import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "content",
    "button",
    "description",
    "tests"
  ];
  connect() {}

  changeTab(event) {
    console.log(event.currentTarget);
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
