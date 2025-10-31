#!/usr/bin/env bash
set -euo pipefail

cd DESSERT || { echo "❌ Jalankan Part 1 dan 2 dulu."; exit 1; }

echo "🎨 Membuat renderers, materials, loaders, lights, controls..."

mkdir -p src/renderers src/materials src/loaders src/lights src/controls

# --- RENDERERS ---

cat > src/renderers/WebGLRenderer.js <<'EOF'
import Logger from "../utils/Logger.js";

export default class WebGLRenderer {
  constructor(canvas) {
    this.canvas = canvas;
    this.gl = canvas.getContext("webgl2", { antialias: true });
    if (!this.gl) throw new Error("WebGL2 not supported");
    this.clearColor = [0.1, 0.1, 0.1, 1];
    window.addEventListener("resize", () => this.resize());
    this.resize();
  }

  resize() {
    const gl = this.gl;
    this.canvas.width = window.innerWidth;
    this.canvas.height = window.innerHeight;
    gl.viewport(0, 0, this.canvas.width, this.canvas.height);
  }

  setClearColor(r, g, b, a = 1.0) {
    this.clearColor = [r, g, b, a];
  }

  render(scene, camera) {
    const gl = this.gl;
    gl.clearColor(...this.clearColor);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    Logger.info("Rendering frame...");
  }
}
EOF

cat > src/renderers/WebGLUtils.js <<'EOF'
export const createShader = (gl, type, source) => {
  const shader = gl.createShader(type);
  gl.shaderSource(shader, source);
  gl.compileShader(shader);
  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS))
    throw new Error(gl.getShaderInfoLog(shader));
  return shader;
};

export const createProgram = (gl, vsSrc, fsSrc) => {
  const program = gl.createProgram();
  const vs = createShader(gl, gl.VERTEX_SHADER, vsSrc);
  const fs = createShader(gl, gl.FRAGMENT_SHADER, fsSrc);
  gl.attachShader(program, vs);
  gl.attachShader(program, fs);
  gl.linkProgram(program);
  if (!gl.getProgramParameter(program, gl.LINK_STATUS))
    throw new Error(gl.getProgramInfoLog(program));
  return program;
};
EOF

# --- MATERIALS ---

cat > src/materials/Material.js <<'EOF'
export default class Material {
  constructor({ color = [1, 1, 1], shader = null } = {}) {
    this.color = color;
    this.shader = shader;
  }
}
EOF

cat > src/materials/MeshBasicMaterial.js <<'EOF'
import Material from "./Material.js";

export default class MeshBasicMaterial extends Material {
  constructor(params = {}) {
    super(params);
  }
}
EOF

cat > src/materials/PBRMaterial.js <<'EOF'
import Material from "./Material.js";

export default class PBRMaterial extends Material {
  constructor({
    albedo = [1, 1, 1],
    metalness = 0.5,
    roughness = 0.5
  } = {}) {
    super();
    this.albedo = albedo;
    this.metalness = metalness;
    this.roughness = roughness;
  }
}
EOF

# --- LOADERS ---

cat > src/loaders/OBJLoader.js <<'EOF'
export default class OBJLoader {
  static parse(text) {
    const vertices = [];
    const lines = text.split("\\n");
    for (const line of lines) {
      const parts = line.trim().split(" ");
      if (parts[0] === "v") {
        vertices.push(parts.slice(1).map(Number));
      }
    }
    return { vertices };
  }
}
EOF

cat > src/loaders/GLTFLoader.js <<'EOF'
export default class GLTFLoader {
  async load(url) {
    const res = await fetch(url);
    const json = await res.json();
    return json;
  }
}
EOF

# --- LIGHTS ---

cat > src/lights/DirectionalLight.js <<'EOF'
export default class DirectionalLight {
  constructor(color = [1, 1, 1], intensity = 1) {
    this.color = color;
    this.intensity = intensity;
    this.direction = [0, -1, 0];
  }
}
EOF

cat > src/lights/PointLight.js <<'EOF'
export default class PointLight {
  constructor(color = [1, 1, 1], intensity = 1, position = [0, 0, 0]) {
    this.color = color;
    this.intensity = intensity;
    this.position = position;
  }
}
EOF

# --- CONTROLS ---

cat > src/controls/OrbitControls.js <<'EOF'
export default class OrbitControls {
  constructor(camera, canvas) {
    this.camera = camera;
    this.canvas = canvas;
    this.distance = 5;
    this.rotation = { x: 0, y: 0 };
    this.#init();
  }

  #init() {
    let dragging = false, lastX = 0, lastY = 0;
    this.canvas.addEventListener("mousedown", e => {
      dragging = true; lastX = e.clientX; lastY = e.clientY;
    });
    this.canvas.addEventListener("mouseup", () => (dragging = false));
    this.canvas.addEventListener("mousemove", e => {
      if (!dragging) return;
      const dx = e.clientX - lastX, dy = e.clientY - lastY;
      this.rotation.x += dy * 0.005;
      this.rotation.y += dx * 0.005;
      lastX = e.clientX; lastY = e.clientY;
    });
  }
}
EOF

echo "✅ Part 3 selesai — renderers, materials, loaders, lights, dan controls sudah dibuat."
echo "➡️ Lanjut ke Part 4 untuk membuat examples, docs, tools, dan types."
