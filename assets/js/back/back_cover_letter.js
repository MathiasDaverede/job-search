import '../../styles/back/back_cover_letter.scss';

import { CopyButton } from './copy_button.js';

/**
 * Executes code after the initial page load and after every Turbo navigation
 * (e.g., form submission via POST-Redirect-GET or link click).
 * This is essential for re-initializing JavaScript components that interact with the DOM,
 * as Turbo replaces the <body> content without triggering a full page reload or DOMContentLoaded.
 */
document.addEventListener('turbo:load', () => {
    document.querySelectorAll('.btn-copy').forEach(button => {
        new CopyButton(button);
    });
});
