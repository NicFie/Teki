import { Controller } from "@hotwired/stimulus"
const codemirror = require("../codemirror/codemirror");

// Connects to data-controller="solution"
export default class extends Controller {
  static values = {
    gameRoundMethod: String,
    gameId: Number,
    gamePlayerOne: Number,
    gamePlayerTwo: Number,
    userId: Number
  }
  static targets = ["editorone", "editortwo", "output"]

  initialize() {
    console.log(`player one user:${this.gamePlayerOneValue}`);
    console.log(`player two user:${this.gamePlayerTwoValue}`);
    console.log(`current user:${this.userIdValue}`);

    let playerOneTheme = 0
    let playerTwoTheme = 0

    if(this.gamePlayerOneValue == this.userIdValue) {
      playerOneTheme = "dracula";
      playerTwoTheme = "dracula_blurred";
    } else if(this.gamePlayerTwoValue == this.userIdValue) {
      playerOneTheme = "dracula_blurred";
      playerTwoTheme = "dracula";
    }

    this.editor_one = codemirror.fromTextArea(
      this.editoroneTarget, {
        mode: "ruby",
        theme: playerOneTheme,
        lineNumbers: true
      }
    );

    this.editor_two = codemirror.fromTextArea(
      this.editortwoTarget, {
        mode: "ruby",
        theme: playerTwoTheme,
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
    this.editor_one.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
  }
  clearPlayerTwoSubmission(){
    this.editor_two.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
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
