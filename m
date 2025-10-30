Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB0A337B90
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 07:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761811162; cv=none; b=lTL2TBiI8rhx77p3qY7cnRf+KcBO05qvil5c5LIuKLSRVY6MW4NyATM9W/ifoHK+cqAAbEtfE9XNNAOtUsJv9jnVm0v+kXH4SUAM77UUSwGNw31zfYcq1vZ+6CGxmKErrSAbhIhMfiPyunyat9GywuuedXK40zntnvWS3vT93NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761811162; c=relaxed/simple;
	bh=p9Kbtdf4LrBZJvlhGyrQ8xwNEm/z9oCOyc3wRrZl5os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DzqLK9mPgYWHelQptoRhACUVuOYZPpgkIZD2+ioU76/elkLOC2jJWcIaNSzwXI8YUhIF4TgszI7pFF/8z9DKMIhZ2EMCElBRBkFCtPOnHVmstB6MaXaK5sstqQ1nw672aHYya3g3QUw+Q891EeCZ+UWQkbWycFpLr6uaIIrEQcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gch/rDTY; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gch/rDTY"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-429a8a27db6so116048f8f.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 00:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761811158; x=1762415958; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IIoxsoXYWqm4Xf1ajsdITMeQ3bdYTIRud5Xrl/r9fQ4=;
        b=gch/rDTY3+oNeJE3js1j7HLqxOoII5aNg1KQqjP+R3wktQbXuU8giDdTEf6TW/fOAC
         kEYfm9EqlvKZlHZ7Bpqg10+RjfJhac3Sm3UvK8QaGhYw0wvAATBNXh6XUQr/J3RbYXhO
         qAIO1feNiM2MoUUHboixwAiwPtvyEimdTdI2+YQ0FGkdASRPGPGRP7a9YuBP7rb/kyGm
         r9Jqm0QdbaUSSdRS6d67AMFTw4s+ly3KJGbPfFycaqr8VMOxmuSePmp7RqQQ3DmhdWOb
         gsjvJssYSBu51mHAA/3N5QSLS7vn+IZbePhUXgJtJ77T5mabgSARvkk4egCecd4YYE++
         gH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761811158; x=1762415958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIoxsoXYWqm4Xf1ajsdITMeQ3bdYTIRud5Xrl/r9fQ4=;
        b=SASGVv9gtPKIkviwMBAZ3s4YY49AlTb2TP+BfTBock6tGtpiqPI8ibE0/XjAuwl0Gu
         U0Xs3+SSAxN80M8axM0SRKQcbkm0kCOFw8nCCAsKLrS25tBOHLvAtB1Ty958XBWeHbQW
         sGPUAIEvARrAq5utk0fgR2hRiRhyn+kDRBNKQGyzLSYhrEHvA4/WdteQoXgK0rXcfuON
         MCjXR4zrTCVKLGK91LPndZ22EhRsNa+kFlrPXoFEk1Wy4DzR06TU7Ex+JnQGynxdf6Qd
         KbyiH0My+G1ZYS8ljZFN2D68BmzuS2EsUXXSuwBZQgGUJGQOAgHHA8tvprsbTyqCUoBd
         84Gw==
X-Forwarded-Encrypted: i=1; AJvYcCW7mG/V4wjOtCGk4eMa6yU78qrz7y54GYEzmvTSaMJgts+VfjfnWoBTs+Ec7dsz8wWqVqjpaWDr5Oc1Sg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyKfW2TBQSBiZd4TUQh2/UmYkarTe4st1jmyf1LnZmOS21OgUG1
	9ldrFPW6edzZTuwQRcYXCQ0EQLqPQx1yofPNSkdwItS/srq0CJ+xT5ce5XWHdx6rlQI=
