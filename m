Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1369534250F
	for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 16:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766074085; cv=none; b=uE+KW9GkBhOx8BC0Hz+9BfqveiyxcPnEL2tMkUSGRSBPH8A+AnkDTviJ03iKYKdZI5DjARyULHLUgAZ21icHhX54i2IUzw0izMf6O48WH5fD7ERI5EJHLIAEvXMthCMv1Hp27o6GGlM81crtV1TPH1WWKwuBOoWiTPg58fL4vzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766074085; c=relaxed/simple;
	bh=9fY3A5b4zET37FjxItWEHTv8ADHy/IGZ3gVaaXcN4G0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LUhzknr76S/v3kTYSPNNFZr862p+EPQd7n0/T1SA8LRDnH62VNpnqfXFsmSCBufbOgV6vt7wdbGT9jmfw+vWOsixvbGZ9HybBU+bKSr4+WBH+trJ15FAxXGVrYot796bPYa4SOrV016JHdbud3RyYodMBi1M8POn3O70kwyvcto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JwxxfNOA; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JwxxfNOA"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47797676c62so1078885e9.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 08:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766074080; x=1766678880; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ll5fg56zYYiWFQstkxfa8620KqOD1ctc79MVD69plr0=;
        b=JwxxfNOAgAT+1mJkqzeDRqzEjZCmtNbjc4VMVXomYna9KDk7xJbJGlYFzXJG9AFazf
         ts8leoYvye+ijin7Y8k4sCrxpGQyne9CVWHfl2tdZ78nOUVsvqivKYaaxnqc6gk/5fbe
         IAC0ZVQdGVViWmsvfx0M6B/+nFrYj+Ur0k5WMEXGAm4noPNdAOLEzDXFbdX6pFqYXrDq
         4EINkl2K5t4RbER+DK7p9xOLrS/aZXOJLjFVs3BOQDJlYznaEBD04Rpp2nm2lE0LMCKO
         EBnMBAQhAnXbB0zJhGH4n+ziS3cpeS9unTIQXrwyeVAadBTrM/T38uFI5cnZRfenyj2W
         dRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766074080; x=1766678880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ll5fg56zYYiWFQstkxfa8620KqOD1ctc79MVD69plr0=;
        b=JYr33TJoGN1nsrk7nTRifBaOq+RsQV1h/Ri70CKR01UfmIk0a2c1ntKya5W3KR4Pca
         owJkQyVyU4h+jUuoG+OZCpIncurm5/iTep5LIBIc1dQmJ/8nxrhXXWYiE3egKC4s+ew3
         DfUHcZUT47/GbPQbG4M4nauDTunDGDDCPGew3v5yw3RC7x4nBcPnCaqS9sUS7fjseCIT
         afxq38iYbDGM9CS1ZN1z8OZVXs3i/WJTbNqMSDnzIe80kPdwgjoY1arnjAlQQl2BnLjq
         C66zEhMKClNurqYsqm2pY9JVEPVcwpmMsTbnY/YED4FnfQLS9c8dPOAhYsWNz6brdRuA
         a+SA==
X-Forwarded-Encrypted: i=1; AJvYcCX39ak7hl7knEI0ptQf2aRUm0kM8xIEWvxdLdIc6i/XLyf5IfN9NJ2D/7xnAdRiWe8jvXpH4G//inhHqQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxsSv3BI89VxUlh6m/xlnSi/h9259c/t26xZGSkxZf4166Ov9mi
	7Cs/eEyv+lHsZzJWdEL8c6mPKAqB/KQRokCPJnPGUvIggZj/BTUqJRWXyf2KLJPdLPI=
X-Gm-Gg: AY/fxX7uGQsXPS33rCpcZVOH0acBuRMc2hpcgTIEkZSD2MHztWLDJ1bDaJ/HdK2kaCm
	l7i+u0xcve9raKmcR1eHlrNSwSyuvjR7Id2wDs5ghL20ZvvSGuVb0jVvvmPL2e4UumdFOR5kYW6
	hwbmI2JeqTGDO8afVGuMZpYi3lD1Nv3V1yWx0Qg/MieIT9fzlJ61cgWIAcoCbf+JhlCoViRRi/l
	QYP8MoqcOmOMlSqW8HhEpkoEFy216ZLrT6A5i7CVFBqx0Tdx/15L5F8XXxXYOVj9Mbx0/cKOr1T
	YLvExE0jkgqejquADsN/oko3oTro30Fmk+Dne/YF6MCy3exMZNuPghhWaohw+bLxtGjdPTZl92H
	SLPFZXsn6qS7FPvrbn3Hz+MnsbuZTa3wXkOOJ7ucfN2Hq7GpqGJ+FRHJPJjq2eo4VBzYPEOv7ET
	EffJ4Y4cRYvA==
