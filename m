Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518AD2C15BB
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Dec 2025 08:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764750421; cv=none; b=EdZKQbDVczSUWTcLQPRiGql2W8mxXYipEc04UQyiyUiTIxTiIREI725UAzrRacFbJcI+jYRVDl89EtFPcny7gsz5N7lRe79JAFwYSe0EfmhB/h+DPAOXnmTdJLlH1raUwdzQSUzZVw8FFSKuGEViVL89oV+yO2I84XHQL9ULaRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764750421; c=relaxed/simple;
	bh=3go/RnO4E8ECeHXb6AkOLP1q/Z0brBvyMWr81IzZVmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vE+4BSfJ7+b3cjpSgh0kIGlH5TkPEOv3ev/sUcPfV09MwayhjdRlJ5O3D8BuKjR3PXr0oGfNnUFXv/VWNHjQVhdvOuWmnZQxh9Z2FtVywaBQqlW5x6wiECPBxUFnlFagf+NrCow645CWL1d9PlDzIWme3HdH0ZHjCNMToy1fj20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DTQtTUM0; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DTQtTUM0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764750409; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=u/Q2pTWYQiHnbkqRVPkjlAOy9csUeamAQMht+QcrcRs=;
	b=DTQtTUM0GhIVdpWZHoh6a9gsZzbMDmATDIF98XvUzDSaCwJ0Ilp2/bmriBwQ6jiKmy+ym5yseCFx6n4OEKOTTF/EYXWcL27rAX8hDZ2MOmdwLAHKYQ5mHeyxnUC+CCF/r9EoGBfgMng/foJzTPCRR4/OCZF/YIQow7oE3bTLLho=
Received: from 30.221.128.156(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wu-bwR-_1764750408 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Dec 2025 16:26:48 +0800
Message-ID: <63a063ce-2be2-4f2f-9391-97f24935a36b@linux.alibaba.com>
Date: Wed, 3 Dec 2025 16:26:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] ocfs2: Convert remaining read-only checks to
 ocfs2_emergency_state
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
 Heming Zhao <heming.zhao@suse.com>
References: <cover.1764728893.git.eraykrdg1@gmail.com>
 <3421641b54ad6b6e4ffca052351b518eacc1bd08.1764728893.git.eraykrdg1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <3421641b54ad6b6e4ffca052351b518eacc1bd08.1764728893.git.eraykrdg1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/3 11:34, Ahmet Eray Karadag wrote:
> Now that the centralized `ocfs2_emergency_state()` helper is available,
> refactor remaining filesystem-wide checks for `ocfs2_is_soft_readonly`
> and `ocfs2_is_hard_readonly` to use this new function.
> 
> To ensure strict consistency with the previous behavior and guarantee
> no functional changes, the call sites continue to explicitly return
> -EROFS when the emergency state is detected. This standardizes the
> check logic while preserving the existing error handling flow.
> 
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2:
>  - Use `unlikely()` for status check
> ---
> v4:
>  - Ensure consistency with the previous behavior as requested
> ---
>  fs/ocfs2/buffer_head_io.c | 2 +-
>  fs/ocfs2/file.c           | 8 ++++----
>  fs/ocfs2/inode.c          | 3 +--
>  fs/ocfs2/move_extents.c   | 2 +-
>  fs/ocfs2/resize.c         | 4 ++--
>  fs/ocfs2/super.c          | 2 +-
>  6 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 8f714406528d..701d27d908d4 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -434,7 +434,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
>  	BUG_ON(buffer_jbd(bh));
>  	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
> +	if (unlikely(ocfs2_emergency_state(osb))) {
>  		ret = -EROFS;
>  		mlog_errno(ret);
>  		goto out;
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index ddca292944d7..732c61599159 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -179,7 +179,7 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
>  			      file->f_path.dentry->d_name.name,
>  			      (unsigned long long)datasync);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	if (unlikely(ocfs2_emergency_state(osb)))
>  		return -EROFS;
>  
>  	err = file_write_and_wait_range(file, start, end);
> @@ -209,7 +209,7 @@ int ocfs2_should_update_atime(struct inode *inode,
>  	struct timespec64 now;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	if (unlikely(ocfs2_emergency_state(osb)))
>  		return 0;
>  
>  	if ((inode->i_flags & S_NOATIME) ||
> @@ -1949,7 +1949,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	handle_t *handle;
>  	unsigned long long max_off = inode->i_sb->s_maxbytes;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	if (unlikely(ocfs2_emergency_state(osb)))
>  		return -EROFS;
>  
>  	inode_lock(inode);
> @@ -2713,7 +2713,7 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
>  		return -EINVAL;
>  	if (!ocfs2_refcount_tree(osb))
>  		return -EOPNOTSUPP;
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	if (unlikely(ocfs2_emergency_state(osb)))
>  		return -EROFS;
>  
>  	/* Lock both files against IO */
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..b7dad049cfa3 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1586,8 +1586,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
>  	trace_ocfs2_filecheck_repair_inode_block(
>  		(unsigned long long)bh->b_blocknr);
>  
> -	if (ocfs2_is_hard_readonly(OCFS2_SB(sb)) ||
> -	    ocfs2_is_soft_readonly(OCFS2_SB(sb))) {
> +	if (unlikely(ocfs2_emergency_state(OCFS2_SB(sb)))) {
>  		mlog(ML_ERROR,
>  		     "Filecheck: cannot repair dinode #%llu "
>  		     "on readonly filesystem\n",
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 86f2631e6360..71025d7b2d4b 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -898,7 +898,7 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>  	struct buffer_head *di_bh = NULL;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	if (unlikely(ocfs2_emergency_state(osb)))
>  		return -EROFS;
>  
>  	inode_lock(inode);
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index b0733c08ed13..ac3ec2c21119 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -276,7 +276,7 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
>  	u32 first_new_cluster;
>  	u64 lgd_blkno;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	if (unlikely(ocfs2_emergency_state(osb)))
>  		return -EROFS;
>  
>  	if (new_clusters < 0)
> @@ -466,7 +466,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  	u16 cl_bpc;
>  	u64 bg_ptr;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	if (unlikely(ocfs2_emergency_state(osb)))
>  		return -EROFS;
>  
>  	main_bm_inode = ocfs2_get_system_file_inode(osb,
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 53daa4482406..c6019d260efc 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2487,7 +2487,7 @@ static int ocfs2_handle_error(struct super_block *sb)
>  		rv = -EIO;
>  	} else { /* default option */
>  		rv = -EROFS;
> -		if (sb_rdonly(sb) && (ocfs2_is_soft_readonly(osb) || ocfs2_is_hard_readonly(osb)))
> +		if (sb_rdonly(sb) && ocfs2_emergency_state(osb))
>  			return rv;
>  
>  		pr_crit("OCFS2: File system is now read-only.\n");

