<?php

declare(strict_types=1);

/**
 * @file
 * Theme settings form for AllenT theme.
 */

use Drupal\Core\Form\FormState;

/**
 * Implements hook_form_system_theme_settings_alter().
 */
function allent_form_system_theme_settings_alter(array &$form, FormState $form_state): void {

  $form['allent'] = [
    '#type' => 'details',
    '#title' => t('AllenT'),
    '#open' => TRUE,
  ];

  $form['allent']['example'] = [
    '#type' => 'textfield',
    '#title' => t('Example'),
    '#default_value' => theme_get_setting('example'),
  ];

}
