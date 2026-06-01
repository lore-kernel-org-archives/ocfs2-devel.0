Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DF029CE1;
	Mon,  1 Jun 2026 18:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780338101; cv=none; b=MOSiai82NA8kIK5aUehZi/cT70Jg+QqgzAV/7Q234I0NHpu0I/1NSw6WRG02fndx8g8T/IZW0jEvqJb5o7YOdvdnLiNtXqq4/SM2Rfv0WV47k/u/MKqFV3LktR54GC2ca0rC6Tb9DnOYr5g1hH/Ieleu7AX2c8BmU5d6VKCgjQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780338101; c=relaxed/simple;
	bh=a3HJssRy+/uLhln8hZlM847mxZpyftYSRi0JLbatPHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHvd5l3FT91Xxn/L1ZNIuxM06NiZuUyn7cvMe+Crd6woysLGFpNKEgy4OftjTXeg9xXoWzjPFo6yU5+x3kWNGKEPLrWk7pv41f93GmAgoE/vfcjJ32T3plAfGuq6rH5Hif7Zx89DMx2xKelnfrEQbnOn1GkEoJuQLZJT2cHklxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=evilplan.org; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=fail (0-bit key) header.d=infradead.org header.i=@infradead.org header.b=bSzJ7NW/ reason="key not found in DNS"; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=evilplan.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=infradead.org header.i=@infradead.org header.b="bSzJ7NW/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=owqG3vqrdJjMWEFJrPdAcx7VvAnC8jHqS4x0Q1jAvhg=; b=bSzJ7NW/HjiAy0+xIWNZoYWhAh
	OigUmUFE7Ade8qpChlOJiuP9LIczsIiylPiW1fBhbrstfaKWYuO2jTiv2v2sbb2xm6sB9sX+4APjt
	go5vzkevw9X10cDI93xeA9e9ysRn4LdmS4sXMx7PR7Ho+w+ofvQ+q7wNUI1Svi14EWmuodD2c3ZRn
	9W7RHL2ws23H6CNDP7ZM1gjC1VsqR4AyUxsySqT5hYIY5Qo4zrt6JbRXMc3fkKIjTB7jcnfGXdV8B
	dUa47BieSuRsM7IpUOlLdC1cesFNzEcnNkv/oznTSdvqbD70VstDEcY6jPNfVDJ8ZA7LidNIYaIMZ
	MItS2aew==;
Received: from jlbec by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wU7Gc-00000003YqP-0wwv;
	Mon, 01 Jun 2026 18:21:38 +0000
Date: Mon, 1 Jun 2026 11:21:34 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
	ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ocfs2: reject dinodes whose i_rdev disagrees with
 the file type
Message-ID: <ah3NruJW0S1ASobq@google.com>
Mail-Followup-To: Michael Bommarito <michael.bommarito@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260519110404.1803902-1-michael.bommarito@gmail.com>
 <20260519110404.1803902-3-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519110404.1803902-3-michael.bommarito@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
Sender: Joel Becker <jlbec@ftp.linux.org.uk>

On Tue, May 19, 2026 at 07:04:03AM -0400, Michael Bommarito wrote:
> id1.dev1.i_rdev is the device-number arm of the ocfs2_dinode id1 union.
> It is only meaningful for character and block device inodes. For any
> other user-visible file type the on-disk value must be zero.
> 
> ocfs2_populate_inode() currently copies id1.dev1.i_rdev into
> inode->i_rdev before the S_IFMT switch decides whether the inode is a
> special file. A non-device inode with a non-zero i_rdev can therefore
> publish stale or attacker-controlled device state into the in-core inode.
> 
> System inodes legitimately use other arms of the same union, so keep
> the cross-check restricted to non-system inodes. Factor that predicate
> into a helper and use it in both the normal validator and online
> filecheck path; filecheck reports the malformed dinode through
> OCFS2_FILECHECK_ERR_INVALIDINO instead of ocfs2_error().
> 
> Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Assisted-by: Claude:claude-opus-4-7

Reviewed-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/inode.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index e149ccbdc03ce..992980ea98046 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -72,6 +72,16 @@ static bool ocfs2_valid_inode_mode(umode_t mode)
>  	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
>  }
>  
> +static bool ocfs2_dinode_has_unexpected_rdev(struct ocfs2_dinode *di)
> +{
> +	umode_t mode = le16_to_cpu(di->i_mode);
> +
> +	if (le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)
> +		return false;
> +
> +	return !S_ISCHR(mode) && !S_ISBLK(mode) && di->id1.dev1.i_rdev != 0;
> +}
> +
>  void ocfs2_set_inode_flags(struct inode *inode)
>  {
>  	unsigned int flags = OCFS2_I(inode)->ip_attr;
> @@ -1518,6 +1528,41 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	/*
> +	 * id1.dev1.i_rdev is the device-number arm of the id1 union and
> +	 * is only meaningful for character and block device inodes.  For
> +	 * any other regular user-visible file type the on-disk value
> +	 * must be zero.  ocfs2_populate_inode() currently runs
> +	 *
> +	 *     inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
> +	 *
> +	 * unconditionally, before the S_IFMT switch decides whether the
> +	 * inode is a special file.  As a result, an i_rdev value present
> +	 * on a non-device inode is silently published into the in-core
> +	 * inode; a subsequent forced re-read or in-core mode mutation
> +	 * (cluster peer with raw write access to the shared LUN,
> +	 * on-disk corruption, or a separately forged dinode) can then
> +	 * expose the attacker-controlled device number to
> +	 * init_special_inode() without ever showing an unusual i_mode
> +	 * at validation time.
> +	 *
> +	 * System inodes (OCFS2_SYSTEM_FL) legitimately use the bitmap1
> +	 * and journal1 arms of the same union (allocator i_used /
> +	 * i_total counters and the journal ij_flags /
> +	 * ij_recovery_generation pair); those bytes are not an i_rdev
> +	 * and must not be checked here.  Restrict the cross-check to
> +	 * non-system inodes, which is the full attacker-controllable
> +	 * surface.
> +	 */
> +	if (ocfs2_dinode_has_unexpected_rdev(di)) {
> +		rc = ocfs2_error(sb,
> +				 "Invalid dinode #%llu: non-device mode 0%o with i_rdev %llu\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(di->i_mode),
> +				 (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
> +		goto bail;
> +	}
> +
>  	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
>  		struct ocfs2_inline_data *data = &di->id2.i_data;
>  
> @@ -1657,6 +1702,16 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
>  		     (unsigned long long)bh->b_blocknr,
>  		     le16_to_cpu(di->i_mode));
>  		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> +		goto bail;
> +	}
> +
> +	if (ocfs2_dinode_has_unexpected_rdev(di)) {
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: non-device mode 0%o with i_rdev %llu\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->i_mode),
> +		     (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
> +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
>  	}
>  
>  bail:
> -- 
> 2.53.0

-- 

"Nearly all men can stand adversity, but if you really want to
 test a man's character, give him power."
	- Abraham Lincoln

			http://www.jlbec.org/
			jlbec@evilplan.org
