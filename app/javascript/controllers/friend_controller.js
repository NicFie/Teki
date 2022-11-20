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
  "Target",
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
  "playerTwoReady",
  "playerRejectedInvite",
  "typed"
  ]


  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "FriendChannel", id: this.currentUserIdValue },
      { received: data => {
        if(data.command == "invited player info") {
          this.inviteModal(data)
          console.log(data)
        };
        if(data.command == 'inviter info') {
          this.dynamicWaitingContent(data)
          console.log(data)
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
        if(data.command == 'player two rejects') {
          this.playerTwoRejected(data)
        };
        if(data.command == 'start game') {
          this.startGameStatus(data)
        };
        if(data.command == 'cancel invite') {
          this.endSearchPlayerTwo(data)
        }
      }}
    )
  }

  initialize() {
    this.token = document.getElementsByName("csrf-token")[0].content
    this.accepted = false;
  }

  updateGameForm(event) {
    // adds player_one params to game form
    this.formTarget.insertAdjacentHTML("afterbegin",
    `<input type='hidden' name='game[player_one_id]' id="playerOneIdData" value='${this.currentUserIdValue}' autocomplete='off'></input>`)
    // adds player_two params to game form
    this.formTarget.insertAdjacentHTML("afterbegin",
    `<input type='hidden' name='game[player_two_id]' id="playerTwoIdData" value='${event.target.dataset.value}' autocomplete='off'></input>`)
  }

  inviteModal(data) {
    $('#inviteModal').modal('show');
    $('.modal-backdrop').remove();
    this.inviteContentTarget.innerText = `${data.player_one.username} invited you to a game!`
    this.playerOneId = data.player_one.id
    this.playerTwoId = data.player_two.id
    this.gameId = data.current_game_id
  }

  acceptInvite() {
    this.accepted = true;
  }

  triggeredByAccept(data) {
    fetch(`/games/${data.current_game_id}/invite_response`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ accepted: this.accepted, player_one_id: data.player_one.id, player_two_id: data.player_two.id, game_id: data.current_game_id }),
    })
    $('#inviteModal').modal('hide');
    this.preGameReadyModalTarget.style.display = "flex"
    this.playerOneUsernameTarget.innerText = `${data.player_one.username}`
    this.playerOneAvatarTarget.innerHTML = `<img src="/assets/${data.player_one.avatar}">`
    this.playerTwoUsernameTarget.innerText = `${data.player_two.username}`
    this.playerTwoAvatarTarget.innerHTML = `<img src="/assets/${data.player_two.avatar}">`
  }

  rejectInvite() {
    $('#inviteModal').modal('hide');
    this.formTarget.reset()
    fetch(`/games/${this.gameId}/invite_response`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ rejected: true, player_one_id: this.playerOneId, player_two_id: this.playerTwoId }),
    })
  }

  playerTwoRejected(data) {
    this.playerRejectedInviteTarget.innerHTML = `<h1>${data.player_two_username} doesn't want to play right now :(</h1>`
    this.preGameLoadingContentTarget.style.display = "none"
    this.playerRejectedInviteTarget.style.display = 'flex'
    setTimeout(() => {
      this.preGameModalTarget.style.display = "none"
      this.preGameLoadingContentTarget.style.display = "flex"
      this.playerRejectedInviteTarget.style.display = 'none'
      $("#roundChoice").removeClass("show");
      this.formTarget.reset()
    }, 3000);
  }

  redirectInviter(data) {
    this.preGameModalTarget.style.display = "none"
    this.preGameReadyModalTarget.style.display = "flex"
    $("#roundChoice").removeClass("show");
  }

  endSearch() {
    this.preGameModalTarget.style.display = "none";
    $("#roundChoice").removeClass("show");
    this.formTarget.reset()
    document.querySelectorAll('#typed').forEach(function(al) {
      al.empty()
    })

    fetch(`/games/${this.gameId}/cancel_invite`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ cancel: 'cancel', player_two_id: this.playerTwoId }),
    })
  }

  endSearchPlayerTwo(data) {
    $('#inviteModal').modal('hide');
    this.formTarget.reset()
  }


  dynamicWaitingContent(info) {
    this.preGameLoadingContentTarget.removeChild(this.preGameLoadingContentTarget.children[0])
    this.preGameLoadingContentTarget.insertAdjacentHTML("afterbegin", '<h1 class="typed-loading" id="typed"></h1>')
    const typed = document.querySelector("#typed")
    new Typed(typed, {
      strings: [`Waiting for ${info.player_two.username}...`],
      loop: true,
      typeSpeed: 50,
      showCursor: false,
    })

    this.playerOneId = info.player_one.id
    this.playerTwoId = info.player_two.id
    this.gameId = info.current_game_id
    this.playerOneUsernameTarget.innerText = `${info.player_one.username}`
    this.playerOneAvatarTarget.innerHTML = `<img src="/assets/${info.player_one.avatar}">`
    this.playerTwoUsernameTarget.innerText = `${info.player_two.username}`
    this.playerTwoAvatarTarget.innerHTML = `<img src="/assets/${info.player_two.avatar}">`
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
        this.TargetTarget.style.display = "none";
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
        this.playerFoundMessageTarget.innerHTML = `<h1 class ="countdown-title">Round ${data.round_number}</h1><br><h1 class="go-animation">Go!</h1>`
      }, 4000);
      setTimeout(() => { //redirect
        window.location.pathname = `/games/${this.gameId}`
      }, 5000);
    }
  }

}
