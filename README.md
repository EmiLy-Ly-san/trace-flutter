# Trace

Journal patient Flutter : textes, photos, messages vocaux et fichiers (PDF, Word…).  
Les contenus restent sur le téléphone. Un interrupteur « Partagé avec mon thérapeute » marque localement ce qu’on voudra partager plus tard ; **aucun envoi vers un serveur n’est implémenté**.

## Prérequis

- [FVM](https://fvm.app/) recommandé (version du projet : **Flutter 3.44.2**)
- Android Studio ou un SDK Android (émulateur ou téléphone)
- `git` et un terminal

Sans FVM, installe Flutter stable 3.44.2 et remplace `fvm flutter` par `flutter` dans les commandes ci-dessous.

## Démarrer le projet

```bash
git clone https://github.com/EmiLy-Ly-san/trace-flutter.git
cd trace-flutter
fvm install
fvm flutter pub get
fvm flutter run
```

Commandes utiles :

```bash
fvm flutter analyze   # analyse statique
fvm flutter test      # tous les tests
fvm dart format lib test
```

### Régénérer le code Drift

Après une modification de table (`contents_table.dart`) ou de `app_database.dart` :

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

Ne pas éditer à la main `lib/core/storage/app_database.g.dart`.

### Construire un APK (démo Android)

```bash
fvm flutter build apk --release
```

Fichier produit : `build/app/outputs/flutter-apk/app-release.apk`  
(signé avec la clé de debug → OK pour une démo, pas pour le Play Store)

## Architecture

Flux principal :

```
Écrans (view) → Providers Riverpod → ContentsRepository → AppDatabase (Drift) → trace.db
                                                      ↘ fichiers locaux (photos/, audios/, files/)
```

| Couche | Rôle |
| --- | --- |
| **View** | Pages et widgets Flutter |
| **Controllers** | Providers Riverpod (`contentsProvider`, `contentsRepositoryProvider`) |
| **Repository** | « Guichet » métier : `addText`, `addPhoto`, `addAudio`, `addFile`, `updateShared`, `deleteById`, `watchAll`… |
| **Drift** | Table `Contents` + fichier SQLite `trace.db` dans le dossier documents de l’app |

État :

- **Riverpod** pour la liste des contenus (stream Drift)
- **`setState` local** pour le filtre Tout / Privé / Partagé et l’interrupteur de partage sur le détail

Navigation : **go_router** (`lib/app/router/app_router.dart`). Les routes d’ajout / détail passent souvent des données via `extra`.

## Structure des dossiers

```
lib/
  main.dart                 # ProviderScope + TraceApp
  app/
    router/app_router.dart  # routes
    theme/                  # couleurs et thème
  core/
    storage/                # AppDatabase Drift + provider
  contents/
    controllers/            # providers Riverpod
    data/
      local/                # table Contents
      repositories/         # ContentsRepository
      file_import_rules.dart
    view/
      pages/                # écrans
      widgets/              # carte, sheet d’ajout, lecteur audio
test/                       # tests unitaires et widget
.github/workflows/ci.yml    # format + analyze + test
```

Données sur l’appareil (dossier documents de l’app) :

- `trace.db` — métadonnées des contenus
- `photos/`, `audios/`, `files/` — fichiers copiés à l’enregistrement

## Fonctionnalités

- Ajouter un **texte**, une **photo** (galerie), un **vocal**, un **fichier**
- Lister, ouvrir le détail, supprimer (avec confirmation ; le fichier associé est aussi effacé)
- Filtrer : **Tout / Privé / Partagé**
- Marquer un contenu comme partagé (stockage local uniquement)

Import de fichiers (`file_import_rules.dart`) :

- Extensions : `pdf`, `doc`, `docx`, `odt`, `rtf`, `txt`
- Taille max : **20 Mo**

Android : `android:allowBackup="false"` (pas de sauvegarde auto des données de l’app).

## Dépendances principales

| Package | Usage |
| --- | --- |
| `flutter_riverpod` | état / providers |
| `go_router` | navigation |
| `drift` + `path_provider` | base SQLite locale |
| `image_picker` | photos |
| `record` + `audioplayers` | enregistrement / lecture audio |
| `file_picker` | import de documents |

Dev : `drift_dev`, `build_runner`, `flutter_lints`.

## CI

Sur chaque pull request et chaque push sur `main` :

1. `flutter pub get`
2. `dart format --set-exit-if-changed lib test`
3. `flutter analyze`
4. `flutter test`

Version Flutter CI : **3.44.2** (alignée avec FVM).

## Prochaines étapes

L’app locale est en place pour la démo. La suite logique côté produit :

1. **Partage réel avec le thérapeute (données médicales)**  
   Aujourd’hui, l’interrupteur ne fait que stocker `isShared` dans `trace.db` sur le téléphone.  
   Ensuite, les contenus **partagés ne resteront plus uniquement en local** : ils seront hébergés dans une base prévue pour des **données de santé** (hébergeur certifié HDS en France / UE).  
   Exemple possible : **PostgreSQL** chez **OVHcloud Healthcare** (ou un autre hébergeur HDS équivalent).  
   Auth patient–thérapeute, envoi des contenus marqués « Partagé », sync (ou file d’attente) hors ligne.

2. **Dashboard thérapeute**  
   Interface web (ou app) où le thérapeute reçoit les contenus partagés.  
   Il ne voit **que les contenus de ses propres patients** (pas ceux des autres thérapeutes).

3. **Notes et catégories côté patient**  
   Le patient pourra ajouter des **notes** à ses contenus et les **catégoriser**.  
   Il crée lui-même ses catégories, avec une **limite** (nombre max) pour éviter la sur-analyse chez certains profils.

4. **Ouvrir les fichiers importés**  
   Afficher ou ouvrir un PDF / document depuis le détail (ex. `open_filex` ou viewer intégré).

5. **Renommer et préparer la release**  
   Nom affiché « Trace », `applicationId` hors `com.example.test`, icône, signature release (keystore) pour le Play Store.

6. **Sécurité optionnelle**  
   Verrouillage au lancement (code / biométrie), puis éventuellement chiffrement local si le besoin métier le demande.  
   Pas retenu pour la démo : le sandbox du téléphone + `allowBackup=false` suffisent pour une démo locale.

7. **iOS**  
   Vérifier permissions micro / photos / fichiers, et le comportement de sauvegarde iCloud si on va en prod.
