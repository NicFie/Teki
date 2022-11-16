import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
import Typed from "typed.js"

// Connects to data-controller="friend"
export default class extends Controller {
  static values = {
  currentUserId: Number,
  gameRoundNumber: Number,
  playerOneReady: Boolean,
  playerTwoReady: Boolean
  }

  static targets = [
  "inviteContent",
  "inviteModal",
  "form",
  "preGameModal",
  "preGameLoadingContent",
  "playerFoundMessage",
  "matchDetailsAndCountdown",
  "preGameReadyModal",
  "playerOneUsername",
  "playerOneAvatar",
  "playerTwoUsername",
  "playerTwoAvatar",
  "playerOneReady",
  "playerTwoReady"
  ]


  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "FriendChannel", id: this.currentUserIdValue },
      { received: data => {
        if(data.command == "invited player info") {
          this.inviteModal(data)
        };
        if(data.command == 'inviter info') {
          this.dynamicWaitingContent(data)
        };
        setInterval(() => {
          if(this.accepted == true) {
            this.triggeredByAccept(data)
          };
          this.accepted = false;
        }, 500);
        if(data.command == 'player two accepts') {
          this.redirectInviter(data)
        };
        if(data.command == 'start game') {
          this.startGameStatus(data)
        }
      }}
    )
  }

  initialize() {
    this.token = document.getElementsByName("csrf-token")[0].content
    this.accepted = false;
  }

  checking(event) {
    this.formTarget.insertAdjacentHTML("afterbegin",
    `<input type='hidden' name='game[player_two_id]' value='${event.target.dataset.value}' autocomplete='off'></input>`)
    this.formTarget.insertAdjacentHTML("afterbegin",
    `<input type='hidden' name='game[player_one_id]' value='${this.currentUserIdValue}' autocomplete='off'></input>`)
  }

  inviteModal(data) {
    $('#inviteModal').modal('show');
    this.inviteContentTarget.innerText = `${data.player_one.username} invited you to a game!`
    this.playerOneId = data.player_one.id
    this.playerTwoId = data.player_two.id
    this.gameId = data.current_game_id
  }

  acceptInvite() {
    this.accepted = true;
  }

  triggeredByAccept(data) {
    fetch(`/games/${data.current_game_id}/invite_accepted`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ ready: this.accepted, player_one_id: data.player_one.id, player_two_id: data.player_two.id, game_id: data.current_game_id }),
    })
    this.preGameReadyModalTarget.style.display = "flex"
  }

  redirectInviter(data) {
    this.preGameReadyModalTarget.style.display = "flex"
  }

  rejectInvite() {
    // destroy game and redirect player one
  }

  dynamicWaitingContent(data) {
    document.querySelectorAll('#typed').forEach(function(el) {
      new Typed(el, {
        strings: [`Waiting for ${data.player_two.username}...`],
        loop: true,
        typeSpeed: 50,
        showCursor: false,
      })
    })
    this.playerOneId = data.player_one.id
    this.playerTwoId = data.player_two.id
    this.gameId = data.current_game_id
  }

  postReadyStatus(player_one_ready, player_two_ready) {
    fetch(`/games/${this.gameId}/user_ready_next_round`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ player_one_ready: player_one_ready, player_two_ready: player_two_ready, player_one: this.playerOneId, player_two: this.playerTwoId}),
    })
  }

  startGame() {
    if(this.currentUserIdValue == this.playerOneId){
      this.playerOneReadyValue = true
      this.postReadyStatus(this.playerOneReadyValue, this.playerTwoReadyValue)
    };
    if(this.currentUserIdValue == this.playerTwoId){
      this.playerTwoReadyValue = true
      this.postReadyStatus(this.playerOneReadyValue, this.playerTwoReadyValue)
    };
  }


  startGameStatus(data){
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
        this.preGameReadyModalTarget.style.display = "none";
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
        window.location.pathname = `/games/${this.gameId}`
      }, 5000);
    }
  }

}
