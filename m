Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B44D39184A
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 03:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791515954; cv=none; b=SLoWuWj99JbNYMjTOH6FEWyNipJWFY9HrawCt900TAh0S1bF75U4UWvUxVURqPL8TtHOUW3c3CpDeKu731VO07dEDE8aEy+DJ8Nzkb8YewfgtHRY7IGoAtckMKgUQVCXW4V0a9xW5D27qczHQ1TGejQnp4ac50Xoa+1qm8MKmXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791515954; c=relaxed/simple;
	bh=2oxsA5sL6UscgvVsOje5/5iiwfa1Jckfyitm9vY7cvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aIkMOUOnWMB3XgY+yfE9CDlIegst558p9Udbn6JX9tTO+dRJhw4MHK3cbKzuyH1Ds+70rvN1ZYwe5nlOBn085NdyVDtfSjBdx86PPYOL2CeO7xIrKB+aor9zX5N8YTBep4fHRbRnDIrA1NZSfzX0fWS1Qwgg1qurXSELbd0HILI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ul+EAWQ1; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ul+EAWQ1"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a16d39964bso1462915e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 08 Oct 2026 20:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791515944; x=1792120744; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sDFURmfhLcZd5B9RBewu4q2g5LpMwGxDtDXCFqVP5Ks=;
        b=Ul+EAWQ1/3lf7syhmDacsxBtJpuUyKlnE52Vq9AEdwSkGfZE/e+YEauLvv9eMkYTnU
         y37EtLPjPwo8djxlVh/FJCYG3Y2ZgSsVp44rXi7gRnqpoRACtVb/42LvOfI874MEGlyM
         YuP6P+/VejhjMwFUR/DzXxY6nNQNe+oTytQ3mcrMzytdvXbDWsaxG4FX6CLN6z2nP4A5
         vioxUWv+Y9JX0EM1gorzV7RyCyPSmh/Cq7MxdblJjvfMae4vTvap+xSDvsEdXkM9Dpjv
         WDrfXUohNZ5CFR9yGZZFZeZXMIWrkipNXkBvNTBW0G8XWUQpF+ameUoWp2MnXQdDpF3G
         G01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791515944; x=1792120744;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sDFURmfhLcZd5B9RBewu4q2g5LpMwGxDtDXCFqVP5Ks=;
        b=TEytlDZP9fcUOvms4bBnB6FkutDk1/0FK7nkPoGWOtNWk4A+a/weJDRFb2cl6B2BWg
         Mp98GkG48z2GicJfo8rCIjvRwMHSGGsZhm9ia3SEGxG9va2wiSKRaeWhm5kYePAUerN3
         3v+iT1aUQjgP+NcC7W7lTSYznNYe97zju79x1By0d0383GCe9a4YiyMRpOlM2ZB3EEpV
         NyAd7wW8lCnV9SFxdYmq1d6NxK9Uio4QobyXIyOLV2FexQ6JMIAqlwn6ppVlEiMiddl7
         TTA/v5ycj4FaNycC0e+MaHjiENA/PNN59P+okTbuAlp9UzcdQKP10xz7bxlDmL4lKZ5f
         jsPQ==
X-Forwarded-Encrypted: i=1; AKwUvBxLJ/pRTdagYtppCLvQAgecBlPSg8/EreEsM/2ruyyyfh50Dbm/i0VY5vt0NXNMKooBdJO0c7vOzUZT4w==@lists.linux.dev
X-Gm-Message-State: AFuF++kSeTopCkP+C8fKxdD9zSsY2OuJuOHEymQ9D2S1wWNV8EIPlV5b
	e5PNgnvcpyiaAroxwnbf7EdxpvRZnEU2RoKDA3aYlka+wjX+IpBlZ361px+365mG1zo=
