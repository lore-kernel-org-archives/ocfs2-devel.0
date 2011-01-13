From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 13 Jan 2011 18:20:12 +0800
Subject: [Ocfs2-devel]  [PATCH 0/8] Ocfs2: Online defragmentaion V2.
Message-ID: <1294914020-21628-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Changes since v1:

 *. implement following #2 strategy(simple extent_moving).

	It's a quite rough patches series v2 for online defrag/ext_moving on OCFS2, it's
workable anyway, may look ugly though;) The essence of online file defragmentation is
extents moving like what btrfs and ext4 were doing, adding 'OCFS2_IOC_MOVE_EXT' ioctl
to ocfs2 allows two strategies upon defragmentation:

1. simple-defragmentation-in-kernl, which means kernel will be responsible for
   claiming new clusters, and packing the defragmented extents according to a
   user-specified threshold.

2. simple-extents moving, in this case, userspace play much more important role
   when doing defragmentation, it needs to specify the new physical blk_offset
   where extents will be moved, kernel itself will not do anything more than
   moving the extents per requested, maybe kernel also needs to manage to
   probe/validate the new_blkoffset to guarantee enough free space around there.

Above two operations using the same OCFS2_IOC_MOVE_EXT:
-------------------------------------------------------------------------------
#define OCFS2_MOVE_EXT_FL_AUTO_DEFRAG   (0x00000001)    /* Kernel manages to
                                                           claim new clusters
                                                           as the goal place
                                                           for extents moving */
#define OCFS2_MOVE_EXT_FL_COMPLETE      (0x00000002)    /* Move or defragmenation
                                                           completely gets done.
                                                         */
struct ocfs2_move_extents {
/* All values are in bytes */
        /* in */
        __u64 me_start;         /* Virtual start in the file to move */
        __u64 me_len;           /* Length of the extents to be moved */
        __u64 me_goal;          /* Physical offset of the goal */
        __u64 me_thresh;        /* Maximum distance from goal or threshold
                                   for auto defragmentation */
        __u64 me_flags;         /* flags for the operation:
                                 * - auto defragmentation.
                                 * - refcount,xattr cases.
                                 */

        /* out */
        __u64 me_moved_len;     /* moved length, are we completely done? */
        __u64 me_new_offset;    /* Resulting physical location */
        __u32 me_reserved[2];   /* reserved for futhure */
};
-------------------------------------------------------------------------------

	Following are some interesting data gathered from simple tests:

1. Performance improvement gained on I/O reads:
-------------------------------------------------------------------------------
* Before defragmentation *

[root at ocfs2-box4 ~]# sync
[root at ocfs2-box4 ~]# echo 3>/proc/sys/vm/drop_caches 
[root at ocfs2-box4 ~]# time dd if=/storage/testfile-1 of=/dev/null
640000+0 records in
640000+0 records out
327680000 bytes (328 MB) copied, 19.9351 s, 16.4 MB/s

real	0m19.954s
user	0m0.246s
sys	0m1.111s

* Do defragmentation *

[root at ocfs2-box4 defrag]# ./defrag -s 0 -l 293601280  -t 3145728 /storage/testfile-1

* After defragmentation *

[root at ocfs2-box4 ~]# sync
[root at ocfs2-box4 ~]# echo 3>/proc/sys/vm/drop_caches
[root at ocfs2-box4 ~]# time dd if=/storage/testfile-1 of=/dev/null
640000+0 records in
640000+0 records out
327680000 bytes (328 MB) copied, 6.79885 s, 48.2 MB/s

real	0m6.969s
user	0m0.209s
sys	0m1.063s
-------------------------------------------------------------------------------


2. Extent tree layout via debugfs.ocfs2:
-------------------------------------------------------------------------------
* Before defragmentation *

        Tree Depth: 1   Count: 243   Next Free Rec: 8
        ## Offset        Clusters       Block#
        0  0             1173           86561
        1  1173          1173           84527
        2  2346          1151           81468
        3  3497          1173           76362
        4  4670          1173           74328
        5  5843          1172           66150
        6  7015          1460           70260
        7  8475          662            87680
        SubAlloc Bit: 1   SubAlloc Slot: 0
        Blknum: 86561   Next Leaf: 84527
        CRC32: abf06a6b   ECC: 44bc
        Tree Depth: 0   Count: 252   Next Free Rec: 252
        ## Offset        Clusters       Block#          Flags
        0  1             16             516104          0x0
        1  17            1              554632          0x0
        2  18            7              560144          0x0
        3  25            1              565960          0x0
        4  26            1              572632          0x
	...
	/* around 1700 extent records were hidden there */
	...
	138 9131          1              258968          0x0
        139 9132          1              259568          0x0
        140 9133          1              260168          0x0
        141 9134          1              260768          0x0
        142 9135          1              261368          0x0
        143 9136          1              261968          0x0

* After defragmentation *

      Tree Depth: 1   Count: 243   Next Free Rec: 1
	## Offset        Clusters       Block#
	0  0             9137           66081
	SubAlloc Bit: 1   SubAlloc Slot: 0
	Blknum: 66081   Next Leaf: 0
	CRC32: 22897d34   ECC: 0619
	Tree Depth: 0   Count: 252   Next Free Rec: 6
	## Offset        Clusters       Block#          Flags
	0  1             1600           4412936         0x0 
	1  1601          1595           20669448        0x0 
	2  3196          1600           9358856         0x0 
	3  4796          1404           14516232        0x0 
	4  6200          1600           21627400        0x0 
	5  7800          1337           7483400         0x0 
-------------------------------------------------------------------------------


TO-DO:

1. Adding refcount/xattr support.
2. Free space defragmentation.


Go to http://oss.oracle.com/osswiki/OCFS2/DesignDocs/OnlineDefrag for more details.


Tristan.
