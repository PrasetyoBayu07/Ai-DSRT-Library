export default class Engine {
  constructor(renderer) {
    this.renderer = renderer;
    this.lastTime = 0;
    this.updatables = [];
  }

  add(object) {
    this.updatables.push(object);
  }

  start() {
    const loop = (time) => {
      const delta = (time - this.lastTime) / 1000;
      this.lastTime = time;
      for (const obj of this.updatables) obj.update?.(delta);
      this.renderer.render();
      requestAnimationFrame(loop);
    };
    requestAnimationFrame(loop);
  }
}
