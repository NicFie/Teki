import { Controller } from "@hotwired/stimulus"
const codemirror = require("../codemirror/codemirror");

// Connects to data-controller="code"
export default class extends Controller {
  static values = {
    userId: Number,
    playerOneId: Number,
    playerTwoId: Number,
    gameRoundMethod: String
  }

  static targets = [
    "editorone",
    "editortwo",
  ]

  initialize() {
    // let playerOneTheme = "dracula"
    // let playerTwoTheme = "dracula_blurred"
    // let playerOneRead = ''
    // let playerTwoRead = nocursor
    this.token = document.getElementsByName("csrf-token")[0].content

    this.editor_one_code = ''
    // if(this.playerOneIdValue == this.userIdValue) {
    //   playerOneTheme = "dracula";
    //   playerTwoTheme = "dracula_blurred";
    //   playerTwoRead = "nocursor";
    // } else if(this.playerTwoIdValue == this.userIdValue) {
    //   playerOneTheme = "dracula_blurred";
    //   playerTwoTheme = "dracula";
    //   playerOneRead = "nocursor";
    // }
    // Generating codemirror windows
    this.editor_one = codemirror.fromTextArea(
      this.editoroneTarget, {
        mode: "ruby",
        theme: "dracula",
        lineNumbers: true,
        // readOnly: playerOneRead
      }
    );

    this.editor_two = codemirror.fromTextArea(
      this.editortwoTarget, {
        mode: "ruby",
        theme: "dracula",
        lineNumbers: true,
        // readOnly: playerTwoRead,
      }
    );

    // setting the challenge default method in codemirror windows
    this.editor_one.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
    this.editor_two.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));

    // setInterval(() => {
    //   fetch(`/games/${this.gameIdValue}/user_code`, {
    //     method: "POST",
    //     credentials: "same-origin",
    //     headers: {
    //       "X-CSRF-Token": this.token,
    //       "Content-Type": "application/json",
    //       "Accept": "application/json"
    //     },
    //   })
    //   .then((response) => response.json())
    //   .then(data => this.updatePlayerEditor(data))
    // }, 2000);

  }

  connect() {

    console.log("Code controller is connected!")
  }
}
