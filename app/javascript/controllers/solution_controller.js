import { Controller } from "@hotwired/stimulus"
const codemirror = require("../codemirror/codemirror");

// Connects to data-controller="solution"
export default class extends Controller {

  connect() {
    let playerOneSumbit = document.getElementById("playerOneSubmit")
    let playerTwoSumbit = document.getElementById("playerTwoSubmit")

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

    playerOneSumbit.addEventListener("click", function(){
      let text = editor_one.getValue()
      console.log(text)
    })

    playerTwoSumbit.addEventListener("click", function(){
      let text = editor_two.getValue()
      console.log(text)
    })
  }

  

}
