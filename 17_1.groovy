import System.*;

class Ideone {
	static def field = []
	
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
	static def getHeight() {
		for (int i = 0; i < 10000; ++i) {
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
		return 10000
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
    static void main(String[] args) {
		def scanner = new Scanner(System.in)
		def input = scanner.nextLine()
		for (int i = 0; i < 10000; ++i) {
			field.add([0, 0, 0, 0, 0, 0, 0])
		}
		def currentMove = 0
		for (int bi = 0; bi < 2022; ++bi) {
			def brick = getBrick(bi)
			def moved = true;
			def height = getHeight()
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
		}
		println(getHeight() + 1)
    }
}

