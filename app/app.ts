import Application from 'ember-strict-application-resolver';
import setupInspector from "@embroider/legacy-inspector-support/ember-source-4.12";

export default class App extends Application {
  inspector = setupInspector(this);
  modules = {
    ...import.meta.glob('./router.*', { eager: true }),
    ...import.meta.glob('./templates/**/*', { eager: true }),
    ...import.meta.glob('./services/**/*', { eager: true }),
    ...import.meta.glob('./routes/**/*', { eager: true }),
  }
}
