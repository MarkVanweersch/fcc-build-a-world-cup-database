#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# empty tables
echo $($PSQL "TRUNCATE games, teams;")

# insert teams
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
  if [[ $YEAR != "year" ]]
  then
    # insert winner teams
    TEAM=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER';")
    if [[ -z $TEAM ]] 
    then
      echo $($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      echo Team inserted: $WINNER
    fi

    # insert opponent teams
    TEAM=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT';")
    if [[ -z $TEAM ]] 
    then
      echo $($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      echo Team inserted: $OPPONENT
    fi
  fi
done

# insert games
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  echo $($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
done