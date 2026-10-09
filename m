Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808BA472F78
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791558593; cv=none; b=sYCpwP+jK28fcDuZLTIXqIaR4eRZLqWmCCyabzDH716lz85PmrKSWcgxcgLaAXwNn3hpWpZkUyJwJz9I3+bW7Zgw2aVBuKPH7mv+YHiVfR3iFUdEjnjQEyfdDQlXztb0IjV/7yB4OYOG1DqInO1uQBEXZiKvmwq3EEtEh2WWbdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791558593; c=relaxed/simple;
	bh=qNMj5D1fNLlV/nVRkSJPYnmRg/wnN8E/sGYhjBjHrxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yh78eJFFHLJpc3JQFPm9miQSqry/T+H8myHX3YCU1/hlmA6JkfiDkPGH+EjNj7lB4wqjYX6qJKHEm2dV7cibfg8kZrTCS4xnJfK+G701OZI2BuiDSGOufZDgUN9gZ/I+DgGos+M8+RSo467qT6fnO+2FAeH4ShJBmW6qNh/B47M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RGfw/K2h; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RGfw/K2h"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2a6d40404fso41640566b.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 09 Oct 2026 08:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791558590; x=1792163390; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K+QJFCsdX0b7I85190WFfJTMBp320bxRkXas79ET8+s=;
        b=RGfw/K2hyBonDeZOZlMgNtiKCWUHAs6FVT0E2DzZ/OFaMaPb6UgctcLr3Z8EjGsPFz
         17if6Sa5AcOsItwpnmtUnaWqIdHXcZPun6IG9YM4OLWJj2PDR7PKLHcwtnhUdnefIOJE
         bTIVNq/TkU7teqlCYXRCtobEiFVE5RsJpIEjhxpWLCvkm2dHc3B4OA7l9Kxoyz/H/KDX
         PB8UjOwMbgsroWJFv4PE40Qxd92jZI+RR8oUNZcUUdGwCSbZP7uOyQ80JiSITC8Ul3G5
         Qd2nAggdvzu6VZaRucMj5IrsizlPYvYBrRRP7ZgwUl8KaGm9MGbICYzTmtML9u9igTTp
         f34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791558590; x=1792163390;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K+QJFCsdX0b7I85190WFfJTMBp320bxRkXas79ET8+s=;
        b=LXsYambQm6aHIQaAkooAYWz03JSSc6SUc6ygg5UHGxQaHAJ8mGjkAFh2NawRMVb9MD
         PmiZtVA8pAH0MmLA8sUfHdI0fmOm5NZJqsCBse7skWwz311ByxH4siE5nY2wJxWhKYrx
         DFQ2W+4fgF6DqrdF47cXNKy/Iostrf/u6wQrIXlx3YaBV+izPNB9vr1sa1UHOztZDQGq
         h8msMYQ9XEZVUgMEri86jwNXgMNcqigD6hivcSlvzN1w8fVaCqiG0IaibeYDb8otQrk3
         dM4ZimGY77yb2wMjIv18y+s2nHxBOd3/+0stVdVFZvxEnJbKKuYLDoynfJDfEiTFIMjk
         cU2A==
X-Forwarded-Encrypted: i=1; AKwUvBwx0sIvPEiSUfs4+A/1eUWpYOfFhlajqqhrJXRHQmUyy1q1uo32Gh6dCBWqy2srR4UmJ2djRGKi03cJLg==@lists.linux.dev
X-Gm-Message-State: AFq9FYJz+jBrHWXp47D6P8eu/EiVzOdMUiO5MwqRRXNNG7kNpV3LPC4V
	JLfMbjJ5CjogBD0oeKjgCQKoSS7Z0W/PYvqonfdLRqicUidhIH3aa772NpvFzsFRL9g=
X-Gm-Gg: AYBFou1Op1ZE+SQKG6e653nhlAREWGwm3Y0u1ZZrejYQj06NJmCKFYzDfQ/Mg++uIXV
	klsSHUb84Vk8A2f/pKI1UVZ02TM7te5NsgJb34sQZF0BloxSfScQNAzVMK13zr56Z+p5SeSE07H
	1yvkabDust9yQq76pp8py9IcTEF2wum3nAsgX5Qpqwyb5J9xpZZcAjtTvjORbNs7YOenW1NHn8k
	QzPqCaUxjRMb+eyIgtrUHiii0IKZ3W/BZuOyYap9W8Wdk+alma+xJ1XeYzszpsJbYWliG0iqX3F
	N+Yo05OXo4Urfeu21h3Zh3s03Nj0bQSyh3T1Zl3xlTZ+UDJSSRL7412axVC2ASnBxUbY98KdoEx
	n2opLq5CyFzCTtK4syJDu2gDyENYXPlqJck1Vj2WyhNW+CbGSyVJJUc3h4aveOytum5Y18MsKcu
	Pbp2zh1nGfcDlP83CSXDc12ITs1mE1UUPz0dBUpBngXlumo4km6NJxm7sxZ1zzCtS5Pcpv
X-Received: by 2002:a17:907:d89:b0:c2a:ad68:c6fa with SMTP id a640c23a62f3a-c31a9d1065dmr278270566b.3.1791558589628;
        Fri, 09 Oct 2026 08:09:49 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c469ea49sm1234562b3a.53.2026.10.09.08.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 08:09:48 -0700 (PDT)
Date: Fri, 9 Oct 2026 23:09:45 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Anderson Ferneda <anderson.ferneda@braza.com.br>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ocfs2: deal with legacy signed xattr name hash
 values
Message-ID: <askDoqcW-HLPLKrt@p15>
References: <20261009083002.2621201-1-joseph.qi@linux.alibaba.com>
 <20261009083002.2621201-4-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009083002.2621201-4-joseph.qi@linux.alibaba.com>

On Fri, Oct 09, 2026 at 04:30:02PM +0800, Joseph Qi wrote:
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
> Cc: <stable@vger.kernel.org> # 6.2+
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/xattr.c | 93 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 82 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index c5a39a7d43d0..e92bcf401490 100644
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
