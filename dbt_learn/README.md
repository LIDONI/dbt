# dbt Learn — NYC Yellow Taxi Trips 2024

Projet dbt/DuckDB qui nettoie et transforme les données publiques des taxis jaunes de New York pour l'année 2024.

## Architecture

- `models/taxi_trips/transform.sql` : aperçu limité de la source.
- `models/taxi_trips/transform_data.sql` : modèle de nettoyage principal.
- `models/taxi_trips/sources.yml` : définition des 12 fichiers Parquet TLC distants.
- `models/taxi_trips/schema.yml` : documentation et tests de colonnes.
- `tests/` : tests de données personnalisés.

Les modèles sont matérialisés comme vues DuckDB dans la base configurée par le profil local.

## Prérequis

- Python 3.10 ou version ultérieure
- Accès réseau aux fichiers TLC hébergés sur CloudFront

## Installation

Depuis ce dossier :

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
dbt deps
Copy-Item profiles.yml.example profiles.yml
```

Sous macOS/Linux, remplacez l'activation par `source .venv/bin/activate` et la copie par `cp profiles.yml.example profiles.yml`.

`profiles.yml` est volontairement ignoré par Git : il peut contenir des identifiants selon l'adaptateur utilisé. Pour ce projet DuckDB, le profil fourni écrit dans `output/transformed_data.db`.

## Exécution

```powershell
dbt debug --profiles-dir .
dbt deps
dbt build --profiles-dir .
```

Pour générer et consulter la documentation :

```powershell
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
```

## Source de données et reproductibilité

La source lit les douze fichiers `yellow_tripdata_2024-*.parquet` publiés par la [NYC Taxi & Limousine Commission](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page). Le fournisseur peut temporairement refuser l'accès HTTP ; un précédent lancement a notamment reçu un code 403 pour décembre 2024. Ce problème est externe au SQL du projet.

En cas de blocage, téléchargez les fichiers depuis la source officielle et adaptez localement `external_location` dans `sources.yml` pour cibler vos fichiers Parquet. Ne versionnez pas les données brutes ni les bases DuckDB générées.

## Qualité et CI

La CI exécute `dbt deps` puis `dbt parse`. Elle ne lance pas `dbt build`, car ce dernier dépend de la disponibilité du fournisseur de données distant. Exécutez `dbt build --profiles-dir .` localement lorsque la source est accessible.

## Publication GitHub

Publiez le contenu de ce dossier comme racine du dépôt. Les artefacts dbt, fichiers DuckDB, profils locaux et identifiants utilisateur sont exclus par `.gitignore`. Ajoutez une licence avant publication si vous souhaitez en accorder une explicitement.
