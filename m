Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6013A1EE7C6
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 05:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765518603; cv=none; b=REneAQK7ae3VUmVK9p/foPAuwrFR7ZNxtIVNfwciGgB66knT31JuZzf8Za1/OkSxPb16NMWZ5MNT0FwWNM/wN8YB0t5zXYFOub1Ib4baVP2ZOVp1CozkmbAndiPvMS3sVgUVZoJkwrGKiOOGovf9hrjXRT0Bzac8JqG98FojfMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765518603; c=relaxed/simple;
	bh=R/6GGPpNT9Q99jNBUqY4Uufj/LxHU4Y8ccvg1futXY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EWOTmKpW20eoGvtutgk23iqLTapyOcDLTp5Mz8KKpNKzNAMy4MMzQtJfW4hnE1gw6ko4Bs9qrkZ+Vw1BRKWvUTvYa83+PlLSr63bevVy1EOVoS2mn3MGTHHeiRDoVAo/2zMr14FEwieLreM3eRRodqfnAsb5EuuyXgdyJkAO20w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fgr7j9UD; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fgr7j9UD"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765518591; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MfR7kuQ4sF2AFGdIxMpIVVaMkIrhNOQOu5vxnO/+ijc=;
	b=fgr7j9UDN09uEJ8LKBSIpB3d1YIH7eu5GvaQhYApErn7ndvfDp1vb0SJ6LipHrmvsF850toQCbvIz6QuIBDwCZQ66ZAVFbJ4jGS8bnK4hzfquMZ7ntgjJrBzlxlXxq0CnBTustohPgpp596pPoJz/dUyDrE5l4z7q3uUDX+FpEs=
Received: from 30.221.145.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wud9asR_1765518590 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Dec 2025 13:49:50 +0800
Message-ID: <314374af-5b3e-4d34-88c8-4bb2323ad5d5@linux.alibaba.com>
Date: Fri, 12 Dec 2025 13:49:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: validate inline data i_size during inode read
To: Deepanshu Kartikey <kartikey406@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, heming.zhao@suse.com, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
References: <20251212052132.16750-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251212052132.16750-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/12 13:21, Deepanshu Kartikey wrote:
> When reading an inode from disk, ocfs2_validate_inode_block() performs
> various sanity checks but does not validate the size of inline data.
> If the filesystem is corrupted, an inode's i_size can exceed the actual
> inline data capacity (id_count).
> 
> This causes ocfs2_dir_foreach_blk_id() to iterate beyond the inline
> data buffer, triggering a use-after-free when accessing directory
> entries from freed memory.
> 
> In the syzbot report:
>   - i_size was 1099511627576 bytes (~1TB)
>   - Actual inline data capacity (id_count) is typically <256 bytes
>   - A garbage rec_len (54648) caused ctx->pos to jump out of bounds
>   - This triggered a UAF in ocfs2_check_dir_entry()
> 
> Fix by adding a validation check in ocfs2_validate_inode_block() to
> ensure inodes with inline data have i_size <= id_count. This catches
> the corruption early during inode read and prevents all downstream
> code from operating on invalid data.
> 
> Reported-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c897823f699449cc3eb4
> Tested-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/20251211115231.3560028-1-kartikey406@gmail.com/T/ [v1]
> Link: https://lore.kernel.org/all/20251212040400.6377-1-kartikey406@gmail.com/T/ [v2]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v3:
>   - Folded new check into existing OCFS2_INLINE_DATA_FL block (Joseph Qi)
> 
> v2:
>   - Removed unnecessary S_ISDIR() check since OCFS2_INLINE_DATA_FL
>     applies to both directories and regular files (Heming Zhao)
>   - Fixed checkpatch.pl warnings
> ---
>  fs/ocfs2/inode.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 8340525e5589..77f73fa663b7 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1486,12 +1486,25 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> -	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
> -	    le32_to_cpu(di->i_clusters)) {
> -		rc = ocfs2_error(sb, "Invalid dinode %llu: %u clusters\n",
> -				 (unsigned long long)bh->b_blocknr,
> -				 le32_to_cpu(di->i_clusters));
> -		goto bail;
> +	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
> +		struct ocfs2_inline_data *data = &di->id2.i_data;
> +
> +		if (le32_to_cpu(di->i_clusters)) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode %llu: %u clusters\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le32_to_cpu(di->i_clusters));
> +			goto bail;
> +		}
> +
> +		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 (unsigned long long)le64_to_cpu(di->i_size),
> +					 le16_to_cpu(data->id_count));
> +			goto bail;
> +		}
>  	}
>  
>  	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {

