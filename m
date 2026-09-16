Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DA74E66A7
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 13:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789566902; cv=none; b=JwYw/m3/fuSKY578ryghmpQi8R/Y5C/g9o/uyiD820k86U8KL477PrzwXbLjQ+Uu3BPJTWVBCAR8NHGBMXHaSbA6W1PhZrcLniltWd3GwYopkiMjTUBUEBAat7aZMiKYZaFNox4DQetsozpWgPJIKoGgeMwlZ7lqW5FIABtAGF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789566902; c=relaxed/simple;
	bh=X7H/+PCa7na8YAQKP6nTZfBLQN6WGcAiu+Y7lmqirPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DsSubZP7dI3+i0NZTJPDGcMU/+8letgYJoWpV6nm3e8n1GnT9d3oHyud/tTLQa6stNs18kVA7tXYgnbHVnTX3TlxwQ9YZfxi9zOY5Sy5tDhVqoIZOjIqG0Da5lYkLU2DwRl40FBZ44+HIcNrIn4mL2d9dyRSILyGzyZvWwuOe/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=S52jH/9g; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="S52jH/9g"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c25bf832368so12827366b.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 06:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789566890; x=1790171690; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iDchB+ryUkdDdWE5U+mZxjTR/yYOQrNzWlaxP9QHW2Q=;
        b=S52jH/9gU2+V1cBK9nJj8SV+4cutjZ+8qDRZ3PB5GwgSVtHyqjjt6LdYJQXJxsyRcu
         3PpLidveynA6sXSG13ufdrbKJ7HhZI1TRXJ69vxZtaqtX88GhRVXZzHWXZtnfua+d2SQ
         ucDaF0SkU1h3jmnkgj6mKEuoW7c7GnoHm4Iz2Diwf/Edontvom1NCCtD+DST3uqCOi8Y
         13em350l49XhqN5rqbIFKKOuoGzjsvC2RmJl9oCa9xEqixKaZ+actR92MF1tRJib0psx
         L+PaqykmpGXKdcd5JU0uHIKCLjvUcLGobOo4VhvuWV8xwGxCYtNyPL2ZNpYjmjO3E00K
         tHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789566890; x=1790171690;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iDchB+ryUkdDdWE5U+mZxjTR/yYOQrNzWlaxP9QHW2Q=;
        b=Ze9WfXCiLg151AdS8mV968tn7bVj4BxOvdxL87RkaAFTBg3Yq0pLNLo/mCrfuhGWY6
         2vPbK2pfv0t8oHJ5+pdBfolpRA+LNCD27JdOL+uYmePw7+NXMIkRls9r6MjnrrtOmCiO
         pPNseQfGzrtv9W0TCILFut0qBL3Nb51rTF6aTxzfkFP3FbrjSfITUHjVafruQTw3Qw5f
         MSHycw3WLHD3ryaTiFHcTgi8mPj8eUEFp3FnFWvSKRa9YQtMQ3H/lEV46pTwb/nw56IT
         kNNPrfARm2ffIb0Pp55RUtRKV+PIDjDg0FiZAxuCDgjpiGukJ3MRQTt9UTXxNiIhxCO8
         nVxw==
X-Forwarded-Encrypted: i=1; AKwUvBxuh4UDhENq9f4iWzNvrcuPXfDF7rcEqtJCva7256yyilv6yAH3G6btG12pgzH+LxCjMGUpRao3N1UO2Q==@lists.linux.dev
X-Gm-Message-State: AFuF++lQvxdRMfY6xwMNgd+XhzUkC1ijm7q+SDgXScp1I7Tbl1neva8m
	Fu/FAazRS9saN6IabNh8emVg0sX+Un5oR2rGD+fWGtgL1aPGedT/RGXXWNexqVkxVKfFxlh5+Ca
	vW9ZSopE=
