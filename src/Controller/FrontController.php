<?php

namespace App\Controller;

use App\Constant\UsefulLink;
use Knp\Bundle\SnappyBundle\Snappy\Response\PdfResponse;
use Knp\Snappy\Pdf;
use Symfony\Component\HttpFoundation\Response;
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

    #[Route('/liens-utiles', name: 'front_useful_links')]
    public function usefulLinks(): Response
    {
        return $this->render('front/useful_links.html.twig', [
            // To show a different approach
            'devOpsLinks' => UsefulLink::getDevOpsLinks(),
        ]);
    }

    #[Route('/soutien', name: 'front_support_me')]
    public function supportMe(): Response
    {
        return $this->render('front/support_me.html.twig');
    }
}
