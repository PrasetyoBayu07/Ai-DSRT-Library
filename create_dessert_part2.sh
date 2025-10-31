#!/usr/bin/env bash
set -euo pipefail

cd DESSERT || { echo "❌ Jalankan Part 1 dulu."; exit 1; }

echo "🧩 Membuat src/core, math, dan utils..."

mkdir -p src/core src/math src/utils

# --- CORE MODULES ---

cat > src/core/Engine.js <<'EOF'
export default class Engine {
  constructor(renderer) {
    this.renderer = renderer;
    this.lastTime = 0;
    this.updatables = [];
  }

  add(object) {
    this.updatables.push(object);
  }

  start() {
    const loop = (time) => {
      const delta = (time - this.lastTime) / 1000;
      this.lastTime = time;
      for (const obj of this.updatables) obj.update?.(delta);
      this.renderer.render();
      requestAnimationFrame(loop);
    };
    requestAnimationFrame(loop);
  }
}
EOF

cat > src/core/Object3D.js <<'EOF'
import Vector3 from "../math/Vector3.js";
import Quaternion from "../math/Quaternion.js";

export default class Object3D {
  constructor() {
    this.position = new Vector3();
    this.rotation = new Quaternion();
    this.scale = new Vector3(1, 1, 1);
    this.children = [];
    this.parent = null;
  }

  add(child) {
    child.parent = this;
    this.children.push(child);
  }

  update(delta) {
    for (const c of this.children) c.update?.(delta);
  }
}
EOF

cat > src/core/Scene.js <<'EOF'
import Object3D from "./Object3D.js";

export default class Scene extends Object3D {
  constructor() {
    super();
    this.background = [0.05, 0.05, 0.05];
  }
}
EOF

cat > src/core/Camera.js <<'EOF'
import Object3D from "./Object3D.js";
export default class Camera extends Object3D {
  constructor(fov = 75, aspect = 1, near = 0.1, far = 1000) {
    super();
    this.fov = fov;
    this.aspect = aspect;
    this.near = near;
    this.far = far;
    this.projectionMatrix = new Float32Array(16);
    this.updateProjectionMatrix();
  }

  updateProjectionMatrix() {
    const f = 1.0 / Math.tan((this.fov * Math.PI) / 360);
    const nf = 1 / (this.near - this.far);
    const out = this.projectionMatrix;
    out[0] = f / this.aspect;
    out[1] = 0;
    out[2] = 0;
    out[3] = 0;
    out[4] = 0;
    out[5] = f;
    out[6] = 0;
    out[7] = 0;
    out[8] = 0;
    out[9] = 0;
    out[10] = (this.far + this.near) * nf;
    out[11] = -1;
    out[12] = 0;
    out[13] = 0;
    out[14] = 2 * this.far * this.near * nf;
    out[15] = 0;
  }
}
EOF

cat > src/core/Renderer.js <<'EOF'
export default class Renderer {
  constructor(canvas) {
    this.canvas = canvas;
    this.gl = canvas.getContext("webgl2");
    if (!this.gl) throw new Error("WebGL2 not supported.");
    this.resize();
    window.addEventListener("resize", () => this.resize());
  }

  resize() {
    const { innerWidth: w, innerHeight: h } = window;
    this.canvas.width = w;
    this.canvas.height = h;
    this.gl.viewport(0, 0, w, h);
  }

  render() {
    const gl = this.gl;
    gl.clearColor(0.1, 0.1, 0.12, 1.0);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  }
}
EOF

# --- MATH MODULES ---

cat > src/math/Vector3.js <<'EOF'
export default class Vector3 {
  constructor(x = 0, y = 0, z = 0) {
    this.x = x; this.y = y; this.z = z;
  }
  set(x, y, z) { this.x = x; this.y = y; this.z = z; return this; }
  add(v) { this.x += v.x; this.y += v.y; this.z += v.z; return this; }
  sub(v) { this.x -= v.x; this.y -= v.y; this.z -= v.z; return this; }
  scale(s) { this.x *= s; this.y *= s; this.z *= s; return this; }
  clone() { return new Vector3(this.x, this.y, this.z); }
}
EOF

cat > src/math/Vector2.js <<'EOF'
export default class Vector2 {
  constructor(x = 0, y = 0) {
    this.x = x; this.y = y;
  }
  set(x, y) { this.x = x; this.y = y; return this; }
  add(v) { this.x += v.x; this.y += v.y; return this; }
  sub(v) { this.x -= v.x; this.y -= v.y; return this; }
  scale(s) { this.x *= s; this.y *= s; return this; }
  clone() { return new Vector2(this.x, this.y); }
}
EOF

cat > src/math/Matrix4.js <<'EOF'
export default class Matrix4 {
  constructor() { this.m = new Float32Array(16); this.identity(); }
  identity() {
    const m = this.m;
    m.set([1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1]);
    return this;
  }
}
EOF

cat > src/math/Quaternion.js <<'EOF'
export default class Quaternion {
  constructor(x = 0, y = 0, z = 0, w = 1) {
    this.x = x; this.y = y; this.z = z; this.w = w;
  }
}
EOF

# --- UTILS ---

cat > src/utils/Logger.js <<'EOF'
export default class Logger {
  static info(...args) { console.log("[INFO]", ...args); }
  static warn(...args) { console.warn("[WARN]", ...args); }
  static error(...args) { console.error("[ERR]", ...args); }
}
EOF

cat > src/utils/MathUtils.js <<'EOF'
export const DEG2RAD = Math.PI / 180;
export const RAD2DEG = 180 / Math.PI;
export const clamp = (v, min, max) => Math.min(max, Math.max(min, v));
EOF

echo "✅ Part 2 selesai — Core, Math, dan Utils sudah dibuat."
echo "➡️ Lanjut ke Part 3 untuk modul renderers, materials, dan loaders."
