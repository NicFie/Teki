const codemirror = require("./codemirror");


// document.onload(editor);

let editor_one = codemirror.fromTextArea(
  document.getElementById("editor-one"), {
    mode: "ruby",
    theme: "dracula",
    lineNumbers: true
  }
);
let editor_two = codemirror.fromTextArea(
  document.getElementById("editor-two"), {
    mode: "ruby",
    theme: "dracula",
    lineNumbers: true
  }
);
