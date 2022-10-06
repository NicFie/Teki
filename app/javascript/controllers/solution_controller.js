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
  }

  connect() {
  }

  playerOneSubmission() {
    this.sendCode(this.editor_one.getValue());
  }

  playerTwoSubmission() {
    console.log(this.editor_two.getValue());
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
      body: JSON.stringify({ round_count: code }),
    })
    .then((response) => response.json())
    .then((data) => this.outputTarget.innerHTML = data)
  }
}
