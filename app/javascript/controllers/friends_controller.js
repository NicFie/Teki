import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="friends"
export default class extends Controller {
  static values = { currentId: Number, userId: Number, userName: String }

  initialize() {
    this.token = document.getElementsByName("csrf-token")[0].content
  }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "FriendsChannel", id: this.currentIdValue },
      { received: data => { if(data.command == "checking") { console.log(`Sending a message to ${this.userNameValue}`) };}
      }
    )
    console.log(`Current user is ${this.currentIdValue}`)
    console.log(`Friend ID is ${this.userIdValue}`)
  }

  checking(event) {
    // console.log(`New friend Id is ${event.target.dataset.value}`)
    fetch(`/users/${event.target.dataset.value}/send_game_invitation`)
  }
}
