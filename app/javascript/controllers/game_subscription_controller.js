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
    gameRoundMethod: String,
    gameRoundNumber: Number,
    playerOneReady: Boolean,
    playerTwoReady: Boolean
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
    "preGameLoadingContent",
    "playerFoundMessage",
    "matchDetailsAndCountdown",
    "playerOneReady",
    "playerTwoReady",
    "playerTwoDetails",
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
        if(data.command == "start game") { this.startGameUserUpdate(); }
        if(data.command == "next round") { this.nextRoundStatus(data); }}}
    )
    console.log(`Subscribe to the chatroom with the id ${this.gameIdValue}.`);
    console.log(`The current user is ${this.userIdValue}`);
    console.log(`Player one's current Id is ${this.playerOneIdValue}`)
    console.log(`Player two's current Id is ${this.playerTwoIdValue}`)

    //Checks default value of the game then updates
    //the game with correct user id's for player one and player two.
    if (this.playerTwoIdValue === 1) {
      this.preGameModalTarget.style.display = "flex";
      document.querySelectorAll('#typed').forEach(function(el) {
        new Typed(el, {
        stringsElement: el.previousElementSibling,
        loop: true,
        typeSpeed: 50,
        showCursor: false,
      })
    });
    }

    if (this.playerOneIdValue === 1) {
      this.updatePlayerOneId()
      this.preGameModalTarget.style.display = "flex";
    } else if (this.playerOneIdValue !== this.userIdValue && this.playerTwoIdValue !== this.userIdValue ) {
      this.updatePlayerTwoId()
      this.startGameUserUpdate()
    }
  }

  startGameUserUpdate() {
    this.preGameLoadingContentTarget.style.display = "none"
    this.playerFoundMessageTarget.style.display = "flex"
    // setTimeout(() => { // switch to head to head details
    //   this.playerFoundMessageTarget.style.display = "none"
    //   this.matchDetailsAndCountdownTarget.style.display = "flex";
    // }, 2000);
    setTimeout(() => { // countdown
      this.matchDetailsAndCountdownTarget.style.display = "none";
      this.playerFoundMessageTarget.style.display = "flex"
      this.playerFoundMessageTarget.innerHTML = `<h1 class="countdown-title">Round ${this.gameRoundNumberValue + 1}</h1><br><h1 class="number-animation">3</h1>`
    }, 3000);
    setTimeout(() => { // countdown
      this.playerFoundMessageTarget.innerHTML = `<h1 class="countdown-title">Round ${this.gameRoundNumberValue + 1}</h1><br><h1 class="number-animation">2</h1>`
    }, 4000);
    setTimeout(() => { // countdown
      this.playerFoundMessageTarget.innerHTML = `<h1 class="countdown-title">Round ${this.gameRoundNumberValue + 1}</h1><br><h1 class="number-animation">1</h1>`
    }, 5000);
    setTimeout(() => { // countdown
      this.playerFoundMessageTarget.innerHTML = `<h1 class="countdown-title">Round ${this.gameRoundNumberValue + 1}</h1><br><h1 class="number-animation">Go!</h1>`
    }, 6000);
    setTimeout(() => { //remove
      this.playerFoundMessageTarget.style.display = "none"
      this.preGameModalTarget.style.display = "none";
      if(this.playerOneIdValue === 1 || this.playerTwoIdValue === 1) {
        this.updatePage()
      }
    }, 7000);
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
    // setTimeout(() => {
    //   this.updatePage()
    // }, 300);
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

  postReadyStatus(player_one_ready, player_two_ready) {
    fetch(`/games/${this.gameIdValue}/user_ready_next_round`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ player_one_ready: player_one_ready, player_two_ready: player_two_ready }),
    })
  }

  postReadyStatus(player_one_ready, player_two_ready) {
    fetch(`/games/${this.gameIdValue}/user_ready_next_round`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ player_one_ready: player_one_ready, player_two_ready: player_two_ready }),
    })
  }

  nextRound() {
    if(this.userIdValue == this.playerOneIdValue){
      this.playerOneReadyValue = true
      this.postReadyStatus(this.playerOneReadyValue, this.playerTwoReadyValue)
    };
    if(this.userIdValue == this.playerTwoIdValue){
      this.playerTwoReadyValue = true
      this.postReadyStatus(this.playerOneReadyValue, this.playerTwoReadyValue)
    };
  }

  nextRoundStatus(data){
    if(data.player_one_ready == true){
      this.playerOneReadyTarget.innerText = '✅'
      this.playerOneReadyValue = true;
    }
    if(data.player_two_ready == true){
      this.playerTwoReadyTarget.innerText = '✅'
      this.playerTwoReadyValue = true;
    }
    if(data.player_one_ready == true && data.player_two_ready == true){
      setTimeout(() => { // countdown
        this.roundWinnerModalTarget.style.display = "none";
        this.preGameLoadingContentTarget.style.display = "none";
        this.preGameModalTarget.style.display = "flex";
        this.playerFoundMessageTarget.style.display = "flex";
        this.playerFoundMessageTarget.innerHTML = `<h1 class="countdown-title">Round ${data.round_number}</h1><br><h1 class="number-animation">3</h1>`
      }, 1000);
      setTimeout(() => { // countdown
        this.playerFoundMessageTarget.innerHTML = `<h1 class ="countdown-title">Round ${data.round_number}</h1><br><h1 class="number-animation">2</h1>`
      }, 2000);
      setTimeout(() => { // countdown
        this.playerFoundMessageTarget.innerHTML = `<h1 class ="countdown-title">Round ${data.round_number}</h1><br><h1 class="number-animation">1</h1>`
      }, 3000);
      setTimeout(() => { // countdown
        this.playerFoundMessageTarget.innerHTML = `<h1 class ="countdown-title">Round ${data.round_number}</h1><br><h1 class="number-animation">Go!</h1>`
      }, 4000);
      setTimeout(() => { //remove
        this.playerFoundMessageTarget.style.display = "none"
        this.preGameModalTarget.style.display = "none";
        this.updatePage()
      }, 5000);
    }
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


  disconnect() {
    this.channel.unsubscribe()
    if (this.playerTwoIdValue === 1) {
      let playerOnesForm = new FormData()
      playerOnesForm.append("game[player_one_id]", 1)
      this.patchForm(playerOnesForm)
    }
  }
}
