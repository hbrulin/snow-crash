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
docker inspect to know IP - see if i can scp from VM to docker, otherwise it's still fine
https://github.com/rothgar/docker-john/blob/master/Dockerfile
TODO:
- retirer les trucs inutiles du dockerfile à la fin
- ssh keygen necessary?
- better to do it all from docker?


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

password : nottoohardhere

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
Lancer john qui va essayer de casser le password file.
John peut aussi unshadow un shadow passwd file (ici on ne peut pas)

password:abcdefg

- level02
There is a pcap file in /home/user/level02
Possible to open it with tshark (better than wireshark from command line) : https://www.wireshark.org/docs/man-pages/tshark.html.
Packet capture (PCAP) analysis is the process of obtaining and analyzing individual data packets that travel through your network.
PCAP (short for Packet Capture) is the name of the API commonly used to record packet metrics. PCAP files are especially helpful because they can record multilayer traffic data, capturing packets originating from the data link layer all the way to the application layer. If you’re looking to perform network packet analysis, chances are the software you’re using creates PCAP files.
https://www.dnsstuff.com/pcap-analysis 
https://www.hackingarticles.in/beginners-guide-to-tshark-part-1/
https://linuxhint.com/wireshark-command-line-interface-tshark/
https://baturorkun.medium.com/using-wireshark-command-line-tool-tshark-62a32beef12c
Here I found the info on how to look for credentials in pcap file: https://www.infosecmatter.com/capture-passwords-using-wireshark/#capture_passwords_with_tshark 
I can see the hex dump that corresponds to the password.
Info on hex dumps : https://www.wireshark.org/docs/wsug_html_chunked/ChIOImportSection.html
Then I print all the data streams and find the one that says "Password" (000d0a50617373776f72643a20) : tshark -r level02.pcap -T fields -e  data
ALl of what is below is my password being sent, until last line : 
66
74
5f
77
61
6e
64
72
7f
7f
7f
4e
44
52
65
6c
7f
4c
30
4c
0d
000d0a
01

Decode it here: https://www.convertstring.com/fr/EncodeDecode/HexDecode ==> ft_wandrNDRelL0L
ou use echo data xxd -r -p : echo 66745f77616e64727f7f7f4e4452656c7f4c304c0d000d0a01 | xxd -r -p


- level 03
There is a binary that, when launched, says Exploit me.
If i cat the file, I see "/usr/bin/env echo Exploit me"
I can in /tmp file, create a file called echo and use getflag in it. (I can do it where I am if i use chmod 777 .)

TODO : but why does it work in binary but not normally? histoire de droit suid? voir ls -la si c'est bien grâce à ça.

Go directly to level04 with the flag.

- level04
Il y a un fichier : level04.pl. C'est un script perl.
On voit l'adresse où on peut envoyer une requête.
L'envoi curl requête POST correspond à taper http://192.168.99.106:4747/?x=`getflag` dans browser.

TODO: 
- bien comprendre chaque ligne du script perl.
- pourquoi les quotes ``?

- level 5
Chercher un folder level05 de la même manière qu'au level00.
Aller voir ce mail : */2 * * * * su -c "sh /usr/sbin/openarenaserver" - flag05
It's a cron tab -> the file openarenaserver is launched regularly. It's a script that executed script in the folder /opt/openarenaserver.
Create a script that calls getflag, and wait for it to disappear (accoridng to cron time job).

- level06
One script and one binary in home.
level06 execute level06.php with the flag06 suid : https://fr.wikipedia.org/wiki/Permissions_UNIX#Droit_SUID -> Lorsque le droit SUID est appliqué à un exécutable et qu'un utilisateur quelconque l'exécute, le programme détiendra alors les droits du propriétaire du fichier durant son exécution. -> ça se voit avec ls -la. donc si je l'exécute correctement, j'ai les bons droits pour getflag.
Changer le fichier php pour qu'il call getflag.

- level07
./level07 outputs level07.
I want to know what prints it so I use ltrace : ltrace is a program that simply runs the specified command until
       it exits.  It intercepts and records the dynamic library calls
       which are called by the executed process and the signals which
       are received by that process.  It can also intercept and print
       the system calls executed by the program.
What is printed is the env var LOGNAME, through an echo.
So I add a command to the echo through export LOGNAME="&& getflag"

todo :
- check the diff btw strace and ltrace


- level08
Here level08 binary has suid of flag08, so if I execute I would act with the rights of flag08.
Level08 seems to be a binary that reads a file given in input.
./level08 token -> you may not access token. It has rw rights only for flag08. and
But if I check the calls in ltrace, I can see that it only check whether or not the input file is called "token".
So I chmod 777. puis change the name of token file.
Then launch ./level08 tok --> quif5eloekouj29ke0vouxean
Puis login to flag08, getflag et level09.

TODO :
- check if it's better to chmod 777 . or to make a soft link.
- vérifier ce que fait exactement chmod777

- level09
It seems that ./level09 takes a string and prints str[i] + i.
create a program that reads insode token file and does the same in reverse.
I get password : f3iji1ju5yuevaus41q1afiuq.
