Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD623CAA55
	for <ocfs2-devel@lists.linux.dev>; Tue, 29 Sep 2026 02:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790650777; cv=none; b=P7kNatGJi08MQUBsywECLAPfmJGKz5fZ6fOsyFihZ/CYYaYByhwrdnycC+tg7JpquUkC2F4Xo5unRcH/xwfkCy+yXNxBl5PL7Vp2awU2drNxuNN+iSctId5kDH1wKw1MVq5wRvq9Xqgku6+u4zb5msb1UY4IEfHfH32v+q+tB84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790650777; c=relaxed/simple;
	bh=LL1eMOxoibboDf2sqy283DenGQo0UIJfc+tQH5HrZm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jnMpmPUUR6b2I7kvXKbPiBi/0qmISZmUWuJpHTrM3rp4Gghyr9JDtU12JT+RZC0N1ud1js0crkmdd1H2j1HJZnwt5PdFRX/bMC0ZjJlWiCxJeeGUxHSDyaQlJS1+D7iDn8xpsfOK4qYGCDuo6RwWrEUOhIb5kq/NpP7qwCfjFVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f8MJTdNZ; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f8MJTdNZ"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b93204449so2579105e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 19:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790650773; x=1791255573; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C0p+hB3kZAdlvGeRUtCIMr+NV0GRwVEcUScE2UAkvn4=;
        b=f8MJTdNZJEuV1Pf/MmInu/sFwJsD1xofIGEsFBsQsx7N128Az4qftZP3l1NXlRluz2
         B4m/TZqIPPZUqpTTeI8EDv7xeg/blol115GQjw8QhwHn+zXG2mu+ZMWvoppawf+nBACa
         GXUbzOdEZIQyWSznQCaJ4KdVfaCByS2xMP2miXer/eXgUzy2mHtRg/c2kfNy68xEWaOI
         v4qmdH662m6fYky/OGHaPUO1a+OR/JXuDTVHRxRuTApOGCNatXaU+rdMVJ3s1GozuK2d
         iUyV58/ORmYPN+u57pa68qBe3pZRj6hXmDc4wCrjlxwqql5J6r7RyYXNxv4aepWdxn0Q
         qUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790650773; x=1791255573;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C0p+hB3kZAdlvGeRUtCIMr+NV0GRwVEcUScE2UAkvn4=;
        b=TtCLJfwVESyWQCWfAiqko6N5j1AjhWkgqhmCTiueeWAtVUIJ5y91b67T33bFf+nv0O
         pnSf1Azrl7NgtMScMnrx/ar/lW5Hv/OsN43+PDc2ihJ/bEesBrP96RGUzMaha6YNlf8C
         BrLL0oB6278oz/3fInDfTNRXJWf97VzfhZwvJr5OE2WckStK+X4Q2hLkh7FUrAipdLUo
         IecaeQQ+kqxVBypnKGKbN2Gf65Xe7Qt8Hvi/JaIjfmTxKWn/Mzi/P0dD9lp6L1tkvHiW
         xoPZbJK6wcrLYPGS7s/JZBf4SkyCrj8V/FKBIbCaINEWlPJ7az5E1Ous1zL1jLOI+4qG
         fXvw==
X-Forwarded-Encrypted: i=1; AKwUvBxkDeYLHmNc445ylUAl5zLfbHD45ZgjySH06+MxuFykRd9b8b1xLBgWJjRpxWm0CS1Zqz0F012E2ACqIw==@lists.linux.dev
X-Gm-Message-State: AFuF++lCNYrp3Dl6s7YNd3yKH1FIF37drmvL4aRn/sH/7I1KEQA/elvx
	727WQVHL2rgMT++mWoh/FkRkFo2mvHDzEaXN+LtZtcr1pMDWJo1CyAktBr2srfw6k+I=
