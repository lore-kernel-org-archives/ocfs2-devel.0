Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9A3261B77
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Nov 2025 03:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762832648; cv=none; b=ICajWPpBGSNr72/v5mHYFqOBW3wADMKgdabAz9mO8Rj4h2e2hdFI+FdZMtzLKhh2aaWR19fwr6xqJFJ7sMv+K4zRYwRKl8didWx1DylQwaEQqml0p3WSz2MFn7V/U6zJvmNILHhbUUjiYePNrd41bwnNs0Th4TOEM/s3xvv/tMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762832648; c=relaxed/simple;
	bh=0ZECHkUSj6g52R5EQ80fJPC8fk2deCqZl66ciVcyS1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IotA9e7TLB5PAllxWS61RSo2Knag0RBBHVDTCg2oPyn9/jTo6wvNXKPOtuBI1gaoKF6enVLTyvh+CIQNMXisXClNaXLJKiItQGuxXwyKisNWHLyFH48Nfu+CRBiPaOTrX7+Lc4sw61fBDk9CcqgOfIss5uuNeSpuVO8mN4Eem1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JCM0x/sm; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JCM0x/sm"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42b305881a1so266695f8f.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 10 Nov 2025 19:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762832643; x=1763437443; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8iPZXAZg8pQGqZG4u6J8NA9VICiZVn+zK9boW+BJKwU=;
        b=JCM0x/smLvbND0az42k5ffOrYBgvm8rtM1duby2TNvxCB4I2WB88oUfGoLytBG7Ke4
         2C9lnFatgssjNyEWJXInRWG7ikNgUpaJPcAgJVRXlclUq2D4sd0yqMU0WOgZ/aymaem0
         cRdUaiGugIHXPPp9XQcbv1T4+QDzDogRKHgNuuJqWNvu9uRbT1CUVlJ9WiK7LKYqT8Jc
         0ogj/bPimG28pYa5cpUsHRWW8YdebPbb15Nwqv/SzF4rccYDL+wEQoRjiet48Rc6KCG2
         AGQbljVxnbi8knRywXPy84WPYPPUvCKZdD+YYB6aukuDk/pEBH0FFB2bJVZFZLvLF084
         FCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762832643; x=1763437443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8iPZXAZg8pQGqZG4u6J8NA9VICiZVn+zK9boW+BJKwU=;
        b=S71HQlZ31M1tsfs0UPlhx8tSWYziO1mZuXWPsW5fwmot7eYUTXVmUM7nE8Y+r2+ECx
         sEmYwiJJCvsXKFUVRdTlhziMgXDt3pE167QUT3c8cipSEGJN3TyDEWZA6mdYayUXtj0v
         MENUcP4eyY2D7rZ48iuooOG0hIyttCz6TETlckiyg+RCBmBzk4EU/ZAlCU2pNwumhScg
         m9MVajO3+QjqnftsmUBq8XFMI+VT+DMomL8dGHWDmos/RnXvhx5fMKdeWbumup1HJtPE
         btPupVUfDTDey40f5l+atsDdNxsmf+AC6+lhmZxsv6/OjrqDqnWl+WyQ3bZlR1Wwbsqy
         6puw==
X-Forwarded-Encrypted: i=1; AJvYcCXJUwifRwlHbukF7VyJ0hbeCa49HPPMBAz8zGyg8dZsLA0iy4XbzummU5dzGv7iYGSITBIxQMDyL1b+dw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxGGbZaaiIqEBmOjTfydkQoVP3JzJb8zqfYMdL/EGLa7BPJVPkx
	WCEdbW9c3SMACmj5HsSI2LL6YE2Q7lK/ukZCAx+nfeP0MOpnXoGe5cCsu6Ueu0bzdfk=
