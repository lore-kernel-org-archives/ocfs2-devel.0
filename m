From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 28 Nov 2008 14:49:19 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Inode Allocation Strategy
	Improvement
Message-ID: <492F946F.1060409@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	In ocfs2, when we create a fresh file system and create inodes in it, 
they are contiguous and good for readdir+stat. While if we delete all 
the inodes and created again, the new inodes will get spread out and 
that isn't what we need. The core problem here is that the inode block 
search looks for the "emptiest" inode group to allocate from. So if an 
inode alloc file has many equally (or almost equally) empty groups, new 
inodes will tend to get spread out amongst them, which in turn can put 
them all over the disk. This is undesirable because directory operations 
on conceptually "nearby" inodes force a large number of seeks. For more 
details, please see 
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/InodeAllocationStrategy.(I 
have modified it a little, Mark, if you are interested, please look at 
it. They are underlined.)

So this patch set try to fix this problem.
patch 1: Optimize inode allocation by remembering last group.
We add ip_last_used_group in core directory inodes which records
the last used allocation group. Another field named ip_last_used_slot
is also added in case inode stealing happens. When claiming new inode,
we passed in directory's inode so that the allocation can use this
information.

patch 2: let the Inode group allocs use the global bitmap directly.

patch 3: we add osb_last_alloc_group in ocfs2_super to record the last
used allocation group so that we can make inode groups contiguous enough.

The patch set are based on Mark's merge_window, so they are easy to push.

Regards,
Tao
