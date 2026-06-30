<?php

namespace App\Home\Controller;

use App\Home\Repository\UserRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class HomeController extends AbstractController {

    public function __construct(
        private readonly UserRepository $userRepository,
    ) {
    }

    #[Route('/', name: 'app_home')]
    public function index(): Response
    {
        return $this->render('Home/homeWrapper.html.twig', [
            'users' => $this->userRepository->findAll(),
        ]);
    }
}
