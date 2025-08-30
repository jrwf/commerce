<?php

declare(strict_types=1);

namespace Drupal\woodym\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\webform\Entity\Webform;

/**
 * Returns responses for Woodym routes.
 */
final class ContactController extends ControllerBase {

  /**
   * Zobrazí stránku s kontaktním formulářem.
   */
  public function contactPage() {
    $webform = Webform::load('contact'); // Zkontroluj strojový název formuláře

    if (!$webform) {
      return [
        '#markup' => $this->t('Webformulář nebyl nalezen.'),
      ];
    }

    // Vygeneruje render array pro webform
    $form = \Drupal::entityTypeManager()
      ->getViewBuilder('webform')
      ->view($webform);

    return [
      '#theme' => 'woodym_contact_page', // Název vaší Twig šablony
      '#data' => [
        'contact_form'  => $form,
      ],
    ];
  }
}
