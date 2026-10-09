Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22484E36F9
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791558484; cv=none; b=CAxLKqAwp8LI/CilzSLdE/Vs8IrHCH6l47YRvE1WtPT/4hg9rJTnPe9eCWVxc9OeChClJa4OGKjjGLsuUymuh7SSX7XE0tM0+opO486R98cJMdSuBGwlieqlgt4erGNDqeMNUr2BcayNKvGzC6BiHn7x+HM+K3NSxpILFL8nmdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791558484; c=relaxed/simple;
	bh=5622vFjjrUQ8N4J/FirkFRj5hIIji0qwNLtjg3ohHK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJc1zUjFGt8ZZQC3YOCWYfubLqhretOiqNs39Eb15lgwLcp6Vohl8s/ewZxzgNu7mxh2pppHtMe8yhAefHi9bhp7MqOTpCQGNg30x3N90NRhr9F95TjCIQpnFj798Xm/5DoLgXIZJdtZ5l4aUo7VlTr8li1CqNdnEVLVH79271I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JT9vV5vo; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JT9vV5vo"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49e71fc84bbso2139205e9.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 09 Oct 2026 08:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791558481; x=1792163281; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l7FAggyg1PuXiF2goI0uppUUtryZ3eugWEM0zzhFv98=;
        b=JT9vV5voDR6ZImgYlMFcmCrzsLlpKyk75grduvDpNI1ec5l1iH6q5cp9CHxu5lZrNZ
         Waks+CicHl0CcYQE6gpsPVFvWOzs3qAEZDhHgQzysl7XBE+INHr+M1ClszXbNvry1GB1
         B24ADoH0Ra1rbXssDsaqNZjap4/rc3Wt/12icWy6+9SnKhBOR0f5oBb815SW7SidHHTV
         ECoWQHTChZM9j3j+hkQPcyr2IBe9A27+fHkvoYfZYifPhPDB/JwDZ/R50onAXQDQgzbs
         J4eYj9PNegVX0cURWx4LehjU92sP8WnGVlJeGQjNuCjtkRudJ2R7LS4OZJPmX2b7R3UP
         Dblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791558481; x=1792163281;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l7FAggyg1PuXiF2goI0uppUUtryZ3eugWEM0zzhFv98=;
        b=2N0raQi4jLlQuOrPq72xaO8rM6VYVOPolVv2E9LG/3iRd09XsH20KqDju1+0okK5t7
         ZKru6DOwYPiybanrK9wHTvzROofeAEKP/FO+xdox2PP96I/RWRoOUmy/H9U0CvicXGCF
         vpfIJyK2hbdATdHr9NgghTV8CZZDZNaQ7ZGyfhOWgqu3fZ0ABG0DS+esJBA+GaY9RE3k
         VxMuVrCPtKI/2GxHUixSUl4AyQmFUEBNYDSJ3eQeyq9WWieieGiwUJbI4Vj82XFp1vZf
         ZjabOn1WEHFMFk1F/Gm7iW6tJuU3IDof//iYNQ1oeTTkN7WZsG5ivv1TfC4A7i6UEhrZ
         BwEA==
X-Forwarded-Encrypted: i=1; AKwUvByusSg0bXkZqh/XN3A0qe8jyibVl0uyxTjbgCt3lK1bms46JREdm6aoi9LBTSnd/tB75599bdzyp+xT+g==@lists.linux.dev
X-Gm-Message-State: AFuF++nlGmbQduAeyUrOAFDS2HS1Qf0gTVaXE0tsxGIBr6ZqUyI19imh
	XZgcO9pgZCYp3f6EGii+JlDlVJT/lLQwYVcm66GDpXtMkaNbaxsYSV8kbsIUPYgBbr46lyFgCoZ
	eNKXiqaw=
X-Gm-Gg: AYBFou2ox7OY6WLB8u4db5kMpgaaIOLsCX57RkL0XjKupsKTUGzMldQKKIla3bBTuvb
	s40M1xHDrr1m+wBh6X2R1T6Isuxx+KFLX4u/zXGZzn13FcjbHEgWbI5JYXhT/gt4f21451xEQQq
	L9NLavkKkLDUWLyFZO2tB9P1sfQDKftNzGvB6WQv8o07FaKYC8fIE6IQ4vnlim3ZbpdCuEObvf+
	4W3kGHMCxNdgl1VVgk/q9fqVvbR4ninZMRBS2hkiecNgFKGDnPDuzodGMS00KiKiyBZyO4Yv3Hy
	6nAgLigWEXW+8U/G88tM8d34V8StL3og2i0q+LVScbdqfnXkXmtjrgMSeE/KdXaBfw+LLfyqBpa
	Wo1LCz4OEBi43Xw+RjGzQlaUcwDbd4p07K+FPfF8VeU/9Jh7ALAW9uAg2iVhLvTmQJDtWZ06YI0
	HGqNxJkbVCHwGX3I9ihTUXlcAYI0NuDlz3YEH/WaqYWQFMAo2ffwEO7Ew8tNUBnCYj8zlp
