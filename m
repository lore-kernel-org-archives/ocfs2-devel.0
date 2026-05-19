Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD59F4DB54E
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 12:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779193301; cv=none; b=j7xdsXQKvBG4Mk/OJRCSIJPbLkmP0TwWr5ujbpTpw4hY5bW8AXmejEYB9JLUcUiy7xOBOGL0yPgyWBxRh0tX1DZzTtM+Q8L5U4o8QwI8Uef/evYvmELevWjaBvASgG9zanwKsCLP8dPUtbF6qsvQNtKBekxAa+3eIgLOG3OLr4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779193301; c=relaxed/simple;
	bh=807Jcb6zYWVlN2DM30ZCBg2Qm7A4EcnfvqEMJ+k6gkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UNPBhaWAxZBb3/Hj2VuB6mCEwI4FNh2e/pdr1/e0DNUdpF8Fza0E3UVOgIgfuMEz7y/0XZrCbTVEUy+Ixp2K/OZHZPmFwTt4MnCQC/dSdXN27lnnMoML0VE8XK5qTx/mp2akrC81/8uR/Q3JoDNceS5+LxRNa26hakecwLDlaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iN2UwzGI; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iN2UwzGI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779193288; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BATmymOnLliC4uVwt3uqvmHjyteI7eUKaXu8pSyYJMY=;
	b=iN2UwzGIIHWOePmB+jrSCri1QEjgntaVjnNSdIh/9L+Ane560sQvTp8Ocku5OVxrQqqv12bx9nu1PLgMJg3VaLwG0JXH4v0+gSwq0VwZDADSywukQQ8d1gj/vmBuLUYrg3/a/RfnlcLLXw4cxe4KjDO6bzYaB03e8U7AChR+nHk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X3FZeUM_1779193287;
Received: from 30.221.130.5(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3FZeUM_1779193287 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 May 2026 20:21:27 +0800
Message-ID: <2d3d2fca-460d-47ff-a91e-a06720ad1420@linux.alibaba.com>
Date: Tue, 19 May 2026 20:21:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] ocfs2: reject dinodes with non-canonical i_mode
 type
To: Michael Bommarito <michael.bommarito@gmail.com>,
 akpm <akpm@linux-foundation.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260519110404.1803902-1-michael.bommarito@gmail.com>
 <20260519110404.1803902-2-michael.bommarito@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260519110404.1803902-2-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/19/26 7:04 PM, Michael Bommarito wrote:
> ocfs2_validate_inode_block() currently accepts any non-zero i_mode value.
> ocfs2_populate_inode() then copies that mode verbatim into inode->i_mode
> and dispatches on i_mode & S_IFMT to the file/dir/symlink/special_file
> iops; an unrecognised type falls through to ocfs2_special_file_iops and
> init_special_inode().
> 
> Reject dinodes whose type bits do not name one of the seven canonical
> POSIX file types.  Use fs_umode_to_ftype(), the same generic file-type
> conversion helper OCFS2 already uses for directory entries, so the
> accepted inode type set matches the kernel file-type vocabulary instead
> of open-coding a local switch.
> 
> Apply the same structural check to the online filecheck read path.
> filecheck keeps its own error namespace, so it reports malformed i_mode
> through the filecheck logger and OCFS2_FILECHECK_ERR_INVALIDINO instead
> of calling ocfs2_error(), but it must not allow a malformed dinode to
> proceed into ocfs2_populate_inode().
> 
> Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
> Cc: stable@vger.kernel.org
> Link: https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.bommarito%40gmail.com
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Assisted-by: Claude:claude-opus-4-7

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/inode.c | 36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index a510a0eb1adcc..e149ccbdc03ce 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -13,6 +13,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/quotaops.h>
>  #include <linux/iversion.h>
> +#include <linux/fs_dirent.h>
>  
>  #include <asm/byteorder.h>
>  
> @@ -64,7 +65,12 @@ static int ocfs2_filecheck_read_inode_block_full(struct inode *inode,
>  static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
>  						struct buffer_head *bh);
>  static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
> -					      struct buffer_head *bh);
> +						      struct buffer_head *bh);
> +
> +static bool ocfs2_valid_inode_mode(umode_t mode)
> +{
> +	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
> +}
>  
>  void ocfs2_set_inode_flags(struct inode *inode)
>  {
> @@ -1494,6 +1500,24 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	/*
> +	 * Reject dinodes whose i_mode does not name one of the seven
> +	 * canonical POSIX file types.  ocfs2_populate_inode() copies
> +	 * i_mode verbatim into inode->i_mode and then dispatches via
> +	 * switch (mode & S_IFMT) to file/dir/symlink/special_file iops;
> +	 * an unrecognised type falls into ocfs2_special_file_iops with
> +	 * init_special_inode(), which interprets i_rdev.  Constrain the
> +	 * type here so the dispatch only ever sees a value mkfs.ocfs2 /
> +	 * VFS can produce.
> +	 */
> +	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
> +		rc = ocfs2_error(sb,
> +				 "Invalid dinode #%llu: mode 0%o has unknown file type\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(di->i_mode));
> +		goto bail;
> +	}
> +
>  	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
>  		struct ocfs2_inline_data *data = &di->id2.i_data;
>  
> @@ -1624,6 +1648,15 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
>  		     (unsigned long long)bh->b_blocknr,
>  		     le32_to_cpu(di->i_fs_generation));
>  		rc = -OCFS2_FILECHECK_ERR_GENERATION;
> +		goto bail;
> +	}
> +
> +	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
> +		mlog(ML_ERROR,
> +		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->i_mode));
> +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
>  	}
>  
>  bail:
> @@ -1812,4 +1845,3 @@ const struct ocfs2_caching_operations ocfs2_inode_caching_ops = {
>  	.co_io_lock		= ocfs2_inode_cache_io_lock,
>  	.co_io_unlock		= ocfs2_inode_cache_io_unlock,
>  };
> -

