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
  static targets = ["editorone", "editortwo", "output", "roundWinner", "roundWinnerModal"]



  connect() {
    // modal stuff
    const modal = document.getElementById("roundWinnerModal");
    const span = document.getElementsByClassName("round-winner-modal-close")[0];
    span.onclick = function() {
      modal.style.display = "none";
    }
    window.onclick = function(event) {
      if (event.target == modal) {
        modal.style.display = "none";
      }
    }
  }

  initialize() {
    // console.log(`player one user:${this.gamePlayerOneValue}`);
    // console.log(`player two user:${this.gamePlayerTwoValue}`);
    // console.log(`current user:${this.userIdValue}`);

    // defining the theme of codemirror depending on user
    let playerOneTheme = ''
    let playerTwoTheme = ''
    if(this.gamePlayerOneValue == this.userIdValue) {
      playerOneTheme = "dracula";
      playerTwoTheme = "dracula_blurred";
    } else if(this.gamePlayerTwoValue == this.userIdValue) {
      playerOneTheme = "dracula_blurred";
      playerTwoTheme = "dracula";
    }
    // Generating codemirror windows
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
    // setting the challenge default method in codemirror windows
    this.editor_one.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
    this.editor_two.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));

  }
  // codemirror buttons
  clearPlayerOneSubmission(){
    this.editor_one.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
  }
  clearPlayerTwoSubmission(){
    this.editor_two.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
  }

  playerOneSubmission() {
    this.sendCode(this.editor_one.getValue(), this.userIdValue);
  }
  playerTwoSubmission() {
    this.sendCode(this.editor_two.getValue(), this.userIdValue);
  }

  sendCode(code, user_id) {
    const token = document.getElementsByName("csrf-token")[0].content
    fetch(`/games/${this.gameIdValue}/game_test`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ player_one_code: code, user_id: user_id }),
    })
    .then((response) => response.json())
    .then(data => {
      this.outputTarget.innerText = data.results;
      this.roundWinnerTarget.innerText = data.round_winner;
      if(data.round_winner.includes('wins')){
        this.roundWinnerModalTarget.style.display = "block";
      }
    })
  }

}
