<?php

namespace App\Form\Type\Person;

use App\Entity\Person\Address;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class AddressType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('number', TextType::class, [
                'label' => 'Numéro de voie',
                'attr' => [
                    'placeholder' => 'Numéro de voie',
                ],
                'required' => $options['require_number'],
            ])
            ->add('line1', TextType::class, [
                'label' => 'Ligne 1',
                'attr' => [
                    'placeholder' => 'Ligne 1',
                ],
                'required' => $options['require_line1'],
            ])
            ->add('line2', TextType::class, [
                'label' => 'Informations complémentaires',
                'attr' => [
                    'placeholder' => 'Informations complémentaires',
                ],
                'required' => false,
            ])
            ->add('postalCode', TextType::class, [
                'label' => 'Code postal',
                'attr' => [
                    'placeholder' => 'Code postal',
                ],
                'required' => $options['require_postal_code'],
            ])
            ->add('city', TextType::class, [
                'label' => 'Ville',
                'attr' => [
                    'placeholder' => 'Ville',
                ],
                'required' => $options['require_city'],
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => Address::class,
            'require_number' => false,
            'require_line1' => false,
            'require_postal_code' => false,
            'require_city' => false,
        ]);

        $resolver->setAllowedTypes('require_number', 'bool');
        $resolver->setAllowedTypes('require_line1', 'bool');
        $resolver->setAllowedTypes('require_postal_code', 'bool');
        $resolver->setAllowedTypes('require_city', 'bool');
    }
}
