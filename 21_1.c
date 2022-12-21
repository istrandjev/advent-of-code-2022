#include <stdio.h>
#include <string.h>
#include <ctype.h>

typedef long long ll;
typedef ll (*T)(ll, ll);

struct Monkey {
    ll value;
    int lhs, rhs;
    T operation;
} monkeys[26*26*26*26 + 1];

ll add(ll a, ll b) {
    return a + b;
}

ll mul(ll a, ll b) {
    return a * b;
}

ll sub(ll a, ll b) {
    return a - b;
}

ll div(ll a, ll b) {
    return a / b;
}

int get_code(const char* monkey_name) {
    int res = 0;
    for (int i = 0; i < strlen(monkey_name); ++i) {
        res *= 26;
        res += monkey_name[i] - 'a';
    }
    return res;
}

ll solve(int code) {
    if (monkeys[code].lhs < 0) {
        return monkeys[code].value;
    }
    return monkeys[code].operation(solve(monkeys[code].lhs), solve(monkeys[code].rhs));
}
int main() {

    memset(monkeys, -1, sizeof(monkeys));

    char line_buf[42];
    char name[5], name1[5], name2[5];

    while (gets(line_buf)) {
        line_buf[4] = ' ';

        sscanf(line_buf, "%s", name);
        int code = get_code(name);
        if (isdigit(line_buf[6])) {
            int value;
            sscanf(line_buf + 4, "%d", &value);
            monkeys[code].value = value;
        } else {
            char operation;
            sscanf(line_buf + 4, " %s %c %s", name1, &operation, name2);
            int code1 = get_code(name1);
            int code2 = get_code(name2);
            monkeys[code].lhs = code1;
            monkeys[code].rhs = code2;
            switch(operation) {
                case '+': monkeys[code].operation = add;break;
                case '-': monkeys[code].operation = sub;break;
                case '*': monkeys[code].operation = mul;break;
                case '/': monkeys[code].operation = div;break;
                default: printf("Unknown operation %c\n", operation);
            }
        }
    }
    ll res = solve(get_code("root"));
    printf("%lld\n", res);
    return 0;
}