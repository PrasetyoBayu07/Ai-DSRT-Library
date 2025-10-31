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
