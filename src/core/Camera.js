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
