<?php

namespace App\Tests\Command;

use App\Command\GeneratePdfCommand;
use Symfony\Bundle\FrameworkBundle\Console\Application;
use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Tester\CommandTester;
use Symfony\Component\Filesystem\Filesystem;

class GeneratePdfCommandTest extends KernelTestCase
{
    private Filesystem $filesystem;

    public function testExecute(): void
    {
        $kernel = self::bootKernel();
        $application = new Application($kernel);

        $command = $application->find('app:generate-pdf');
        $commandTester = new CommandTester($command);

        $commandTester->execute([]);
        $output = $commandTester->getDisplay();

        $this->assertEquals(Command::SUCCESS, $commandTester->getStatusCode());
        $this->assertStringContainsString(GeneratePdfCommand::SUCCESS_MESSAGE, $output);
        $this->assertFileExists(GeneratePdfCommand::PDF_PATH);
    }

    protected function setUp(): void
    {
        parent::setUp();
        self::bootKernel();
        $container = static::getContainer();
        $this->filesystem = $container->get(Filesystem::class);
    }

    protected function tearDown(): void
    {
        $this->filesystem->remove(GeneratePdfCommand::PDF_PATH);
        parent::tearDown();
    }
}
