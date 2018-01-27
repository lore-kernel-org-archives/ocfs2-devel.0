From: Changwei Ge <ge.changwei@h3c.com>
Date: Sat, 27 Jan 2018 11:19:25 +0000
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: return error when we attempt to
 access a dirty bh in jbd2
References: <5A6C3809.3010701@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F291677F@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

On 2018/1/27 16:28, piaojun wrote:
> We should not reuse the dirty bh in jbd2 directly due to the following
> situation:
> 
> 1. When removing extent rec, we will dirty the bhs of extent rec and
>     truncate log at the same time, and hand them over to jbd2.
> 2. The bhs are submitted to jbd2 area successfully.
> 3. The write-back thread of device help flush the bhs to disk but
>     encounter write error due to abnormal storage link.
> 4. After a while the storage link become normal. Truncate log flush
>     worker triggered by the next space reclaiming found the dirty bh of
>     truncate log and clear its 'BH_Write_EIO' and then set it uptodate in
>     __ocfs2_journal_access():
> 
> ocfs2_truncate_log_worker
>    ocfs2_flush_truncate_log
>      __ocfs2_flush_truncate_log
>        ocfs2_replay_truncate_records
>          ocfs2_journal_access_di
>            __ocfs2_journal_access // here we clear io_error and set 'tl_bh' uptodata.
> 
> 5. Then jbd2 will flush the bh of truncate log to disk, but the bh of
>     extent rec is still in error state, and unfortunately nobody will
>     take care of it.
> 6. At last the space of extent rec was not reduced, but truncate log
>     flush worker have given it back to globalalloc. That will cause
>     duplicate cluster problem which could be identified by fsck.ocfs2.
> 
> Sadlly we can hardly revert this but set fs read-only in case of
> ruining atomicity and consistency of space reclaim.
> 
> Fixes: acf8fdbe6afb ("ocfs2: do not BUG if buffer not uptodate in __ocfs2_journal_access")
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
> ---
>   fs/ocfs2/journal.c | 49 ++++++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 38 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 3630443..4c5661c 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -666,23 +666,50 @@ static int __ocfs2_journal_access(handle_t *handle,
>   	/* we can safely remove this assertion after testing. */
>   	if (!buffer_uptodate(bh)) {
>   		mlog(ML_ERROR, "giving me a buffer that's not uptodate!\n");
> -		mlog(ML_ERROR, "b_blocknr=%llu\n",
> -		     (unsigned long long)bh->b_blocknr);
> +		mlog(ML_ERROR, "b_blocknr=%llu, b_state=0x%lx\n",
> +		     (unsigned long long)bh->b_blocknr, bh->b_state);
> 
>   		lock_buffer(bh);
>   		/*
> -		 * A previous attempt to write this buffer head failed.
> -		 * Nothing we can do but to retry the write and hope for
> -		 * the best.
> +		 * We should not reuse the dirty bh directly due to the
> +		 * following situation:
> +		 *
> +		 * 1. When removing extent rec, we will dirty the bhs of
> +		 *    extent rec and truncate log at the same time, and
> +		 *    hand them over to jbd2.
> +		 * 2. The bhs are submitted to jbd2 area successfully.
> +		 * 3. The write-back thread of device help flush the bhs
> +		 *    to disk but encounter write error due to abnormal
> +		 *    storage link.
> +		 * 4. After a while the storage link become normal.
> +		 *    Truncate log flush worker triggered by the next
> +		 *    space reclaiming found the dirty bh of truncate log
> +		 *    and clear its 'BH_Write_EIO' and then set it uptodate
> +		 *    in __ocfs2_journal_access():
> +		 *
> +		 *    ocfs2_truncate_log_worker
> +		 *      ocfs2_flush_truncate_log
> +		 *        __ocfs2_flush_truncate_log
> +		 *          ocfs2_replay_truncate_records
> +		 *            ocfs2_journal_access_di
> +		 *              __ocfs2_journal_access
> +		 *
> +		 * 5. Then jbd2 will flush the bh of truncate log to disk,
> +		 *    but the bh of extent rec is still in error state, and
> +		 *    unfortunately nobody will take care of it.
> +		 * 6. At last the space of extent rec was not reduced,
> +		 *    but truncate log flush worker have given it back to
> +		 *    globalalloc. That will cause duplicate cluster problem
> +		 *    which could be identified by fsck.ocfs2.
> +		 *
> +		 * Sadlly we can hardly revert this but set fs read-only
> +		 * in case of ruining atomicity and consistency of space
> +		 * reclaim.
>   		 */

It's tons of comments here and it seems the same with what's in change log.
Must we add them here?
Besides, the scenario the comment is describing is not a common case.
I think the issue will also cause some other metadata inconsistency.
So the comments will make maintainers puzzle afterwards.
I suggest to simplify it like below, for your reference:

A previous transaction with a couple buffer heads fails checkpoint, so all those buffer heads are marked IO_ERROR.
For current transaction, a buffer head is shared with the previous one with IO_ERROR.
We can't just clear IO_ERROR and continue ,since other buffer heads are not written to disk yet.
Above case will cause metadata inconsistency.
Just return -EORFS here and abort journal to avoid damage file system.

Thanks,
Changwei

>   		if (buffer_write_io_error(bh) && !buffer_uptodate(bh)) {
> -			clear_buffer_write_io_error(bh);
> -			set_buffer_uptodate(bh);
> -		}
> -
> -		if (!buffer_uptodate(bh)) {
>   			unlock_buffer(bh);
> -			return -EIO;
> +			return ocfs2_error(osb->sb, "A previous attempt to "
> +					"write this buffer head failed\n");
>   		}
>   		unlock_buffer(bh);
>   	}
> 
