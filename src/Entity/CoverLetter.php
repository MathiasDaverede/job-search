<?php

namespace App\Entity;

use App\Entity\Person\Recipient;
use App\Entity\Person\Sender;
use App\Repository\CoverLetterRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: CoverLetterRepository::class)]
class CoverLetter
{
    public const MARKER_MADAM_MISTER_DEFAULT = 'Madame, Monsieur';
    public const MARKER_MADAM_MISTER = '[MADAME_MONSIEUR]';
    public const MARKER_COMPANY = '[ENTREPRISE]';

    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\OneToOne(cascade: ['persist', 'remove'])]
    #[ORM\JoinColumn(nullable: false)]
    private ?Sender $sender = null;

    #[ORM\OneToOne(cascade: ['persist', 'remove'])]
    private ?Recipient $recipient = null;

    #[ORM\Column(length: 100)]
    private ?string $object = null;

    #[ORM\Column(type: Types::TEXT)]
    private ?string $letter = null;

    /**
     * @return int|null
     */
    public function getId(): ?int
    {
        return $this->id;
    }

    /**
     * @return Sender|null
     */
    public function getSender(): ?Sender
    {
        return $this->sender;
    }

    /**
     * @param Sender $sender
     *
     * @return CoverLetter
     */
    public function setSender(Sender $sender): static
    {
        $this->sender = $sender;

        return $this;
    }

    /**
     * @return Recipient|null
     */
    public function getRecipient(): ?Recipient
    {
        return $this->recipient;
    }

    /**
     * @param Recipient|null $recipient
     *
     * @return CoverLetter
     */
    public function setRecipient(?Recipient $recipient): static
    {
        $this->recipient = $recipient;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getObject(): ?string
    {
        return $this->object;
    }

    /**
     * @param string $object
     *
     * @return CoverLetter
     */
    public function setObject(string $object): static
    {
        $this->object = $object;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getLetter(): ?string
    {
        return $this->letter;
    }

    /**
     * @param string $letter
     *
     * @return CoverLetter
     */
    public function setLetter(string $letter): static
    {
        $this->letter = $letter;

        return $this;
    }
}
