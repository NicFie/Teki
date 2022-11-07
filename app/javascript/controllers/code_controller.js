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
    gameRoundMethod: String,
    currentGameRound: Number
  }

  static targets = [
    "editorone",
    "editortwo",
    "output",
    "roundOneEditorOne",
    "roundOneEditorTwo",
    "roundTwoEditorOne",
    "roundTwoEditorTwo",
    "roundThreeEditorOne",
    "roundThreeEditorTwo",
    "roundFourEditorOne",
    "roundFourEditorTwo",
    "roundFiveEditorOne",
    "roundFiveEditorTwo",
    "roundOneInstructions",
    "roundTwoInstructions",
    "roundThreeInstructions",
    "roundFourInstructions",
    "roundFiveInstructions"
  ]

  initialize() {
    this.token = document.getElementsByName("csrf-token")[0].content

    let playerOneRead = ""
    let playerTwoRead = ""
    let playerOneTheme = ""
    let playerTwoTheme = ""
    if (this.playerOneIdValue == this.userIdValue) {
      playerTwoRead = "nocursor"
      playerOneTheme = "dracula"
      playerTwoTheme = "dracula_blurred"
    } else {
      playerOneRead = "nocursor";
      playerOneTheme = "dracula_blurred"
      playerTwoTheme = "dracula"
    }

    // Generating codemirror windows
    this.editor_one = codemirror.fromTextArea(
      this.editoroneTarget, {
        mode: "ruby",
        theme: playerOneTheme,
        lineNumbers: true,
        readOnly: playerOneRead
      }
    );

    this.editor_two = codemirror.fromTextArea(
      this.editortwoTarget, {
        mode: "ruby",
        theme: playerTwoTheme,
        lineNumbers: true,
        readOnly: playerTwoRead,
      }
    );

    // Solutions modal code editors
    this.round_one_editor_one = codemirror.fromTextArea(
      this.roundOneEditorOneTarget, {
        mode: "ruby",
        theme: 'dracula',
        lineNumbers: true,
        readOnly: 'nocursor'
      }
    );
    this.round_one_editor_two = codemirror.fromTextArea(
      this.roundOneEditorTwoTarget, {
        mode: "ruby",
        theme: 'dracula',
        lineNumbers: true,
        readOnly: 'nocursor',
      }
    );

    this.round_two_editor_one = codemirror.fromTextArea(
      this.roundTwoEditorOneTarget, {
        mode: "ruby",
        theme: 'dracula',
        lineNumbers: true,
        readOnly: 'nocursor'
      }
    );
    this.round_two_editor_two = codemirror.fromTextArea(
      this.roundTwoEditorTwoTarget, {
        mode: "ruby",
        theme: 'dracula',
        lineNumbers: true,
        readOnly: 'nocursor',
      }
    );

    this.round_Three_editor_one = codemirror.fromTextArea(
      this.roundThreeEditorOneTarget, {
        mode: "ruby",
        theme: 'dracula',
        lineNumbers: true,
        readOnly: 'nocursor'
      }
    );
    this.round_three_editor_two = codemirror.fromTextArea(
      this.roundThreeEditorTwoTarget, {
        mode: "ruby",
        theme: 'dracula',
        lineNumbers: true,
        readOnly: 'nocursor',
      }
    );

    this.round_four_editor_one = codemirror.fromTextArea(
      this.roundFourEditorOneTarget, {
        mode: "ruby",
        theme: 'dracula',
        lineNumbers: true,
        readOnly: 'nocursor'
      }
    );
    this.round_four_editor_two = codemirror.fromTextArea(
      this.roundFourEditorTwoTarget, {
        mode: "ruby",
        theme: 'dracula',
        lineNumbers: true,
        readOnly: 'nocursor',
      }
    );

    this.round_five_editor_one = codemirror.fromTextArea(
      this.roundFiveEditorOneTarget, {
        mode: "ruby",
        theme: 'dracula',
        lineNumbers: true,
        readOnly: 'nocursor'
      }
    );
    this.round_five_editor_two = codemirror.fromTextArea(
      this.roundFiveEditorTwoTarget, {
        mode: "ruby",
        theme: 'dracula',
        lineNumbers: true,
        readOnly: 'nocursor',
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
        if(data.command == "update game winner modal") { this.setSolutionModal(data) };
      }}
    )
  }

  patchForm(form) {
    fetch(`/game_rounds/${this.currentGameRoundValue}`, {
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
    playerCodeForm.append(`game_round[player_${this.playerOneOrTwo()}_code]`, this.editorOneOrTwo().getValue())
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

  showSolutionModal(){
    document.getElementById("playerSolutionsModal").style.display = "flex"
  }


  expandRoundOne() {
    let x = document.getElementById("round-one-hidden-details");
    if (x.style.display === "none") {
      x.style.display = "flex";
      x.classList.add('active-round')
    } else {
      x.style.display = "none";
      x.classList.add('active-round')
    }
  }
  expandRoundTwo() {
    let x = document.getElementById("round-two-hidden-details");
    if (x.style.display === "none") {
      x.style.display = "flex";
    } else {
      x.style.display = "none";
    }
  }
  expandRoundThree() {
    let x = document.getElementById("round-three-hidden-details");
    if (x.style.display === "none") {
      x.style.display = "flex";
    } else {
      x.style.display = "none";
    }
  }
  expandRoundFour() {
    let x = document.getElementById("round-four-hidden-details");
    if (x.style.display === "none") {
      x.style.display = "flex";
    } else {
      x.style.display = "none";
    }
  }
  expandRoundFive() {
    let x = document.getElementById("round-five-hidden-details");
    if (x.style.display === "none") {
      x.style.display = "flex";
    } else {
      x.style.display = "none";
    }
  }

  setSolutionModal(data) {
    this.round_one_editor_one.setValue(data.p1_r1_solution)
    this.round_one_editor_two.setValue(data.p2_r1_solution)
    this.roundOneInstructionsTarget.innerHTML = data.round_one_instructions
    this.round_two_editor_one.setValue(data.p1_r2_solution)
    this.round_two_editor_two.setValue(data.p2_r2_solution)
    this.roundTwoInstructionsTarget.innerHTML = data.round_two_instructions
    this.round_three_editor_one.setValue(data.p1_r3_solution)
    this.round_three_editor_two.setValue(data.p2_r3_solution)
    this.roundThreeInstructionsTarget.innerHTML = data.round_three_instructions
    this.round_four_editor_one.setValue(data.p1_r4_solution)
    this.round_four_editor_two.setValue(data.p2_r4_solution)
    this.roundFourInstructionsTarget.innerHTML = data.round_four_instructions
    this.round_five_editor_one.setValue(data.p1_r5_solution)
    this.round_five_editor_two.setValue(data.p2_r5_solution)
    this.roundFiveInstructionsTarget.innerHTML = data.round_five_instructions
  }

}
