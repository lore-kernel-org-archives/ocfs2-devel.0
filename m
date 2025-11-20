Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272ED302743
	for <ocfs2-devel@lists.linux.dev>; Thu, 20 Nov 2025 06:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621383; cv=none; b=t4rYiLuSRshzlytVZU7rRLx9QrOn6Ce8MeS451/JjHAFr+QTuOuIjnHs6KDqYm2kzfEpG6mqbpXPgUMRJlizGoH5FRRxvj8EjVa+mPMNPaqkKT0wxavfdEPd2DeAcklL7Z5Rk8PC8OG2o14jdQm4HH8tbCWA48igcr2oNqMyU6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621383; c=relaxed/simple;
	bh=3CrND0QAS/DF3q1YZzN6ow2D+Tp+HP2ZN/wU1tVBmik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lb1G+otpaW7uClSzww8LxOMx2IgLwG1ZsHokWR213hnW6sDTabXe98Fc9kmFh93gsgAc7C4r1PSHfxBK+NHdCtiT7ZfgDOX4PAuPdbXU8kGWOowM8dMwQpZH9eUpVT7HS5XYm++bdEKLeDwkoW/rEewZaS4jEdYeH48JyXOXYls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L3v2DNdJ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L3v2DNdJ"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-429c844066fso74645f8f.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 22:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763621379; x=1764226179; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JoiC8yBczyCIknx4EfQw9BTFE9Lo97ErgYTwRZWjI70=;
        b=L3v2DNdJ3SodXL4+KHg6e95QvpWRYA8THcGcyF7P9WTwFCwYTAyR/+AHa+rHxywZbM
         JxYuZ49QnXT5qHUbzmo9DRKYngKlUOc2883NN/he1g/nRcCtBwPoMRDM7j9rYxk3Dqhh
         yux54CWCLYVfCwRCJHJl2lG3WZiMCyLa4JxN0C9bwn+rqvjqRNLxa5CHi4lSJgnIlKfA
         NbTO7o3XeXEui8sc81AqQLyxYVaR9jLlsxGzN271koq9MHsUa4KfT/QBpEVcPW6u6/xo
         SpPa+FV50c7/UT7NxLTOTfVT3uc6bBy8vgn5nZU08dkl0ED0t9Dlgtpzud/RGjZi11t5
         5jPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763621379; x=1764226179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JoiC8yBczyCIknx4EfQw9BTFE9Lo97ErgYTwRZWjI70=;
        b=pd/TnknXRTNNcA6/dCpuKMlAtaHcOC5/JR8MbTOsAFseFNYUkv9OeKsaVUC3GSeixS
         sIzGX4LA9W3s8is6odjClHQ7yNae51KYRxQYBaPwtGEClH/qcsJIovj7YL62RlqX28mf
         tC4v89QvNTMg8k55RnbOAWbt4xKv5+ag6+mpTtj6zBez7c/uM6WPsPjumLUvlBhj3sHq
         7Krq8PuAAx8pJsI5f/SIvIAwg5O3TVXb4PhV8M0x4pHBBBjaZ1EtpsnxV9g/lM4AFyVf
         2ICAykmzFHIPuqTvvBHVF0VSe+fRtvCnANdBZO4Do98VXfKW0XduJWoPz5xFrUYQSIud
         X0Tw==
X-Forwarded-Encrypted: i=1; AJvYcCVIdCi98/7Z/Ck3I7rXqj2XhPtIDkRHW48JoNbp8tiX+AD7CNz4fo7XkWte/yU4RXHjnZQiIq4c4vs5dw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9Vesm7E8loPA8ld7plhjam8b6Y+Xulk8NknmOETP3R+6QDzmm
	O0ZYNX8ZFBxIgnClPT/FJVk3LGTNrz0bVOrLZXNLnbWWvoQTPlm0SpiPgH8J+Vc0c3E=
X-Gm-Gg: ASbGncvZ7l7etoanEOCtv5XSl8gND5VdJP/c1ukm/k+4gQWntVV0Hp0jMpikrIpz/u4
	rUns+/i7j58trOtIkKpvJXyPdz88e25uirn7JMz4zZshDckQQ7rRTahXUo1o2CuIojSBaNbfajr
	wWMPkHjjnOdXR/oHtq8a3cUzMT2iRcVvvsNvZG9UlZJdCCRtkxj4HhjMWVnzF0daxX4RaFB3OvA
	j777oDJKCN8qzMgPC2LvfaVUS51tcyo2+EDnOM/YcOgsqLA+ourabxlcdYYVNFBRpyT0VI5+4tu
	8K6ZJe0cGfh64N7RuL5FCI6kNuL5oLdS1BImtdP07E7UrihKUdZ5dtvaza+LFgsXHYjsCu8ekd/
	s+UiZ3bTZrP+SZqOx39+zY25jdOucXAM99Pq7iZ7QLDF9qJy/wMnLfSoDEqsQTLY/wmfWzZwUba
	npTLoRf7Es6w==
