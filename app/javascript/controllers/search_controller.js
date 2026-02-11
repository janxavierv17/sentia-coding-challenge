import { Controller } from "@hotwired/stimulus";

// Debounced search controller.
// Submits the parent form after a 300ms pause in typing.
// This avoids hammering the server on every keystroke.
export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.timeout = null;
  }

  submit() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.element.requestSubmit();
    }, 300);
  }

  disconnect() {
    clearTimeout(this.timeout);
  }
}
