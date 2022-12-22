using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class Test
{   
    public static int[,] moves = { { 0, 1 }, { 1, 0 }, { 0, -1 }, { -1, 0 } };
    public static int[,,] hardcoded_transitions = {
        {{1, 0}, {2, 1}, {3, 0}, {5, 0}},
        {{4, 2}, {2, 2}, {0, 2}, {5, 3}},
        {{1, 3}, {4, 1}, {3, 1}, {0, 3}},
        {{4, 0}, {5, 1}, {0, 0}, {2, 0}},
        {{1, 2}, {5, 2}, {3, 2}, {2, 3}},
        {{4, 3}, {1, 1}, {0, 1}, {3, 3}},
    };
    
    public static int[,] hardcoded_corners = {{0, 50}, {0, 100}, {50, 50}, {100, 0}, {100, 50}, {150, 0}};
    
    public static int[,] hardcoded_reverses = {{0, 2}, {1, 0}, {3, 2}, {4, 0}};
    public static int get_side(int y, int x) {
        for (int i = 0; i < 6; ++i) {
            if (y >= hardcoded_corners[i, 0] && y < hardcoded_corners[i, 0] + 50 &&
                    x >= hardcoded_corners[i, 1] && x < hardcoded_corners[i, 1] + 50) {
                return i;
            }
        }
        return -1;
    }
    public static int get_start(int dir) {
        if (dir == 0 || dir == 1) {
            return 0;
        } else {
            return 49;
        }
    }
    public static Tuple<int, int, int> step_into_the_void(int y, int x, int dir) {
        int side = get_side(y, x);
        int new_side = hardcoded_transitions[side, dir, 0];
        int new_dir = hardcoded_transitions[side, dir, 1];
        
        Tuple<int, int, int> res;
        int by = hardcoded_corners[new_side, 0];
        int bx = hardcoded_corners[new_side, 1];
        
        int other;
        if (dir % 2 == 1) {
            other = x - hardcoded_corners[side, 1];
        } else {
            other = y - hardcoded_corners[side, 0];
        }

        for (int i = 0; i < 4; ++i) {
            if (hardcoded_reverses[i, 0] == side && hardcoded_reverses[i, 1] == dir) {
                other = 49 - other;
            }
        }
        
        if (new_dir % 2 == 1) {
            res = new Tuple<int, int, int>(by + get_start(new_dir), bx + other, new_dir);
        } else {
            res = new Tuple<int, int, int>(by + other, bx + get_start(new_dir), new_dir);
        }
        return res;        
    }
	public static void Main()
	{
		List<string> field = new List<string>();

        string line;
        int m = 0;
        while ((line = Console.ReadLine()) != null)
        {
            field.Add(line);
            
        }

        int n = field.Count;
        string commands = field[n - 1];
        field.RemoveAt(n - 1);
        field.RemoveAt(n - 2);
        n -= 2;
        foreach (string l in field) {
            m = Math.Max(m, l.Length);
        }
        
        Tuple<int, int, int>[,,] next_cell = new Tuple<int, int, int>[n, m, 4];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < field[i].Length; ++j) {
                for (int l = 0; l < 4; ++l) {
                    if (field[i][j] == ' ') {
                        continue;
                    }
                    int ty = i + moves[l, 0];
                    int tx = j + moves[l, 1];
                    int new_dir;
                    if (tx >= 0 && ty >= 0 && ty < n && tx < field[ty].Length && field[ty][tx] != ' ') {
                        new_dir = l;   
                    } else {
                        Tuple<int, int, int> step = step_into_the_void(i, j, l);
                        ty = step.Item1;
                        tx = step.Item2;
                        new_dir = step.Item3;
                    }
                    
                    if (field[ty][tx] == '#') {
                        next_cell[i, j, l] = new Tuple<int, int, int>(i, j, l);
                    } else {
                        next_cell[i, j, l] = new Tuple<int, int, int>(ty, tx, new_dir);
                    }
                }
            }
        }
        Console.WriteLine("Here");

        Tuple<int, int, int> c = null;
        for (int i = 0; i < n && c == null; ++i) {
            for (int j = 0; j < field[i].Length; ++j) {
                if (field[i][j] == '.') {
                    c = new Tuple<int, int, int>(i, j, 0);
                    break;
                }
            }
        }
        MatchCollection matches = Regex.Matches(commands, @"\d+[RL]*");

		foreach (Match match in matches)
		{
			string number_str = match.Value;
			char d = '@';
			if (!char.IsDigit(match.Value[number_str.Length -  1])) {
				d = number_str[number_str.Length - 1];
				number_str = number_str.Substring(0, number_str.Length -  1);
			}
			int number = int.Parse(number_str);
			for (int i = 0; i < number; ++i) {
			    c = next_cell[c.Item1, c.Item2, c.Item3];
			}
			if (d == 'R') {
			    c = new Tuple<int, int, int>(c.Item1, c.Item2, (c.Item3 + 1) % 4);
			}
			if (d == 'L') {
			    c = new Tuple<int, int, int>(c.Item1, c.Item2, (c.Item3 + 3) % 4);
			}
		}
	    Console.WriteLine(c);
        int res = 1000 * (c.Item1 + 1) + 4 * (c.Item2 + 1) + c.Item3;
        Console.WriteLine(res);
	}
}