X-Gm-Gg: ASbGncu2LCCpGWbEsVKVe0IO33wnySMmC8jN4R194xcQyIR6h3x2OF5jSZtJgBGvC7v
	7LX4FRRpfVWxor0Uu7nph0bbZHoeNBn+jgb1Z2AwZFnd+soWgaM+X6BlpHYbJZJIf22zCJaO+dC
	CClFuojFV1tLoVsD3RVm31WP4q+kWmyJtZBfpINPSKbN5fkXdLQsXwWHm2WweOaS5t4h9QDlvaS
	h4RrkPkPU3MKabOKm4ox+DmJsiejLHF9uukL4hWRLnpezSasR7jrc6oLVWu+CHNNncWCq/EHX/7
	ihlBiPuYgU11cSdDw+xP6kRnG6zzbD/GElXQj2OEKmHUPPsMplcFkJOyrguYW7uYvh/4eaPcpCb
	vpZKr2c3TL9a4XmRDc52ZFO59/ARrz54OoRE8NcNJHfHPxyCrYyo2RdD1OCmvOA+vbi7VLft+q8
	7Rxd5Bn0wpW56Y8BCFYnNt
X-Google-Smtp-Source: AGHT+IEX3tDhRdCNc6A4BdqS22VA4H5jZdKkaZYPwJQeMyXBuJuX4/SBu7LMBMgcRV1F8yhicXZQTg==
X-Received: by 2002:a05:600c:4711:b0:475:d7b8:8505 with SMTP id 5b1f17b1804b1-4777329f181mr52644895e9.7.1762832643133;
        Mon, 10 Nov 2025 19:44:03 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c740b5sm166132835ad.70.2025.11.10.19.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 19:44:02 -0800 (PST)
Date: Tue, 11 Nov 2025 11:44:00 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com, 
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [RFT PATCH] ocfs2: Invalidate inode if i_mode is zero after
 block read
Message-ID: <tocd57rydneodajmr7o2r4drjimixftcppzsbycxlwvophhxgi@jhq5lazi5buu>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108120133.37443-3-eraykrdg1@gmail.com>

On Sat, Nov 08, 2025 at 03:01:35PM +0300, Ahmet Eray Karadag wrote:
> A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
> handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.
> 
> This "zombie" inode is created because ocfs2_read_locked_inode proceeds
> even after ocfs2_validate_inode_block successfully validates a block
> that structurally looks okay (passes checksum, signature etc.) but
> contains semantically invalid data (specifically i_mode=0). The current
> validation function doesn't check for i_mode being zero.
> 
> This results in an in-memory inode with i_mode=0 being added to the VFS
> cache, which later triggers the panic during unlink.
> 
> Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan) 
> within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
> corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
> make_bad_inode(), correctly preventing the zombie inode from entering
> the cache.
> 
> Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
> Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
> ---
>  fs/ocfs2/inode.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 14bf440ea4df..d966df3aa605 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1455,7 +1455,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		     (unsigned long long)bh->b_blocknr);
>  		goto bail;
>  	}
> -
> +	if (!le16_to_cpu(di->i_links_count) && !le16_to_cpu(di->i_mode) &&
> +		!(le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL)) {

1.
di->i_links_count is the low 16 bits of i_nlink. We need to check both
di->i_link_count and di->i_link_count_hi.

2.
We are only interested the the di members' value being ZERO.
Therefore, calling le16_to_cpu() to perform the conversion is wasting CPU cycles.

3.
The ocfs2_dinode structure has dozens of members, and syzbot could potentially
corrupt any one of them. At the same time, the probability of this type of syzbot
error occurring in a real-world scenario is practically zero. My idea is to
minimize unnecessary checks.
I prefer to remove the check for OCFS2_ORPHANED_FL.

4.
It is an error/exception if either i_links_count or i_mode is zero.
The code "!di->i_links_count && !di->i_mode" need to be changed to '||'. (I
didn't test it)

Thanks,
Heming

> +		mlog(ML_ERROR, "Invalid dinode #%llu: "
> +			"Corrupt state (nlink=0, mode=0, !orphan) detected!\n",
> +		        (unsigned long long)bh->b_blocknr);
> +		rc = -EFSCORRUPTED;
> +		goto bail;
> +	}
>  	/*
>  	 * Errors after here are fatal.
>  	 */
> -- 
> 2.43.0
> 
> 
