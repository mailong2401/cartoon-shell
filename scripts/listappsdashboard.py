#!/usr/bin/env python3
"""
listapps_icons_exec_only.py - optimized version with only icon paths and exec

Features:
- Parse only [Desktop Entry] section
- Get only iconPath and exec fields
- No sorting for speed optimization
- Filter out entries without iconPath
"""
import os
import sys
import json
import hashlib
import pickle
import time
import re
from pathlib import Path

CACHE_FILE = Path.home() / ".cache" / "listapps_icon_exec_cache.pkl"
CACHE_FILE.parent.mkdir(parents=True, exist_ok=True)

DESKTOP_DIRS = [
    "/usr/share/applications",
    "/usr/local/share/applications",
    "/var/lib/flatpak/exports/share/applications/",
    os.path.expanduser("~/.local/share/applications")
]

# Essential icon directories
ICON_DIRS = [
    "/usr/share/icons/Papirus",
    "/usr/share/icons/hicolor",
]

FIELD_CODE_RE = re.compile(r"%[fFuUdDinkcmv]")  # desktop file field codes

def get_cache_key():
    """Generate cache key based on directory modification times"""
    timestamps = []
    for directory in DESKTOP_DIRS:
        path = Path(directory)
        if path.exists():
            try:
                timestamps.append(str(path.stat().st_mtime))
            except:
                pass
    return hashlib.md5(''.join(timestamps).encode()).hexdigest()

def load_cache():
    """Load from cache if valid"""
    if CACHE_FILE.exists():
        try:
            with open(CACHE_FILE, 'rb') as f:
                cache_data = pickle.load(f)
                if cache_data.get('key') == get_cache_key():
                    return cache_data.get('apps', [])
        except:
            pass
    return None

def save_cache(apps):
    """Save to cache"""
    try:
        cache_data = {
            'key': get_cache_key(),
            'apps': apps,
            'timestamp': time.time()
        }
        with open(CACHE_FILE, 'wb') as f:
            pickle.dump(cache_data, f)
    except:
        pass

def find_icon_simple(icon_name):
    """
    Simple icon search - only find if exists in common locations
    Returns absolute path or empty string
    """
    if not icon_name:
        return ""
    
    # If already absolute path
    if os.path.isabs(icon_name) and os.path.exists(icon_name):
        return icon_name
    
    # Common icon extensions to check
    extensions = ['.svg', '.png', '.xpm', '.jpg', '.jpeg']
    
    # Check common icon directories
    for icon_dir in ICON_DIRS:
        path = Path(icon_dir)
        if not path.exists():
            continue
        
        # First check in scalable (SVG) - best quality
        svg_path = path / "scalable" / "apps" / f"{icon_name}.svg"
        if svg_path.exists():
            return str(svg_path)
        
        # Check in common sizes (from large to small)
        for size in ['512x512', '256x256', '128x128', '96x96', '64x64', '48x48', '32x32', '24x24', '22x22', '16x16']:
            png_path = path / size / "apps" / f"{icon_name}.png"
            if png_path.exists():
                return str(png_path)
            
            svg_path = path / size / "apps" / f"{icon_name}.svg"
            if svg_path.exists():
                return str(svg_path)
        
        # Check directly in icons directory
        for ext in extensions:
            icon_path = path / f"{icon_name}{ext}"
            if icon_path.exists():
                return str(icon_path)
    
    # Check /usr/share/pixmaps
    pixmaps = Path("/usr/share/pixmaps")
    if pixmaps.exists():
        for ext in extensions:
            icon_path = pixmaps / f"{icon_name}{ext}"
            if icon_path.exists():
                return str(icon_path)
    
    return ""

def parse_desktop_file_simple(filepath):
    """
    Parse desktop file and return only iconPath and exec
    """
    try:
        # Quick check for NoDisplay or Hidden
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read(2000)  # Read only first 2000 chars for speed
        
        if 'NoDisplay=true' in content or 'Hidden=true' in content:
            return None
        
        # Simple parsing for [Desktop Entry] section
        lines = content.split('\n')
        in_desktop_entry = False
        data = {}
        
        for line in lines:
            line = line.strip()
            if not line:
                continue
            
            if line.startswith('[') and line.endswith(']'):
                section = line[1:-1].strip()
                in_desktop_entry = (section == 'Desktop Entry')
                if not in_desktop_entry and data:  # Stop after Desktop Entry
                    break
                continue
            
            if in_desktop_entry and '=' in line:
                key, value = line.split('=', 1)
                key = key.strip()
                value = value.strip()
                
                if key in ['Exec', 'Icon']:
                    data[key] = value
        
        if not data.get('Exec'):
            return None
        
        # Clean exec command
        exec_cmd = FIELD_CODE_RE.sub('', data.get('Exec', '')).strip()
        exec_cmd = re.sub(r'\s+', ' ', exec_cmd)
        
        # Skip if exec is empty after cleaning
        if not exec_cmd:
            return None
        
        # Find icon
        icon_name = data.get('Icon', '')
        icon_path = find_icon_simple(icon_name)

        if not icon_path:
            return None
        
        # Skip if no icon found
        if not icon_path:
            return None
        
        return {
            "exec": exec_cmd,
            "iconPath": icon_path
        }
    except:
        return None

def scan_desktop_files_fast():
    """Scan desktop files without sorting for maximum speed"""
    cached = load_cache()
    if cached is not None:
        return cached
    
    apps = []
    seen_execs = set()
    
    for directory in DESKTOP_DIRS:
        path = Path(directory)
        if not path.exists():
            continue
        
        try:
            for entry in os.scandir(directory):
                if not entry.name.endswith('.desktop'):
                    continue
                
                app = parse_desktop_file_simple(entry.path)
                if not app:
                    continue
                
                # Simple deduplication by exec command
                exec_cmd = app.get('exec', '')
                if exec_cmd and exec_cmd not in seen_execs:
                    seen_execs.add(exec_cmd)
                    apps.append(app)
        except:
            continue
    
    save_cache(apps)
    return apps

if __name__ == "__main__":
    try:
        apps_list = scan_desktop_files_fast()
        print(json.dumps(apps_list, ensure_ascii=False, indent=2))
    except Exception as e:
        print(json.dumps([]))
        sys.exit(1)
