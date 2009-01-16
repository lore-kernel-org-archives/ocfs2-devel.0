From: tristan.ye <tristan.ye@oracle.com>
Date: Fri, 16 Jan 2009 16:05:28 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Inode Allocation
	Strategy	Improvement.v2
In-Reply-To: <1232056719-27716-1-git-send-email-tao.ma@oracle.com>
References: <1232056719-27716-1-git-send-email-tao.ma@oracle.com>
Message-ID: <1232093128.6601.12.camel@tristan-laptop.cn.oracle.com>
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

Tao,

I'm wondering why the 1st 'ls -lR' did not show us such a huge
enhancement, are the system load(by uptime) simliar when doing your 2rd
'ls -lR' contrast tests? if so, that's a really significant
gain!!!!:-),great congs!

To get more persuasive testing results, i suggest you do the same tests
by considerable times,and then a average statistic results should be
more attractive to us:-), and it also minimize the influence of some
exceptional system loads:-)

Tristan


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
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
