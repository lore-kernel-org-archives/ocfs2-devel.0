Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701EC57882
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711616526; cv=none; b=l+svh1anjHLKfG4kfcJQV/jXimX/dgQlCDl/MsaBcs98Fb06Gh6g2KFiu/mSRKEoDJ0h0iig2Zn6JIaPTNWfVPEmvJPiRUVzax5BcvHT1LTz67bYzmJ/m+WmfIAXRNG9VKXDofqakgN6A+jrmQ44yIrkht65cht9WvnF4QqxlRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711616526; c=relaxed/simple;
	bh=MRu4F28vzB7WmhdL0sfY/6WNs+7Tjpbay+WpvtTqx9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EwRf7MQgSXpMOiGWxCsJEVupGA017HqoNCtbfHkoaTN65iyu+8B7/IMlfEXvUjRkUyKfIya2G0aWaS8r45bVz0JEggjSRUPLdRTg64GT9lv8EswQLfsD+vxHOCQxuBY+McwiWmApMt4LZuv40jBKuSKfu+YAePgalFkSuVrJZbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EXa9eVQ+; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EXa9eVQ+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711616517; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=W6XFgJ4xqOxhnXP5ngj8mbvS0kBwrrMJ3BSqyjt/Soo=;
	b=EXa9eVQ+CYA88kvNg0UnM7lAHL7SjuuDsxV7gG3hj89MG+/UwkveK18xKLBh8Jw1lUx1Wzn4L/Aii/HNupEUmO3IpRRbY/bugERMO8NcEJQWIfJvX1YGdSvnZCJ6d+1pcQXkwx8b+B3vD1X1CoBIa+zeJVplJ5U3gAb5cXIzv6Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W3SvjTL_1711616516;
Received: from 30.221.129.70(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3SvjTL_1711616516)
          by smtp.aliyun-inc.com;
          Thu, 28 Mar 2024 17:01:57 +0800
Message-ID: <b1982b17-0674-4080-8ed4-de2c0107c7f3@linux.alibaba.com>
Date: Thu, 28 Mar 2024 17:01:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/4] ocfs2: fix sparse warnings
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240328082943.20251-1-heming.zhao@suse.com>
 <20240328082943.20251-5-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240328082943.20251-5-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/28/24 4:29 PM, Heming Zhao wrote:
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
> 6.
> fs/ocfs2/dlm/dlmrecovery.c:2950:9: warning: context imbalance in 'dlm_finalize_reco_handler' - different lock contexts for basic block
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
> v5: (first version)
> - localalloc.c fix (No: 1) is split from v4 patch 3/3.
> - new sparse warnings fixes (No: 2~6) for other files.
> 
> ---
>  fs/ocfs2/dlm/dlmdomain.c   | 11 +++++------
>  fs/ocfs2/dlm/dlmrecovery.c |  4 ++++
>  fs/ocfs2/export.c          | 12 ++++++------
>  fs/ocfs2/inode.c           |  2 ++
>  fs/ocfs2/localalloc.c      |  4 ++--
>  fs/ocfs2/refcounttree.c    |  2 +-
>  6 files changed, 20 insertions(+), 15 deletions(-)
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
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 50da8af988c1..40a0e5df3de0 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -2917,8 +2917,11 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,
>  		BUG();
>  	}
>  
> +	spin_unlock(&dlm->spinlock);
> +

I'm not sure unlock first and then lock is a right way.
I'd rather leave it as of now.

Joseph

>  	switch (stage) {
>  		case 1:
> +			spin_lock(&dlm->spinlock);
>  			dlm_finish_local_lockres_recovery(dlm, fr->dead_node, fr->node_idx);
>  			if (dlm->reco.state & DLM_RECO_STATE_FINALIZE) {
>  				mlog(ML_ERROR, "%s: received finalize1 from "
> @@ -2932,6 +2935,7 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,
>  			spin_unlock(&dlm->spinlock);
>  			break;
>  		case 2:
> +			spin_lock(&dlm->spinlock);
>  			if (!(dlm->reco.state & DLM_RECO_STATE_FINALIZE)) {
>  				mlog(ML_ERROR, "%s: received finalize2 from "
>  				     "new master %u for dead node %u, but "
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
