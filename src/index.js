import "../styles/Font-Awesome-4.7.0/css/font-awesome.min.css";
import "../styles/bulma.min.css";
import "../styles/main.css";
import { Elm } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";
import * as fileSaver from "file-saver";
import * as stringify from "../node_modules/csv-stringify/lib/es5/index";

const app = Elm.Main.init({
  node: document.getElementById("root")
});

registerServiceWorker();

app.ports.exportData.subscribe(content => {
  const fileName = "reel-time_summary.csv";

  stringify(content, function(err, output) {
    const blob = new Blob([output], {
      type: "data:text/csv;charset=utf-8"
    });

    fileSaver.saveAs(blob, fileName);
  });
});
