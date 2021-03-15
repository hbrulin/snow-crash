# snow-crash
Besoin de :
- gdb
- lecteur pcap -> cloudshark.org
- John : logiciel pour craquer des passwords
- scripts python

autres sites :
- dcode.fr - pour un ou deux niveaux
- duckduckgo.com


Rendu : 
- dossier level -> fichier flag (parfois pas de flag), dossier Ressources

Process:
- trouver flag
- se connecter au level avec password : su flag00. La commande "su" (Switch User) permet d'ouvrir une session avec l'ID d'un autre utilisateur
- getflag



Mount: https://www.techwalla.com/articles/how-to-mount-mdf-mds-files
In VM settings, change the first internet adapter by Host-Only Adapter (for ssh connexion)
ssh level00@ip -p 4242
level00:level00

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

the encrypted password in the file was encrypted with rot11 (ceaser cypher): It replaces each letter with the letter 11 positions after that letter.
rot13 : echo "cdiiddwpgswtgt" | tr '[A-Za-z]' '[N-ZA-Mn-za-m]'
The tr command in UNIX is a command line utility for translating or deleting characters.
https://www.geeksforgeeks.org/tr-command-in-unix-linux-with-examples/#:~:text=The%20tr%20command%20in%20UNIX,to%20support%20more%20complex%20translation. 
for rot15 : tr '[A-Za-z]' '[P-ZA-Op-za-o]'
rot11 : tr '[A-Za-z]' '[L-ZA-Kl-za-k]'

TODO:
- implement a program that tries different rotations until it works with 'su flag00'

launch getflag - save it in level00
-> use it for "su level01"









Info:
- commande scp : https://technique.arscenic.org/transfert-de-donnees-entre/article/scp-transfert-de-fichier-a-travers 