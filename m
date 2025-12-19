Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C87126B2B0
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766125925; cv=none; b=UJu8y5FTtkFMGx+4zT6jp932CThG8D1sJ4yHls58Eh0lb5DxCoIvVVa6eOW+QDnrHYH+FLsapReYtNzzW4/rKE3OGmRFOjBYfv1PNhdIsaoPVQ3+NK4vxtBhfdsJXGM18FXbR5VFvdqrcHOk+P6KkuqLqvnCuKpuJoiItpWyTLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766125925; c=relaxed/simple;
	bh=EzoKIrYkxcb2va1J9lG2lfBqsxjMdLlUf2eTeoEco9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/4dPbEQ30YWsBRCWfj7SAH//Use9Sw9UDTEV6J1N1pW1yJd3ZV7wP1DjkbbGmpdAGM4eIq4j0MLd+e+bwmWv2t5ru2Wq9+FrXPpugQqD/C8+4j+7SxjQz9pWxmFHibFaK6OfIB6Yux+9BYghhqQ9r9NNlXZQpVsEJIx1XxS5+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Z6YVh/Pf; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Z6YVh/Pf"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779b49d724so2463905e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 22:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766125921; x=1766730721; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkzqWwjEsYvdNgO1Jjw2dYslyLnjwkCq5dpCUnPunEU=;
        b=Z6YVh/Pf1Oi1yFHXmzUfsRcnsP8k5mGDD6ilXjC4GdMZBRc/s6XtanPCupQyq6j8Bd
         s9Nsml2o6oeRHaQgzhuwtM7Ox+4wSrwq00E0ijjt3gDhPyVUvXPLgwmBIqmThR4U0DlA
         9ygLJHGuzcQEZi+5B0gd/KzxZGqMpSso+r8np+ujEvK6eRdTzDEzo5lBZO3BXJzEZJ7q
         rIWXYEfYzIJqgl258S+Snw2Ly1hnd8fWOpfRkEOyiQXRi1AWyQvh2FcI5Amk1R6NRKcj
         ZwlnYkurF9Elu73nU2i9ZL+Z88qtUafrq1SluPC4EBCqC4y/1oXsPc4NTI6lQ++bySjM
         5nsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766125921; x=1766730721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZkzqWwjEsYvdNgO1Jjw2dYslyLnjwkCq5dpCUnPunEU=;
        b=d611d0kkWaxCVO+kifatq0B5SNsUbKyNe1b9XGazyeIxhzEuUs+zm8gEfxsIP7qJyL
         FfgQoMddDWkbbWpr8U18Wh6cxQjqzazON7raPTkatxHAjIRkyLk+GpOaAMRMY2Q9GqOC
         qwNt/PwpjWnorp8bzqjlUNJ34h9hSWhghHuhBka4Lc8aU1Magg5qjOYAxAj4v+cLenZG
         8K9ly4lzBC4qTc1xEpTcIOtVT28vTKUXRZhwbWWbKrIJAPBXTDGDWf4JK5P5YbUjawBJ
         I4nbKxNXD9it09uD8NHI1ygWPQNkShCcCQW5DtzyuznIj7kwMhbxxfDOjdKer3I39vGW
         9xhg==
X-Forwarded-Encrypted: i=1; AJvYcCXxJ1Z7SAcuVZua4i+yQD5oiwdJdW4cBhlq+sToTd/d8XAeOjvdwVNvqTBEyjJnVnL/Nll/qbs7S+NqCA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyNIR/I2GRLUXhJ9Vj364Us4Z8/AC1YQJuFRN2QvFRvFEzesbIY
	dqQzCKHS6x9y1cJPvG//EZ42J8t4CTRQrDKJVIa5/fny3HdpN6rzX5JYjoRecmrIOHD6aWCYk1D
	WYy/N
