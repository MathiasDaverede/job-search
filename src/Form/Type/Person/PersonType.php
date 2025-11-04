<?php

namespace App\Form\Type\Person;

use App\Entity\Person\Sender;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class PersonType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $addressOptions = [
            'label' => 'Adresse',
        ];

        if ($options['data_class'] === Sender::class) {
            $addressOptions['require_number'] = true;
            $addressOptions['require_line1'] = true;
            $addressOptions['require_postal_code'] = true;
            $addressOptions['require_city'] = true;
        }

        $builder
            ->add('firstName', TextType::class, [
                'label' => 'Prénom',
                'required' => $options['require_first_name'],
                'attr' => [
                    'placeholder' => 'Prénom',
                ],
            ])
            ->add('lastName', TextType::class, [
                'label' => 'Nom',
                'attr' => [
                    'placeholder' => 'Nom',
                ],
                'required' => $options['require_last_name'],
            ])
            ->add('address', AddressType::class, $addressOptions)
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'require_first_name' => false,
            'require_last_name' => false,
        ]);

        $resolver->setAllowedTypes('require_first_name', 'bool');
        $resolver->setAllowedTypes('require_last_name', 'bool');
    }
}
