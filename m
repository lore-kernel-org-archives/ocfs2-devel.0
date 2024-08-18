Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8BC8C13
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Aug 2024 11:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723980997; cv=none; b=Q4U/u+opSO7B5ejOqehORG2JMCYW+LGwZ9T8QLq0AoN+BzqZJMem8lrUCdj9tBBtQjngf90Q5VJ9ghAgaDYYRp3ehgmn/9XmfIUXtx4xdoPgCcTr6R+JoJ5I69TXc5ZeAxzWEu4s813wRp1c7WaDeCNDnkn9qCBMwl2GMXP5po0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723980997; c=relaxed/simple;
	bh=emaXNsgdl5NHORKtBOppdVEU2slprfD8AHSZqpBCNw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cUxrCMY2IuSMr2lx4hE1DUCh1py2uzlefwPu9/BqqR0i+Y0OtbRPTr5qK4wYpsMH1iWOap7s4ODEO/sVfdgX9gUKJ4PAXb+RAqU4oUp9FLx6PofIISOYrbzX/Htt7ewKFUZX2MABoeylFjLb7vfbSdwN59ClRk2nJ1WHiQHjOXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SFYNyczx; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SFYNyczx"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-37196229343so1359957f8f.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Aug 2024 04:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723980993; x=1724585793; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PAJdMQKZiX+9jCnggas981zW+KUWWZZDTKHFUqV7VHM=;
        b=SFYNyczx+0WiFdn6E1nV03hHNQRiB+caZ0fpSNr1jPH01yMxptk6+9vpcdENBFGIkK
         bzUUu0t3KYxk+Jqn9gyShzjPu1KF9tKcfvGgIGS7p4kVZHZVvV2Y97Ah4oEIkYlATaEY
         ivyTFygtcuUDze58C4b7v1H8UOS/giN7Y3u/mhPVyetrjEjiJird6YBenbRyflVs2vrR
         a2qwmlIj7peI8ApkQRsr6ICm2kC4zWHEHggAmTtUuAsU6S3/ZRaulHaTr8u6NAWN7IMD
         iBtcNIpuMZ14awzst8l7vIPVIgNlQyUJaVdSJ65egvh8Wc3EoLQrsKkDyFzj5uYhoTQj
         DfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723980993; x=1724585793;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PAJdMQKZiX+9jCnggas981zW+KUWWZZDTKHFUqV7VHM=;
        b=iLrBI75QoPWufk5oj71XXjpfhMl+ACWswiOB6DHBjXwGCHc8sLBEuk1rK3PMmg1g0+
         tn5g7N91b4EFvc8cVx94mj2wITK/JB3AvcMG4OOOyGTSw4FX30qSTYFE54FwmXrU1E/s
         90nFAALXenJPGX3M52bCoZWppD0ylSb3JHIovY/45QXr8kXtaixxb+dswhMJ5zcRwkUH
         ovSfakS9SSMPr6htOKD/grDUiE57bsE7lpODWjOJKFjNy/y4DZfJk7ybOXe6Z+qNv5Pt
         mHV10rTuAhL5vIaN/Az12zcmcwv6AG4tSwUE1k3jn8y2R5hTb3vgW8AGTf/0Rr+xjvZ8
         ShHw==
X-Forwarded-Encrypted: i=1; AJvYcCWhkjqlL30RjgtUffJyGrld/rurG1jhNNiPV8+Q4B4nHCxdKxX9u8uftHhe9FLn77sb4qfz8jZfS2CVrOge2YwyKU3KPlN9d/BE4Bg=
X-Gm-Message-State: AOJu0Yw/xsUUMBBL7MyjIpEW2bkUcFikDOhUt/FDK6E0aAxrs9iLf78e
	lC7P5xh2inHrJktB/HD3chO8cqMyArSo7/PPFsdmv5QSQMxs/U8ObyHK8uG3K9Q=
X-Google-Smtp-Source: AGHT+IFzBHXv9/w0iRDS4AcSUkJDBHxQa194bTyJD7dRAKg6cwL4kmUfwhABd6WEcQOinr9c2dZgRw==
X-Received: by 2002:a5d:6908:0:b0:371:83ac:fec1 with SMTP id ffacd0b85a97d-37194314afemr4592193f8f.1.1723980992674;
        Sun, 18 Aug 2024 04:36:32 -0700 (PDT)
Received: from [127.0.0.1] ([192.177.92.77])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f039e258sm49307155ad.245.2024.08.18.04.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Aug 2024 04:36:32 -0700 (PDT)
Message-ID: <a4b3ab50-02af-42f2-b937-dcbb92b4f0d2@suse.com>
Date: Sun, 18 Aug 2024 19:36:18 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Remove custom swap functions in favor of built-in
 sort swap
Content-Language: en-US
To: Kuan-Wei Chiu <visitorckw@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: jserv@ccns.ncku.edu.tw, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240810195316.186504-1-visitorckw@gmail.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240810195316.186504-1-visitorckw@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/11/24 03:53, Kuan-Wei Chiu wrote:
> The custom swap functions used in ocfs2 do not perform any special
> operations and can be replaced with the built-in swap function of sort.
> This change not only reduces code size but also improves efficiency,
> especially in scenarios where CONFIG_RETPOLINE is enabled, as it makes
> indirect function calls more expensive.
> 
> By using the built-in swap, we avoid these costly indirect function
> calls, leading to better performance.
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Looks good to me
Signed-off-by: Heming Zhao <heming.zhao@suse.com>

