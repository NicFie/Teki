import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
import { postForm } from '../utils/fileUtils';
// const codemirror = require("../codemirror/codemirror");
import { basicSetup, EditorView } from "codemirror"
import { StreamLanguage } from "@codemirror/language"
import { ruby } from "@codemirror/legacy-modes/mode/ruby"
import { dracula } from '@uiw/codemirror-theme-dracula';



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
    this.setupChannel();
    this.gameMetaData().then(this.setupEditors.bind(this))
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
    }

    setupEditors() {
        let playerOneRead = (this.playerOneId === this.userId)? "" : "nocursor";
        let playerTwoRead = (this.playerOneId === this.userId) ? "nocursor" : "";
        let playerOneTheme = (this.playerOneId === this.userId) ? "dracula" : "dracula_blurred";
        let playerTwoTheme = (this.playerOneId === this.userId) ? "dracula_blurred" : "dracula";

        this.editor_one = this.setupCodeMirror(this.editoroneTarget, playerOneRead, this.gameRoundMethod.replaceAll("\\n", "\n"));
        this.editor_two = this.setupCodeMirror(this.editortwoTarget, playerTwoRead, this.gameRoundMethod.replaceAll("\\n", "\n"));
        this.editor_one.setValue(this.gameRoundMethod.replaceAll("\\n", "\n"))
        this.editor_two.setValue(this.gameRoundMethod.replaceAll("\\n", "\n"))

        // Solutions modal code editors
        for (let i = 1; i <= 5; i++) {
            let round = ["One", "Two", "Three", "Four", "Five"]
            this[`round_${round[i - 1].toLowerCase()}_editor_one`] = this.setupCodeMirror(this[`round${round[i - 1]}EditorOneTarget`], "dracula", "nocursor", editorConfig);
            this[`round_${round[i - 1].toLowerCase()}_editor_two`] = this.setupCodeMirror(this[`round${round[i - 1]}EditorTwoTarget`], "dracula", "nocursor", editorConfig);
        }
    }

    setupCodeMirror(target, readOnly, info) {
        // return codemirror.fromTextArea(target, { ...config, theme, readOnly });
        const editor = document.querySelector('#user-codebox-1')

        new EditorView({
            doc: info,
            extensions: [dracula, basicSetup, StreamLanguage.define(ruby)],
            parent: target
        })
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
    this.editorOneOrTwo().setValue(this.gameRoundMethod.replaceAll("\\n", "\n"));
  }

  playerSubmission() {
    this.sendCode(this.editorOneOrTwo().getValue(), this.userId);
  }

  forfeitRound() {
      let user_id = (this.userId === this.playerOneId) ? this.playerTwoId : this.playerOneId
      this.finishRound(user_id, `${this.gameId}/forfeit_round`)
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

      const url = `${this.gameId}/round_won`
      const body = { user_id: user_id, player_one_code: player_one_code, player_two_code: player_two_code }
      postForm(url, body).then()
  }

  showSolutionModal(){
    document.getElementById("playerSolutionsModal").style.display = "flex"
    this.round_one_editor_one.refresh()
    this.round_one_editor_two.refresh()
  }

  closeSolutionModal(){
    document.getElementById("playerSolutionsModal").style.display = "none"
  }

  expandRounds(id, roundNumber, active) {
      let x = document.getElementById(id);
      if (x.style.display === "none") {
          x.style.display = "flex";
          this[`round_${roundNumber}_editor_one`].refresh()
          this[`round_${roundNumber}_editor_two`].refresh()
          if (active) {
            x.classList.add("active-round")
          }
      } else {
          x.style.display = "none";
          if (active) {
            x.classList.add("active-round")
          }
      }
  }

  expandRoundOne() {
      let id = "round-one-hidden-details"
      let roundNumber = "one"
      let active = true
      this.expandRounds(id, roundNumber, active)
  }
  expandRoundTwo() {
      let id = "round-two-hidden-details"
      let roundNumber = "two"
      let active = false
      this.expandRounds(id, roundNumber, active)
  }
  expandRoundThree() {
      let id = "round-three-hidden-details"
      let roundNumber = "three"
      let active = false
      this.expandRounds(id, roundNumber, active)
  }
  expandRoundFour() {
      let id = "round-four-hidden-details"
      let roundNumber = "four"
      let active = false
      this.expandRounds(id, roundNumber, active)
  }
  expandRoundFive() {
      let id = "round-five-hidden-details"
      let roundNumber = "five"
      let active = false
      this.expandRounds(id, roundNumber, active)
  }

  setSolutionModal(data) {
      for (let i = 1; i <= data.round_count; i++) {
          let round = ["One", "Two", "Three", "Four", "Five"]
          this[`round_${round[i - 1].toLowerCase()}_editor_one`].setValue(data[`p1_r${i}_solution`])
          this[`round_${round[i - 1].toLowerCase()}_editor_two`].setValue(data[`p2_r${i}_solution`])
          this[`round${round[i - 1]}InstructionsTarget`].innerText = data[`round_${round[i - 1].toLowerCase()}_instructions`]
          document.getElementById(`round${round[i - 1]}`).classList.remove("hidden")
      }
  }

  setupChannel() {
      this.channel = createConsumer().subscriptions.create(
          { channel: "GameChannel", id: this.gameId },
          { received: data => {
                  if(data.command === "update editors") { this.updatePlayerEditor(data) }
                  if(data.command === "update game winner modal") { this.setSolutionModal(data) }
              }}
      )
  }
}
