import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileInput", "submitButton"]

  connect() {
    this.updateButtonState()
  }

  fileChanged() {
    this.updateButtonState()
  }

  updateButtonState() {
    const file = this.fileInputTarget.files[0]
    const isValidCsv = file && file.type === "text/csv"
    
    this.submitButtonTarget.disabled = !isValidCsv
    
    if (isValidCsv) {
      this.submitButtonTarget.classList.remove("opacity-50", "cursor-not-allowed")
      this.submitButtonTarget.classList.add("cursor-pointer")
    } else {
      this.submitButtonTarget.classList.add("opacity-50", "cursor-not-allowed")
      this.submitButtonTarget.classList.remove("cursor-pointer")
    }
  }
}