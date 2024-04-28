import { Controller } from "@hotwired/stimulus"
import { Editor } from "@tiptap/core"
import StarterKit from "@tiptap/starter-kit"
import { Link } from "@tiptap/extension-link"
import { Image } from "@tiptap/extension-image"
import { TextAlign } from "@tiptap/extension-text-align"

export default class extends Controller {
  static targets = ["boldButton", "italicButton", "paragraphButton", "codeBlockButton"]

  connect() {
    const element = this.element.querySelector('.editor-content')

    this.hiddenField = this.element.querySelector(".hidden-content-field");
    const innerHTML = this.hiddenField.value;

    this.editor = new Editor({
      element: element,
      extensions: [
        StarterKit,
        Link,
        Image,
        TextAlign.configure({
          types: ['heading', 'paragraph', 'image'],
        }),
      ],
      content: innerHTML,
      autofocus: true,
      editable: true,
    })

    this.hiddenField.form.addEventListener('submit', event => this.formSubmit(event));

    // Update button states initially and on editor updates
    this.updateButtonStates();
    this.editor.on('selectionUpdate', () => this.updateButtonStates());
    this.editor.on('selectionUpdate', () => console.log(this.editor.getHTML()));
  }

  updateButtonStates() {
    this.boldButtonTarget.classList.toggle('editor-button--active', this.editor.isActive('bold'));
    this.italicButtonTarget.classList.toggle('editor-button--active', this.editor.isActive('italic'));
    this.paragraphButtonTarget.classList.toggle('editor-button--active', this.editor.isActive('paragraph'));
    this.codeBlockButtonTarget.classList.toggle('editor-button--active', this.editor.isActive('codeBlock'));
  }

  bold() {
    this.editor.chain().focus().toggleBold().run();
    this.updateButtonStates();
  }

  italic() {
    this.editor.chain().focus().toggleItalic().run();
    this.updateButtonStates();
  }

  h3() {
    this.editor.chain().focus().toggleHeading({level: 3}).run();
    this.updateButtonStates();
  }

  h4() {
    this.editor.chain().focus().toggleHeading({level: 4}).run();
    this.updateButtonStates();
  }

  h5() {
      this.editor.chain().focus().toggleHeading({level: 5}).run();
      this.updateButtonStates();
  }

  insertImage() {
    const url = prompt('Enter the URL of the image:');
    this.editor.chain().focus().setImage({ src: url }).run();
  }

  paragraph() {
    this.editor.chain().focus().setParagraph().run();
    this.updateButtonStates();
  }

  codeBlock() {
    this.editor.chain().focus().toggleCodeBlock().run();
    this.updateButtonStates();
  }

  left() {
    this.editor.chain().focus().setTextAlign('left').run();
  }

  center() {
    this.editor.chain().focus().setTextAlign('center').run();
  }

  right() {
    this.editor.chain().focus().setTextAlign('right').run();
  }

  formSubmit(event){
    event.preventDefault()
    event.stopPropagation()

    this.hiddenField.value = this.editor.getHTML()
    Turbo.navigator.submitForm(this.hiddenField.form)
  }

  disconnect() {
    this.editor.destroy()
  }
}
