import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notifications"
export default class extends Controller {
  static targets = ["dropdown", "navbarDropdown"]
  connect() {
    console.log("notifications connected")
  }

  open() {
    this.dropdownTarget.classList.toggle("dropdownopen");
  }

  checkModals() {
    if (this.navbarDropdownTarget.classList.contains('show')) {
      this.dropdownTarget.classList.remove("dropdownopen");
    }
  }
}