X-Google-Smtp-Source: AGHT+IFfChPcdXBQmW4OnfiET0IribR1F0Ir/X6rOlOywgz8dsCin5NgK+sVVKYU+DaOhPJ/6fhXmg==
X-Received: by 2002:a05:600c:4ed2:b0:471:ab1:18f5 with SMTP id 5b1f17b1804b1-47be3cffd6amr17869585e9.7.1766074080318;
        Thu, 18 Dec 2025 08:08:00 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d2fa20a22sm2673669a12.20.2025.12.18.08.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 08:07:59 -0800 (PST)
Date: Fri, 19 Dec 2025 00:07:56 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Prithvi Tambewagh <activprithvi@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org, david.hunter.linux@gmail.com, 
	khalid@kernel.org, syzbot+779d072a1067a8b1a917@syzkaller.appspotmail.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: handle OCFS2_SUPER_BLOCK_FL flag in system dinode
Message-ID: <njikmwfpnsdzalxump7dj7wnlvkwfmvuqwxhpwzly45v7ioj5l@yckvd3veaifi>
References: <20251216200544.4114-1-activprithvi@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216200544.4114-1-activprithvi@gmail.com>

On Wed, Dec 17, 2025 at 01:35:44AM +0530, Prithvi Tambewagh wrote:
> When ocfs2_populate_inode() is called during mount process, if the flag
> OCFS2_SUPER_BLOCK_FL is set in on-disk system dinode, then BUG() is
> triggered, causing kernel to panic. This is indicative of metadata
> corruption.
> 
> This is fixed by calling ocfs2_error() to print the error log and the
> corresponding inode is marked as 'bad', so that it is not used further
> during the mount process. It is ensured that the fact of that inode being
> bad is propagated to caller ocfs2_populate_inode() i.e.
> ocfs2_read_locked_inode() using is_bad_inode() and further behind along
> the call trace as well.
> 
> Reported-by: syzbot+779d072a1067a8b1a917@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=779d072a1067a8b1a917
> Tested-by: syzbot+779d072a1067a8b1a917@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> ---
>  fs/ocfs2/inode.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 12e5d1f73325..f439dc801845 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -347,7 +347,12 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
>  	} else if (fe->i_flags & cpu_to_le32(OCFS2_SUPER_BLOCK_FL)) {
>  		/* we can't actually hit this as read_inode can't
>  		 * handle superblocks today ;-) */
> -		BUG();
> +		ocfs2_error(sb,
> +			    "System Inode %llu has "
> +			    "OCFS2_SUPER_BLOCK_FL set",
> +			    (unsigned long long)le64_to_cpu(fe->i_blkno));
> +		make_bad_inode(inode);
> +		return;
>  	}
>  
>  	switch (inode->i_mode & S_IFMT) {
> @@ -555,6 +560,11 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  
>  	ocfs2_populate_inode(inode, fe, 0);
>  
> +	if (is_bad_inode(inode)) {
> +		status = -EIO;
> +		goto bail;
> +	}
> +
>  	BUG_ON(args->fi_blkno != le64_to_cpu(fe->i_blkno));
>  
>  	if (buffer_dirty(bh) && !buffer_jbd(bh)) {
> @@ -576,7 +586,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  	if (can_lock)
>  		ocfs2_inode_unlock(inode, lock_level);
>  
> -	if (status < 0)
> +	if (status < 0 && !is_bad_inode(inode))
>  		make_bad_inode(inode);
>  
>  	brelse(bh);
> 
> base-commit: d76bb1ebb5587f66b0f8b8099bfbb44722bc08b3
> -- 
> 2.43.0
> 
> 

ocfs2_populate_inode has two callers: __ocfs2_mknod_locked() and
ocfs2_read_locked_inode()

Your code only works for the ocfs2_read_locked_inode() path, but not for the
__ocfs2_mknod_locked() path.
In __ocfs2_mknod_locked(), there are two tasks after ocfs2_populate_inode:
"creating locks" and "updating the transaction". If you use a 'goto' to bypass
these two tasks, ocfs2 will crash in the near future. Conversely, if you choose
to execute the two jobs, the logic is flawed because we perform on a bad inode.

In my view, the existing code (using BUG()) is acceptable. We don't need to
worry about this syzbot report.

Thanks,
Heming
