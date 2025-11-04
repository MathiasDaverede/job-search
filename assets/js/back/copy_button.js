export class CopyButton {
    /**
     * @param {HTMLElement} button
     */
    constructor(button) {
        this.button = button;
        this.originalContent = button.innerHTML;

        this.initEventListeners();
    }

    initEventListeners() {
        this.button.addEventListener('click', () => this.handleCopy());
        this.button.addEventListener('mouseleave', () => this.handleMouseLeave());
    }

    handleCopy() {
        const textToCopy = this.button.parentElement.querySelector("span").textContent;

        navigator.clipboard.writeText(textToCopy).then(() => {
            this.button.innerHTML = 'Copié !';
        }).catch(err => {
            console.error('Erreur lors de la copie :', err);
        });
    }

    handleMouseLeave() {
        this.button.innerHTML = this.originalContent;
    }
}
