#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $* ]]
then 
 echo "Please provide an element as an argument."
else
 if [[ $1 =~ ^[0-9]+$ ]]
 then
  QUERY_RESULT=$($PSQL "select * from elements full join properties using(atomic_number) full join types using(type_id) where atomic_number=$1")
 else
  QUERY_RESULT=$($PSQL "select * from elements full join properties using(atomic_number) full join types using(type_id) where symbol='$1' or name='$1'")
 fi
 if [[ $QUERY_RESULT ]]
 then
  echo "$QUERY_RESULT" | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME WEIGHT MELTING_POINT BOILING_POINT TYPE
  do echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
 else
  echo "I could not find that element in the database." 
 fi
fi