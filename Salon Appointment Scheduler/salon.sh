#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

 # $PSQL "truncate customers, services, appointments"
 # $PSQL "insert into services(name) values('cut'), ('color'), ('perm'), ('style'), ('trim')"
 # $PSQL "ALTER SEQUENCE services_service_id_seq RESTART WITH 1"
 # $PSQL "ALTER SEQUENCE customers_customer_id_seq RESTART WITH 1"
 # $PSQL "ALTER SEQUENCE appointments_appointment_id_seq RESTART WITH 1"


echo -e "\n~~~~~ MY SALON ~~~~~\n"

ASKING_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  if [[ ! $1 ]]
  then
    echo -e "Welcome to My Salon, how can I help you?\n"
  fi
  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT $SERVICE_ID_SELECTED ;; 
    2) MAKE_APPOINTMENT $SERVICE_ID_SELECTED ;;
    3) MAKE_APPOINTMENT $SERVICE_ID_SELECTED ;;
    4) MAKE_APPOINTMENT $SERVICE_ID_SELECTED ;;
    5) MAKE_APPOINTMENT $SERVICE_ID_SELECTED ;;
    *) ASKING_MENU "I could not find that service. What would you like today?"
  esac
}

MAKE_APPOINTMENT() {
  SERVICE=$1
  SERVICE_ID=$($PSQL "select service_id from services where service_id=$SERVICE")
  SERVICE_NAME="$($PSQL "select name from services where service_id=$SERVICE")"

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  PHONE_DATA="$($PSQL "select phone from customers where phone='$CUSTOMER_PHONE'")"

  if [[ -z $PHONE_DATA ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    INSERT_NAME_PHONE=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  NAME_DATA="$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")"

  NAME_DATA_FORMATTED=$(echo $NAME_DATA | sed 's/^ *//')
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/^ *//')

  echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $NAME_DATA_FORMATTED?"
  read SERVICE_TIME

  INSERT_TIME="$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")"

  if [[ $INSERT_TIME == "INSERT 0 1" ]] 
  then
    echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $NAME_DATA_FORMATTED.\n"
  fi
}

ASKING_MENU
