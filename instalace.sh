#!/bin/bash

# Instalace základního Drupalu
echo "Instaluji základní Drupal..."
drush site-install standard --account-name=admin --account-pass=admin --db-url=mysql://root:root@database/drupal -y

drush en -y jw module_filter admin_toolbar admin_toolbar_tools admin_toolbar_search inline_form_errors phpass syslog ctools ctools_views backup_migrate checklistapi editor_advanced_link pathauto redirect token twig_tweak view_password jquery_ui_accordion paragraphs field_group metatag metatag_open_graph metatag_views better_exposed_filters draggableviews views_bulk_operations views_conditional views_data_export views_infinite_scroll views_slideshow views_slideshow_cycle actions_permissions devel mail_login coffee

CONFIG_DIR="./web/config/sync"

OLD_UUID=ef40a25e-805a-406e-97ae-fca2f7c959eb

NEW_UUID=$(drush cget system.site uuid --format=string)

if [ -z "$OLD_UUID" ]; then
  echo "Nepodařilo se načíst původní UUID, zkontroluj system.site.yml!"
  exit 1
fi

echo "Staré UUID: $OLD_UUID"
echo "Nové UUID: $NEW_UUID"

grep -rl "$OLD_UUID" "$CONFIG_DIR" | xargs sed -i "s/$OLD_UUID/$NEW_UUID/g"

echo "UUID aktualizováno."

echo "Mažu existující shortcut sady..."
drush entity:delete shortcut_set -y

echo "Odinstalovávám shortcut modul..."
drush pmu shortcut -y

echo "Importuji konfiguraci..."
drush cim -y

echo "Znovu instaluji shortcut..."
drush en shortcut -y

echo "Instalace a import dokončen."
