Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDDEE56A
	for <ocfs2-devel@lists.linux.dev>; Fri, 29 Mar 2024 01:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711674059; cv=none; b=PphIIGgCWretlyPHdwLSGzzeM7cqJj2RhTjUdzegLTYm4A7SK1333pun6FMcbflH4ozjfDeNeLqY8M//1DyWHf0PCzeOLvRXLkh7yHNu5if41965A+sbNT3ltwpKN9r+I+yqfp2QyhqrVKQnaoOp4a6/cBgpOkBjOxJ+OSjbm/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711674059; c=relaxed/simple;
	bh=vO768F2YgwwMR9aaEYQlwHkR738JuS7+8D0+pZvmAaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NzWmRdezT2MWlaolhR/1Yq3f9jab9jXyPFVlXcuWjbsHW0cWg2RK2ZDG/0Um53BFrpSRHGyGIdNY0Gu5+YwaR/yebw9RiU+ZPyhuWoPMmsoTUuZAdHbz3R6lhW8k1IPUVCeZzR5B9DIfdmD7Tp67vfdb+kT9/hhd5mrmBVfyIuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=i37eeLVB; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="i37eeLVB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711674053; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AE0tfw2XuGGJWTAVlcqdczRS+tGe5OICti9H9MJ53Ls=;
	b=i37eeLVBb7mU49sZAfvnfJSGBeA4Zuxhj1/ZTg43z66CRs21m/kAbaH77SX+gNDBB58W+ZFZB6tsVYuWHJUDvo9ngeejlMMkxQ0K27rwRiht2KVapwzXN/QQK75s1oF8jlIbVosjw+2E+5d9RcwEOPyYdefK6AzNURhIBnKtEx8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W3Uitrz_1711674051;
Received: from 30.221.128.172(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3Uitrz_1711674051)
          by smtp.aliyun-inc.com;
          Fri, 29 Mar 2024 09:00:51 +0800
Message-ID: <34e2aef8-9f44-4c57-b218-bed1c3d4f84c@linux.alibaba.com>
Date: Fri, 29 Mar 2024 09:00:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/4] ocfs2: fix sparse warnings
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240328125203.20892-1-heming.zhao@suse.com>
 <20240328125203.20892-5-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240328125203.20892-5-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/28/24 8:52 PM, Heming Zhao wrote:
