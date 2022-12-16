#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <map>

using namespace std;

struct Valve {
    int id;
    int flow;
    int flow_id;
};

vector<vector<int> > ne;
map<string, int> valve_to_int;
vector<Valve> valves;

int mem[3 + (1<<15)][60][31];

#define update(x, y, z) (mem[x][y][z] == -1? solve(x, y, z) : mem[x][y][z])

int solve(int mask, int valve, int minutes) {
    if (minutes <= 1) {
        return mem[mask][valve][minutes] = 0;
    }
    int res = 0;
    for (auto nxt : ne[valve]) {
        int temp = update(mask, nxt, minutes - 1);
        res = max(res, temp);
    }
    if (valves[valve].flow > 0 && !(mask&(1 << valves[valve].flow_id))) {
        int new_mask = (mask|(1 << valves[valve].flow_id));
        int temp = update(new_mask, valve, minutes - 1);
        temp += (minutes - 1) * valves[valve].flow;
        res = max(res, temp);
    }
    return mem[mask][valve][minutes] = res;
}

int get_valve_code(const string& s) {
    auto it = valve_to_int.find(s);
    if (it == valve_to_int.end()) {
        int id = valve_to_int.size();
        valve_to_int.insert({s, id});
        return id;
    }
    return it->second;
}

string replace(const string& s, const string& what, const string& with) {
    string res;
    for (unsigned i = 0; i < s.size(); ++i) {
        if (i + what.size() <= s.size() && s.substr(i, what.size()) == what) {
            i += (int)what.size() - 1;
            res += with;
        } else {
            res.push_back(s[i]);
        }
    }
    return res;
}
char buf[100], name[4];
int main() {
    string s;
    int flow_id = 0;
    while (getline(cin, s)) {
        s = replace(s, "tunnel ", "tunnels ");
        s = replace(s, "valve ", "valves ");
        int pos = s.find("valves");
        string t = s.substr(0, pos);

        Valve current;
        int read = sscanf(
            t.c_str(),
            "Valve %s has flow rate=%d; tunnels lead to valves",
            name, &current.flow);
        current.id = get_valve_code(name);
        if (current.flow > 0) {
            current.flow_id = flow_id++;
        }
        if (current.id >= valves.size()) {
            valves.resize(current.id + 1);
        }
        valves[current.id] = current;
        istringstream iss(s.substr(pos + 6));
        if (ne.size() <= current.id) {
            ne.resize(current.id + 1);
        }
        string temp;
        while (iss >> temp) {
            if (temp.back() == ',') {
                temp.pop_back();
            }
            ne[current.id].push_back(get_valve_code(temp));
        }

    }
    memset(mem, -1, sizeof(mem));
    int vaa = valve_to_int["AA"];

    cout << solve(0, vaa, 30) << endl;

    int res = 0;
    for (int mask = 0; mask < (1 << flow_id); ++mask) {
        int rem = ((1 << flow_id) - 1) ^ mask;
        int temp = solve(mask, vaa, 26) + solve(rem, vaa, 26);
        res = max(res, temp);
    }
    cout << res <<endl;
    return 0;
}