<?php

namespace App\Form\Type;

use App\Entity\CoverLetter;
use App\Form\Type\Person\RecipientType;
use App\Form\Type\Person\SenderType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class CoverLetterType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('sender', SenderType::class, ['label' => 'Expéditeur'])
            ->add('recipient', RecipientType::class, ['label' => 'Destinataire'])
            ->add('object', TextType::class, [
                'label' => 'Objet',
                'attr' => [
                    'placeholder' => 'Objet',
                ],
            ])
            ->add('letter', TextareaType::class, [
                'label' => 'Lettre',
                'attr' => [
                    'placeholder' => 'Lettre',
                ],
            ])
            ->add('save', SubmitType::class, [
                'label' => 'Enregistrer',
                'attr' => [
                    'class' => 'btn btn-outline-primary',
                ],
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => CoverLetter::class,
        ]);
    }
}
