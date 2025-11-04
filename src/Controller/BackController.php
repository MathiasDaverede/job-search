<?php

namespace App\Controller;

use App\Entity\CoverLetter;
use App\Form\Type\CoverLetterType;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class BackController extends BaseController
{
    #[Route('/lettre-de-motivation', name: 'back_cover_letter')]
    public function coverLetter(Request $request): Response|RedirectResponse
    {
        $coverLetter = $this->coverLetterManager->getOne();

        $form = $this->createForm(CoverLetterType::class, $coverLetter);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->coverLetterManager->save($form->getData());

            $this->addFlash(
                'notice',
                'Vos modifications ont bien été enregistrées!'
            );

            return $this->redirectToRoute('back_cover_letter');
        }

        return $this->render('back/cover_letter/cover_letter.html.twig', [
            'form' => $form,
        ]);
    }

    #[Route('/lettre-de-motivation/supprimer-destinataire', name: 'back_cover_letter_delete_recipient')]
    public function deleteRecipient(Request $request): RedirectResponse
    {
        $this->coverLetterManager->deleteRecipient();

        $this->addFlash(
            'notice',
            'Le destinataire a bien été supprimé!'
        );

        return $this->redirectToRoute('back_cover_letter');
    }
}
