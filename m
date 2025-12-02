Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B679C22F75E
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 02:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764643984; cv=none; b=t/DOExLhWYr00yxXAx6BvM7Xf4lIDVkXoJgLM8fLh5cUQCInWWwyRy3oqMJZUbFas27y0fVb8zmDSsrzdedA2Cf5xnHZrhlQY/Lj8bL1r3ne8JdldryhOEm6/Mjuc0H7ffPPUHF1ztv853AuXcryrsK5A70Iztt1scasKH9eglU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764643984; c=relaxed/simple;
	bh=BfsmnESRsTEjjnMLFGVy11NbPyiIG+VhSw9ewpDfdMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0W9zD4CsW25onW81cJF1Mt6T+issKSOEHS6fmcWWMQNyDC1Lrc/GqGCNKEOPUZept7HKl3/gJf8X0i3GQK4pD2Y9ngAcaJGk0HaZPUis2G00XHo3CDsPmAk92JT7WDL/uXuB2F9RGJDUzM6tEE8hWkVNP9mIit48mSpOyICBOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Miqt+JvI; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Miqt+JvI"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47797676c62so6446395e9.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 18:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764643980; x=1765248780; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JcTE+sN2plpnhB+7RR8c6oqE04ilShYcg9WPG5FJJ4s=;
        b=Miqt+JvIjW9CHaxmftqFLI/Uqc0ShQP6FISY7JQH8ZAGzti67/ZEwn0n1fRcdf0J4v
         /jyCTIt6OSwbYAFq30hMkYGVNGQ4ejS//6bcq5zWDhGFwgoYLN9+t8i3in08ls5XgZoL
         ZE1v0ZAzrj4XRbdz7u96klx0JvSyXM6FMMFmZCROyFnOAkh4UyGBN0frg+VmzeFGD/An
         xrd6+S0EnYuJvHf+nogV+ewNrvFRXIElY7rlhQfRKkzDk/UmKSMLRhJKQ7LBNmcVdn5h
         zEdnle8tOYMFW+Eqx0L50Es3pyETkEr4CKXmALJ03MOEV+t21e9Z14fRv7RaRRPDtEgd
         kF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764643980; x=1765248780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JcTE+sN2plpnhB+7RR8c6oqE04ilShYcg9WPG5FJJ4s=;
        b=t+dKrMV6X2Jy2Ks/K+Alg/8hwPTb82peW9SsBFxSchDDes85yEsFkIadkAarSlcPpk
         4sZaGyzRCH7yeoP4jbIMFXlVJda31NStK73A/5U3HJLUYcrX4L1NF/+pcRZVIGmtInJl
         FQBMlrUEeEODPo8CjrdxS/Wstji1sBBuX1qGkr7VBDc6JSjl4z9d0TSaHWL/vGcG0cY+
         m6BLBH/GkY05MCP6X8Oee105vpLouP5tBB4EVn+ulKqinvehBJsLZI/weWG7q0irRwNU
         uvV2yRelyyLSuJe7gNh4vI2hYoGYgtmIlN4GhZfhATNxsTNqQDK9nS60PZx3/aGgN+Zy
         BIlg==
X-Forwarded-Encrypted: i=1; AJvYcCVIhZv4kcqFXCG/qENELlCqB/cYO8N8AzWVsDqczZVl//GoVe/vCQZs8ba080XIeVV45RrylmTnAiHdkA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8+qd7RsxYCVMpaFjDNLM3JVww2DKiHt0bikwI38AdOjYGad1s
	GBqysohvD8Vbz0FfrBN1s3OlhDplKKJJxYup/oW9WWQ+jpPbdFhuNVKnb3GnW1ZVagE=
X-Gm-Gg: ASbGncumcZa4qyIqNZU+NYjH7vaCKZ2wAVRd4TeatkGRT6cnnZWSm8mqH1NZp3jzDxD
	cwa9WH4lVZJnIAH1knaiTO+0FSA+s1M8d/ctX9a3tfT6Tu0dc7i0rfsry0EsWOQ2QVl9UWyKHv6
	3emqzASHawxLWvnHDUpgbWKc8dbMfuLjtnBJVlvETQRZfXfbXINgeegjHUbIDtBtZD1OLda4PQA
	WCh40ntmG4s1Dh5PXbvURcSGiZrDbOlgVzozuUVVVdS7BceIi8/gQXEPQVRhUdOvO6bbcavCMq9
	Dd72bchItwVezcYmOxarFkxEcEWxJLrSvve88rZZwp0++M+55UP5t3VHquIDYEohZ59uitYcGeu
	sDyOFlGhXPVHSqqvHg349rXzh07ud3CF5Bt837xsnqWyxEmaibvK12zwHIl+1ouKbPrY/AyF1v5
	1LJRJlAXJHkA==
