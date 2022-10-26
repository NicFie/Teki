import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core"
import { createConsumer } from "@rails/actioncable"
const codemirror = require("../codemirror/codemirror");


export default class extends Controller {
  static values = {
    gameId: Number,
    userId: Number,
    playerOneId: Number,
    playerTwoId: Number,
    loaded: Boolean,
    gameRoundMethod: String
  }

  static targets = [
    "editorone",
    "editortwo",
    "output",
    "solutions",
    "roundWinner",
    "roundWinnerModal",
    "roundWinnerModalContent",
    "roundWinnerCountp1",
    "roundWinnerCountp2",
    "gameWinner",
    "gameWinnerModal",
    "roundWinnerModalContent",
    "gameWinnerCountp1",
    "gameWinnerCountp2"
  ]

  initialize() {
    // defining the theme of codemirror depending on user
    let playerOneTheme = ''
    let playerTwoTheme = ''
    let playerOneRead = ''
    let playerTwoRead = ''
    this.token = document.getElementsByName("csrf-token")[0].content

    this.editor_one_code = ''
    if(this.playerOneIdValue == this.userIdValue) {
      playerOneTheme = "dracula";
      playerTwoTheme = "dracula_blurred";
      playerTwoRead = "nocursor";
    } else if(this.playerTwoIdValue == this.userIdValue) {
      playerOneTheme = "dracula_blurred";
      playerTwoTheme = "dracula";
      playerOneRead = "nocursor";
    }
    // Generating codemirror windows
    this.editor_one = codemirror.fromTextArea(
      this.editoroneTarget, {
        mode: "ruby",
        theme: playerOneTheme,
        lineNumbers: true,
        readOnly: playerOneRead
      }
    );
    this.editor_two = codemirror.fromTextArea(
      this.editortwoTarget, {
        mode: "ruby",
        theme: playerTwoTheme,
        lineNumbers: true,
        readOnly: playerTwoRead,
      }
    );

    // setting the challenge default method in codemirror windows
    this.editor_one.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
    this.editor_two.setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));

    setInterval(() => {
      fetch(`/games/${this.gameIdValue}/user_code`, {
        method: "POST",
        credentials: "same-origin",
        headers: {
          "X-CSRF-Token": this.token,
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      })
      .then((response) => response.json())
      .then(data => this.updatePlayerEditor(data))
    }, 2000);
  }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "GameChannel", id: this.gameIdValue },
      { received: data => {
        console.log(data);
        if(data.command == "update page") { this.updatePlayerOnePage() };
        if(data.command == "update round winner modal") { this.roundWinnerModalUpdate(data) };
        if(data.command == "update game winner modal") { this.gameWinnerModalUpdate(data) };
      } }
    )
    console.log(`Subscribe to the chatroom with the id ${this.gameIdValue}.`);
    console.log(`The current user is ${this.userIdValue}`);
    console.log(`Player one's current Id is ${this.playerOneIdValue}`)
    console.log(`Player two's current Id is ${this.playerTwoIdValue}`)

    // modal stuff
    const roundWinnerModal = document.getElementById("roundWinnerModal");
    const roundWinnerspan = document.getElementsByClassName("round-winner-modal-close")[0];
    roundWinnerspan.onclick = function() {
      roundWinnerModal.style.display = "none";
    }
    window.onclick = function(event) {
      if (event.target == roundWinnerModal) {
        roundWinnerModal.style.display = "none";
      }
    }
    const gameWinnerModal = document.getElementById("gameWinnerModal");
    const gameWinnerspan = document.getElementsByClassName("game-winner-modal-close")[0];
    gameWinnerspan.onclick = function() {
      gameWinnerModal.style.display = "none";
    }
    window.onclick = function(event) {
      if (event.target == gameWinnerModal) {
        gameWinnerModal.style.display = "none";
      }
    }

    //Checks default value of the game then updates
    //the game with correct user id's for player one and player two.
    if (this.playerOneIdValue === 1) {
      this.updatePlayerOneId()
    } else if (this.playerOneIdValue !== this.userIdValue && this.playerTwoIdValue !== this.userIdValue ) {
      this.updatePlayerTwoId()
    }
  }

  currentUsersEditor() {
    if(this.userIdValue == this.playerOneIdValue) {
      return this.editor_one
    } else {
      return this.editor_two
    }
  }

  //Creates a form and sends it to to the server to update the game,
  //changing players from the default 1 to the id of the player_one or player_two

  patchForm(form) {
    fetch(this.data.get("update-url"), {
      body: form,
      method: 'PATCH',
      credentials: "include",
      dataType: "script",
      headers: {
              "X-CSRF-Token": this.token
       },
    })
  }

  updatePlayerOneId() {
    let playerOnesForm = new FormData()
    playerOnesForm.append("game[player_one_id]", this.userIdValue)
    this.patchForm(playerOnesForm)
    // maybe use broadcast instead
    setTimeout(() => {
      this.updatePage()
    }, 300);
  }

  updatePlayerTwoId() {
    let playerTwosForm = new FormData()
    playerTwosForm.append("game[player_two_id]", this.userIdValue)
    this.patchForm(playerTwosForm)
    // maybe use broadcast instead
    setTimeout(() => {
      this.updatePage()
    }, 300);
  }

  updatePage() {
    location.reload()
  }

  updatePlayerOnePage() {
    if(this.loadedValue === false) {
      location.reload()
      this.loadedValue = true
    }
  }

  //updates code on the database as a player types then updates the view of player.
  playerOneOrTwo() {
    return ((this.userIdValue === this.playerOneIdValue) ? "one" : "two")
  }

  editorOneOrTwo() {
    return ((this.userIdValue === this.playerOneIdValue) ? this.editor_one : this.editor_two)
  }

  playerTyping() {
    let playerCodeForm = new FormData()
    playerCodeForm.append(`game[player_${this.playerOneOrTwo()}_code]`, this.editorOneOrTwo().getValue())
    this.patchForm(playerCodeForm)
  }

  updatePlayerEditor(data) {
    if(this.userIdValue === this.playerTwoIdValue) {
      this.editor_one.setValue(data.player_one)
    } else if (this.userIdValue === this.playerOneIdValue) {
      this.editor_two.setValue(data.player_two)
    }
  }

  // Code submissions and sendCode function
  clearPlayerSubmission() {
    this.editorOneOrTwo().setValue(this.gameRoundMethodValue.replaceAll('\\n', '\n'));
  }

  playerSubmission() {
    this.sendCode(this.editorOneOrTwo().getValue(), this.userIdValue);
  }

  sendCode(code, user_id) {
    fetch(`/games/${this.gameIdValue}/game_test`, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({ submission_code: code, user_id: user_id }),
    })
    .then((response) => response.json())
    .then(data => this.outputTarget.innerText = data.results)
  }


    roundWinnerModalUpdate(data) {
    if(data.round_winner.includes('wins')){
    this.roundWinnerTarget.innerText = data.round_winner;
    this.roundWinnerCountp1Target.innerText = `${data.p1_count}`;
    this.roundWinnerCountp2Target.innerText = `${data.p2_count}`;
    this.roundWinnerModalTarget.style.display = "block";
    }
  }

  nextRound() {
    this.updatePage();
  }

  gameWinnerModalUpdate(data) {
    if(data.round_winner.includes('wins')){
    this.gameWinnerTarget.innerText = `${data.game_winner} wins the game!!!`;
    this.gameWinnerCountp1Target.innerText = `${data.p1_count}`;
    this.gameWinnerCountp2Target.innerText = `${data.p2_count}`;
    this.gameWinnerModalTarget.style.display = "block";
    }
  }

  endGame() {
    this.updatePage()
  }

  disconnect() {
    console.log("Unsubscribed from the chatroom")
    this.channel.unsubscribe()
  }
}
