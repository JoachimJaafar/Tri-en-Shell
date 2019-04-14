#!/bin/bash

#Cette fonction permet de récupérer les paramètres se situant après l'appel du script (le répertoire et les options)
function getFolderAndOptions()
{
	#On parcourt les arguments
	for i in $@
	do
		#Si l'argument actuel est :
		case "$i" in
			#"-R" = trier toute l'arborescence
		 	-R) if [ $boolArborescence -ne 1 ]
					#On vérifie que le booléen associé à "-R" est bien à 0
					then
						boolArborescence=1
					#Sinon erreur
					else
						echo "Les paramètres sont incorrectes"
						echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
						exit 4
					fi
					;;
			#"-d" = trier dans l'ordre décroissant
			-d) if [ $comp == "<" ]
					#on vérifie que le tri est bien dans l'ordre croissant par défaut
					then
						comp=">"
					#Sinon erreur
					else
						echo "Les paramètres sont incorrectes"
						echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
						exit 4
					fi
					;;
			#Si c'est autre chose que "-R" ou "-d :
			#Si c'est le répertoire en paramètre
			*)	if [ -d $i ] 						
					then
						folder=$i
					#Sinon, il correspond aux options de tri ([-nsmletpg])
					else										
						lesOptions="$i"
						local taille=${#lesOptions}
						#Si la taille des options de tri est égale à 1 (pas assez de paramètres)
						if [ $taille -eq 1 ]
						then
							echo "Les paramètres sont incorrectes"
							echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
							exit 4
						#Si la taille des options de tri est supérieure à 9 (trop de paramètres)
						elif [ $taille -gt 9 ]
						then
							echo "Les paramètres sont incorrectes"
							echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
							exit 4
						#Si la taille des options de tri est correcte
						else
							local i=1
							#On parcourt toutes les options
							while [ $i -lt $taille ]
							do
								#char correspond à la ième lettre des options de tri
								local char=`echo "$lesOptions" | head -c $((i+1)) | tail -c 1`
								case "$char" in
									#"n" = trier par ordre alphabétique des noms
									n)  if [ $boolNom -ne 1 ]
										#On vérifie que le booléen associé à "n" est bien à 0
											then
												boolNom=1
											else
												echo "Les paramètres sont incorrectes"
												echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
												exit 4
											fi
											;;
									#"s" = trier par taille
									s)  if [ $boolTaille -ne 1 ]
										#On vérifie que le booléen associé à "s" est bien à 0
											then
												boolTaille=1
											else
												echo "Les paramètres sont incorrectes"
												echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
												exit 4
											fi
											;;
									#"m" = trier par date de dernière modification
									m)  if [ $boolDate -ne 1 ]
											#On vérifie que le booléen associé à "m" est bien à 0
											then
												boolDate=1
											else
												echo "Les paramètres sont incorrectes"
												echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
												exit 4
											fi
											;;
									#"l" = trier par nombre de lignes
									l)  if [ $boolLignes -ne 1 ]
											#On vérifie que le booléen associé à "l" est bien à 0
											then
												boolLignes=1
											else
												echo "Les paramètres sont incorrectes"
												echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
												exit 4
											fi
											;;
									#"e" = trier par ordre alphabétique des extensions
									e)  if [ $boolExt -ne 1 ]
											#On vérifie que le booléen associé à "l" est bien à 0
											then
												boolExt=1
											else
												echo "Les paramètres sont incorrectes"
												echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
												exit 4
											fi
											;;
									#"t" = trier par type
									t)  if [ $boolType -ne 1 ]
											#On vérifie que le booléen associé à "t" est bien à 0
											then
												boolType=1
											else
												echo "Les paramètres sont incorrectes"
												echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
												exit 4
											fi
											;;
									#"p" = trier par ordre alphabétique des propriétaires
									p)  if [ $boolProp -ne 1 ]
											#On vérifie que le booléen associé à "p" est bien à 0
											then
												boolProp=1
											else
												echo "Les paramètres sont incorrectes"
												echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
												exit 4
											fi
											;;
									#"g" = trier par ordre alphabétique du groupe associé
									g)  if [ $boolGroupe -ne 1 ]
											#On vérifie que le booléen associé à "g" est bien à 0
											then
												boolGroupe=1
											else
												echo "Les paramètres sont incorrectes"
												echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
												exit 4
											fi
											break
											;;
									#Si une autre lettre est donnée en option de tri, ce n'est pas correct
									*)	 if [[ $boolExt -eq 1 ]] || [[ $boolNom -eq 1 ]]
										 then
										 echo "Les paramètres sont incorrectes"
										 echo "ok"
										 echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
										 exit 4
										 fi
										 ;;
								esac
								#On incrémente l'indice dans le parcours des options de tri
								i=$((i+1))
							done
						fi
					fi
					;;
		esac
	done
}

