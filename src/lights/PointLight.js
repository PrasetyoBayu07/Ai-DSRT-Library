export default class PointLight {
  constructor(color = [1, 1, 1], intensity = 1, position = [0, 0, 0]) {
    this.color = color;
    this.intensity = intensity;
    this.position = position;
  }
}
