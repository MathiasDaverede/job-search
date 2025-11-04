<?php

namespace App\Controller;

use Knp\Bundle\SnappyBundle\Snappy\Response\PdfResponse;
use Knp\Snappy\Pdf;
use Symfony\Component\Routing\Attribute\Route;

final class FrontController extends BaseController
{
    #[Route('/generer-pdf', name: 'front_generate_pdf')]
    public function generatePdf(Pdf $knpSnappyPdf): PdfResponse
    {
        $coverLetter = $this->coverLetterManager->getOne();
        $company = $coverLetter->getRecipient()->getCompany();

        $html = $this->renderView('front/cover_letter_template.html.twig', ['coverLetter' => $coverLetter]);

        return new PdfResponse(
            $knpSnappyPdf->getOutputFromHtml($html),
            $this->coverLetterManager->getPdfFileName($company),
            'application/pdf',
            'inline'
        );
    }
}
