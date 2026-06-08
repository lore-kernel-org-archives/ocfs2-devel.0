Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EBD3358DA
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Jun 2026 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780953337; cv=none; b=QbumY1jHrQ6Zw+V0OXY3hhrpIA9cBCxAJ+aRMvoQQxWbenqQ9K/wM+68nIDFN6ZH806xTNWFtlZm+xVxUXFHg2LjI8bz7GqU3zS6Qp+hjdew+VmXANA0VawGv+ZlZMDpvKBbxVcPW9hM7ZJ4AiPgbk0DSfC6uRdvge4nq7ORUf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780953337; c=relaxed/simple;
	bh=x6Mb3FawFz2KhFBo1P4mAQjxv0hbgQ2eJpawsrgcSTY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BhXUjWrd6nTNLixc1d6R9IfRNUYptITsJ5sVpjH2uOQNoSv7s4/jtqjqWz6dp9u7/K7bORLzUcL+Q/e9T6g1DL9UNetW1KdWzr8YDi98jJIU3IM31fVqoiBLltV/1iFy0+Q0I11KLnoycDq/DbV2H7agsj9tpby3OyftYct/0rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=l06Yj0T6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Vm6nNbPy; arc=none smtp.client-ip=202.12.124.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="l06Yj0T6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Vm6nNbPy"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.stl.internal (Postfix) with ESMTP id 7A4BB13002DB;
	Mon,  8 Jun 2026 17:15:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Mon, 08 Jun 2026 17:15:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1780953333; x=1780956933; bh=8BPGNj4AfU
	ZP44/EZPSKVMlh26YEvrBXQmS3pwzCgD4=; b=l06Yj0T6Le/hNW++/rd8HgjBca
	opNvF4q3EEYejaw1XLVPpPVzc+yaQJrEUMZy+Ljuyq6JkrZGcZVMeJXX4uA/3Y37
	4OjnATtJx85p2VlSLQs7u2FjU7dovUDg+nnoEt5wdD8ZwIrCoZp9ryOxJNcrgObk
	2EiwJ9GBrXCTK9t6+BT4UidpJycqS0VIiR2Iz6I8Ns1o+0iK7TU9cvKqfiizzkxh
	twq2eJe61jNFyp4G2+2jce0uGGSc/Ge2v1+qb4UvlK/7VNU82GAo12dwdLlokKvl
	vWQIWldjJAfE9DOTBGEjjqKrGSPf7YWfo2IL22D4Nb9WVD05Xpv+VCHzhotA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1780953333; x=1780956933; bh=8BPGNj4AfUZP44/EZPSKVMlh26YEvrBXQmS
	3pwzCgD4=; b=Vm6nNbPy3ufaaKvwOFfoi1Lxp0cr7+D6oMaNQSdtWu7e6iOTKP0
	wKs1RiwNSJCCzp9u+MKViach8GFA192p2h3IAn2l9/6zIAz1TUkVwOCUe9oy/yX4
	WTnvxYMLTJ21OJVQWTIKQb/fxNIvTafDBeD91qi+xpiYYShmpR+xPNb5iNvjJ3oS
	CcbmsUNawAoOgdHLqzgEpZX+s3MOW1UgiL6V88kK23rkZCn3u77peccJnaekI3oc
	we/tNsRZCQb7t76IU9FkyZYC5q54xm8YBy/UkCdL8mcYoKV2S0BprHqQrKahawYn
	o/Jb6rS6vZCuXU2H9VKdxgQgJ5B5vq493Bg==
X-ME-Sender: <xms:9DAnaiYZLH3q0FP1lDLSCHKc3MLNd9xqRwn-vsD9xj4zMnEslTFowA>
    <xme:9DAnauUyYxHiSgqdC1FTOVRzdNlWIGfgUHTv9yfNCk_z4wBKAAjnO4bTp-0rGxcMw
    eSLK5etg3tQxzbMqzalq5pM2BGvzlo5E9q-WzxFQGQ3IautHpTbZnXQ>
