# marches-adeps : les marches ADEPS dans le terminal

`marches-adeps` trouve la prochaine [marche ADEPS](https://marches.sport-adeps.be)
près de chez vous : date, localité, distance, parcours, lieu de rendez-vous,
horaires et organisateur. Un skill pour agents (Claude Code, Hermes) est fourni.
Vous pouvez donc demander à votre agent « Il y a une marche Adeps près de chez
moi dimanche ? ».

Les marches ADEPS, aussi appelées « points verts », sont des marches gratuites
de 5 à 20 km. Elles sont organisées presque tous les dimanches par des clubs
et des associations de Wallonie et de Bruxelles, et reconnues par l'Adeps
(Fédération Wallonie-Bruxelles).

Les données viennent du catalogue officiel
[marches.sport-adeps.be](https://marches.sport-adeps.be). Pas de compte ni de
clé. Il faut seulement Python 3.9 ou plus récent, sans paquet à installer.

```
$ marches-adeps --adresse "Grand-Place 1, 1348 Louvain-la-Neuve" --trajet
Depuis : Grand Place 1, 1348 Ottignies-Louvain-la-Neuve  (rayon 30 km)

Dimanche 22 novembre 2026 (aujourd'hui)
  • CORTIL-WODON — 26.8 km à vol d'oiseau, 30 min en voiture (33.4 km)
    Marche 5 - 10 - 15 - 20 km · 32 Rue Saint-Martin, 5380 Cortil-Wodon (Namur)
    Organisateur : Association de parents de l'Ecole saint Martin
    Horaires : Toutes les marches sont accessibles de 8h à 18h. Les départs sont libres.
    https://marches.sport-adeps.be/marche/cortil-wodon-marche-dimanche-22-novembre-2026
```

> Projet personnel et **non officiel**, sans lien avec l'Adeps ni avec la
> Fédération Wallonie-Bruxelles. En cas de doute, la page officielle de la
> marche fait foi (annulation, changement d'horaire…).

## Démarrage rapide

1. Clonez le dépôt où vous voulez et lancez l'installation, avec votre adresse
   pour qu'elle devienne l'adresse par défaut :

   ```bash
   git clone https://github.com/bidouilles/marches-adeps.git && cd marches-adeps
   ./install.sh "Grand-Place 1, 1348 Louvain-la-Neuve"
   ```

   Si vous voulez seulement la commande, sans skill ni clone (c'est un seul
   fichier) :

   ```bash
   curl -fsSL https://raw.githubusercontent.com/bidouilles/marches-adeps/main/marches-adeps \
     -o ~/.local/bin/marches-adeps && chmod +x ~/.local/bin/marches-adeps
   ```

2. Essayez dans le terminal, ou demandez à votre agent :

   ```bash
   marches-adeps
   ```

   > Quelle est la prochaine marche Adeps près de chez moi ?

Voir [Demander à l'agent](#demander-à-lagent) pour d'autres questions à essayer.

## Installation

```bash
./install.sh                       # commande + skill
./install.sh "rue, code postal commune"   # idem, et enregistre l'adresse par défaut
```

Le script :

- crée le lien `~/.local/bin/marches-adeps` vers la commande du dépôt ;
- relie le skill `skill/` à `~/.claude/skills/marches-adeps` (Claude Code) et à
  `~/.hermes/skills/leisure/marches-adeps` (Hermes), si ces dossiers existent.

Ce sont des liens symboliques : une mise à jour du dépôt (`git pull`)
s'applique tout de suite. Pour désinstaller :

```bash
rm ~/.local/bin/marches-adeps ~/.claude/skills/marches-adeps ~/.hermes/skills/leisure/marches-adeps
rm -r ~/.config/marches-adeps ~/.cache/marches-adeps
```

## Utilisation

```bash
marches-adeps                                  # prochaine date avec une marche à ≤ 30 km
marches-adeps --adresse "Wavre" --rayon 15     # autre point de départ, autre rayon
marches-adeps --date dimanche                  # dimanche, demain, 29/11, 2026-12-06…
marches-adeps --toutes                         # toutes les dates publiées
marches-adeps --trajet                         # + durée et distance en voiture
marches-adeps --complet                        # + contact, remarques, carte IGN, itinéraire
marches-adeps --dates                          # dates publiées et nombre de marches
marches-adeps --json                           # sortie JSON
```

- **Par défaut**, la commande affiche la première date qui a au moins une
  marche dans le rayon, avec les marches les plus proches d'abord.
- **Adresse** : une adresse complète, une commune seule (`--adresse Namur`) ou
  des coordonnées (`--position 50.46,4.87`). Sans option, la commande prend
  `$MARCHES_ADEPS_ADRESSE`, puis l'adresse enregistrée.
- **Distances** : à vol d'oiseau. `--trajet` ajoute la durée réelle en voiture.
- **Rien dans le rayon ?** La commande indique la marche la plus proche et le
  rayon à utiliser, puis sort avec le code **1**.
- `--complet` ajoute ce que dit la page de la marche : personne de contact,
  remarques, parcours accessibles aux landaus et aux PMR, ravitaillement,
  carte IGN et lien d'itinéraire.

| Option | Rôle |
| --- | --- |
| `-a`, `--adresse` | adresse de départ |
| `-p`, `--position LAT,LON` | coordonnées de départ |
| `-r`, `--rayon KM` | rayon à vol d'oiseau, 30 km par défaut |
| `-n`, `--nombre N` | marches max. par date, 5 par défaut |
| `-d`, `--date` | une seule date |
| `-t`, `--toutes` | toutes les dates au lieu de la prochaine |
| `--trajet` | durée en voiture (serveur public OSRM) |
| `-c`, `--complet` | toutes les informations de la page de la marche |
| `--rapide` | sans les pages de détail (ni organisateur ni horaires) |
| `--json` | sortie structurée pour scripts et agents |
| `--enregistrer` | enregistre `--adresse` comme adresse par défaut |

Codes de sortie : **0** marche trouvée, **1** aucune marche dans le rayon (ou
site injoignable), **2** adresse ou date non comprise.

### Adresse par défaut

```bash
marches-adeps --enregistrer --adresse "Grand-Place 1, 1348 Louvain-la-Neuve"
```

Elle est enregistrée dans `~/.config/marches-adeps/config.json`, sur votre
machine uniquement.

## Demander à l'agent

Une fois le skill installé, posez la question avec vos mots, en français ou en
anglais. Le skill (`skill/SKILL.md`) choisit la commande et répond court : la
date, la localité, la distance, les parcours, le rendez-vous et les horaires,
puis le lien officiel.

| Vous demandez | L'agent lance |
| --- | --- |
| Quelle est la prochaine marche Adeps près de chez moi ? | `marches-adeps` |
| Il y a une marche dimanche pas trop loin ? | `marches-adeps --date dimanche --trajet` |
| Une marche Adeps vers Namur, à 20 km max ? | `marches-adeps --adresse Namur --rayon 20` |
| Quelles marches d'ici fin décembre près de chez moi ? | `marches-adeps --toutes` |
| On peut y aller avec la poussette ? | `marches-adeps --complet` (parcours accessibles aux landaus) |
| Next ADEPS walk near Wavre? | `marches-adeps --adresse Wavre` |

## Fonctionnement

1. La [carte officielle](https://marches.sport-adeps.be/catalogue/marches/carte)
   contient toutes les marches à venir avec leurs coordonnées : une seule
   requête suffit.
2. L'adresse est convertie en coordonnées avec Photon puis Nominatim
   (OpenStreetMap). Le résultat est gardé en cache dans
   `~/.cache/marches-adeps/geocodage.json` : une adresse n'est envoyée qu'une
   fois.
3. La distance est calculée à vol d'oiseau, puis la première date qui a une
   marche dans le rayon est retenue.
4. Les pages officielles des marches affichées donnent l'organisateur, les
   horaires et le reste.

Services contactés : marches.sport-adeps.be, photon.komoot.io et
nominatim.openstreetmap.org (géocodage), router.project-osrm.org (seulement
avec `--trajet`).

## Organisation du dépôt

| Chemin | Contenu |
| --- | --- |
| `marches-adeps` | La commande : un seul fichier, bibliothèque standard uniquement |
| `skill/SKILL.md` | Le skill pour Claude Code et Hermes |
| `install.sh` | Installe la commande et le skill, enregistre l'adresse |
| `AGENTS.md` | Notes pour les agents qui modifient ce dépôt |

## Liens officiels

- [Marches Adeps](https://marches.sport-adeps.be) : le catalogue officiel
- [Liste des marches](https://marches.sport-adeps.be/catalogue/marches/liste),
  [carte](https://marches.sport-adeps.be/catalogue/marches/carte) et
  [calendrier](https://marches.sport-adeps.be/marche-adeps/calendrier)
- [Sport-Adeps](https://www.sport-adeps.be) : le portail du sport en
  Fédération Wallonie-Bruxelles

## Crédits

Données des marches : [Adeps](https://www.sport-adeps.be), Fédération
Wallonie-Bruxelles. Géocodage : [Photon](https://photon.komoot.io) et
[Nominatim](https://nominatim.org), données © contributeurs
[OpenStreetMap](https://www.openstreetmap.org/copyright) (ODbL). Trajets en
voiture : [OSRM](https://project-osrm.org).

## Licence

MIT. Voir `LICENSE`.