> 1.
> fs/ocfs2/localalloc.c:1224:41: warning: incorrect type in argument 1 (different base types)
> fs/ocfs2/localalloc.c:1224:41:    expected unsigned long long val1
> fs/ocfs2/localalloc.c:1224:41:    got restricted __le32 [usertype] la_bm_off
> 
> 2.
> fs/ocfs2/export.c:258:32: warning: cast to restricted __le32
> fs/ocfs2/export.c:259:33: warning: cast to restricted __le32
> fs/ocfs2/export.c:260:32: warning: cast to restricted __le32
> fs/ocfs2/export.c:272:32: warning: cast to restricted __le32
> fs/ocfs2/export.c:273:33: warning: cast to restricted __le32
> fs/ocfs2/export.c:274:32: warning: cast to restricted __le32
> 
> 3.
> fs/ocfs2/inode.c:1623:13: warning: context imbalance in 'ocfs2_inode_cache_lock' - wrong count at exit
> fs/ocfs2/inode.c:1630:13: warning: context imbalance in 'ocfs2_inode_cache_unlock' - unexpected unlock
> 
> 4.
> fs/ocfs2/refcounttree.c:633:27: warning: incorrect type in assignment (different base types)
> fs/ocfs2/refcounttree.c:633:27:    expected restricted __le32 [usertype] rf_generation
> fs/ocfs2/refcounttree.c:633:27:    got unsigned int
> 
> 5.
> fs/ocfs2/dlm/dlmdomain.c:1316:20: warning: context imbalance in 'dlm_query_nodeinfo_handler' - different lock contexts for basic block
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v6:
> - restore the original code in dlm/dlmrecovery.c
> 
> v5: (first version)
> - localalloc.c fix (No: 1) is split from v4 patch 3/3.
> - new sparse warnings fixes (No: 2~6) for other files.
> 
> ---
>  fs/ocfs2/dlm/dlmdomain.c | 11 +++++------
>  fs/ocfs2/export.c        | 12 ++++++------
>  fs/ocfs2/inode.c         |  2 ++
>  fs/ocfs2/localalloc.c    |  4 ++--
>  fs/ocfs2/refcounttree.c  |  2 +-
>  5 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 5c04dde99981..2e0a2f338282 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -1274,7 +1274,7 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
>  {
>  	struct dlm_query_nodeinfo *qn;
>  	struct dlm_ctxt *dlm = NULL;
> -	int locked = 0, status = -EINVAL;
> +	int status = -EINVAL;
>  
>  	qn = (struct dlm_query_nodeinfo *) msg->buf;
>  
> @@ -1290,12 +1290,11 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
>  	}
>  
>  	spin_lock(&dlm->spinlock);
> -	locked = 1;
>  	if (dlm->joining_node != qn->qn_nodenum) {
>  		mlog(ML_ERROR, "Node %d queried nodes on domain %s but "
>  		     "joining node is %d\n", qn->qn_nodenum, qn->qn_domain,
>  		     dlm->joining_node);
> -		goto bail;
> +		goto unlock;
>  	}
>  
>  	/* Support for node query was added in 1.1 */
> @@ -1305,14 +1304,14 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
>  		     "but active dlm protocol is %d.%d\n", qn->qn_nodenum,
>  		     qn->qn_domain, dlm->dlm_locking_proto.pv_major,
>  		     dlm->dlm_locking_proto.pv_minor);
> -		goto bail;
> +		goto unlock;
>  	}
>  
>  	status = dlm_match_nodes(dlm, qn);
>  
> +unlock:
> +	spin_unlock(&dlm->spinlock);
>  bail:
> -	if (locked)
> -		spin_unlock(&dlm->spinlock);
>  	spin_unlock(&dlm_domain_lock);
>  
>  	return status;
> diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
> index b8b6a191b5cb..96b684763b39 100644
> --- a/fs/ocfs2/export.c
> +++ b/fs/ocfs2/export.c
> @@ -255,9 +255,9 @@ static struct dentry *ocfs2_fh_to_dentry(struct super_block *sb,
>  	if (fh_len < 3 || fh_type > 2)
>  		return NULL;
>  
> -	handle.ih_blkno = (u64)le32_to_cpu(fid->raw[0]) << 32;
> -	handle.ih_blkno |= (u64)le32_to_cpu(fid->raw[1]);
> -	handle.ih_generation = le32_to_cpu(fid->raw[2]);
> +	handle.ih_blkno = (u64)le32_to_cpu((__force __le32)fid->raw[0]) << 32;
> +	handle.ih_blkno |= (u64)le32_to_cpu((__force __le32)fid->raw[1]);
> +	handle.ih_generation = le32_to_cpu((__force __le32)fid->raw[2]);
>  	return ocfs2_get_dentry(sb, &handle);
>  }
>  
> @@ -269,9 +269,9 @@ static struct dentry *ocfs2_fh_to_parent(struct super_block *sb,
>  	if (fh_type != 2 || fh_len < 6)
>  		return NULL;
>  
> -	parent.ih_blkno = (u64)le32_to_cpu(fid->raw[3]) << 32;
> -	parent.ih_blkno |= (u64)le32_to_cpu(fid->raw[4]);
> -	parent.ih_generation = le32_to_cpu(fid->raw[5]);
> +	parent.ih_blkno = (u64)le32_to_cpu((__force __le32)fid->raw[3]) << 32;
> +	parent.ih_blkno |= (u64)le32_to_cpu((__force __le32)fid->raw[4]);
> +	parent.ih_generation = le32_to_cpu((__force __le32)fid->raw[5]);
>  	return ocfs2_get_dentry(sb, &parent);
>  }
>  
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 999111bfc271..2cc5c99fe941 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1621,6 +1621,7 @@ static struct super_block *ocfs2_inode_cache_get_super(struct ocfs2_caching_info
>  }
>  
>  static void ocfs2_inode_cache_lock(struct ocfs2_caching_info *ci)
> +__acquires(&oi->ip_lock)
>  {
>  	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
>  
> @@ -1628,6 +1629,7 @@ static void ocfs2_inode_cache_lock(struct ocfs2_caching_info *ci)
>  }
>  
>  static void ocfs2_inode_cache_unlock(struct ocfs2_caching_info *ci)
> +__releases(&oi->ip_lock)
>  {
>  	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
>  
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index b893ef56accd..86cdd60bcaab 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -336,7 +336,7 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>  		     "found = %u, set = %u, taken = %u, off = %u\n",
>  		     num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
>  		     le32_to_cpu(alloc->id1.bitmap1.i_total),
> -		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
> +		     le32_to_cpu(OCFS2_LOCAL_ALLOC(alloc)->la_bm_off));
>  
>  		status = -EINVAL;
>  		goto bail;
> @@ -1221,7 +1221,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
>  			     OCFS2_LOCAL_ALLOC(alloc)->la_bitmap);
>  
>  	trace_ocfs2_local_alloc_new_window_result(
> -		OCFS2_LOCAL_ALLOC(alloc)->la_bm_off,
> +		le32_to_cpu(OCFS2_LOCAL_ALLOC(alloc)->la_bm_off),
>  		le32_to_cpu(alloc->id1.bitmap1.i_total));
>  
>  bail:
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 3f80a56d0d60..1f303b1adf1a 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -630,7 +630,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
>  	rb->rf_records.rl_count =
>  			cpu_to_le16(ocfs2_refcount_recs_per_rb(osb->sb));
>  	spin_lock(&osb->osb_lock);
> -	rb->rf_generation = osb->s_next_generation++;
> +	rb->rf_generation = cpu_to_le32(osb->s_next_generation++);
>  	spin_unlock(&osb->osb_lock);
>  
>  	ocfs2_journal_dirty(handle, new_bh);
