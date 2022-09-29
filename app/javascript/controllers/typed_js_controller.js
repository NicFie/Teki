import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

// Connects to data-controller="typed-js"
export default class extends Controller {
  connect() {
    console.log('typed js connected')
    new Typed(this.element, {
      strings: ["Awesome h1 title", "Teki is awesome yayy"],
      typeSpeed: 50,
      loop: true
    })
  }
}
