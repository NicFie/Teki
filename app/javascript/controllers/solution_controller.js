import { Controller } from "@hotwired/stimulus"
const codemirror = require("../codemirror/codemirror");

// Connects to data-controller="solution"
export default class extends Controller {
  static values = { gameId: Number }

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
      let playerOneSubmission = editor_one.getValue()
      // console.log(playerOneSubmission)
      this.sendCode(playerOneSubmission)
    });

    playerTwoSumbit.addEventListener("click", function(){
      let playerTwoSubmission = editor_two.getValue()
      console.log(playerTwoSubmission)
    })

  }

  sendCode(code) {
    fetch(`/games/${this.gameIdValue}/game_test`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": Rails.csrfToken(),
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ code: code }),
    })
  }

}
