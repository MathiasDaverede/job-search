<?php

namespace App\Repository;

use App\Entity\CoverLetter;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<CoverLetter>
 */
class CoverLetterRepository extends ServiceEntityRepository
{
    /**
     * @param ManagerRegistry $registry
     */
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, CoverLetter::class);
    }

    /**
     * @return CoverLetter|null
     */
    public function findOne(): ?CoverLetter
    {
        return $this->createQueryBuilder('cl')
            ->getQuery()
            ->getOneOrNullResult()
        ;
    }
}
