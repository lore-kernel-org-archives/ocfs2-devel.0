Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121963264C2
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 02:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791514732; cv=none; b=igZiy8cgvmuMPX3QzcX6CdsHuhvsHQWcF5fiF3NTQdwl42KAy0FrDgqo8cCNtT30Z/4if7O88SH26UqIB5yB7Vv8PuhlA0issXWXJVQa1eHKDaGL2ldi5nynwOBWqFvbrCzeeBDmEci4PKfYd1YGJgOBQrhLPhJfmsWK485JcHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791514732; c=relaxed/simple;
	bh=MNvr+DbdsCxNj+Ha9nzMNVNZQecmMlPkvNM4YtBQ+JU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvznvbPmz3FsGNpCrqyn35hJRC9tNUHqfCJpdlojCkkMS0zhxifjg/5dt0XasLAS+iBIhuGk4tY8+a18wwEtWcFzJjUIiuA1s9bCB19o22fJRK/bxFRYKVGQlAB2j8xiCERSfliVulNqnUARW3LJIFiV5uzAS9+Pbp9KPsrIW94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TmTMFo8j; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TmTMFo8j"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48afcb1e5f9so162413f8f.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 08 Oct 2026 19:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791514728; x=1792119528; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i+iyPvnyC0wQuPh/K+mYDhdaAhHwMxdH+RIdFuzmmPo=;
        b=TmTMFo8jcGp5uc6Lgn1aV4q40zkTt1Xjjr8gR51m10++UkdVDhXVZSA7xJImRmKgyz
         eiodlwlVIBpBtyi8Z5p5bXlkbABsQdTWpWS/wJ/LcXnHSG0REgmZEOYGa0xa46p5R+5+
         Xpeq8INUsfDtXzSNSmjbOiI9HtpuUezgFePm1E4sV/iwCkjHFwpLtG/G/E3LA7+Sj+Y0
         lGr+bQwLPQh7i56zSIBOmv9cS/4IlJTkcFvdRtxXGKlarJgz0JycV3Fzgnkdw7PwQTrA
         Bd6CAQ3Bj7gsoDousAWpmfuPjaW159uOvAoNLJne1yL4OI6OQDt8+MLxyoPJfSZcvAS0
         xJ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791514728; x=1792119528;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i+iyPvnyC0wQuPh/K+mYDhdaAhHwMxdH+RIdFuzmmPo=;
        b=ruCmhSFLJ+jHHg2GsZwA2g197UIGp1dlBcN2XM4V8Y+umyIiT4qcnWIo/7ID/Oigz5
         1seg0Ai228g7Jdctlw8WvAQnqMMjuGGwHjcBns/jHAJtAeL6AT5eOpBVJv2oB8pamKcD
         cU4bPM8YdhwCuMwpSAWqf1vFaBxXgQP4KVYwHL3jWeuqAYaC454EfJPnGXQCupS76vne
         iM1Uums/gsALCns3Nh0q+O2Ah2eaTtGIQoBb4GYZw8PoxU7RUmlSYrqkt22dG/MvBw9k
         2MaEjTHrUEiP0uSYg2agtI5yd4z6stXSscrBtE1mS6KFU7kB9FLwcgOuYmPkoda/Wyte
         76PA==
X-Forwarded-Encrypted: i=1; AKwUvBwnHks+PVVDZ0SEUtjyvSLQBGPFhIWX0Y3EuE/9Y9wAtkvfqMxIe92URR33TBU3ebiqqJ8oKOQ6s8MUEA==@lists.linux.dev
X-Gm-Message-State: AFuF++kC2fdZgNo8/ieApC1zIs/53dsUZ6M7BMb3VXerhw1i6nJ6l+v9
	BqYIVZabSFT61ODZZ+smqNqRGMOtPit+g3yKJ2L2GGIZaDIe8gyfKtSMu8Xk9uy9hKVYt+g8dbf
	mBXmZ0SU=
X-Gm-Gg: AYBFou0oRNTRnhxvpGwjS4nutQaqSbiUMJvROFXrSifq9Xbp5mB1o0jnTAaIFOnqgX/
	w055bY+pV9JEZzSlcQG1M4bnFA79qTD6jgc3hC15kteE0pgjtydDlcLuUiZdWqkuOXunh+XV3OS
	M7ln+RzjiynuAS3W9OC6COlORQ9Kid5pxpzEg/7uAfD1htb7800/4ifGbRm/YDKY9FZD22ci/cO
	KESbnXABmS5wuvz/B+hsCKBxv/RIhkIgbjNUrc5mxhFCZnLLS3OUbadmXgdasB1/ARxFAQAoZT9
	te5gHhfkuZWX0IKBqx/M08rkPy6McHo/VVGwgtIkpnWHmwfLcpnvWZfhn1y7ursh8ntxaB9Y11U
	xofpiMN+ElYYdyS9pZF4kU/7WG3/NjdqzIor2hsgFG7Gu9Vu+F0ufWV5YVWEVwKqwMNKw6K+WRh
	OFWgDdZtvddm4j56SkA9HRkVdw4u3MsrFiFqejUjkNrhkMphDYI039VRt1E1rkCGmCrwoLAfTJq
	RHtPBo=
X-Received: by 2002:a05:600c:1912:b0:4a0:73b:a222 with SMTP id 5b1f17b1804b1-4a18e3ee97dmr6850745e9.0.1791514728194;
        Thu, 08 Oct 2026 19:58:48 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e841a02f85sm2447925ad.10.2026.10.08.19.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 19:58:46 -0700 (PDT)
Date: Fri, 9 Oct 2026 10:58:42 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Anderson Ferneda <anderson.ferneda@braza.com.br>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ocfs2: deal with legacy signed dir index name hash
 values
Message-ID: <ashYTCl9usNNPdXa@p15>
References: <20261008122743.616779-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008122743.616779-1-joseph.qi@linux.alibaba.com>

On Thu, Oct 08, 2026 at 08:27:42PM +0800, Joseph Qi wrote:
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

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
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
> 
