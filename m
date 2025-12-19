Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CAA1F94A
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 04:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766117575; cv=none; b=FKosGDc69s/D4RqvoFuAgj2XYwVUyUjflTCEs7BzjnYEgPoqm7iUat/3+ltp6A73YE91xWuUCf/cR5STp5p7BlBVQVclu9MBUljwIpuPVdSo+d+EQJ43pt3tBKICyzMlyk8HuswnaB3lH56SEUVhXjJ8VCg8stFdy0SgcgzixSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766117575; c=relaxed/simple;
	bh=NwrMsDvOkw9J2tdJViOmYW3tkkIkqa0mHfJJBbqrOD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSFBLCWvVhebRNIgPWldQs3LFKsKlJ5RnqrrQ5VHMtGkZfPKDUxnCvlwd7LTW2DJBYEjNtmpVARc1+fAJfllgKZbFKeG0CPGRQJRHltpoFh6gBc3XR6pS7w+l0Lo1BCvEfl2gF1ldVt/2YrXU6BK5FzW1izarI2nAUbv2GvjQ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UlYU/bYX; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UlYU/bYX"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42fbb061a08so57704f8f.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 20:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766117571; x=1766722371; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yKOTyZpWn7kWTvvudPbS1DszXOptpmfg/ZuRduiSLtM=;
        b=UlYU/bYXBiMSO0ajMpGsXKT0ARp+XI+rEyRoCWlncRc0DHKWSPBreNF3uni5iZNqzr
         Jhzgr0HAOMNSy1qAGl2zvzPmH7JoasXQA00/11HH1JHxwGUlj28pvuckC0PjDRbc7DOn
         NMQPz0RDl2lcSoumRRMWmm+RDtbQTq+RAovtKbK+04i5z13Bc2On/j7IUSAwSArtCs7z
         fL7Y80a/vryja4J73edWUrqZoh1DRoqe9HPUWjCPffINYiEXwGmyZJ6fvjfwQB+V9pjT
         uwaxsAunxbBuspKTL4yAW2WPoYQ8ydDqnPQ/XjD35gEFSR36fbjYFpW/A03ijCmOeyuJ
         xPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766117571; x=1766722371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yKOTyZpWn7kWTvvudPbS1DszXOptpmfg/ZuRduiSLtM=;
        b=bIQb51zEtXsp1pGAcDiAGapC0aXqawjgmbmPs/YWThg5JdgPg2e1gxHyqKoPbYH0/l
         +ybN41MAlgtrJiSGTo0lXESfLJXXvlR3NZQDpxZoD3K3w/4QiuX4S41QAqWBZm05Vzpz
         Hv/wPc/jY7zwCi2Bj8/KInfcbLLTDkI2RWmcU/3qpbAFJfK3VM7pSXzcpHWjsWHWUTyZ
         Hnxgv6r+egf2S59Sz4C2dChFgTeYNdSfSihWIJhFuUADQagg1GJjQ3AEZ5y/chOoNI5M
         VZ3LedP3jCVi25/gz8x3K1jCeJjwcWLAHVWuZ4q1UPje5hFuo8xPSpaY8/iRiBcDlAgY
         pPBg==
X-Forwarded-Encrypted: i=1; AJvYcCUfQaFs0S+h7PItgXQtyOp5ydzezeO2zYzTk8euufcnDATaMf7S35VYHE6RfU1g5flVlzP3n4c+HHOEXw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzS5k6Q2bIgIMHkiOC34msEnBQCHLg4T6XSEMeZYI+I428IUk47
	jUzbx3vebZfW0OBqlbawzfoRNPkWH4WsncETRN7Kdhfj/pLf+94etz/8PZFuqwxSgvE=
X-Gm-Gg: AY/fxX6Y5PsLIWPqb6P9CBrL/llyp9j5qaO8p+cyyBpR3pYnqspf/O2eisdsz346YnA
	37WwJSL6soLyzjXghA3Pea4nNYOURIDOx2J90nL+0VDWYHonNKIBEWihYbvM+p76EszDO1iOPxm
	5zF1IlZ5ziGmMWlGNyvab5DtFNLLZBRqaCIX8OEwOCZLM6cgqjtisdfmWJQRMtzY7nxJjcnaMqZ
	4W9qddIZDDLX9eyhn6EdncMWJsQY241StCcm+mykk2NczDArLq2DyBpZDBcgNMN5f94f4E6UyVV
	iOI+tWh+9LSspap4o6JurIZS6xHeAmnKh6Xyo5twqzeGMZEw+wMbnLsVaiWLu1tZBnhdt7/u+fF
	N+g21TFlGPn6AQcEM47XiIhRqqBsWbkI3GFMVyOKedM1pkoNb0lE+YTY1hZOkGXu810IGA5iB7R
	xwIb3bEWv37PzxExh+S9t8
