#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

$PSQL "SELECT atomic_number FROM elements ORDER BY atomic_number" | while read ATOMIC_NUMBER
do
  ATOMIC_NUMBER_TRIMMED=$(echo $ATOMIC_NUMBER | sed 's/ //g')
  ATOMIC_NUMBER_FROM_PROPERTIES=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number=$ATOMIC_NUMBER_TRIMMED")
  if [[ -z $ATOMIC_NUMBER_FROM_PROPERTIES ]]
  then
    if [[ $ATOMIC_NUMBER_TRIMMED == 10 ]]
    then
      echo -e "Тип элемента\n"
      TYPE="nonmetal"
      echo $TYPE
      TYPE_ID_FROM_TYPES=$($PSQL "SELECT type_id FROM types WHERE type='$TYPE'")
      if [[ -z $TYPE_ID_FROM_TYPES ]]
      then
        echo "Нет такого"
      else
        INSERT_ATOMIC_NUMBER_RESULT=$($PSQL "INSERT INTO properties (atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id, type) VALUES ($ATOMIC_NUMBER_TRIMMED, 20.18, -248.6, -246.1, $TYPE_ID_FROM_TYPES, '$TYPE')")
        if [[ $INSERT_ATOMIC_NUMBER_RESULT == 'INSERT 0 1' ]]
        then
          echo "Inserted into properties, $($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER_TRIMMED")"
        fi
      fi
    else
      INSERT_ATOMIC_NUMBER_RESULT=$($PSQL "INSERT INTO properties (atomic_number) VALUES ($ATOMIC_NUMBER_TRIMMED)")
      if [[ $INSERT_ATOMIC_NUMBER_RESULT == 'INSERT 0 1' ]]
      then
        echo "Inserted into properties, $ATOMIC_NUMBER_TRIMMED"
      fi
    fi
  else
    if [[ $ATOMIC_NUMBER_TRIMMED == 9 ]]
    then
      echo -e "\nТип элемента\n"
      TYPE="nonmetal"
      echo $TYPE
      TYPE_ID_FROM_TYPES=$($PSQL "SELECT type_id FROM types WHERE type='$TYPE'")
      if [[ -z $TYPE_ID_FROM_TYPES ]]
      then
        echo "Нет такого"
      else
        UPDATE_RESULT=$($PSQL "UPDATE properties SET type='$TYPE', type_id=$TYPE_ID_FROM_TYPES WHERE atomic_number=$ATOMIC_NUMBER_TRIMMED")
        if [[ $UPDATE_RESULT == 'UPDATE 1' ]]
        then
          echo "Updated properties, $($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER_TRIMMED")"
        fi
      fi
    fi
  fi
done
