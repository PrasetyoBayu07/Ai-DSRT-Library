import Vector3 from "../math/Vector3";
import Quaternion from "../math/Quaternion";
export default class Object3D {
  position: Vector3;
  rotation: Quaternion;
  scale: Vector3;
  children: Object3D[];
  parent: Object3D | null;
  add(child: Object3D): void;
  update(delta: number): void;
}
