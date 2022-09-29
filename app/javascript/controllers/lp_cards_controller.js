import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="lp-cards"
export default class extends Controller {
  static targets = ["card"];
  connect() {
  }

  changeOpacity() {
      this.cardTargets.forEach((card) => {
      const distInView = card.getBoundingClientRect().top - window.innerHeight + 20;
      if (distInView < 0) {
        card.classList.add("inView");
    } else {
        card.classList.remove("inView");
    }
    })
  }
}
