export default class WebGLRenderer {
  canvas: HTMLCanvasElement;
  gl: WebGL2RenderingContext;
  setClearColor(r: number, g: number, b: number, a?: number): void;
  render(scene?: any, camera?: any): void;
}
