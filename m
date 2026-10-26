Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793008807;
	b=dz/lAT2wMTkLPbLhaeDIaVGJE0mkfIo+y+y3eqNX4Eo7c8r89/IHqPQxDZuJz2sMaLnk
	 zXjC7+NOmghOuHuzgzIx7+ywRDpxnnv2e0qGNs/tacHZpXh2tQRrHbJ1e1FI2aCZaIYEs
	 GDM7UkGWnE4TBCSqmljNngywT8WuuRgdwxVP0Psh4tBWYxMOpnUX1rAVAeRkva4fj88d3
	 3hQsOfp5b/mrsL8EaoueN2j8Huue/3SI9MuzTFPtE3/l7ALrEMeQo2o1HbR+aXo3/AofU
	 DTnmQQoXAiWx78XMebw7ob7voCDi+ONAFs/tfFpNoxAWO5Kpfn5jog9QbEv+EPs4xSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793008807;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=F/pa/uFhSJPFHIEewk36wTKJdJWq4rFHLThxtYs5ePs=;
	b=OD+FM6kV58eNn2wsj99WfrKub3aQitFZJYRLOnoKZp1x11ob7B0oLhZWmi4Q5125/zeR
	 3NYpRcNOENs9VNPSsRVTvtLF3ituvD7YdaWq7H6yGn10biKICQiiftOAcobWC4EFsFMZm
	 XSX8uz7zOHKeZ5C08Qi8dplYaqPWi8nSl5BfR22c3s64TbSIwmpj9CjMhQUB39zwkcT91
	 v/OMPSwI3Oi4s7ZiWpp73gfayjX98+zdpp/wxpOPpsLWLH+RYYsECIhnyD5//I1AY9sfX
	 1u9u29XRt9uQ2Iv7g9ngDK3dIZOeGDs+FtqhV09u8QB4c9Nd8KMdSsfUgDunFyCdGnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dwlM3Jda;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE822606B44E
	for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 10:00:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE822606B44E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dwlM3Jda
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793008802; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=F/pa/uFhSJPFHIEewk36wTKJdJWq4rFHLThxtYs5ePs=;
	b=dwlM3JdaG5OIPj4Hpwv6O+JHHTOsMIur4AduK7yfy1WQtq1WlssMpBZ5KPIcbYRGK5R55/izikwaCtLpgnIuI8lQL9f1TE4LBmScw+3iSCX5mqBiJKDafwC+KvB29VhQsgTcT7+EmuneBwXusMiwx/ZH/K9JdowyBgALjAu4Tmc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDW4SKg_1793008801;
