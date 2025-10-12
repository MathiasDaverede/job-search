<?php

namespace App\Entity\Person;

use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
class Sender extends Person
{
    #[ORM\Column(length: 20, nullable: true)]
    private ?string $phone = null;

    /**
     * @return string|null
     */
    public function getPhone(): ?string
    {
        return $this->phone;
    }

    /**
     * @param string|null $phone
     *
     * @return Sender
     */
    public function setPhone(?string $phone): static
    {
        $this->phone = $phone;

        return $this;
    }
}