X-Google-Smtp-Source: AGHT+IEADor3nzqp40Hdx9F6N9OjB3gQARmoleImhy/L36uc3BgyU/tmk2V0xMWPUpVDvZFzmKH9GA==
X-Received: by 2002:a05:600c:1551:b0:477:555b:3411 with SMTP id 5b1f17b1804b1-477c2ef91d3mr229822415e9.1.1764643979944;
        Mon, 01 Dec 2025 18:52:59 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce2e676esm135007365ad.0.2025.12.01.18.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:52:59 -0800 (PST)
Date: Tue, 2 Dec 2025 10:52:55 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com, 
	jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	david.hunter.linux@gmail.com, skhan@linuxfoundation.org, 
	syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com, Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH v4] ocfs2: Invalidate inode if i_mode is zero after block
 read
Message-ID: <hux2iqo5ttxuq6xn4w7zoiagti4cxccpwwzqr53rgli5oj43g2@xonpvmjnebai>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251202003209.188987-2-eraykrdg1@gmail.com>
 <5d9b1739-2337-41ad-8c92-38828c8f5c32@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d9b1739-2337-41ad-8c92-38828c8f5c32@linux.alibaba.com>

On Tue, Dec 02, 2025 at 10:44:21AM +0800, Joseph Qi wrote:
> 
> 
> On 2025/12/2 08:32, Ahmet Eray Karadag wrote:
> > A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
> > handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.
> > 
> > This "zombie" inode is created because ocfs2_read_locked_inode proceeds
> > even after ocfs2_validate_inode_block successfully validates a block
> > that structurally looks okay (passes checksum, signature etc.) but
> > contains semantically invalid data (specifically i_mode=0). The current
> > validation function doesn't check for i_mode being zero.
> > 
> > This results in an in-memory inode with i_mode=0 being added to the VFS
> > cache, which later triggers the panic during unlink.
> > 
> > Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
> > within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
> > corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
> > make_bad_inode(), correctly preventing the zombie inode from entering
> > the cache.
> > 
> > Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
> > Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
> > Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> > Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
> > ---
> > v2:
> >  - Only checking either i_links_count == 0 or i_mode == 0
> >  - Not performing le16_to_cpu() anymore
> >  - Tested with ocfs2-test
> > ---
> > v3:
> >  - Add checking both high and low bits of i_links_count
> > ---
> > v4:
> >  - Reading i_links_count hi and low bits without helper function
> >   to save few cpu cycles
> > ---
> >  fs/ocfs2/inode.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > index 14bf440ea4df..34c2882273ae 100644
> > --- a/fs/ocfs2/inode.c
> > +++ b/fs/ocfs2/inode.c
> > @@ -1455,7 +1455,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
> >  		     (unsigned long long)bh->b_blocknr);
> >  		goto bail;
> >  	}
> > -
> > +	if (!(di->i_links_count | di->i_links_count_hi) || !di->i_mode) {
> 
> "(di->i_links_count | di->i_links_count_hi)" looks meaningless.
> So if we don't want to introduce the endian coversion here, how about:
> 
> if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
> 	...
> }
> 
> Heming, what's your opinion?

clearer, looks good to me.

> 
> > +		mlog(ML_ERROR, "Invalid dinode #%llu: "
> > +			"Corrupt state (nlink=0 or mode=0,) detected!\n",
> 
> Better to log the actual i_nlink/i_mode. e.g.
> 
> "corrupted i_nlink %u or i_mode %u\n"
> ...
> 
> Joseph

agree.

- Heming
> 
> > +		        (unsigned long long)bh->b_blocknr);
> > +		rc = -EFSCORRUPTED;
> > +		goto bail;
> > +	}
> >  	/*
> >  	 * Errors after here are fatal.
> >  	 */
> 
