import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
import { postForm } from '../utils/fileUtils';
const codemirror = require("../codemirror/codemirror");

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
    this.gameId = this.gameIdValue
  }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "GameChannel", id: this.gameId },
      { received: data => {
        if(data.command == "update editors") { this.updatePlayerEditor(data) }
        if(data.command == "update game winner modal") { this.setSolutionModal(data) }
      }}
    )

      this.gameMetaData().then()
  }

    async gameMetaData() {
        const response = await postForm(`${this.gameId}/game_metadata`, {});
        const { roundCount, userId, playerOneId, playerTwoId, gameRoundMethod, gameTests, rubyServiceUrl, updateUrl, gameRoundId } = response.meta_data;

        this.gameRoundMethod = gameRoundMethod;
        this.gameTests = gameTests;
        this.playerOneId = playerOneId;
        this.playerTwoId = playerTwoId;
        this.roundCount = roundCount;
        this.rubyServiceUrl = rubyServiceUrl;
        this.updateUrl = updateUrl;
        this.userId = userId;
        this.gameRoundId = gameRoundId;

        this.setupEditors();
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

        this.editor_one.setValue(this.gameRoundMethod.replaceAll('\\n', '\n'))
        this.editor_two.setValue(this.gameRoundMethod.replaceAll('\\n', '\n'))

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


  playerOneOrTwo() {
    return ((this.userId === this.playerOneId) ? "one" : "two")
  }

  editorOneOrTwo() {
    return ((this.userId === this.playerOneId) ? this.editor_one : this.editor_two)
  }

  playerTyping() {
    const code = this.editorOneOrTwo().getValue();
    const url = `/games/${this.gameId}/user_code`
    const body =   { code: code, user_id: this.userId }
    postForm(url, body).then()
  }

  getPlayerCode() {
    const url =   `/games/${this.gameId}/user_code`
    const body = {}
    postForm(url, body).then()
  }

  updatePlayerEditor(data) {
    if(data.user_id === this.playerTwoId && data.user_id !== this.userId) {
      this.editor_two.setValue(data.code)
    } else if (data.user_id === this.playerOneId && data.user_id !== this.userId) {
      this.editor_one.setValue(data.code)
    }
  }

  // Code submissions and sendCode function
  clearPlayerSubmission() {
    this.editorOneOrTwo().setValue(this.gameRoundMethod.replaceAll('\\n', '\n'));
  }

  playerSubmission() {
    this.sendCode(this.editorOneOrTwo().getValue(), this.userId);
  }

  forfeitRound() {
      let user_id = (this.userId === this.playerOneId) ? this.playerTwoId : this.playerOneId
      this.finishRound(user_id, `${this.gameIdValue}/forfeit_round`)
  }

  sendCode(code, user_id) {
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
      let player_one_code = this.editor_one.getValue()
      let player_two_code = this.editor_two.getValue()

      const url = `${this.gameIdValue}/round_won`
      const body = { user_id: user_id, player_one_code: player_one_code, player_two_code: player_two_code }
      postForm(url, body)
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
