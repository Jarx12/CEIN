import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // You must include "frame" here if you use this.frameTarget
  static targets = ["input", "frame"]

  // This runs on every keystroke
  filter() {
    // Replace any character that is not a digit with nothing
    this.inputTarget.value = this.inputTarget.value.replace(/[^\d]/g, "")
  }

  search() {
    const cedula = this.inputTarget.value
    const frameId = this.frameTarget.id // Capture 'representante_name' or 'representante_secundario_name'
    if (cedula.length < 5) return 

    this.frameTarget.src = `/representantes/preview?cedula=${cedula}&frame_id=${frameId}`
  }
  clear(event) {
    event.preventDefault() 
    this.inputTarget.value = "" 
    this.frameTarget.innerHTML = '<small class="text-muted">Ingrese cédula para verificar</small>'
    this.frameTarget.removeAttribute("src")
  }
}