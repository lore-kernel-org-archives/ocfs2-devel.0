From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 31 Mar 2010 10:44:49 +0800
Subject: [Ocfs2-devel] question for lvb->lvb_igeneration
In-Reply-To: <4BB2A0C2.7010305@suse.de>
References: <4BB2A0C2.7010305@suse.de>
Message-ID: <20100331024449.GA2184@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Coly,

Let me try to comment.

On 10-03-31 09:09, Coly Li wrote:
> Hi,
> 
> As my understanding, inode->i_generation only gets updated when inode with same inode number is recreated.
> When truncating a file, the modification of di->i_size will not update the inode->i_generation. Therefore, I suspicious
> it's problematic in following condition.

Yes I think the generation don't change during the life of an inode.
The generation comparation in ocfs2_meta_lvb_is_trustable() is to make
sure it's the correct inode to refresh form lvb.

> 
> 1) in ocfs2_inode_lock_update(), if ocfs2_meta_lvb_is_trustable() returns 1, update inode->i_size from lvb->lvb_isize by
> ocfs2_refresh_inode_from_lvb().

The lvb is valid in case the prior EX holder(another node) just downgraded it
to PR or NL. So lvb carries the newest inode meta.
refreshing from lvb(in memory) is much faster than updating from disk.

> 2) If the inode's di->i_size is changed, and not updated to lvb->lvb_isize (can this happen ?),

I think this can't happen unless there is a bug.

> ocfs2_meta_lvb_is_trustable() still returns 1, while inode->i_size still updates from lvb->lvb_isize.
> 3) When di->i_size != lvb->lvb_isize, when execution goes into ocfs2_truncate_file() from ocfs2_setattr(), a
> mlog_bug_on_msg((le64_to_cpu(fe->i_size) != i_size_read(inode), ...) will be triggered.

coming to the mlog_bug_on_msg(), inode meta is already updated from
lvb(when needed), In case we did refresh from lvb, the prior EX holder
has flushed meta to disk before releasing EX lock. So reading inode
block(no cache) on this node get the newest meta.

> My question is, is it possible that same inode's lvb->lvb_size and di->i_size can be different ? And if an inode lvb is
> really trustable when ocfs2_meta_lvb_is_trustable() returns 1 ?

I think lvb is trustable. If di->i_size mismatches lvb->lvb_size, either
we are taking a wrong lvb or the di is stale.
> 
> The reason why I ask this question, is because of bnc#591039 (https://bugzilla.novell.com/show_bug.cgi?id=591039).

regards,
wengang.
