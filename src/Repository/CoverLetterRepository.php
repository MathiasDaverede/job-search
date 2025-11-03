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
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, CoverLetter::class);
    }

    public function findOne(): ?CoverLetter
    {
        return $this->createQueryBuilder('cl')
            ->getQuery()
            ->getOneOrNullResult()
        ;
    }
}
