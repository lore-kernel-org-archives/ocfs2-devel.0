Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9643317709
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 08:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763367191; cv=none; b=ISej3rDwNaZIq/laF1ylfo1/79FFVrYGlqfLcqqbpDVj21jdo0BtYCvkqCslB3PgpalmJ30O8W+PRV42lDM6hH+EQT0qf7GjnvOMcQiVcVwbhkmiTWNJLW/6NXR46ZH5FBd4cctQ3mCehjFaK33Oq7GbXjw6FMI1Ln9rPacWcpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763367191; c=relaxed/simple;
	bh=Xq7TPOHGz5d604UDdtH0bw8EsN+zxDikLZ/ZplqggUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XP9BCMjMHFQInVCeVfVEl9xYCKRB2YdVpru3ds03/hiHQkAGi+cD2u9x0Mg8xy3KDKpHQRZ1cxy8b2KDIIZRKWzvWcNF+p/42dh+fcGpqE/Cy1iC4419f5eTw/2zOH2RkE7xUYfoA6rzMQTkIaTYo6HB0uf+8PE4Gr3UdwadafE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JkJpNZKx; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JkJpNZKx"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4779c9109ceso1012005e9.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 00:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763367186; x=1763971986; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t156GkdszmaigIWuYYpkJ4xGyc9wNprDGTMaKhSzixM=;
        b=JkJpNZKxOuKAkEsfgdyZgaswUQScLLXnJ3icEhrL+oBvFAQZ3ejtA5hmXP/1G7e/CE
         RYcxtvRFJvJXXiNFYnfZlXO0Dksj6S1Jhip1q/3hWu8MzVPzqSE2DeQOgbS+40TC6kRF
         D95LZ3SmRmCxrvR+M6s28SaMX3o8J8lawP/UhuOoPbOtk5bdUVIxTrfsI86R7KkOgSy6
         TM/oXrhUk8zqoG9J/36j34lV9v6Wlf0g2di1KTIkbvFcEVohnYk6bI9KQPVAEGrUjbuT
         jDWlY1Kw9X7Sf6G1IVtIlmGnIQrKI6nKdwSVKVMjGYgpzHA42GMq5sIySC/rKsE0SR5m
         t7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763367186; x=1763971986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t156GkdszmaigIWuYYpkJ4xGyc9wNprDGTMaKhSzixM=;
        b=RrPQgMqqfiDO8LHWIt05MQ9IPK6+snEys6GTV0zNxEKEOgtCkhodHFOVwYklvtQudk
         BGzi/2nA3QaI6kcYLf+H6Gq7mDgKMZ38NP2bae1rYV2ECNOltJJIelRbr7uMefVMR2kD
         6TaWJmUZ1BwGiZleYpCnZ4vpiHm9/+IqH6HoB7lQGaKBrbgsBn3ZngAidgA4ObUjvOim
         lKRcouPCKWYQKaXZSzHaif27QxlFEkwXowC6Lb+Gh5gzjqgQhhef/wyB5CMf3gfJTljE
         p6BaAfmXH7DiCfuCsk52AgHkVch16t7d4LVJzeYL+wobzdSZxhiFasbg0eckF76pVHV+
         QsOA==
X-Forwarded-Encrypted: i=1; AJvYcCVumYADmmydz+R46z82oMIsuja4KQ9ZDjQjlikSqXAz2QOgHimXrUMrXWZejIBI54fGkcq++N9mixSbag==@lists.linux.dev
X-Gm-Message-State: AOJu0YzXuAYfh9xO1J/Pjhl+PoobaqXvqR4mRop0IW92S7XH92iV4juG
	WlhRCI8JbsiQQzCCrawpvs2x9eSRaY/FlDOkoQOB0uZ9WkSxorwtHByrVhBmEXszAfU=
X-Gm-Gg: ASbGnctDwYK/0Y61qwWlKaz9H8geKB08sqYTewbmTtdkhda1KgenG/zKGhPO3CP8Ol+
	g1EMhrFGmOou9tSuI1ACXuD+A6i/ENrL0RmZaRw8kLRZvGq6tfqqW4hNJ4nba++HMOnb/RXcWps
	HxQD6RzBJAThxNXI+Bzg70GGfQ1nRbPF344KIC0TOB12cY4Bih0uoDf7/b9dpGlL212FWyTlVhX
	ttf5xdLDE9I6FLqR6lDcvvY6nxW/Nndkk7Hmpkgr8vvFG7jKYm0t0IwseJo0L6a89KwTgKR1Yed
	aRUY7qEklpuIkOsutvd9c1LaIYPdhag1fBeXZnD8LaeuBRss1OBG2C6JvnxeN+GdtiermaccCGc
	nBoVAyXZoKWqZcSOVgQ2+RV2lbVDWFaNjoEwspF+xuM2ABLNJyCniyBBN+AKcL4etGE5NrmuVWq
	s=
