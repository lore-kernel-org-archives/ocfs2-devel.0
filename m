Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D9449E5C7
	for <ocfs2-devel@lists.linux.dev>; Thu,  8 Oct 2026 12:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791464355; cv=none; b=XZnRXMJlE2RbyyMywsyYQXT5pVK7BvU8vYwTceDaBYjPB1lzvQFpxjjen1/Ke3x0sOLPx3OGcXqK0+7BFoOFoo3AQ7YL/kC36JKP+IO2yR1duw6tFEN0X5lbekld0Uwxq7jbFl/cJNkelgg91wEo5GFHeYEaI5HJcYKXgLx36tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791464355; c=relaxed/simple;
	bh=DgAsKS9JvwInHXRpeBq9EtB+MtkPMfsQVYaRjgxcRpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=oLMA84A40aJCIwRjatwOmVbYEY7MI+5G+EDuRw/7BQAaUL4bgmT5cISE6AOAYha32mwyIspmE5eMG3HJpX432VwoyNLJvjzGntEaindLwPQLlySy006Gb89V7IjD2LFQtBdZoMxYc6B34Nt/0xKji9IKPufJ87tUk456qiWJdc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mB8bBy5R; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mB8bBy5R"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791464347; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UQ3AWBfwIgF+TFIDso++283qqFfL3TrJ8DKata4q3xI=;
	b=mB8bBy5Rmcbao3R1/0A8VL7NIYJw3ntpRXcweX3C/6pwziH1anAmBX9x+/sXjqmcwxHGuO+Is2fr7X9lUiwt74ViQkIQhoTlWu3Xvs61gDllU0FLQDPXEPLpRafLMiXmYIRYV2gAx60yVEe+tVyscvSl6JzfgpqYkvZ3kIteCqA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XCQ7o1P_1791464346;
Received: from 30.221.149.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCQ7o1P_1791464346 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 20:59:06 +0800
Message-ID: <b5773b48-d9be-4789-845b-a8d94a701fa5@linux.alibaba.com>
Date: Thu, 8 Oct 2026 20:59:05 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: validate filecheck inode slots
To: Jiale Yao <yaojiale02@163.com>
References: <20261004070621.1514598-1-yaojiale02@163.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Gang He <ghe@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261004070621.1514598-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/4/26 3:06 PM, Jiale Yao wrote:
> The online filecheck path reads inodes with
> ocfs2_filecheck_validate_inode_block() instead of
> ocfs2_validate_inode_block(). It does not check the slot fields used by
> ocfs2_get_system_file_inode() to index slot-local system inodes.
> 
> A corrupted dinode can set OCFS2_ORPHANED_FL or
> OCFS2_DIO_ORPHANED_FL while carrying an out-of-range orphan slot. An
> out-of-range i_suballoc_slot can also bypass the normal validator through
> the filecheck path. These values can later cause an out-of-bounds access
> when used as slot indices.
> 
> Share predicate helpers between the normal and filecheck validators so
> both paths enforce the same bounds while retaining their own logging and
> error handling. Reject invalid slots in the repair path as well, since the
> correct slot cannot be recovered.
> 
> This was reproduced on Linux 7.3-rc4 in an x86_64 QEMU guest with KASAN.
> Online filecheck of a corrupted inode reported a slab-out-of-bounds read
> in ocfs2_evict_inode(), reached from ocfs2_filecheck_attr_store().
> 
> Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
> 
> Notes:
>     Changes in v2:
>     - Extract the slot validity conditions from ocfs2_validate_inode_block()
>       into predicates shared with the filecheck paths.
>     - Keep logging and error handling local to each validator.
>     - Fix the Fixes tag and include the KASAN reproduction information.
> 
>  fs/ocfs2/inode.c | 68 +++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 62 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 180107a11046..e5a7e53fffe5 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -249,6 +249,33 @@ static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
>  	return 1;
>  }
>  
> +static int
> +ocfs2_dinode_has_invalid_suballoc_slot(struct super_block *sb,
> +				       struct ocfs2_dinode *di)
> +{
> +	u16 slot = le16_to_cpu(di->i_suballoc_slot);
> +
> +	return slot != (u16)OCFS2_INVALID_SLOT &&
> +	       slot >= OCFS2_SB(sb)->max_slots;
> +}

Use 'static bool' instead, to keep consistent with
ocfs2_dinode_has_size_without_clusters().

And it seems your another patch also changes the same context, so please
send the two together as a series.

BTW, you should rebase on top of the latest linux-next. This conflicts
with the series of 25bf9e549360 ("ocfs2: restrict OCFS2_INVALID_SLOT
suballoc slot to system inodes"), and you have to teach the helper about
OCFS2_SYSTEM_FL.

Thanks,
Joseph

> +
> +static int
> +ocfs2_dinode_has_invalid_orphan_slot(struct super_block *sb,
> +				     struct ocfs2_dinode *di)
> +{
> +	return (le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
> +	       le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots;
> +}
> +
> +static int
> +ocfs2_dinode_has_invalid_dio_orphan_slot(struct super_block *sb,
> +					 struct ocfs2_dinode *di)
> +{
> +	return (le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
> +	       le16_to_cpu(di->i_dio_orphaned_slot) >=
> +	       OCFS2_SB(sb)->max_slots;
> +}
> +
>  /*
>   * here's how inodes get read from disk:
>   * iget5_locked -> find_actor -> OCFS2_FIND_ACTOR
> @@ -1520,24 +1547,21 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> -	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
> -	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
> +	if (ocfs2_dinode_has_invalid_suballoc_slot(sb, di)) {
>  		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
>  				 (unsigned long long)bh->b_blocknr,
>  				 le16_to_cpu(di->i_suballoc_slot));
>  		goto bail;
>  	}
>  
> -	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
> -	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
> +	if (ocfs2_dinode_has_invalid_orphan_slot(sb, di)) {
>  		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
>  				 (unsigned long long)bh->b_blocknr,
>  				 le16_to_cpu(di->i_orphaned_slot));
>  		goto bail;
>  	}
>  
> -	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
> -	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
> +	if (ocfs2_dinode_has_invalid_dio_orphan_slot(sb, di)) {
>  		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
>  				 (unsigned long long)bh->b_blocknr,
>  				 le16_to_cpu(di->i_dio_orphaned_slot));
> @@ -1835,6 +1859,33 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if (ocfs2_dinode_has_invalid_suballoc_slot(sb, di)) {
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: suballoc slot %u\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->i_suballoc_slot));
> +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> +		goto bail;
> +	}
> +
> +	if (ocfs2_dinode_has_invalid_orphan_slot(sb, di)) {
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: orphaned slot %u\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->i_orphaned_slot));
> +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> +		goto bail;
> +	}
> +
> +	if (ocfs2_dinode_has_invalid_dio_orphan_slot(sb, di)) {
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: DIO orphaned slot %u\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->i_dio_orphaned_slot));
> +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> +		goto bail;
> +	}
> +
>  	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
>  		if (S_ISDIR(le16_to_cpu(di->i_mode)))
>  			mlog(ML_ERROR,
> @@ -1893,6 +1944,11 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
>  		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
>  	}
>  
> +	if (ocfs2_dinode_has_invalid_suballoc_slot(sb, di) ||
> +	    ocfs2_dinode_has_invalid_orphan_slot(sb, di) ||
> +	    ocfs2_dinode_has_invalid_dio_orphan_slot(sb, di))
> +		return -OCFS2_FILECHECK_ERR_INVALIDINO;
> +
>  	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
>  		di->i_blkno = cpu_to_le64(bh->b_blocknr);
>  		changed = 1;

