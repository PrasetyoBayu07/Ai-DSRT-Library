export default class Vector3 {
  constructor(x?: number, y?: number, z?: number);
  x: number;
  y: number;
  z: number;
  set(x: number, y: number, z: number): Vector3;
  add(v: Vector3): Vector3;
  sub(v: Vector3): Vector3;
  scale(s: number): Vector3;
  clone(): Vector3;
}
