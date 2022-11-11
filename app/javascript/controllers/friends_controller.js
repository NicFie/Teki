import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="friends"
export default class extends Controller {
  static values = { userId: Number, userName: String }

  initialize() {
    this.token = document.getElementsByName("csrf-token")[0].content
  }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "FriendsChannel", id: this.userIdValue },
      { received: data => { if(data.command == "checking") { console.log(`Sending a message to ${this.userNameValue}`) };}
      }
    )
    // console.log(this.userIdValue)
  }

  checking() {
    // fetch(this.userIdValue).then(console.log(this.userIdValue))
    fetch(`/users/${this.userIdValue}/send_game_invitation`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    })
  }
}
