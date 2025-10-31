import Object3D from "./Object3D";
export default class Camera extends Object3D {
  fov: number;
  aspect: number;
  near: number;
  far: number;
  projectionMatrix: Float32Array;
  updateProjectionMatrix(): void;
}
