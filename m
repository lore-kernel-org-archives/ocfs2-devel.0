Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A48E48C403
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 15:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791558560; cv=none; b=A8GyIribWf2yA70WmrgQ6TtV8ntdeMOeAKVPDhYUSsqGI+brarJbgjV7OPsImDWXd4EMwDEBwEr6+fuAK1haK9SNBG/8PHA5X5vO+FS+iJsb6+evQOww8i0EiJWUa4B5PyrIlhHKf/eqN9BORIN3hilivUylPPiwPpx5WT8ahdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791558560; c=relaxed/simple;
	bh=5622vFjjrUQ8N4J/FirkFRj5hIIji0qwNLtjg3ohHK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFkLs13k7vs4FSmsW5K16Z8/4M5VBtAeJ9XORz1NnU+eT5VacuFLe4NcBIlGfCCJmbWD0LySSz3rk5rsN8/fgo14vcz1yKXzgG9zPHHM+j8ZOrMZxyFSYZ3qKvH0LNBEDK2X7q/ke2KO29TPhTE35kvo+453RPp1pX+oREAbD24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AmNgMPQE; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AmNgMPQE"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49e6b771d06so6895695e9.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 09 Oct 2026 08:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791558557; x=1792163357; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l7FAggyg1PuXiF2goI0uppUUtryZ3eugWEM0zzhFv98=;
        b=AmNgMPQEnq6m83Y9jz4Y1j3ydzHaqSH5r3ZKKPekz5vBfqieR9kK7uZCzhNaD68GBG
         4QXRAxq51WQi9Zn/PYLNXeFnVU0xptHbMFkEbiwXK0YHrKfmfVn40t+UVZlSHl4aGPTd
         TO8ozNesU8spbOvsx65bzaBEtwDdCTlxw1p7zDQjNl8aBVPhbj3mZlFbSRO2+5MNzozN
         rrHptKDvUhrfEPYykGcJKGKfS9rknqQgVC0KG07E6a98ozpubsPF4R5zuHO0VFsDjuA9
         CwmQL0MU0fZUMNfLSkNW2CvfgQdlrJSLU5rwIYBiKxPb/5A79pGHWOhqwSAC6qKviAIp
         3zOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791558557; x=1792163357;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l7FAggyg1PuXiF2goI0uppUUtryZ3eugWEM0zzhFv98=;
        b=r9/C5uEph1NMXxIkJv+0/S5UwlwREuIa69TC3MJ5Czfa0VDtHbbEWxJVG2B2YNrWTe
         PlwJMxsgbW6z8fXvAq55fikF5cIWjQtmlQq72RIfG+oUA9R0NQTkhFp38W07Crc8n95f
         LIDHcCN6X5JWEgb2XRkTjEo2HQGPcrRvBs8+uJ+qWPYQz6axCETLk2f6GCA6yi7V0yjR
         VEJMkV4MMD9Yh74RM4RvVd5N6GfKnvrxJk9X/UP+HtCQxqCcRpzlcrBmhX0etJ+E8L5E
         fyBH13YPBe+U1PUpFN4Rt8Y2houLCbQpa7M19zZSSv+uibQiOIE9gQPuOs7Bu83RGZGI
         dWUQ==
X-Forwarded-Encrypted: i=1; AKwUvBx2/tn5nv0AS95p3DioiGNInx8vn7eOvTc9ky5w6EsAPG9/xLG13xLfk6psXYiYJi41W2h1F4XSf2bD5A==@lists.linux.dev
X-Gm-Message-State: AFuF++lFz7Po0CWwxdSiHLcq7YuO48RbLFpckJF7a2D2Aok7JHBYOuwn
	oLkAKjxLxVhH1kogw3cMwDwS+ddSO1pgBckojMeNmRTz7y7uO38LITP1u3n5EwcC/5yllZy6RdZ
	UFu1z6qc=
X-Gm-Gg: AYBFou3g8TqdpDk78kzqhina3DRSgM4hNGjTEX3qI1R5kixcz+IpCo7zsKIBqHahG75
	7hbBqCMoDKtp2AZtys234TSJblCeDGXSP3RxBv9Rhjk2HpI68ibtO9XFohMGTf2ygBtyvnV+H4p
	w+1EvdGLPYO51eNAclvfpB3SAzerFYzG5KgHC/HnAYGckEtb51uuFeXLKC27uwnUjbLjYte28id
	YYkPMgqujx8sq80IzpE+oJSjUheS2ljmTMX8eXBLEpqks6fSR46w8/Nv6UjRe/F9f0aUsn1c++n
	XW+/jie6KIoIOsA5pGVO/YIoW5OzSbgdfWeuLMQtBPpaBwxOJhv2w/7NtrpoJSRUh70U/wBBiz2
	nPU6u824hv1lJnzuuPdB40PwhmuY8kOM8ngX+4JNn2e1Oauc2LLsElxYd3O+3aslNBnQhhFBx8t
	fyDCHVIW3lP4DgkWSXivOw4HHXGUvVTYYO0xFz7RfUJp+7RZOJRWyi79ew8eXIFkwHsuEJbw==
X-Received: by 2002:a05:600c:1e0f:b0:4a1:8469:e6c8 with SMTP id 5b1f17b1804b1-4a18e46f48fmr42865885e9.1.1791558556633;
        Fri, 09 Oct 2026 08:09:16 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ff0d34sm4261482a91.14.2026.10.09.08.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 08:09:15 -0700 (PDT)
Date: Fri, 9 Oct 2026 23:08:07 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Anderson Ferneda <anderson.ferneda@braza.com.br>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ocfs2: use the stored hash when checking xattr
 bucket collision
Message-ID: <askDOj3-b_20RTu-@p15>
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
