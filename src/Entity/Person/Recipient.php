<?php

namespace App\Entity\Person;

use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
class Recipient extends Person
{
    #[ORM\Column(length: 5, nullable: true)]
    private ?string $gender = null;

    #[ORM\Column(length: 50, nullable: true)]
    private ?string $company = null;

    #[ORM\Column(length: 100, nullable: true)]
    protected ?string $job = null;

    public function getGender(): ?string
    {
        return $this->gender;
    }

    public function setGender(?string $gender): static
    {
        $this->gender = $gender;

        return $this;
    }

    public function getCompany(): ?string
    {
        return $this->company;
    }

    public function setCompany(?string $company): static
    {
        $this->company = $company;

        return $this;
    }

    public function getJob(): ?string
    {
        return $this->job;
    }

    public function setJob(?string $job): static
    {
        $this->job = $job;

        return $this;
    }
}
