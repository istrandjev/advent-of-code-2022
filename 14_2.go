package main
import (
	"fmt"
	"bufio"
	"os"
	"strings"
	"strconv"
	)

func main(){
	scanner := bufio.NewScanner(os.Stdin)
	var a = [1000][200]int{}
	moves := [3][2]int {{0, 1}, {-1, 1}, {1, 1}}
	maxy := 0
	for scanner.Scan() {
	  line := scanner.Text()
	  res1 := strings.Split(line, "->")
	  px, py := -1, -1
	  for idx, pt := range res1 {
		temp := strings.Split(pt, ",")
		x, _ := strconv.Atoi(strings.TrimSpace(temp[0]))
		y, _ := strconv.Atoi(strings.TrimSpace(temp[1]))
        if (y > maxy) {
            maxy = y
        }
		if (idx > 0) {
            sx, ex := px, x
            if (x < px) {
                sx, ex = x, px
            }
            sy, ey := py, y
            if (y < py) {
                sy, ey = y, py
            }
            for ix := sx; ix <= ex; ix++ {
              for iy := sy; iy <= ey; iy++ {
                a[ix][iy] = 1
              }
            }
		}
		px, py = x, y
	  }
	}
	for ix := 0; ix < 1000; ix++ {
	    a[ix][maxy + 2] = 1
	}

	res := 0
	for {
	   cx, cy := 500, 0
	   for {
	     moved := false

	     for l := 0; l < 3; l += 1 {
	        tx, ty := cx + moves[l][0], cy + moves[l][1]

	        if (tx < 0 || tx >= 1000 || a[tx][ty] != 0) {
	            continue
	        }

	        cx, cy = tx, ty
	        moved = true
	        break
	     }
	     if (moved == false && cy < 180) {
	        a[cx][cy] = 2
	        res += 1
	        break
 	     }
	   }
	   if (cy == 0) {
	     break
	   }

	}
	fmt.Println(maxy + 2)
    fmt.Print(res)
}