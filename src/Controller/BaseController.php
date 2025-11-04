<?php

namespace App\Controller;

use App\Service\CoverLetterManager;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class BaseController extends AbstractController
{
    public function __construct(protected CoverLetterManager $coverLetterManager) {}
}
