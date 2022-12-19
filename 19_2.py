from functools import lru_cache

import re
import sys

from typing import List, Tuple

robot_costs = []
maxes = []


def parse_cost(part: str):
    mapping = {'ore': 0, 'clay': 1, 'obsidian': 2}
    cost = [0] * 4
    for item in re.findall(r'\d+ \w+', part):
        val, name = item.split()
        cost[mapping[name]] = int(val)
    return cost


def get_needed(robot_cost: List[int], resources, miners, i):
    if robot_cost[i] <= resources[i]:
        return 0

    return (robot_cost[i] - resources[i] + miners[i] - 1) // miners[i]


@lru_cache(maxsize=20000000)
def solve(miners: Tuple[int, int, int, int], resources: Tuple[int, int, int], minutes: int):
    answer = miners[3] * minutes
    if minutes <= 0:
        return 0
    for next_robot in range(4):
        if next_robot != 3 and miners[next_robot] >= maxes[next_robot]:
            continue

        if next_robot != 3 and resources[next_robot] >= (maxes[next_robot] - miners[next_robot]) * minutes:
            continue

        if any(robot_costs[next_robot][i] > resources[i] and miners[i] == 0 for i in range(3)):
            continue
        needed = max(get_needed(robot_costs[next_robot], resources, miners, i) for i in range(3)) + 1
        if needed > minutes:
            continue

        new_miners = tuple(miners[i] + int(i == next_robot) for i in range(4))
        new_resources = tuple(
            min(
                resources[i] + miners[i] * needed - robot_costs[next_robot][i],
                (maxes[i] - new_miners[i] + 4) * (minutes - needed)
            )
            for i in range(3)
        )

        temp = miners[3] * needed + solve(new_miners, new_resources, minutes - needed)
        if temp > answer:
            answer = temp
    return answer


def process_blueprint(blueprint: str):
    global robot_costs
    parts = blueprint.split('.')
    robot_costs = [parse_cost(part) for part in parts[:4]]
    global maxes
    maxes = [max(robot_cost[i] for robot_cost in robot_costs) for i in range(4)]
    solve.cache_clear()

    return solve((1, 0, 0, 0), (0, 0, 0), 32)


if __name__ == '__main__':
    res1 = 1
    lines = list(sys.stdin)
    for index, line in enumerate(lines, start=1):
        res1 *= process_blueprint(line)
    print(res1)
