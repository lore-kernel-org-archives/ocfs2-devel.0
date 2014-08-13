From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 13 Aug 2014 11:43:36 -0700
Subject: [Ocfs2-devel] [patch 06/10] ocfs2: call
	ocfs2_journal_access_di() before	ocfs2_journal_dirty() in
	ocfs2_write_end_nolock()
In-Reply-To: <53e290cb.rCYzzvUZ1cY/IQ85%akpm@linux-foundation.org>
References: <53e290cb.rCYzzvUZ1cY/IQ85%akpm@linux-foundation.org>
Message-ID: <20140813184336.GV2203@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 06, 2014 at 01:32:11PM -0700, Andrew Morton wrote:
> From: yangwenfang <vicky.yangwenfang@huawei.com>
> Subject: ocfs2: call ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()
> 
> After we call ocfs2_journal_access_di() in ocfs2_write_begin(),
> jbd2_journal_restart() may also be called, in this function transaction
> A's t_updates-- and obtains a new transaction B.  If
> jbd2_journal_commit_transaction() is happened to commit transaction A,
> when t_updates==0, it will continue to complete commit and unfile buffer.
> 
> So when jbd2_journal_dirty_metadata(), the handle is pointed a new
> transaction B, and the buffer head's journal head is already freed,
> jh->b_transaction == NULL, jh->b_next_transaction == NULL, it returns
> EINVAL, So it triggers the BUG_ON(status).
> 
> thread 1:                             jbd2:
> ocfs2_write_begin                     jbd2_journal_commit_transaction
> ocfs2_write_begin_nolock
>   ocfs2_start_trans
>     jbd2__journal_start(t_updates+1,
>                        transaction A)
>     ocfs2_journal_access_di
>     ocfs2_write_cluster_by_desc
>       ocfs2_mark_extent_written
>         ocfs2_change_extent_flag
>           ocfs2_split_extent
>             ocfs2_extend_rotate_transaction
>               jbd2_journal_restart
>               (t_updates-1,transaction B) t_updates==0
>                                         __jbd2_journal_refile_buffer
> 
> ocfs2_write_end
> ocfs2_write_end_nolock
>     ocfs2_journal_dirty
>         jbd2_journal_dirty_metadata(bug)
>    ocfs2_commit_trans
> 
> In ext4, I found that: jbd2_journal_get_write_access() called by
> 
> ext4_write_end.
> ext4_write_begin
>     ext4_journal_start
>         __ext4_journal_start_sb
>             ext4_journal_check_start
>             jbd2__journal_start
> 
> ext4_write_end
>     ext4_mark_inode_dirty
>         ext4_reserve_inode_write
>             ext4_journal_get_write_access
>                 jbd2_journal_get_write_access
>         ext4_mark_iloc_dirty
>             ext4_do_update_inode
>                 ext4_handle_dirty_metadata
>                     jbd2_journal_dirty_metadata
> 
> 
> So I think we should put ocfs2_journal_access_di before
>   ocfs2_journal_dirty in the ocfs2_write_end.  and it works well after my
>   modification.

Putting the journal_access_di in ocfs2_write_end is the correct thing to do,
thanks. I think we want to keep the journal_access_di in ocfs2_write_begin
though as we may change the disk inode when marking unwritten extents
(see the call to ocfs2_mark_extent_written()). So:

- I would remove the comment above journal_access_di in write_begin but not
  the actual call as we may dirty the inode buffer later.

- Move the call to journal_access_di to the top of ocfs2_write_end_nolock as
  I believe you might be missing some inode buffer updates there too.

Thanks,
	--Mark

--
Mark Fasheh
