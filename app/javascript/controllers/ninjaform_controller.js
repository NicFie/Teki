import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ninjaform"
export default class extends Controller {
  static targets = ["form"]
  connect() {
    console.log("ninja-form connected")
  }

  submitForm() {
    this.formTarget.submit();
  }
}