X-Gm-Gg: AYBFou2VpvVtSx0ampLao/SEx2RYpHoXogPOdAE+CxKJdcnSpfSDHkN2yC1OwtySRTy
	GfGFbESUzdtEOQSJY4p1jgXVMoNd3VbtX5HOpFHsHJJFDan9rtkHdUy9nNm8r9klY2I8U7Twi0z
	xUnQOTCcVB/KBq6x9nm9t8+9PsSHRQWIXwGCqFa91ZtSoF9MfkWyHXyUUeMDY0C+kK10tgSUfda
	9ZgrxnTYKH+61D/yjonEH5vgVbCz5I6A2erNMM+sBeoJjrxpApmUAN8ag0tZOdM/nsWHIB/HrAw
	mzEX9ImQ35IVIMfNhWJoudWLUTChnMbMtQy3LcoX/bZ+7DFvN4ApQBNrkus8MfnOdSgE2PrYt+R
	UcK2yDym+CWKe5iLwq5FgHhMRH4eUfRJ9uhOr1p1JVMlW8NYgDxMeFgRTtjFC+pl3OqAlwMmFo8
	Zc9xCVOLigQ4RKXX1nZsnC6/y07moOnNJXWjiyDKqyCMzVhcX6JRJUmZtfbLmrVT6Dn4MI
X-Received: by 2002:a05:600c:1912:b0:4a0:73b:a222 with SMTP id 5b1f17b1804b1-4a18e3ee97dmr7458505e9.0.1791515944392;
        Thu, 08 Oct 2026 20:19:04 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e84219e503sm2459595ad.17.2026.10.08.20.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 20:19:03 -0700 (PDT)
Date: Fri, 9 Oct 2026 11:18:26 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Anderson Ferneda <anderson.ferneda@braza.com.br>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ocfs2: deal with legacy signed xattr name hash values
Message-ID: <ashc5y5FgsvxvX0F@p15>
References: <20261008122743.616779-1-joseph.qi@linux.alibaba.com>
 <20261008122743.616779-2-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008122743.616779-2-joseph.qi@linux.alibaba.com>

