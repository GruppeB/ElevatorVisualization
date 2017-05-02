#!/usr/bin/python3

import argparse
import sys

def line_to_numbers(line):
    numbers = [int(float(x)) for x in line.split()]
    # for i, number in enumerate(numbers):
    #     if number.is_integer():
    #         numbers[i] = int(number)

    return numbers

def numbers_diff(p, n, elevators):
    return n[0:1+elevators] + [j - i for i, j in zip(p[1+elevators:], n[1+elevators:])]

def scale_positions(numbers, scale, elevators, floors):
    for i in range(1, elevators+1):
        numbers[i] = int((floors - numbers[i] - 1) * scale)

def print_numbers(numbers, prev_numbers, elevators):
    array = list(map(str, numbers_diff(prev_numbers, numbers, elevators)))
    array = array[:1+elevators] + array[1+2*elevators:] + array[1+elevators:1+2*elevators]
    print(' '.join(array))

def run(args):
    E, F = [int(x) for x in sys.stdin.readline().split()]
    print(E, F)

    prev_numbers = line_to_numbers(sys.stdin.readline())
    for line in sys.stdin:
        numbers = line_to_numbers(line)
        scale_positions(numbers, args.position_scale, E, F)
        print_numbers(numbers, prev_numbers, E)
        prev_numbers = numbers


def main():
    parser = argparse.ArgumentParser(
        description = 'Preprocesses simulation dump file format',
        usage = 'Read simulation dump file from stanard in and write to standard out'
    )

    parser.add_argument(
        'position_scale',
        help = 'By how much to scale the elevators position',
        type = float
    )

    run(parser.parse_args())



if __name__ == "__main__":
    main()
