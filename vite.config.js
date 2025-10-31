import { defineConfig } from "vite";
export default defineConfig({
  root: ".",
  publicDir: "assets",
  build: {
    outDir: "dist",
    lib: {
      entry: "src/index.js",
      name: "DESSERT",
      fileName: (format) => `dessert.${format}.js`
    },
    rollupOptions: { external: [] }
  },
  server: { port: 5173, open: "examples/index.html" }
});
