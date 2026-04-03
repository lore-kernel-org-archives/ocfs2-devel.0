Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CC037B3FD
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 08:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775205038; cv=none; b=nO+/NfKC4l5+sh/kmQgzxL4bj28mH+zIz1H9XwcHCKdXk4nENuZbwzEsJk/w7ZW+Pr1cBUrPyLyJlj+lXA6Q49d9Del/RbpOwFchbBMB5YTDEznDWd/RNqS5qc4SnDWWYUhNKqBNJN0qWEAcUeeth0zom+YBjhBct8Ldndm7AMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775205038; c=relaxed/simple;
	bh=ma9XTJsfZPHt0gNoK3vH+yy2VquzTMPuT+kMc3c+VUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W9bZi6SvDlhQcHVnsARclL9oQThjwwtzF1/n3g6iD5yssXDiTRjmFGUaE7OmedwxVrHfZe9RAqzuZnPdSFLt5Lw2vgWFdeE8ZjjLF5HMNfOFusTSwUHxBtYTfEAKs8YJb5++HT5DeXZOH0NzN9S5yn8Xb8qLm5IEYzxIxweZlcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Br+b1LnZ; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Br+b1LnZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775205027; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aoPnAvlZpMnpgmxGDTQA0EuL49OXgfeHx45koTrB37s=;
	b=Br+b1LnZ1HnxoRXbUmO3JSEx+KG+e5dsidd4Z/OUXrHCpzaWalb5KEW2ePOLF4bcb1MXviQ6sXJOoF+c6Du43DUrhX9XxAotMTFTMHZ8MIcT3vZIGqrSu60uvCgSfuf5tZyjgsuawoH3Ln7It9oWGZuX+WT1uqw6yAX63+4F43M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X0JhJDA_1775205026;
Received: from 30.221.145.18(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0JhJDA_1775205026 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 16:30:27 +0800
Message-ID: <8ce97736-83ab-4d48-81f1-90c70d87f44b@linux.alibaba.com>
Date: Fri, 3 Apr 2026 16:30:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate dx extent list bounds during lookup
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260401013914.3543304-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260401013914.3543304-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This makes ocfs2_dx_dir_lookup_rec() messy.
And I think the right place to do this check is ocfs2_validate_dx_root()
and ocfs2_validate_extent_block() during read from disk.
I'll rework it and send out later.

Thanks,
Joseph

On 4/1/26 9:39 AM, ZhengYuan Huang wrote:
> [BUG]
> A corrupted indexed directory can trigger a KASAN use-after-free in
> ocfs2_dx_dir_lookup_rec() when the dx root or leaf extent list carries
> an out-of-range l_count or l_next_free_rec value.
> 
> BUG: KASAN: use-after-free in ocfs2_dx_dir_lookup_rec+0x6f7/0x880 fs/ocfs2/dir.c:813
> Read of size 4 at addr ffff888043b7b0e0 by task syz.0.3467/8031
> 
> Call Trace:
>  <TASK>
>  ...
>  ocfs2_dx_dir_lookup_rec+0x6f7/0x880 fs/ocfs2/dir.c:813
>  ocfs2_dx_dir_lookup+0x100/0x5d0 fs/ocfs2/dir.c:868
>  ocfs2_dx_dir_search+0x7bc/0x11c0 fs/ocfs2/dir.c:928
>  ocfs2_find_entry_dx fs/ocfs2/dir.c:1042 [inline]
>  ocfs2_find_entry+0x97e/0xce0 fs/ocfs2/dir.c:1079
>  ocfs2_find_files_on_disk+0xa9/0x2f0 fs/ocfs2/dir.c:2002
>  ocfs2_lookup_ino_from_name+0xae/0x110 fs/ocfs2/dir.c:2024
>  ocfs2_lookup+0x45e/0x860 fs/ocfs2/namei.c:122
>  lookup_open.isra.0+0x4a2/0x1460 fs/namei.c:3774
>  open_last_lookups fs/namei.c:3895 [inline]
>  path_openat+0x11fe/0x2ce0 fs/namei.c:4131
>  do_filp_open+0x1f6/0x430 fs/namei.c:4161
>  do_sys_openat2+0x117/0x1c0 fs/open.c:1437
>  do_sys_open fs/open.c:1452 [inline]
>  __do_sys_openat fs/open.c:1468 [inline]
>  __se_sys_openat fs/open.c:1463 [inline]
>  __x64_sys_openat+0x15b/0x220 fs/open.c:1463
>  ...
> 
> [CAUSE]
> ocfs2_dx_dir_lookup_rec() only checked for an empty extent list before
> iterating over the directory index records. It did not verify that the
> root dx list fits within a dx root block, or that the leaf list fits
> within an extent block.
> 
> Comparing l_next_free_rec only against the on-disk l_count is also not
> enough because l_count itself can be corrupted.
> 
> [FIX]
> Validate both the dx root list and the leaf extent list against their
> physical record capacities before indexing into l_recs[]. Use
> ocfs2_extent_recs_per_dx_root() for the root and
> ocfs2_extent_recs_per_eb() for the leaf block so the bounds check does
> not trust on-disk sizing fields.
> 
> Fixes: 9b7895efac90 ("ocfs2: Add a name indexed b-tree to directory inodes")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/ocfs2/dir.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index b82fe4431eb1..3403c0d3810e 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -790,15 +790,25 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  	struct buffer_head *eb_bh = NULL;
>  	struct ocfs2_extent_block *eb;
>  	struct ocfs2_extent_rec *rec = NULL;
> +	unsigned int max_recs;
>  
> -	if (le16_to_cpu(el->l_count) !=
> -	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
> +	max_recs = ocfs2_extent_recs_per_dx_root(inode->i_sb);
> +	if (le16_to_cpu(el->l_count) != max_recs) {
>  		ret = ocfs2_error(inode->i_sb,
>  				  "Inode %llu has invalid extent list length %u\n",
>  				  inode->i_ino, le16_to_cpu(el->l_count));
>  		goto out;
>  	}
>  
> +	if (le16_to_cpu(el->l_next_free_rec) > max_recs) {
> +		ret = ocfs2_error(inode->i_sb,
> +				  "Inode %llu has invalid dx root next free %u, max %u\n",
> +				  inode->i_ino,
> +				  le16_to_cpu(el->l_next_free_rec),
> +				  max_recs);
> +		goto out;
> +	}
> +
>  	if (el->l_tree_depth) {
>  		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
>  				      &eb_bh);
> @@ -817,6 +827,27 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  					  (unsigned long long)eb_bh->b_blocknr);
>  			goto out;
>  		}
> +
> +		max_recs = ocfs2_extent_recs_per_eb(inode->i_sb);
> +		if (le16_to_cpu(el->l_count) != max_recs) {
> +			ret = ocfs2_error(inode->i_sb,
> +					  "Inode %llu has invalid tree block %llu list count %u, max %u\n",
> +					  inode->i_ino,
> +					  (unsigned long long)eb_bh->b_blocknr,
> +					  le16_to_cpu(el->l_count),
> +					  max_recs);
> +			goto out;
> +		}
> +
> +		if (le16_to_cpu(el->l_next_free_rec) > max_recs) {
> +			ret = ocfs2_error(inode->i_sb,
> +					  "Inode %llu has invalid tree block %llu next free %u, max %u\n",
> +					  inode->i_ino,
> +					  (unsigned long long)eb_bh->b_blocknr,
> +					  le16_to_cpu(el->l_next_free_rec),
> +					  max_recs);
> +			goto out;
> +		}
>  	}
>  
>  	if (le16_to_cpu(el->l_next_free_rec) == 0) {

