#!/bin/bash

counter=0

while [ $counter -lt 50 ]; do
  let counter=counter+1

  name=$(nl people.txt | grep -w $counter | awk '{print $2}')
  lastname=$(nl people.txt | grep -w $counter | awk '{print $3}')
  age=$(shuf -i 20-40 -n 1)
  
  mysql  -u root -p1234 people -e "INSERT INTO register values($counter, '$name', '$lastname', $age);"
  echo "[LOG] Inserted $counter: $name $lastname $age successfully."

done

