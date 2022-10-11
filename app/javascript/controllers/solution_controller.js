import { Controller } from "@hotwired/stimulus"
const codemirror = require("../codemirror/codemirror");

// Connects to data-controller="solution"
export default class extends Controller {
  static values = {
    gameRoundMethod: String,
    gameId: Number
  }
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

    this.editor_one.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
    this.editor_two.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));

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
    this.editor_one.setValue(this.gameRoundMethodValue);
  }

  clearPlayerTwoSubmission(){
    this.editor_two.setValue(this.gameRoundMethodValue);
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
