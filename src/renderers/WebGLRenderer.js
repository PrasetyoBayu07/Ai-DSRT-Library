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
