import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="lp-cards"
export default class extends Controller {
  static targets = ["card"];
  connect() {
    console.log('lp-card connected')
  }

  changeOpacity() {
    const scroll = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;

    this.cardTargets.forEach((card) => {
      const distInView = card.getBoundingClientRect().top - window.innerHeight + 20;
      if (distInView < 0) {
        console.log(card)
        card.classList.add("inView");
    } else {
        card.classList.remove("inView");
    }
    })
  }
}
