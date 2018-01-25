From: Gang He <ghe@suse.com>
Date: Thu, 25 Jan 2018 01:40:47 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: return error when we attempt to
 access a dirty bh in jbd2
In-Reply-To: <5A6943BC.5010406@huawei.com>
References: <5A6943BC.5010406@huawei.com>
Message-ID: <5A6A088F020000F9000A6354@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

If we return -EIO here, what is the consequence?
make the journal aborted and file system will become read-only?

Thanks
Gang


>>> 
> We should not reuse the dirty bh in jbd2 directly due to the following
> situation:
> 
> 1. When removing extent rec, we will dirty the bhs of extent rec and
>    truncate log at the same time, and hand them over to jbd2.
> 2. The bhs are not flushed to disk due to abnormal storage link.
> 3. After a while the storage link become normal. Truncate log flush
>    worker triggered by the next space reclaiming found the dirty bh of
>    truncate log and clear its 'BH_Write_EIO' and then set it uptodate
>    in __ocfs2_journal_access():
> 
> ocfs2_truncate_log_worker
>   ocfs2_flush_truncate_log
>     __ocfs2_flush_truncate_log
>       ocfs2_replay_truncate_records
>         ocfs2_journal_access_di
>           __ocfs2_journal_access // here we clear io_error and set 'tl_bh' 
> uptodata.
> 
> 4. Then jbd2 will flush the bh of truncate log to disk, but the bh of
>    extent rec is still in error state, and unfortunately nobody will
>    take care of it.
> 5. At last the space of extent rec was not reduced, but truncate log
>    flush worker have given it back to globalalloc. That will cause
>    duplicate cluster problem which could be identified by fsck.ocfs2.
> 
> So we should return -EIO in case of ruining atomicity and consistency
> of space reclaim.
> 
> Fixes: acf8fdbe6afb ("ocfs2: do not BUG if buffer not uptodate in 
> __ocfs2_journal_access")
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
> ---
>  fs/ocfs2/journal.c | 45 +++++++++++++++++++++++++++++++++++----------
>  1 file changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 3630443..d769ca2 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -666,21 +666,46 @@ static int __ocfs2_journal_access(handle_t *handle,
>  	/* we can safely remove this assertion after testing. */
>  	if (!buffer_uptodate(bh)) {
>  		mlog(ML_ERROR, "giving me a buffer that's not uptodate!\n");
> -		mlog(ML_ERROR, "b_blocknr=%llu\n",
> -		     (unsigned long long)bh->b_blocknr);
> +		mlog(ML_ERROR, "b_blocknr=%llu, b_state=0x%lx\n",
> +		     (unsigned long long)bh->b_blocknr, bh->b_state);
> 
>  		lock_buffer(bh);
>  		/*
> -		 * A previous attempt to write this buffer head failed.
> -		 * Nothing we can do but to retry the write and hope for
> -		 * the best.
> +		 * We should not reuse the dirty bh directly due to the
> +		 * following situation:
> +		 *
> +		 * 1. When removing extent rec, we will dirty the bhs of
> +		 *    extent rec and truncate log at the same time, and
> +		 *    hand them over to jbd2.
> +		 * 2. The bhs are not flushed to disk due to abnormal
> +		 *    storage link.
> +		 * 3. After a while the storage link become normal.
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
> +		 * 4. Then jbd2 will flush the bh of truncate log to disk,
> +		 *    but the bh of extent rec is still in error state, and
> +		 *    unfortunately nobody will take care of it.
> +		 * 5. At last the space of extent rec was not reduced,
> +		 *    but truncate log flush worker have given it back to
> +		 *    globalalloc. That will cause duplicate cluster problem
> +		 *    which could be identified by fsck.ocfs2.
> +		 *
> +		 * So we should return -EIO in case of ruining atomicity
> +		 * and consistency of space reclaim.
>  		 */
>  		if (buffer_write_io_error(bh) && !buffer_uptodate(bh)) {
> -			clear_buffer_write_io_error(bh);
> -			set_buffer_uptodate(bh);
> -		}
> -
> -		if (!buffer_uptodate(bh)) {
> +			mlog(ML_ERROR, "A previous attempt to write this "
> +				"buffer head failed\n");
>  			unlock_buffer(bh);
>  			return -EIO;
>  		}
> -- 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
