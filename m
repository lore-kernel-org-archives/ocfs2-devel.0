Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87C428134F
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 07:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766131159; cv=none; b=ZYc2J9KEBEyBgYaazEcd0xAfe9hZ6uLbFPpB1sZRF3Dmz6Po6nt1bX8ICLUD7XRv+5nModDah3hKoc2IaHMRZ8GgoNksmK1TSPWj8Hxryk/oBBV/DS6eC0Ul983AcOinS0+JRrpWtkBF41T7HRnyRr45D1Kw75wNc1gnEgoedAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766131159; c=relaxed/simple;
	bh=XX7nTxSaswGEWV1Uel3RQuHQ5YzuwJ4dHK2YBqWA82o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKW4nvw5SVg+MpM9wDC83OCpkZfO++VzM5SeuneJN+z1vRSKLJgelkoJ04ayyhhhtcRpFf/mU5hgBHp/XpCeXKRO79G+vo/Xc03Y0kU6vKWojrgkUN3wug+TojB+kMQcFY51whOc/KxrHWz/uNyssTPMrnkmz1j61YS1ZoSHhuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ClGVReoj; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ClGVReoj"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477aa91e75dso1688315e9.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 23:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766131154; x=1766735954; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z6V7T/dFVaPJI9Lo/9Kt1n+/HvC7y4+d9kElFV5QZPo=;
        b=ClGVReoj1ZOsX5jNjbMJ8r0PqDDqDQzlYydGwFobY7zVKQpBKMnOAo9Rk0xNzkBI4V
         9XUrkTUHlJHHgEJIZ9xqXZQ4RJhqTBhrpT343GjrnMzEHbteIgkVebsO2vcA+GNRks1A
         LItVYKrlkom31N+WHIdrXSU6NzxokAUIiPgNYrJmzZ0Z1aZHhgiXDXP/aN+47N/C5jsj
         3/r0rBRJbFPcxifTFJ2ze5uh5g8uzNiMEJ86ANGtdU41hoSuW3htHOCH3YtcnHAcOCtE
         ZbLPXwxNJQwvozwgPWf6iJsFpE++R9K229sy92AM3QC9q9eSaa2+Qz062ul05r2bz2lw
         wC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766131154; x=1766735954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z6V7T/dFVaPJI9Lo/9Kt1n+/HvC7y4+d9kElFV5QZPo=;
        b=hNOYtUiBJdgS0LZWsmeVYAPgYeXJpCsHoCoXldvt05nlXhyiYpeDNfZ2I/olxf0g+W
         emCUn2DF2+k+hlu0XfYCLpni/KlEf/271Mh7Zoofc5iyzu8LjN9eaYijpi4IaSCXHmKf
         rhfHjuWVnDetE5uOHHjTqgcFzPS4kxm9FsauBVM+zzqGemQWXt9CI0ejKYTRhB8EtTvb
         jAMrstNzq2hhIbJTaI4mGHOXwDXajXPSs8JPmSpWVJFQIs/KwB9CgzYt3HZt02mdjKLV
         ufLwounhXEployVJoSNaySuHVoCHnM/6rXbPnWCFfL2rQ6IzncBl8Gv1uvI6sR8CmidB
         ZyLA==
X-Forwarded-Encrypted: i=1; AJvYcCWsAHg/ZcniX0sTh1UR7BDOc5jPx0GmdcedQZ63uRIUvY6zXYuab7C4vuHdps88gqkLaxHJf0pzvwPULg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzqrDPdTrQ9Gq09tYeJhCR5F+m0Eu2mOim5aQ+o1p/FMZGPo99C
	Y1d0Bnn3BEu2ekVIt5m2bRQuaJNQpaDwBi06fHDbcX/03fJZirrO3VgXjLBzyZEXHSI=
X-Gm-Gg: AY/fxX4irXqq3NOWfip2YGZJMpY1hFkQoy6x8CD8p9uup6MrdRETOlbP1JFXHqUBdTl
	UNyz4RPWwjgiL4VJpV01RRRb4NqJcIXtvhJai32Wkbt5gVli0sgwR40qiFgQszKKTlKHvhvkbtb
	b9qYwCPM3LajvAuwakFfcSnrMWLnOGTrVLxAnp+J6OZPftDMNDcK+fxQGp2GH7shdbqpcee2PTR
	nfhgdPcGlUhGWICNUmos/9xtnJZ88M1p3cisgz8OrWHX0v4Wj+4C++0EXRm5HDQ6UO9oEUnxIKj
	KfDbpsSRGgkM6exa7rce7KXlOMKRd+kiQMNAnjEnhwcPc0tL9RNPcAO/aKLbytZ+VAJXsVg8jS5
	dfLUxAvoAzwWo86RCw3KBmLDJwR/DpAEGNQhn3A8dEOAMpERhR6UZPmDw6012JkN1eRYIJClyHU
	PTq83xWLwZ/w==
X-Google-Smtp-Source: AGHT+IFj2GBnJecdMkQWJslAk2fVOpJ9EvTtLmGhPRgCu8ZltBUoOIZyj110CbuAWkuiZ2g/hAPhIg==
X-Received: by 2002:a05:600c:5251:b0:47a:8bfa:bd5 with SMTP id 5b1f17b1804b1-47d195aaff0mr9687175e9.8.1766131154058;
        Thu, 18 Dec 2025 23:59:14 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d6d557sm13985135ad.84.2025.12.18.23.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 23:59:13 -0800 (PST)
Date: Fri, 19 Dec 2025 15:59:10 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Edward Adam Davis <eadavis@qq.com>
Cc: eadavis@qq.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v3] ocfs2: fix oob in __ocfs2_find_path
Message-ID: <rwy27v6h3su6i7osrb5aelexurlg7ggbzeedv7bghuwhe54uvl@nfwl3p5xugwh>
References: <5hyc4g4g6uxix5jncqi7ukhmdzq6xoxvou5dkvpj2o5y6v7zoe@qgvucbpcvbqn>
 <tencent_72C97EE3BCA443F77C776D46CAF36D436E05@qq.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_72C97EE3BCA443F77C776D46CAF36D436E05@qq.com>

On Fri, Dec 19, 2025 at 03:43:32PM +0800, Edward Adam Davis wrote:
> syzbot constructed a corrupted image, which resulted in the l_count
> value of the root element being 0. Since the length of the l_recs
> array depends on l_count, reading its member e_blkno triggered the
> out-of-bounds access reported by syzbot in [1].

for: "which resulted in the l_count of the root element being 0"
This issue occurs not only in the root extent but also in every node of the
b-tree. It's better to use a more general description, such as:
which resulted in el->l_count from the b-tree extent block being 0.

- Heming
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
> Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> v2 -> v3: remove le16 and Fix tag and update comments
> v1 -> v2: check l_count and update comments
> 
>  fs/ocfs2/alloc.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 58bf58b68955..b7db177d17d6 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1812,14 +1812,15 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
>  			ret = -EROFS;
>  			goto out;
>  		}
> -		if (le16_to_cpu(el->l_next_free_rec) == 0) {
> +		if (!el->l_next_free_rec || !el->l_count) {
>  			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
> -				    "Owner %llu has empty extent list at depth %u\n",
> +				    "Owner %llu has empty extent list at depth %u\n"
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
