Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFFD3FE4
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jan 2025 06:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735800891; cv=none; b=ZrPHEBFXJeE3vQaQAqtayKxjWXE/3LdLORonTRGcrxEiWzA+ohcoK781d13BoN07dPBi2z2CvZ4nLDDJ+P2+RxWYcamAX6c+Y34cHxZqzCR7fqNG90SlsJQocuGG4rnRFy7zMeKyKmxYGEWzDFviX4oFggydvYdDrEF6PaKTDEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735800891; c=relaxed/simple;
	bh=/ehIBqGV/Q5J0FViWvpK2UtH2bPDqzKLgR4rRSJmePk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T2mzU4Lx1Xj9qX6TnoWBznuK1CAQoRWnTp5QosVnMkCsEL+x7e3mFG+S2M7db/IOnqhQB3f+LxXwfB5kfym5SVFC97iS16iEc8BFqlcYAGJctFSq7fbx2nu/LY7d3JtfxSYVZFA9QsmX5qQBvGaJ25hPaHv5EiO2zL5H7cavNI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SEhNgEjC; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SEhNgEjC"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735800880; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fST2LnTIoAym6hp++eWQnJ0Dt9vJBwHV7P26qvNW65Q=;
	b=SEhNgEjCTsxUWeHclF6yQ1l8qP77pwF57Zvtg32NZ2ENnIvplrNUerxDIQqilTeMbA+zQnzaJLIHVmmN/Qib+zQqhGRS3Kpe6lmkNeKJYryywSK0rrOypUTA7cmpMZK+xDlJATv0MN/Ng6nt29rSApM5VzKYZVBvqqY0P/a7irM=
Received: from 30.221.129.127(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMl6Ryx_1735800879 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Jan 2025 14:54:39 +0800
Message-ID: <2f18ddcc-405f-4e21-92be-dc70d133f131@linux.alibaba.com>
Date: Thu, 2 Jan 2025 14:54:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: Correct l_next_free_rec in online check
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com, jlbec@evilplan.org
References: <20250102035321.391540-1-sunjunchao2870@gmail.com>
 <20250102035321.391540-2-sunjunchao2870@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250102035321.391540-2-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/2 11:53, Julian Sun wrote:
> Correct the value of l_next_free_rec to l_count during the online
> check, as done in the check_el() function in ocfs2_tools.
> 
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> ---
>  fs/ocfs2/inode.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 2cc5c99fe941..1fc9544dc1fa 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -200,6 +200,20 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  	return inode;
>  }
>  
> +static int has_extents(struct ocfs2_dinode *di)

Better to rename it to 'ocfs2_dinode_has_extents'.

> +{
> +	/* inodes flagged with other stuff in id2 */
> +	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
> +			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
> +		return 0;
> +	/* i_flags doesn't indicate when id2 is a fast symlink */
> +	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
> +		return 0;
> +	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
> +		return 0;
> +
> +	return 1;
> +}
>  
>  /*
>   * here's how inodes get read from disk:
> @@ -1528,6 +1542,16 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
>  		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
>  	}
>  
> +	if (has_extents(di) && le16_to_cpu(di->id2.i_list.l_next_free_rec) >
> +	    le16_to_cpu(di->id2.i_list.l_count)) {
> +		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
> +		changed = 1;
> +		mlog(ML_ERROR,
> +		     "Filecheck: reset dinode #%llu: l_next_free_rec to %u\n",
> +		     (unsigned long long)bh->b_blocknr,
> +		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
> +	}
> +

I'd like to move this check behind fs_generation since they are commoner check.

Thanks,
Joseph

>  	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
>  		di->i_blkno = cpu_to_le64(bh->b_blocknr);
>  		changed = 1;

