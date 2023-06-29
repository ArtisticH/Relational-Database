#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

OUTPUT_NUMBER() {
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where $1=$2")
  SYMBOL=$($PSQL "select symbol from elements where $1=$2")
  NAME=$($PSQL "select name from elements where $1=$2")

  if [[ -z $ATOMIC_NUMBER ]]
  then
    # 인수 없을때
    echo "I could not find that element in the database."
  else
    # 인수가 있다면
    ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ATOMIC_NUMBER")
    MELTING=$($PSQL "select melting_point_celsius from properties where atomic_number=$ATOMIC_NUMBER")
    BOILING=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ATOMIC_NUMBER")

    # type
    TYPE=$($PSQL "select type from properties left join types using (type_id) where atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
}

OUTPUT_STRING() {
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where $1='$2'")
  SYMBOL=$($PSQL "select symbol from elements where $1='$2'")
  NAME=$($PSQL "select name from elements where $1='$2'")

  if [[ -z $ATOMIC_NUMBER ]]
  then
    # 인수 없을때
    echo "I could not find that element in the database."
  else
    # 인수가 있다면
    ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ATOMIC_NUMBER")
    MELTING=$($PSQL "select melting_point_celsius from properties where atomic_number=$ATOMIC_NUMBER")
    BOILING=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ATOMIC_NUMBER")

    # type
    TYPE=$($PSQL "select type from properties left join types using (type_id) where atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
}


if [[ ! $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  # 인수가 atomic_number라면
  if [[ $1 =~ ^[0-9]*$ ]] 
  then
    NUM=$1
    OUTPUT_NUMBER atomic_number $NUM
  elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
    then
    SYM=$1
    OUTPUT_STRING symbol $SYM
  else
    NAM=$1
    OUTPUT_STRING name $NAM
  fi
fi
