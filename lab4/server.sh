#!/bin/bash

if [ "$3" == "potomny" ]
then
  liczba=$1
  klient=$2
  result=$(($liczba+1))
  echo $result > $klient/klientfifo
  exit 0
fi

czysc() {
  echo "Koniec pracy serwera"
  rm -f ~/serwerfifo
  exit 0
}

trap "" SIGHUP
trap "" SIGTERM

trap "czysc" SIGUSR1
trap "czysc" SIGINT

if [ ! -p ~/serwerfifo ]
then
  mkfifo ~/serwerfifo
fi

while true
do
  client_msg=`cat < ~/serwerfifo`
  array=($client_msg)
  klient_home=${array[0]}
  number=${array[1]}
  $0 $number $klient_home potomny &
done
