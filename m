Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792739350;
	b=xhIajHQDbKFumo7NCEbRTh1AXCC3A+dR1xnd7c9KbAnM54MBnH5bLTvyzHGg8Oizt1gW
	 6/c+1VSBD8+1PZ5dPZ88LZEvrcgSHX/s8jP9x/ACj9rXySgD9gjlP14mCPs3dmaQyTeXJ
	 o3gfl5zgFgqOgDc6lTVl8x7YnnRLs7ZMPa4oqvQJsPoTq6n7EMkhP0pjT4Omug2Ols0FZ
	 xCgczSbqclyxyiO7zHjqC9sUWdzCv+tfyvx/gR2gBc82d7+AH+2kcJUtqfd4FCs5Zx2xL
	 PaZuJugXDd27YXfXWtHPA7rr0u5g6QIvglL0QVptuztqiWjldKlG+e0FNV8Xd2QqI+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792739350;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=gvgYpLS83V3S26ukRbON8rhR0vUKj9WSZRuvm289hrM=;
	b=JXRwlXZN06lAZzQv0U6zkkSBI8qRvPnzlPxW/Cj4Ip/oMI+zTLN+3nQzXEtEzWtJtaF6
	 8lunc0uV3M23TcCqZfDmmcd1i0TX871aaSXhp+QNvwxRQCrWgsmXjeRvJ1B1IGwe08iN4
	 5oXdHPn3UTu2cOx6f7arFiVKXbWIPZnURShgNuAK89lLh+wp2zIqrFSgr3F125KZJxCvT
	 xAiTtK6R8rNxoCXvFpjNPDZ6riA3fpr2Zwrsex/gvgF9qOYma1acnsuWltfgZRQ5koWwQ
	 G9csmmUp3Nr/z0xRtV2eEChF2AmHFdhVims1kJipuJtK+V4ZuG336IMib/A/8D3vZ3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="VAq/gleA";
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC5D606A31B
	for <ocfs2-devel@lists.linux.dev>; Fri, 23 Oct 2026 07:09:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BC5D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VAq/gleA
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792739346; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gvgYpLS83V3S26ukRbON8rhR0vUKj9WSZRuvm289hrM=;
	b=VAq/gleAXlFvw26OHvkGtHN6dfxl5D+kcqgYFB/YEbwm64bXIkSWxS02iLKR53AyTPIeVGhw3scxbKWzTjosa/EpzybJg0kfSHCKSRJrPQxrJr2auI0bqxlp+487WT8ynpvCikhGyMCeuTttdzcP+aEn+0OYYOvoMysdFSwr3po=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDLMPQI_1792739344;
Received: from 30.221.129.69(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDLMPQI_1792739344 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 15:09:05 +0800
Message-ID: <31b48648-c157-49f1-94d5-d1b927bae1c9@linux.alibaba.com>
Date: Fri, 23 Oct 2026 15:09:04 +0800
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
To: Cen Zhang <zzzccc427@gmail.com>
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

Don't see any difference between your v2 sent before.
BTW, it seems v3 is also missing.

Thanks,
Joseph

