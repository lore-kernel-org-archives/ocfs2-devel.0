Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793000139;
	b=OuaiqBv9OcS9oOGIBikwqNBPWD0Me5hsVpPHOPKPrJhEtWQ05B8YtlhHxX1+WpPOwceP
	 d+RZAZEMbdmydsskfHdlMlXXEbj3qzLAUAKFnH5Kc5cPQHFNgoYWBg0AY5+G/bZ083ptj
	 EfjOVqYuHlrPUkITAcJXFPuF4imgpC37/HiJLc72SlXh7a5pzDBQqdSMMPu7CruH9e7CU
	 pns5Wprzx/Wj+pvkBA82Q86+JAFjp08oGBY3tek44uGd3tQdBgFEnOTr1Bc49x4oLmlue
	 PvHyLzrqndktzWr8QvlRNeNFtRQQKcuAuOj32ZjR5m3Cjf1pwpX7enJeP8nUHjONEMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793000139;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=jBfB8fIh9sLjpPgzQDyDCLXx/dHJVZUaeC0qV6JKDew=;
	b=xzDJGLAbn5Fb2RZVsSEcUF79wuShaRq/0IttqZrnyQnCE9odH/SZSZ7jrmqKjjbzD1hW
	 8tB59BJlYi5YnSMXmlJKxeh8xE3Vz52Z+OO8qC+VXiDtLdFOTOsTaSVA7kp1FKjRRhMxx
	 OqkWiDY9825I7VutQ9IxQJOojekyIi18OhBvoSLl3Pp4k1gjQTl0yd4nXM4ZNrlDWBeyx
	 GQYoMVYmwdWa27U3lRYDhdHbsfHZ9Rne7hqSMaPr2lrkoXul6/uM+Sk0PCd7LuR/5UMiD
	 mdAWAA3724TaJq7ppuD8nrbnZeCwTlQ4AUY1m0+7PpdM1oz+Kj21SsrnLVKBgi/S6WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="bL9c3tg/";
	arc=none smtp.remote-ip=115.124.30.101
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4D9606A31A
	for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 07:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E4D9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=bL9c3tg/
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793000128; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jBfB8fIh9sLjpPgzQDyDCLXx/dHJVZUaeC0qV6JKDew=;
	b=bL9c3tg/EIwqV78/CtYHkjvo4cn3OF32JZcJYogpWwrhPalnAu4dqGTRuEt74+Cmp8VXGISVMfltsXR1I8RF3hqHXaEAGrgaJuNHDy58p0vu4OrHqS3/llDXcGLLtMSaIIguhbxVV7+1pXtPdLYPYLXrhKYejT9q5/ceq4dtzPo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDTo0vY_1793000127;
