From: bob findlay (TOC) <bob.findlay@bbsrc.ac.uk>
Date: Fri Jan 11 05:50:47 2008
Subject: [Ocfs2-devel] systems hang when accessing parts of the OCFS2
	filesystem
In-Reply-To: <D2AD15EF58CEB8448EA3626C1A102209014260EB@NBIE2KSRV1.nbi.bbsrc.ac.uk>
References: <D2AD15EF58CEB8448EA3626C1A102209014260EB@NBIE2KSRV1.nbi.bbsrc.ac.uk>
Message-ID: <D2AD15EF58CEB8448EA3626C1A1022090142611E@NBIE2KSRV1.nbi.bbsrc.ac.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sorry, should have also stated the obviously necessary information -

[root@jic55124 bin]# cat /proc/fs/ocfs2/version
OCFS2 1.2.7 Tue Oct  9 16:15:59 PDT 2007 (build
d443ce77532cea8d1e167ab2de51b8c8)

[root@jic55124 bin]# rpm -qf /boot/vmlinuz-`uname -r` --queryformat
"%{ARCH}\n"
x86_64

[root@jic55124 bin]# uname -a
Linux jic55124 2.6.9-42.ELsmp #1 SMP Wed Jul 12 23:32:02 EDT 2006 x86_64
x86_64 x86_64 GNU/Linux


Thanks
 
Bob.
 
=====================================================
Bob Findlay
The Operations Centre - Norwich BioScience Institutes
Tel: 01603 450474  (2474 internal)
Fax: 01603 450045
=====================================================


