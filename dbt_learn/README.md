# dbt — NYC Yellow Taxi Trips 2024

Projet d'apprentissage **dbt + DuckDB** consacré au nettoyage et à la transformation des données publiques des taxis jaunes de New York en 2024.

Les données proviennent de la [NYC Taxi & Limousine Commission (TLC)](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page). Elles sont lues directement au format Parquet et ne sont pas versionnées dans ce dépôt.

## Objectifs

- Déclarer une source externe dans dbt.
- Construire des modèles SQL versionnés et documentés.
- Nettoyer les trajets incohérents avant leur analyse.
- Tester les règles de qualité de données avec les tests dbt natifs, `dbt_expectations` et des tests SQL personnalisés.
- Utiliser DuckDB comme entrepôt analytique local, sans serveur de base de données.

## Architecture du projet

```text
.
├── models/
│   └── taxi_trips/
│       ├── sources.yml          # Source TLC et fichiers Parquet distants
│       ├── transform.sql        # Aperçu de la source
│       ├── transform_data.sql   # Modèle principal de nettoyage
│       └── schema.yml           # Documentation et tests de colonnes
├── tests/                       # Tests SQL personnalisés
├── analyses/                    # Requêtes exploratoires
├── packages.yml                 # dbt_expectations
├── profiles.yml.example         # Profil DuckDB sans information sensible
└── .github/workflows/           # Validation dbt dans GitHub Actions
```

## Lignage

```text
NYC TLC Parquet (12 fichiers 2024)
                │
                ├── transform       → aperçu de 10 lignes
                │
                └── transform_data  → données nettoyées et enrichies
                                      │
                                      └── tests dbt et tests SQL
```

## Règles de transformation

Le modèle `transform_data` conserve uniquement les trajets qui respectent les règles suivantes :

- `passenger_count`, `trip_distance` et `total_amount` sont strictement positifs ;
- l'heure de prise en charge est antérieure à l'heure de dépose ;
- `store_and_fwd_flag = 'N'` ;
- le pourboire est positif ou nul ;
- le paiement est par carte (`payment_type = 1`) ou en espèces (`payment_type = 2`) ;
- le départ et l'arrivée ont lieu en 2024 ;
- la durée calculée est strictement positive.

Le modèle ajoute notamment :

- `payment_method` : traduction du code de paiement en `Credit card` ou `Cash` ;
- `trip_duration_minutes` : différence en minutes entre la prise en charge et la dépose ;
- `passenger_count` converti en entier.

## Contrôles de qualité

Les tests documentés dans `schema.yml` vérifient les valeurs nulles et les valeurs autorisées. Les tests SQL du dossier `tests/` vérifient aussi :

- une distance strictement positive ;
- une durée strictement positive ;
- un nombre de passagers strictement positif ;
- la présence des douze mois de 2024.

## Prérequis

- Python 3.10 ou version ultérieure ;
- accès réseau aux fichiers Parquet TLC ;
- Git, pour cloner et publier les changements.

## Installation locale

```powershell
git clone https://github.com/LIDONI/dbt.git
cd dbt

python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt

Copy-Item profiles.yml.example profiles.yml
dbt deps
```

Sous macOS/Linux :

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp profiles.yml.example profiles.yml
dbt deps
```

## Utilisation

Vérifier la configuration :

```powershell
dbt debug --profiles-dir .
```

Construire les modèles et exécuter les tests :

```powershell
dbt build --profiles-dir .
```

Exécuter seulement le modèle principal et ses tests :

```powershell
dbt build --select transform_data --profiles-dir .
```

Générer la documentation dbt :

```powershell
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
```

## Sécurité et fichiers locaux

Ne publiez jamais `profiles.yml` s'il contient des identifiants. Le dépôt fournit uniquement `profiles.yml.example`.

Les artefacts générés (`target/`, `logs/`, `dbt_packages/`), les bases DuckDB (`*.duckdb`, `output/*.db`) et les fichiers d'environnement sont exclus par `.gitignore`.

## Disponibilité de la source TLC

La source CloudFront de TLC peut refuser ponctuellement certaines requêtes HTTP. Un code `403 Forbidden` est donc une indisponibilité externe et non un échec du SQL dbt. Dans ce cas, téléchargez les fichiers depuis le site officiel de TLC, puis adaptez localement `external_location` dans `models/taxi_trips/sources.yml` pour lire les Parquet téléchargés.

## Intégration continue

GitHub Actions exécute `dbt deps` puis `dbt parse` à chaque push et pull request. La CI ne lance pas `dbt build`, car ce dernier dépend de la disponibilité de la source TLC distante.

## Publier dans ce dépôt

Le dépôt GitHub étant destiné à ce projet, publiez **le contenu de ce dossier à la racine du dépôt**, pas le dossier parent `DBT practice` qui contient d'autres travaux.

```powershell
git add .
git status
git commit -m "Add dbt DuckDB taxi project"
git push origin main
```

Avant le premier push, vérifiez que `profiles.yml`, les bases DuckDB et les dossiers générés n'apparaissent pas dans `git status`.
