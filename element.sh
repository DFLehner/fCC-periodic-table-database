PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#First check if an argument is given. If not, there is nothing to do but exit.
if [ -z "$1" ]
  then
    echo "Please provide an element as an argument."

else
#If an argument is given, we must search for the relevant data in the PSQL database.
#There will be 3 accepted formats, atomic number, element name, and element symbol.

    GET_ELEM_INFO=$($PSQL "SELECT * FROM elements FULL JOIN properties USING( atomic_number ) FULL JOIN types USING( type_id ) WHERE name = '$1';")
    if [[ -z $GET_ELEM_INFO ]] #First check if valid name given.
    then #if it wasn't, check if valid symbol.
      GET_ELEM_INFO=$($PSQL "SELECT * FROM elements FULL JOIN properties USING( atomic_number ) FULL JOIN types USING( type_id ) WHERE symbol = '$1';")
      if [[ -z $GET_ELEM_INFO && $1 =~ ^[0-9]+$ ]] #finally check if valid number given.
      then 
        GET_ELEM_INFO=$($PSQL "SELECT * FROM elements FULL JOIN properties USING( atomic_number ) FULL JOIN types USING( type_id ) WHERE atomic_number = $1;")
      fi
      if [[ -z $GET_ELEM_INFO ]] #if still no data found, exit script.
        then
          echo "I could not find that element in the database."
          exit
        fi

#Now processing data that has been found to give to user.

    fi
          echo "$GET_ELEM_INFO" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done

    
fi