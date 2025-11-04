<?php

namespace App\Twig;

use App\Entity\CoverLetter;
use App\Entity\Person\Recipient;
use DateTime;
use Twig\Extension\AbstractExtension;
use Twig\TwigFilter;

class CoverLetterExtension extends AbstractExtension
{
    private const ENGLISH_FRENCH_MONTHS = [
        'january' => 'janvier',
        'february' => 'février',
        'march' => 'mars',
        'april' => 'avril',
        'may' => 'mai',
        'june' => 'juin',
        'july' => 'juillet',
        'august' => 'août',
        'september' => 'septembre',
        'october' => 'octobre',
        'november' => 'novembre',
        'december' => 'décembre',
    ];

    /**
     * @return TwigFilter[]
     */
    public function getFilters(): array
    {
        return [
            new TwigFilter('fullName', [$this, 'getFullName']),
            new TwigFilter('forTheAttentionOf', [$this, 'forTheAttentionOf']),
            new TwigFilter('locationAndDate', [$this, 'getLocationAndDate']),
            new TwigFilter('letter', [$this, 'getLetter']),
        ];
    }

    /**
     * @param Sender|Recipient $person
     */
    public function getFullName($person): string
    {
        return $person->getFirstName() . ' ' . $person->getLastName();
    }

    public function forTheAttentionOf(CoverLetter $coverLetter): string
    {
        $madamMister = $this->getMadamMister($coverLetter);

        return "À l'attention de $madamMister";
    }

    public function getLocationAndDate(CoverLetter $coverLetter): string
    {
        $date = new DateTime();
        $englishMonth = strtolower($date->format('F'));
        $frenchMonth = self::ENGLISH_FRENCH_MONTHS[$englishMonth];

        $locationAndDate = $coverLetter->getSender()->getAddress()->getCity() . ', ';
        $locationAndDate .= 'le ' . $date->format('j') . ' ' . $frenchMonth . ' ' . $date->format('Y');

        return $locationAndDate;
    }

    public function getLetter(CoverLetter $coverLetter): string
    {
        $madamMister = $this->getMadamMister($coverLetter, false);

        $letter = str_replace(CoverLetter::MARKER_MADAM_MISTER, $madamMister, $coverLetter->getLetter());
        $recipient = $coverLetter->getRecipient();

        if (!is_null($recipient)) {
            $letter = str_replace(CoverLetter::MARKER_COMPANY, $recipient->getCompany(), $letter);
        }

        return $letter;
    }

    private function getMadamMister(CoverLetter $coverLetter, bool $withFirstName = true): string
    {
        $madamMister = CoverLetter::MARKER_MADAM_MISTER_DEFAULT;
        $recipient = $coverLetter->getRecipient();

        if (!is_null($recipient) && !is_null($recipient->getLastName())) {
            $madamMister = ($recipient->getGender() === Recipient::GENDER_WOMAN) ? 'Madame' : 'Monsieur';
            $madamMister .= ' ';

            if ($withFirstName && !is_null($recipient->getFirstName())) {
                $madamMister .= $this->getFullName($recipient);
            } else {
                $madamMister .= $recipient->getLastName();
            }
        }

        return $madamMister;
    }
}
