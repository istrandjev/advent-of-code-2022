mapping mem = ([]);
mapping valves = ([]);
mapping ne = ([]);
mapping valve_to_index = ([]);

array(string) split(string s, string delim) {
    array(string) res = ({});
    int prev = 0;
    for (int i = 0; i + strlen(delim) <= strlen(s); ++i) {
        if (s[i..(i - 1 + strlen(delim))] == delim) {
            res += ({s[prev..(i - 1)]});
            prev = i + strlen(delim);
            i += strlen(delim) - 1;
        }
    }
    if (prev < strlen(s)) {
        res += ({s[prev..(strlen(s) - 1)]});
    }
    return res;
}


void parse_valve(string line) {
    line = Regexp.replace("valves", line, "valve");
    mixed parts = split(line, " valve ");

    string name;
    int flow;
    sscanf(parts[0], "Valve %s has flow rate=%d; tunnels lead to", name, flow);
    if (flow > 0) {
        int index = sizeof(valves);
        valves[name] = ({index, flow});
    }
    ne[name] = split(parts[1], ", ");
    valve_to_index[name] = sizeof(valve_to_index);
}

int encode(int mask, string valve, int minute) {
    return mask * 6000 + valve_to_index[valve] * 32 + minute;
}


int solve(int mask, string valve, int minute) {
    int code = encode(mask, valve, minute);
    // it seems there is no way to check for presence in pike
    int value = mem[code];
    if (value != 0) {
        return value - 1;
    }
    if (minute <= 1) {
        mem[code] = 1;
        return 0;
    }
    int res = 0;
    for (int i = 0; i < sizeof(ne[valve]); ++i) {
        int temp = solve(mask, ne[valve][i], minute - 1);
        if (temp > res) {
            res = temp;
        }
    }
    if (valves[valve] != 0) {
        int vi = valves[valve][0];
        int flow = valves[valve][1];
        if ((mask & (1 << vi)) == 0) {
            int temp = solve((mask | (1 << vi)), valve, minute - 1);
            temp += (minute - 1) * flow;
            if (temp > res) {
                res = temp;
            }
        }
    }
    mem[code] = res + 1;
    return res;
}

int main() {
	string line;
	array(string) b = ({});
	while (line = Stdio.stdin->gets())
	{
	    parse_valve(line);
	}
	int num_valves = sizeof(valves);
	int res = 0;
	for (int mask = 0; mask < (1 << num_valves); ++mask) {
	    int rem = ((1 << num_valves) - 1) ^ mask;
	    int temp = solve(mask, "AA", 26) + solve(rem, "AA", 26);
	    if (temp > res) {
	        res = temp;
	    }
	}
    write("%d\n", res);
}