<?php

namespace App\Home\Entity;

use App\Home\Model\UserId;
use App\Home\Type\UserIdType;
use App\Shared\Persistence\Trait\TimestampableTrait;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\ORM\Mapping\Id;
use Doctrine\ORM\Mapping\Table;

#[Entity]
#[Table(name: 'User')]
class User {

    use TimestampableTrait;

    #[Id]
    #[Column(type: UserIdType::NAME)]
    #[GeneratedValue]
    private ?UserId $id = null;

    public function __construct(
        #[Column(type: Types::STRING)]
        private string $name,
    ) {
    }

    public function getName(): string {
        return $this->name;
    }
}
