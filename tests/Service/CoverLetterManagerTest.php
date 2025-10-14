<?php

namespace App\Service;

use App\DataFixtures\CoverLetterFixtures;
use App\DataFixtures\RecipientFixtures;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;

class CoverLetterManagerTest extends KernelTestCase
{
    private EntityManagerInterface $entityManager;
    private CoverLetterManager $coverLetterManager;

    public function testGetOne(): void
    {
        $coverLetter = $this->coverLetterManager->getOne();
        $recipient = $coverLetter->getRecipient();

        $this->assertEquals(RecipientFixtures::FIRST_NAME, $recipient->getFirstName());
        $this->assertEquals(RecipientFixtures::LAST_NAME, $recipient->getLastName());
        $this->assertEquals(CoverLetterFixtures::OBJECT, $coverLetter->getObject());
        $this->assertEquals(CoverLetterFixtures::LETTER, $coverLetter->getLetter());
    }

    public function testDeleteRecipient(): void
    {
        $this->coverLetterManager->deleteRecipient();
        $coverLetter = $this->coverLetterManager->getOne();

        $this->assertEquals(null, $coverLetter->getRecipient());
    }

    protected function setUp(): void
    {
        parent::setUp();
        self::bootKernel();
        $container = static::getContainer();
        $this->entityManager = $container->get(EntityManagerInterface::class);
        $this->coverLetterManager = $container->get(CoverLetterManager::class);
        $this->entityManager->beginTransaction();
    }

    protected function tearDown(): void
    {
        $this->entityManager->rollback();
        $this->entityManager->close();
        parent::tearDown();
    }
}
