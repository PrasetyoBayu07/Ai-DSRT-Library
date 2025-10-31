export default class OrbitControls {
  constructor(camera, canvas) {
    this.camera = camera;
    this.canvas = canvas;
    this.distance = 5;
    this.rotation = { x: 0, y: 0 };
    this.#init();
  }

  #init() {
    let dragging = false, lastX = 0, lastY = 0;
    this.canvas.addEventListener("mousedown", e => {
      dragging = true; lastX = e.clientX; lastY = e.clientY;
    });
    this.canvas.addEventListener("mouseup", () => (dragging = false));
    this.canvas.addEventListener("mousemove", e => {
      if (!dragging) return;
      const dx = e.clientX - lastX, dy = e.clientY - lastY;
      this.rotation.x += dy * 0.005;
      this.rotation.y += dx * 0.005;
      lastX = e.clientX; lastY = e.clientY;
    });
  }
}
