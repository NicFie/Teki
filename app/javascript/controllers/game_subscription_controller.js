import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { gameId: Number, userId: Number, playerOneId: Number, playerTwoId: Number }
  static targets = ["solutions"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "GameChannel", id: this.gameIdValue },
      { received: data => console.log(data) }
    )
    // console.log(`Subscribe to the chatroom with the id ${this.gameIdValue}.`)
    console.log(`Player one's current Id is ${this.playerOneIdValue}`)
    console.log(`Player two's current Id is ${this.playerTwoIdValue}`)


    if (this.playerOneIdValue === 1)
      this.checkPlayerOne()
    else {
      this.checkPlayerTwo()
    };
  }

  checkPlayerOne() {
    // console.log(`User id is ${this.userId}`)
    // console.log(`Player one's current ID is ${this.playerOneIdValue}`);
    let playerOnesForm = new FormData()
    playerOnesForm.append("game[player_one_id]", this.userIdValue)
    const token = document.getElementsByName("csrf-token")[0].content

    fetch(this.data.get("update-url"), {
      body: playerOnesForm,
      method: 'PATCH',
      credentials: "include",
      dataType: "script",
      headers: {
              "X-CSRF-Token": token
       },
    }).then(function(response) {
      if (response.status != 204) {
          console.log("This worked")
      }
    })

    // console.log(`Player one's new id is ${this.playerOneIdValue}`)
  }

  checkPlayerTwo() {
    // console.log(`User id is ${this.userId}`)
    // console.log(`Player Two's current ID is ${this.playerTwoIdValue}`);
    let playerTwosForm = new FormData()
    playerTwosForm.append("game[player_two_id]", this.userIdValue)
    const token = document.getElementsByName("csrf-token")[0].content

    fetch(this.data.get("update-url"), {
      body: playerTwosForm,
      method: 'PATCH',
      credentials: "include",
      dataType: "script",
      headers: {
              "X-CSRF-Token": token
       },
    }).then(function(response) {
      if (response.status != 204) {
          console.log("This worked")
      }
    })

    // console.log(`Player two's new id is ${this.playerTwoIdValue}`)
  }
}
