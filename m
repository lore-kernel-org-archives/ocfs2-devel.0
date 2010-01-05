From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 05 Jan 2010 09:50:33 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: set OCFS2_LOCK_BLOCKED properly
In-Reply-To: <201001051707.o05Gxath022586@acsinet15.oracle.com>
References: <201001051707.o05Gxath022586@acsinet15.oracle.com>
Message-ID: <4B437BE9.7090803@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

woah... this looks like a good catch.

Mark?

Wengang Wang wrote:
> for most cases ocfs2_generic_handle_bast() return 1 meaning that some down-
> converting work should be done. but when it return 0, the OCFS2_LOCK_BLOCKED is
> set inproperly.
> OCFS2_LOCK_BLOCKED is cleared in a down-convertion(dc) is done. if no dc is needed
> any more(done by another lock request queued before this one), OCFS2_LOCK_BLOCKED
> stays there unexpectly.
>
> the fix is that setting that flag when dc(s) is really needed.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlmglue.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index c5e4a49..e18eadf 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -907,8 +907,6 @@ static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres,
>  
>  	assert_spin_locked(&lockres->l_lock);
>  
> -	lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
> -
>  	if (level > lockres->l_blocking) {
>  		/* only schedule a downconvert if we haven't already scheduled
>  		 * one that goes low enough to satisfy the level we're
> @@ -921,6 +919,9 @@ static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres,
>  		lockres->l_blocking = level;
>  	}
>  
> +	if (needs_downconvert)
> +		lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
> +		
>  	mlog_exit(needs_downconvert);
>  	return needs_downconvert;
>  }
>   
