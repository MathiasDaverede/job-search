<?php

namespace App\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Knp\Snappy\Pdf;

#[AsCommand(
    name: 'app:generate-pdf',
    description: 'Generate a Pdf to test in CI'
)]
class GeneratePdfCommand extends Command
{
    public const PDF_NAME = 'test.pdf';
    public const PDF_PATH = './' . self::PDF_NAME;
    public const SUCCESS_MESSAGE = 'Pdf generated successfully';

    public function __construct(private Pdf $snappy)
    {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $html = '<h1>Test Cover Letter</h1><p>Hello, world!</p>';
        $this->snappy->generateFromHtml($html, self::PDF_PATH);
        $output->writeln(self::SUCCESS_MESSAGE);

        return Command::SUCCESS;
    }
}
