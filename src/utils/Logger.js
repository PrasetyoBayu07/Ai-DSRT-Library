export default class Logger {
  static info(...args) { console.log("[INFO]", ...args); }
  static warn(...args) { console.warn("[WARN]", ...args); }
  static error(...args) { console.error("[ERR]", ...args); }
}
