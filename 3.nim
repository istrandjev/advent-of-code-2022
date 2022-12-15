import os
import strutils

var
  sum = 0
while true:
  var
   l1:string = stdin.readLine
   l2:string = stdin.readLine
   l3:string = stdin.readLine
   a = ""
   b = ""
  if l1.len == 0:
    break
  else:
    for c in l1:
      if c in l2 and c in l3:

        if c <= 'Z':
          sum += int(c) - int('A') + 27
        else:
          sum += int(c) - int('a') + 1
        echo sum
        break
