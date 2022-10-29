import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
const codemirror = require("../codemirror/codemirror");

// Connects to data-controller="code"
export default class extends Controller {
  static values = {
    gameId: Number,
    userId: Number,
    playerOneId: Number,
    playerTwoId: Number,
    gameRoundMethod: String
  }

  static targets = [
    "editorone",
    "editortwo",
    "output"
  ]

  initialize() {
    this.token = document.getElementsByName("csrf-token")[0].content

    let playerOneRead = ""
    let playerTwoRead = ""
    if (this.playerOneIdValue == this.userIdValue) {
      playerTwoRead = "nocursor"
    } else {
      playerOneRead = "nocursor";
    }

    // Generating codemirror windows
    this.editor_one = codemirror.fromTextArea(
      this.editoroneTarget, {
        mode: "ruby",
        theme: "dracula",
        lineNumbers: true,
        readOnly: playerOneRead
      }
    );

    this.editor_two = codemirror.fromTextArea(
      this.editortwoTarget, {
        mode: "ruby",
        theme: "dracula",
        lineNumbers: true,
        readOnly: playerTwoRead,
      }
    );

    // setting the challenge default method in codemirror windows
    this.editor_one.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
    this.editor_two.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));

    this.playerTyping()
  }

  connect() {
    console.log(`Code player 1 is ${this.playerOneIdValue}`)
    console.log(`Code player 2 is ${this.playerTwoIdValue}`)
    console.log(`This user is ${this.userIdValue}`)
    this.channel = createConsumer().subscriptions.create(
      { channel: "GameChannel", id: this.gameIdValue },
      { received: data => {
        if(data.command == "update editors") { this.updatePlayerEditor(data) };
      }}
    )
  }

  patchForm(form) {
    fetch(this.data.get("update-url"), {
      body: form,
      method: 'PATCH',
      credentials: "include",
      dataType: "script",
      headers: {
              "X-CSRF-Token": this.token
       },
    })
  }

  playerOneOrTwo() {
    return ((this.userIdValue === this.playerOneIdValue) ? "one" : "two")
  }

  editorOneOrTwo() {
    return ((this.userIdValue === this.playerOneIdValue) ? this.editor_one : this.editor_two)
  }

  playerTyping() {
    let playerCodeForm = new FormData()
    playerCodeForm.append(`game[player_${this.playerOneOrTwo()}_code]`, this.editorOneOrTwo().getValue())
    this.patchForm(playerCodeForm)
    this.getPlayerCode()
  }

  getPlayerCode() {
    fetch(`/games/${this.gameIdValue}/user_code`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    })
  }

  updatePlayerEditor(data) {
    if(this.userIdValue === this.playerTwoIdValue) {
      this.editor_one.setValue(data.player_one)
    } else if (this.userIdValue === this.playerOneIdValue) {
      this.editor_two.setValue(data.player_two)
    }
  }

  // Code submissions and sendCode function
  clearPlayerSubmission() {
    this.editorOneOrTwo().setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
  }

  playerSubmission() {
    this.sendCode(this.editorOneOrTwo().getValue(), this.userIdValue);
  }

  sendCode(code, user_id) {
    fetch(`/games/${this.gameIdValue}/game_test`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ submission_code: code, user_id: user_id }),
    })
    .then((response) => response.json())
    .then(data => this.outputTarget.innerHTML = data.results)
  }
}
