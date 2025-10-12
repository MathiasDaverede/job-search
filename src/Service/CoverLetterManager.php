<?php

namespace App\Service;

use App\Entity\CoverLetter;
use App\Repository\CoverLetterRepository;
use Doctrine\ORM\EntityManagerInterface;

class CoverLetterManager
{
    /**
     * @param EntityManagerInterface $entityManager
     * @param CoverLetterRepository  $repository
     */
    public function __construct(
        private EntityManagerInterface $entityManager,
        private CoverLetterRepository $repository
    ) {}

    /**
     * @return CoverLetter|null
     */
    public function getOne(): ?CoverLetter
    {
        return $this->repository->findOne();
    }

    /**
     * @param CoverLetter $coverLetter
     */
    public function save(CoverLetter $coverLetter): void
    {
        if (!$this->entityManager->contains($coverLetter)) {
            $this->entityManager->persist($coverLetter);
        }

        $this->entityManager->flush();
    }

    /**
     * Delete the recipient,
     * to quickly add a new one.
     */
    public function deleteRecipient(): void
    {
        $coverLetter = $this->getOne();
        $recipient = $coverLetter->getRecipient();

        $coverLetter->setRecipient(null);
        $this->entityManager->remove($recipient);

        $this->entityManager->flush();
    }
}
