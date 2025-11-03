<?php

namespace App\DataFixtures;

use App\Entity\Person\Sender;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class SenderFixtures extends Fixture
{
    public const REFERENCE = 'sender';

    public function load(ObjectManager $manager): void
    {
        $sender = new Sender();

        $manager->persist($sender);
        $manager->flush();

        $this->addReference(self::REFERENCE, $sender);
    }
}