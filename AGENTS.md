# AGENTS.md

Notes pour les agents qui modifient ce dépôt. Le mode d'emploi est dans
`README.md` ; le skill (pour *utiliser* la commande) est dans `skill/SKILL.md`.

## Contenu

- `marches-adeps` : la commande, un seul fichier Python exécutable.
- `skill/SKILL.md` : le skill, relié par lien symbolique dans `~/.claude/skills/`
  et `~/.hermes/skills/leisure/`. Toute modification ici est vue tout de suite
  par les deux agents.
- `install.sh` : liens vers `~/.local/bin` et les dossiers de skills, plus
  l'enregistrement facultatif de l'adresse par défaut.

## Règles

- **Bibliothèque standard uniquement**, compatible **Python 3.9** (le Python
  système de macOS). Garder
  `from __future__ import annotations`. Pas de `match`, pas de dépendance pip.
- **Tout en français** : messages, aide `--help`, sortie, README, skill. Les
  noms de fonctions et les clés JSON sont en français aussi (`localite`,
  `distance_km`, `jours`…). Les clés JSON sont une interface pour les agents :
  ne pas les renommer sans mettre à jour `skill/SKILL.md`.
- Codes de sortie : 0 trouvé, 1 rien dans le rayon ou erreur réseau, 2 entrée
  non comprise. Le skill s'appuie dessus.
- Ne jamais écrire d'adresse personnelle dans le dépôt : l'adresse par défaut
  vit dans `~/.config/marches-adeps/config.json`.

## Le site ADEPS

Site Drupal, rendu côté serveur ; `curl` suffit (pas besoin de navigateur).

- `/catalogue/marches/carte` **sans filtre** : toutes les marches à venir. Les
  données sont dans le JSON `drupal-settings-json` → `leaflet.<id>.features[]` :
  `lat`, `lon`, `entity_id`, et `popup.value` (HTML : `<h2>` localité,
  `field__item activites|location|date|province`, lien `/marche/<slug>`).
  La date du popup est au format `JJ/MM/AA`.
- Filtres possibles : `?f[0]=date:<id>`, `?f[0]=province:<id>` (5263, 6497…),
  combinables avec `f[1]=…`. Inutiles pour l'instant.
- Page de détail `/marche/<slug>` : bloc `<article class="full node marche…">`.
  Le parseur passe ce bloc en lignes de texte et lit la ligne qui suit chaque
  libellé (`Lieu de rendez-vous:`, `Personne de contact:`, `IGN:`…) et les
  sections (`ORGANISATEUR`, `REMARQUES`, `Informations supplémentaires`,
  `Horaires`). Si un libellé change sur le site, mettre à jour `details_marche`
  et l'ensemble `SECTIONS`.

## Vérifier un changement

Pas de suite de tests : le site change, on teste contre le vrai site.

```bash
python3 -m py_compile marches-adeps && rm -rf __pycache__
./marches-adeps --dates                         # doit lister ~5 semaines de dates
./marches-adeps -a Namur -r 30 --complet        # détails remplis (organisateur, horaires)
./marches-adeps -a Arlon -r 5; echo $?          # rien dans le rayon → message + code 1
./marches-adeps -a "zzzz qqqq"; echo $?         # adresse inconnue → code 2
./marches-adeps -a Wavre --toutes --json | python3 -m json.tool > /dev/null
```

Tester aussi sous Python 3.9 (`uv run --no-project --python 3.9 ./marches-adeps --dates`).
Le Python système de macOS embarque un LibreSSL ancien : certains serveurs TLS
refusent la connexion, d'où le repli sur `curl` dans `http_get`.
