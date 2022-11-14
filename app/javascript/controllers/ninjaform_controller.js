import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ninjaform"
export default class extends Controller {
  static targets = ["form", "withFriendForm"]
  connect() {
    console.log("ninja-form connected")
  }

  submitForm() {
    this.formTarget.submit();
  }
  // submitFriendForm() {
  //   this.withFriendFormTarget.submit();
  // }

}
