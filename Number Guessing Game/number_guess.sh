#!/bin/bash

# \pset pager off
# alter sequence users_user_id_seq restart with 1;
# alter sequence games_game_id_seq restart with 1;
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# 1에서 1000까지 랜덤 숫자가 나오면 그걸 유저가 맞추는
# 1부터 1000까지의 랜덤 숫자
IT=$(( $RANDOM % 1000 + 1 ))
# echo $IT

# 이름 입력,최대 22자
echo "Enter your username:"
read INPUT_NAME

# USERNAME으로 데이터베이스에서 정보 뽑아오기
USERNAME=$($PSQL "SELECT username FROM users where username='$INPUT_NAME'")

# 첫 유저 
if [[ -z $USERNAME ]]
then
  echo -e "\nWelcome, $INPUT_NAME! It looks like this is your first time here."
  INSERT_USER="$($PSQL "insert into users(username) values('$INPUT_NAME')")"
  USER_ID=$($PSQL "select user_id from users where username='$INPUT_NAME'")
else
  # 기존 유저
  USER_ID=$($PSQL "select user_id from users where username='$USERNAME'")
  # 게임 참여 횟수
  GAME_NUMBERS=$($PSQL "select count(user_id) from games where user_id=$USER_ID")
  # 가장 적은 guess
  MINIMUM_GUESS=$($PSQL "select min(guess_count) from games where user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAME_NUMBERS games, and your best game took $MINIMUM_GUESS guesses."
fi

# 게임 시작
echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS

COUNT=1
# until
until [[ $GUESS == $IT ]] 
do 
  (( COUNT++ ))
  # 숫자라면
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    # 큰 수라면
    if [[ $GUESS > $IT ]]
    then
      echo -e "\nIt's lower than that, guess again:"
      read GUESS
    else
    # 작은 수라면
      echo -e "\nIt's higher than that, guess again:"
      read GUESS
    fi
  else
    # 숫자가 아니라면
    echo -e "\nThat is not an integer, guess again:"
    read GUESS
  fi
done

# 맞춘다면
if [[ $GUESS == $IT ]]
then
  INSERT_GAME="$($PSQL "INSERT INTO games(user_id, guess_count) values($USER_ID, $COUNT)")"
  echo -e "\nYou guessed it in $COUNT tries. The secret number was $IT. Nice job!"
fi
