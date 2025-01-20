Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ADC179BF
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jan 2025 01:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737335704; cv=none; b=cWQDHTU50opFgo1MTH933Dqqh/U1xWJFtx16JdmSQB7TBtib2WXJroSwu4J8YltAwY/L0aBYHwE6bxRc/T/FrPKXiv4be75pn/ZBlpzebBMRZ773f1EhGIioxshGQea6/rttzMc5NNTU1OfFpiU35jALnGlXoPmUWYd8legp6k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737335704; c=relaxed/simple;
	bh=3/Z6DbJOXRmHyOfuIhNNTlKbbA4f5YrmZpaJMYJLYfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=arHT2z2WRBoE1IBmPidfmal7xN/XGrqWnLInQWB4nRdMUMji7XabKWW+3wRjFdT8mIrBya3g09lB94w45waH2RaYKkEalgLyY4s+45+7iyg4GMJAZBor/ot2VeG267kSkkp8cP+AH3kEXGDHIyMFUHL74SdObO/kxe+hOvTmY5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cjKsdXuI; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cjKsdXuI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1737335693; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mPh50Tqmd692JlGZotayXZgwUZLqXePYhljwIsmYUHY=;
	b=cjKsdXuIZN9Wd+CW9+YkUeQ4/vHPTp+wul6NatoTGPuM6K4ipBblbFMYmlKkLclFR+cB0BJvh3vUVcBH1qAjQigLmO6yo1PtOqDWr5dOLUPRmPb9EsEHPbgu6f7+0IZfnDw7rnw2Wl0gKzSCewlJOAF9HWrWt/C+WAgE6kaLGXA=
