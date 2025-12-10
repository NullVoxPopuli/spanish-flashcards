import { defineConfig } from "vite";
import { extensions, ember } from "@embroider/vite";
import { babel } from "@rollup/plugin-babel";
import { scopedCSS } from 'ember-scoped-css/vite';

export default defineConfig({
  plugins: [
    scopedCSS({ additionalRoots: ['templates']}),

    ember(),
    // extra plugins here
    babel({
      babelHelpers: "runtime",
      extensions,
    }),
  ],
});
