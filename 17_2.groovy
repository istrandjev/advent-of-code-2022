import System.*;

class Ideone {
	static def field = []

	static def max(a, b) {
	    if (a > b) {
	        return a
	    }
	    return b
	}
	static def getBrick(i) {
		def bricks = [
    		["####"],
    		[
    			".#.",
    			"###",
    			".#."
    		],
    		[
    			"###",
    			"..#",
    			"..#"
    		],
    		[
    			"#",
    			"#",
    			"#",
    			"#"
    		], 
    		[
    			"##",
    			"##"
    		]
    	];
    	
		def res = []
		def idx = i % bricks.size();
		for (int ii = 0; ii < bricks[idx].size(); ++ii) {
			for (int j = 0; j < bricks[idx][ii].size(); ++j) {
				if (bricks[idx][ii].getAt(j) == '#') {
					res.add([ii, j])
				}
			}
		}
		return res
	}
	static def getHeight(ph) {
		for (int i = max(ph, 0); i < 82000; ++i) {
			def empty = true
			for (int j = 0; j < field[i].size(); ++j) {
				if (field[i][j] != 0) {
					empty = false
					break
				}
			}
			if (empty) {
				return i - 1
			}
		}
		return 82000
	}
	static def check(cx, cy, b) {
		for (int i = 0; i < b.size(); ++i) {
			def ty = cy + b[i][0]
			def tx = cx + b[i][1]

			if (ty < 0 || tx < 0 || tx >= 7 || field[ty][tx] != 0) {
				return false
			}
		}
		return true
	}

	static def is_all(x) {
		for (int i = 0; i < 7; ++i) {
			if (field[x][i] == 0) {
				return false
			}
		}
		return true
	}
    static void main(String[] args) {
		def scanner = new Scanner(System.in)
		def input = scanner.nextLine()
		for (int i = 0; i < 82000; ++i) {
			field.add([0, 0, 0, 0, 0, 0, 0])
		}
		def currentMove = 0
		def ph = 0
		def mem = [:]
		def hs = [:]
		for (int bi = 0; bi < 50091; ++bi) {
			def brick = getBrick(bi)
			def moved = true;
			def height = getHeight(ph - 1)
			ph = height
			def cy = height + 4
			def cx = 2
			while (moved) {
				def ty = cy
				def tx = cx
				if (input.getAt(currentMove) == '<') {
					tx -= 1
				} else {
					tx += 1
				}
				currentMove += 1
				currentMove %= input.size()
				if (check(tx, ty, brick)) {
					cx = tx
				}
				ty -= 1
				if (check(cx, ty, brick)) {
					cy = ty
				} else {
					moved = false
					break
				}
			}
			for (int i = 0; i < brick.size(); ++i) {
				def ty = cy + brick[i][0]
				def tx = cx + brick[i][1]
				field[ty][tx] = 1
			}
			height = getHeight(ph)
            hs[bi] = height
			if (is_all(height - 1)) {
			    def mask = 0
			    for (int j = 0; j < 7; ++j) {
			        if (field[height][j] != 0) {
			            mask += 1
			        }
			        mask *= 2
			    }
			    if (mem.containsKey([mask, currentMove, bi % 4])) {
			        long hgt = height
			        def previ = mem[[mask, currentMove, bi % 4]][1]
			        long prevh = mem[[mask, currentMove, bi % 4]][0]
			        def len = bi - previ;
			        def total = 1000000000000
			        long cnt = (total - previ) / len
                    println(cnt)
 			        long res = cnt * (hgt - prevh)
 			        long index_l = (total - previ) % len + previ
 			        int index = index_l
 			        res += (long)hs[index]
                    println(res)
			        break
			    }
			    mem[[mask, currentMove, bi % 4]] = [height, bi]

			}
		}
		println(getHeight(0) + 1)
    }
}
