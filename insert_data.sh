#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "truncate table games,teams;"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
 if [[ $YEAR != year ]]
 then 
  if [[ -z $($PSQL "select * from teams where name='$WINNER';") ]]
  then $PSQL "insert into teams(name) values('$WINNER');"
  fi
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
  if [[ -z $($PSQL "select * from teams where name='$OPPONENT';") ]]
  then $PSQL "insert into teams(name) values('$OPPONENT');"
  fi
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
  $PSQL "insert into games(round,year,winner_goals,opponent_goals,winner_id,opponent_id) values('$ROUND',$YEAR,$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID);"
 fi
done

