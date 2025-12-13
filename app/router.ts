import EmberRouter from "@embroider/router";
import config from "spanish-flashcards/config/environment";

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route("quiz", { path: "quiz/:kind" }, function () {
    this.route("card", { path: ":cardNumber" });
  });
});
