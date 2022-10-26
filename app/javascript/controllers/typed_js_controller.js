import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

// Connects to data-controller="typed-js"
export default class extends Controller {
  connect() {
    console.log('typed js connected')
    new Typed(this.element, {
      strings: ["Teki for techies", "Challenge others in coding battles"],
      typeSpeed: 50,
      loop: true
    })
  }
}
