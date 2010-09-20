From: jeff.liu <jeff.liu@oracle.com>
Date: Mon, 20 Sep 2010 14:53:58 +0800
Subject: [Ocfs2-devel] Shared-du: show the shared extents per file and the
	footprint v4
In-Reply-To: <4BB44D82.7000403@oracle.com>
References: <> <1267198108-7459-1-git-send-email-jeff.liu@oracle.com>
	<1267198108-7459-2-git-send-email-jeff.liu@oracle.com>
	<1267198108-7459-3-git-send-email-jeff.liu@oracle.com>
	<4BB44D82.7000403@oracle.com>
Message-ID: <4C970506.9030503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

The coming patches introduce fiemap support to du(1), the goal is to teach du(1) to figure up the
shared extents per file it goes through, as well as the footprint of the storage in the end.

Changes to v3:
. fix the issues according to Tao's comments.
. Try to merge to the left or right node if possible when inserting a new extent_info to rbtree.

I have done some tests in the past few days, it works fine, thanks Tao for help creating the test
envionment!


Also, I write a tiny script to verify the result with shared-du as below, it show the total shared
extents against the target storage in bytes.

usage:
./show_shared_extents.sh [storage_mount_path] [storage_device]
like: ./show_shared_extents.sh /storage /dev/sda8

#!/bin/bash

DEBUGGER="/sbin/debugfs.ocfs2 -n"

#
# Get the block size and cluster size, we make use of cluster size to calculate the
# shared extent physical offset and length in bytes.
#
ocfs2_block_cluster_size=($(echo "stats" | $DEBUGGER -n /dev/sda8 | grep "Block Size Bits" | awk '{
print $4" "$8 }'))
block_size=$[ 2 ** ${ocfs2_block_cluster_size[0]} ]
cluster_size=$[ 2 ** ${ocfs2_block_cluster_size[1]} ]

function process_file() {
	local __f=$1
        local device=$2
	local __start=0
	local __lines=0
	local start_line=0
	local end_line=0

	inode=$(stat --format="%i" ${__f})

        #
        # Check if we meet a refcount file
        #
	refcount_file=$(echo "stat <$inode>" | $DEBUGGER $device | sed '5!d' | grep "Refcounted")

	if (test -n "$refcount_file") then
                refcount_records=($(echo "refcount <$inode>"	|
				    $DEBUGGER $device		|
			    	    grep -n "Refcount records"	|
				    awk -F':' '{print $1 $4}'))

		refcount_records_num=${#refcount_records[@]}

		i=0
		while [[ $i -lt $refcount_records_num ]]
		do
			__start=${refcount_records[$i]}
			(( i++ ))
			__lines=$[ ${refcount_records[$i]} + 1 ]
			(( i++ ))
			let "start_line = __start + 1"
			let "end_line = start_line + __lines"

			extents=($(echo "refcount <$inode>" | $DEBUGGER $device |
				   awk "FNR > $start_line && FNR < $end_line"	|
				   awk '{ print $2" "$3" "$4 }' ))

			extents_num=${#extents[@]}

			for (( j = 0; j < $extents_num; ))
			do
				physical_offset=$[ ${extents[$j]} * $cluster_size ]

				(( j++ ))
				length=$[ ${extents[$j]} * $cluster_size ]
				(( j++ ))

                        	#
				# Decrease the reference count to meet the du semantics
				#
				count=$[${extents[$j]} - 1]
				(( j++ ))

				extent_array[$physical_offset]="$physical_offset:$length:$count"
			done
		done
	fi
}


STORAGE_MOUNT_PATH=$1
STORAGE_DEVICE=$2

for f in $(find $STORAGE_MOUNT_PATH -type f)
do
	process_file ${f} $STORAGE_DEVICE
done

items=${#extent_array[*]}

total_shared_length=0
for item in ${extent_array[@]}
do
	shared_length=$(echo "${item}" | awk -F: '{ print $2 * $3}')
	let "total_shared_length += shared_length"
done

echo "TOTAL_SHARED_LENGTH: $total_shared_length"



Regards,
-Jeff
