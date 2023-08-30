#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
MAIN_MENU() {
  echo -e "\n~~~~~ MY SALON ~~~~~"
  echo -e "\nWelcome to My Salon, how can I help you?\n"
  SERVICES=$($PSQL "select * from services")
  echo "$SERVICES" | sed "s/|/) /g"
  read SERVICE_ID_SELECTED
  SERVICE_RESULT=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  while [[ -z $SERVICE_RESULT ]]
  do
   echo -e "\nI could not find that service. What would you like today?"
   echo "$SERVICES" | sed "s/|/) /g"
   read SERVICE_ID_SELECTED
   SERVICE_RESULT=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  done 
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_RESULT=$($PSQL "select * from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_RESULT ]]
  then 
   echo -e "\nI don't have a record for that phone number, what's your name?"
   read CUSTOMER_NAME
   ONE=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME
  TWO=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_RESULT at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU


