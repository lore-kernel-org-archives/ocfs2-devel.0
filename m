From: Robert Smith <spamfree@wansecurity.com>
Date: Wed, 30 Dec 2009 23:30:43 +0900
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JDB2,
	huge partition support,
	Volume might try to write to blocks beyond what jbd can address in 32
	bits)
Message-ID: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Is there a distribution available or at least what real version number of the tools, and the FS driver to I really need to make this work?

I have a 40TB partition that I want to format an cluster as a single OCFS2 cluster partition. After about 20 hours of reading and messing around with different solutions, and patches, everything seems to fall back to the following error:

[ 1358.014040] (11731,7):ocfs2_initialize_super:2157 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
[ 1358.014073] (11731,7):ocfs2_fill_super:1006 ERROR: status = -22
[ 1358.014096] ocfs2: Unmounting device (252,2) on (node 0)

root at s2-replay01:~# time mkfs.ocfs2 -N 2 -J block64 -F -v -b 4096 -T mail -M cluster --fs-feature-level=max-features /dev/replays/replay-data 
mkfs.ocfs2 1.4.2
Cluster stack: classic o2cb
Filesystem Type of mail
Filesystem label=
Block size=4096 (bits=12)
Cluster size=16384 (bits=14)
Volume size=39999990923264 (2441405696 clusters) (9765622784 blocks)
75689 cluster groups (tail covers 13568 clusters, rest cover 32256 clusters)
Journal size=268435456
Initial number of node slots: 2
Creating bitmaps: done
Initializing superblock: done
Writing system files: done
Writing superblock: done
Writing backup superblock: 6 block(s)
Formatting Journals: done
Formatting slot map: done
Writing lost+found: done
mkfs.ocfs2 successful


real    24m25.153s
user    0m7.500s
sys     0m5.110s
root at s2-replay01:~# mount.ocfs2 -o inode64 /dev/replays/replay-data /data/storage/
mount.ocfs2: Invalid argument while mounting /dev/replays/replay-data on /data/storage/. Check 'dmesg' for more information on this error.
root at s2-replay01:~#


root at s2-replay01:~# dmesg | tail
...
...
[ 1358.014040] (11731,7):ocfs2_initialize_super:2157 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
[ 1358.014073] (11731,7):ocfs2_fill_super:1006 ERROR: status = -22
[ 1358.014096] ocfs2: Unmounting device (252,2) on (node 0)
[ 9554.762902] (14685,7):ocfs2_initialize_super:2157 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
[ 9554.762964] (14685,7):ocfs2_fill_super:1006 ERROR: status = -22
[ 9554.763001] ocfs2: Unmounting device (252,2) on (node 0)
root at s2-replay01:~#


I've tried compiling the new tools, and FS driver, but it looks like the most recent version is using some old constructs or API and won't compile against the most recent kernel versions without a patch.

I've considered scrapping this, and using XFS, and Gluster. However, I like the prestige of using an Oracle based solution. Can anyone tell me if there is a combination of Tools and FS driver that can support a 40TB partition at this time?

-Robert

-- 
Robert Smith, CISSP
Chief Technology Officer
rtsmith at wansecurity.com

WANSecurity, Inc.
https://www.wansecurity.com

My PGP public key is available from:
https://www.wansecurity.com/keys/robert_smith.asc

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20091230/20845c6c/attachment.html 