> ---
> Note: Build test only.
> 
>   fs/ocfs2/dir.c          | 12 +-----------
>   fs/ocfs2/refcounttree.c | 13 +++----------
>   fs/ocfs2/xattr.c        | 15 +++------------
>   3 files changed, 7 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index f0beb173dbba..fa5d0819a997 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -3511,16 +3511,6 @@ static int dx_leaf_sort_cmp(const void *a, const void *b)
>   	return 0;
>   }
>   
> -static void dx_leaf_sort_swap(void *a, void *b, int size)
> -{
> -	struct ocfs2_dx_entry *entry1 = a;
> -	struct ocfs2_dx_entry *entry2 = b;
> -
> -	BUG_ON(size != sizeof(*entry1));
> -
> -	swap(*entry1, *entry2);
> -}
> -
>   static int ocfs2_dx_leaf_same_major(struct ocfs2_dx_leaf *dx_leaf)
>   {
>   	struct ocfs2_dx_entry_list *dl_list = &dx_leaf->dl_list;
> @@ -3781,7 +3771,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
>   	 */
>   	sort(dx_leaf->dl_list.de_entries, num_used,
>   	     sizeof(struct ocfs2_dx_entry), dx_leaf_sort_cmp,
> -	     dx_leaf_sort_swap);
> +	     NULL);
>   
>   	ocfs2_journal_dirty(handle, dx_leaf_bh);
>   
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 1f303b1adf1a..4f85508538fc 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -1392,13 +1392,6 @@ static int cmp_refcount_rec_by_cpos(const void *a, const void *b)
>   	return 0;
>   }
>   
> -static void swap_refcount_rec(void *a, void *b, int size)
> -{
> -	struct ocfs2_refcount_rec *l = a, *r = b;
> -
> -	swap(*l, *r);
> -}
> -
>   /*
>    * The refcount cpos are ordered by their 64bit cpos,
>    * But we will use the low 32 bit to be the e_cpos in the b-tree.
> @@ -1474,7 +1467,7 @@ static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
>   	 */
>   	sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
>   	     sizeof(struct ocfs2_refcount_rec),
> -	     cmp_refcount_rec_by_low_cpos, swap_refcount_rec);
> +	     cmp_refcount_rec_by_low_cpos, NULL);
>   
>   	ret = ocfs2_find_refcount_split_pos(rl, &cpos, &split_index);
>   	if (ret) {
> @@ -1499,11 +1492,11 @@ static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
>   
>   	sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
>   	     sizeof(struct ocfs2_refcount_rec),
> -	     cmp_refcount_rec_by_cpos, swap_refcount_rec);
> +	     cmp_refcount_rec_by_cpos, NULL);
>   
>   	sort(&new_rl->rl_recs, le16_to_cpu(new_rl->rl_used),
>   	     sizeof(struct ocfs2_refcount_rec),
> -	     cmp_refcount_rec_by_cpos, swap_refcount_rec);
> +	     cmp_refcount_rec_by_cpos, NULL);
>   
>   	*split_cpos = cpos;
>   	return 0;
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 35c0cc2a51af..0e58a5ce539e 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -4167,15 +4167,6 @@ static int cmp_xe(const void *a, const void *b)
>   	return 0;
>   }
>   
> -static void swap_xe(void *a, void *b, int size)
> -{
> -	struct ocfs2_xattr_entry *l = a, *r = b, tmp;
> -
> -	tmp = *l;
> -	memcpy(l, r, sizeof(struct ocfs2_xattr_entry));
> -	memcpy(r, &tmp, sizeof(struct ocfs2_xattr_entry));
> -}
> -
>   /*
>    * When the ocfs2_xattr_block is filled up, new bucket will be created
>    * and all the xattr entries will be moved to the new bucket.
> @@ -4241,7 +4232,7 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
>   	trace_ocfs2_cp_xattr_block_to_bucket_end(offset, size, off_change);
>   
>   	sort(target + offset, count, sizeof(struct ocfs2_xattr_entry),
> -	     cmp_xe, swap_xe);
> +	     cmp_xe, NULL);
>   }
>   
>   /*
> @@ -4436,7 +4427,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
>   	 */
>   	sort(entries, le16_to_cpu(xh->xh_count),
>   	     sizeof(struct ocfs2_xattr_entry),
> -	     cmp_xe_offset, swap_xe);
> +	     cmp_xe_offset, NULL);
>   
>   	/* Move all name/values to the end of the bucket. */
>   	xe = xh->xh_entries;
> @@ -4478,7 +4469,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
>   	/* sort the entries by their name_hash. */
>   	sort(entries, le16_to_cpu(xh->xh_count),
>   	     sizeof(struct ocfs2_xattr_entry),
> -	     cmp_xe, swap_xe);
> +	     cmp_xe, NULL);
>   
>   	buf = bucket_buf;
>   	for (i = 0; i < bucket->bu_blocks; i++, buf += blocksize)

