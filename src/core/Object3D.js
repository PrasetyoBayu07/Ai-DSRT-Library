import Vector3 from "../math/Vector3.js";
import Quaternion from "../math/Quaternion.js";

export default class Object3D {
  constructor() {
    this.position = new Vector3();
    this.rotation = new Quaternion();
    this.scale = new Vector3(1, 1, 1);
    this.children = [];
    this.parent = null;
  }

  add(child) {
    child.parent = this;
    this.children.push(child);
  }

  update(delta) {
    for (const c of this.children) c.update?.(delta);
  }
}
