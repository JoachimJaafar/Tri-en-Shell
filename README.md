# Tri-en-Shell
Affiche l'arborescence d'un dossier selon les options données en argument.

La syntaxe de la commande est : trishell.sh [-R] [-d] [-nsmletpg] repertoire

Les différentes options sont les suivantes :
- R : tri le contenu de l’arborescence débutant au répertoire rep. Dans ce cas on triera par rapport aux
noms des entrées mais on affichera le chemin d’accès ;
- d : tri dans l’ordre décroissant, par défaut le tri est effectué dans l’ordre croissant ;
- nsdletpg : permet de spécifier le critère de tri utilisé. Ces critères peuvent être combinés, dans ce cas si
deux fichiers sont identiques pour le premier critère, le second critère les départegera et ainsi de suite.
- n : tri suivant le nom des entrées ;
- s : tri suivant la taille des entrées ;
- m : tri suivant la date de dernière modification des entrées ;
- l : tri suivant le nombre de lignes des entrées ;
- e : tri suivant l’extension des entrées (caractères se trouvant après le dernier point du nom de l’entrée ;
- t : tri suivant le type de fichier (ordre : répertoire, fichier, liens, fichier spécial de type bloc, fichier
spécial de type caractère, tube nommé, socket) ;
– p : tri suivant le nom du propriétaire de l’entrée ;
– g : tri suivant le groupe du propriétaire de l’entrée.

Exemple : trishell -R -d -pse /home trie, par ordre décroissant, l’arborescence débutant à /home en fonction
des propriétaires des entrées comme premier critère, de la taille des entrées comme second critère et de l’extension
des entrées comme dernier critère.
