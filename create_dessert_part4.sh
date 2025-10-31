#!/usr/bin/env bash
set -euo pipefail

cd DESSERT || { echo "❌ Jalankan Part 1-3 dulu."; exit 1; }

echo "📚 Membuat examples, docs, tools, dan types..."

mkdir -p examples docs tools types

# --- EXAMPLES ---

cat > examples/scene-basic.js <<'EOF'
import WebGLRenderer from "../src/renderers/WebGLRenderer.js";
import Scene from "../src/core/Scene.js";
import Camera from "../src/core/Camera.js";
import Engine from "../src/core/Engine.js";
import OrbitControls from "../src/controls/OrbitControls.js";

const canvas = document.getElementById("app");
const renderer = new WebGLRenderer(canvas);
const scene = new Scene();
const camera = new Camera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
camera.position.z = 5;

const controls = new OrbitControls(camera, canvas);
const engine = new Engine(renderer);
engine.add(scene);

engine.start();
EOF

cat > examples/scene-pbr.js <<'EOF'
import PBRMaterial from "../src/materials/PBRMaterial.js";
import Logger from "../src/utils/Logger.js";
Logger.info("Scene PBR ready - placeholder for advanced rendering");
EOF

cat > examples/scene-gltf.js <<'EOF'
import GLTFLoader from "../src/loaders/GLTFLoader.js";
import Logger from "../src/utils/Logger.js";

const loader = new GLTFLoader();
loader.load("../assets/model.gltf").then((json) => {
  Logger.info("GLTF Loaded:", json);
});
EOF

cat > examples/scene-animation.js <<'EOF'
import Logger from "../src/utils/Logger.js";
Logger.info("Animation demo placeholder - coming soon!");
EOF

# --- DOCS ---

mkdir -p docs/api
cat > docs/index.md <<'EOF'
# 🍨 DESSERT Documentation

DESSERT (AI-DSRT-Library) is a modular WebGL engine.
Below are modules:

- **Core**: Engine, Object3D, Scene, Camera
- **Renderers**: WebGLRenderer, WebGLUtils
- **Materials**: Basic, PBR
- **Math**: Vector2, Vector3, Matrix4
EOF

cat > docs/api/core.md <<'EOF'
# Core API

### Engine
Manages render loop and updates.

### Object3D
Base class for all objects in the scene.

### Camera
Projection and view matrix utilities.
EOF

# --- TOOLS ---

cat > tools/build-docs.js <<'EOF'
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
EOF

# --- TYPES (.d.ts) ---

mkdir -p types/core types/math types/renderers

cat > types/index.d.ts <<'EOF'
export * from "./core/Engine";
export * from "./core/Object3D";
export * from "./core/Scene";
export * from "./core/Camera";
export * from "./renderers/WebGLRenderer";
export * from "./math/Vector3";
EOF

cat > types/core/Engine.d.ts <<'EOF'
export default class Engine {
  constructor(renderer: any);
  add(object: any): void;
  start(): void;
}
EOF

cat > types/core/Object3D.d.ts <<'EOF'
import Vector3 from "../math/Vector3";
import Quaternion from "../math/Quaternion";
export default class Object3D {
  position: Vector3;
  rotation: Quaternion;
  scale: Vector3;
  children: Object3D[];
  parent: Object3D | null;
  add(child: Object3D): void;
  update(delta: number): void;
}
EOF

cat > types/core/Scene.d.ts <<'EOF'
import Object3D from "./Object3D";
export default class Scene extends Object3D {
  background: [number, number, number];
}
EOF

cat > types/core/Camera.d.ts <<'EOF'
import Object3D from "./Object3D";
export default class Camera extends Object3D {
  fov: number;
  aspect: number;
  near: number;
  far: number;
  projectionMatrix: Float32Array;
  updateProjectionMatrix(): void;
}
EOF

cat > types/renderers/WebGLRenderer.d.ts <<'EOF'
export default class WebGLRenderer {
  canvas: HTMLCanvasElement;
  gl: WebGL2RenderingContext;
  setClearColor(r: number, g: number, b: number, a?: number): void;
  render(scene?: any, camera?: any): void;
}
EOF

cat > types/math/Vector3.d.ts <<'EOF'
export default class Vector3 {
  constructor(x?: number, y?: number, z?: number);
  x: number;
  y: number;
  z: number;
  set(x: number, y: number, z: number): Vector3;
  add(v: Vector3): Vector3;
  sub(v: Vector3): Vector3;
  scale(s: number): Vector3;
  clone(): Vector3;
}
EOF

echo "✅ Part 4 selesai — examples, docs, tools, dan types sudah dibuat."
echo "➡️ Lanjut ke Part 5 untuk auto npm install, git init, dan push ke GitHub."
