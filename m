From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 20 May 2015 16:22:12 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: do not BUG if
 jbd2_journal_dirty_metadata fails
In-Reply-To: <55515D2B.8010202@huawei.com>
References: <55515D2B.8010202@huawei.com>
Message-ID: <555C4434.7090807@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/12/2015 09:53 AM, Joseph Qi wrote:
> jbd2_journal_dirty_metadata may fail. Currently it cannot take care of
> non zero return value and just BUG in ocfs2_journal_dirty.
> This patch is aborting the handle and journal instead of BUG.
> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Cc: joyce.xue <xuejiufei@huawei.com>
> ---
>  fs/ocfs2/journal.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index ff53192..eefca1e 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -775,7 +775,17 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)
>  	trace_ocfs2_journal_dirty((unsigned long long)bh->b_blocknr);
> 
>  	status = jbd2_journal_dirty_metadata(handle, bh);
> -	BUG_ON(status);
> +	if (status) {
> +		mlog_errno(status);
> +		if (!is_handle_aborted(handle)) {
> +			journal_t *journal = handle->h_transaction->t_journal;
> +
> +			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed. "
> +					"Aborting transaction and journal.");
> +			handle->h_err = status;
> +			jbd2_journal_abort_handle(handle);
> +			jbd2_journal_abort(journal, status);
Let fs go after journal lose affect seemed not safe, may we set fs
read-only here?

Thanks,
Junxiao.


> +		}
> +	}
>  }
> 
>  #define OCFS2_DEFAULT_COMMIT_INTERVAL	(HZ * JBD2_DEFAULT_MAX_COMMIT_AGE)
> 
