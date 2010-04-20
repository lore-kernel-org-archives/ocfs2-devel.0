From: Jan Kara <jack@suse.cz>
Date: Tue, 20 Apr 2010 20:00:54 +0200
Subject: [Ocfs2-devel] Ocfs2 leaking inodes on failed allocation
Message-ID: <20100420180053.GD3885@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

  when running fsstress test on an almost full filesystem we observe
the following errors:
1163.522931] (4774,1):ocfs2_query_inode_wipe:898 ERROR: bug expression:
!(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL))
[ 1163.522938] (4774,1):ocfs2_query_inode_wipe:898 ERROR: Inode 77233
(on-disk 77233) not orphaned! Disk flags  0x1, inode flags 0x0

This is caused by the fact that we succeed in allocating inode in
ocfs2_mknod_locked but later fail to allocate block for symlink data
or directory data because of ENOSPC. So we set i_nlink to 0 and 
by doing iput() we continue through standard inode deletion path but the
inode is not orphaned and thus the error check is triggered.

Now this isn't trivial to fix (at least AFAICS) so I wanted to share my
thoughts before investing too much time in writing the patch which would
be then rejected.

The easiest solution would be to always create inodes in the orphan
directory (we even have a function ocfs2_create_inode_in_orphan for this).
The downside this has would be that I expect we would start contending on
orphan dir i_mutex quite early and thus fs scalability would suffer a lot.
Also there's some additional IO and CPU cost involved...

Adding inode to orphan dir after we find out we cannot finish allocation
is IMHO no-go. Because the filesystem is close to ENOSPC, we even don't
have to have a block to extend orphan directory to accomodate new directory
entry. Also adding to orphan directory has to happen outside of a
transaction (due to lock ordering) but we have a transaction already
started and cannot stop it without adding a link to the inode somewhere
(otherwise we would leak the inode in case of crash).

The last idea I have is that we could "undo" the inode allocation and
other operations we did in the transaction so far. But looking at the code
it would get nasty quickly - all the xattr handling which gets inode locks,
starts & stops transactions, etc...

Any other ideas? What would make things much easier would be if orphan
handling was more lightweight like it is e.g. in ext3 / ext4 - there we
have just linked list of orphaned inodes and so if we decide an inode needs
to be orphaned, we just have to modify the superblock (orphan list head)
and the inode (to point at the current orphan list head)... In OCFS2 we
could have a per-slot lists like this but a change like this would probably
be an overkill for the above bug so it would make sence only if there would
be other benefits from this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
