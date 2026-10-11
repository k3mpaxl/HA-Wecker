#!/usr/bin/env python3

import argparse
import sys
import time

import serial


def main() -> int:
    parser = argparse.ArgumentParser(description="Reset an ESP32 and capture its early serial boot log.")
    parser.add_argument("port")
    parser.add_argument("--seconds", type=float, default=20.0)
    args = parser.parse_args()

    with serial.Serial(args.port, 115200, timeout=0.2) as device:
        # Keep GPIO0 released and pulse EN through the CH340 control lines.
        device.dtr = False
        device.rts = True
        time.sleep(0.15)
        device.rts = False
        time.sleep(0.15)

        deadline = time.monotonic() + args.seconds
        while time.monotonic() < deadline:
            data = device.read(device.in_waiting or 1)
            if data:
                sys.stdout.buffer.write(data)
                sys.stdout.buffer.flush()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
