From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Mon Aug  2 13:29:52 2004
Subject: [Ocfs2-devel] Calculating volume size from superblock
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B01812211@orsmsx410>
References: <60C14C611F1DDD4198D53F2F43D8CA3B01812211@orsmsx410>
Message-ID: <1091471231.12289.33.camel@smushran-pc1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

superblock has the clustersize and global bitmap has the number of bits.
clustersize ==> 17 bits ==> 128K
128K x 200059 bits = 24G

This size is the total size of the disk.

[root@ca-test6-RHAS21 sunil]# ./debugfs.ocfs2 /dev/sde2
debugocfs version 0.0.1
Bound /dev/sde2 to /dev/raw/raw3
debugfs: stats
        Revision: 0.90
        Mount Count: 0   Max Mount Count: 20
        State: 0   Errors: 0
        Check Interval: 0   Last Check: Tue Jul 20 09:22:50 2004
        Creator OS: 0
        Feature Compat: 0   Incompat: 0   RO Compat: 0
        Root Blknum: 3   System Dir Blknum: 4
        Block Size Bits: 12   Cluster Size Bits: 17	<=====
        Max Nodes: 3
        Label: oastdbf2
        UUID: F2F0828734DEFB36D0B9DEBC10840971
        Inode: 2   Mode: 00   Generation: 0
        Type: unknown   Flags: valid system superblock
        User: 0 (root)   Group: 0 (root)   Size: 0
        Links: 0   Clusters: 0
        Lock Master: 0   Level: 0x0   Seqnum: 0
        Lock Map: 000
        ctime: 0x40fd46da -- Tue Jul 20 09:22:50 2004
        atime: 0x0 -- Wed Dec 31 16:00:00 1969
        mtime: 0x40fd46da -- Tue Jul 20 09:22:50 2004
        dtime: 0x0 -- Wed Dec 31 16:00:00 1969
        Last Extblk: 0
        Sub Alloc Node: 4294967295   Sub Alloc Blknum: 2


debugfs: stat 9
        Inode: 9   Mode: 0775   Generation: 0
        Type: regular   Flags: valid system allocbitmap
        User: 1011 (oracle)   Group: 1011 (oracle)   Size: 131072
        Links: 1   Clusters: 1
        Lock Master: 0   Level: 0x5   Seqnum: 0
        Lock Map: 000
        ctime: 0x40fd46da -- Tue Jul 20 09:22:50 2004
        atime: 0x40fd46da -- Tue Jul 20 09:22:50 2004
        mtime: 0x40fd46da -- Tue Jul 20 09:22:50 2004
        dtime: 0x0 -- Wed Dec 31 16:00:00 1969
        Last Extblk: 0
        Sub Alloc Node: 4294967295   Sub Alloc Blknum: 9
===>    Bitmap Total: 200059   Used: 72197   Clear: 127862
        Tree Depth: 0   Count: 243   Next Free Rec: 1
        ## File Offset   Num Clusters   Disk Offset
        0  0             1              3744
debugfs: ls 4
        Inode           Rlen Nlen Ty Name
        224             16   1    2  .
        224             16   2    2  ..
        5               24   10   1  bad_blocks
        6               32   18   1  global_inode_alloc
        7               40   25   1  global_inode_alloc_bitmap
        8               16   3    1  dlm
        9               28   13   1  global_bitmap
        10              24   10   2  orphan_dir
        11              32   17   1  extent_alloc:0000
        12              32   17   1  extent_alloc:0001
        13              32   17   1  extent_alloc:0002
        14              36   24   1  extent_alloc_bitmap:0000
        15              36   24   1  extent_alloc_bitmap:0001
        16              36   24   1  extent_alloc_bitmap:0002
        17              28   16   1  inode_alloc:0000
        18              28   16   1  inode_alloc:0001
        19              28   16   1  inode_alloc:0002
        20              36   23   1  inode_alloc_bitmap:0000
        21              36   23   1  inode_alloc_bitmap:0001
        22              36   23   1  inode_alloc_bitmap:0002
        23              24   12   1  journal:0000
        24              24   12   1  journal:0001
        25              24   12   1  journal:0002
        26              28   16   1  local_alloc:0000
        27              28   16   1  local_alloc:0001
        28              3376 16   1  local_alloc:0002
debugfs:



On Mon, 2004-08-02 at 11:13, Villalovos, John L wrote:
> Another simple question.
> 
> How do I calculate the size of the volume from the superblock?
> 
> Do I just use the two fields:
> 
> u_int32_t s_blocksize_bits;         /* Blocksize for this fs */
> u_int32_t s_clustersize_bits;       /* Clustersize for this fs */
> 
> What is the formula to use?
> 
> Thanks,
> John
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
