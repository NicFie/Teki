import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="friend"
export default class extends Controller {
  static values = { currentUserId: Number,
  gameRoundNumber: Number}
  static targets = ["inviteContent",
  "inviteModal",
  "form",
  "preGameModal",
  "preGameLoadingContent",
  "playerFoundMessage",
  "matchDetailsAndCountdown"]


  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "FriendChannel", id: this.currentUserIdValue },
      { received: data => {
        console.log(data)
        if(data.command == "invite") { this.inviteModal(data) };
        setInterval(() => {
          if(this.accepted == true) { this.triggeredByAccept(data) };
          this.accepted = false;
        }, 500);
        if(data.ready) {
          this.redirectInviter(data)
          console.log('data for inviter received')
        };
      } }
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
    this.inviteContentTarget.innerText = `${data.notification} invited you to a game!`
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
      body: JSON.stringify({ ready: this.accepted, player: data.player_one_id, game_id: data.current_game_id }),
    })
    window.location.pathname = `/games/${data.current_game_id}`
    // trigger game starting modal
  }

  redirectInviter(data) {
    window.location.pathname = `/games/${data.game_id}`
    // trigger game starting modal
  }

  startGameUserUpdate() {
    this.preGameModalTarget.style.display = "flex"
    this.preGameLoadingContentTarget.style.display = "none"
    this.playerFoundMessageTarget.style.display = "flex"
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
    }, 7000);
  }

  rejectInvite() {
    // destroy game and redirect player one
  }
}