#Cette fonction permet de trier le répertoire donné en paramètre selon les options aussi donnéees en paramètre
function sortFolder()
{
	#Chaîne de caractères dans laquelle seront insérés les noms des répertoires et fichiers
	local noms=""
	#On parcourt tous les répertoires et fichiers à récupérer dans le répertoire courant
	for i in `find -maxdepth 1 -not -name ".*"`
	do
		#On insère le nom du répertoire ou fichier dans notre chaîne, avec comme séparateur le caractère "°" 
		#(d'où la supposition qu'il n'y ait pas le caractère "°" dans les noms des répertoires/fichiers)
		noms="°"$i""$noms""
	done
	#Tant qu'il y a encore des noms dans la chaîne
	while ! [[ $noms = "" ]]
	do
		#inf est la variable correspondant au nom du répertoire/fichier considéré comme "inférieur" par l'option de tri courant
		#Ici il est le premier nom de la chaîne
		local inf=${noms#°}
		#On lui retire le séparateur "°" ...
		inf=`echo $inf | grep -oE '^[^°]+'`
		#... que nous changeons par un espace dans tmpNoms pour pouvoir le parcourir
		local tmpNoms=`echo "${noms//°/" "}"`
		#On parcourt tmpNoms
		for j in $tmpNoms
		do
			#comp1 et comp2 vont contenir les variables utilisées pour la comparaison entre j et inf (respectivement)
			local comp1=""
			local comp2=""
			#tmpOptions correspond aux options de tri sans le tiret "-" au début
			local tmpOptions=${lesOptions#-}
			#S'il n'y a pas d'option de tri, on trie par ordre alphabétique des noms
			if [ "${#tmpOptions}" -eq 0 ]
			then
				tmpOptions="n"
				if [ $boolPrintNoOption -eq 0 ]
				then
					echo "Aucune option de tri ([-nsmletpg]) n'a été donné. Le tri par défaut est celui par nom."
					boolPrintNoOption=1
				fi
			fi
			#On parcourt les options de tri tant que comp1 et comp2 sont égales
			while [[ $comp1 == $comp2 ]] && [[ $tmpOptions != "" ]]
			do
				#first = première lettre de tmpOptions
				first=`echo "$tmpOptions" | head -c1`
				#Si first est ...
				case "$first" in
				#n, on récupère le nom
				n)	comp1=$j
					comp2=$inf
					;;
			
				#s, on récupère la taille
				s)	if ! [ -d $j ]
					then
						comp1=`du -sh -b $j | cut -f1`
					else
						comp1=`du -s -b $j | cut -f1`
					fi
					if ! [ -d $inf ]
					then
						comp2=`du -sh -b $inf | cut -f1`
					else
						comp2=`du -s -b $inf | cut -f1`
					fi
					;;
				#m, on récupère la date de dernière modification (en seconde, pour pouvoir comparer deux entiers)
				m)	comp1=`date -r $j +%s`
					comp2=`date -r $inf +%s`
					;;
				
				#l, on récupère le nombre de lignes des fichiers (les dossiers ont 0 lignes)
				l)	if ! [ -d $j ]
					then
						comp1=`wc -l < $j`
					else
						comp1=0
					fi
					if ! [ -d $inf ]
					then
						comp2=`wc -l < $inf`
					else
						comp2=0
					fi
					;;	
				
				#e, on récupère l'extension
				e)	if ! [ -d $j ]
					#Si ce n'est pas un répertoire
					then
						comp1=${j#./}
						comp1=`echo $comp1 | grep -oE '[^\.]+$'`
						if [ ${#comp1} -eq 0 ]
						#S'il n'a pas d'extension (on leur donne # et % pour comparer les fichiers sans extension et les répertoires)
						then
							comp1="#"
						fi
					else
						comp1="%"
					fi
					if ! [ -d $inf ]
					then
						comp2=${inf#./}
						comp2=`echo $comp2 | grep -oE '[^\.]+$'`
						if [ ${#comp2} -eq 0 ]
						then
							comp2="#"
						fi
					else
						comp2="%"
					fi
					;;
				
				#t, on récupère le type
				t)	if [ -d $j ]
					#Si c'est un répertoire
					then
						comp1=0
					elif [ -f $j ]
					#Si c'est un fichier
					then
						comp1=1
					elif [ -L $j ]
					#Si c'est un lien
					then
						comp1=2
					elif [ -b $j ]
					#Si c'est un fichier spécial de type bloc
					then
						comp1=3
					elif [ -c $j ]
					#Si c'est un fichier spécial de type caractère
					then
						comp1=4
					elif [ -p $j ]
					#Si c'est un tubé nommé
					then
						comp1=5
					elif [ -S $j ]
					#Si c'est un socket
					then
						comp1=6
					fi
					if [ -d $inf ]
					then
						comp2=0
					elif [ -f $inf ]
					then
						comp2=1
					elif [ -L $inf ]
					then
						comp2=2
					elif [ -b $inf ]
					then
						comp2=3
					elif [ -c $inf ]
					then
						comp2=4
					elif [ -p $inf ]
					then
						comp2=5
					elif [ -S $inf ]
					then
						comp2=6
					fi
					;;
				#t, on récupère le nom du propriétaire
				p)	comp1=`stat -c %U $j`
					comp2=`stat -c %U $inf`
					;;
				#t, on récupère le groupe du propriétaire
				g)	comp1=`stat -c %G $j`
					comp2=`stat -c %G $inf`
					;;
				esac
				#On retire la première lettre de tmpOptions
				tmpOptions=${tmpOptions:1}
			done
			#Si comp1 et comp2 sont des nombres (donnés par les options de tri s, l et t),
			#la comparaison sera donc faite par "-lt" ou "-gt"
			if [ $first = "s" ] || [ $first = "l" ] || [ $first = "t" ]
			then
				if [ $comp = "<" ]
				then
					comp="-lt"
				elif  [ $comp = ">" ]
				then
					comp="-gt"
				fi
			#Sinon, ce sont des nombres chaînes de caractères,
			#la comparaison sera donc faite par "<" ou ">"
			else
				if [ $comp = "-lt" ]
				then
					comp="<"
				elif [ $comp = "-gt" ]
				then
					comp=">"	
				fi
			fi
			#On compare comp1 et comp2
			if [ $comp1 $comp $comp2 ]
			then
				#On change la valeur de inf par celle de j (car une valeur inférieure à min a été trouvé)
				inf="$j"
			fi
		done
		#On affiche le nom du répertoire/fichier minimal, précédé de indent, qui représente l'indentation de l'arborescence
		echo "$indent ${inf#./}"
		#Si inf est un répertoire et que l'option "-R" a été entré, nous faisons un appel récursif dans ce répertoire pour afficher l'arborescence
		if [ -d $inf ] && [ $boolArborescence -eq 1 ]
		then
			#On modifie indent pour indenter l'affichage
			echo "$indent \\"
			indent="$indent -"
			#On se déplace dans le répertoire et on y fait un appel récursif
			( cd $inf && sortFolder $inf )
			#Après l'appel récursif, il faut actualiser l'indentation
			indent=${indent#" -"}
			echo "$indent /"
		fi
		#On adapte inf pour pouvoir le retirer des noms avec sed
		inf=`echo "${inf/\.\//°\\\.\\\/}"`
		#On retire inf des noms puiqu'il a été traité (trié et affiché)
		noms=`echo $noms | sed -e "s/$inf//g"`
	done
}

#Fonction principale

#S'il n'y a pas de paramètre
if [ $# -eq 0 ]
then
	echo "Il n'y a pas de paramètre, il y en faut au moins 1"
	echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
	exit 1
#S'il y a plus de 4 paramètres
elif [ $# -gt 4 ]
then
	echo "Il y trop de paramètres, il y en faut au plus 4"
	echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
	exit 2
#Si le dernier paramètre n'est pas un répertoire
elif ! [ -d ${@: -1} ]
then
	echo "Erreur : ${@: -1} n'est pas un répertoire"
	echo "La syntaxe de votre commande doit être de la forme : $0 [-R] [-d] [-nsmletpg] folder"
	exit 3

#Si le nombre de paramètres est correct et que le dernier est un répertoire, on lance le script
else
	#Initialisation des variables
	ident=""
	comp="<"
	folder=$1
	boolArborescence=0
	boolPrintNoOption=0
	boolNom=0
	boolTaille=0
	boolDate=0
	boolLignes=0
	boolExt=0
	boolType=0
	boolProp=0
	boolGroupe=0
	#On récupère le répertoire et les options
	getFolderAndOptions $@
	#On se déplace dans le répertoire folder
	cd $folder
	#On trie les noms des répertoires/fichiers dans le répertoire folder
	sortFolder $folder
fi
