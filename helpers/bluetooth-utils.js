.pragma library

// ==============================
// Address helpers
// ==============================

function macFromDevice(dev) {
  if (!dev) return "";
  if (dev.address && dev.address.length > 0) return dev.address;
  if (dev.nativePath && dev.nativePath.indexOf("/dev_") !== -1)
    return dev.nativePath.split("dev_")[1].split("_").join(":");
  return "";
}

function deviceKey(dev) {
  if (!dev) return "";
  if (dev.address && dev.address.length > 0) return dev.address.toUpperCase();
  if (dev.nativePath && dev.nativePath.length > 0) return dev.nativePath;
  if (dev.devicePath && dev.devicePath.length > 0) return dev.devicePath;
  return (dev.name || dev.deviceName || "") + "|" + (dev.icon || "");
}

function dedupeDevices(list) {
  if (!list || list.length === 0) return [];
  const seen = {};
  const out = [];
  for (let i = 0; i < list.length; ++i) {
    const d = list[i];
    if (!d) continue;
    const k = deviceKey(d);
    if (k && !seen[k]) {
      seen[k] = true;
      out.push(d);
    }
  }
  return out;
}

// ==============================
// RSSI parsing
// ==============================

function parseRssiOutput(text) {
  try {
    text = text || "";

    const mParen = text.match(/\(\s*(-?\d+)\s*(?:d?b?m?)?\s*\)/i);
    if (mParen && mParen.length > 1) return Number(mParen[1]);

    const mDec = text.match(/RSSI:\s*(-?\d+)/i);
    if (mDec && mDec.length > 1) return Number(mDec[1]);

    const mHex = text.match(/RSSI:\s*0x([0-9a-fA-F]+)/i);
    if (mHex && mHex.length > 1) {
      let v = parseInt(mHex[1], 16);
      if (v >= 0x80000000) v -= 0x100000000;
      else if (v >= 0x8000) v -= 0x10000;
      else if (v >= 0x80) v -= 0x100;
      return v;
    }
  } catch (e) {}

  return null;
}

function dbmToPercent(dbm) {
  if (dbm === null || dbm === undefined || isNaN(dbm)) return null;
  const pct = Math.round((Number(dbm) + 100) * 2);
  if (isNaN(pct)) return null;
  return Math.max(0, Math.min(100, pct));
}

// ==============================
// Signal helpers
// ==============================

function signalPercent(device, cache) {
  if (!device) return null;

  try {
    const addr = macFromDevice(device);
    if (addr && cache && cache[addr] !== undefined) {
      const cached = Number(cache[addr]) | 0;
      return Math.max(0, Math.min(100, cached));
    }
  } catch (e) {}

  const s = device.signalStrength;
  if (s === undefined || s <= 0) return null;

  const p = Number(s) | 0;
  return Math.max(0, Math.min(100, p));
}

function signalIcon(percent) {
  if (percent === null) return "signal_cellular_off";
  if (percent >= 80) return "signal_cellular_4_bar";
  if (percent >= 60) return "signal_cellular_3_bar";
  if (percent >= 40) return "signal_cellular_2_bar";
  if (percent >= 20) return "signal_cellular_1_bar";
  return "signal_cellular_0_bar";
}

// ==============================
// Device icon mapping (Material)
// ==============================

function deviceIcon(name, icon) {
  const s1 = (name || "").toLowerCase();
  const s2 = (icon || "").toLowerCase();

  const displayHints = [
    "display", "tv", "monitor", "projector",
    "screen", "chromecast", "cast"
  ];

  for (let i = 0; i < displayHints.length; i++) {
    if (s2.indexOf(displayHints[i]) !== -1)
      return "tv";
  }

  const tests = [
    [["controller", "gamepad"], "sports_esports"],
    [["microphone"], "mic"],
    [["pod", "bud", "earbud"], "earbuds"],
    [["headset"], "headset"],
    [["headphone"], "headphones"],
    [["mouse"], "mouse"],
    [["keyboard"], "keyboard"],
    [["watch"], "watch"],
    [["display", "tv", "monitor", "projector", "screen", "chromecast", "cast"], "tv"],
    [["speaker", "audio", "sound"], "speaker"],
    [["phone", "iphone", "android", "samsung"], "smartphone"]
  ];

  for (let i = 0; i < tests.length; i++) {
    const keys = tests[i][0];
    const out = tests[i][1];
    for (let j = 0; j < keys.length; j++) {
      const k = keys[j];
      if (s1.indexOf(k) !== -1 || s2.indexOf(k) !== -1)
        return out;
    }
  }

  return "bluetooth";
}

// ==============================
// Battery helper
// ==============================

function batteryPercent(device) {
  if (!device || !device.batteryAvailable || device.battery === undefined)
    return null;

  const val = Math.round(Number(device.battery) * 100);
  if (isNaN(val)) return null;

  return Math.max(0, Math.min(100, val));
}
