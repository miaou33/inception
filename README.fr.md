[![en](https://img.shields.io/badge/lang-en-pink.svg)](https://github.com/nfauconn/inception/blob/master/README.md)
[![fr](https://img.shields.io/badge/lang-fr-purple.svg)](https://github.com/nfauconn/inception/blob/master/README.fr.md)

*Administration Système* • *Virtualisation* • *Docker* • *Administration Réseau* • *Web* • *Sécurité* • *Scripting* • *Alpine Linux*

# Inception

Ce projet consiste à mettre en place une petite infrastructure composée de différents services sous des règles spécifiques :

**Conteneurs** :
- Un conteneur Docker contenant **NGINX** avec uniquement TLSv1.2 ou TLSv1.3.
- Un conteneur Docker contenant **WordPress + php-fpm** (doit être installé et configuré) uniquement, sans Nginx.
- Un conteneur Docker contenant **MariaDB** uniquement, sans Nginx.

**Volumes** :
- Un volume contenant la **base de données WordPress**.
- Un second volume contenant les **fichiers du site WordPress**.

**Réseau** :
- Un réseau docker qui établit la connexion entre vos conteneurs.

Toutes les images Docker sont construites à partir de zéro en utilisant **Alpine Linux**, pratique pour sa petite taille, sa rapidité et sa sécurité.

![](./.img/diagram.png)

## Utilisation

```shell
git clone git@github.com:nfauconn/inception.git
cd inception
```

Ensuite, vous pouvez créer un fichier .env en copiant le fichier .env.example et en changeant les valeurs comme vous le souhaitez.
```
cp srcs/.env.example srcs/.env
```

> Ce projet est configuré pour fonctionner sur localhost (127.0.0.1). Vous devrez configurer le nom de domaine que vous avez choisi pour pointer vers votre adresse IP locale dans votre fichier `/etc/hosts` en ajoutant à la fin du fichier :
> ```
> 127.0.0.1 <votre nom de domaine>
> ```

Enfin, vous pouvez construire le projet avec :

```shell
make
```

Et accéder au site WordPress à l'adresse que vous avez choisie dans votre navigateur.