# Flutter Application 

## Fonctionnalités

- **Authentification utilisateur** : Les utilisateurs peuvent créer un compte, se connecter et se déconnecter. 

- **Catalogue des activités** : Les utilisateurs peuvent parcourir les activités disponibles dans le catalogue, avec ou sans filtre. Ils peuvent ajouter l'activité directement en cliquant sur le logo "add" ou alors cliquer sur l'activité pour voir le détail de celle-ci. Dans le détails de l'activité nous pouvons y retrouver des informations supplémentaires et aussi un moyen de l'ajouter dans le panier. 

- **Gestion du panier** : Les utilisateurs peuvent ajouter des produits à leur panier, les visualiser, les modifier et les supprimer. Les paniers sont propres à chaques utilisateurs et sauvegardés dans la base de données.

- **Profil** : Un utilisateur peut voir son profil et modifier ses informations ainsi que son mot de passe. 

## US 
- [x] US#1 : [MVP] Interface de login
- [x] US#2 : [MVP] Liste des activités
- [x] US#3 : [MVP] Détail d’une activité
- [x] US#4 : [MVP] Le panier
- [x] US#5 : [MVP] Profil utilisateur 
- [x] US#6 : Filtrer sur la liste des activités
- [x] US#7 : Laisser libre cours à votre imagination

Ce que j'ai fait dans l'US 7 
- J'ai utilisé firebase Authentification et Firestore Database pour la gestion de mes utilisateurs et les inscriptions. Chaque utilisateurs possèdent son panier, qui est sauvegardé s'il se déconnecte. J'ai utilisé un format de données qui me permet de sauvegarder une collection "Cart" dans une collection "Users".
![image](https://github.com/MorganSauvignon/flutter_first_app/assets/70762614/e342c763-5746-4364-a3a7-e3fccc388061)
- Pour se créer une nouveau compte, vous devez rentrer votre mail et votre mot de passe et cliquer sur "s'inscrire". 
- J'ai une bouton qui me permet de vider mon panier entièrement. 





# Test 

L'application a été testé sur Google Chrome en format téléphone. 

Par défaut, un utilisateur peut se connecter avec : 
- email : default@gmail.com
- password : default
