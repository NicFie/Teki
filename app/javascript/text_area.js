const codemirror = require("./codemirror");

let editor = codemirror.fromTextArea(
  document.getElementById("editor"), {
    mode: "ruby",
    theme: "dracula",
    lineNumbers: true
  }
);
