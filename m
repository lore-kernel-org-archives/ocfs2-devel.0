Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE0A45518D
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 09:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589491; cv=none; b=Qco+T1qPADXXFNjVGAkXYwsMYBS6/rJ1SLxzgEdcTeX61YOl6I6cbIagYSAeqzX4zYenVRRK82LfK5YteqedCCmaoVG48AYcLaJg5S+klpC1Gmkv4dL4St5eEhoI2U2P26XEBFgC7uWrtx2INaUa/rO6ERMT4MBh35YQx6KbcVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589491; c=relaxed/simple;
	bh=w+XDQEuSmmCLDdOKBYyjss6Q+r0YkdsA0ILjvX1Irq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Ic651wTLgLcZTR+HTSaSf+FKvpO6dt7AoCY2nP+xTSv7syP4GEDMvrBPYtqeP/m4KkyYScNIdCMZI+1jwseH8MhFKhWP6XFGxNihD/bqO+L2B+WJxu8Cuht+7mROBdFXd6kVEEnpl8MviKZaRvP0wqYUqA1m0LF3EIwMK8kVET8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tm4VDNWb; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tm4VDNWb"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790589485; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O3LNSAVKlF8HCZnjI0h5qpvfepDzzCP/jy0v1v5d07I=;
	b=tm4VDNWb9m71Q/K3AZgsArnUB8ZnJGzMJDOTrMpC4pGHsB4UkIgXkYUDKp6hdCVlgBHTgpFP2zc+WRdDaexbRT66c0TN09qRkL+UnSka5VbiraHIiXBgWwmdz3Z1noJGCEHhipaLPljTBKAdXJBEgBtiJs96PpcqiezNuOkYukU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XBlcLkk_1790589483;
Received: from 30.221.128.216(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XBlcLkk_1790589483 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Sep 2026 17:58:04 +0800
Message-ID: <159ee826-9183-4ab9-a8f3-fdac061830ed@linux.alibaba.com>
Date: Mon, 28 Sep 2026 17:58:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate filecheck inode slots
To: Jiale Yao <yaojiale02@163.com>
References: <20260926135354.3420193-1-yaojiale02@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ZhengYuan Huang <gality369@gmail.com>,
 Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260926135354.3420193-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/26/26 9:53 PM, Jiale Yao wrote:
> The online filecheck path reads inodes with
> ocfs2_filecheck_validate_inode_block() instead of
> ocfs2_validate_inode_block().  It does not check the slot fields that
> are used as indices into arrays sized by osb->max_slots.
> 
> A corrupted dinode can set OCFS2_ORPHANED_FL or
> OCFS2_DIO_ORPHANED_FL while carrying an out-of-range orphan slot.  An
> out-of-range i_suballoc_slot can also bypass the normal validator
> through the filecheck path.  These values can later be used to index
> the slot-local system inode array.
> 
> Mirror the normal validator's slot checks in the filecheck validator.
> Reject invalid slots in the repair path as well, since the correct
> slot cannot be recovered.
> 
> Fixes: bb88131c9831 ("ocfs2: validate DIO orphan slot during inode read")

Don't see why blames this commit.

> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  fs/ocfs2/inode.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 180107a11046..ab82cf9146ef 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1754,6 +1754,44 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  	return rc;
>  }
>  
> +/*
> + * Validate the slot fields used as indices into arrays sized by
> + * osb->max_slots.  The filecheck path uses this validator instead of
> + * ocfs2_validate_inode_block(), so it must enforce the same bounds.
> + */
> +static int ocfs2_filecheck_validate_slots(struct super_block *sb,
> +					  struct ocfs2_dinode *di,
> +					  unsigned long long blkno)
> +{
> +	struct ocfs2_super *osb = OCFS2_SB(sb);
> +
> +	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
> +	    (u32)le16_to_cpu(di->i_suballoc_slot) > osb->max_slots - 1) {
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: suballoc slot %u\n",
> +		     blkno, le16_to_cpu(di->i_suballoc_slot));
> +		return -OCFS2_FILECHECK_ERR_INVALIDINO;
> +	}
> +
> +	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
> +	    le16_to_cpu(di->i_orphaned_slot) >= osb->max_slots) {
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: orphaned slot %u\n",
> +		     blkno, le16_to_cpu(di->i_orphaned_slot));
> +		return -OCFS2_FILECHECK_ERR_INVALIDINO;
> +	}
> +
> +	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
> +	    le16_to_cpu(di->i_dio_orphaned_slot) >= osb->max_slots) {
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: DIO orphaned slot %u\n",
> +		     blkno, le16_to_cpu(di->i_dio_orphaned_slot));
> +		return -OCFS2_FILECHECK_ERR_INVALIDINO;
> +	}
> +
> +	return 0;
> +}
> +

The same comments with extent list filecheck patch.
Please abtract common helpers for this.

Thanks,
Joseph

>  static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
>  						struct buffer_head *bh)
>  {
> @@ -1835,6 +1873,10 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	rc = ocfs2_filecheck_validate_slots(sb, di, bh->b_blocknr);
> +	if (rc)
> +		goto bail;
> +
>  	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
>  		if (S_ISDIR(le16_to_cpu(di->i_mode)))
>  			mlog(ML_ERROR,
> @@ -1893,6 +1935,9 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
>  		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
>  	}
>  
> +	if (ocfs2_filecheck_validate_slots(sb, di, bh->b_blocknr))
> +		return -OCFS2_FILECHECK_ERR_INVALIDINO;
> +
>  	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
>  		di->i_blkno = cpu_to_le64(bh->b_blocknr);
>  		changed = 1;

