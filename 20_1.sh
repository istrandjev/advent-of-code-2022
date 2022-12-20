#!/bin/bash
# Requires bash version >= 4, so default on mac will not work

#function solve() {
#  key="$@"
#  if [ ${mem["$key"]+_} ];
#  then
#    result=mem["$key"]
#    return
#  fi
#  local ore_robots=$1
#  local clay_robots=$2
#  local obsidian_robots=$3
#  local geode_robots=$4
#  local ore=$5
#  local clay=$6
#  local obsidian=$7
#  local minutes=$8
#
#  result=$(solve $((ore_robots))
#  mem["$key"]=result
#}
#function print_robot() {
#  echo for index $index we need $ore_ore ore to build an ore robot
#  echo for index $index we need $clay_ore ore to build a clay robot
#  echo for index $index we need $obsidian_ore ore and $obisdian_clay clay to build an obisdian robot
#  echo for index $index we need $geode_ore ore and $geode_obisidian obsidian to build a geode robot
#}
#
#function process_blueprint() {
#  local ores=$( echo $1 | grep -E '[0-9]+ ore' -o | grep -E '[0-9]+' -o | tr '\n' ' ' )
#  ore_ore=$( echo $ores | cut -d ' ' -f 1 )
#  clay_ore=$( echo $ores | cut -d ' ' -f 2 )
#  obsidian_ore=$( echo $ores | cut -d ' ' -f 3 )
#  obisdian_clay=$( echo $1 | grep -E '[0-9]+ clay' -o | grep -E '[0-9]+' -o )
#  geode_ore=$( echo $ores | cut -d ' ' -f 4 )
#  geode_obisidian=$( echo $1 | grep -E '[0-9]+ obsidian' -o | grep -E '[0-9]+' -o )
#  print_robot
#}


#index=1
#result=0
#declare -A mem
#while IFS='$\n' read -r line; do
#    echo "$index Read a line $line"
#
#    process_blueprint "$line"
#
#    # result=""
#    index=$(( $index + 1))
#done
#
#echo $(( 5 / 3))

function get_position() {
  local i=$1
  local move=$2
  local n=$3
  local t=$(( $n - 1))
  local temp=$(( ${a[$i]} % $t))
  local target=$(( (($i +  $temp) % $n + $n) % n ))

  if (( $target == $i)); then
    RESULT=$target
    return
  fi

  if (( $move < 0)); then
    if (( $target > $i)); then
      RESULT=$(( $target - 1 ))
    else
      RESULT=$target
    fi
  else
    if (( $target < $i)); then
      if (( $(( $target + 1 )) == $(( $n - 1)) )); then
        RESULT=0
      else
        RESULT=$(( $target + 1))
      fi

    else
      RESULT=$target
    fi
  fi
}

SENTINEL=100000
HALF_SENTINEL=$(( $SENTINEL / 2 ))
a=( $( cat /dev/stdin | tr '\n' ' ' ) )

n=${#a[@]}
i=0
steps=0
skips=0
while (( $i < $n ))
do
  steps=$(( $steps + 1))
  if (( $steps % 100 == 0)); then
    echo "$steps: Processing $i... ${a[$i]}"
  fi
  if (( ${a[$i]} >= HALF_SENTINEL )); then
    i=$(( $i + 1))
    skips=$(($skips + 1))
    continue
  fi

  get_position $i ${a[$i]} $n
  position=$RESULT
  temp=${a[$i]}
  if (( $position == $i )); then
    i=$(( $i + 1))
    a[$position]=$(( $temp + $SENTINEL))
    continue
  fi
  if (( $position < $i )); then
    for j in $(seq $i -1 $(( $position + 1 ))); do
      a[$j]=${a[$(( $j - 1 ))]}
    done
    a[$position]=$(( $temp + $SENTINEL))
    i=$(( $i + 1 ))
  else
    for j in $(seq $i $(( $position - 1 ))); do
      a[$j]=${a[$(( $j + 1 ))]}
    done
    a[$position]=$(( $temp + $SENTINEL))
  fi
done

for i in $(seq 0 $(( $n - 1))); do
  if (( ${a[$i]} == $SENTINEL )); then
    ZERO_INDEX=$i
    break
  fi
done
echo "Steps= $steps and skips $skips"
echo "$ZERO_INDEX"
res=0
for pos in $(seq 1000 1000 3000); do
  index=$((($pos + $ZERO_INDEX)% $n))
  echo $((${a[$index]} - $SENTINEL))
  res=$(( $res + ${a[$index]} - $SENTINEL))
done
echo $res
#while (( $i < 15))
#do
#  echo "Welcome $i times"
#  i=$(( $i + 1))
#  if (( $i == 9 )); then
#     i=$(( i + 1))
#  fi
#done
#
#if (( $i == 9 )); then
#  echo "Here"
#  i=$(( i + 2))
#fi
