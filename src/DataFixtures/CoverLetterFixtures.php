<?php

namespace App\DataFixtures;

use App\Entity\CoverLetter;
use App\Entity\Person\Recipient;
use App\Entity\Person\Sender;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Common\DataFixtures\DependentFixtureInterface;
use Doctrine\Persistence\ObjectManager;

class CoverLetterFixtures extends Fixture implements DependentFixtureInterface
{
    public const OBJECT = 'Object';
    public const LETTER = 'Letter';

    public function load(ObjectManager $manager): void
    {
        $coverLetter = new CoverLetter();

        $coverLetter->setSender($this->getReference(SenderFixtures::REFERENCE, Sender::class));
        $coverLetter->setRecipient($this->getReference(RecipientFixtures::REFERENCE, Recipient::class));
        $coverLetter->setObject(self::OBJECT);
        $coverLetter->setLetter(self::LETTER);

        $manager->persist($coverLetter);
        $manager->flush();
    }

    public function getDependencies(): array
    {
        return [
            SenderFixtures::class,
            RecipientFixtures::class,
        ];
    }
}