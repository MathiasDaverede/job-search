<?php

namespace App\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Knp\Snappy\Pdf;

#[AsCommand(name: 'app:generate-cover-letter')]
class GenerateCoverLetterCommand extends Command
{
    private $snappy;

    public function __construct(Pdf $snappy)
    {
        $this->snappy = $snappy;
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $html = '<h1>Test Cover Letter</h1><p>Hello, world!</p>';
        $this->snappy->generateFromHtml($html, 'test.pdf');
        $output->writeln('PDF generated');
        return Command::SUCCESS;
    }
}
