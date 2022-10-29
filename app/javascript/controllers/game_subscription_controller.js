import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core"
import { createConsumer } from "@rails/actioncable"
import Typed from "typed.js"
// const codemirror = require("../codemirror/codemirror");


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
    this.token = document.getElementsByName("csrf-token")[0].content
  }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "GameChannel", id: this.gameIdValue },
      { received: data => {
        // console.log(`broadcast data: ${data}`);
        if(data.command == "update page") { this.updatePlayerOnePage() };
        if(data.command == "update round winner modal") { this.roundWinnerModalUpdate(data) };
        if(data.command == "update game winner modal") { this.gameWinnerModalUpdate(data) };
        // if(data.command == "update editors") { this.updatePlayerEditor(data) };
        if(data.command == "start game") { this.startGameUserUpdate(); }}}
    )
    console.log(`Subscribe to the chatroom with the id ${this.gameIdValue}.`);
    console.log(`The current user is ${this.userIdValue}`);
    console.log(`Player one's current Id is ${this.playerOneIdValue}`)
    console.log(`Player two's current Id is ${this.playerTwoIdValue}`)

    //Checks default value of the game then updates
    //the game with correct user id's for player one and player two.
    if (this.playerTwoIdValue === 1) {
      this.preGameModalTarget.style.display = "block";
    }


    if (this.playerOneIdValue === 1) {
      this.updatePlayerOneId()
    } else if (this.playerOneIdValue !== this.userIdValue && this.playerTwoIdValue !== this.userIdValue ) {
      this.updatePlayerTwoId()
      this.startGameUserUpdate()
    }

  }

  startGameUserUpdate() {
    // if(data.player_two != 1){ //if there is now a player two show player found
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
        if(this.playerOneIdValue === 1 || this.playerTwoIdValue === 1) {
          this.updatePage()
        }
      }, 7000);
    // }
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
  }

  updatePage() {
    location.reload()
  }

  updatePlayerOnePage() {
    location.reload()
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
    if (this.playerTwoIdValue === 1) {
      let playerOnesForm = new FormData()
      playerOnesForm.append("game[player_one_id]", 1)
      this.patchForm(playerOnesForm)
    }
  }
}
