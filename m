Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416DF38F65C;
	Thu,  8 Oct 2026 17:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791479295; cv=none; b=mxvv8DFLFPgTS9Paom/fMZmWgRX55Eo12TZ/arOx3l1ICAzdcR6Bx1qIPXwz9/Dcslx0cBY4Slgo+Fm5Vit7lUORQQDZSb5lemems9SWnZT3umZ+u44K8Yey8j5RHxKQXDlgNSZpb+t+UPDGt7vDvnbPwqw1pmiFgUz+fV8bCps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791479295; c=relaxed/simple;
	bh=0eBtMTu0/gfhzOhtCIIjYp5dd3J2nx+mqrVP8/rXKb4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=dmfGvSX2JhHgujMuEkYAU2zJpKM7y3Fpek9DYt2q8Y/9iwafV2sVi5bSTf63kYVrkPOEQ+zvDGmzhMiEwH8hfpUccHVcRsxP2Tz71IwhEKGMWzLhqDtx1DDgus1w9EO+yGzbF277gRcjB7oS4DQf3UizoX3ne191fYP3SqlzkNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=csdqprA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="csdqprA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C96D1F000FF;
	Thu,  8 Oct 2026 17:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791479293;
	bh=40UmGtsWvKZUKUpHoZBUqaWRitaTWsYb5pdsjbLrFbc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=csdqprA4ZZqt4Jvt9d+z8dNJvB443wlcluTVQvjFtrKp8TUZICyWcXqBapadTNldC
	 QdYL+b8STFSRrWvvQ00GgMU8AixHHUkCp4+nWQmHNPkadSFl++BN356EwDBUdtaOTT
	 HrH6+T3//qPRmIo+OQJijugBSP4K/KPyye8l/1aY=
Date: Thu, 8 Oct 2026 10:08:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Anderson Ferneda
 <anderson.ferneda@braza.com.br>, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ocfs2: deal with legacy signed dir index name hash
 values