X-Google-Smtp-Source: AGHT+IFFtxWzwW6+BgH47xu+shZYK/rQr7JVj11j9VUgYkzy1MFdI35do3yDhd3aWDV9Yfcx4rgGXQ==
X-Received: by 2002:a05:600c:524b:b0:477:a033:9a35 with SMTP id 5b1f17b1804b1-477b8a9f8e8mr9649835e9.4.1763621379266;
        Wed, 19 Nov 2025 22:49:39 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b272cd8sm14866225ad.73.2025.11.19.22.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 22:49:38 -0800 (PST)
Date: Thu, 20 Nov 2025 14:49:35 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] ocfs2: validate inline xattr size and entry count in
 ocfs2_xattr_ibody_list
Message-ID: <2frdco53wk4kj5x6wpfsaqm5qswvsgqa72ex7qsp3zuppltsoh@bvt2zaom5w2t>
References: <20251120041145.33176-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120041145.33176-1-kartikey406@gmail.com>

On Thu, Nov 20, 2025 at 09:41:45AM +0530, Deepanshu Kartikey wrote:
> Add comprehensive validation of inline xattr metadata in
> ocfs2_xattr_ibody_list() to prevent out-of-bounds access and
> use-after-free bugs when processing corrupted inline xattrs.
> 
> The patch adds two critical validations:
> 
> 1. Validates i_xattr_inline_size before use:
>    - Ensures it does not exceed block size
>    - Ensures it is at least large enough for xattr header
>    - Prevents pointer arithmetic with corrupted size values that could
>      point outside the inode block
> 
> 2. Validates xattr entry count (xh_count):
>    - Calculates maximum entries that can fit in the inline space
>    - Rejects counts that exceed this limit
>    - Prevents out-of-bounds array access in subsequent code
> 
> Without these checks, a corrupted filesystem with invalid inline xattr
> metadata can cause the code to access memory beyond the allocated space.
> For example:
> - A corrupted i_xattr_inline_size of 0 would cause header pointer
>   calculation to point past the end of the block
> - A corrupted xh_count of 22 with inline_size of 256 would cause
>   array access 7 entries beyond the 15 that actually fit (the syzbot
>   reproducer used xh_count of 20041), leading to use-after-free when
>   accessing freed memory pages
> 
> The validation uses the correct inline_size (from di->i_xattr_inline_size)
> rather than block size, ensuring accurate bounds checking for inline
> xattrs specifically.
> 
> Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ab0ad25088673470d2d9
> Tested-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
> Suggested-by: Heming Zhao <heming.zhao@suse.com>
> Link: https://lore.kernel.org/all/20251111073831.2027072-1-kartikey406@gmail.com/ [v1]
> Link: https://lore.kernel.org/all/20251117063217.5690-1-kartikey406@gmail.com/ [v2]
> Link: https://lore.kernel.org/all/20251117114224.12948-1-kartikey406@gmail.com/ [v3]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

LGTM
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
> Changes in v4:
>  - Corrected commit message example: max entries is 15, not 7
>    (pointed out by Heming Zhao)
> 
> Changes in v3:
>  - Moved validation from ocfs2_xattr_list_entries() to
>    ocfs2_xattr_ibody_list() to use correct inline size calculation
>    (suggested by Heming Zhao)
>  - Added validation of i_xattr_inline_size before use
>  - Added validation of xattr entry count against inline space
>  - Changed return value to -EFSCORRUPTED for consistency
> ---
>  fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index d70a20d29e3e..98fd4f3f2d2d 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -971,13 +971,39 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
>  	struct ocfs2_xattr_header *header = NULL;
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  	int ret = 0;
> +	u16 xattr_count;
> +	size_t max_entries;
> +	u16 inline_size;
>  
>  	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
>  		return ret;
>  
> +	inline_size = le16_to_cpu(di->i_xattr_inline_size);
> +
> +	/* Validate inline size is reasonable */
> +	if (inline_size > inode->i_sb->s_blocksize ||
> +	    inline_size < sizeof(struct ocfs2_xattr_header)) {
> +		ocfs2_error(inode->i_sb,
> +			    "Invalid xattr inline size %u in inode %llu\n",
> +			    inline_size,
> +			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	header = (struct ocfs2_xattr_header *)
> -		 ((void *)di + inode->i_sb->s_blocksize -
> -		 le16_to_cpu(di->i_xattr_inline_size));
> +		 ((void *)di + inode->i_sb->s_blocksize - inline_size);
> +
> +	xattr_count = le16_to_cpu(header->xh_count);
> +	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
> +		       sizeof(struct ocfs2_xattr_entry);
> +
> +	if (xattr_count > max_entries) {
> +		ocfs2_error(inode->i_sb,
> +			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
> +			    xattr_count, max_entries,
> +			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		return -EFSCORRUPTED;
> +	}
>  
>  	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
>  
> -- 
> 2.43.0
> 
