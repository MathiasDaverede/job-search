<?php

namespace App\Twig;

use Exception;
use Twig\Extension\AbstractExtension;
use Twig\TwigFilter;

/**
 * Trick to convert scss files to css files in pdf's templates.
 */
class TemplateScssTrickExtension extends AbstractExtension
{
    /**
     * @see config/services.yaml
     */
    public function __construct(private string $env) {}

    public function getFilters(): array
    {
        return [
            new TwigFilter('scssTrick', [$this, 'scssToCssTrick']),
        ];
    }

    /**
     * @param string $assetRelativePath The asset relative path returned by Symfony Twig function {{ asset('path/to/css/file.scss') }}
     *
     * @throws Exception 
     */
    public function scssToCssTrick(string $assetRelativePath): string
    {
        $regex = '#/assets/(.*)/([^-]*)-(.*)\.css#';

        preg_match($regex, $assetRelativePath, $matches);

        if (!isset($matches[0])) {
            $message = "\n";
            $message .= "Trick to convert scss files to css files in pdf's templates.\n";
            $message .= "\"$assetRelativePath\" is not an asset,\n";
            $message .= "use it only with Symfony Twig function {{ asset('path/to/css/file.scss') }}.\n";
            $message .= "\n";
            $message .= "e.g.\n";
            $message .= "{% set someVar = asset('path/to/css/file.scss') %}\n";
            $message .= "\n";
            $message .= "<style>\n";
            $message .= "{{ someVar|scssTrick|raw }}\n";
            $message .= "</style>\n";

            throw new Exception($message);
        }

        /**
         * {{ asset('path/to/css/file.scss') }} return something like "/assets/styles/front/front_cover_letter_template-dnxOjLO.css"
         * But currently looking into project/public/assets/...
         * And we are in project/public/
         * 
         * dev : To make it work with bin/console sass:build --watch -v
         */
        if ($this->env === 'dev') {
            $fileName = $matches[2]; // Without extension
            $assetPath = "../var/sass/$fileName.output.css";
        } else {
            $assetPath  = str_replace('/assets/','assets/', $matches[0]);
        }

        if (!is_file($assetPath)) {
            throw new Exception("$assetPath is not a file");
        }

        return file_get_contents($assetPath);
    }
}
