Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B84C1422DD
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 01:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751246813; cv=none; b=RdBnjcbAUfaekINHgPL38wmbCM+5SPVAE4dc+nrWFkXxP3QX79dOh+yRygb+abiTqz3Fwx9JTO7THbRCYfgm6AFURnzkWvPM+VGnL0shSbOCwewsVXz9ayVMBxadr/P+sVxiJdo3quTTvDztugMoKRFKbTnp534n+KA33/7LHok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751246813; c=relaxed/simple;
	bh=OaGhSavxgehz1kxRS4bQjLJGrxCBBHISqRgUIQdbHyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=STCC1qDLFJ4mZlFmZlxrYzDlLKKYMYyLYA0dzxvqi0lMiMds09roZfbiBoj1HNwshaI0NCTMd9taWK57Yv2H0QnjM8MRCkRkDtKNtM3dHm9MAwyVc46j1szx5VoH4GlrnSE1eRVGgWfTui41rQIAmv5pdOm13o/OAmomNpmtoeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EUckvlZm; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EUckvlZm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1751246802; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fq6cIu+dmFZv0xYGNfLmiRHpzV744XSYtX95GIPUPHU=;
	b=EUckvlZmsi8J9l1hxej5/6Z6f4e8QBJLFf/fqXbr1+U2bEfRHnPD8agRinlJveb+9/lWgiRsFBI36Y0MbAaT+OYgWiG+DjlCZgdwk1jF5Z1rQmlnrGecOQsqk5WrDPCWgF66SPcYUUcfbZ0xgGyoewgu9Y9R/EM5X4k62Ve1adk=
Received: from 30.221.128.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wg2L7Fz_1751246801 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Jun 2025 09:26:41 +0800
Message-ID: <d6c72ab8-d600-4cc2-9609-8b749b61703d@linux.alibaba.com>
Date: Mon, 30 Jun 2025 09:26:40 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Avoid NULL pointer dereference in
 dx_dir_lookup_rec()
To: Ivan Pravdin <ipravdin.official@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
References: <20250627023830.150291-1-ipravdin.official@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250627023830.150291-1-ipravdin.official@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,


On 2025/6/27 10:38, Ivan Pravdin wrote:
> When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
> error message that unconditionally dereferences the 'rec' pointer.
> However, if 'rec' is NULL, this leads to a NULL pointer dereference and
> a kernel panic.
> 

This looks possible, but syzbot reports slab-out-of-bounds Read in
ocfs2_dx_dir_lookup_rec(), not NULL pointer dereference.

So I think it is because it construct a malicious image and set a wrong
l_recs, then access this damaged l_recs.

Thanks,
Joseph


> Add an explicit check for a NULL 'rec' and use an alternate error
> message in that case to avoid unsafe access.
> 
> Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/67483b75.050a0220.253251.007c.GAE@google.com/T/
> Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
> ---
>  fs/ocfs2/dir.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 7799f4d16ce9..dccf0349e523 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -809,11 +809,17 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  	}
>  
>  	if (!found) {
> -		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
> -				  inode->i_ino,
> -				  le32_to_cpu(rec->e_cpos),
> -				  ocfs2_rec_clusters(el, rec));
> +		if (rec) {
> +			ret = ocfs2_error(inode->i_sb,
> +					"Inode %lu has bad extent record (%u, %u, 0) in btree\n",
> +					inode->i_ino,
> +					le32_to_cpu(rec->e_cpos),
> +					ocfs2_rec_clusters(el, rec));
> +		} else {
> +			ret = ocfs2_error(inode->i_sb,
> +					"Inode %lu has no extent records in btree\n",
> +					inode->i_ino);
> +		}
>  		goto out;
>  	}
>  

