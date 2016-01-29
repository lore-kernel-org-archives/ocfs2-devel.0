From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 28 Jan 2016 21:34:24 -0800
Subject: [Ocfs2-devel] ocfs2 quota/reflink bug?
Message-ID: <20160129053423.GA5854@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi there,

This might sound a little funny coming from me, but I think I found a quota bug
in ocfs2.  The user quota isn't charged when creating a reflink copy, but
chowning the file credits the old owner and charges the new owner, resulting in
an integer underflow in block usage accounting.  ocfs2-tools is 1.6.4 and the
kernel is 4.5-rc1.

Comments during the terminal transcript will be in [brackets].

# mkfs.ocfs2 --fs-features=local,refcount,usrquota /dev/sda
mkfs.ocfs2 1.6.4
Label: 
Features: local sparse backup-super unwritten inline-data strict-journal-super xattr usrquota refcount
Block size: 4096 (12 bits)
Cluster size: 4096 (12 bits)
Volume size: 1667567616 (407121 clusters) (407121 blocks)
Cluster groups: 13 (tail covers 20049 clusters, rest cover 32256 clusters)
Extent allocator size: 4194304 (1 groups)
Journal size: 67108864
Node slots: 1
Creating bitmaps: done
Initializing superblock: done
Writing system files: done
Writing superblock: done
Writing backup superblock: 1 block(s)
Formatting Journals: done
Growing extent allocator: done
Formatting slot map: done
Formatting quota files: done
Writing lost+found: done
mkfs.ocfs2 successful

# mount /dev/sda /mnt -o usrquota
# dd if=/dev/zero of=/mnt/a bs=65536k count=1
1+0 records in
1+0 records out
67108864 bytes (67 MB) copied, 0.751677 s, 89.3 MB/s
# repquota /mnt
*** Report for user quotas on device /dev/sda
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --   65536       0       0              2     0     0       
# reflink -p /mnt/a /mnt/b
# repquota /mnt
*** Report for user quotas on device /dev/sda
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --   65536       0       0              3     0     0       

[Hey, look!  Reflinks are free!]

# chown nobody /mnt/a
# repquota /mnt
*** Report for user quotas on device /dev/sda
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --       0       0       0              2     0     0       
nobody    --   65536       0       0              1     0     0       

[Hey, I still own /mnt/b!  Free quota for me!]

# chown nobody /mnt/b
# repquota /mnt
*** Report for user quotas on device /dev/sda
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      -- 18446744073709486080       0       0              1     0     0       
nobody    --  131072       0       0              2     0     0       

[Oh no.]

[Hmm, will fsck repair this?]

# fsck.ocfs2 /dev/sda
fsck.ocfs2 1.6.4
Checking OCFS2 filesystem in /dev/sda:
  Label:              <NONE>
  UUID:               B35A5046EB1B4ACEBE522473EA73FB0F
  Number of blocks:   407121
  Block size:         4096
  Number of clusters: 407121
  Cluster size:       4096
  Number of slots:    1

/dev/sda is clean.  It will be checked after 20 additional mounts.

[Uh.....]

# mount /dev/sda
# repquota /mnt
*** Report for user quotas on device /dev/sda
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      -- 18446744073709486080       0       0              1     0     0       

[D'oh]

The simple solution is to charge quota blocks for reflinks, though it is a
little galling to charge users for a supposedly zero-space "copy".  I suppose
if the FS keeps track of who got charged for a given (possibly shared) block,
one could determine the amount that gets credited during a chown or charged
during a CoW, etc.  Sadly I'm not familiar enough with ocfs2 to know which it
is or how to change the code. :(

--D
