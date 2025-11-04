import '../../styles/back/back_cover_letter.scss';

import { Tooltip } from 'bootstrap';
import { CopyButton } from './copy_button.js';

/**
 * Executes code after the initial page load and after every Turbo navigation
 * (e.g., form submission via POST-Redirect-GET or link click).
 * This is essential for re-initializing JavaScript components that interact with the DOM,
 * as Turbo replaces the <body> content without triggering a full page reload or DOMContentLoaded.
 */
document.addEventListener('turbo:load', () => {
    const tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    [...tooltips].map(tooltipElement => new Tooltip(tooltipElement));
    
    document.getElementById('btn-generate-pdf').addEventListener('click', (event) => {
        const button = event.currentTarget;
        const pdfUrl = button.dataset.pdfUrl;

        window.open(pdfUrl, '_blank');
    });

    document.querySelectorAll('.btn-copy').forEach(button => {
        new CopyButton(button);
    });
});