Received: from 30.221.128.194(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WNv28qt_1737335691 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jan 2025 09:14:52 +0800
Message-ID: <fcb58af3-0479-4156-86e9-feccee02912e@linux.alibaba.com>
Date: Mon, 20 Jan 2025 09:14:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Use str_yes_no() and str_no_yes() helper functions
To: Thorsten Blum <thorsten.blum@linux.dev>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, "Dr. David Alan Gilbert"
 <linux@treblig.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250117091335.1189-2-thorsten.blum@linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250117091335.1189-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/17 17:13, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_yes_no() and str_no_yes()
> helper functions.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlm/dlmdebug.c    |  9 +++++----
>  fs/ocfs2/dlm/dlmmaster.c   | 12 ++++++------
>  fs/ocfs2/dlm/dlmrecovery.c |  7 +++----
>  fs/ocfs2/dlmglue.c         |  3 ++-
>  4 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index e9ef4e2b0e75..fe4fdd09bae3 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -14,6 +14,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/debugfs.h>
>  #include <linux/export.h>
> +#include <linux/string_choices.h>
>  
>  #include "../cluster/heartbeat.h"
>  #include "../cluster/nodemanager.h"
> @@ -90,12 +91,12 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
>  	       buf, res->owner, res->state);
>  	printk("  last used: %lu, refcnt: %u, on purge list: %s\n",
>  	       res->last_used, kref_read(&res->refs),
> -	       list_empty(&res->purge) ? "no" : "yes");
> +	       str_no_yes(list_empty(&res->purge)));
>  	printk("  on dirty list: %s, on reco list: %s, "
>  	       "migrating pending: %s\n",
> -	       list_empty(&res->dirty) ? "no" : "yes",
> -	       list_empty(&res->recovering) ? "no" : "yes",
> -	       res->migration_pending ? "yes" : "no");
> +	       str_no_yes(list_empty(&res->dirty)),
> +	       str_no_yes(list_empty(&res->recovering)),
> +	       str_yes_no(res->migration_pending));
>  	printk("  inflight locks: %d, asts reserved: %d\n",
>  	       res->inflight_locks, atomic_read(&res->asts_reserved));
>  	dlm_print_lockres_refmap(res);
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index d610da8e2f24..86bb1a03bcc1 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -21,7 +21,7 @@
>  #include <linux/inet.h>
>  #include <linux/spinlock.h>
>  #include <linux/delay.h>
> -
> +#include <linux/string_choices.h>
>  
>  #include "../cluster/heartbeat.h"
>  #include "../cluster/nodemanager.h"
> @@ -2859,7 +2859,7 @@ static int dlm_mark_lockres_migrating(struct dlm_ctxt *dlm,
>  	dlm_lockres_release_ast(dlm, res);
>  
>  	mlog(0, "about to wait on migration_wq, dirty=%s\n",
> -	       res->state & DLM_LOCK_RES_DIRTY ? "yes" : "no");
> +	       str_yes_no(res->state & DLM_LOCK_RES_DIRTY));
>  	/* if the extra ref we just put was the final one, this
>  	 * will pass thru immediately.  otherwise, we need to wait
>  	 * for the last ast to finish. */
> @@ -2869,12 +2869,12 @@ static int dlm_mark_lockres_migrating(struct dlm_ctxt *dlm,
>  		   msecs_to_jiffies(1000));
>  	if (ret < 0) {
>  		mlog(0, "woken again: migrating? %s, dead? %s\n",
> -		       res->state & DLM_LOCK_RES_MIGRATING ? "yes":"no",
> -		       test_bit(target, dlm->domain_map) ? "no":"yes");
> +		       str_yes_no(res->state & DLM_LOCK_RES_MIGRATING),
> +		       str_no_yes(test_bit(target, dlm->domain_map)));
>  	} else {
>  		mlog(0, "all is well: migrating? %s, dead? %s\n",
> -		       res->state & DLM_LOCK_RES_MIGRATING ? "yes":"no",
> -		       test_bit(target, dlm->domain_map) ? "no":"yes");
> +		       str_yes_no(res->state & DLM_LOCK_RES_MIGRATING),
> +		       str_no_yes(test_bit(target, dlm->domain_map)));
>  	}
>  	if (!dlm_migration_can_proceed(dlm, res, target)) {
>  		mlog(0, "trying again...\n");
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 50da8af988c1..380f9b777ad5 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -22,7 +22,7 @@
>  #include <linux/timer.h>
>  #include <linux/kthread.h>
>  #include <linux/delay.h>
> -
> +#include <linux/string_choices.h>
>  
>  #include "../cluster/heartbeat.h"
>  #include "../cluster/nodemanager.h"
> @@ -581,8 +581,7 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
>  							   msecs_to_jiffies(1000));
>  					mlog(0, "waited 1 sec for %u, "
>  					     "dead? %s\n", ndata->node_num,
> -					     dlm_is_node_dead(dlm, ndata->node_num) ?
> -					     "yes" : "no");
> +					     str_yes_no(dlm_is_node_dead(dlm, ndata->node_num)));
>  				} else {
>  					/* -ENOMEM on the other node */
>  					mlog(0, "%s: node %u returned "
> @@ -677,7 +676,7 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
>  		spin_unlock(&dlm_reco_state_lock);
>  
>  		mlog(0, "pass #%d, all_nodes_done?: %s\n", ++pass,
> -		     all_nodes_done?"yes":"no");
> +		     str_yes_no(all_nodes_done));
>  		if (all_nodes_done) {
>  			int ret;
>  
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 764ecbd5ad41..30e4fedb3f02 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -19,6 +19,7 @@
>  #include <linux/delay.h>
>  #include <linux/quotaops.h>
>  #include <linux/sched/signal.h>
> +#include <linux/string_choices.h>
>  
>  #define MLOG_MASK_PREFIX ML_DLM_GLUE
>  #include <cluster/masklog.h>
> @@ -4339,7 +4340,7 @@ static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
>  		ocfs2_schedule_blocked_lock(osb, lockres);
>  
>  	mlog(ML_BASTS, "lockres %s, requeue = %s.\n", lockres->l_name,
> -	     ctl.requeue ? "yes" : "no");
> +	     str_yes_no(ctl.requeue));
>  	spin_unlock_irqrestore(&lockres->l_lock, flags);
>  
>  	if (ctl.unblock_action != UNBLOCK_CONTINUE

