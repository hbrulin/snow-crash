# snow-crash
Besoin de :
- gdb
- lecteur pcap -> cloudshark.org
- John : logiciel pour craquer des passwords
- scripts python

autres sites :
- dcode.fr - pour un ou deux niveaux
- duckduckgo.com


Process:
- trouver password
- se connecter au user flagXX avec password : su flag00. La commande "su" (Switch User) permet d'ouvrir une session avec l'ID d'un autre utilisateur
- getflag
- se connecter au level suivant : su levelXX

-Start : 
Mount: https://www.techwalla.com/articles/how-to-mount-mdf-mds-files
In VM settings, change the first internet adapter by Host-Only Adapter (for ssh connexion)
ssh level00@ip -p 4242
login:password : level00:level00

- Container for external programs
docker build -t img .
docker run -it img
https://github.com/rothgar/docker-john/blob/master/Dockerfile
TODO:
- retirer les trucs inutiles du dockerfile à la fin
- ssh keygen necessary?


- Level00
find . : current and subdir
find / : in /home and directories below
find -user : look for files that have been changed by a user
If I find -user for flag00 user, two files are not "permission denied" : usr/sbin/john and the same in /rofs : read only file system
It is a password file for John The Ripper : https://www.varonis.com/blog/john-the-ripper/
JtR autodetects the encryption on the hashed data and compares it against a large plain-text file that contains popular passwords, hashing each password, and then stopping it when it finds a match.

view file perm of john binary : ls -l /usr/sbin/john
i cannot change its permission with sudo chmod +x /usr/sbin/john. /sbin is for binaries superuser (root) privileges required.
so i cannot use john on encrypted data (that would be brute force)

the encrypted password in the file was encrypted with rot11 (ceasar cypher): It replaces each letter with the letter 11 positions after that letter.
rot13 : echo "cdiiddwpgswtgt" | tr '[A-Za-z]' '[N-ZA-Mn-za-m]'
The tr command in UNIX is a command line utility for translating or deleting characters.
https://www.geeksforgeeks.org/tr-command-in-unix-linux-with-examples/#:~:text=The%20tr%20command%20in%20UNIX,to%20support%20more%20complex%20translation. 
for rot15 : tr '[A-Za-z]' '[P-ZA-Op-za-o]'
rot11 : tr '[A-Za-z]' '[L-ZA-Kl-za-k]'

TODO:
- implement a program that tries different rotations until it works with 'su flag00'

launch getflag - save it in level00
-> use it for "su level01"

- level01
dans /etc : fichiers de configuration
il y a un fichier de conf passwd: traditional Unix password file. - The command passw can be used to change password of current user.
There is also /etc/shadow which stores actual password in encrypted format : https://www.cyberciti.biz/faq/understanding-etcshadow-file/.
/etc/shadow cannot be cat : -rw-r----- (first triad owner, 2nd group mbs, third others).
But /etc/passwd can be cat, il y a une ligne : flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash.
Le password n'est pas caché comme les autres.
Mettre le password dans un file et l'envoyer dans le conteneur docker. 
Lancer john.