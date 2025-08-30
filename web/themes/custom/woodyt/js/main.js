(function (Drupal, once) {
  'use strict';

  /**
   * Zpracovává logiku pro mobilní menu po kliknutí na burger ikonu.
   * @param {HTMLElement} burgerElement - Element, na který se váže událost (v tomto případě '.burger').
   */
  const handleMobileMenu = (burgerElement) => {
    // Najdeme globální element menu. Předpokládáme, že je na stránce pouze jedno.
    const mobileMenu = document.querySelector('.region-mobil-menu');

    // Pokud menu neexistuje, nic dalšího neděláme.
    if (!mobileMenu) {
      return;
    }

    // Přidáme posluchač události "kliknutí".
    burgerElement.addEventListener('click', (event) => {
      // Zabráníme výchozí akci, pokud by byl burger např. odkaz.
      event.preventDefault();
      // Přepne (přidá/odebere) třídu 'show' na elementu menu.
      mobileMenu.classList.toggle('show');
    });
  };

  /**
   * Drupal behavior pro inicializaci mobilního menu.
   */
  Drupal.behaviors.woodytMobileMenu = {
    attach: function (context) {
      // Najdeme všechny elementy '.burger' v daném kontextu (context)
      // a pomocí once() zajistíme, že se pro každý z nich kód provede jen jednou.
      const burgerElements = once('woodytMobileMenu', '.burger', context);
      // Pro každý nalezený burger element zavoláme naši funkci.
      burgerElements.forEach(handleMobileMenu);
    }
  };

}(Drupal, once));
