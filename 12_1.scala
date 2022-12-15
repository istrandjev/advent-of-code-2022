import scala.io.StdIn
import scala.collection.mutable.Queue
import scala.collection.mutable.HashMap

object Main extends App {
	var lines = Array[String]()
	var line = ""
	while ({line = StdIn.readLine(); line != null}) {
	    lines = lines :+ line
	}
	val moves = Array((0, 1), (1, 0), (0, -1), (-1, 0))
	
	var sx = -1
	var sy = -1
	var ex = -1
	var ey = -1
	for( i <- 0 to lines.length - 1) {
        for( j <- 0 to lines(i).length - 1) {
            if (lines(i)(j) == 'S') {
                sx = i
                sy = j
            }
            if (lines(i)(j) == 'E') {
                ex = i
                ey = j
            }
        }
    }
    
    var q = Queue[(Int, Int)]((sx, sy))
    var dist = HashMap[(Int, Int), Int]((sx, sy) -> 0)
    while (!q.isEmpty) {
        val c = q.dequeue
        
        for (l <- 0 to 3) {
            val tx = c._1 + moves(l)._1
            val ty = c._2 + moves(l)._2

            if (tx >= 0 && tx < lines.length && ty >= 0 && ty < lines(0).length) {
                val nxt = if (lines(tx)(ty) == 'E')  'z' else lines(tx)(ty)
                val cur = if (lines(c._1)(c._2) == 'S')  'a' else lines(c._1)(c._2)
                if (nxt - cur <= 1 && !(dist isDefinedAt (tx, ty))) {
                    q.enqueue((tx, ty))
                    dist += ((tx, ty) -> (dist((c._1, c._2)) + 1))
                }
            }
        }
    }
    println(dist((ex, ey)))
	
}
