pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  function trimFileProtocol(str) {
    let s = str;
    if (typeof s !== "string")
      s = str.toString();

    if (s.startsWith("file://"))
      return s.slice(7);

    if (s.startsWith("~/"))
      return Quickshell.env("HOME") + s.slice(2);

    return s;
  }

  function fileNameForPath(str) {
    if (typeof str !== "string")
      return "";

    const trimmed = root.trimFileProtocol(str);
    return trimmed.split(/[\\/]/).pop();
  }

  function folderNameForPath(str) {
    if (typeof str !== "string")
      return "";

    const trimmed = root.trimFileProtocol(str);
    const noTrailing = trimmed.endsWith("/") ? trimmed.slice(0, -1) : trimmed;

    if (!noTrailing)
      return "";

    return noTrailing.split(/[\\/]/).pop();
  }

  function trimFileExt(str) {
    if (typeof str !== "string")
      return "";

    const trimmed = root.trimFileProtocol(str);
    const lastDot = trimmed.lastIndexOf(".");

    if (lastDot > -1 && lastDot > trimmed.lastIndexOf("/"))
      return trimmed.slice(0, lastDot);

    return trimmed;
  }

  function parentDirectory(str) {
    if (typeof str !== "string")
      return "";

    const trimmed = root.trimFileProtocol(str);
    const parts = trimmed.split(/[\\/]/);

    if (parts.length <= 1)
      return "";

    parts.pop();
    return parts.join("/");
  }
}