X-Gm-Gg: AY/fxX5JInF3+ldY5ir7i5kg4LCJBW86BtENhkggdiFIykaebmPyII0pFh82QHzAZDj
	9efLsWFavayKcRVwxg+HXoKhm7bFNZYO6IAf/t/mKazjEpN1AXnf3VNDwv8h3xea5PquTaIRvJg
	Q4IeXwE/VFtIa9GCU+poH61CfCJlahGJcXt7zonXr2pY5VwvjQ5tIvzyj7mbCWmYndWKiPWICvS
	29q5Ev8ejJm9GPAVEoHihlvCpPzBL2aUVzJ5L/ZTasJoYjrlt2RBsJ/CXMv/fTPNaapU1ftGbc+
	N5Cit2dReE4Rz3bOaNpXHL3NlcJXSANms6iRXCnoC+OtImD+QBmKv/9Po/6glf5Li+WgLHwNTk0
	qixYNRUgO9db5cMURPniOf94Z/tdpIIz2Cd6N3uwSEpRb4wsGn61mE0aNq53S6HkMsSpMDnmEBC
	vepQiSa3SZyQ==
X-Google-Smtp-Source: AGHT+IHpMCY6WsfTSWVvDF7rpIUmgY+q9b2BVYMlXsbu4wnGW1wURIKXr5Le1INPlrZqhVsHBKIAVQ==
X-Received: by 2002:a05:600c:3151:b0:477:a203:66dd with SMTP id 5b1f17b1804b1-47d197f69demr6514365e9.2.1766125921180;
        Thu, 18 Dec 2025 22:32:01 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d1b8sm11680225ad.68.2025.12.18.22.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 22:32:00 -0800 (PST)
Date: Fri, 19 Dec 2025 14:31:58 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Edward Adam Davis <eadavis@qq.com>, dmantipov@yandex.ru
Cc: eadavis@qq.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v2] ocfs2: fix oob in __ocfs2_find_path
Message-ID: <rb73ttkcynklsuqf4nf6qg265v2sjun7p6g65cmkai3pzekpai@3ntwvmr34tsr>
References: <5wws3jiutruexkk4wl34wootqtfggj2h6ezrbemvtn7ykgsumq@3komfzq36st4>
 <tencent_585DA45DC5993F4FCC0DA6A5F38DBD921207@qq.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_585DA45DC5993F4FCC0DA6A5F38DBD921207@qq.com>

On Fri, Dec 19, 2025 at 12:55:06PM +0800, Edward Adam Davis wrote:
> Patch 2f26f58df041 modifies the definition of the array l_recs, specifying
> the number of its members as l_count. In the path shown in [1], it will
> first read the inode block where the system file directory is located
> from the disk, and then read the l_count of each extension block from
> the disk according to the extension list of the directory. Then the
> value is 0 before l_count is read. If the array l_recs member is directly
> accessed, the oob in [1] will be triggered.

Please revise the commit log.
I noticed a mistake in my previous email. While __ocfs2_find_path() does issue
IOs via ocfs2_read_extent_block(), the claim that "the value is 0 before
l_count is read" cannot be true in this context. All data for struct
ocfs2_extent_list (el) is fully read from the disk before the OOB issue is
triggered.

> 
> The loop terminates when l_count is 0, similar to when next_free is 0.
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
> Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
> Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> v1 -> v2: check l_count and update comments
> 
>  fs/ocfs2/alloc.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 58bf58b68955..44bbc51276de 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1812,14 +1812,16 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
>  			ret = -EROFS;
>  			goto out;
>  		}
> -		if (le16_to_cpu(el->l_next_free_rec) == 0) {
> +		if (le16_to_cpu(el->l_next_free_rec) == 0 ||
> +		    le16_to_cpu(el->l_count) == 0) {

please restore the code above to my original patch. Since the value is expected
to be zero, converting from le16 to cpu endian is a redundant operation and
waste of cpu cycles.

- Heming
>  			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
> -				    "Owner %llu has empty extent list at depth %u\n",
> +				    "Owner %llu has empty extent list at depth %u "
> +				    "(next free=%u count=%u)\n",
>  				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
> -				    le16_to_cpu(el->l_tree_depth));
> +				    le16_to_cpu(el->l_tree_depth),
> +				    le16_to_cpu(el->l_next_free_rec), le16_to_cpu(el->l_count));
>  			ret = -EROFS;
>  			goto out;
> -
>  		}
>  
>  		for(i = 0; i < le16_to_cpu(el->l_next_free_rec) - 1; i++) {
> -- 
> 2.43.0
> 
