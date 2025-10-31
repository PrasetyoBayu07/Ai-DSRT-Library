import Object3D from "./Object3D.js";

export default class Scene extends Object3D {
  constructor() {
    super();
    this.background = [0.05, 0.05, 0.05];
  }
}
