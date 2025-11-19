Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9424F2E62C6
	for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763566590; cv=none; b=TgZtyN9Z3GEYLTJNaAW3Uvs/ljwi4CyI52UpnQojvQtsv7laa60tIndKTmV3nKOhG/ETDs41kXC9U/GuttAWp1c6Tj5nsgWbq8kM0+lfjqRda7vfDqSZGoI2wWfzHsoqo88ECQZlk9YSQfS4Xlr3tz3kBJpepUyp0fcQrSTVW7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763566590; c=relaxed/simple;
	bh=tjDOJOCMoToZCXrKn+XQAXCtPv+T1F09h5TSllNIhUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wn8elHISq9q9X17cxdAa06WSckoF5ZHVLvTJOu4NkvHVHC8Cxp9HFhajT/zm/zLY1k9Uisrq6dScUbZeypr+r900DNbvDN1iH2KsKTKnhcLp6ugIpJDP91lR4gXcfQXIgb5yjH1pRafeKoL3+jfNn8ohFbXxi0lhpbUuOAvLefM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VzJO5gWc; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VzJO5gWc"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-429cbdab700so716411f8f.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 07:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763566586; x=1764171386; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V4dCEIkVE3aCKgoz50yV7mi5CpZI8BY081Fwxjt8m/I=;
        b=VzJO5gWcZN1va+6DgEsIDUGGCMbTIzO+LcAH5Vsy0tdwW2SSgEhynpfmPLjLbkTqeD
         tDGVy3s4b6fUxEeJhOc9PnrXyTMFcz5+bSU5zetdfNc6kQsrmtkKUY2CecHJyl2Wbk/6
         tDin+IPsn3EZyeYi48iotszxGI+kwg/bQg/Bp36jx3hnaqF6yCH63c+96gw6lsi5Epgi
         PEfWoScmDOGlT40iIlGJxk9GT7+X3F9H2aMiMJjNAVpqg8FEiitz5t4dAqm3mcZIkM2U
         tBDajyUK+UBx5oZiyL6z2hSlC5iszWccV+w4JrDlxxw3LgiFTUgSckVNi8cImc9nZmbc
         pjpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763566586; x=1764171386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V4dCEIkVE3aCKgoz50yV7mi5CpZI8BY081Fwxjt8m/I=;
        b=N8qD7QSI7JOUluW08gjlh9Iavs3FGAoONbLek6WPLa0Pw4HeWCKLK2xQo6T1n81qHw
         LnG5r/UzOZPYAvPg8lk+75X4f9PFPeOBAeXEcp58ANa+B1CHtrjRw5ri5D8CZURM0lwK
         nWmPEaKsW0ktcTjNNbVDqBTYZg73YPUY+86zDhUSmeWCgDR52hivB3EbfAuutUL2vWwA
         Lvl0zyAz3TLWFHaJ+BJZ1qTLBNylrT26SsPQeUVt8eEuhbI6tbnIcMQJI376s9nTgxCH
         YDFikuuPm2qzCzRGFyHVN0Ik8UkuN6ErPvkU8pgtvNB2Pc3XJHykL0A2/uzSdeyt/5xT
         AjGg==
X-Forwarded-Encrypted: i=1; AJvYcCXVxe2WCRO9UkxvW3JYhXcXKFNXy8secRulm+9VxSEja0iyllE+QB5PY3J2iAO0/Qs4BOx3ERTJxuoZEA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzE3k1BuH70MWwqKM7hZGP7AcJOIgZJlvK8NG1pHd7eGkoB/d0K
	GhHRuWFsgJ8IbBPmkyahQvb1I38VKMZdpiFDFwT7R5pk2lGL5pMyETZSjKd6AMkrbcPzmOC8Gwj
	1JcZ8
X-Gm-Gg: ASbGncteNT9Fw0v+AlcuxliWnpKMaT7y/H38+WLNxwqQr7Qplkr93wbViULCewsySEe
	9U8T9UCodeDhHSc2u9Mmql79qaIXec/adBWjW5/IDvi4GmvH4pnaE+Oxf65VXCsTN2+Wgp4h4lq
	s2D2C6W2GsO8k6X5VVObtyYjssMfAWv9z5LrTIX0k1DaiB9NdVndQMQqyvvYysvMNE6eF5nRp57
	ahLlW0VcTwTjdhjjUrTetuST+L1Yn2OTMMf1ARs8ij/a5I1dwqDtcfupeyJzLdQiQCPQe5rX2WK
	U1ZQjFNgWHyAljE1m99NIn45Tu2dLQwquitJgr49wu+vh3L4MThCMr/IcmDMZHqFWJPiUC6zC2E
	0rUSYoIU/VvaY1h2ZGpOTNGnDTZ2HUKHExmmoj6f+mkNUPQNjSQZ8gtKVLFnKAiQbYAfc5e5FrH
	MmENi768gyvw==
X-Google-Smtp-Source: AGHT+IGHid/xFOIP7XmJ8s2DUweLDvAhac0nHeW0x2LKa3R3D6GOH8v6DgVJCa/HwE4PIrYpblgYxw==
X-Received: by 2002:a05:600c:a4b:b0:477:7bd8:8f2d with SMTP id 5b1f17b1804b1-477a9c4f2b9mr35533085e9.8.1763566585524;
        Wed, 19 Nov 2025 07:36:25 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc36db22439sm19423578a12.4.2025.11.19.07.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:36:24 -0800 (PST)
Date: Wed, 19 Nov 2025 23:36:21 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] ocfs2: validate inline xattr size and entry count in
 ocfs2_xattr_ibody_list
Message-ID: <ef22zw37ifljwla5ifbtrgjrx35gnifqi5lcaxfgabaeydbmco@zbc2eulbbmea>
References: <20251117114224.12948-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117114224.12948-1-kartikey406@gmail.com>

On Mon, Nov 17, 2025 at 05:12:24PM +0530, Deepanshu Kartikey wrote:
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
> - A corrupted xh_count of 20041 with inline_size of 256 would cause
>   array access beyond the 7 entries that actually fit, leading to
>   use-after-free when accessing freed memory pages

The following patch code is LGTM, but I can't understand the meaning of above
xh_cont:20041. Please show more details for the value 20041.

In my view,
the sizeof(struct ocfs2_xattr_header) is 16 (by: 2+2+2+2+(4+2+2)+0)
the sizeof(struct ocfs2_xattr_entry) is 16 (by: 4+2+1+1+8).
when the inline_size is 256.
the max number of entries for inline mode: (256-16) / 16 = 15.
therefore, the xh_count of 22 (by: 15+7) corresponds to a value that is 7
entries beyond the boundary.

Thanks,
Heming
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
> Link: https://lore.kernel.org/all/20251117063217.5690-1-kartikey406@gmail.com/T/ [v2]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
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
