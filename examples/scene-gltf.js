import GLTFLoader from "../src/loaders/GLTFLoader.js";
import Logger from "../src/utils/Logger.js";

const loader = new GLTFLoader();
loader.load("../assets/model.gltf").then((json) => {
  Logger.info("GLTF Loaded:", json);
});
