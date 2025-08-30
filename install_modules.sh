#!/bin/bash

# admin_toolbar_tools
# admin_toolbar_links_access_filter
# admin_toolbar_search
# module_filter
# checklistapiexample

# Seznam standardních modulů k instalaci
MODULES=(
  # Administrace
  'drupal/module_filter:^5.0' # https://www.drupal.org/project/module_filter
  'drupal/admin_toolbar:^3.5' # https://www.drupal.org/project/admin_toolbar
  'drupal/coffee:^1.4' # https://www.drupal.org/project/coffee
  'drupal/paragraphs:^1.18' # https://www.drupal.org/project/paragraphs
  'drupal/dev_mode:^2.6' # https://www.drupal.org/project/dev_mode
  'drupal/google_tag' # https://www.drupal.org/project/google_tag
  # SEO
  'drupal/metatag:^2.0' # https://www.drupal.org/project/metatag
  'drupal/schema_metatag:^3.0' # https://www.drupal.org/project/schema_metatag
  'drupal/simple_sitemap:^4.2' # https://www.drupal.org/project/simple_sitemap
  'drupal/sitemap:^2.0' # https://www.drupal.org/project/sitemap
  'drupal/robotstxt:^1.6' # https://www.drupal.org/project/robotstxt
  'drupal/yoast_seo' # https://www.drupal.org/project/yoast_seo
  'drupal/easy_breadcrumb:^2.0' # https://www.drupal.org/project/easy_breadcrumb
  'drupal/pathauto:^1.13' # https://www.drupal.org/project/pathauto
  'drupal/redirect:^1.10' # https://www.drupal.org/project/redirect
  'drupal/search404' # https://www.drupal.org/project/search404
  'drupal/hreflang:^2.1' # https://www.drupal.org/project/hreflang
  'drupal/seo_checklist:^5.2' # https://www.drupal.org/project/seo_checklist
  'drupal/xmlsitemap' # https://www.drupal.org/project/xmlsitemap
  'drupal/editor_advanced_link' # https://www.drupal.org/project/editor_advanced_link
#  'drupal/linkchecker'
  # Ostatni
  'drupal/webform:^6.2' # https://www.drupal.org/project/webform
  'drupal/recaptcha:^3.4' # https://www.drupal.org/project/recaptcha
  'drupal/eu_cookie_compliance:^1.24' # https://www.drupal.org/project/eu_cookie_compliance
  'drupal/field_group:^3.6' # https://www.drupal.org/project/field_group
  'drupal/view_password:^6.0' # https://www.drupal.org/project/view_password
  # Views
  'drupal/views_slideshow:^5.0' # https://www.drupal.org/project/views_slideshow
#  'drupal/views_slideshow_cycle' # https://www.drupal.org/project/views_slideshow_cycle
  'drupal/views_bulk_operations:^4.2' # https://www.drupal.org/project/views_bulk_operations
  'drupal/views_data_export:^1.4' # https://www.drupal.org/project/views_data_export
  'drupal/draggableviews:^2.1' # https://www.drupal.org/project/draggableviews
  'drupal/views_conditional:^1.10' # https://www.drupal.org/project/views_conditional
  'drupal/views_infinite_scroll:^2.0' # https://www.drupal.org/project/views_infinite_scroll
  'drupal/better_exposed_filters:^7.0' # https://www.drupal.org/project/better_exposed_filters
  'drupal/views_accordion:^2.0' # https://www.drupal.org/project/views_accordion
  'drupal/calendar_view:^2.1' # https://www.drupal.org/project/calendar_view
)

# Seznam vývojových modulů k instalaci s --dev
DEV_MODULES=(
  'drupal/drush' # https://www.drupal.org/project/drush
  'drupal/devel' # https://www.drupal.org/project/devel
  'drupal/twig_tweak' # https://www.drupal.org/project/twig_tweak
  'drupal/backup_migrate' # https://www.drupal.org/project/backup_migrate
)

# Funkce pro instalaci a povolení modulů
install_and_enable() {
  local module=$1
  local dev_flag=$2

  # Instalace modulu pomocí Composeru, pokud ještě není nainstalován
  composer require $dev_flag "$module"

  # Získání názvu modulu bez předpony 'drupal/' nebo 'drush/'
  local module_name=$(echo "$module" | cut -d '/' -f 2)

  # Kontrola, zda je modul již povolen
  if ! vendor/bin/drush pm-list --type=module --status=enabled | grep -q "$module_name"; then
    # Pokud není modul povolen, povolí ho
    vendor/bin/drush pm-enable "$module_name" -y
  else
    echo "Modul $module_name je již povolen."
  fi
}

# Projít seznam standardních modulů a nainstalovat každý modul
for module in "${MODULES[@]}"
do
  install_and_enable "$module"
done

# Projít seznam vývojových modulů a nainstalovat každý modul s --dev
for dev_module in "${DEV_MODULES[@]}"
do
  install_and_enable "$dev_module" "--dev"
done