Message-Id: <20261008100812.0969af222022821d4ed72fad@linux-foundation.org>
In-Reply-To: <20261008122743.616779-1-joseph.qi@linux.alibaba.com>
References: <20261008122743.616779-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  8 Oct 2026 20:27:42 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") set
> -funsigned-char globally, which changed the result of the naked 'char'
> load in str2hashbuf():
> 
> 	val = msg[i] + (val << 8);
> 
> A name byte >= 0x80 used to sign-extend and now zero-extends, so
> ocfs2_dx_dir_name_hash() computes a different hash pair for every name
> containing one.  The pair is written into the dx leaf when the entry is
> created, so an index built by an older kernel no longer matches and
> ocfs2_dx_dir_search() returns -ENOENT for a name that readdir still
> lists.
> 
> Search with the current unsigned hash and, on a miss, retry with the
> legacy signed one, as ext4 does in commit f3bbac32475b2 ("ext4: deal
> with legacy signed xattr name hash values").  New entries are always
> indexed under the unsigned hash.  Skip the retry when the two hashes
> are equal, so that a miss on an ASCII name does not walk the index
> twice.
> 
> The retry costs a second walk of the dx tree, so a negative lookup of a
> name containing a byte >= 0x80 does twice the work.  That is bounded and
> worth it, and directories whose dx root is still inline pay nothing
> extra, since there the retry only rescans the root block that is already
> loaded.  Nothing retires it at runtime: a legacy entry keeps its legacy
> hash, because neither deleting nor updating an entry rewrites the dx
> hash, and the only code that rehashes existing dirents is
> ocfs2_expand_inline_dir() on the inline to extent conversion.
> Rebuilding the index offline is what removes the cost for good.
> 
> Also spell out the signedness in str2hashbuf() instead of leaving the
> current hash to -funsigned-char, as commit 854f0912f813 ("ext4: make
> xattr char unsignedness in hash explicit") did, so that both variants
> stay correct if this is backported to a kernel without the flag.
> 
> Reported-by: Anderson Ferneda <anderson.ferneda@braza.com.br>
> Link: https://lore.kernel.org/ocfs2-devel/CP5P284MB2780AC2C3C2AB2CF2B6CB7AFBE942@CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM/
> Exposed-by: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
> Cc: stable@vger.kernel.org # 6.2+
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dir.c | 76 ++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 65 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 55c4a305a282..3f159a20a248 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -221,7 +221,8 @@ static void TEA_transform(__u32 buf[4], __u32 const in[])
>  	buf[1] += b1;
>  }
>  
> -static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
> +static void str2hashbuf(const char *msg, int len, __u32 *buf, int num,
> +			bool legacy_signed)
>  {
>  	__u32	pad, val;
>  	int	i;
> @@ -235,7 +236,10 @@ static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
>  	for (i = 0; i < len; i++) {
>  		if ((i % 4) == 0)
>  			val = pad;
> -		val = msg[i] + (val << 8);
> +		if (legacy_signed)
> +			val = (signed char)msg[i] + (val << 8);
> +		else
> +			val = (unsigned char)msg[i] + (val << 8);
>  		if ((i % 4) == 3) {
>  			*buf++ = val;
>  			val = pad;
> @@ -248,8 +252,9 @@ static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
>  		*buf++ = pad;
>  }
>  
> -static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
> -				   struct ocfs2_dx_hinfo *hinfo)
> +static void __ocfs2_dx_dir_name_hash(struct inode *dir, const char *name,
> +				     int len, struct ocfs2_dx_hinfo *hinfo,
> +				     bool legacy_signed)
>  {
>  	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>  	const char	*p;
> @@ -279,7 +284,7 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
>  
>  	p = name;
>  	while (len > 0) {
> -		str2hashbuf(p, len, in, 4);
> +		str2hashbuf(p, len, in, 4, legacy_signed);
>  		TEA_transform(buf, in);
>  		len -= 16;
>  		p += 16;
> @@ -290,6 +295,19 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
>  	hinfo->minor_hash = buf[1];
>  }
>  
> +static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
> +				   struct ocfs2_dx_hinfo *hinfo)
> +{
> +	__ocfs2_dx_dir_name_hash(dir, name, len, hinfo, false);
> +}
> +
> +static void ocfs2_dx_dir_name_hash_signed(struct inode *dir, const char *name,
> +					  int len,
> +					  struct ocfs2_dx_hinfo *hinfo)
> +{
> +	__ocfs2_dx_dir_name_hash(dir, name, len, hinfo, true);
> +}
> +
>  /*
>   * bh passed here can be an inode block or a dir data block, depending
>   * on the inode inline data flag.
> @@ -1021,10 +1039,10 @@ static int ocfs2_dx_dir_lookup(struct inode *inode,
>  	return ret;
>  }
>  
> -static int ocfs2_dx_dir_search(const char *name, int namelen,
> -			       struct inode *dir,
> -			       struct ocfs2_dx_root_block *dx_root,
> -			       struct ocfs2_dir_lookup_result *res)
> +static int __ocfs2_dx_dir_search(const char *name, int namelen,
> +				 struct inode *dir,
> +				 struct ocfs2_dx_root_block *dx_root,
> +				 struct ocfs2_dir_lookup_result *res)
>  {
>  	int ret, i, found;
>  	u64 phys;
> @@ -1037,8 +1055,6 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
>  	struct ocfs2_extent_list *dr_el;
>  	struct ocfs2_dx_entry_list *entry_list;
>  
> -	ocfs2_dx_dir_name_hash(dir, name, namelen, &res->dl_hinfo);
> -
>  	if (ocfs2_dx_root_inline(dx_root)) {
>  		entry_list = &dx_root->dr_entries;
>  		goto search;
> @@ -1135,6 +1151,44 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
>  	return ret;
>  }
>  
> +static int ocfs2_dx_dir_search(const char *name, int namelen,
> +			       struct inode *dir,
> +			       struct ocfs2_dx_root_block *dx_root,
> +			       struct ocfs2_dir_lookup_result *res)
> +{
> +	struct ocfs2_dx_hinfo legacy;
> +	int ret;
> +
> +	ocfs2_dx_dir_name_hash(dir, name, namelen, &res->dl_hinfo);
> +
> +	ret = __ocfs2_dx_dir_search(name, namelen, dir, dx_root, res);
> +	if (ret != -ENOENT)
> +		return ret;
> +
> +	/*
> +	 * Nothing under the current hash.  The entry may have been indexed by
> +	 * an older kernel, which sign-extended the name bytes when hashing.
> +	 * New entries are always indexed under the unsigned hash, so only fall
> +	 * back to the legacy signed one when it can actually differ: an ASCII
> +	 * name hashes the same either way, and a genuine miss on one should
> +	 * not have to walk the index twice.
> +	 */
> +	ocfs2_dx_dir_name_hash_signed(dir, name, namelen, &legacy);
> +	if (legacy.major_hash == res->dl_hinfo.major_hash &&
> +	    legacy.minor_hash == res->dl_hinfo.minor_hash)
> +		return ret;
> +
> +	res->dl_hinfo = legacy;
> +
> +	ret = __ocfs2_dx_dir_search(name, namelen, dir, dx_root, res);
> +	if (ret)
> +		return ret;
> +
> +	pr_warn_once("ocfs2: directory index with signed name hash\n");
> +
> +	return 0;
> +}
> +
>  static int ocfs2_find_entry_dx(const char *name, int namelen,
>  			       struct inode *dir,
>  			       struct ocfs2_dir_lookup_result *lookup)
> -- 
> 2.39.3
