From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 2 Jun 2014 16:21:40 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove some unused codes
In-Reply-To: <537EB09E.7080004@huawei.com>
References: <537EB09E.7080004@huawei.com>
Message-ID: <20140602162140.35b5ec0bdae2959a983f8c99@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 23 May 2014 10:21:18 +0800 Xue jiufei <xuejiufei@huawei.com> wrote:

Please write changelogs for the patches if they are not utterly obvious?

And part of this patch was not utterly obvious.  So I wrote your changelog:

: dlm_recovery_ctxt.received is unused.
:
: ocfs2_should_refresh_lock_res() can only return 0 or 1, so the error
: handling code in ocfs2_super_lock() is unneeded.

> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2544,11 +2544,6 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
>  	 * refreshed, so we do it here. Of course, making sense of
>  	 * everything is up to the caller :) */
>  	status = ocfs2_should_refresh_lock_res(lockres);
> -	if (status < 0) {
> -		ocfs2_cluster_unlock(osb, lockres, level);
> -		mlog_errno(status);
> -		goto bail;
> -	}
>  	if (status) {
>  		status = ocfs2_refresh_slot_info(osb);

One does wonder if this is the correct fix.  Perhaps
ocfs2_should_refresh_lock_res() should be checking something but forgot
to do so?
