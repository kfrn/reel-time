import "../styles/Font-Awesome-4.7.0/css/font-awesome.min.css";
import "../styles/bulma.min.css";
import "../styles/main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";
import * as fileSaver from "file-saver";

const app = Main.embed(document.getElementById("root"));

registerServiceWorker();

app.ports.exportData.subscribe(content => {
  const fileName = "reel-time_summary.csv";

  const blob = new Blob([content], {
    type: "data:text/csv;charset=utf-8"
  });

  fileSaver.saveAs(blob, fileName);
});
