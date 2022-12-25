import std.stdio;
import std.conv;
import std.array;
import std.math;
void main(string[ ] args) {
    string s;
    int x = 1, res = 0, step = 0;
    string letters = "";
    int letter_index = 0;
    while ((s = readln()) !is null) {
        int steps = 1;
        int val = 0;
        if (s != "noop\n") {
            steps = 2;
            val = to!int(s.split[1]);
        }
        for (int i = 0; i < steps; ++i) {
            step += 1;
            if (step % 40 == 20) {
                res += x * step;
            }
            if (abs(letter_index - x) <= 1) {
                letters ~= "#";
            } else {
                letters ~= ".";
            }
            if (letter_index % 40 == 39) {
                letters ~= "\n";
            }
            letter_index = (letter_index + 1) % 40;
        }
        x += val;
    }
    writeln(res);
    writeln(letters);
}