X-Gm-Gg: AYBFou03eUWjgBvJcxt1b+EcyZJ4Whz1Zab0KKaFW9zAW5KPq4h/vc8VnVk1lgKAawE
	4uPufZHxEmbu9A3Onmto1+06QkUVwvp4vn0wDkhpKPEPC7MIf8V19YI9bT7X8x3FTEIf/uyndWy
	xqtJWTIbnu9ak7dywQmqhSS9446Oz1cpRqMWpJmf7VfVV2WYVXyQxBHtbNJBbIzLiRsXp9Z4M/4
	CVxttyUZcu1GocWPTHUqysKgnMUhG0AR9jj73dtUuqAA4qv8g/a+Qgp8Ag9XwOMM8WBaXvu5BFZ
	BNDi4EyqkwEAo4uIS4L37IKgZNTqSDZ8ICJVUGBZqFA4nAlDyFhE+TghWorzdTyby4WD74fVOCJ
	1RnHdpTm5xhlrOxDyIKxNJ2qEucwv79775FLQV8TvhuXof2mXNwTfQu2CrdGWz3Fhz6uw2J2n5x
	XXR7oh7NnvTvh880l+91CUSUAyxgeAGS4c38JqHDtewOCL0NwVpLkV3vghIjr4q7Ixei20iYY=
X-Received: by 2002:a17:906:f59d:b0:c25:2fb5:e57c with SMTP id a640c23a62f3a-c29e5302b7cmr203357166b.3.1789566890387;
        Wed, 16 Sep 2026 06:54:50 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1b7e29f3sm5106347a91.17.2026.09.16.06.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 06:54:49 -0700 (PDT)
Date: Wed, 16 Sep 2026 21:54:46 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: retain all security xattrs during inode creation
Message-ID: <aqqe10w7OONy6pcI@p15>
References: <20260916120258.3583355-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916120258.3583355-1-joseph.qi@linux.alibaba.com>

On Wed, Sep 16, 2026 at 08:02:58PM +0800, Joseph Qi wrote:
> When creating a new inode, ocfs2_init_security_get() stores the
> security xattr returned by the LSM framework in
> ocfs2_security_xattr_info so that it can be written later within the
> same transaction.  But ocfs2_initxattrs() only ever looks at the
> first element of the xattr array, and it keeps the name as a bare
> pointer into memory owned by the security layer instead of copying
> it.  The value, by contrast, is already duplicated with kmemdup().
> 
> With stacked LSMs, security_inode_init_security() provides one xattr
> per LSM, so all labels but the first are silently dropped and never
> written to disk, leaving newly created files without the security
> xattrs the other LSMs rely on.
> 
> The borrowed name is not an outright bug with the LSMs in tree
> today: security_inode_init_security() frees only ->value once the
> callback returns, and documents ->name as the attribute name
> suffix, so the pointer stays valid for as long as ocfs2 uses it.
> It is fragile though, as an LSM that allocates the name together
> with the value would turn it into a use-after-free, so the rework
> below copies the names as well.
> 
> Fix this by storing copies of all the security xattrs: allocate an
> array in ocfs2_initxattrs(), copy the names and values, account for
> all of them in the credit calculations, and write each one in
> ocfs2_init_security_set().
> 
> While at it, switch the allocations from GFP_KERNEL to GFP_NOFS.
> The callback runs in the inode creation path with the parent
> directory locked, and the security layer allocates the very same
> xattr array with GFP_NOFS, so direct reclaim must not be allowed to
> recurse into the filesystem from here.
> 
> Fixes: de3004c874e7 ("ocfs2: Switch to security_inode_init_security()")
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

