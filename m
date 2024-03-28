Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C0D59B72
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 08:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711616288; cv=none; b=AAVi6jJ10VdB9QLAnb2WkjisfcnQLoSL2iBgTaEVGqsC8DV6UvjXrM7KPO34hXMcrxaKZhmJiv+4S7p4FhtDdaHS4ZbrwCuqVjQMt2TYOnAxyfy0IOII5UU5CP5L3FiCD5sj7K/Mao60tMEA2TXdlE0OYYj1gQPL98371laRux4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711616288; c=relaxed/simple;
	bh=bT662cIus60FZ9p8Zg/n6aFF6/KThhqi32eCWbf2dNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mL0fnmVxMODsOHN2NGcvwOj9rAzIWWoFmRZGySUfL3ofpQoPzYZJsLOaF4sJ0oZAm7jMxymzMSkKsu86noRsQ2IBdGj7el/eC4Vg69dnfatBvlR88GfNYGLZvphPFzB2nesMop8hFAXHg0PZLNBKjzNojLUonQlXQ6+gaNGwQ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XcJlJVZk; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XcJlJVZk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711616283; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=koJ1shY86HFqxT40yRDCoHJQHZbPrM4pPrrwYjQl9hQ=;
	b=XcJlJVZkQDTBUQchMAezVJvc/Q5A94fmw3l/EwJ146+5wK6eOznOhaENQeMMMLOOfa8pRHrVnIm78f1BZQS+E2D6y782sJS1ZvcuWjfvTOKVc9iLe1BeaOTTb8uPwzjoRKD0Ee401YJnV2Vkv4cXGc+T0z+MyWMjDU8qcfDkn44=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W3SiETM_1711616264;
Received: from 30.221.129.70(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3SiETM_1711616264)
          by smtp.aliyun-inc.com;
          Thu, 28 Mar 2024 16:58:02 +0800
Message-ID: <7c7f0eb0-de4e-4eb7-9fa4-b1c3a05f51be@linux.alibaba.com>
Date: Thu, 28 Mar 2024 16:58:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] ocfs2: adjust enabling place for la window
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240328082943.20251-1-heming.zhao@suse.com>
 <20240328082943.20251-3-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240328082943.20251-3-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/28/24 4:29 PM, Heming Zhao wrote:
> After introducing gd->bg_contig_free_bits, the code path
> 'ocfs2_cluster_group_search() => ocfs2_local_alloc_seen_free_bits()'
> becomes death when all the gd->bg_contig_free_bits are set to the
> correct value. This patch relocates ocfs2_local_alloc_seen_free_bits()
> to a more appropriate location. (The new place being
> ocfs2_block_group_set_bits().)
> 
> In ocfs2_local_alloc_seen_free_bits(), the scope of the spin-lock has
> been adjusted to reduce meaningless lock races. e.g: when userspace
> creates & deletes 1 cluster_size files in parallel, acquiring the
> spin-lock in ocfs2_local_alloc_seen_free_bits() is totally pointless and
> impedes IO performance.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v5:
> put 'osb->local_alloc_state = OCFS2_LA_ENABLED' into the if block
> 
> v4: first verion
> ---
>  fs/ocfs2/localalloc.c | 11 ++++++-----
>  fs/ocfs2/suballoc.c   |  9 ++-------
>  2 files changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index c803c10dd97e..b893ef56accd 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -212,14 +212,15 @@ static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
>  void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
>  				      unsigned int num_clusters)
>  {
> -	spin_lock(&osb->osb_lock);
> -	if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
> -	    osb->local_alloc_state == OCFS2_LA_THROTTLED)
> -		if (num_clusters >= osb->local_alloc_default_bits) {
> +	if (num_clusters >= osb->local_alloc_default_bits) {
> +		spin_lock(&osb->osb_lock);
> +		if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
> +		    osb->local_alloc_state == OCFS2_LA_THROTTLED) {
>  			cancel_delayed_work(&osb->la_enable_wq);
>  			osb->local_alloc_state = OCFS2_LA_ENABLED;
>  		}
> -	spin_unlock(&osb->osb_lock);
> +		spin_unlock(&osb->osb_lock);
> +	}
>  }
>  
>  void ocfs2_la_enable_worker(struct work_struct *work)
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 1a7b53fd468d..fc80cb3dbcd1 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1374,6 +1374,7 @@ int ocfs2_block_group_set_bits(handle_t *handle,
>  	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
>  	unsigned int start = bit_off + num_bits;
>  	u16 contig_bits;
> +	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
>  
>  	/* All callers get the descriptor via
>  	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
> @@ -1423,6 +1424,7 @@ int ocfs2_block_group_set_bits(handle_t *handle,
>  		if (contig_bits > max_contig_bits)
>  			max_contig_bits = contig_bits;
>  		bg->bg_contig_free_bits = cpu_to_le16(max_contig_bits);
> +		ocfs2_local_alloc_seen_free_bits(osb, max_contig_bits);
>  	} else {
>  		bg->bg_contig_free_bits = 0;
>  	}
> @@ -1589,13 +1591,6 @@ static int ocfs2_cluster_group_search(struct inode *inode,
>  		 * of bits. */
>  		if (min_bits <= res->sr_bits)
>  			search = 0; /* success */
> -		else if (res->sr_bits) {
> -			/*
> -			 * Don't show bits which we'll be returning
> -			 * for allocation to the local alloc bitmap.
> -			 */
> -			ocfs2_local_alloc_seen_free_bits(osb, res->sr_bits);
> -		}
>  	}
>  
>  	return search;
