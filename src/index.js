import "../styles/Font-Awesome-4.7.0/css/font-awesome.min.css";
import "../styles/bulma.min.css";
import "../styles/main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

Main.embed(document.getElementById("root"));

registerServiceWorker();
