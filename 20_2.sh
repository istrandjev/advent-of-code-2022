#!/bin/bash
# Requires bash version >= 4, so default on mac will not work

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
      RESULT=$(( $target + 1))
    else
      RESULT=$target
    fi
  fi
}

a=( $( cat /dev/stdin | tr '\n' ' ' ) )
n=${#a[@]}
declare -a map
declare -a inv
for i in $(seq 0 $((n - 1))); do
  a[$i]=$(( ${a[$i]} * 811589153))
  map[$i]=$i
  inv[$i]=$i
done

for it in {1..10}; do
  i=0
  steps=0
  skips=0
  for ii in $(seq 0 $(( $n - 1)) ); do
    i=${map[$ii]}
    steps=$(( $steps + 1))
    if (( $steps % 100 == 0)); then
      echo "($it) $steps: Processing $ii... ${a[$i]}"
    fi

    get_position $i ${a[$i]} $n
    position=$RESULT
    temp=${a[$i]}
    if (( $position == $i )); then
      a[$position]=$temp
      continue
    fi
    if (( $position < $i )); then
      for j in $(seq $i -1 $(( $position + 1 ))); do
        prev=$(( $j - 1 ))
        map[${inv[$prev]}]=$j
        inv[$j]=${inv[$prev]}
        a[$j]=${a[$prev]}
      done

      map[$ii]=$position
      inv[$position]=$ii
      a[$position]=$temp
    else
      for j in $(seq $i $(( $position - 1 ))); do
        nxt=$(( $j + 1))

        map[${inv[$nxt]}]=$j
        inv[$j]=${inv[$nxt]}
        a[$j]=${a[$nxt]}
      done
      map[$ii]=$position
      inv[$position]=$ii
      a[$position]=$temp
    fi
  done
done
for i in $(seq 0 $(( $n - 1))); do
  if (( ${a[$i]} == 0 )); then
    ZERO_INDEX=$i
    break
  fi
done
echo $ZERO_INDEX
echo ${a[@]} >20.backup
res=0
for pos in $(seq 1000 1000 3000); do
  index=$((($pos + $ZERO_INDEX) % $n))
  echo $((${a[$index]}))
  res=$(( $res + ${a[$index]}))
done
echo $res

