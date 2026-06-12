Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984F62C375A
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Jun 2026 01:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781226152; cv=none; b=GCb/VNsqIqZoHZC+5cUu9ImxW2a7ufvoBwn3PcnKkzz6kUqEMUptmY3rpIU63vdX2uMJReDKUwjwvP2WyMxQJpRpIjTIZnj80ABmxJ2mDdjHxv/GDa8njQmF51bX5ssqD++pmag5Y8ccB2SL91ykrohQwTNmYrHRt6VbJ7tU/kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781226152; c=relaxed/simple;
	bh=+Dg+/4H6lPCRTI8lbBz2r+TrZQuiFYCkgMZJzJSbiGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=UF0O1POHNmWwBccUcQty1X+UdgRy9E3aGi5CNMgE9sA7jU1Uf4ZjWZ46PCfp9t4bDp3VOBdEWQG5XeLZfiJeSin26r3/GCqxG9g2fvPJFQUIKKYI0dPHHsbfG0/oUm9lKTjLm21DC9qws9d5TZqwI3u1ztUKsfQQAv3zZvF2wvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZTHo9rFR; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZTHo9rFR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781226142; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O5Q7Kd11BUZ1uj3aFJyfEkkO0CyBezvD6IcqVAJU0OI=;
	b=ZTHo9rFRA7hf2eGDGqP3PnVLGDSaw52Oiy9YWoS29+Ar8e/EIPYqOWn9Raz2i7Dm3x/DB++TmcgzLpSycltgMwG0HX0ZqD7IR4XWkakrKO1akmIbEtKiW0yt3StS7ihBwlR3F/ijklAjzSvVfWCXKkF6HM9gF5lItMXjLopkOTY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X4f9joK_1781226140;
Received: from 30.221.145.30(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X4f9joK_1781226140 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Jun 2026 09:02:20 +0800
Message-ID: <d3c3ac65-0f46-40ec-9071-92bf6ffa4fc8@linux.alibaba.com>
Date: Fri, 12 Jun 2026 09:02:18 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: fix UBSAN array-index-out-of-bounds in
 ocfs2_sum_rightmost_rec
To: Ian Bridges <icb@fastmail.org>, akpm <akpm@linux-foundation.org>
References: <ain_780qc0P4ypNd@dev>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ain_780qc0P4ypNd@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/11/26 8:23 AM, Ian Bridges wrote:
> [BUG]
> On-disk corruption setting l_next_free_rec to 0 in an inode's embedded
> extent list triggers a UBSAN panic on the next write to that file.
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
> Validate the inode's embedded extent list when the inode is read, in
> ocfs2_validate_inode_block(): l_count must be non-zero and no larger
> than the inode block can hold, and l_next_free_rec must not exceed
> l_count. A corrupt list is rejected at read time, before the b-tree
> code can index l_recs[] out of bounds.
> 
> Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changes in 4:
>  - Update commit message to use "inline" instead of "embedded"

Typo here? I think you mean 'embedded' instead of 'inline'.

>  
> v3: https://lore.kernel.org/all/aibMhhAH-swS38i0@dev/
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

