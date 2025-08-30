/**
 * @file
 * AllenT behaviors.
 */
(function (Drupal) {

  'use strict';

  Drupal.behaviors.allent = {
    attach (context, settings) {

      console.log('It works!');

      // Mobile menu toggle functionality
      const burgerMenu = document.querySelector('.burger');
      if (burgerMenu) {
        burgerMenu.addEventListener('click', function() {
          const mobileMenu = document.querySelector('.region-mobil-menu');
          if (mobileMenu) {
            mobileMenu.classList.toggle('show');
          }
        });
      }

    }
  };

} (Drupal));
