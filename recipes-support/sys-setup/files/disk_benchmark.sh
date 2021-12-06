#!/bin/bash

# disk_benchmark.sh
# Perform disk throughput tests
#
# 15.09.2021
# Daniel Selvan, Jasmin Infotech

# Hopefully have a version check (for 3 and above)
# echo "Bash version ${BASH_VERSION}" # For testing

length=10
# chunk_size=8192 # 8kB
chunk_size=512

# count is calculated as the no. of cycles required to achieve 100MB data in piece of chunk size
count=$((104857600 / $chunk_size))

enc_blk="/dmblk"
test_file="test.dat"

[ -d "$enc_blk" ] || {
    echo "ERROR: $enc_blk does not exist!"

    exit 1
}

device=$(uname -n)
boot_med=sd
dt=$(date '+%Y%m%d%H%M%S')

# rm -f dm_perf_"$device"_$boot_med*.md # For testing
# cryptsetup status crypt_target

file_name=dm_perf_"$device"_"$boot_med"_$dt.md

echo "# This file is automatically created by ${0#"./"}" >$file_name
echo "" >>$file_name
echo "## Do not modify if you're not sure!" >>$file_name
echo "" >>$file_name
echo "Test run on $device at $(date '+%H:%M:%S %d-%m-%Y')" >>$file_name

echo "" >>$file_name
echo "- Boot medium - $boot_med" >>$file_name

echo "Block size : $chunk_size bytes"
[ $chunk_size -gt 1024 ] && {
    echo "- Block size - $(($chunk_size / 1024))kB" >>$file_name
} || {
    echo "- Block size - $chunk_size Bytes" >>$file_name
}

echo "" >>$file_name
echo "| S.No | Write  | Read |" >>$file_name
echo "| ---- | ------ | ---- |" >>$file_name

for ((i = 1; i <= $length; i++)); do
    # echo "looping $i time..." # for testing
    rm -f $enc_blk/$test_file 2>/dev/null

    # Write sequence
    # Clearing cache
    sync
    echo 3 >/proc/sys/vm/drop_caches

    status=$(dd if=/dev/zero of=$enc_blk/$test_file bs=$chunk_size count=$count conv=fsync 2>&1)
    sync

    write_speed=$(echo "${status##*$'\n'}" | cut -d' ' -f 10-)
    # echo "write speed: $write_speed" # for testing

    # Read sequence
    echo 3 >/proc/sys/vm/drop_caches

    status=$(dd if=$enc_blk/$test_file of=/dev/null bs=$chunk_size count=$count 2>&1)
    sync

    read_speed=$(echo "${status##*$'\n'}" | cut -d' ' -f 10-)
    # echo "read speed: $read_speed" # for testing
    rm -f $enc_blk/$test_file 2>/dev/null

    # Writing to file
    echo "| $i | $write_speed | $read_speed |" >>$file_name
done

echo "" >>$file_name
echo "---" >>$file_name
echo "" >>$file_name
echo "Written by Daniel Selvan, Jasmin Infotech" >>$file_name

echo "Test completed. Report available on $file_name"

exit 0
