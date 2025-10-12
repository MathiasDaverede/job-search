<?php

namespace App\Entity\Person;

use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
class Recipient extends Person
{
    public const GENDER_WOMAN = 'woman';
    public const GENDER_MAN = 'man';

    #[ORM\Column(length: 5, nullable: true)]
    private ?string $gender = null;

    #[ORM\Column(length: 50, nullable: true)]
    private ?string $company = null;

    #[ORM\Column(length: 100, nullable: true)]
    protected ?string $job = null;

    /**
     * @return string[]
     */
    public static function getGenders(): array
    {
        return [
            'Femme' => self::GENDER_WOMAN,
            'Homme' => self::GENDER_MAN,
        ];
    }

    /**
     * @return string|null
     */
    public function getGender(): ?string
    {
        return $this->gender;
    }

    /**
     * @param string|null $gender
     *
     * @return Recipient
     */
    public function setGender(?string $gender): static
    {
        $this->gender = $gender;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getCompany(): ?string
    {
        return $this->company;
    }

    /**
     * @param string|null $company
     *
     * @return Recipient
     */
    public function setCompany(?string $company): static
    {
        $this->company = $company;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getJob(): ?string
    {
        return $this->job;
    }

    /**
     * @param string|null $job
     *
     * @return Recipient
     */
    public function setJob(?string $job): static
    {
        $this->job = $job;

        return $this;
    }
}
