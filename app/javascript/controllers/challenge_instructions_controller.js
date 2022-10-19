import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "content",
    "button",
    "description",
    "tests",
    "testsButton"
  ];
  connect() {}

  showTests(event) {
    this.descriptionTarget.classList.add("d-none");
    this.testsTarget.classList.remove("d-none");
    this.buttonTargets.forEach(button =>
      button.classList.remove("active")
    );
    this.testsButtonTarget.classList.add("active");
  }

  changeTab(event) {
    this.contentTargets.forEach(content =>
      content.classList.add("d-none")
      );
      this.buttonTargets.forEach(button =>
      button.classList.remove("active")
    );
    event.currentTarget.classList.add("active");
    if (event.currentTarget.id == "description") {
      this.descriptionTarget.classList.remove("d-none");
    } else {
      this.testsTarget.classList.remove("d-none");
    }
  }
}
