From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 May 2015 16:03:50 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: do not BUG if
 jbd2_journal_dirty_metadata fails
In-Reply-To: <55515D2B.8010202@huawei.com>
References: <55515D2B.8010202@huawei.com>
Message-ID: <20150512160350.476474387848736a843817e9@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 12 May 2015 09:53:47 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> jbd2_journal_dirty_metadata may fail. Currently it cannot take care of
> non zero return value and just BUG in ocfs2_journal_dirty.
> This patch is aborting the handle and journal instead of BUG.
> 

This patch is internally inconsistent.

> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -775,7 +775,17 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)

The "-775,7 +775,17" means "the 7 lines at line 775 get turned into 17
lines".  ie: 10 lines are added.

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
> +		}
> +	}
>  }

But the patch deletes 1 line and adds 12, for a net addition of 11 lines,
not 10.

So the patch doesn't apply.  Changing the "17" to "18" fixes that.


Whatever tool you used for generating this patch needs slapping.
