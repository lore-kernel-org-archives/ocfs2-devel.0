Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC56E47ECEE
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Oct 2026 14:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791988537; cv=none; b=Vx0g1Bsb2sjce8xJq3ikiOAEiMQ8bk5kHQWxo1D7YVGHFZc20wyTGaBYYFFScwi6VqzA+YqEZHlycnjw/0ON6SAPFr8jDWl78EndAHm+Jy0UlUZfm4wsPJhNCr9kqksCX7qBzSEBsDjtv+THDG++5quEr+OhatAayrlq4guY1fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791988537; c=relaxed/simple;
	bh=iEb6Wyf8v6HCQ2gtxiwtWl90BNNFvcDXJo2VBnw7bOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHi6I6ox8En1ix75Brspc+IKNFloCVQkHw11W0lp/D7e3cp/UhvzbDzEEZM4GxUQ8OadVCmuQr7WMIpPWAGBqbz7LEfNQUyXo3Y1gGD8itc2GzV8TlOERFO/O1Gue5Fi84S6fd0kv9ydTv8uOs8wh6R3E5l8bsym4H42FoIFH+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LaeiOQXz; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LaeiOQXz"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1810f8855so2569615e9.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 14 Oct 2026 07:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791988534; x=1792593334; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DbezI2uGy3QvoWseZWOGIcO/b3+YK9kmK9c/cECVLuE=;
        b=LaeiOQXzdHcGiviiSi3VVqsvJWB1zGPHGuvOaXqt/hNLb6W62OrSKNItV87yLmBC2r
         pNzl3mqos1vMuRBZ96qAw4r/qjTnBsEpHRC4kBjsHga8TUM8h+9r8/L31EQpga+2XWny
         3cjoT+f/cCccADlqy1cTe09hBb7q7qSTMMw2lPx2Gej3r63pUCJTygEtlr/vY3i3Q4qz
         I2LAqmizG2/Zxgng+iUgaqX9MeY0nsfPkHqNJYaBYRjo6p6LKS9j2D41gcuHMNkXaKw7
         WXulJCI47/9FsZqwjCWRltEzb32sgZA+v3EsrkFYaNve39IziRsfLbq3wWcHK6z8ZwmI
         YbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791988534; x=1792593334;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DbezI2uGy3QvoWseZWOGIcO/b3+YK9kmK9c/cECVLuE=;
        b=04BZT6du6ItBvr534dJBuDXFh8iMGCREeMWqUqM3N5VThCbwjaszpRZ97e6Pbw6wpB
         Fxpb15ckM1X8mx0z3sJ0GJyoK9Ak9G3YvbZvJ+AbcK1m1GFqYRG7C4J0Ep6VgAJ3kShs
         gJ2TGmxJq0zbxMclvwWj+UOPxXiltpvr0cTOH1F2X+bFBhLfoX08Oi4mBf/WCR0SFg4Y
         Iv6CNLQN+R7MQFNuDeQTCVWLO08qDc888A53OxrSlpxyveD16CMyDChzqpjxxJAPJhom
         RO3UYDdTqWlSdehhCysXzq0/bEiYa3jWES39mBEQvbBM+3MvIh2f9eJqo96d+4SQQWek
         ijvg==
X-Forwarded-Encrypted: i=1; AKwUvBynnHz8Qwy+3xA7ofY5cR3pifFYfUMFB8UPAArTf2t67XW6rYjFI7tKbSf2YpbvgGWBaLu1AmjZl/+EdA==@lists.linux.dev
X-Gm-Message-State: AFq9FYK4i8en0o3qHG2Oyrj6oNb7RXUZ6bz5ZJl9r8RLexB4AJSUUDYf
	7bIxP6JV8BqHeZJkgwammhm8QrsXpfU211qyZXfzvLCERiefrU4mLmEXh0VEHbycu6U=
