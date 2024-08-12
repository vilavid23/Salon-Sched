#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~ Salon Services ~~~\n"

MAIN_MENU(){
  
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi
   
SERVICE_MENU=$($PSQL "SELECT service_id, name FROM services")

echo "$SERVICE_MENU" | while read SERVICE_ID BAR NAME
do
ID=$(echo $SERVICE_ID | sed 's/ //g' )
SERVICE=$(echo $NAME | sed 's/ //g' )
echo "$ID) $SERVICE"
done
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in 
[1-3]) NEXT ;;
*) MAIN_MENU "Please make a valid selection"
esac
}

NEXT () {
  echo "Please input your phone number"
  read CUSTOMER_PHONE
  
 CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
  echo "Looks like you're not in our system yet. Please enter your first name :D"
    # get new customer name
  read CUSTOMER_NAME
  # insert new customer
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  echo "Hello, $CUSTOMER_NAME! Welcome!"
  else 
  echo "Hello $CUSTOMER_NAME! Good to see you again."
  fi
  echo -e "\nWhat time would you like to book your appointment for?"
  read SERVICE_TIME
  
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_APP=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  FORMAT_SERVICE=$(echo $SERVICE_NAME | sed 's/ //g' )
  FORMAT_CUSTOMER=$(echo $CUSTOMER_NAME | sed 's/ //g' )
echo -e "\nI have put you down for a $FORMAT_SERVICE at $SERVICE_TIME, $FORMAT_CUSTOMER."
}



EXIT(){
  echo Thank you for coming!
}

MAIN_MENU