The code looks good to me.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/namei.c |   6 +--
>  fs/ocfs2/xattr.c | 122 ++++++++++++++++++++++++++++++++++++-----------
>  fs/ocfs2/xattr.h |  12 +++--
>  3 files changed, 105 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 58c6061ed983..ef03f90e7265 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -248,7 +248,6 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>  	int want_meta = 0;
>  	int xattr_credits = 0;
>  	struct ocfs2_security_xattr_info si = {
> -		.name = NULL,
>  		.enable = 1,
>  	};
>  	int did_quota_inode = 0;
> @@ -475,7 +474,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>  
>  	brelse(new_fe_bh);
>  	brelse(parent_fe_bh);
> -	kfree(si.value);
> +	ocfs2_free_security_xattrs(&si);
>  
>  	ocfs2_acl_init_release(&acl_state);
>  
> @@ -1831,7 +1830,6 @@ static int ocfs2_symlink(struct mnt_idmap *idmap,
>  	int want_clusters = 0;
>  	int xattr_credits = 0;
>  	struct ocfs2_security_xattr_info si = {
> -		.name = NULL,
>  		.enable = 1,
>  	};
>  	int did_quota = 0, did_quota_inode = 0;
> @@ -2063,7 +2061,7 @@ static int ocfs2_symlink(struct mnt_idmap *idmap,
>  
>  	brelse(new_fe_bh);
>  	brelse(parent_fe_bh);
> -	kfree(si.value);
> +	ocfs2_free_security_xattrs(&si);
>  	ocfs2_free_dir_lookup_result(&lookup);
>  	if (inode_ac)
>  		ocfs2_free_alloc_context(inode_ac);
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index a2d6c3d0f2e8..f2b7a53ed969 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -643,10 +643,15 @@ int ocfs2_calc_security_init(struct inode *dir,
>  			     int *xattr_credits,
>  			     struct ocfs2_alloc_context **xattr_ac)
>  {
> +	int i;
>  	int ret = 0;
>  	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
> -	int s_size = ocfs2_xattr_entry_real_size(strlen(si->name),
> -						 si->value_len);
> +	int s_size = 0;
> +
> +	for (i = 0; i < si->count; i++)
> +		s_size += ocfs2_xattr_entry_real_size(
> +				strlen(si->xattrs[i].name),
> +				si->xattrs[i].value_len);
>  
>  	/*
>  	 * The max space of security xattr taken inline is
> @@ -664,13 +669,15 @@ int ocfs2_calc_security_init(struct inode *dir,
>  	}
>  
>  	/* reserve clusters for xattr value which will be set in B tree*/
> -	if (si->value_len > OCFS2_XATTR_INLINE_SIZE) {
> -		int new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
> -							    si->value_len);
> -
> -		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
> -							   new_clusters);
> -		*want_clusters += new_clusters;
> +	for (i = 0; i < si->count; i++) {
> +		if (si->xattrs[i].value_len > OCFS2_XATTR_INLINE_SIZE) {
> +			int new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
> +						si->xattrs[i].value_len);
> +
> +			*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
> +								   new_clusters);
> +			*want_clusters += new_clusters;
> +		}
>  	}
>  	return ret;
>  }
> @@ -680,12 +687,16 @@ void ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>  			   int *want_clusters, int *xattr_credits,
>  			   int *want_meta, struct ocfs2_acl_state *acl_state)
>  {
> +	int i;
>  	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>  	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
>  
> -	if (si->enable)
> -		s_size = ocfs2_xattr_entry_real_size(strlen(si->name),
> -						     si->value_len);
> +	if (si->enable) {
> +		for (i = 0; i < si->count; i++)
> +			s_size += ocfs2_xattr_entry_real_size(
> +					strlen(si->xattrs[i].name),
> +					si->xattrs[i].value_len);
> +	}
>  
>  	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
>  		if (acl_state->default_acl && S_ISDIR(mode)) {
> @@ -732,12 +743,14 @@ void ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>  	 * reserve credits and clusters for xattrs which has large value
>  	 * and have to be set outside
>  	 */
> -	if (si->enable && si->value_len > OCFS2_XATTR_INLINE_SIZE) {
> -		new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
> -							si->value_len);
> -		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
> -							   new_clusters);
> -		*want_clusters += new_clusters;
> +	for (i = 0; si->enable && i < si->count; i++) {
> +		if (si->xattrs[i].value_len > OCFS2_XATTR_INLINE_SIZE) {
> +			new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
> +						si->xattrs[i].value_len);
> +			*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
> +								   new_clusters);
> +			*want_clusters += new_clusters;
> +		}
>  	}
>  	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
>  		if (acl_state->default_acl && S_ISDIR(mode)) {
> @@ -7630,17 +7643,46 @@ static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array
>  {
>  	struct ocfs2_security_xattr_info *si = fs_info;
>  	const struct xattr *xattr;
> +	struct ocfs2_security_xattr *xattrs;
> +	int count = 0, i;
>  	int err = 0;
>  
>  	if (si) {
> -		si->value = kmemdup(xattr_array->value, xattr_array->value_len,
> -				    GFP_KERNEL);
> -		if (!si->value)
> +		for (xattr = xattr_array; xattr->name != NULL; xattr++)
> +			count++;
> +
> +		xattrs = kcalloc(count, sizeof(*xattrs), GFP_NOFS);
> +		if (!xattrs)
>  			return -ENOMEM;
>  
> -		si->name = xattr_array->name;
> -		si->value_len = xattr_array->value_len;
> +		for (i = 0; i < count; i++) {
> +			xattrs[i].name = kstrdup(xattr_array[i].name, GFP_NOFS);
> +			if (!xattrs[i].name) {
> +				err = -ENOMEM;
> +				goto out_err;
> +			}
> +
> +			xattrs[i].value = kmemdup(xattr_array[i].value,
> +						  xattr_array[i].value_len,
> +						  GFP_NOFS);
> +			if (!xattrs[i].value) {
> +				err = -ENOMEM;
> +				goto out_err;
> +			}
> +			xattrs[i].value_len = xattr_array[i].value_len;
> +		}
> +
> +		si->xattrs = xattrs;
> +		si->count = count;
>  		return 0;
> +
> +out_err:
> +		for (; i >= 0; i--) {
> +			kfree(xattrs[i].name);
> +			kfree(xattrs[i].value);
> +		}
> +		kfree(xattrs);
> +		return err;
>  	}
>  
>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> @@ -7653,6 +7695,19 @@ static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array
>  	return err;
>  }
>  
> +void ocfs2_free_security_xattrs(struct ocfs2_security_xattr_info *si)
> +{
> +	int i;
> +
> +	for (i = 0; i < si->count; i++) {
> +		kfree(si->xattrs[i].name);
> +		kfree(si->xattrs[i].value);
> +	}
> +	kfree(si->xattrs);
> +	si->xattrs = NULL;
> +	si->count = 0;
> +}
> +
>  int ocfs2_init_security_get(struct inode *inode,
>  			    struct inode *dir,
>  			    const struct qstr *qstr,
> @@ -7670,7 +7725,7 @@ int ocfs2_init_security_get(struct inode *inode,
>  		 * security_inode_init_security() does not return -EOPNOTSUPP,
>  		 * we have to check the xattr ourselves.
>  		 */
> -		if (!ret && !si->name)
> +		if (!ret && !si->count)
>  			si->enable = 0;
>  
>  		return ret;
> @@ -7687,10 +7742,21 @@ int ocfs2_init_security_set(handle_t *handle,
>  			    struct ocfs2_alloc_context *xattr_ac,
>  			    struct ocfs2_alloc_context *data_ac)
>  {
> -	return ocfs2_xattr_set_handle(handle, inode, di_bh,
> -				     OCFS2_XATTR_INDEX_SECURITY,
> -				     si->name, si->value, si->value_len, 0,
> -				     xattr_ac, data_ac);
> +	int i;
> +	int ret = 0;
> +
> +	for (i = 0; i < si->count; i++) {
> +		ret = ocfs2_xattr_set_handle(handle, inode, di_bh,
> +					     OCFS2_XATTR_INDEX_SECURITY,
> +					     si->xattrs[i].name,
> +					     si->xattrs[i].value,
> +					     si->xattrs[i].value_len, 0,
> +					     xattr_ac, data_ac);
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
>  }
>  
>  const struct xattr_handler ocfs2_xattr_security_handler = {
> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
> index 887cc1a18b1a..1dd08f979e3c 100644
> --- a/fs/ocfs2/xattr.h
> +++ b/fs/ocfs2/xattr.h
> @@ -20,13 +20,18 @@ enum ocfs2_xattr_type {
>  	OCFS2_XATTR_MAX
>  };
>  
> -struct ocfs2_security_xattr_info {
> -	int enable;
> -	const char *name;
> +struct ocfs2_security_xattr {
> +	char *name;
>  	void *value;
>  	size_t value_len;
>  };
>  
> +struct ocfs2_security_xattr_info {
> +	int enable;
> +	struct ocfs2_security_xattr *xattrs;
> +	int count;
> +};
> +
>  extern const struct xattr_handler ocfs2_xattr_user_handler;
>  extern const struct xattr_handler ocfs2_xattr_trusted_handler;
>  extern const struct xattr_handler ocfs2_xattr_security_handler;
> @@ -49,6 +54,7 @@ int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
>  int ocfs2_init_security_get(struct inode *, struct inode *,
>  			    const struct qstr *,
>  			    struct ocfs2_security_xattr_info *);
> +void ocfs2_free_security_xattrs(struct ocfs2_security_xattr_info *);
>  int ocfs2_init_security_set(handle_t *, struct inode *,
>  			    struct buffer_head *,
>  			    struct ocfs2_security_xattr_info *,
> -- 
> 2.39.3
> 
