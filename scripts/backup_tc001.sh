#!/usr/bin/env bash

set -euo pipefail

serial_port="${1:-/dev/cu.usbserial-10}"
backup_file="${2:-backups/tc001-backup-4m.bin}"
flash_size=$((0x400000))
chunk_size=$((0x40000))
max_attempts=5
parts_dir="${backup_file}.parts"

mkdir -p "${parts_dir}"

merge_args=()
for ((offset = 0; offset < flash_size; offset += chunk_size)); do
  printf -v offset_hex "0x%06x" "${offset}"
  printf -v part_name "%s/part-%06x.bin" "${parts_dir}" "${offset}"

  success=0
  if [[ -f "${part_name}" ]] &&
     [[ "$(stat -f%z "${part_name}")" -eq "${chunk_size}" ]]; then
    echo "Reusing complete chunk ${offset_hex}"
    success=1
  else
    for ((attempt = 1; attempt <= max_attempts; attempt++)); do
      echo "Reading ${offset_hex} (${attempt}/${max_attempts})"
      if python3 -m esptool \
        --port "${serial_port}" \
        --baud 115200 \
        read-flash \
        --flash-size 4MB \
        --no-progress \
        "${offset_hex}" "${chunk_size}" "${part_name}"; then
        actual_size="$(stat -f%z "${part_name}")"
        if [[ "${actual_size}" -eq "${chunk_size}" ]]; then
          success=1
          break
        fi
      fi
    done
  fi

  if [[ "${success}" -ne 1 ]]; then
    echo "Failed to read ${offset_hex} after ${max_attempts} attempts" >&2
    exit 1
  fi

  merge_args+=("${offset_hex}" "${part_name}")
done

python3 -m esptool --chip esp32 merge-bin \
  --output "${backup_file}" \
  --format raw \
  --pad-to-size 4MB \
  "${merge_args[@]}"

actual_size="$(stat -f%z "${backup_file}")"
if [[ "${actual_size}" -ne "${flash_size}" ]]; then
  echo "Unexpected backup size: ${actual_size}" >&2
  exit 1
fi

shasum -a 256 "${backup_file}"
