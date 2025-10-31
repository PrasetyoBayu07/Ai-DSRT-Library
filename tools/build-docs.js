import fs from "fs";
import path from "path";
console.log("🛠️ Generating documentation...");
const srcDir = "src";
const files = [];

function scan(dir) {
  for (const f of fs.readdirSync(dir)) {
    const full = path.join(dir, f);
    if (fs.statSync(full).isDirectory()) scan(full);
    else if (f.endsWith(".js")) files.push(full);
  }
}
scan(srcDir);
fs.writeFileSync("docs/api/files.json", JSON.stringify(files, null, 2));
console.log("✅ Docs built:", files.length, "files indexed.");
