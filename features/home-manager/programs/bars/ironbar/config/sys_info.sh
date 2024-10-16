#!/usr/bin/env bash

# Function to get CPU usage
get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}

# Function to get memory usage
get_memory_usage() {
  local usage=$(free | grep Mem | awk '{print $3*0.000001"GB"}')
  local percentage=$(free | grep Mem | awk '{print $3/$2 * 100}')
  local formatted=$(printf "%.2fGB(%.0f%%)" "$usage" "$percentage")
  echo $formatted
}

# Function to get disk usage
get_disk_usage() {
    df -h | grep '/dev/nvme0n1p3' | awk '{print $5}'
}

# Main monitoring function
monitor_system() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local cpu_usage=$(get_cpu_usage)
    local memory_usage=$(get_memory_usage)
    local disk_usage=$(get_disk_usage)
    local gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
    local gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    printf "CPU: %s\nRam: %s\nDisk: %s\nGPU: %s%%|%s°C\n" "$cpu_usage" "$memory_usage" "$disk_usage" "$gpu_usage" "$gpu_temp"
}

# Run the monitoring function
monitor_system

# Optional: Set up a cron job to run this script every 5 minutes
# */5 * * * * /path/to/this/script.sh
