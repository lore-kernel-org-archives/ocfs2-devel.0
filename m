Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A4313B293
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 10:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766138836; cv=none; b=EiulrsDE+TyF+g8IkfTbV/wZnNkuTnFQv/DXbqlYlFbpipmPpz5vwnFN0eNaxemMM8zQZcelIIrb2VOPDVZZWwDCEftsnpVtucYZuBI6VF1CQ9luRRVSp3W4+HXrDnEkjuygewTMagrIyPfiux3ubailvhlqamSt7V9iUJkFsIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766138836; c=relaxed/simple;
	bh=w0acv45mrSqqE2QDc9QI8x3sL2lcsNsWZsXR8k69Bjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=reFFUN3tIptP0kKLNedlPQYITDYTOb3X1lB/+GBfKg9RcGSMqB9COxvHbXlKZkcF+OLOOs8f30U3ch8KhadBmN79JEzO5/IfCjQsbUOEiT3YDk4LlUgNPpImPBbD5mxWbdtoVOmca1u5BJppGrI5/B6t9Wx1TzZobQOYsX9/Dk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KdfLyFcv; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KdfLyFcv"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-431037f7c0bso94431f8f.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 02:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766138833; x=1766743633; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B5n7onjDe75aIfEYgFDw9TZLNfmHGRJZ+wxGKC60BEo=;
        b=KdfLyFcvxbjKH0Df34mWnoydjwdylZG89y2tiHpmn9zQ44poRtA1Tehd2QAqolPuYN
         31sWboFnPcElpk87rS3UDmb9EoEQjQ2JEiGMdsfuXWxCB2+VRco3qXsWZXVueA1t7CZs
         yApif+UEFjn77HH1OTWsPiBYyy94Sx+HTZJFMX5e4THkjDJimCeukKtsPY0bY0d14Nxd
         /BNXMe+GgzCuaJXme5GRFRvk569v9BflxMxNaoIMVduI+GQUHMroslMa4J6mdqJ035KS
         Kd4s5ospjnDgpsJiBz2RMPDED/bARfTXpVdMlY/AvWzxQCGmvOuKIKjv+ykugPski6wN
         GrWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766138833; x=1766743633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B5n7onjDe75aIfEYgFDw9TZLNfmHGRJZ+wxGKC60BEo=;
        b=XBoi6J/OKg43tg/nv9pJAVEyeEKbvmlL9NtIM3laYTecngupZwMKl1/NgCjtwkiVY3
         VT0a+0kMcv71xLxDEXGHfe1wkzZpHrVpyiwAp2n1uEQPzQ3wOVMglZ54iXxgQvloa7LA
         UKeSYvLmwb+0W0/pUz7CJXvHOONa1UTBV8FQ2PjqUWRJvg8ZhirXe4Tde2m36JOWTQgt
         7x+MAhgaCx3b+fD2mz8DzUe0Ooa9JFxeWN58xCvlRUhQAwO/h262WcBYkaKjegsT724C
         JWcCpVoWKH0hOx/ucM68aKWIr1KsRk2H5mhd0XJvqhGlQL91pyESqjEByzcusVXdRKZ0
         hdUw==
X-Forwarded-Encrypted: i=1; AJvYcCU7DtNdz7Cj0OlMSFLVvFkivpkCrnhsPbxf0Ykl2TGhWcR9qBSzZcOiL46/ubryATZ/VGXolKPtjk/wVA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6V1MbgjLS+vbuoos5hmI2vq9Su/5FUv9XCEs0ukrFf1FaMW++
	uzGQBWC4k52Nel+xLhWPQHCAlmKoXC/j3UAREUmhqqe6MLDlkj0PgH5k7vghM2GrPjw=
X-Gm-Gg: AY/fxX701/q2XULhMendevMweOgf+chRFhtFWeD4YpuYmesOkNzq6kPghMG5FBMBdyE
	/BaFAz4wRd9J3/BJOgTC5dLCmdsrmqJiIp+M719o+vy15IGWnxsRr5m4yzw8RgwbZhq1M75/wkU
	azS3uXHSbvv9niWf/oqH3DlY6HiU49g4YXHmClIQDa2IdbkCo9WxbnppUsnCIx5nAZet87+7WdV
	HXl6t+mz02A2eDXKlP6EPdH9LOz70FHQlBYF7R0qCpNfF728v/DFxAu29xlTVqQNkfUy5fQgmEY
	LFw+SQA0tsKAppzyKUAzzs+DOhDb/oo6nK/i9k/Z679HVcw/EsqpD8e9PbGH73ssyLbFhUMVj29
	7f28qGcvbmW9QZWhaLCQ5tBxWO7wYWft1JHeygcj3ZexWS2cVmhwmKUyDoNsbxLJooqCzikZKUc
	XvSvY+jh3zkA==
X-Google-Smtp-Source: AGHT+IH756snRTSuERbGefsMuUKkfqOrmGZePcU5FUQpGxX4ebhuri+I/2aMQZnIiMBJwWPm3MP7oA==
X-Received: by 2002:a05:600c:6348:b0:477:7bd8:8f2d with SMTP id 5b1f17b1804b1-47d195918c8mr6935725e9.8.1766138832477;
        Fri, 19 Dec 2025 02:07:12 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm18405075ad.63.2025.12.19.02.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 02:07:11 -0800 (PST)
Date: Fri, 19 Dec 2025 18:07:09 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Edward Adam Davis <eadavis@qq.com>
Cc: eadavis@qq.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v4] ocfs2: fix oob in __ocfs2_find_path
Message-ID: <2v5rwkwevjoy2i3kwcb6s3zvyutp5zdcwwdnqbgukxn35aeu2z@abmakzczn45z>
References: <rwy27v6h3su6i7osrb5aelexurlg7ggbzeedv7bghuwhe54uvl@nfwl3p5xugwh>
 <tencent_4D99464FA28D9225BE0DBA923F5DF6DD8C07@qq.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_4D99464FA28D9225BE0DBA923F5DF6DD8C07@qq.com>

On Fri, Dec 19, 2025 at 04:31:52PM +0800, Edward Adam Davis wrote:
> syzbot constructed a corrupted image, which resulted in el->l_count
> from the b-tree extent block being 0. Since the length of the l_recs
> array depends on l_count, reading its member e_blkno triggered the
> out-of-bounds access reported by syzbot in [1].
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

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
> v3 -> v4: update comments
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
