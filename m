Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D92D3597F
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 05:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736141404; cv=none; b=aY77P+Pjx8H5ZNuu1C0ohQDiCYGxQwUDTanpzmgBMsD94IjbIIo0l8vUoc//zRCcNpGL4loGJV7bZ+poc5v+gtSUKkZiiC0Wo1WDnZ1PP+fqsV3OF+8Odx2pnnf4kaXE80leiB4GXMIweifDHwd2l7YTxh8neJq3IrjfZcJnoio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736141404; c=relaxed/simple;
	bh=KF/u/9UgFotwN9BrVOEDT7Oru9ylam2azEVo9cwnSXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mZXqvW3WGuneg1zUeczIu72vZD0+gsnmbTpdFvDYzIP3PMhxH7D81IA/lgGh1gpRjDi7ZtmuDrBeE+91L5AEuNM+oIWWuJYAEAmciXQ2j7odZ02QjN6eC+5RQvojQSzbJeuKABSHRCwisf6P0R1yAaKeu8Xqwqc5NPevK1xyMpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wKQBMy4C; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wKQBMy4C"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736141399; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GPlcn8HNoUOUUKyziEL52W2EgQEOIprXLQ5wbxza3Jg=;
	b=wKQBMy4CfC5tG3S0mLfIKJr4wuObDVlyHzZl02dKWMKhgB5B2/Hzj7PDTpXXsox12DXO/eKoyl3StHYs0me43F2lbzKucbX4oVisEB21n4xhXsgnaw6ZP+2MKDy0E8KTR/dp0HGY/06zWT8stiz5pMo3Y3Ji53hDCX3jPUImFM0=
Received: from 30.221.130.9(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WN-J-St_1736141396 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Jan 2025 13:29:57 +0800
Message-ID: <1e00e9b9-8600-4e30-af00-748c8545353e@linux.alibaba.com>
Date: Mon, 6 Jan 2025 13:29:55 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] ocfs2: Check el->l_next_free_rec in
 ocfs2_get_clusters_nocache
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org,
 syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
References: <20250106023432.1320904-1-sunjunchao2870@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250106023432.1320904-1-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/6 10:34, Julian Sun wrote:
> Recently syzbot reported a use-after-free issue[1].
> 
> The root cause of the problem is that the journal
> inode recorded in this file system image is corrupted.
> The value of "di->id2.i_list.l_next_free_rec" is 8193,
> which is greater than the value of "di->id2.i_list.l_count" (19).
> 
> To solve this problem, an additional check should be added
> within ocfs2_get_clusters_nocache(). If the check fails, an error will
> be returned and the file system will be set to read-only.
> 
> [1]: https://lore.kernel.org/all/67577778.050a0220.a30f1.01bc.GAE@google.com/T/
> 
> Reported-and-tested-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=2313dda4dc4885c93578
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/extent_map.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index f7672472fa82..930150ed5db1 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -435,6 +435,16 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  		}
>  	}
>  
> +	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
> +		ocfs2_error(inode->i_sb,
> +			    "Inode %lu has an invalid extent (next_free_rec %u, count %u)\n",
> +			    inode->i_ino,
> +			    le16_to_cpu(el->l_next_free_rec),
> +			    le16_to_cpu(el->l_count));
> +		ret = -EROFS;
> +		goto out;
> +	}
> +
>  	i = ocfs2_search_extent_list(el, v_cluster);
>  	if (i == -1) {
>  		/*

