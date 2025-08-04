#!/bin/bash

# Verifică dacă există fișierul de registru
if [ ! -f "utilizatori.csv" ]; then
    echo "ID,Nume,E-mail,Parola,Last_Login" > utilizatori.csv
fi
#vector pt utilizatorii autentificati
declare -a logged_in_users=()
#-a inseamna ca vectorul este indexat numeric, incepand de la 0


inregistrare(){
    read -p 'Introduceti numele de utilizator: ' csv_username

    # Verifică dacă numele de utilizator există deja
    grep "^$csv_username" "utilizatori.csv" && verif=0 || verif=1
    if (( $verif == 0 )); then
    echo "Utilizatorul exista deja!" && exit 1
    else
    echo "Introduceti datele: "
    fi
    read -sp 'Introduceti parola (trebuie sa contina litere mari, mici, sau cifre): ' csv_password

    if [[ "$csv_password" =~ [A-Za-z0-9] ]]; then
    echo "Parola corecta!"
    else
    echo "Parola incorecta!" && exit 1
    fi

    read -sp 'Confirmati parola: ' password_c

    # Verifică dacă parolele coincid
    if [ "$csv_password" != "$password_c" ]; then
        echo "Parolele nu coincid!"
        exit 1
    fi
    read -p 'Introduceti e-mail(trebuie sa se termine cu "@student.ro": '  email
    if [[ ! "$email" =~ @student\.ro$ ]]; then
    echo "E-mail incorect!" && exit 1
    fi
    ID=$((1000 + RANDOM % 9000))
    home_director="home/$csv_username"
    mkdir -p "$home_director"
    # Adaugă utilizatorul în registru
    echo "$ID,$csv_username,$email,$csv_password" >> utilizatori.csv

    echo "Utilizatorul a fost înregistrat cu succes!"
}

#functie autentificare
autentificare_user() {
   local username password
   read -p 'Introduceti numele de utilizator: ' username
   read -sp "Introduceti parola: " password

   while IFS=, read -r ID csv_username email csv_password last_log; do
      if [[ "$username" == "$csv_username" && "$password" == "$csv_password" ]]; then
         echo "V-ati autentificat cu succes"

         #actualizare last_login
         last_login=$(date '+%Y.%m.%d %H:%M:%S')
         temp_file=$(mktemp)
         awk -F, -v user="$username" -v login="$last_login" 'BEGIN {OFS = FS} {if ($2 == user) $6 = login} 1' utilizatori.csv > "$temp_file" && mv "$temp_file" utilizatori.csv

         #se adauga utilizatorul la vectorul de utilizatori autentificati
         logged_in_users+=("$username")

         #se navigheaza la directorul home al utilizatorului
         cd "home/$username" || exit 1
         return
      fi
   done < utilizatori.csv

   echo "Nume de utilizator incorect"
}

#afisare lista de utilizatori autentificati
echo "Utilizatorii autentificati sunt: ${logged_in_users[@]}"


# Funcție pentru logout
delogare_user() {
   local username
   read -p 'Introduceti numele de utilizator pentru a va deloga: ' username

   #verifica daca username-ul exista in lista
   for (( i=0; i<${#logged_in_users[@]}; i++ )); do
      if [[ "${logged_in_users[i]}" == $username ]]; then
         unset 'logged_in_users[i]'
         echo "Utilizatorul s-a delogat cu succes"
         return
      fi
   done

   #daca username-ul nu exista in lista, se afiseaza mesajul
   echo "Utilizatorul nu este logat"
}


raport(){

local username
read -p "Introduceți numele de utilizator pentru generarea raportului: " username

dir_home="home/$username"

if [ ! -d "$dir_home" ]; then
    echo "Directorul home pentru acest utilizator nu exista"
    exit 1
fi

echo "Raport pentru utilizatorul $username: " > "$dir_home/report.txt"

# Calculăm numărul de fișiere, directoare și dimensiunea pe disc
num_files=$(find $dir_home -type f | wc -l)
num_dirs=$(find $dir_home -type d | wc -l)
disk_usage=$(du -hs $dir_home | awk '{print $1}')

# Generăm raportul în directorul "home" al utilizatorului
echo "Numărul de fișiere: $num_files" >> "$dir_home/report.txt"
echo "Numărul de directoare: $num_dirs" >> "$dir_home/report.txt"
echo "Dimensiunea pe disc: $disk_usage" >> "$dir_home/report.txt"
}


while true
do
    echo "Selectați o opțiune: "
    echo "1.Inregistrare"
    echo "2.Autentificare"
    echo "3.Logout utilizator"
    echo "4.Raport"
    echo "5.Iesire"
    read -p "Opțiunea dvs: " optiune

    case $optiune in
        1)
            inregistrare
            ;;
        2)
            autentificare_user
            ;;
        3)
            delogare_user
            ;;
        4)
            raport 
            ;;
        5)
            echo "La revedere!"
            exit 0
            ;;
        *)
            echo "Opțiune invalidă, vă rugăm să încercați din nou."
            ;;
    esac
done
