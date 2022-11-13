import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="friends"
export default class extends Controller {
  static values = { currentUserId: Number }

  initialize() {
    this.token = document.getElementsByName("csrf-token")[0].content
  }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "FriendChannel", id: this.currentUserIdValue },
      { received: data => { console.log(data) } }
    )
  }

  checking(event) {
    fetch(`/users/${event.target.dataset.value}/send_game_invitation`)
  }
}
