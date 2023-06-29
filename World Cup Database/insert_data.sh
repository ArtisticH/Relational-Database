#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # 첫줄생략
  if [[ $YEAR != 'year' ]]
  then
    # team table 만들기

    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name='$WINNER'")
    TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name='$OPPONENT'")

    if [[ -z $TEAM_ID_WINNER ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      TEAM_ID_WINNER=$($PSQL "select team_id from teams where name='$WINNER'")
    fi

    if [[ -z $TEAM_ID_OPPONENT ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi
    # team table 만들기 끝
    

    # games table 채우기
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    
    INSERT_GAMES_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', '$WINNER_ID', '$OPPONENT_ID', $WINNER_GOALS, $OPPONENT_GOALS)")

  fi
done
