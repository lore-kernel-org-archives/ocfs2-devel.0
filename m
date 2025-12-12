Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F8F5B1EB
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 07:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765523580; cv=none; b=QwkL1YTcAntApioXk0BAumZUcaV7MMeS7YT0jQU8GSh5j/x3yE1Zr95RGlfspDSLgObkVhLtetEiUaHIm0mVDLZZtho7dILTt1sJN9SRIfqJ6vi86I2dhwAS2Sdn7YX66cXA1DnlBUyhcj8wmAsbwtOksnEgw+m2EgT5zoCtsNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765523580; c=relaxed/simple;
	bh=mdrWiccMMChVBe59dbKnUXtZbtoLCjAKE0qfQpwQhyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gdaolBDw9m5n0gPSeLpaHIRodXFkojjGk+NDPkHQqdVD7UCRqtpbJ+cJvCQDs5BOoCwv/paAZtTXz75AqEKzwaRFQ0AtgeHQA2pUWcdUrUC76/3qr/mEuxHPCbJE5vt2wlVdJ49tPHqneAuGlEl0WLUF2AA1Ih02hEeaHP0JuSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=c5Ubwdi/; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="c5Ubwdi/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765523574; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IBQf2oyPXFZcAnQh/40OQC9G2g0G+m0n0IBr7tLL+/g=;
	b=c5Ubwdi/mQiSTy/Gz+96PCDFR+vAkngTffX8W5UXAnbxJYPRKsCK1w8Cr1jnPbzZHLk9PuLLeHqZP68v/XGrWACdZ3xqnpNIiQFK1uL+osJOcezhwf3aGqX9XURzBtg0uVV56+MRZ/vU8xHZJ8JczKhCjShYwiiJjqTT6z86nwo=
Received: from 30.221.145.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WudJOAK_1765523573 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Dec 2025 15:12:54 +0800
Message-ID: <62b99931-75c4-4a13-8d79-98f71ed46718@linux.alibaba.com>
Date: Fri, 12 Dec 2025 15:12:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] ocfs2: detect released suballocator BG for
 fh_to_[dentry|parent]
To: Heming Zhao <heming.zhao@suse.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 glass.su@suse.com
References: <20251212070016.24235-1-heming.zhao@suse.com>
 <20251212070016.24235-3-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251212070016.24235-3-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/12 15:00, Heming Zhao wrote:
> After ocfs2 gained the ability to reclaim suballocator free block
> group (BGs), a suballocator block group may be released. This change
> causes the xfstest case generic/426 to fail.
> 
> generic/426 expects return value -ENOENT or -ESTALE, but the current
> code triggers -EROFS.
> 
> Call stack before ocfs2 gained the ability to reclaim bg:
> 
> ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
>  ocfs2_get_dentry
>   + ocfs2_test_inode_bit
>   |  ocfs2_test_suballoc_bit
>   |   + ocfs2_read_group_descriptor //Since ocfs2 never releases the bg,
>   |   |                             //the bg block was always found.
>   |   + *res = ocfs2_test_bit //unlink was called, and the bit is zero
>   |
>   + if (!set) //because the above *res is 0
>      status = -ESTALE //the generic/426 expected return value
> 
> Current call stack that triggers -EROFS:
> 
> ocfs2_get_dentry
>  ocfs2_test_inode_bit
>   ocfs2_test_suballoc_bit
>    ocfs2_read_group_descriptor
>     + if reading a released bg, validation fails and triggers -EROFS
> 
> How to fix:
> Since the read BG is already released, we must avoid triggering -EROFS.
> With this commit, we use ocfs2_read_hint_group_descriptor() to detect
> the released BG block. This approach quietly handles this type of error
> and returns -EINVAL, which triggers the caller's existing conversion
> path to -ESTALE.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reviewed-by: Su Yue <glass.su@suse.com>
> ---
>  fs/ocfs2/export.c   |  6 ++++--
>  fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
>  2 files changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
> index b95724b767e1..9c2665dd24e2 100644
> --- a/fs/ocfs2/export.c
> +++ b/fs/ocfs2/export.c
> @@ -74,8 +74,9 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
>  			 * nice
>  			 */
>  			status = -ESTALE;
> -		} else
> +		} else if (status != -ESTALE) {
>  			mlog(ML_ERROR, "test inode bit failed %d\n", status);
> +		}
>  		goto unlock_nfs_sync;
>  	}
>  
> @@ -162,8 +163,9 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
>  	if (status < 0) {
>  		if (status == -EINVAL) {
>  			status = -ESTALE;
> -		} else
> +		} else if (status != -ESTALE) {
>  			mlog(ML_ERROR, "test inode bit failed %d\n", status);
> +		}
>  		parent = ERR_PTR(status);
>  		goto bail_unlock;
>  	}
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 9a19f5230c8c..ddcfa6e001e8 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -3152,7 +3152,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>  	struct ocfs2_group_desc *group;
>  	struct buffer_head *group_bh = NULL;
>  	u64 bg_blkno;
> -	int status;
> +	int status, quiet = 0, released;
>  
>  	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
>  				      (unsigned int)bit);
> @@ -3168,11 +3168,15 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>  
>  	bg_blkno = group_blkno ? group_blkno :
>  		   ocfs2_which_suballoc_group(blkno, bit);
> -	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
> -					     &group_bh);
> -	if (status < 0) {
> +	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
> +					     &group_bh, &released);
> +	if (released) {
> +		quiet = 1;
> +		status = -ESTALE;
> +		goto bail;
> +	} else if (status < 0) {
>  		mlog(ML_ERROR, "read group %llu failed %d\n",
> -		     (unsigned long long)bg_blkno, status);
> +				(unsigned long long)bg_blkno, status);

This can be kept untouched.

>  		goto bail;
>  	}
>  
> @@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>  bail:
>  	brelse(group_bh);
>  
> -	if (status)
> +	if (status && (!quiet))

'!quiet' is enough, the parentheses is unneeded.

Other looks good to me.

Thanks,
Joseph

>  		mlog_errno(status);
>  	return status;
>  }
> @@ -3202,7 +3206,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>   */
>  int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>  {
> -	int status;
> +	int status, quiet = 0;
>  	u64 group_blkno = 0;
>  	u16 suballoc_bit = 0, suballoc_slot = 0;
>  	struct inode *inode_alloc_inode;
> @@ -3244,8 +3248,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>  
>  	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
>  					 group_blkno, blkno, suballoc_bit, res);
> -	if (status < 0)
> -		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> +	if (status < 0) {
> +		if (status == -ESTALE)
> +			quiet = 1;
> +		else
> +			mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> +	}
>  
>  	ocfs2_inode_unlock(inode_alloc_inode, 0);
>  	inode_unlock(inode_alloc_inode);
> @@ -3253,7 +3261,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>  	iput(inode_alloc_inode);
>  	brelse(alloc_bh);
>  bail:
> -	if (status)
> +	if (status && !quiet)
>  		mlog_errno(status);
>  	return status;
>  }

