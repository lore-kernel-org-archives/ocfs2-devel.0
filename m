From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 4 Feb 2010 18:27:29 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Plugs race between the dc
	thread	and an unlock ast message
In-Reply-To: <1265221014-10591-1-git-send-email-sunil.mushran@oracle.com>
References: <1265221014-10591-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100204102729.GA4339@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

Just for my knowledage.

By "unlock ast message", do you meant
ocfs2_locking_ast()->ocfs2_generic_handle_downconvert_action()?

If yes, 
if l_blocking did not changed before ocfs2_generic_handle_downconvert_action(),
when l_level is set with a lower value, l_blocking must change.
So why we need to check l_level?

regards,
wengang.

On 10-02-03 10:16, Sunil Mushran wrote:
> This patch plugs a race between the downconvert thread and an unlock ast message.
> Specifically, after the downconvert worker has done its task, the dc thread needs
> to check whether an unlock ast made the downconvert moot.
> 
> Reported-by: David Teigland <teigland@redhat.com>
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Acked-by: Mark Fasheh <mfasheh@sus.com>
> ---
>  fs/ocfs2/dlmglue.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 1c4d704..28b3e21 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3384,6 +3384,7 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
>  	unsigned long flags;
>  	int blocking;
>  	int new_level;
> +	int level;
>  	int ret = 0;
>  	int set_lvb = 0;
>  	unsigned int gen;
> @@ -3503,6 +3504,7 @@ recheck:
>  	 * may sleep, so we save off a copy of what we're blocking as
>  	 * it may change while we're not holding the spin lock. */
>  	blocking = lockres->l_blocking;
> +	level = lockres->l_level;
>  	spin_unlock_irqrestore(&lockres->l_lock, flags);
>  
>  	ctl->unblock_action = lockres->l_ops->downconvert_worker(lockres, blocking);
> @@ -3511,7 +3513,7 @@ recheck:
>  		goto leave;
>  
>  	spin_lock_irqsave(&lockres->l_lock, flags);
> -	if (blocking != lockres->l_blocking) {
> +	if ((blocking != lockres->l_blocking) || (level != lockres->l_level)) {
>  		/* If this changed underneath us, then we can't drop
>  		 * it just yet. */
>  		goto recheck;
> -- 
> 1.6.3.3
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
