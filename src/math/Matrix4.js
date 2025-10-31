export default class Matrix4 {
  constructor() { this.m = new Float32Array(16); this.identity(); }
  identity() {
    const m = this.m;
    m.set([1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1]);
    return this;
  }
}
