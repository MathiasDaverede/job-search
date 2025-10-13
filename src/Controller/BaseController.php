<?php

namespace App\Controller;

use App\Service\CoverLetterManager;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class BaseController extends AbstractController
{
    /**
     * @param CoverLetterManager $coverLetterManager 
     */
    public function __construct(protected CoverLetterManager $coverLetterManager) {}
}