X-ME-Received: <xmr:9DAnaoixS15oMIDO8fPjSPCoihrPKKcRJ1KPzgvH5W4Oq_jYFxYu7vEH-QU>
X-ME-Proxy-Cause: dmFkZTGtwFja+dwjDkQRH/YCauWPXxfECR6zOtN5Yp40d4LYhuNvuhU+QPVghxu++2G4Q9
    Xhsf2HaQLwqHFhLSnmRtG/jHLz7cjbSq7W3uO/QREuYVW2CiXICy3w3ZOfdltpUZ5roVQA
    2qZ8whx4TOcYc3aGfEPIeT5Cndq3qX3u0+4gKYBpb5QdOdD6vnA5/pZjXH8YFl47aBmIcj
    qsMsjA3rF3J54RI0rnKgoGJeZjWxaLOaQEgVz7DofvCuFXFn/t1WoAKzfRa/5d7Xd9RdpV
    seWpJeVIzDKCAoKIHnwz+YSA8V9VMTlxQ68y7Xg8qZnKyu2ojs5B/b83VDkcviyXh0ULfC
    /oXYiAp7FhyHG+4fz/CU6wjpEcO+xPMjVaSqyKz2/zxfa/dg6+bP74KgB4FLXfCONgwhpP
    GiuJlPBfZQgn1EtsfZPUOuRYBfrzblmLPOnd/KOGnQWUwSqpvyyYtwXljG9OZ2PCnOf6Gy
    tlexmc8GG4Gi769Y7UW6zBjkHCp3ztbxxQ7/D8DJ1zm1nUO50oFmFYttIHD4faOh7OYDiU
    xnVb4kvdVqOMi1sr8zRCOS8sKWvPL/LL0zovLGxEZkvfbyU708ARu1K9btTnfK6uYk1cop
    75EqXQfBwEb0IMQIC+mggUQUfTpqyExzOIzmUsXaTm5mxt0boapQqhWr/okg
X-ME-Proxy: <xmx:9DAnaksIjLgfMfYkpOrfj6I8GwjQ7R3R6cl-CKlxMpXkQNXgWsQZtg>
    <xmx:9DAnap5E-loqvc1kzoGXv4bOSvGF49QBEL4CglNkY1M-wRScEYfMSA>
    <xmx:9DAnagObyr_jtr3bVCHUXnA3hy6YOBfOl1Hg6rRKU8XWRN9TNIb1tQ>
    <xmx:9DAnanuBwpcCOxbmVpjhMQuyWiWfyH3pAfzUfbF5aaB9zfPGZoD-Ew>
    <xmx:9TAnamGt0yPGY_X586gXBmNHgIJHMafmLg0pOn3o9j6s_9CDtqQsvmkX>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Jun 2026 17:15:31 -0400 (EDT)
Date: Mon, 8 Jun 2026 16:15:30 -0500
From: Ian Bridges <icb@fastmail.org>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ocfs2: fix UBSAN array-index-out-of-bounds in
 ocfs2_sum_rightmost_rec
Message-ID: <aicw8tIeGplAyxSr@dev>
References: <aibMhhAH-swS38i0@dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aibMhhAH-swS38i0@dev>

On Mon, Jun 08, 2026 at 09:07:05AM -0500, Ian Bridges wrote:
> [BUG]
> On-disk corruption setting l_next_free_rec to 0 in an inode's inline
> extent list triggers an UBSAN panic on the next write to that file.
>

I misread the recommendation on the previous patch review regarding
"inline" vs "embedded". I will release a v4 with the correct
terminology.

Ian

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
> Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
> ---
> Changes in v3:
>  - Update commit message to use "inline" instead of "embedded"
>  - CC stable@vger.kernel.org
>  
> v2: https://lore.kernel.org/all/aiLNd9gAuCC5u2jf@dev/
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
> -- 
> 2.47.3
> 
