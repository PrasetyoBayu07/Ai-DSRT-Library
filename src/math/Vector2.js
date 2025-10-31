export default class Vector2 {
  constructor(x = 0, y = 0) {
    this.x = x; this.y = y;
  }
  set(x, y) { this.x = x; this.y = y; return this; }
  add(v) { this.x += v.x; this.y += v.y; return this; }
  sub(v) { this.x -= v.x; this.y -= v.y; return this; }
  scale(s) { this.x *= s; this.y *= s; return this; }
  clone() { return new Vector2(this.x, this.y); }
}
