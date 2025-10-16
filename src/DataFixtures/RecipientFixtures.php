<?php

namespace App\DataFixtures;

use App\Entity\Person\Recipient;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class RecipientFixtures extends Fixture
{
    public const REFERENCE = 'recipient';

    public const FIRST_NAME = 'First name';
    public const LAST_NAME = 'Last name';

    public function load(ObjectManager $manager): void
    {
        $recipient = new Recipient();
        $recipient->setFirstName(self::FIRST_NAME);
        $recipient->setLastName(self::LAST_NAME);

        $manager->persist($recipient);
        $manager->flush();

        $this->addReference(self::REFERENCE, $recipient);
    }
}