Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2057E25DB12
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 01:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761616581; cv=none; b=I1HH0j/SLAkCOwn5MZN2Ll00H/6UK/QxNUrkFtFGPU2kUz3ZTONGDv+Gcb/R0sT9jKfTJH4EvHEyE44+a87obH1bvRkvE3qi9I3DJDfVLuGNJJwlfpQw255HDP6F747jcdntMLAd7OsydEMpkQ6oPE6FOT6j/piOAQRsZA8541w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761616581; c=relaxed/simple;
	bh=WC78YlnpngLJ8dzJIQZhvOcsfnrBSjf1oSbV+U/pUn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YF1MO3R9OVgGaiaFxbR2CEOBw/xjKl4yNggrckN7Pdy+aiu2KOjubJ3/2e24uuj7PJqMXjBtSFqbR0WpNYOlYqxUWlyorVCevhvyOamtnYjsTfERqM6H+3uC1wy5RJgAZM/u9TqoQtXbD0uHk/9FCTviOf+I+FpgfnzBfmTWOSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZGmxDfqN; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZGmxDfqN"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42702037a01so1008518f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 18:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761616577; x=1762221377; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3w8XMz7w1nx2owr4x2gLYWNPhnazc1CyX1uPJRg5inE=;
        b=ZGmxDfqNPrsPTCFU877D0HMvu9/CikarJ8qBUWsSpoq10p5CG/Epoqn5Hqhmh1eBhP
         KZ1UJI43ctehxzJrPtQwELsAdb5KC5oF2uqO2c/FHuCnFve8C5+8pAo2RfeugJGfkYpO
         SrqvJSCCse8ujZjLjpJNSS155XAjYEY0dc96Ze9UD7pPMf8hJiv+dutKWPqLXx14ewnk
         8GqDkTDLUV9NdHgKxzJ/OZaaLmD01ERIcDs3jYtmY6bEul+TfGkV9JIM5JnlA7GoDVbr
         ZP0o+vfcWsSBUfNJumXE/2SmzVBOS5sDQrGSfOlsTwkMs/qXMAXciNFJE2j31cl5N+AT
         loHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761616577; x=1762221377;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3w8XMz7w1nx2owr4x2gLYWNPhnazc1CyX1uPJRg5inE=;
        b=kPeLdpTlKGXKvKe39+oEFrEqsDpM1jRf3GrTgqFUqMtqvX1gXv4M0mO1C84P4fyBr4
         V7FuBa5jJ8BkC8r+UOurBzZZW1q6DKf6UNtttsXtWw0eyDhAMVL0OPGYRHywzVI4Ylw7
         C+Xo8WK18faEnI33aSuE0saXoaAU2PPHfIDL4gcr6E3jD1yJk2z8MCJZCFMwTuH1qxeV
         H+ABMxy0Fj+TpAQRfgPWrGcTYRtEPBKKoWxHv6hu4ZDK+rJnVrie03XCPzlxxMEWAd8A
         bf4ilmP1/Se+5xTQIsnVLTM5fjMRfgy8U3l3DbwaR0MjXyWqq+4YrwG9jqp0wIG69HMA
         N11g==
X-Forwarded-Encrypted: i=1; AJvYcCUagS6nVKXZoMXXu0vJOUSEKG0IBjWXjmbZ+59bDEMtbWsNauWCKbiPSQWFGxb+OAUNJmGikhrH5s/+OA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1S3VW0GuJjwamUSDgYtgqcwyX2cLb5s2vCo/Zz1w6RfErZux7
	YDbgsEMvjpIjHNd+1raZjj7GUnDJF1lh2olk99W3p5F6LHCFdexssvf7B7/dOJowkC4=
