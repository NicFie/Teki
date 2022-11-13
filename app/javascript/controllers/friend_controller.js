import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="friend"
export default class extends Controller {
  static values = { currentUserId: Number }

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
