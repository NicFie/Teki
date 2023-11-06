import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
const codemirror = require("../codemirror/codemirror");

// Connects to data-controller="code"
export default class extends Controller {
  static values = {
    gameId: Number,
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
    "roundFiveInstructions",
    "gameRoundCount"
  ]

  initialize() {
    this.token = document.getElementsByName("csrf-token")[0].content
  }

  connect() {
    console.log(`Code player 1 is ${this.playerOneId}`)
    console.log(`Code player 2 is ${this.playerTwoId}`)
    console.log(`This user is ${this.userId}`)
    this.channel = createConsumer().subscriptions.create(
      { channel: "GameChannel", id: this.gameIdValue },
      { received: data => {
        if(data.command == "update editors") { this.updatePlayerEditor(data) }
        if(data.command == "update game winner modal") { this.setSolutionModal(data) }
      }}
    )
      this.gameMetaData()
      this.playerTyping()
  }

gameMetaData() {
    fetch(`${this.gameIdValue}/game_metadata`, {
        method: "POST",
        credentials: "same-origin",
        headers: {
            "X-CSRF-Token": this.token,
            "Content-Type": "application/json",
            "Accept": "application/json"
        }})
        .then(response => response.json())
        .then(data => {
            let meta_data = data.meta_data
            this.gameRoundMethod = meta_data.gameRoundMethod
            this.gameTests = meta_data.gameTests
            this.playerOneId = meta_data.playerOneId
            this.playerTwoId = meta_data.playerTwoId
            this.roundCount = meta_data.roundCount
            this.rubyServiceUrl = meta_data.rubyServiceUrl
            this.updateUrl = meta_data.updateUrl
            this.userId = meta_data.userId
            this.gameRound = meta_data.gameRound

            this.setupEditors()
        })
        .then(e => {
            this.editor_one.setValue(this.gameRoundMethod.replaceAll('\\n', '\n'));
            this.editor_two.setValue(this.gameRoundMethod.replaceAll('\\n', '\n'));
        })
        .catch(er => {
            console.log(er)
        })
    }

    setupEditors() {
        let playerOneRead = ""
        let playerTwoRead = ""
        let playerOneTheme = ""
        let playerTwoTheme = ""
        if (this.playerOneId == this.userId) {
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
                readOnly: playerOneRead,
                lineWrapping: true
            }
        );

        this.editor_two = codemirror.fromTextArea(
            this.editortwoTarget, {
                mode: "ruby",
                theme: playerTwoTheme,
                lineNumbers: true,
                readOnly: playerTwoRead,
                lineWrapping: true
            }
        );

        const data = {
            mode: "ruby",
            theme: 'dracula',
            lineNumbers: true,
            readOnly: 'nocursor',
            lineWrapping: true
        }

