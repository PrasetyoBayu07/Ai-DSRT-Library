export default class Material {
  constructor({ color = [1, 1, 1], shader = null } = {}) {
    this.color = color;
    this.shader = shader;
  }
}