X-Received: by 2002:a05:600c:1912:b0:4a0:1e9f:64f6 with SMTP id 5b1f17b1804b1-4a18e3ef211mr38754775e9.0.1791558480773;
        Fri, 09 Oct 2026 08:08:00 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36ed0daesm3998972a91.5.2026.10.09.08.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 08:07:59 -0700 (PDT)
Date: Fri, 9 Oct 2026 23:05:51 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Anderson Ferneda <anderson.ferneda@braza.com.br>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ocfs2: use the stored hash when checking xattr
 bucket collision
Message-ID: <askCqE-GKFv8tK1q@p15>
References: <20261009083002.2621201-1-joseph.qi@linux.alibaba.com>
 <20261009083002.2621201-3-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009083002.2621201-3-joseph.qi@linux.alibaba.com>

On Fri, Oct 09, 2026 at 04:30:01PM +0800, Joseph Qi wrote:
> ocfs2_check_xattr_bucket_collision() decides whether splitting a full
> bucket can make room for the entry being set by recomputing the hash of
> the name:
> 
> 	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
> 
> 	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
> 		return 0;
> 
> For a new entry that is the hash it will be stored under, so comparing it
> is correct.  An existing entry keeps the hash it already has: an update
> never rewrites xe_name_hash, since ocfs2_xa_add_entry() is the only
> writer of that field for a real entry and ocfs2_xa_prepare_entry() calls
> it only when loc->xl_entry is NULL.
> 
> An entry stored by a kernel that sign-extended the name bytes when
> hashing can still be updated, because ocfs2_xattr_find_entry() searches
> a non-indexed xattr block by memcmp on the name and never looks at
> xe_name_hash.  Growing it past the space left in the block converts the
> block into a tree, ocfs2_cp_xattr_block_to_bucket() fills the bucket in
> stored hash order, and the update runs out of room in the bucket too.
> The collision check then compares the unsigned hash against the legacy
> hashes in the bucket and reports no collision.
> 
> ocfs2_xattr_set_entry_index_block() goes on to allocate a bucket that
> ocfs2_divide_xattr_bucket() cannot fill: a bucket whose entries all share
> one hash has no divide position, so all it does is append an empty bucket
> with a sentinel hash one above the last entry's.
> 
> The re-search that follows depends on where the unsigned hash sorts.
> Below the legacy ones, it comes back to the full bucket and the set fails
> with -ENOSPC, having grown the tree for nothing.  Above them, it lands on
> the new empty bucket, which ocfs2_xattr_bucket_find() handles explicitly
> and ocfs2_find_xe_in_bucket() scans zero times, so the set stores a second
> copy of the entry under the unsigned hash and returns success.  The
> original stays in the full bucket, listxattr reports the name twice and
> getxattr returns the new copy.
> 
> Pass the hash the entry is stored under instead: the stored one for an
> existing entry, the unsigned one for a new entry.  A tree whose entries
> are all stored under the unsigned hash sees no change, since there the
> two are the same value.
> 
> Exposed-by: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
> Cc: <stable@vger.kernel.org> # 6.2+
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/xattr.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index a428fe908116..c5a39a7d43d0 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -5896,16 +5896,14 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
>  
>  /*
>   * check whether the xattr bucket is filled up with the same hash value.
> - * If we want to insert the xattr with the same hash, return -ENOSPC.
> - * If we want to insert a xattr with different hash value, go ahead
> - * and ocfs2_divide_xattr_bucket will handle this.
> + * If the entry being set carries that same hash, return -ENOSPC, since
> + * ocfs2_divide_xattr_bucket() has no divide position to work with.
> + * Otherwise go ahead and ocfs2_divide_xattr_bucket() will handle this.
>   */
> -static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
> -					      struct ocfs2_xattr_bucket *bucket,
> -					      const char *name)
> +static int ocfs2_check_xattr_bucket_collision(struct ocfs2_xattr_bucket *bucket,
> +					      u32 name_hash)
>  {
>  	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
> -	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
>  
>  	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
>  		return 0;
> @@ -5974,6 +5972,7 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
>  					     struct ocfs2_xattr_search *xs,
>  					     struct ocfs2_xattr_set_ctxt *ctxt)
>  {
> +	u32 name_hash;
>  	int ret;
>  
>  	trace_ocfs2_xattr_set_entry_index_block(xi->xi_name);
> @@ -5993,10 +5992,18 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
>  	 * the maximum number of collisions we will allow for then is
>  	 * one bucket's worth, so check it here whether we need to
>  	 * add a new bucket for the insert.
> +	 *
> +	 * An existing entry keeps the hash it was stored under, and that is
> +	 * the hash a split has to work with.  A new entry is stored under the
> +	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
>  	 */
> -	ret = ocfs2_check_xattr_bucket_collision(inode,
> -						 xs->bucket,
> -						 xi->xi_name);
> +	if (xs->not_found)
> +		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
> +						  xi->xi_name_len);
> +	else
> +		name_hash = le32_to_cpu(xs->here->xe_name_hash);
> +
> +	ret = ocfs2_check_xattr_bucket_collision(xs->bucket, name_hash);
>  	if (ret) {
>  		mlog_errno(ret);
>  		goto out;
> -- 
> 2.39.3
> 
