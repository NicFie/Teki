import { Controller } from "@hotwired/stimulus"
const codemirror = require("../codemirror/codemirror");

// Connects to data-controller="solution"
export default class extends Controller {
  static values = { gameId: Number }
  static targets = ["editorone", "editortwo", "output"]

  initialize() {
     this.editor_one = codemirror.fromTextArea(
      this.editoroneTarget, {
        mode: "ruby",
        theme: "dracula",
        lineNumbers: true
      }
    );

    this.editor_two = codemirror.fromTextArea(
      this.editortwoTarget, {
        mode: "ruby",
        theme: "dracula",
        lineNumbers: true
      }
    );

    // const initialDefaultMethod = this.editor_one.getValue()

  }

  connect() {
  }

  playerOneSubmission() {
    this.sendCode(this.editor_one.getValue());
  }

  playerTwoSubmission() {
    this.sendCode(this.editor_two.getValue());
  }

  clearPlayerOneSubmission(){
    this.editor_one.getDoc().setValue("initialDefaultMethod");
  }

  clearPlayerTwoSubmission(){
    this.editor_two.getDoc().setValue("initialDefaultMethod");
  }

  sendCode(code) {
    const token = document.getElementsByName("csrf-token")[0].content
    fetch(`/games/${this.gameIdValue}/game_test`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ player_one_code: code }),
    })
    .then((response) => response.json())
    .then((data) => this.outputTarget.innerHTML = data)
  }

}
