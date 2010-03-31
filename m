From: Coly Li <coly.li@suse.de>
Date: Wed, 31 Mar 2010 09:09:22 +0800
Subject: [Ocfs2-devel] question for lvb->lvb_igeneration
Message-ID: <4BB2A0C2.7010305@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

As my understanding, inode->i_generation only gets updated when inode with same inode number is recreated.
When truncating a file, the modification of di->i_size will not update the inode->i_generation. Therefore, I suspicious
it's problematic in following condition.

1) in ocfs2_inode_lock_update(), if ocfs2_meta_lvb_is_trustable() returns 1, update inode->i_size from lvb->lvb_isize by
ocfs2_refresh_inode_from_lvb().
2) If the inode's di->i_size is changed, and not updated to lvb->lvb_isize (can this happen ?),
ocfs2_meta_lvb_is_trustable() still returns 1, while inode->i_size still updates from lvb->lvb_isize.
3) When di->i_size != lvb->lvb_isize, when execution goes into ocfs2_truncate_file() from ocfs2_setattr(), a
mlog_bug_on_msg((le64_to_cpu(fe->i_size) != i_size_read(inode), ...) will be triggered.

My question is, is it possible that same inode's lvb->lvb_size and di->i_size can be different ? And if an inode lvb is
really trustable when ocfs2_meta_lvb_is_trustable() returns 1 ?

The reason why I ask this question, is because of bnc#591039 (https://bugzilla.novell.com/show_bug.cgi?id=591039).

Thanks.
-- 
Coly Li
SuSE Labs