X-Gm-Gg: ASbGnctEHBXc2hP4c2DxwD8Mf+hwfSejFLaWIRkV4Zx3S9DPOL76RL1wY0xrBUbyOoA
	/MKtsfN//GhV1GWx8KYAd8tVgrjWgodY1ZeaBwiE5i/ZjgurbHm411DjG8YjKgJByaLjx0fYR29
	Tvxasv4gZsC2TMttAdEZHGJFMWx83jY398T3xHzaC0mE6UCGVHBBYuxMRRnuryLGrItKDcp3CPR
	6UjKaoVHrtta77UXqQdRVrq09J3w+F4G3lx3wxLKvYKqf7pk6XtpXOBmP3xEzkgeySsVE8wa831
	2gGSFQ7YUXC8d/Hc1CkM3vC+3q2a3b9gX278/cqw/QVkIUKmcbdyt6NKiSHTHmk6QzrNG6Pha36
	SE18apxAWhK+Iraw/IpuLyna3gtYMS/dSe+6zJkZgc+qLPW6Aue+CGcQdJAnykHxNfrjz1YX9D1
	A=
X-Google-Smtp-Source: AGHT+IE4izJuOgkkxUgDEESLYGhQVPGtfgQ12YJwzExFPdsPhgQFjseb2VcSHTFOuZL7oWwU9j0qow==
X-Received: by 2002:a05:600c:19d4:b0:46e:36f9:c57e with SMTP id 5b1f17b1804b1-47717e6efe1mr7082215e9.5.1761616577281;
        Mon, 27 Oct 2025 18:56:17 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d4015bsm95949655ad.68.2025.10.27.18.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 18:56:16 -0700 (PDT)
Date: Tue, 28 Oct 2025 09:56:14 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com, syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Subject: Re: [RESEND PATCH v2] ocfs2: introduce chain list sanity check with
 ocfs2_check_chain_list()
Message-ID: <ladj6lzysyam3mqxdwgqy4f7xyxes6y6unubbcepvh442yr74x@5dfhpxdp74jb>
References: <20251027125654.312153-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027125654.312153-1-dmantipov@yandex.ru>

On Mon, Oct 27, 2025 at 03:56:54PM +0300, Dmitry Antipov wrote:
> Introduce 'ocfs2_check_chain_list()' to check whether a) the maximum
> amount of chain records in 'struct ocfs2_chain_list' matches the value
> calculated based on the filesystem block size, and b) the next free slot
> index is within the valid range, and use the aforementioned function
> in 'ocfs2_block_group_alloc()' and 'ocfs2_claim_suballoc_bits()'.
> 
> Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
> Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
> note: resend to ensure that it's reviewed and hopefully good enough for
>       mm-nonmm-unstable of -mm
> v2: bail on cl->cl_next_free_rec > cl->cl_count (the name is misleading,
>     cl_next_free_rec is a member count (and so can be equal to array
>     size) rather than member index)
> ---
>  fs/ocfs2/suballoc.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..9969a041ab18 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -649,6 +649,16 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
>  	return status ? ERR_PTR(status) : bg_bh;
>  }
>  
> +static int ocfs2_check_chain_list(struct ocfs2_chain_list *cl,
> +				  struct super_block *sb)
> +{
> +	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb))
> +		return -EINVAL;
> +	if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count))
> +		return -EINVAL;
> +	return 0;
> +}
> +
>  /*
>   * We expect the block group allocator to already be locked.
>   */
> @@ -671,6 +681,10 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>  	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
>  
>  	cl = &fe->id2.i_chain;
> +	status = ocfs2_check_chain_list(cl, alloc_inode->i_sb);
> +	if (status)
> +		goto bail;
> +
>  	status = ocfs2_reserve_clusters_with_limit(osb,
>  						   le16_to_cpu(cl->cl_cpg),
>  						   max_block, flags, &ac);
> @@ -1992,6 +2006,9 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  	}
>  
>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
> +	status = ocfs2_check_chain_list(cl, ac->ac_inode->i_sb);
> +	if (status)
> +		goto bail;
>  
>  	victim = ocfs2_find_victim_chain(cl);
>  	ac->ac_chain = victim;
> -- 
> 2.51.0
> 
