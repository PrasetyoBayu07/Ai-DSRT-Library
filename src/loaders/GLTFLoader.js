export default class GLTFLoader {
  async load(url) {
    const res = await fetch(url);
    const json = await res.json();
    return json;
  }
}
