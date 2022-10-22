import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core"
const codemirror = require("../codemirror/codemirror");
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = {
    gameId: Number,
    userId: Number,
    playerOneId: Number,
    playerTwoId: Number,
    loaded: Boolean,
    gameRoundMethod: String }
  static targets = ["editorone", "editortwo", "output", "solutions"]

  initialize() {
    // console.log(`player one user:${this.gamePlayerOneValue}`);
    // console.log(`player two user:${this.gamePlayerTwoValue}`);
    // console.log(`current user:${this.userIdValue}`);

    // defining the theme of codemirror depending on user
    let playerOneTheme = ''
    let playerTwoTheme = ''
    this.editor_one_code = ''
    if(this.playerOneIdValue == this.userIdValue) {
      playerOneTheme = "dracula";
      playerTwoTheme = "dracula_blurred";
    } else if(this.playerTwoIdValue == this.userIdValue) {
      playerOneTheme = "dracula_blurred";
      playerTwoTheme = "dracula";
    }
    // Generating codemirror windows
    this.editor_one = codemirror.fromTextArea(
      this.editoroneTarget, {
        mode: "ruby",
        theme: playerOneTheme,
        lineNumbers: true
      }
    );
    this.editor_two = codemirror.fromTextArea(
      this.editortwoTarget, {
        mode: "ruby",
        theme: playerTwoTheme,
        lineNumbers: true
      }
    );
    // setting the challenge default method in codemirror windows
    this.editor_one.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
    this.editor_two.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));

    setInterval(() => {
      console.log("refreshing")
      const token = document.getElementsByName("csrf-token")[0].content
      fetch(`/games/${this.gameIdValue}/user_code`, {
        method: "POST",
        credentials: "same-origin",
        headers: {
          "X-CSRF-Token": token,
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      })
      .then((response) => response.json())
      .then(data => console.log(data))
    }, 2000);
  }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "GameChannel", id: this.gameIdValue },
      { received: data => { if(data == "update page") { this.updatePlayerOnePage() } } }
    )
    console.log(`Subscribe to the chatroom with the id ${this.gameIdValue}.`);
    console.log(`The current user is ${this.userIdValue}`);
    console.log(`Player one's current Id is ${this.playerOneIdValue}`)
    console.log(`Player two's current Id is ${this.playerTwoIdValue}`)
    //Checks default value of the game then updates
    //the game with correct user id's for player one and player two.

    if (this.playerOneIdValue === 1) {
      this.updatePlayerOneId()
    } else if (this.playerOneIdValue !== this.userIdValue && this.playerTwoIdValue !== this.userIdValue ) {
      this.updatePlayerTwoId()
    }
    // this.editorOneRefresh()
  }



  updatePlayerOneId() {
    //Creates a form and sends it to to the server to update the game,
    //changing player_one_id from the default 1 to the id of the first user

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
    this.updatePage()
  }

  updatePlayerTwoId() {
    //Creates a form and sends it to to the server to update the game,
    //changing player_two_id from the default 1 to the id of the second user

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

    this.updatePage()

    // console.log(`Player two's new id is ${this.playerTwoIdValue}`)
  }

  updatePage() {
    location.reload()
    // this.data.get("loaded") = true
  }

  updatePlayerOnePage() {
    // console.log(this.loadedValue)
    if(this.loadedValue === false) {
      location.reload()
      this.loadedValue = true
    }


    // console.log(this.loadedValue)
    console.log(this.editor_one.getValue())
  }

  clearPlayerOneSubmission(){
    this.editor_one.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
  }
  clearPlayerTwoSubmission(){
    this.editor_two.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
  }

  playerOneSubmission() {
    this.sendCode(this.editor_one.getValue());
  }
  playerTwoSubmission() {
    this.sendCode(this.editor_two.getValue());
  }

  sendCode(code) {
    const token = document.getElementsByName("csrf-token")[0].content
    fetch(`/games/${this.gameIdValue}/game_test`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ player_one_code: code }),
    })
    .then((response) => response.json())
    .then(data => this.outputTarget.innerText = data)
  }

  //This bit gets whatever the user types!

  editorOneRefresh(data) {
    let playerOneCodeForm = new FormData()
    playerOneCodeForm.append("game[player_one_code]", data)
    const token = document.getElementsByName("csrf-token")[0].content

    fetch(this.data.get("update-url"), {
      body: playerOneCodeForm,
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
  }

  playerOneTyping() {
    // console.log(this.editor_one.getValue())
    const token = document.getElementsByName("csrf-token")[0].content
    fetch(`/games/${this.gameIdValue}/update_display`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ player_one_code: this.editor_one.getValue() }),
    })
    .then((response) => response.json())
    .then(data => this.editorOneRefresh(data))
  }

  // { if (this.userIdValue !== this.playerOneIdValue) {this.editor_one.setValue(data) }}

  // playerTwoTyping() {
  //   console.log(this.editor_two.getValue())
  // }
}
