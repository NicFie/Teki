import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "dashtabcontent",
    "dashtablink",
    "leaderboard",
    "friendslist",
  ];
  connect() {}

  changeTab(event) {
    this.dashtabcontentTargets.forEach(dashtabcontent =>
      dashtabcontent.classList.add("d-none")
    );
    this.dashtablinkTargets.forEach(dashtablink =>
      dashtablink.classList.remove("active")
    );
    event.currentTarget.classList.add("active");
    if (event.currentTarget.id === "leaderboard") {
      this.leaderboardTarget.classList.remove("d-none");
    } else {
      this.friendslistTarget.classList.remove("d-none");
    }
  }
}