        // Solutions modal code editors
        this.round_one_editor_one = codemirror.fromTextArea(this.roundOneEditorOneTarget, data);
        this.round_one_editor_two = codemirror.fromTextArea(this.roundOneEditorTwoTarget, data);
        this.round_two_editor_one = codemirror.fromTextArea(this.roundTwoEditorOneTarget, data);
        this.round_two_editor_two = codemirror.fromTextArea(this.roundTwoEditorTwoTarget, data);
        this.round_three_editor_one = codemirror.fromTextArea(this.roundThreeEditorOneTarget, data);
        this.round_three_editor_two = codemirror.fromTextArea(this.roundThreeEditorTwoTarget, data);
        this.round_four_editor_one = codemirror.fromTextArea(this.roundFourEditorOneTarget, data);
        this.round_four_editor_two = codemirror.fromTextArea(this.roundFourEditorTwoTarget, data);
        this.round_five_editor_one = codemirror.fromTextArea(this.roundFiveEditorOneTarget, data);
        this.round_five_editor_two = codemirror.fromTextArea(this.roundFiveEditorTwoTarget, data);
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
    return ((this.userId === this.playerOneId) ? "one" : "two")
  }

  editorOneOrTwo() {
    return ((this.userId === this.playerOneId) ? this.editor_one : this.editor_two)
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
    if(this.userId === this.playerTwoId) {
      this.editor_one.setValue(data.player_one)
    } else if (this.userId === this.playerOneId) {
      this.editor_two.setValue(data.player_two)
    }
  }

  // Code submissions and sendCode function
  clearPlayerSubmission() {
    this.editorOneOrTwo().setValue(this.gameRoundMethod.replaceAll('\\n', '\n'));
  }

  playerSubmission() {
    this.sendCode(this.editorOneOrTwo().getValue(), this.userId);
  }

  sendCode(code, user_id) {
      console.log(this.roundCount)
      fetch(`${this.rubyServiceUrl}/execute`, {
          method: "POST",
          body: JSON.stringify({ submission_code: code, user_id: user_id, tests: this.gameTests }),
      })
      .then((response) => response.json())
      .then(data => {
          this.outputTarget.innerHTML = data.output
          data.all_passed === true && this.finishRound(user_id);
      })
  }

  finishRound(user_id) {
      fetch(`${this.gameIdValue}/round_won`, {
          method: "POST",
          credentials: "same-origin",
          headers: {
              "X-CSRF-Token": this.token,
              "Content-Type": "application/json",
              "Accept": "application/json"
          },
          body: JSON.stringify({ user_id: user_id})
      })
  }

  showSolutionModal(){
    document.getElementById("playerSolutionsModal").style.display = "flex"
    this.round_one_editor_one.refresh()
    this.round_one_editor_two.refresh()
  }

  closeSolutionModal(){
    document.getElementById("playerSolutionsModal").style.display = "none"
  }


  expandRoundOne() {
    let x = document.getElementById("round-one-hidden-details");
    if (x.style.display === "none") {
      x.style.display = "flex";
      x.classList.add('active-round')
      this.round_one_editor_one.refresh()
      this.round_one_editor_two.refresh()
    } else {
      x.style.display = "none";
      x.classList.add('active-round')
    }
  }
  expandRoundTwo() {
    let x = document.getElementById("round-two-hidden-details");
    if (x.style.display === "none") {
      x.style.display = "flex";
      this.round_two_editor_one.refresh()
      this.round_two_editor_two.refresh()
    } else {
      x.style.display = "none";
    }
  }
  expandRoundThree() {
    let x = document.getElementById("round-three-hidden-details");
    if (x.style.display === "none") {
      x.style.display = "flex";
      this.round_three_editor_one.refresh()
      this.round_three_editor_two.refresh()
    } else {
      x.style.display = "none";
    }
  }
  expandRoundFour() {
    let x = document.getElementById("round-four-hidden-details");
    if (x.style.display === "none") {
      x.style.display = "flex";
      this.round_four_editor_one.refresh()
      this.round_four_editor_two.refresh()
    } else {
      x.style.display = "none";
    }
  }
  expandRoundFive() {
    let x = document.getElementById("round-five-hidden-details");
    if (x.style.display === "none") {
      x.style.display = "flex";
      this.round_five_editor_one.refresh()
      this.round_five_editor_two.refresh()
    } else {
      x.style.display = "none";
    }
  }

  setSolutionModal(data) {
      console.log(data.round_cound == 1)
    if(data.round_count == 1) {
      this.round_one_editor_one.setValue(data.p1_r1_solution)
      this.round_one_editor_two.setValue(data.p2_r1_solution)
      this.roundOneInstructionsTarget.innerText = `${data.round_one_instructions}`
      document.getElementById("round-one-hidden-details").style.display = "flex"
      document.getElementById("roundTwo").style.display = "none"
      document.getElementById("roundThree").style.display = "none"
      document.getElementById("roundFour").style.display = "none"
      document.getElementById("roundFive").style.display = "none"
    }else if(data.round_count == 3) {
      this.round_one_editor_one.setValue(data.p1_r1_solution)
      this.round_one_editor_two.setValue(data.p2_r1_solution)
      this.roundOneInstructionsTarget.innerText = `${data.round_one_instructions}`
      this.round_two_editor_one.setValue(data.p1_r2_solution)
      this.round_two_editor_two.setValue(data.p2_r2_solution)
      this.roundTwoInstructionsTarget.innerText = `${data.round_two_instructions}`
      this.round_three_editor_one.setValue(data.p1_r3_solution)
      this.round_three_editor_two.setValue(data.p2_r3_solution)
      this.roundThreeInstructionsTarget.innerText = `${data.round_three_instructions}`
      document.getElementById("roundFour").style.display = "none"
      document.getElementById("roundFive").style.display = "none"
    }else if(data.round_count == 5) {
      this.round_one_editor_one.setValue(data.p1_r1_solution)
      this.round_one_editor_two.setValue(data.p2_r1_solution)
      this.roundOneInstructionsTarget.innerText = `${data.round_one_instructions}`
      this.round_two_editor_one.setValue(data.p1_r2_solution)
      this.round_two_editor_two.setValue(data.p2_r2_solution)
      this.roundTwoInstructionsTarget.innerText = `${data.round_two_instructions}`
      this.round_three_editor_one.setValue(data.p1_r3_solution)
      this.round_three_editor_two.setValue(data.p2_r3_solution)
      this.roundThreeInstructionsTarget.innerText = `${data.round_three_instructions}`
      this.round_four_editor_one.setValue(data.p1_r4_solution)
      this.round_four_editor_two.setValue(data.p2_r4_solution)
      this.roundFourInstructionsTarget.innerText = `${data.round_four_instructions}`
      this.round_five_editor_one.setValue(data.p1_r5_solution)
      this.round_five_editor_two.setValue(data.p2_r5_solution)
      this.roundFiveInstructionsTarget.innerText = `${data.round_five_instructions}`
    }
  }
}
