# 🚨 Exercice 2 - Attaque CORS sur DVWA

## 📋 Objectif
Expérimenter une attaque sur le mécanisme CORS (Cross-Origin Resource Sharing) au moyen du laboratoire d'expérimentation en ciblant l'environnement DVWA.

## 🎯 Scénario d'attaque
Démontrer comment une mauvaise configuration CORS peut permettre à un site malveillant de voler des cookies de session et des données sensibles depuis un autre domaine.

## 🛠️ Fichiers du projet

### 📁 Structure
```
Exo2/
├── README.md                   # Ce fichier
├── QUESTIONS_REPONSES.md       # Réponses aux questions
├── vulnerable.php             # Script vulnérable à CORS
├── vulnerable_fixed.php       # Script sécurisé
├── exploit.html               # Page d'exploitation interactive
├── start_attack_server.ps1    # Script PowerShell
├── start_attack_server.sh     # Script Bash
├── setup_exo2.ps1            # Script de démarrage PowerShell
└── setup_exo2.sh             # Script de démarrage Bash
```

### 🔧 Scripts principaux
- **`vulnerable.php`** : Script PHP avec CORS dangereux (`Access-Control-Allow-Origin: *`)
- **`vulnerable_fixed.php`** : Version sécurisée avec origines restreintes
- **`exploit.html`** : Page malveillante pour démontrer l'attaque
- **`setup_exo2.ps1`** : Script de démarrage PowerShell avec Podman

## 🚀 Démarrage rapide

### Prérequis
- Podman Desktop installé
- Python 3.x installé
- Navigateur web moderne

### Étape 1 : Démarrer DVWA avec Podman
```powershell
# Option 1 : Script PowerShell (recommandé)
.\setup_exo2.ps1

# Option 2 : Script Bash
bash setup_exo2.sh

# Option 3 : Commandes manuelles
podman pod create --name exo2-cors -p 8080:80
podman run -d --pod exo2-cors --name dvwa-cors vulnerables/web-dvwa
```

### Étape 2 : Configurer DVWA
1. Se connecter à DVWA (http://localhost:8080)
2. Aller dans **DVWA Security** et mettre le niveau à **"Low"**
3. Copier le fichier `vulnerable.php` dans le répertoire web de DVWA

### Étape 3 : Démarrer le serveur d'attaque
```powershell
# Option 1 : PowerShell (recommandé)
.\start_attack_server.ps1

# Option 2 : Bash (si disponible)
bash start_attack_server.sh

# Option 3 : Python direct
python -m http.server 8000
```

### Étape 4 : Exécuter l'attaque
1. Ouvrir http://localhost:8000/exploit.html dans un navigateur
2. S'assurer d'être connecté à DVWA dans un autre onglet
3. Cliquer sur "Tester la vulnérabilité CORS"
4. Observer le vol du cookie de session

## 🔍 Démonstration de l'attaque

### 1. Test de vulnérabilité
- La page `exploit.html` teste la vulnérabilité CORS
- Si vulnérable : affichage des données sensibles
- Si sécurisé : erreur 403 "Origin not allowed"

### 2. Vol de cookie de session
- Récupération du cookie PHPSESSID
- Affichage des informations de session
- Simulation d'envoi vers serveur malveillant

### 3. Capture du trafic
- Utiliser Burp Suite pour intercepter les requêtes
- Observer les en-têtes CORS dangereux
- Analyser la fuite des données sensibles

## 🔒 Correction de la vulnérabilité

### Avant correction (vulnérable)
```php
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials: true");
// ... code vulnérable
?>
```

### Après correction (sécurisé)
```php
<?php
header("Access-Control-Allow-Origin: https://trusted-site.com");
header("Access-Control-Allow-Credentials: true");
// ... code sécurisé
?>
```

## ❓ Questions et réponses

### 1. Pourquoi « Access-Control-Allow-Origin: * » est-il dangereux ?
- Permet l'accès depuis n'importe quel domaine
- Expose les données sensibles
- Contourne la politique de même origine
- Facilite les attaques CSRF

### 2. Quel rôle joue « Access-Control-Allow-Credentials: true » ?
- Inclut les cookies dans les requêtes CORS
- Transmet les informations d'authentification
- Expose les données de session
- Augmente la surface d'attaque

### 3. Comment un attaquant pourrait-il exploiter cette faille ?
- Vol de cookies de session via JavaScript
- Actions non autorisées
- Exfiltration de données sensibles
- Escalade de privilèges

### 4. Quelles sont les bonnes pratiques pour configurer CORS ?
- Spécifier des origines exactes
- Utiliser des listes d'origines autorisées
- Limiter les méthodes HTTP autorisées
- Désactiver les credentials si non nécessaires

## 📊 Résultats attendus

### ✅ Avant correction (vulnérable)
- L'attaque réussit
- Le cookie de session est volé
- Les données sensibles sont exposées

### ❌ Après correction (sécurisé)
- L'attaque échoue
- Erreur 403 "Origin not allowed"
- Seules les origines autorisées peuvent accéder

## 🎬 Guide de démonstration

Pour la démonstration, suivez les étapes dans ce README :
- Instructions détaillées étape par étape
- Capture d'écran des résultats
- Script de démonstration
- Points clés à mentionner

## 🔧 Dépannage

### Problèmes courants
1. **DVWA non accessible** : Vérifier que `.\setup_exo2.ps1` a fonctionné
2. **Python non trouvé** : Installer Python depuis https://python.org
3. **Attaque échoue** : Vérifier que vous êtes connecté à DVWA dans un autre onglet
4. **Port 8000 occupé** : Changer le port dans `start_attack_server.ps1`
5. **Podman-compose non trouvé** : Installer depuis https://github.com/containers/podman-compose

### Solutions
- Vérifier les logs des conteneurs : `podman logs dvwa-cors`
- Tester l'accès DVWA : `curl http://localhost:8080`
- Vérifier les ports : `netstat -an | findstr :8000`
- Vérifier les services : `podman ps`
- Redémarrer les services : `podman pod restart exo2-cors`

## 📚 Documentation complète

- **`QUESTIONS_REPONSES.md`** : Réponses aux questions de l'exercice
- **`vulnerable.php`** : Code source du script vulnérable
- **`vulnerable_fixed.php`** : Code source du script sécurisé

## ⚠️ Usage éthique

Cette démonstration est destinée uniquement à des fins éducatives. N'utilisez ces techniques que sur vos propres systèmes ou avec autorisation explicite.

## 🎯 Objectifs pédagogiques

À la fin de cet exercice, vous saurez :
- Identifier les vulnérabilités CORS
- Exploiter une mauvaise configuration CORS
- Corriger les vulnérabilités CORS
- Comprendre l'importance de la sécurité web
- Appliquer les bonnes pratiques de configuration CORS

## 🏆 Conformité aux exigences

- ✅ **Attaque CORS** : Démonstration complète
- ✅ **Scripts vulnérables** : Code source fourni
- ✅ **Page d'exploitation** : Interface interactive
- ✅ **Correction** : Version sécurisée
- ✅ **Documentation** : Réponses aux questions
- ✅ **Démonstration** : Guide de capture d'écran

## 📞 Support

En cas de problème, consultez :
1. Ce README pour la documentation technique
2. Les logs des conteneurs pour le diagnostic
3. La section Dépannage ci-dessus

---

**🎓 Exercice 2 - Attaque CORS sur DVWA**  
*Laboratoire d'apprentissage des vulnérabilités web*