X-Google-Smtp-Source: AGHT+IHdN1QTwtUgyAzrb74SWt/OyIHux24yryGsK0JJaws5UqKH7l6X7apkaXXcnzVmeOigoRfm5A==
X-Received: by 2002:a05:600c:3ba9:b0:475:d7b8:8505 with SMTP id 5b1f17b1804b1-47790286666mr71226025e9.7.1763367185548;
        Mon, 17 Nov 2025 00:13:05 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343ea600620sm7792504a91.0.2025.11.17.00.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 00:13:04 -0800 (PST)
Date: Mon, 17 Nov 2025 16:13:02 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ocfs2: validate xattr entry count in
 ocfs2_xattr_list_entries
Message-ID: <yiza5dit6fgkeoshpqptaqyuohxup7n2jtmdasodblp6voi7qa@66pgsjaykg73>
References: <20251117063217.5690-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117063217.5690-1-kartikey406@gmail.com>

On Mon, Nov 17, 2025 at 12:02:17PM +0530, Deepanshu Kartikey wrote:
> Add validation of xattr entry count before accessing entries to prevent
> out-of-bounds array access and use-after-free bugs. A corrupted
> filesystem with an invalid xh_count value can cause the loop to access
> memory beyond the allocated block, potentially reaching freed memory
> pages.
> 
> The validation calculates the maximum number of entries that can fit in
> the available space and rejects counts that exceed this limit. This
> prevents the subsequent loop from accessing invalid memory addresses.
> 
> Without this check, the code directly uses xh_count from disk in array
> indexing operations like &header->xh_entries[i], which can point outside
> the block when xh_count is corrupted, triggering KASAN use-after-free
> detection.
> 
> Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ab0ad25088673470d2d9
> Tested-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
> Suggested-by: Heming Zhao <heming.zhao@suse.com>
> Link: https://lore.kernel.org/all/20251111073831.2027072-1-kartikey406@gmail.com/ [v1]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> Changes in v2:
>  - Changed return value from -EUCLEAN to -EFSCORRUPTED for consistency
>    with existing xattr error handling (suggested by Heming Zhao)
> 
>  fs/ocfs2/xattr.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index d70a20d29e3e..f7341e3d8a6c 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -928,8 +928,23 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
>  	size_t result = 0;
>  	int i, type, ret;
>  	const char *name;
> +	u16 count;
> +	size_t max_entries;
> +	struct super_block *sb = inode->i_sb;
> +
> +	count = le16_to_cpu(header->xh_count);
> +	max_entries = (sb->s_blocksize - sizeof(struct ocfs2_xattr_header)) /
> +		       sizeof(struct ocfs2_xattr_entry);
>  
> -	for (i = 0 ; i < le16_to_cpu(header->xh_count); i++) {
> +	if (count > max_entries) {
> +		ocfs2_error(sb,
> +			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
> +			    count, max_entries,
> +			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		return -EFSCORRUPTED;

The errno (-EFSCORRUPTED) looks good to me.

Sorry for my carelessness in reviewing the v1 patch.
It seems the patch code only handles the xattr inline mode. For the xattr
extra block mode, the calacating above for the max_entries is wrong. 
Btw, even for inline mode, the codes are also need to be revised. Please
check the 'header' value in the caller ocfs2_xattr_ibody_list().
For this syzbot bug, you can put the sanity check code in ocfs2_xattr_ibody_list().
For the extra xattr block mode, ocfs2_validate_xattr_block() seems like a good
place to put the fix.

For the minimal code change to satisfy syzbot, we can just put the santity check
in ocfs2_xattr_ibody_list().

Thanks,
Heming
> +	}
> +
> +	for (i = 0; i < count; i++) {
>  		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
>  		type = ocfs2_xattr_get_type(entry);
>  		name = (const char *)header +
> -- 
> 2.43.0
> 
