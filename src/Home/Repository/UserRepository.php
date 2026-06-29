<?php

namespace App\Home\Repository;

use App\Home\Entity\User;
use Doctrine\ORM\EntityManagerInterface;

class UserRepository
{
    public function __construct(
        private readonly EntityManagerInterface $entityManager,
    ) {
    }

    public function findAll(): array
    {
        return $this->entityManager->createQueryBuilder()
            ->select('User')
            ->from(User::class, 'User')
            ->getQuery()
            ->getResult();
    }
}
