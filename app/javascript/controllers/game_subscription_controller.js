import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { gameId: Number, userId: Number }
  static targets = ["solutions", "editor-one"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "GameChannel", id: this.gameIdValue },
      { received: data => console.log(data) }
    )
    console.log(`Subscribe to the chatroom with the id ${this.gameIdValue}.`)
    console.log(`The current user is ${this.userIdValue}`)

  }

  printEditorOne() {
    console.log("testing editor");
    console.log(this.editor-oneTarget.value);
  }
}
