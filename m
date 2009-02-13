From: tristan.ye <tristan.ye@oracle.com>
Date: Fri, 13 Feb 2009 10:42:08 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Inode Allocation
	Strategy	Improvement.v2
In-Reply-To: <1232056719-27716-1-git-send-email-tao.ma@oracle.com>
References: <1232056719-27716-1-git-send-email-tao.ma@oracle.com>
Message-ID: <1234492928.6700.118.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 2009-01-16 at 05:58 +0800, Tao Ma wrote:
> Changelog from V1 to V2:
> 1. Modify some codes according to Mark's advice.
> 2. Attach some test statistics in the commit log of patch 3 and in
> this e-mail also. See below.
> 
> Hi all,
> 	In ocfs2, when we create a fresh file system and create inodes in it, 
> they are contiguous and good for readdir+stat. While if we delete all 
> the inodes and created again, the new inodes will get spread out and 
> that isn't what we need. The core problem here is that the inode block 
> search looks for the "emptiest" inode group to allocate from. So if an 
> inode alloc file has many equally (or almost equally) empty groups, new 
> inodes will tend to get spread out amongst them, which in turn can put 
> them all over the disk. This is undesirable because directory operations 
> on conceptually "nearby" inodes force a large number of seeks. For more 
> details, please see 
> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/InodeAllocationStrategy. 
> 
> So this patch set try to fix this problem.
> patch 1: Optimize inode allocation by remembering last group.
> We add ip_last_used_group in core directory inodes which records
> the last used allocation group. Another field named ip_last_used_slot
> is also added in case inode stealing happens. When claiming new inode,
> we passed in directory's inode so that the allocation can use this
> information.
> 
> patch 2: let the Inode group allocs use the global bitmap directly.
> 
> patch 3: we add osb_last_alloc_group in ocfs2_super to record the last
> used allocation group so that we can make inode groups contiguous enough.
> 
> I have done some basic test and the results are cool.
> 1. single node test:
> first column is the result without inode allocation patches, and the
> second one with inode allocation patched enabled. You see we have
> great improvement with the second "ls -lR".
> 
> echo 'y'|mkfs.ocfs2 -b 4K -C 4K -M local /dev/sda11
> 
> mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
> time tar jxvf /home/taoma/linux-2.6.28.tar.bz2 -C /mnt/ocfs2/ 1>/dev/null
> 
> real	0m20.548s 0m20.106s
> 
> umount /mnt/ocfs2/
> echo 2 > /proc/sys/vm/drop_caches
> mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
> time ls -lR /mnt/ocfs2/ 1>/dev/null
> 
> real	0m13.965s 0m13.766s
> 
> umount /mnt/ocfs2/
> echo 2 > /proc/sys/vm/drop_caches
> mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
> time rm /mnt/ocfs2/linux-2.6.28/ -rf
> 
> real	0m13.198s 0m13.091s
> 
> umount /mnt/ocfs2/
> echo 2 > /proc/sys/vm/drop_caches
> mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
> time tar jxvf /home/taoma/linux-2.6.28.tar.bz2 -C /mnt/ocfs2/ 1>/dev/null
> 
> real	0m23.022s 0m21.360s
> 
> umount /mnt/ocfs2/
> echo 2 > /proc/sys/vm/drop_caches
> mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
> time ls -lR /mnt/ocfs2/ 1>/dev/null
> 
> real	2m45.189s 0m15.019s 
> yes, that is it. ;) I don't know we can improve so much when I start up.
> 
> 2. Tested with 4 nodes(megabyte switch for both cross-node
> communication and iscsi), with the same command sequence(using
> openmpi to run the command simultaneously). Although we spend
> a lot of time in cross-node communication, we still have some
> performance improvement.
> 
> the 1st tar:
> real	356.22s  357.70s
> 
> the 1st ls -lR:
> real	187.33s  187.32s
> 
> the rm:
> real	260.68s  262.42s
> 
> the 2nd tar:
> real	371.92s  358.47s
> 
> the 2nd ls:
> real	197.16s  188.36s
> 
> Regards,
> Tao


Tao, mark,

I've done a series of more strict tests with a much higher worload to
prove a performance gain from tao's patches. 

Following are the testing steps,

1st Tar: Untar files to a freshly mkfsed and empty fs by proper
iterations to fill the whole disk up(Here we use 100G volume)

1st Ls:  Try to traverse all inodes in the fs recursivly

1st Rm: remove all inodes in the fs


2nd Tar:Untar files again to the empty fs.

2nd Ls : the same as 1st Ls

2nd Rm: the same as 1st Rm

We use the same testing steps to do a comprison test between patched
kernels and original kernel.

From the above tests, we were expected to see a performance gain during
the 2nd Ls and 2nd RM since we know the patched kernel will provide a
better inode locality when creating by '2nd Tar' while the original
kernel go round robin with the inode allocator that makes a poor
locality.  And i'd like to say the result of real tests were awesome and
encourging...Following are the testing reports.

1. Single node test.

========Time Consumed Statistics(2 iterations)======
            [Patched kernel]   [Original kernel]
1st Tar:      1745.17s            1751.86s
1st Ls:        2128.81s            2262.13s
1st Rm:      1760.66s            1857.06s
2nd Tar:     1924.77s            1917.75s
2nd Ls:       2313.11s            8196.51s
2nd Rm:     1925.14s            2372.10s



2. Multiple nodes tests.

1). From node1:test5

========Time Consumed Statistics(2 iterations)======
            [Patched kernel]   [Original kernel]
1st Tar:      3528.36s            3422.23s
1st Ls:        3035.17s            6009.16s
1st Rm:      2436.65s            2307.37s
2nd Tar:     3131.00s            3521.21s
2nd Ls:       2949.31s            4002.07s
2nd Rm:     2425.09s            3365.42s

2) From node2:test12
========Time Consumed Statistics(2 iterations)======
            [Patched kernel]   [Original kernel]
1st Tar:      3470.28s            3876.46s
1st Ls:        2972.58s            6743.32s
1st Rm:      2413.23s            2572.18s
2nd Tar:     3848.56s            3521.21s
2nd Ls:       2887.13s            8259.07s
2nd Rm:     2478.70s            4152.42s


The data statistics from above tests were persuasive,this patches set
really behaved well during such perf comparison tests:),and it should be
the right time to get such patches committed.


Regards,
Tristan


> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
