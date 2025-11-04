<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20251103233605 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE address (id INT AUTO_INCREMENT NOT NULL, number VARCHAR(10) DEFAULT NULL, line1 VARCHAR(100) DEFAULT NULL, line2 VARCHAR(100) DEFAULT NULL, postal_code VARCHAR(10) DEFAULT NULL, city VARCHAR(100) DEFAULT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE cover_letter (id INT AUTO_INCREMENT NOT NULL, sender_id INT NOT NULL, recipient_id INT DEFAULT NULL, object VARCHAR(100) NOT NULL, letter LONGTEXT NOT NULL, UNIQUE INDEX UNIQ_EBE6B47F624B39D (sender_id), UNIQUE INDEX UNIQ_EBE6B47E92F8F78 (recipient_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE person (id INT AUTO_INCREMENT NOT NULL, address_id INT DEFAULT NULL, first_name VARCHAR(50) DEFAULT NULL, last_name VARCHAR(100) DEFAULT NULL, type VARCHAR(255) NOT NULL, phone VARCHAR(20) DEFAULT NULL, gender VARCHAR(5) DEFAULT NULL, company VARCHAR(50) DEFAULT NULL, job VARCHAR(100) DEFAULT NULL, INDEX IDX_34DCD176F5B7AF75 (address_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('CREATE TABLE messenger_messages (id BIGINT AUTO_INCREMENT NOT NULL, body LONGTEXT NOT NULL, headers LONGTEXT NOT NULL, queue_name VARCHAR(190) NOT NULL, created_at DATETIME NOT NULL COMMENT \'(DC2Type:datetime_immutable)\', available_at DATETIME NOT NULL COMMENT \'(DC2Type:datetime_immutable)\', delivered_at DATETIME DEFAULT NULL COMMENT \'(DC2Type:datetime_immutable)\', INDEX IDX_75EA56E0FB7336F0 (queue_name), INDEX IDX_75EA56E0E3BD61CE (available_at), INDEX IDX_75EA56E016BA31DB (delivered_at), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB');
        $this->addSql('ALTER TABLE cover_letter ADD CONSTRAINT FK_EBE6B47F624B39D FOREIGN KEY (sender_id) REFERENCES person (id)');
        $this->addSql('ALTER TABLE cover_letter ADD CONSTRAINT FK_EBE6B47E92F8F78 FOREIGN KEY (recipient_id) REFERENCES person (id)');
        $this->addSql('ALTER TABLE person ADD CONSTRAINT FK_34DCD176F5B7AF75 FOREIGN KEY (address_id) REFERENCES address (id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE cover_letter DROP FOREIGN KEY FK_EBE6B47F624B39D');
        $this->addSql('ALTER TABLE cover_letter DROP FOREIGN KEY FK_EBE6B47E92F8F78');
        $this->addSql('ALTER TABLE person DROP FOREIGN KEY FK_34DCD176F5B7AF75');
        $this->addSql('DROP TABLE address');
        $this->addSql('DROP TABLE cover_letter');
        $this->addSql('DROP TABLE person');
        $this->addSql('DROP TABLE messenger_messages');
    }
}
