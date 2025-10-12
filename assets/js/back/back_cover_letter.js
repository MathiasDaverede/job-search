import '../../styles/back/back_cover_letter.scss';
import { CopyButton } from './copy_button.js';

document.querySelectorAll('.btn-copy').forEach(button => {
    new CopyButton(button);
});