Received: from 30.221.130.82(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDTo0vY_1793000127 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 15:35:27 +0800
Message-ID: <234626be-335b-4b08-b5fd-38d0e3d27627@linux.alibaba.com>
Date: Mon, 26 Oct 2026 15:35:26 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: cache the mount context for dentry lock
 callbacks
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0012-v9-eeb9084fb29577971229@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0012-v9-eeb9084fb29577971229@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/20/26 10:25 PM, Cen Zhang wrote:
> ocfs2_drop_dentry_lock() drops the inode reference before releasing the
> DENTRY lock. This lets inode eviction release the local inode and open
> locks before a remote unlink can proceed past the DENTRY lock.
> 
> A DLM callback can still arrive before the DENTRY lock has been dropped.
> ocfs2_get_dentry_osb() obtains the mount context through dl_inode->i_sb,
> which can access a freed inode when the downconvert thread drops the
> last inode reference in its post-unlock callback:
> 
>   Downconvert thread                     DLM callback thread
>   ------------------                     -------------------
>   ocfs2_process_blocked_lock()
>     ocfs2_dentry_post_unlock()
>       ocfs2_dentry_lock_put()
>         ocfs2_drop_dentry_lock()
>           iput(dl->dl_inode)
>           [inode reclaimed after RCU]
>                                          ocfs2_blocking_ast()
>                                            ocfs2_get_dentry_osb()
>                                              dl->dl_inode->i_sb
>           ocfs2_simple_drop_lockres()
> 
> Store the mount context in the DENTRY lock resource's l_priv field and
> use the default mount-context lookup. Recover the containing dentry
> lock with container_of(), as already done for refcount locks, and remove
> ocfs2_get_dentry_osb(). ocfs2_dismount_volume() shuts down the DLM before
> freeing the mount context, so callbacks can use it without accessing the
> inode. Preserve the existing iput-before-unlock order to avoid delaying
> local inode and open lock release until after the DENTRY lock is released.
> 
> Fixes: 8ed6b23709b3 ("ocfs2: revert iput deferring code in ocfs2_drop_dentry_lock")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changes in v4:
> - Drop the convert-worker change from v3. Keep MAYBE_ORPHANED marking before
>   the extra-reference check, including the dl_count == 0 path needed for
>   local orphan cleanup.
> - Retain the osb cache from v2 and the original iput-before-unlock order;
>   remove the incorrect worker-lifetime claims from the commit message.
> 
> Changes in v3:
> - Move the inode lookup and MAYBE_ORPHANED update after the existing
>   FREEING/dl_count guard and successful extra-reference acquisition,
>   addressing Joseph Qi's review.
> - Keep the osb cache from v2 and preserve iput-before-unlock ordering.
> 
> Changes in v2:
> - Preserve the existing iput-before-unlock order and cache the mount context
>   in the lock resource's existing l_priv field instead.
> - Recover the containing dentry lock with container_of() and remove the
>   inode-dependent mount-context lookup.
> - Correct the comment describing the dentry lock's inode reference.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0012-v5-a0413a339b72c02fc885@gmail.com
> Link to v2: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0012-v6-17b58652a3505eeecb0c@gmail.com
> Link to v3: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0012-v8-d01e30cb3f465e294c0a@gmail.com
> 
>  fs/ocfs2/dcache.h  |  5 ++---
>  fs/ocfs2/dlmglue.c | 16 ++++------------
>  2 files changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
> index 7f246c5692d8..046ab9a80769 100644
> --- a/fs/ocfs2/dcache.h
> +++ b/fs/ocfs2/dcache.h
> @@ -17,9 +17,8 @@ struct ocfs2_dentry_lock {
>  	u64			dl_parent_blkno;
>  
>  	/*
> -	 * The ocfs2_dentry_lock keeps an inode reference until
> -	 * dl_lockres has been destroyed. This is usually done in
> -	 * ->d_iput() anyway, so there should be minimal impact.
> +	 * The inode reference is dropped before dl_lockres is unlocked.
> +	 * Callbacks must not use it to find the mount context during teardown.
>  	 */
>  	struct inode		*dl_inode;
>  	struct ocfs2_lock_res	dl_lockres;
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 88d946466083..437a726834c8 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -58,7 +58,6 @@ struct ocfs2_mask_waiter {
>  #endif
>  };
>  
> -static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres);
>  static struct ocfs2_super *ocfs2_get_inode_osb(struct ocfs2_lock_res *lockres);
>  static struct ocfs2_super *ocfs2_get_file_osb(struct ocfs2_lock_res *lockres);
>  static struct ocfs2_super *ocfs2_get_qinfo_osb(struct ocfs2_lock_res *lockres);
> @@ -258,7 +257,6 @@ static const struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
>  };
>  
>  static const struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
> -	.get_osb	= ocfs2_get_dentry_osb,
>  	.post_unlock	= ocfs2_dentry_post_unlock,
>  	.downconvert_worker = ocfs2_dentry_convert_worker,
>  	.flags		= 0,
> @@ -309,7 +307,7 @@ static inline struct ocfs2_dentry_lock *ocfs2_lock_res_dl(struct ocfs2_lock_res
>  {
>  	BUG_ON(lockres->l_type != OCFS2_LOCK_TYPE_DENTRY);
>  
> -	return (struct ocfs2_dentry_lock *)lockres->l_priv;
> +	return container_of(lockres, struct ocfs2_dentry_lock, dl_lockres);
>  }
>  
>  static inline struct ocfs2_mem_dqinfo *ocfs2_lock_res_qinfo(struct ocfs2_lock_res *lockres)
> @@ -610,13 +608,6 @@ static __u64 ocfs2_get_dentry_lock_ino(struct ocfs2_lock_res *lockres)
>  	return be64_to_cpu(inode_blkno_be);
>  }
>  
> -static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres)
> -{
> -	struct ocfs2_dentry_lock *dl = lockres->l_priv;
> -
> -	return OCFS2_SB(dl->dl_inode->i_sb);
> -}
> -
>  void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
>  				u64 parent, struct inode *inode)
>  {
> @@ -624,6 +615,7 @@ void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
>  	u64 inode_blkno = OCFS2_I(inode)->ip_blkno;
>  	__be64 inode_blkno_be = cpu_to_be64(inode_blkno);
>  	struct ocfs2_lock_res *lockres = &dl->dl_lockres;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
>  	ocfs2_lock_res_init_once(lockres);
>  
> @@ -652,9 +644,9 @@ void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
>  	memcpy(&lockres->l_name[OCFS2_DENTRY_LOCK_INO_START], &inode_blkno_be,
>  	       sizeof(__be64));
>  
> -	ocfs2_lock_res_init_common(OCFS2_SB(inode->i_sb), lockres,
> +	ocfs2_lock_res_init_common(osb, lockres,
>  				   OCFS2_LOCK_TYPE_DENTRY, &ocfs2_dentry_lops,
> -				   dl);
> +				   osb);
>  }
>  
>  static void ocfs2_super_lock_res_init(struct ocfs2_lock_res *res,

