<?php

namespace App\Constant;

class UsefulLink
{
    public const GITHUB_REPO = 'https://github.com/MathiasDaverede/job-search';
    public const GITHUB_CHANGELOG = self::GITHUB_REPO . '/blob/main/CHANGELOG.md';
    public const CODINGAME_PROFILE = 'https://www.codingame.com/profile/8ee16a3f95abdb6ba27dd653534e016e4923462';
    
    public const JOB_OFFERS = [
        'Indeed' => 'https://fr.indeed.com/',
        'LinkedIn' => 'https://www.linkedin.com/jobs/',
        'Welcome to the Jungle' => 'https://www.welcometothejungle.com/fr/jobs',
        'France Travail' => 'https://candidat.francetravail.fr/rechercheoffre/landing',
        'WeLoveDevs' => 'https://welovedevs.com/fr/app/jobs',
        'Jooble' => 'https://fr.jooble.org/',
        'Hellowork' => 'https://www.hellowork.com/fr-fr/',
        'Meteojob' => 'https://www.meteojob.com/jobs',
        'Apec' => 'https://www.apec.fr/parcourir-les-emplois.html',
    ];

    public const JOB_INTERVIEW_PREPARATION = [
        'CVBoost' => 'https://www.cvboost.co/',
        'SymfonyCasts' => 'https://symfonycasts.com/',
        'CadreEmploi' => 'https://www.cadremploi.fr/editorial/conseils/conseils-candidature/entretien-embauche/detail/article/les-20-questions-les-plus-courantes-en-entretien-dembauche.html',
        'Hellowork' => 'https://www.hellowork.com/fr-fr/outil/preparation-entretien.html',
        'France Travail' => 'https://www.francetravail.fr/candidat/vos-recherches/preparer-votre-candidature/entretien/entretien-embauche-pose-question.html',
        'Mon Campus' => 'https://www.mon-campus.fr/2025/06/16/questions-entretien-embauche-guide-complet-2025/',
        'Make my CV' => 'https://makemycv.fr/entretien-embauche',
    ];

    public const BACK = [
        'Symfony 7.3' => 'https://symfony.com/doc/7.3',
        'PHP' => 'https://www.php.net/manual/fr/',
        'Composer' => 'https://getcomposer.org/',
        'Packagist' => 'https://packagist.org/',
        'API PLATFORM' => 'https://api-platform.com/docs/symfony/',
        'PHPUnit' => 'https://phpunit.de/documentation.html',
        'PHPStan' => 'https://phpstan.org/',
        'Postman' => 'https://www.postman.com/',
        'Regular expressions 101' => 'https://regex101.com/',
    ];

    public const FRONT = [
        'NPM' => 'https://www.npmjs.com/',
        'JavaScript' => 'https://developer.mozilla.org/fr/docs/Web/JavaScript',
        'Twig 3' => 'https://twig.symfony.com/doc/3.x/',
        'Bootstrap 5.3' => 'https://getbootstrap.com/docs/5.3/getting-started/introduction/',
        'Fontawesome' => 'https://fontawesome.com/icons',
        'Flat UI colors' => 'https://flatuicolors.com/',
        'Coolors' => 'https://coolors.co/',
    ];

    public const COOL = [
        'songsterr' => 'https://www.songsterr.com/',
        'Duolingo' => 'https://fr.duolingo.com/',
        'Marmiton' => 'https://www.marmiton.org/',
        'Nasa' => 'https://www.nasa.gov/',
        'Atlas Obscura' => 'https://www.atlasobscura.com/',
    ];

    public const OTHER = [
        'Redis' => 'https://redis.io/',
        'Trello' => 'https://trello.com/fr',
        'Grok' => 'https://grok.com/chat',
        'ChatGPT' => 'https://chatgpt.com/',
        'Couleurs pour les echo Linux' => 'https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux',
        'oh my zsh' => 'https://ohmyz.sh/',
        'Xdebug' => 'https://xdebug.org/docs/',
        'Canva' => 'https://www.canva.com/fr_fr/',
    ];

    public const DEV_OPS = [
        'Conteneurs' => [
            'Docker' => 'https://docs.docker.com/',
            'Docker compose' => 'https://docs.docker.com/compose/',
            'Hub Docker' => 'https://hub.docker.com/',
            'Traefik' => 'https://traefik.io/traefik',
            'Portainer' => 'https://docs.portainer.io/',
            'Docker swarm' => 'https://docs.docker.com/engine/swarm/',
            'Kubernetes' => 'https://kubernetes.io/docs/home/',
        ],
        'CI/CD' => [
            'Github Actions' => 'https://github.com/features/actions',
            'GitLab CI' => 'https://docs.gitlab.com/ci/',
            'Jenkins' => 'https://www.jenkins.io/doc/',
        ],
        'Déploiement' => [
            'Déploiement Symfony' => 'https://symfony.com/doc/current/deployment.html',
            'Terraform' => 'https://developer.hashicorp.com/terraform/docs',
            'Ansible' => 'https://docs.ansible.com/ansible/latest/index.html',
        ],
        'Monitoring et Sécurité' => [
            'Prometheus' => 'https://prometheus.io/docs/introduction/overview/',
            'Grafana' => 'https://grafana.com/docs/grafana/latest/',
            'Sécurité Docker' => 'https://docs.docker.com/engine/security/',

        ],
        'Cloud Providers' => [
            'AWS' => 'https://aws.amazon.com/',
            'Google Cloud' => 'https://cloud.google.com/docs',
            'Azure' => 'https://learn.microsoft.com/en-us/azure/',
        ],
    ];

    /**
     * @return string[]
     */
    public static function getDevOpsLinks ()
    {
        return self::DEV_OPS;
    }
}
