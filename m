From: Joseph Qi <joseph.qi@huawei.com>
Date: Sat, 25 Jul 2015 18:08:41 +0800
Subject: [Ocfs2-devel] extent alloc gd abnormally cleared
Message-ID: <55B36029.5010900@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi All,
We have encountered a case that extent alloc gd has been abnormally
cleared.
In our environment, the volume has been formatted with 128 slots but
actually has 64 slots in use. Since extent alloc is allocated when
formatting, and extent_alloc:0107 (inode 259) hasn't been use in our
environment, I have no idea how it can happen.
Does any one have an idea?

The fsck log is attached below:
fsck.ocfs2 1.6.4
Checking OCFS2 filesystem in /dev/disk/by-id/scsi-360022a11000b17590551993300000001:
  Label:              <NONE>
  UUID:               908A3228F49B41468FFC4927FAE1E54F
  Number of blocks:   2415918080
  Block size:         4096
  Number of clusters: 301989760
  Cluster size:       32768
  Number of slots:    128

/dev/disk/by-id/scsi-360022a11000b17590551993300000001 was run with -f, check forced.
Pass 0a: Checking cluster allocation chains
Pass 0b: Checking inode allocation chains
Pass 0c: Checking extent block allocation chains
[CHAIN_LINK_MAGIC] Chain 24 in allocator at inode 259 contains a reference at depth 0 to block 6578184 which doesn't have a valid checksum.  Truncate this chain? y
[CHAIN_BITS] Chain 24 in allocator inode 259 has 1023 bits marked free out of 1024 total bits but the block groups in the chain have 0 free out of 0 total.  Fix this by updating the chain record? y
[CHAIN_EMPTY] Chain 24 in allocator inode 259 is empty.  Remove it from the chain record array in the inode and shift further chains into its place? y
[GROUP_CHAIN] Group descriptor at block 6603784 was found in chain 24 but it claims to be in chain 49. Update the descriptor's recorded chain? y
Duplicate clusters detected.  Pass 1b will be run
Pass 1: Checking inodes and blocks.
......
Running additional passes to resolve clusters claimed by more than one inode...
Pass 1b: Determining ownership of multiply-claimed clusters
pass1b: Inode type does not contain extents while processing inode 17
