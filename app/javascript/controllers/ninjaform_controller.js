import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

// Connects to data-controller="ninjaform"
export default class extends Controller {
  static values = {
    withFriend: Boolean
  }

  static targets = [
    "form",
    "roundChoiceModal",
    "preGameModal",
    "preGameLoadingContent",
    "playerFoundMessage",
    "matchDetailsAndCountdown"
  ]

  connect() {
  }

  withFriend() {
    this.withFriendValue = true;
  }

  submitForm() {
    if (this.withFriendValue == true) {
      this.formTarget.submit();
      this.formTarget.removeChild(this.formTarget.firstElementChild);
      this.formTarget.removeChild(this.formTarget.firstElementChild);
      $('.modal-backdrop').remove();
      this.preGameModalTarget.style.display = "flex"
    } else {
      this.formTarget.submit();

    }
  }
}
