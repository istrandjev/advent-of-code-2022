readline = require('readline');

function gcd(a, b) {
    if (a < b) {
        return gcd(b, a);
    }
    while (a % b != 0) {
        let r = a % b;
        a = b;
        b = r;
    }
    return b;
}

function lcm(a, b) {
    let d = gcd(a, b);
    return (a / d) * b;
}
const moves = [[0, 1], [1, 0], [0, -1], [-1, 0]];

function get_vertical(field, y, x, move) {
    const n = field.length - 2;
    y = y - 1;
    return field[((y + move) % n + n) % n + 1][x];
}

function get_horizontal(field, y, x, move) {
    const m = field[0].length - 2;
    x = x - 1;
    return field[y][((x + move) % m + m) % m + 1];
}


function check_cell(field, cell) {
    const [y, x, move] = cell;
    
    if (y == field.length - 1 || y == 0) {
        return true;
    }
    if (get_vertical(field, y, x, move) == '^') {
        return false;
    }
    if (get_vertical(field, y, x, -move) == 'v') {
        return false;
    }
    if (get_horizontal(field, y, x, move) == '<') {
        return false;
    }
    if (get_horizontal(field, y, x, -move) == '>') {
        return false;
    }
    return true;
}

function solve(field) {
    let cycle = lcm(field.length - 2, field[0].length - 2);
    const queue = [];
    queue.push([0, 1, 0]);
    const vis = {};
    vis[[0, 1, 0]] = 0;
    let best = -1;
    while (queue.length != 0 && best == -1) {
        const c = queue.shift();
        const c_dist = vis[c];
        const stay = [c[0], c[1], (c[2] + 1) % cycle];
        if (!vis.hasOwnProperty(stay) && check_cell(field, stay)) {
            vis[stay] = c_dist + 1;
            queue.push(stay);
        }
        
        moves.forEach(move_delta => {
            const ty = c[0] + move_delta[0];
            const tx = c[1] + move_delta[1];
            
            if (ty >= 0 && field[ty][tx] != '#') {
                const next = [ty, tx, (c[2] + 1) % cycle];
                if (!vis.hasOwnProperty(next) && check_cell(field, next)) {
                    vis[next] = c_dist + 1;
                    if (next[0] == field.length - 1 && best == -1) {
                        best = c_dist + 1;
                    }
                    queue.push(next);
                }
            }
        });
    }
    return best;
}

// Initialize an array to hold the lines of input
let lines = [];

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});
rl.on('line', line => {
  lines.push(line);
});
rl.on('close', () => {
  console.log(solve(lines));
});

