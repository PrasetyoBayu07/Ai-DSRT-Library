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
