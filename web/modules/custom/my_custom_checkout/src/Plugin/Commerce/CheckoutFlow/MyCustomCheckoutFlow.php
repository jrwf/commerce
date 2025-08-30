<?php

// Cesta: /modules/custom/my_custom_checkout/src/Plugin/Commerce/CheckoutFlow/MyCustomCheckoutFlow.php

namespace Drupal\my_custom_checkout\Plugin\Commerce\CheckoutFlow;

use Drupal\commerce_checkout\Annotation\CommerceCheckoutFlow;
use Drupal\commerce_checkout\Plugin\Commerce\CheckoutFlow\CheckoutFlowWithPanesBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Poskytuje vlastní checkout flow s oddělenými kroky pro fakturaci a dopravu.
 *
 * @CommerceCheckoutFlow(
 *   id = "my_custom_flow",
 *   label = @Translation("Můj vlastní checkout proces")
 * )
 */
class MyCustomCheckoutFlow extends CheckoutFlowWithPanesBase {

  /**
   * {@inheritdoc}
   */
  public function getSteps() {
    return [
        // Krok 1: Přihlášení nebo pokračovat jako host
        'login' => [
          'id' => 'login',
          'label' => $this->t('Login'),
          'previous_label' => $this->t('Zpět do košíku'),
          'next_label' => $this->t('Pokračovat'),
        ],
        // Krok 2: Kontaktní a doručovací údaje
        'shipping' => [
          'id' => 'shipping',
          'label' => $this->t('Doručovací údaje'),
          'previous_label' => $this->t('Zpět k přihlášení'),
          'next_label' => $this->t('Vybrat platbu'),
          'has_sidebar' => TRUE,
        ],
        // Krok 3: Platba
        'payment' => [
          'id' => 'payment',
          'label' => $this->t('Platba'),
          'previous_label' => $this->t('Zpět k doručení'),
          'next_label' => $this->t('Zkontrolovat objednávku'),
          'has_sidebar' => TRUE,
        ],
        // Krok 4: Rekapitulace před odesláním
        'review' => [
          'id' => 'review',
          'label' => $this->t('Rekapitulace'),
          'previous_label' => $this->t('Zpět k platbě'),
          'next_label' => $this->t('Dokončit objednávku'),
          'has_sidebar' => TRUE,
        ],
        // Poslední krok (thank you) je zděděn z rodiče.
      ] + parent::getSteps();
  }

}
