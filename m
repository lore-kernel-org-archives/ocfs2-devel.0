Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C095C208A8
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 11:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537538; cv=none; b=t+11LnrBuq24FCGKvce9M9EhC1PAc4DipNnj4dZAntKyDlYtei1f2PX4ygPvqOmlCyhwFzoYU2u/Z4MAcQSQb5Bg9XRlq5BKePZGttScRSr8BZWAA9ECm7d3iF03f62IKNdbXiOkHtGU/pOHFFAXB/DQl284z1Luob1QVdWiKPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537538; c=relaxed/simple;
	bh=mvt9gWfYrIvPipCP99ErqKWiRS2Y+O4Kt8xDjWKoWcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MsWjwJGy7NcPSB/jBNSfJjdJSixhzSfX0pW2CalGGQuxRe+QPX0K4hPpI5tU+k17gfIlGnERxjANYwvYWLP7/n3mNcX7klfL0ZU3PJY4fYJtDxhKf2kbyFHf2nDyN8OsZO/bAx5hzGWGA8+8ctVEA3v0zuNxGr/eVMMKN57JnJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YGVvbN9v; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YGVvbN9v"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711537531; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Gcf1u55CRnxus5nujl6h2diMTo5iAdk0lX1F5OQe0F4=;
	b=YGVvbN9v783s0fBw09JeNkwc3ztvCkjX8pUmAiuLw7vOn7WYAFh1l5FUZ0YN7NoPRBdCF4sjaSI3EGn5Zq0Cvjd0uiN18oOQVjJBIpJOXDdzr8aHvfVYIU8l3mLD679sqjDps0EoNN/n7MO7avZamJRs2Cm8ZAjsMXv3p52iO/0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W3OUUla_1711537530;
Received: from 30.221.128.129(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3OUUla_1711537530)
          by smtp.aliyun-inc.com;
          Wed, 27 Mar 2024 19:05:30 +0800
Message-ID: <326496c2-ab47-462d-87ca-bb98aa796dfc@linux.alibaba.com>
Date: Wed, 27 Mar 2024 19:05:29 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] ocfs2: adjust enabling place for la window
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240327082146.6258-1-heming.zhao@suse.com>
 <20240327082146.6258-3-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240327082146.6258-3-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/27/24 4:21 PM, Heming Zhao wrote:
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
> ---
>  fs/ocfs2/localalloc.c | 15 ++++++++-------
>  fs/ocfs2/suballoc.c   |  9 ++-------
>  2 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index c803c10dd97e..2391b96b8a3b 100644
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
> +		    osb->local_alloc_state == OCFS2_LA_THROTTLED)
>  			cancel_delayed_work(&osb->la_enable_wq);
> -			osb->local_alloc_state = OCFS2_LA_ENABLED;
> -		}
> -	spin_unlock(&osb->osb_lock);
> +
> +		osb->local_alloc_state = OCFS2_LA_ENABLED;
> +		spin_unlock(&osb->osb_lock);
> +	}

This makes checking osb->local_alloc_default_bits outside osb_lock.

Joseph

>  }
>  
>  void ocfs2_la_enable_worker(struct work_struct *work)
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6fd67c8da9fe..4163554b0383 100644
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
