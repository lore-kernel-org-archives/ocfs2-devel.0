Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EA9F9D9
	for <ocfs2-devel@lists.linux.dev>; Sat,  4 Jan 2025 09:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735984764; cv=none; b=LkUFeuiBzZVhQ7bwi9DFBBUmIZrA6id99MLEC8shFB/pVVpUgUWiF1k/emiQbT4mBOQXncEyYSQHB7CtWAnKXswPtdyrfFEMP34xSkCcBhdMzexsK7OwEAbCBOg8HsXzcawrCYs9l7Gvue1WleqwVWyvzcKGLT2HX9XG/KyVGRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735984764; c=relaxed/simple;
	bh=NMcP58sJBpw2GMaeITtT6O54K/fUQiAVoblDSyrcu/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xd47OZVCVHvMyFYQ7zWj5iSiUe2U39Ix2VL1DAMFmrGFd8JU9MU12G58bWcfYBAFkYdDHYZdWzfqlEA2tlNS8K9jxov3V6OJdgd/uOCC6IAb7aYVYNS4VihTZk0nUNR3ucylzUMMZxcbW4WHGG51doaQkZ83L+ZNx7xtydpDVwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gTIgtoDx; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gTIgtoDx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735984750; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HfHOtOEPeb7kRxkw9MsLoZGoQKa/hSb4SrkkDTBoUs0=;
	b=gTIgtoDxfMApitF3yMX9zwVJ7JQSG+ulQ+D7Lkdgjr9nZEsX8of4iQv+EqygB4vCDkOci7gAtuBvJ/xqyCwPsDs/hhsTM4CY/CcKFpLD6crDpvepyVbsbmb4RmH7OUhjYc2B1RDCWQF7N6Jhwr+YgalkiYMaIdWjPEV26+yoQmY=
Received: from 30.120.143.131(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMvcno3_1735984749 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 04 Jan 2025 17:59:09 +0800
Message-ID: <165bc833-b756-431f-a08b-bce5c77aa4ed@linux.alibaba.com>
Date: Sat, 4 Jan 2025 17:59:08 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] ocfs2: Check el->l_next_free_rec in
 ocfs2_get_clusters_nocache
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com, jlbec@evilplan.org,
 syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
References: <20250103131226.1262042-1-sunjunchao2870@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250103131226.1262042-1-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 2025/1/3 21:12, Julian Sun wrote:
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
> ---
>  fs/ocfs2/extent_map.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index f7672472fa82..a326c08d9145 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -435,6 +435,17 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
>  		}
>  	}
>  
> +	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
> +		ocfs2_error(inode->i_sb,
> +			    "Inode %lu has bad extent next_free_rec %u count %u in block %llu\n",

Inode %lu has an invalid extent (next_free=%u, count=%u)

> +			    inode->i_ino,
> +			    le16_to_cpu(el->l_next_free_rec),
> +			    le16_to_cpu(el->l_count),
> +			    (unsigned long long)eb_bh->b_blocknr);

eb_bh may be NULL here, so don't print here.

Thanks,
Joseph

> +		ret = -EROFS;
> +		goto out;
> +	}
> +
>  	i = ocfs2_search_extent_list(el, v_cluster);
>  	if (i == -1) {
>  		/*

