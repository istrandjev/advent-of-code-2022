using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class Test
{   
    public static int[,] moves = { { 0, 1 }, { 1, 0 }, { 0, -1 }, { -1, 0 } };
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
        
        Tuple<int, int>[,,] next_cell = new Tuple<int, int>[n, m, 4];
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < field[i].Length; ++j) {
                for (int l = 0; l < 4; ++l) {
                    int tx = ((i + moves[l, 0]) % n + n) % n;
                    int ty = ((j + moves[l, 1]) % m + m) % m;
                    while (ty >= field[tx].Length || field[tx][ty] == ' ') {
                        tx = ((tx + moves[l, 0]) % n + n) % n;
                        ty = ((ty + moves[l, 1]) % m + m) % m;
                    }
                    if (field[tx][ty] == '#') {
                        next_cell[i, j, l] = new Tuple<int, int>(i, j);
                    } else {
                        next_cell[i, j, l] = new Tuple<int, int>(tx, ty);
                    }
                }
            }
        }

        int dir = 0;
        Tuple<int, int> c = null;
        for (int i = 0; i < n && c == null; ++i) {
            for (int j = 0; j < field[i].Length; ++j) {
                if (field[i][j] == '.') {
                    c = new Tuple<int, int>(i, j);
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
			    c = next_cell[c.Item1, c.Item2, dir];
			}
			if (d == 'R') {
			    dir = (dir + 1) % 4;
			}
			if (d == 'L') {
			    dir = (dir + 3) % 4;
			}
		}
	    Console.WriteLine(c);
        Console.WriteLine(dir);
        int res = 1000 * (c.Item1 + 1) + 4 * (c.Item2 + 1) + dir;
        Console.WriteLine(res);
	}
}

