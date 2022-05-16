#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Check if input is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    IFS='|' read ATOMIC_NUMBER SYMBOL ELEMENT <<< $($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL ELEMENT ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< $($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  else
    IFS='|' read ATOMIC_NUMBER SYMBOL ELEMENT <<< $($PSQL "SELECT * FROM elements WHERE symbol='$1' OR name='$1'")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL ELEMENT ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< $($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  fi
fi