-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com
[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of bob findlay
(TOC)
Sent: 11 January 2008 11:17
To: ocfs2-devel@oss.oracle.com; ocfs2-users@oss.oracle.com
Subject: [Ocfs2-devel] systems hang when accessing parts of the OCFS2
filesystem

Hi everyone
 
Firstly, apologies for the cross post, I am not sure which list is most
appropriate for this question.  I should also point out, that I did not
install OCFS2 and I am not the person that normally looks after these
kind of things, so please can you bear that in mind when you make any
suggestions (I will need a lot of detail!)
 
The problem: accessing certain directories within the cluster file
system e.g. with "ls" cause the process to hang permanently.  I cannot
cancel the request, I have to terminate the session.  This is happening
across multiple nodes, so I am assuming that OCFS2 is the root cause of
the problem.
 
Accessing the directory in debug mode seems to work fine eg this command
will hang my session
 
[root@jic55124 databases]# ls -l /common/users/cbu/vigourom

Whereas this works fine
 
[root@jic55124 databases]# echo "ls -l /users/cbu/vigourom" |
debugfs.ocfs2 -n /dev/sdf1
        25447960        drwxr-xr-x  33  2522  2004            4096
10-Jan-2008 16:30 .
        25447672        drwxr-xr-x   5  3773  2004            4096
30-Nov-2007 14:27 ..
        25447961        drwx------   2  2522  2004            4096
1-Aug-2007 12:06 .ssh
        25447963        -rw-r--r--   1  2522  2004            3814
1-Aug-2007 17:04 addgi_new3.pl
        25447964        -rw-r--r--   1     0     0               0
1-Aug-2007 17:05 allmaize.out
        25447965        -rw-------   1  2522  2004            1741
15-Aug-2007 11:13 .viminfo
        25447966        drwxr-xr-x   3  2522  2004            4096
4-Sep-2007 12:07 .mcop
        25447970        drwxr-xr-x   2  2522  2004            4096
4-Sep-2007 15:43 forUNIGENE
        25447971        -rw-r--r--   1     0     0          325655
1-Aug-2007 15:02 maize.out
        25447972        -rw-r--r--   1     0     0             264
1-Aug-2007 15:42 README
        25447973        -rwxr--r--   1  2522  2004         7209696
8-Aug-2007 14:53 bioperl-1.5.2_102.zip
        25447974        drwxrwsr-x   9  2522  2004            4096
13-Aug-2007 14:59 bioperl-1.5.2_102
        22610705        drwxr-xr-x   2  2522  2004            4096
14-Aug-2007 17:10 perl5lib
        22610706        drwxr-xr-x   3  2522  2004            4096
14-Aug-2007 17:11 .cpan
        22610709        drwx------   4  2522  2004            4096
4-Sep-2007 11:39 .gnome
        22610713        drwx------   4  2522  2004            4096
4-Sep-2007 14:58 .gnome2
        22610719        drwx------   2  2522  2004            4096
4-Sep-2007 11:39 .gnome2_private
        22610720        drwx------   4  2522  2004            4096
4-Sep-2007 11:40 .kde
        229702011       -rw-------   1  2522  2004             771
10-Jan-2008 09:40 .Xauthority
        22610820        drwx------   4  2522  2004            4096
9-Jan-2008 14:08 .gconf
        22610835        drwx------   2  2522  2004            4096
10-Jan-2008 13:41 .gconfd
        22610837        drwxr-xr-x   3  2522  2004            4096
4-Sep-2007 11:39 .nautilus
        22610842        drwxr-xr-x   4  2522  2004            4096
4-Sep-2007 15:27 Desktop
        28545914        drwxr-xr-x   2  2522  2004            4096
4-Sep-2007 11:40 .qt
        28545917        drwxr-xr-x   2  2522  2004            4096
4-Sep-2007 11:42 .fonts
        28545922        drwx------   3  2522  2004            4096
4-Sep-2007 12:13 .mozilla
        4567882         -rw-r--r--   1  2522  2004              53
9-Jan-2008 14:08 .fonts.cache-1
        28545956        -rw-------   1  2522  2004               0
6-Sep-2007 15:30 .ICEauthority
        28545957        -rw-r--r--   1  2522  2004             110
4-Sep-2007 11:42 .fonts.conf
        28545958        -rw-------   1  2522  2004              31
4-Sep-2007 12:07 .mcoprc
        28545959        drwxr-xr-x   2  2522  2004            4096
4-Sep-2007 12:17 .wp
        28545962        drwxr-xr-x   2  2522  2004            4096
4-Sep-2007 15:04 .seqlab-node7
        28545967        -rw-r--r--   1  2522  2004             707
4-Sep-2007 16:16 .seqlab-history
        28545968        drwxr-xr-x   5  2522  2004            4096
4-Sep-2007 15:05 GCGSeqmergeTests
etc
 
stat gives 
 
[root@jic55124 databases]# echo "stat /users/cbu/vigourom" |
debugfs.ocfs2 -n /dev/sdf1     
        Inode: 25447960   Mode: 0755   Generation: 1766836575
(0x694fc95f)
        FS Generation: 3856768928 (0xe5e19fa0)
        Type: Directory   Attr: 0x0   Flags: Valid 
        User: 2522 (vigourom)   Group: 2004 (cbu)   Size: 4096
        Links: 33   Clusters: 1
        ctime: 0x4786481b -- Thu Jan 10 16:30:19 2008
        atime: 0x46a9a7dc -- Fri Jul 27 09:07:56 2007
        mtime: 0x4786481b -- Thu Jan 10 16:30:19 2008
        dtime: 0x0 -- Thu Jan  1 01:00:00 1970
        ctime_nsec: 0x33de5143 -- 870207811
        atime_nsec: 0x0ba52bb0 -- 195374000
        mtime_nsec: 0x33de5143 -- 870207811
        Last Extblk: 0
        Sub Alloc Slot: 4   Sub Alloc Bit: 544
        Tree Depth: 0   Count: 243   Next Free Rec: 1
        ## Offset        Clusters       Block#
        0  0             1              20289216
 
fsck.ocfs2 gives internal logic failures (or faliures ;) amongst other
things, which sounds pretty bad.  Is it?
 
[root@jic55124 ~]# fsck.ocfs2 -fn /dev/sdf1
Checking OCFS2 filesystem in /dev/sdf1:
  label:              oracle
  uuid:               e4 18 cb 00 24 2f 4d f2 96 b4 6f 3b 0a e9 b2 e8 
  number of blocks:   243930952
  bytes per block:    4096
  number of clusters: 30491369
  bytes per cluster:  32768
  max slots:          24
 
** Skipping journal replay because -n was given.  There may be spurious
errors that journal replay would fix. **
/dev/sdf1 was run with -f, check forced.
Pass 0a: Checking cluster allocation chains
[GROUP_FREE_BITS] Group descriptor at block 177020928 claims to have 2
free bits which is more than 0 bits indicated by the bitmap.n
Pass 0b: Checking inode allocation chains
Pass 0c: Checking extent block allocation chains
Pass 1: Checking inodes and blocks.
o2fsck_mark_cluster_allocated: Internal logic faliure !! duplicate
cluster 22151173
[DIR_ZERO] Inode 149371341 is a zero length directory, clear it? n
[CLUSTER_ALLOC_BIT] Cluster 11553628 is marked in the global cluster
bitmap but it isn't in use.  Clear its bit in the bitmap? n
[CLUSTER_ALLOC_BIT] Cluster 16917926 is marked in the global cluster
bitmap but it isn't in use.  Clear its bit in the bitmap? n
Pass 2: Checking directory entries.
[DIRENT_INODE_FREE] Directory entry '#74502784' refers to inode number
74502784 which isn't allocated, clear the entry? n
Pass 3: Checking directory connectivity.
[DIR_NOT_CONNECTED] Directory inode 149371341 isn't connected to the
filesystem.  Move it to lost+found? n
Pass 4a: checking for orphaned inodes
** Skipping orphan dir replay because -n was given.
Pass 4b: Checking inodes link counts.
[INODE_COUNT] Inode 74502784 has a link count of 0 on disk but directory
entry references come to 1. Update the count on disk to man
[INODE_COUNT] Inode 142698567 has a link count of 1 on disk but
directory entry references come to 2. Update the count on disk to mn
pass4: Internal logic faliure fsck's thinks inode 149371307 has a link
count of 1 but on disk it is 0
[INODE_COUNT] Inode 149371307 has a link count of 1 on disk but
directory entry references come to 2. Update the count on disk to mn
[INODE_NOT_CONNECTED] Inode 149371307 isn't referenced by any directory
entries.  Move it to lost+found? n
[INODE_COUNT] Inode 149371341 has a link count of 2 on disk but
directory entry references come to 0. Update the count on disk to mn
All passes succeeded.
 
 
This has happened before and was "resolved" by shutting down the cluster
and performing a fsck.ocfs2, but that doesn't help us prevent it in the
future, so I would really like to resolve it properly.  
 
any suggestions as to how I can narrow down the cause of this problem
please?  (or how to fix it would be even better! ;-)
 
Thanks
 
Bob.
 
=====================================================
Bob Findlay
The Operations Centre - Norwich BioScience Institutes
Tel: 01603 450474  (2474 internal)
Fax: 01603 450045
=====================================================

 
