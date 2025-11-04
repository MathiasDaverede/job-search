<?php

namespace App\Twig;

use Twig\Extension\AbstractExtension;
use Twig\TwigFilter;

/**
 * To get file content (currently only to display VERSION.md content)
 */
class FilePathExtension extends AbstractExtension
{
    public function getFilters(): array
    {
        return [
            new TwigFilter('content', [$this, 'getContent']),
        ];
    }

    public function getContent(string $filePath): string
    {
        if (!is_file($filePath)) {
            return "$filePath is not a file";
        }

        return file_get_contents($filePath);
    }
}
