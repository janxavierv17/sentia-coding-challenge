import { Controller } from "@hotwired/stimulus"

//#region file-import
export default class extends Controller {
  static targets = ["fileInput", "submitButton", "spinner", "buttonText"]

  connect() {
    this.updateButtonState()
  }

  fileChanged() {
    this.updateButtonState()
  }

  submit() {
    this.submitButtonTarget.disabled = true
    this.submitButtonTarget.classList.add("opacity-75", "cursor-not-allowed")
    this.spinnerTarget.classList.remove("hidden")
    this.buttonTextTarget.textContent = "Importing..."
  }

  updateButtonState() {
    const file = this.fileInputTarget.files[0]
    const isValidCsv = file && (file.type === "text/csv" || file.name.endsWith(".csv"))
    
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
//#endregion