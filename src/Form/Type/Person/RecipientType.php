<?php

namespace App\Form\Type\Person;

use App\Entity\Person\Recipient;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class RecipientType extends PersonType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        parent::buildForm($builder, $options);

        $builder
            ->add('gender', ChoiceType::class, [
                'label' => 'Genre',
                'choices' => Recipient::getGenders(),
            ])
            ->add('company', TextType::class, [
                'label' => 'Entreprise',
                'attr' => [
                    'placeholder' => 'Entreprise',
                ],
            ])
            ->add('job', TextType::class, [
                'label' => 'Poste',
                'attr' => [
                    'placeholder' => 'Poste',
                ],
                'required' => false,
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        parent::configureOptions($resolver);

        $resolver->setDefaults([
            'data_class' => Recipient::class,
        ]);
    }
}
