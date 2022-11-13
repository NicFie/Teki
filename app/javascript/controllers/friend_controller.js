import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="friend"
export default class extends Controller {
  static values = { currentUserId: Number }
  static targets = ["inviteContent", "inviteModal", "friendForm", "form"]


  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "FriendChannel", id: this.currentUserIdValue },
      { received: data => {
        console.log(data)
        this.inviteModal(data);
      } }
    )
  }

  checking(event) {
    this.formTarget.insertAdjacentHTML("afterbegin",
    `<input type='hidden' name='game[player_two_id]' value='${event.target.dataset.value}' autocomplete='off'></input>`)
    this.formTarget.insertAdjacentHTML("afterbegin",
    `<input type='hidden' name='game[player_one_id]' value='${this.currentUserIdValue}' autocomplete='off'></input>`)
    // fetch(`/users/${event.target.dataset.value}/send_game_invitation`)
  }

  inviteModal(data) {
    this.inviteModalTarget.style.display = "flex";
    this.inviteModalTarget.style.opacity = "1 !important";
    this.inviteContentTarget.innerText = `${data.inviter.username} invited you to a game!`
  }
}
