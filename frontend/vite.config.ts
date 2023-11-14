import { defineConfig } from "vite";
import preact from "@preact/preset-vite";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [preact()],
  build: {
    rollupOptions: {
      output: {
        dir: "dist/",
        entryFileNames: "app-[name].js",
        assetFileNames: "app-[name].css",
        chunkFileNames: "chunk-[name].js",
        manualChunks: undefined,
      },
    },
  },
});