X-Gm-Gg: ASbGncu70UPzuthskj/eWFbJpuZYWJpwUmPZsdFSYaGjZ0qVPNK2siGpHn/qtNsbSgM
	VnyedLMmeQm1l0FyeofSG1zuOsuiITf5QLXpufFj5+MKbMOeKwYeR5bT31mbf5PQLJg60jyzql9
	Wd5/NgKCpRDBMsf46IpCiYAj7tEOT7FbBGg6YTEpwHOGozWB8urAmr2rWx8HtttNHsHa1xGXgWR
	+TVFY0Jm71Zw99jDl1zJJ524Xq8ZDgZ9mL4TREELxXGTcHvKKjs1PtHe3EmI5uEKexMx+EPWmCl
	A9/cAZP4DiULdAYLgO+bW63E1pD9cjsQidpdlQ+xdAnYfqxC2hAFAv24L2b5DE2txKMHVqMb+ay
	4z2BtKA7kOBj7D9nXuxcCTO+D+or8Vgu0vKizRDbs/qV6huEi5o53EHc3pbL6EiDrAXJuy3sA+a
	M=
X-Google-Smtp-Source: AGHT+IG7qoNWxeH56TLe6+Z4Mf4ydyY551FTBsYsB9Zop338tCPTa37NEB0x1rOcV0kV8iiRB6Eptw==
X-Received: by 2002:a05:6000:26cf:b0:426:ff0e:b563 with SMTP id ffacd0b85a97d-429aef845a1mr2544640f8f.3.1761811158290;
        Thu, 30 Oct 2025 00:59:18 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-340509894c9sm1616343a91.7.2025.10.30.00.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 00:59:17 -0700 (PDT)
Date: Thu, 30 Oct 2025 15:59:15 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com, 
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure
 during read
Message-ID: <wzykonhpj76qowdn24inwtaji4zfclesmc3lqnnc7cn6jkyjl4@oauagnarupov>
References: <20251029225748.11361-2-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029225748.11361-2-eraykrdg1@gmail.com>

Hi,

In my view, combining this patch and another patch [1] is a complete
solution for this bug.

According to the oops stack, the FS is already in read-only mode.
We should forbid any write operations and then perform the inode
sanity check.

And I think ocfs2_validate_inode_block is a good place for make_bad_inode().

[1]:
https://syzkaller.appspot.com/text?tag=Patch&x=1287f614580000
- by albinbabuvarghese20@gmail.com from:
  https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072 

Thanks,
Heming

On Thu, Oct 30, 2025 at 01:57:49AM +0300, Ahmet Eray Karadag wrote:
> Potentially triggered by sequences like buffered writes followed by
> open(O_DIRECT), can result in an invalid on-disk inode block 
> (e.g., bad signature). OCFS2 detects this corruption when reading the
> inode block via ocfs2_validate_inode_block(), logs "Invalid dinode",
> and often switches the filesystem to read-only mode.
> 
> Currently, the function reading the inode block (ocfs2_read_inode_block_full())
> fails to call make_bad_inode() upon detecting the validation error.
> Because the in-memory inode is not marked bad, subsequent operations
> (like ftruncate) proceed erroneously. They eventually reach code
> (e.g., ocfs2_truncate_file()) that compares the inconsistent
> in-memory size (38639) against the invalid/stale on-disk size (0), leading
> to kernel crashes via BUG_ON.
> 
> Fix this by calling make_bad_inode(inode) within the error handling path of
> ocfs2_read_inode_block_full() immediately after a block read or validation
> error occurs. This ensures VFS is properly notified about the
> corrupt inode at the point of detection. Marking the inode bad  allows VFS
> to correctly fail subsequent operations targeting this inode early,
> preventing kernel panics caused by operating on known inconsistent inode states.
> 
> [RFC]: While this patch prevents the kernel crash triggered by the reproducer,
> feedback is requested on whether ocfs2_read_inode_block_full() is the most
> appropriate layer to call make_bad_inode(). Should this check perhaps reside
> within the caller or should the error propagation be handled differently?:
> Input on the best practice for handling this specific VFS inconsistency
> within OCFS2 would be appreciated.
> 
> Reported-by: syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> ---
>  fs/ocfs2/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..415ad29ec758 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1690,6 +1690,8 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
>  	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
>  			       1, &tmp, flags, ocfs2_validate_inode_block);
>  
> +	if (rc < 0)
> +		make_bad_inode(inode);
>  	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
>  	if (!rc && !*bh)
>  		*bh = tmp;
> -- 
> 2.43.0
> 
> 
