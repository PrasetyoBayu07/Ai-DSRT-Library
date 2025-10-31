export default class DirectionalLight {
  constructor(color = [1, 1, 1], intensity = 1) {
    this.color = color;
    this.intensity = intensity;
    this.direction = [0, -1, 0];
  }
}
