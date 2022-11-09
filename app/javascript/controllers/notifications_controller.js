import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notifications"
export default class extends Controller {
  static targets = ["dropdown"]
  connect() {
    console.log("notifications connected")
  }

  open() {
    this.dropdownTarget.classList.toggle("dropdownopen");
    console.log("opening dropdown")
  }
}
