From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 19 Jun 2009 15:55:05 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Provide the ocfs2_dlm_lvb_valid()
 stack API. v2 stack API.
In-Reply-To: <20090619224047.GK29140@mail.oracle.com>
References: <20090619221921.GH29140@mail.oracle.com>
	<20090619224047.GK29140@mail.oracle.com>
Message-ID: <4A3C1749.6060704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>


Joel Becker wrote:
> Changes from v1:
> - I totally failed to use the API in dlmglue.c!
>
> The Lock Value Block (LVB) of a DLM lock can be lost when nodes die and
> the DLM cannot reconstruct its state.  Clients of the DLM need to know
> this.
>
> ocfs2's internal DLM, o2dlm, explicitly zeroes out the LVB when it loses
> track of the state.  This is not a standard behavior, but ocfs2 has
> always relied on it.  Thus, an o2dlm LVB is always "valid".
>
> ocfs2 now supports both o2dlm and fs/dlm via the stack glue.  When
> fs/dlm loses track of an LVBs state, it sets a flag
> (DLM_SBF_VALNOTVALID) on the Lock Status Block (LKSB).  The contents of
> the LVB may be garbage or merely stale.
>
> ocfs2 doesn't want to try to guess at the validity of the stale LVB.
> Instead, it should be checking the VALNOTVALID flag.  As this is the
> 'standard' way of treating LVBs, we will promote this behavior.
>
> We add a stack glue API ocfs2_dlm_lvb_valid().  It returns non-zero when
> the LVB is valid.  o2dlm will always return valid, while fs/dlm will
> check VALNOTVALID.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/dlmglue.c    |    9 ++++++---
>  fs/ocfs2/stack_o2cb.c |   11 +++++++++++
>  fs/ocfs2/stack_user.c |    8 ++++++++
>  fs/ocfs2/stackglue.c  |   13 +++++++------
>  fs/ocfs2/stackglue.h  |    6 ++++++
>  5 files changed, 38 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 6cdeaa7..83d2ddb 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1989,7 +1989,8 @@ static inline int ocfs2_meta_lvb_is_trustable(struct inode *inode,
>  {
>  	struct ocfs2_meta_lvb *lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>  
> -	if (lvb->lvb_version == OCFS2_LVB_VERSION
> +	if (ocfs2_dlm_lvb_valid(&lockres->l_lksb)
> +	    && lvb->lvb_version == OCFS2_LVB_VERSION
>  	    && be32_to_cpu(lvb->lvb_igeneration) == inode->i_generation)
>  		return 1;
>  	return 0;
> @@ -2382,7 +2383,8 @@ int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int ex)
>  		return status;
>  
>  	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
> -	if (lvb->lvb_version == OCFS2_ORPHAN_LVB_VERSION)
> +	if (ocfs2_dlm_lvb_valid(&lockres->l_lksb) &&
> +	    lvb->lvb_version == OCFS2_ORPHAN_LVB_VERSION)
>  		*seqno = be32_to_cpu(lvb->lvb_os_seqno);
>  	return status;
>  }
> @@ -3627,7 +3629,8 @@ static int ocfs2_refresh_qinfo(struct ocfs2_mem_dqinfo *oinfo)
>  	struct ocfs2_global_disk_dqinfo *gdinfo;
>  	int status = 0;
>  
> -	if (lvb->lvb_version == OCFS2_QINFO_LVB_VERSION) {
> +	if (ocfs2_dlm_lvb_valid(&lockres->l_lksb) &&
> +	    lvb->lvb_version == OCFS2_QINFO_LVB_VERSION) {
>  		info->dqi_bgrace = be32_to_cpu(lvb->lvb_bgrace);
>  		info->dqi_igrace = be32_to_cpu(lvb->lvb_igrace);
>  		oinfo->dqi_syncms = be32_to_cpu(lvb->lvb_syncms);
> diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
> index fcd120f..3f66137 100644
> --- a/fs/ocfs2/stack_o2cb.c
> +++ b/fs/ocfs2/stack_o2cb.c
> @@ -236,6 +236,16 @@ static int o2cb_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
>  	return dlm_status_to_errno(lksb->lksb_o2dlm.status);
>  }
>  
> +/*
> + * o2dlm aways has a "valid" LVB. If the dlm loses track of the LVB
> + * contents, it will zero out the LVB.  Thus the caller can always trust
> + * the contents.
> + */
> +static int o2cb_dlm_lvb_valid(union ocfs2_dlm_lksb *lksb)
> +{
> +	return 1;
> +}
> +
>  static void *o2cb_dlm_lvb(union ocfs2_dlm_lksb *lksb)
>  {
>  	return (void *)(lksb->lksb_o2dlm.lvb);
> @@ -354,6 +364,7 @@ static struct ocfs2_stack_operations o2cb_stack_ops = {
>  	.dlm_lock	= o2cb_dlm_lock,
>  	.dlm_unlock	= o2cb_dlm_unlock,
>  	.lock_status	= o2cb_dlm_lock_status,
> +	.lvb_valid	= o2cb_dlm_lvb_valid,
>  	.lock_lvb	= o2cb_dlm_lvb,
>  	.dump_lksb	= o2cb_dump_lksb,
>  };
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 9b76d41..ff4c798 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -738,6 +738,13 @@ static int user_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
>  	return lksb->lksb_fsdlm.sb_status;
>  }
>  
> +static int user_dlm_lvb_valid(union ocfs2_dlm_lksb *lksb)
> +{
> +	int invalid = lksb->lksb_fsdlm.sb_flags & DLM_SBF_VALNOTVALID;
> +
> +	return !invalid;
> +}
> +
>  static void *user_dlm_lvb(union ocfs2_dlm_lksb *lksb)
>  {
>  	if (!lksb->lksb_fsdlm.sb_lvbptr)
> @@ -873,6 +880,7 @@ static struct ocfs2_stack_operations ocfs2_user_plugin_ops = {
>  	.dlm_lock	= user_dlm_lock,
>  	.dlm_unlock	= user_dlm_unlock,
>  	.lock_status	= user_dlm_lock_status,
> +	.lvb_valid	= user_dlm_lvb_valid,
>  	.lock_lvb	= user_dlm_lvb,
>  	.plock		= user_plock,
>  	.dump_lksb	= user_dlm_dump_lksb,
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 68b668b..3f2f1c4 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -6,7 +6,7 @@
>   * Code which implements an OCFS2 specific interface to underlying
>   * cluster stacks.
>   *
> - * Copyright (C) 2007 Oracle.  All rights reserved.
> + * Copyright (C) 2007, 2009 Oracle.  All rights reserved.
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public
> @@ -271,11 +271,12 @@ int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
>  }
>  EXPORT_SYMBOL_GPL(ocfs2_dlm_lock_status);
>  
> -/*
> - * Why don't we cast to ocfs2_meta_lvb?  The "clean" answer is that we
> - * don't cast at the glue level.  The real answer is that the header
> - * ordering is nigh impossible.
> - */
> +int ocfs2_dlm_lvb_valid(union ocfs2_dlm_lksb *lksb)
> +{
> +	return active_stack->sp_ops->lvb_valid(lksb);
> +}
> +EXPORT_SYMBOL_GPL(ocfs2_dlm_lvb_valid);
> +
>  void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb)
>  {
>  	return active_stack->sp_ops->lock_lvb(lksb);
> diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
> index c571af3..03a44d6 100644
> --- a/fs/ocfs2/stackglue.h
> +++ b/fs/ocfs2/stackglue.h
> @@ -186,6 +186,11 @@ struct ocfs2_stack_operations {
>  	int (*lock_status)(union ocfs2_dlm_lksb *lksb);
>  
>  	/*
> +	 * Return non-zero if the LVB is valid.
> +	 */
> +	int (*lvb_valid)(union ocfs2_dlm_lksb *lksb);
> +
> +	/*
>  	 * Pull the lvb pointer off of the stack-specific lksb.
>  	 */
>  	void *(*lock_lvb)(union ocfs2_dlm_lksb *lksb);
> @@ -252,6 +257,7 @@ int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
>  		     struct ocfs2_lock_res *astarg);
>  
>  int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb);
> +int ocfs2_dlm_lvb_valid(union ocfs2_dlm_lksb *lksb);
>  void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb);
>  void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb);
>  
>   
