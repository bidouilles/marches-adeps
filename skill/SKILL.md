---
name: marches-adeps
description: Trouve la prochaine marche ADEPS (points verts, marches Adeps de la Fédération Wallonie-Bruxelles) près d'une adresse avec la commande `marches-adeps` — date, localité, distance, parcours (5-10-15-20 km), lieu de rendez-vous, horaires, organisateur, itinéraire. À utiliser quand l'utilisateur demande « la prochaine marche Adeps », « une marche ce dimanche près de chez moi », « points verts », « marche Adeps à côté de Wavre », « où marcher dimanche », ou parle de marches.sport-adeps.be. Use also for English requests like "next ADEPS walk near me".
---

# Marches ADEPS près d'une adresse

`marches-adeps` est une commande dans le PATH (`~/.local/bin`). Elle lit le
catalogue public https://marches.sport-adeps.be (sans compte ni clé), calcule
la distance à vol d'oiseau depuis l'adresse et garde les marches dans le rayon.

Si `command -v marches-adeps` ne trouve rien, lancer l'installation depuis le
dépôt qui contient ce skill (ce dossier est un lien vers `<dépôt>/skill`) :

```bash
sh "$(cd -P "<dossier de ce skill>" && cd .. && pwd)/install.sh"
```

## Adresse

Une adresse par défaut est enregistrée (`~/.config/marches-adeps/config.json`) :
c'est le domicile de l'utilisateur. Pour « près de chez moi », ne passer
**aucune** adresse. Pour un autre endroit, passer `--adresse "<rue, code postal
commune>"` (une commune seule suffit : `--adresse Wavre`). N'enregistrer une
nouvelle adresse par défaut (`--enregistrer`) que si l'utilisateur le demande.

## Commandes

```bash
marches-adeps                              # prochaine date avec des marches à ≤ 30 km
marches-adeps --adresse "Namur" -r 20      # autre point de départ, rayon 20 km
marches-adeps --date dimanche              # une date : dimanche, demain, 29/11, 2026-12-06
marches-adeps --toutes                     # toutes les dates publiées (≈ 5 semaines)
marches-adeps --trajet                     # + durée en voiture (OSRM)
marches-adeps --complet                    # + contact, remarques, landaus/PMR, carte IGN, lien itinéraire
marches-adeps --dates                      # dates publiées et nombre de marches
marches-adeps --json                       # sortie structurée (mêmes options)
```

Options utiles : `-n N` (marches max. par date, défaut 5), `--rapide` (sans
pages de détail : plus d'organisateur ni d'horaires), `--position LAT,LON`.

## Lire le résultat

- Code de sortie **0** : au moins une marche trouvée. **1** : rien dans le
  rayon ; la sortie indique la marche la plus proche et le `--rayon` à utiliser
  — proposer de l'élargir. **2** : adresse ou date non comprise ; reformuler
  (code postal + commune) ou demander à l'utilisateur.
- Les marches ADEPS ont lieu surtout le dimanche, en général de 8h à 18h,
  départs libres : lire la ligne « Horaires » de chaque marche. Si la date est
  « aujourd'hui » et qu'il est tard, le signaler.
- Les distances sont à vol d'oiseau ; `--trajet` donne la vraie durée en voiture.
- Répondre en français, de façon courte : date, localité, distance, parcours,
  lieu de rendez-vous, horaires, puis le lien. Donner le lien d'itinéraire
  (`--complet`) si l'utilisateur veut s'y rendre.
