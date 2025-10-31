export default class OBJLoader {
  static parse(text) {
    const vertices = [];
    const lines = text.split("\\n");
    for (const line of lines) {
      const parts = line.trim().split(" ");
      if (parts[0] === "v") {
        vertices.push(parts.slice(1).map(Number));
      }
    }
    return { vertices };
  }
}
