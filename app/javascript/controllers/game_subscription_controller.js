import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core"
import { createConsumer } from "@rails/actioncable"
import Typed from "typed.js"
const codemirror = require("../codemirror/codemirror");


export default class extends Controller {
  static values = {
    gameId: Number,
    userId: Number,
    playerOneId: Number,
    playerTwoId: Number,
    loaded: Boolean,
    gameRoundMethod: String
  }

  static targets = [
    "editorone",
    "editortwo",
    "output",
    "solutions",
    "roundWinner",
    "roundWinnerModal",
    "roundWinnerModalContent",
    "roundWinnerCountp1",
    "roundWinnerCountp2",
    "gameWinner",
    "gameWinnerModal",
    "roundWinnerModalContent",
    "gameWinnerCountp1",
    "gameWinnerCountp2",
    "preGameModal",
    "preGameWaitingContent",
    "playerFoundMessage",
    "preGamePlayerFoundContent",
    "playerOneReady",
    "playerTwoReady",
    "playerTwoUsername",
    "playerTwoAvatar"
  ]

  initialize() {
    // variables for next round function
    let playerOneReady = false
    let playerTwoReady = false
    // defining the theme of codemirror depending on user
    let playerOneTheme = ''
    let playerTwoTheme = ''
    let playerOneRead = ''
    let playerTwoRead = ''
    this.token = document.getElementsByName("csrf-token")[0].content

    this.editor_one_code = ''
    if(this.playerOneIdValue == this.userIdValue) {
      playerOneTheme = "dracula";
      playerTwoTheme = "dracula_blurred";
      playerTwoRead = "nocursor";
    } else if(this.playerTwoIdValue == this.userIdValue) {
      playerOneTheme = "dracula_blurred";
      playerTwoTheme = "dracula";
      playerOneRead = "nocursor";
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

    // setting the challenge default method in codemirror windows
    this.editor_one.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
    this.editor_two.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));

    this.playerTyping()
  }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "GameChannel", id: this.gameIdValue },
      { received: data => {
        console.log(`broadcast data: ${data}`);
        if(data.command == "update page") { this.updatePlayerOnePage() };
        if(data.command == "update round winner modal") { this.roundWinnerModalUpdate(data) };
        if(data.command == "update game winner modal") { this.gameWinnerModalUpdate(data) };
        if(data.command == "update editors") { this.updatePlayerEditor(data) };
        if(data.command == "start game") { this.startGameUserUpdate(data) };
      } }
    )
    console.log(`Subscribe to the chatroom with the id ${this.gameIdValue}.`);
    console.log(`The current user is ${this.userIdValue}`);
    console.log(`Player one's current Id is ${this.playerOneIdValue}`)
    console.log(`Player two's current Id is ${this.playerTwoIdValue}`)

    //Checks default value of the game then updates
    //the game with correct user id's for player one and player two.
    if (this.playerOneIdValue === 1) {
      this.updatePlayerOneId()
    } else if (this.playerOneIdValue !== this.userIdValue && this.playerTwoIdValue !== this.userIdValue ) {
      this.updatePlayerTwoId()
    }
  }

  startGameUserUpdate(data) {
    if(data.player_two != 1){ //if there is now a player two show player found
      this.playerTwoUsernameTargets.forEach (t => t.innerText = data.player_two_username)
      this.playerTwoAvatarTargets.forEach (t => t.src = `../../assets/images/${data.player_two_avatar}.png`)
      this.preGameWaitingContentTarget.style.display = "none"
      this.playerFoundMessageTarget.style.display = "flex"
      setTimeout(() => { // switch to head to head details
        this.playerFoundMessageTarget.style.display = "none"
        this.preGamePlayerFoundContentTarget.style.display = "flex";
      }, 2000);
      setTimeout(() => { // countdown
        this.preGamePlayerFoundContentTarget.style.display = "none";
        this.playerFoundMessageTarget.style.display = "flex"
        this.playerFoundMessageTarget.innerHTML = "3"
      }, 4000);
      setTimeout(() => { // countdown
        this.playerFoundMessageTarget.innerHTML = "2"
      }, 5000);
      setTimeout(() => { // countdown
        this.playerFoundMessageTarget.innerHTML = "1"
      }, 6000);
      setTimeout(() => { //remove
        this.playerFoundMessageTarget.style.display = "none"
        this.preGameModalTarget.style.display = "none";
      }, 7000);
    }
  }

  currentUsersEditor() {
    if(this.userIdValue == this.playerOneIdValue) {
      return this.editor_one
    } else {
      return this.editor_two
    }
  }

  //Creates a form and sends it to to the server to update the game,
  //changing players from the default 1 to the id of the player_one or player_two

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

  updatePlayerOneId() {
    let playerOnesForm = new FormData()
    playerOnesForm.append("game[player_one_id]", this.userIdValue)
    this.patchForm(playerOnesForm)
    // maybe use broadcast instead
    setTimeout(() => {
      this.updatePage()
    }, 300);
  }

  updatePlayerTwoId() {
    let playerTwosForm = new FormData()
    playerTwosForm.append("game[player_two_id]", this.userIdValue)
    this.patchForm(playerTwosForm)

    // maybe use broadcast instead
    fetch(`/games/${this.gameIdValue}/update_display`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    })
    .then((response) => response.json())

    this.updatePage()
  }

  updatePage() {
    location.reload()
  }

  updatePlayerOnePage() {
    location.reload()
  }

  //updates code on the database as a player types then updates the view of player.
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
    // console.log("arrives in player code")
    fetch(`/games/${this.gameIdValue}/user_code`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    })
    .then((response) => response.json())
    // .then(data => this.updatePlayerEditor(data))
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


  roundWinnerModalUpdate(data) {
    if(data.round_winner.includes('wins')){
      this.roundWinnerTarget.innerText = data.round_winner;
      this.roundWinnerCountp1Target.innerText = `${data.p1_count}`;
      this.roundWinnerCountp2Target.innerText = `${data.p2_count}`;
      this.roundWinnerModalTarget.style.display = "block";
    }
  }

  nextRound() {
    if(this.userIdValue == this.playerOneIdValue){
      this.playerOneReady = true
      this.playerOneReadyTarget.innerText = 'yes'
    };
    if(this.userIdValue == this.playerTwoIdValue){
      this.playerTwoReady = true
      this.playerTwoReadyTarget.innerText = 'yes'
    };
    let nextRoundInterval = setInterval(() => {
      if (this.playerOneReady == true && this.playerTwoReady == true){
        clearInterval(nextRoundInterval);
        this.updatePage();
      }
    }, 1000);
  }

  gameWinnerModalUpdate(data) {
    if(data.round_winner.includes('wins')){
      this.gameWinnerTarget.innerText = `${data.game_winner} wins the game!!!`;
      this.gameWinnerCountp1Target.innerText = `${data.p1_count}`;
      this.gameWinnerCountp2Target.innerText = `${data.p2_count}`;
      this.gameWinnerModalTarget.style.display = "block";
    }
  }

  endGame() {
    this.updatePage()
  }

  preGameModal(){

  }

  disconnect() {
    this.channel.unsubscribe()
    console.log(this.playerTwoIdValue)
    if (this.playerTwoIdValue === 1) {
      let playerOnesForm = new FormData()
      playerOnesForm.append("game[player_one_id]", 1)
      this.patchForm(playerOnesForm)
    }
    WebSocket.CLOSED()
  }
}
