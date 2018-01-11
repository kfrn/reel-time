import "../styles/output.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

Main.embed(document.getElementById("root"));

registerServiceWorker();