Received: from 30.221.130.82(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDW4SKg_1793008801 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 18:00:01 +0800
Message-ID: <87a005a4-c61f-4525-a0d1-89bfc6a8f75d@linux.alibaba.com>
Date: Mon, 26 Oct 2026 17:59:59 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: validate move extents against a stable EOF
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-move-extents-isize-rrw-v4-d4b80ed0748f84dc3f8e@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-move-extents-isize-rrw-v4-d4b80ed0748f84dc3f8e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/26 12:20 AM, Cen Zhang wrote:
> The move-extents range must be bounded by the inode size used for extent
> movement. ocfs2_ioctl_move_extents() checks and clamps the request before
> taking the local inode and cluster locks in ocfs2_move_extents(). It also
> uses separate i_size_read() calls for the range check and subtraction.
> 
> A concurrent truncate can invalidate the first check and make the later
> unsigned subtraction underflow:
> 
>   Move-extents ioctl                  Truncate
>   ------------------                  --------
>   check me_start <= i_size
>                                       take inode and cluster locks
>                                       shrink EOF below me_start
>                                       release locks
>   compare me_start + me_len with EOF
>   set me_len = EOF - me_start
>     [unsigned underflow]
>   acquire inode and cluster locks
>   select extents using the bad range
> 
> A truncate after clamping can also leave the range extending beyond EOF.
> Conversely, the cached size may be smaller than the size refreshed when
> the cluster inode lock is acquired. Early validation can then reject a
> valid start or permanently shorten the requested length and threshold.
> The me_start + me_len comparison can also wrap for a large input length.
> 
> Validate and adjust the original request once, after inode_lock(), the
> exclusive rw lock and ocfs2_inode_lock() have stabilized and refreshed
> the size. Read EOF once, reject a start beyond it, and bound the length
> by EOF minus start. Normalize the threshold using the same EOF snapshot.
> This keeps zero as the default-threshold sentinel until validation uses
> the size that will govern extent movement.
> 
> Move goal validation after range adjustment as well. Its allocation-group
> capacity check uses me_len and must see the EOF-clamped length. Both
> validation failures use the existing inode-lock unwind path before any
> extent movement or transaction starts.
> 
> Fixes: 53069d4e7695 ("Ocfs2/move_extents: move/defrag extents within a certain range.")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
> Changes in v2:
> - Validate and normalize the original range only once, after inode and
>   cluster locking have stabilized and refreshed EOF.
> - Move goal validation after range adjustment because its allocation-group
>   capacity check depends on me_len.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-move-extents-isize-rrw-v3-b2a7508c41108cc2d00b@gmail.com
> 
>  fs/ocfs2/move_extents.c | 68 ++++++++++++++++++++++-------------------
>  1 file changed, 37 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index ad1678ee7cc4..f2682ef6bf2b 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -907,6 +907,30 @@ out:
>  	return ret;
>  }
>  
> +static int ocfs2_validate_and_adjust_move_range(struct inode *inode,
> +						struct ocfs2_move_extents *range)
> +{
> +	u64 i_size = i_size_read(inode);
> +
> +	if (range->me_start > i_size)
> +		return -EINVAL;
> +
> +	if (range->me_len > i_size - range->me_start)
> +		range->me_len = i_size - range->me_start;
> +
> +	/*
> +	 * The default threshold for defragmentation is 1 MiB, which
> +	 * matches the maximum OCFS2 cluster size.
> +	 */
> +	if (!range->me_threshold)
> +		range->me_threshold = 1024 * 1024;
> +
> +	if (range->me_threshold > i_size)
> +		range->me_threshold = i_size;
> +
> +	return 0;
> +}
> +
>  static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>  {
>  	int status;
> @@ -936,6 +960,19 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>  		goto out_rw_unlock;
>  	}
>  
> +	status = ocfs2_validate_and_adjust_move_range(inode, context->range);
> +	if (status) {
> +		mlog_errno(status);
> +		goto out_inode_unlock;
> +	}
> +
> +	/* The goal check depends on the adjusted range length. */
> +	if (!context->auto_defrag) {
> +		status = ocfs2_validate_and_adjust_move_goal(inode, context->range);
> +		if (status)
> +			goto out_inode_unlock;

Seems we'd better log the failure like ocfs2_validate_and_adjust_move_range().

> +	}
> +
>  	/*
>  	 * remember ip_xattr_sem also needs to be held if necessary
>  	 */
> @@ -1028,27 +1065,8 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>  		goto out_free;
>  	}
>  
> -	if (range.me_start > i_size_read(inode)) {
> -		status = -EINVAL;
> -		goto out_free;
> -	}

This seems changes the return value. It returned -EINVAL without touching
the caller's buffer. It now unwinds through out_inode_unlock and falls into
the copy back and returns -EFAULT instead of -EINVAL.

Seems not a bug since the goal validation failure already behaved this way,
but worth a line in the commit log.

Thanks,
Joseph

> -
> -	if (range.me_start + range.me_len > i_size_read(inode))
> -			range.me_len = i_size_read(inode) - range.me_start;
> -
>  	context->range = &range;
>  
> -	/*
> -	 * ok, the default threshold for the defragmentation
> -	 * is 1M, since our maximum clustersize was 1M also.
> -	 * any thought?
> -	 */
> -	if (!range.me_threshold)
> -		range.me_threshold = 1024 * 1024;
> -
> -	if (range.me_threshold > i_size_read(inode))
> -		range.me_threshold = i_size_read(inode);
> -
>  	if (range.me_flags & ~(OCFS2_MOVE_EXT_FL_AUTO_DEFRAG |
>  			       OCFS2_MOVE_EXT_FL_PART_DEFRAG)) {
>  		status = -EINVAL;
> @@ -1060,23 +1078,11 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>  
>  		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
>  			context->partial = 1;
> -	} else {
> -		/*
> -		 * first best-effort attempt to validate and adjust the goal
> -		 * (physical address in block), while it can't guarantee later
> -		 * operation can succeed all the time since global_bitmap may
> -		 * change a bit over time.
> -		 */
> -
> -		status = ocfs2_validate_and_adjust_move_goal(inode, &range);
> -		if (status)
> -			goto out_copy;
>  	}
>  
>  	status = ocfs2_move_extents(context);
>  	if (status)
>  		mlog_errno(status);
> -out_copy:
>  	/*
>  	 * movement/defragmentation may end up being partially completed,
>  	 * that's the reason why we need to return userspace the finished

