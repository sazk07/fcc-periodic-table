#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"
if [[ $1 ]]
then
  # check if input is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1;")
  # check if input is a letter
  elif [[ $(echo $1 | wc -c) < 4 ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1';")
  # check if input is a name
  else
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$1';")
  fi
  # if not found
  if [[ -z $ELEMENT ]]
  then
    echo I could not find that element in the database.
  # else read output in while loop and destructure
  else
    echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING BOILING
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
else
  echo Please provide an element as an argument.
fi
