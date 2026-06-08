Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63313ACEE2
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Jun 2026 09:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780910862; cv=none; b=SazE8wRYoisYARGHhfHK9fWHgKADxd6uXnC26bMMSPVKeZjs//TgqRlvu+tOz0LqmRQ6EGxfYsq7QqQX+QV3hszduG+5OPHrIX6YcjK6jwWh8X7L7mQZeHiPG8/CVzFrcZvK/p40N2iGpl3Dky156NglrSNMnZGugcmf+l4mWMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780910862; c=relaxed/simple;
	bh=YbuaucBFlyVpiPEizwTgM8J3SETDH/DxmgJWihs/xuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=V+qBkdF5kSE+HKaUUA79Ybl0GZv7O++W4dUWYMTZN9YJr066DahIO5gJalIlCK/rr1eZKMlXyjRuRcWFaHAbT2MZHBXAIRsaTMASnPHvXLvr+gwcPvq6qBPxekai5Np5rZwQGISusJDjpOxjUpfkN6dzP9n3GpvBp94VOfkIbds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=e3WZQF0L; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="e3WZQF0L"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780910851; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CI33oDIcOHMyCjWzO6mFvuBkNKd4/lauWCfYu2v0UBU=;
	b=e3WZQF0LBLzVmTNMOrCSE9ajiNZ0ICw/WuPolM8FYD9F4sOr/nTy2ueVjYXVL/nw6iXaK4MG4J2PCJakqrtN+PeD2nAv7bmdMCnzs4aMwv+OiitOCvREcJiRcHevsIKCu7rtfDOsojti+EDg0fvE9NvPHGxPRsyv4GjjW299Lls=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X4N-Xvq_1780910848;
Received: from 30.221.145.187(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X4N-Xvq_1780910848 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 17:27:28 +0800
Message-ID: <ae0343a8-2056-4f7f-8bdd-7e2b979fb8b3@linux.alibaba.com>
Date: Mon, 8 Jun 2026 17:27:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix UBSAN array-index-out-of-bounds in
 ocfs2_sum_rightmost_rec
To: Ian Bridges <icb@fastmail.org>
References: <aiLNd9gAuCC5u2jf@dev>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <aiLNd9gAuCC5u2jf@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/5/26 9:21 PM, Ian Bridges wrote:
> [BUG]
> On-disk corruption setting l_next_free_rec to 0 in an inode's inline
> extent list triggers a UBSAN panic on the next write to that file.

Replace 'inline extent list' here to 'embedded extent list'.
Since 'inline' always means inline data and may cause confuse.

> 
> [CAUSE]
> ocfs2_sum_rightmost_rec() computes
> i = le16_to_cpu(el->l_next_free_rec) - 1
> and accesses el->l_recs[i] without validating i. When l_next_free_rec
> is 0, i becomes -1; when l_next_free_rec exceeds l_count, i falls
> past the end of the array. Either case violates the
> __counted_by_le(l_count) annotation on l_recs[] and triggers UBSAN.
> 
> [FIX]
> Validate the inode's inline extent list when the inode is read, in
> ocfs2_validate_inode_block(): l_count must be non-zero and no larger
> than the inode block can hold, and l_next_free_rec must not exceed
> l_count. A corrupt list is rejected at read time, before the b-tree
> code can index l_recs[] out of bounds.
> 
> Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")

IMO, commit 2f26f58df041 just expose it as UBSAN. Before it, accessing
l_recs[-1] was silent undefined behavior.
So I don't think it is the right blame commit. Since the logic was
introduced long time ago, so I'd rather just mark it as
"Cc: stable@vger.kernel.org" with no "Fixes" tag.

> Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
> Signed-off-by: Ian Bridges <icb@fastmail.org>
> ---
> Changes in v2:
>  - Reject the corrupt inode at read time by validating its inline extent
>    list (l_count, l_next_free_rec) in ocfs2_validate_inode_block().
> 
> v1: https://lore.kernel.org/all/ah2ljwKRw-Xsi4Ga@dev/
> 
>  fs/ocfs2/inode.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index a510a0eb1adc..aff95efd78e7 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1559,6 +1559,38 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if (ocfs2_dinode_has_extents(di)) {
> +		struct ocfs2_extent_list *el = &di->id2.i_list;
> +		u16 count = le16_to_cpu(el->l_count);
> +		u16 next_free = le16_to_cpu(el->l_next_free_rec);
> +
> +		if (count == 0) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode %llu: extent list l_count is zero\n",
> +					 (unsigned long long)bh->b_blocknr);
> +			goto bail;
> +		}
> +		/*
> +		 * The exact capacity depends on i_xattr_inline_size, another
> +		 * unvalidated on-disk field. Inline xattrs only shrink the
> +		 * list, so the no-xattr maximum is a safe upper bound that a
> +		 * valid l_count never exceeds.
> +		 */
> +		if (count > ocfs2_extent_recs_per_inode(sb)) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode %llu: extent list l_count %u exceeds max %u\n",
> +					 (unsigned long long)bh->b_blocknr, count,
> +					 ocfs2_extent_recs_per_inode(sb));
> +			goto bail;
> +		}
> +		if (next_free > count) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
> +					 (unsigned long long)bh->b_blocknr, next_free, count);
> +			goto bail;
> +		}
> +	}
> +
>  	rc = 0;
>  
>  bail:

