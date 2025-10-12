<?php

namespace App\Entity\Person;

use App\Repository\AddressRepository;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: AddressRepository::class)]
class Address
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 10, nullable: true)]
    private ?string $number = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $line1 = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $line2 = null;

    #[ORM\Column(length: 10, nullable: true)]
    private ?string $postalCode = null;

    #[ORM\Column(length: 100, nullable: true)]
    private ?string $city = null;

    /**
     * @return int|null
     */
    public function getId(): ?int
    {
        return $this->id;
    }

    /**
     * @return string|null
     */
    public function getNumber(): ?string
    {
        return $this->number;
    }

    /**
     * @param string $number
     *
     * @return Address
     */
    public function setNumber(string $number): static
    {
        $this->number = $number;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getLine1(): ?string
    {
        return $this->line1;
    }

    /**
     * @param string $line1
     *
     * @return Address
     */
    public function setLine1(string $line1): static
    {
        $this->line1 = $line1;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getLine2(): ?string
    {
        return $this->line2;
    }

    /**
     * @param string|null $line2
     *
     * @return Address
     */
    public function setLine2(?string $line2): static
    {
        $this->line2 = $line2;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getPostalCode(): ?string
    {
        return $this->postalCode;
    }

    /**
     * @param string $postalCode
     *
     * @return Address
     */
    public function setPostalCode(string $postalCode): static
    {
        $this->postalCode = $postalCode;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getCity(): ?string
    {
        return $this->city;
    }

    /**
     * @param string $city
     *
     * @return Address
     */
    public function setCity(string $city): static
    {
        $this->city = $city;

        return $this;
    }
}