X-Gm-Gg: AYBFou25w6atK/cQbyKvaJ/O394bASbEJuF4TgEFdWjHd3gm2PmiojqQW7zMFsFXtVH
	D+Cx35wK0zpiSphrbezYgZaXVEcixaz44OY0e3HpMpF6nqPkciudgVuJ8RP/es3xVd098Bd/DnR
	XwJmG6/QVBTygPjvjtRNMVC6/Heng7gIH99cg7NYcxCIWBwCPc33BaPyY8KI/X1WiRiWsxMRmRx
	lRG7rXJieVJEjGuAfNxpSfTq+o5un66cG+T8R8wEdyE/t12bfeuxkrYaWlKW309TQndmrgk5AD6
	6vgDcCMOTqbsZU2vGHNXDmSWm8WztW1J2u6Xv9dd0VCUKCzTUBPT1J77o4bIts/a4vhZX4qLGlr
	PmrvxdI8L9q3r/nUoXy76VB0XyUs92KCpJ14MsWDYSH7FAND+u2JEHkCcNH097bGvlZHrX96Ang
	iQHbmiAPzIUE0rwdDtVPOHHu8IbScLkFnxbSG/w1RF2WiPcJIRafc/SwNep4SVF8SfiTsX
X-Received: by 2002:a05:600c:548e:b0:49c:f9b8:bae0 with SMTP id 5b1f17b1804b1-49fede023d8mr200822235e9.2.1790650773345;
        Mon, 28 Sep 2026 19:59:33 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e2b4bc736fsm15265955ad.74.2026.09.28.19.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 19:59:32 -0700 (PDT)
Date: Tue, 29 Sep 2026 10:59:29 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ginger Li <ginger.jzllee@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: Protect local_alloc_state updates in load/shutdown
Message-ID: <arsnHB6Ak3q4Ztsn@p15>
References: <20260922060048.13158-1-ginger.jzllee@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922060048.13158-1-ginger.jzllee@gmail.com>

On Tue, Sep 22, 2026 at 02:00:48PM +0800, Ginger Li wrote:
> My static analyzer identified a potential issue in 'fs/ocfs2/localalloc.c':
> osb->local_alloc_state is documented as protected by osb->osb_lock in
> struct ocfs2_super, and most of the code follows that rule:
> ocfs2_local_alloc_seen_free_bits(), ocfs2_la_enable_worker() and
> ocfs2_recalc_la_window() all update the field with the lock held.
> 
> ocfs2_load_local_alloc() and ocfs2_shutdown_local_alloc() update
> local_alloc_state, and local_alloc_bh next to it, without taking osb_lock, so
> those stores can race with the reads and writes done by the local alloc
> reserve path.  Those two writers predate the locking convention and were
> never converted.
> 
> Take osb->osb_lock when updating both fields.
> 
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
> ---
>  fs/ocfs2/localalloc.c | 6 ++++++
>  1 file changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -342,8 +342,10 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>  		goto bail;
>  	}
>  
> +	spin_lock(&osb->osb_lock);
>  	osb->local_alloc_bh = alloc_bh;
>  	osb->local_alloc_state = OCFS2_LA_ENABLED;
> +	spin_unlock(&osb->osb_lock);
>  

This function is triggered during the mount phase. The la (localalloc) is only
active after this point, and the fs is still in the initialization state, so no
inodes can be created. Therefore, we don't need to worry about any race conditions.

>  bail:
>  	if (status < 0)
> @@ -392,7 +394,9 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *os
>  		goto out;
>  	}
>  
> +	spin_lock(&osb->osb_lock);
>  	osb->local_alloc_state = OCFS2_LA_DISABLED;
> +	spin_unlock(&osb->osb_lock);
>  
>  	ocfs2_resmap_uninit(&osb->osb_la_resmap);
>  
> @@ -441,8 +445,10 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *os
>  	ocfs2_journal_dirty(handle, bh);
>  
>  	brelse(bh);
> +	spin_lock(&osb->osb_lock);
>  	osb->local_alloc_bh = NULL;
>  	osb->local_alloc_state = OCFS2_LA_UNUSED;
> +	spin_unlock(&osb->osb_lock);
>  
>  	status = ocfs2_sync_local_to_main(osb, handle, alloc_copy,
>  					  main_bm_inode, main_bm_bh);
> -- 
> 2.43.0
> 

When the code enters the umount phase, the VFS layer ensures that there are
no other references to the fs, so no race can occur at this time.

At last, if you have reproducible steps, please provide them to help us
understand the issue better.

Thanks,
Heming