X-Gm-Gg: AYBFou3cZ3QuhvB58sYBiT7WQfLe43KyIfpepPJpRDTUsv/x3m5KdT4BohJMQ8Rw5sc
	HT0yR2F8tAv89aFTg576QwJnrYtG8f1hmQGDvIfor6WYB08JXgmr9ZnrfsWgVI3rpLzH75fW20b
	pyPjBn1vVFOmHWTtLzT6HfunS0NdLTZTcUTEeJHUTqNpQ0OHkM17cn870gRk9C4E1ERbT83FMCU
	nuETeS6z+YEzzNE9NY1plckK1aVe7x5oQ50Filnd4CVLHn54IPn7HEOJ4kGt6fNwaCi4zcBs18F
	Jklji+swH3EadkMpIn+yzTEFF6XtrfivMQ26ZFzIL0raH1Ktwt+NgoA0cwKcqumvYwHziLsbapM
	+M2QVvGUxP6ncupiciXU64o32PKkZxmw+LrmWW/3ZwX6Sbeis6E/GAVabO5t3aF6AydOxLEFL9B
	+GXytwE2amy5Rxl5wEreYnkcAHNL3TknZD2MyJauiSsr8aMWaO4Rap9QmXqLK9f+AS1UtE
X-Received: by 2002:a05:600c:4ecc:b0:4a1:7dcf:be1f with SMTP id 5b1f17b1804b1-4a18e476022mr342666045e9.1.1791988533816;
        Wed, 14 Oct 2026 07:35:33 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e84219e525sm71732095ad.16.2026.10.14.07.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 07:35:32 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:35:29 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: validate the xattr tree root of an indexed xattr
 block
Message-ID: <as-SUraepqsded7n@p15>
References: <20261014105856.2909777-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014105856.2909777-1-joseph.qi@linux.alibaba.com>

On Wed, Oct 14, 2026 at 06:58:56PM +0800, Joseph Qi wrote:
> ocfs2_validate_xattr_block() checks an xattr block's signature, blkno,
> generation and suballocator fields, and for a non-indexed block the entry
> array it carries.  An indexed block is passed straight through, so the
> extent list in its xattr tree root is never looked at.
> 
> Both fields that describe the list are bounded.  The two places that
> create a root set l_count from ocfs2_xattr_recs_per_xb() and nothing
> rewrites it, and the insert path asserts in ocfs2_rotate_leaf() that
> l_next_free_rec stays within l_count.  Check both when the block is
> first read, so a root that disagrees with the block size, or claims more
> records than it has room for, is caught before anything indexes into
> l_recs[].
> 
> An empty root is deliberately not rejected.  Emptying the tree leaves it
> that way: ocfs2_rm_xattr_cluster() removes one extent per transaction,
> and the last one ends in ocfs2_truncate_rec(), whose closing
> ocfs2_rotate_tree_left() reaches ocfs2_remove_empty_extent() on the
> depth-zero root and takes l_next_free_rec to zero.  That transaction
> commits before ocfs2_xattr_free_block() frees the block, and before
> ocfs2_xattr_remove() clears i_xattr_loc, in two later transactions, so a
> crash in between leaves an orphan inode pointing at an xattr block whose
> root has no extents.  Both readers already cope with it:
> __ocfs2_xattr_index_block_find() answers -ENODATA, and
> ocfs2_iterate_xattr_index_block() returns without iterating.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/xattr.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 18d920b30602..b2bd06083a14 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -491,6 +491,7 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
>  				      struct buffer_head *bh)
>  {
>  	int rc;
> +	struct ocfs2_extent_list *el;
>  	struct ocfs2_xattr_block *xb =
>  		(struct ocfs2_xattr_block *)bh->b_data;
>  
> @@ -573,6 +574,30 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
>  							 region_offset);
>  	}
>  
> +	/*
> +	 * An indexed xattr block carries the root of the xattr tree.  Its
> +	 * record count is fixed by the block size and l_next_free_rec never
> +	 * exceeds it.  A zero l_next_free_rec is valid: emptying the tree on
> +	 * the inode deletion path leaves the root with no extents.
> +	 */
> +	el = &xb->xb_attrs.xb_root.xt_list;
> +
> +	if (le16_to_cpu(el->l_count) != ocfs2_xattr_recs_per_xb(sb)) {
> +		return ocfs2_error(sb,
> +				   "Xattr tree root #%llu has invalid l_count %u (expected %u)\n",
> +				   (unsigned long long)bh->b_blocknr,
> +				   le16_to_cpu(el->l_count),
> +				   ocfs2_xattr_recs_per_xb(sb));
> +	}
> +
> +	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
> +		return ocfs2_error(sb,
> +				   "Xattr tree root #%llu has l_next_free_rec %u past the end of its list (l_count %u)\n",
> +				   (unsigned long long)bh->b_blocknr,
> +				   le16_to_cpu(el->l_next_free_rec),
> +				   le16_to_cpu(el->l_count));
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.39.3
> 
