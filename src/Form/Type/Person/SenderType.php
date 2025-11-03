<?php

namespace App\Form\Type\Person;

use App\Entity\Person\Sender;
use Symfony\Component\Form\Extension\Core\Type\TelType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class SenderType extends PersonType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $options['require_first_name'] = true;
        $options['require_last_name'] = true;

        parent::buildForm($builder, $options);

        $builder
            ->add('phone', TelType::class, [
                'label' => 'Numéro de téléphone',
                'attr' => [
                    'placeholder' => 'Numéro de téléphone',
                ],
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        parent::configureOptions($resolver);

        $resolver->setDefaults([
            'data_class' => Sender::class,
        ]);
    }
}
