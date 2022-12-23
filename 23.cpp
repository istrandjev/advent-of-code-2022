#include <iostream>
#include <set>
#include <map>
#include <vector>
#include <string>

using namespace std;

typedef long long ll;
const int moves[8][2] = {{-1, -1}, {-1, 0}, {-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}};
const int directions[4] = {1, 5, 7, 3};

ll get_elves_area(const set<pair<int, int>>& elves) {
    ll minx, maxx, miny, maxy;
    miny = maxy = elves.begin()->first;
    minx = maxx = elves.begin()->second;
    for (auto elve:  elves) {
        minx = min(minx, (ll)elve.second);
        maxx = max(maxx, (ll)elve.second);
        miny = min(miny, (ll)elve.first);
        maxy = max(maxy, (ll)elve.first);
    }
    return (maxy - miny + 1) * (maxx - minx + 1);
}
int main() {
    vector<string> a;
    string s;
    while (getline(cin, s)) {
        a.push_back(s);
    }
    int n = (int)a.size();
    int m = (int)a[0].size();
    set<pair<int, int> > elves;
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            if (a[i][j] == '#') {
                elves.insert({i, j});
            }
        }
    }

    bool any_moved = true;
    int move_number;
    for (move_number = 0; any_moved; ++move_number) {
        any_moved = false;
        map<pair<int, int>, pair<int, int> > proposed;
        set<pair<int, int> > proposals;
        set<pair<int, int> > repeated;
        
        for (auto elve: elves) {
            bool has_neighbour = false;
            for (int l = 0; l < 8; ++l) {
                int ty = elve.first + moves[l][0];
                int tx = elve.second + moves[l][1];
                if (elves.count({ty, tx})) {
                    has_neighbour = true;
                    break;
                }
            }
            if (!has_neighbour) {
                proposed.insert({elve, elve});
                proposals.insert(elve);
                continue;
            }
            bool has_proposed = false;
            for (int l = 0; l < 4; ++l) {
                int to_check = directions[(l + move_number) % 4];

                bool has = false;
                for (int delta = -1; delta <= 1; ++delta) {
                    int ty = elve.first + moves[(to_check + delta)%8][0];
                    int tx = elve.second + moves[(to_check + delta)%8][1];
                    if (elves.count({ty, tx})) {
                        has = true;
                    }
                }
                if (!has) {
                    pair<int, int> new_position(elve.first + moves[to_check][0], elve.second + moves[to_check][1]);
                    proposed.insert({elve, new_position});
                    if (proposals.count(new_position)) {
                        repeated.insert(new_position);
                    } else {
                        proposals.insert(new_position);
                    }
                    has_proposed = true;
                    break;
                }
            }
            if (!has_proposed) {
                proposed.insert({elve, elve});
                proposals.insert(elve);
            }
        }

        elves.clear();
        for (auto proposal: proposed) {
            if (repeated.count(proposal.second)) {
                elves.insert(proposal.first);
            } else {
                if (proposal.second != proposal.first) {
                    any_moved = true;
                }
                elves.insert(proposal.second);
            }
        }
        if (move_number == 9) {
            cout << "Part 1: " << get_elves_area(elves) - (ll)elves.size() << endl;
        }
    }

    cout << "Part 2: " << move_number << endl;
    return 0;
}