X-Google-Smtp-Source: AGHT+IGVw2I/7gbVQqyRAza01pjyN2BFQNtVbfc8psd0R5vJDESgOVHEH6G6AXFQsAi72kIbIqoCxg==
X-Received: by 2002:a05:600c:4e44:b0:477:9d54:58ce with SMTP id 5b1f17b1804b1-47d19531c76mr6798815e9.1.1766117571150;
        Thu, 18 Dec 2025 20:12:51 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c82858sm7803745ad.29.2025.12.18.20.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 20:12:50 -0800 (PST)
Date: Fri, 19 Dec 2025 12:12:47 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	mark@fasheh.com, ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] ocfs2: fix oob in __ocfs2_find_path
Message-ID: <5wws3jiutruexkk4wl34wootqtfggj2h6ezrbemvtn7ykgsumq@3komfzq36st4>
References: <693fd627.a70a0220.33cd7b.00f4.GAE@google.com>
 <tencent_5EA7DB86C912FD065749A52EC12EC94C8B06@qq.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_5EA7DB86C912FD065749A52EC12EC94C8B06@qq.com>

On Mon, Dec 15, 2025 at 10:09:32PM +0800, Edward Adam Davis wrote:
> Patch d358e5254674 modifies the definition of the array l_recs, specifying
> the number of its members as l_count. In the path shown in [1], it will
> first read the inode block where the system file directory is located
> from the disk, and then read the l_count of each extension block from
> the disk according to the extension list of the directory. Then the
> value is 0 before l_count is read. If the array l_recs member is directly
> accessed, the oob in [1] will be triggered.
> 
> Use the rec pointer directly to access the extension block number to
> prevent the oob reported in [1].
> 
> [1]
> UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:1838:11
> index 0 is out of range for type 'struct ocfs2_extent_rec[] __counted_by(l_count)' (aka 'struct ocfs2_extent_rec[]')
> Call Trace:
>  __ocfs2_find_path+0x606/0xa40 fs/ocfs2/alloc.c:1838
>  ocfs2_find_leaf+0xab/0x1c0 fs/ocfs2/alloc.c:1946
>  ocfs2_get_clusters_nocache+0x172/0xc60 fs/ocfs2/extent_map.c:418
>  ocfs2_get_clusters+0x505/0xa70 fs/ocfs2/extent_map.c:631
>  ocfs2_extent_map_get_blocks+0x202/0x6a0 fs/ocfs2/extent_map.c:678
>  ocfs2_read_virt_blocks+0x286/0x930 fs/ocfs2/extent_map.c:1001
>  ocfs2_read_dir_block fs/ocfs2/dir.c:521 [inline]
>  ocfs2_find_entry_el fs/ocfs2/dir.c:728 [inline]
>  ocfs2_find_entry+0x3e4/0x2090 fs/ocfs2/dir.c:1120
>  ocfs2_find_files_on_disk+0xdf/0x310 fs/ocfs2/dir.c:2023
>  ocfs2_lookup_ino_from_name+0x52/0x100 fs/ocfs2/dir.c:2045
>  _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:136 [inline]
>  ocfs2_get_system_file_inode+0x326/0x770 fs/ocfs2/sysfile.c:112
>  ocfs2_init_global_system_inodes+0x319/0x660 fs/ocfs2/super.c:461
>  ocfs2_initialize_super fs/ocfs2/super.c:2196 [inline]
>  ocfs2_fill_super+0x4432/0x65b0 fs/ocfs2/super.c:993
>  get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1751
>  fc_mount fs/namespace.c:1199 [inline]
> 
> Fixes: d358e5254674 ("ocfs2: annotate flexible array members with __counted_by_le()")
> Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>

First, the commit id d358e5254674 is incorrect, the correct one is
2f26f58df041bbcf692730ff4d8ab0f250d9670d.

All __ocfs2_find_path() operations occur in memory, meaning there are no I/O
operations involeved.
From the error msg "index 0 is out of range ...", we can deduce that both 'i'
and 'el->l_count' are zero. This is an impossible scenario in normal volume.
Therefore, the syzbot may have crafted a struct ocfs2_extent_rec where
el->l_count is 0.

I suggest you use this patch as a fix:
https://syzkaller.appspot.com/text?tag=Patch&x=14eb331a580000

Thanks,
Heming
> ---
>  fs/ocfs2/alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 58bf58b68955..1ab0b9095a7a 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1836,7 +1836,7 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
>  			    break;
>  		}
>  
> -		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
> +		blkno = le64_to_cpu(rec->e_blkno);
>  		if (blkno == 0) {
>  			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
>  				    "Owner %llu has bad blkno in extent list at depth %u (index %d)\n",
> -- 
> 2.43.0
> 
> 
