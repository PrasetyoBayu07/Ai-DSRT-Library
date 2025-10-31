import WebGLRenderer from "../src/renderers/WebGLRenderer.js";
import Scene from "../src/core/Scene.js";
import Camera from "../src/core/Camera.js";
import Engine from "../src/core/Engine.js";
import OrbitControls from "../src/controls/OrbitControls.js";

const canvas = document.getElementById("app");
const renderer = new WebGLRenderer(canvas);
const scene = new Scene();
const camera = new Camera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
camera.position.z = 5;

const controls = new OrbitControls(camera, canvas);
const engine = new Engine(renderer);
engine.add(scene);

engine.start();