On Thu, Oct 08, 2026 at 08:27:43PM +0800, Joseph Qi wrote:
> Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") set
> -funsigned-char globally, which changed the result of the naked 'char'
> load in ocfs2_xattr_name_hash():
> 
> 	hash = (hash << OCFS2_HASH_SHIFT) ^
> 	       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
> 	       *name++;
> 
> A name byte >= 0x80 used to sign-extend and now zero-extends, so the
> hash no longer matches the xe_name_hash an older kernel stored.  An
> indexed xattr tree is searched by that hash alone, and both the bucket
> binary search and the entry scan within it stop as soon as the wanted
> hash falls below an entry's, so the entry is never reached: getxattr,
> setxattr and removexattr return -ENODATA for a name that listxattr
> still lists.
> 
> Search with the current unsigned hash and, on a miss, retry with the
> legacy signed one, as ext4 does in commit f3bbac32475b2 ("ext4: deal
> with legacy signed xattr name hash values").  New entries are always
> stored under the unsigned hash.  Skip the retry when the two hashes are
> equal, so that a miss on an ASCII name does not walk the tree twice.
> 
> A miss is not empty handed: ocfs2_xattr_bucket_find() leaves xs->bucket
> holding the bucket a new entry would go into.  So after a double miss
> drop it and search once more with the unsigned hash, otherwise a new
> entry would be placed by its legacy hash and stored under its unsigned
> one, breaking the ordering the search relies on.
> 
> Only indexed trees are affected; inline xattrs and non-indexed xattr
> blocks compare names with memcmp and never look at the hash.
> 
> Also spell out the signedness instead of leaving the current hash to
> -funsigned-char, as commit 854f0912f813 ("ext4: make xattr char
> unsignedness in hash explicit") did, so that both variants stay correct
> if this is backported to a kernel without the flag.
> 
> Exposed-by: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
> Cc: stable@vger.kernel.org # 6.2+
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

I agree with Sashiko review comment, the ocfs2_check_xattr_bucket_collision()
also requires the same fix.

Thanks,
Heming
> ---
>  fs/ocfs2/xattr.c | 93 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 82 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index a428fe908116..0834883ae971 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -601,9 +601,10 @@ static inline const char *ocfs2_xattr_prefix(int name_index)
>  	return handler ? xattr_prefix(handler) : NULL;
>  }
>  
> -static u32 ocfs2_xattr_name_hash(struct inode *inode,
> -				 const char *name,
> -				 int name_len)
> +static u32 __ocfs2_xattr_name_hash(struct inode *inode,
> +				   const char *name,
> +				   int name_len,
> +				   bool legacy_signed)
>  {
>  	/* Get hash value of uuid from super block */
>  	u32 hash = OCFS2_SB(inode->i_sb)->uuid_hash;
> @@ -612,13 +613,30 @@ static u32 ocfs2_xattr_name_hash(struct inode *inode,
>  	/* hash extended attribute name */
>  	for (i = 0; i < name_len; i++) {
>  		hash = (hash << OCFS2_HASH_SHIFT) ^
> -		       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
> -		       *name++;
> +		       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT));
> +		if (legacy_signed)
> +			hash ^= (signed char)name[i];
> +		else
> +			hash ^= (unsigned char)name[i];
>  	}
>  
>  	return hash;
>  }
>  
> +static u32 ocfs2_xattr_name_hash(struct inode *inode,
> +				 const char *name,
> +				 int name_len)
> +{
> +	return __ocfs2_xattr_name_hash(inode, name, name_len, false);
> +}
> +
> +static u32 ocfs2_xattr_name_hash_signed(struct inode *inode,
> +					const char *name,
> +					int name_len)
> +{
> +	return __ocfs2_xattr_name_hash(inode, name, name_len, true);
> +}
> +
>  static int ocfs2_xattr_entry_real_size(int name_len, size_t value_len)
>  {
>  	return namevalue_size(name_len, value_len) +
> @@ -4304,11 +4322,12 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
>  	return ret;
>  }
>  
> -static int ocfs2_xattr_index_block_find(struct inode *inode,
> -					struct buffer_head *root_bh,
> -					int name_index,
> -					const char *name,
> -					struct ocfs2_xattr_search *xs)
> +static int __ocfs2_xattr_index_block_find(struct inode *inode,
> +					  struct buffer_head *root_bh,
> +					  int name_index,
> +					  const char *name,
> +					  u32 name_hash,
> +					  struct ocfs2_xattr_search *xs)
>  {
>  	int ret;
>  	struct ocfs2_xattr_block *xb =
> @@ -4317,7 +4336,6 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
>  	struct ocfs2_extent_list *el = &xb_root->xt_list;
>  	u64 p_blkno = 0;
>  	u32 first_hash, num_clusters = 0;
> -	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
>  
>  	if (le16_to_cpu(el->l_next_free_rec) == 0)
>  		return -ENODATA;
> @@ -4348,6 +4366,59 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
>  	return ret;
>  }
>  
> +static int ocfs2_xattr_index_block_find(struct inode *inode,
> +					struct buffer_head *root_bh,
> +					int name_index,
> +					const char *name,
> +					struct ocfs2_xattr_search *xs)
> +{
> +	u32 name_hash, legacy_hash;
> +	int name_len = strlen(name);
> +	int ret;
> +
> +	name_hash = ocfs2_xattr_name_hash(inode, name, name_len);
> +
> +	ret = __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
> +					     name_hash, xs);
> +	if (ret != -ENODATA)
> +		return ret;
> +
> +	/*
> +	 * Nothing under the current hash.  The entry may have been stored by
> +	 * an older kernel, which sign-extended the name bytes when hashing.
> +	 * Skip the retry when the two hashes are equal, so that a name made
> +	 * only of ASCII does not have to walk the tree twice.
> +	 */
> +	legacy_hash = ocfs2_xattr_name_hash_signed(inode, name, name_len);
> +	if (legacy_hash == name_hash)
> +		return ret;
> +
> +	/*
> +	 * A miss still leaves xs->bucket holding the bucket a new entry would
> +	 * be inserted into, so drop it before searching again.
> +	 */
> +	ocfs2_xattr_bucket_relse(xs->bucket);
> +
> +	ret = __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
> +					     legacy_hash, xs);
> +	if (!ret) {
> +		pr_warn_once("ocfs2: xattr tree with signed name hash\n");
> +		return ret;
> +	}
> +	if (ret != -ENODATA)
> +		return ret;
> +
> +	/*
> +	 * Not under either hash.  Restore the unsigned placement, since that
> +	 * is where a new entry is stored: leaving the bucket where the legacy
> +	 * hash put it would break the ordering the search relies on.
> +	 */
> +	ocfs2_xattr_bucket_relse(xs->bucket);
> +
> +	return __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
> +					      name_hash, xs);
> +}
> +
>  static int ocfs2_iterate_xattr_buckets(struct inode *inode,
>  				       u64 blkno,
>  				       u32 clusters,
> -- 
> 2.39.3
> 
