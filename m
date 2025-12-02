Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B90A3FF1
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 07:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764661177; cv=none; b=Zc17on90UNuWOLpQAiJ7CCPBrg+LCXT+NDocfv7lw51t2NTFCb158m7FAxUxMQuoqO+jTuXwOjMgmkEhXuGljvL3HAH41zx5/1DRjGDtElZtaxUymzmUOt1/xO8FQ9V8zjBhwyuGgIn440bCpmkpAFapI8X8J4rycuJxpMaV+hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764661177; c=relaxed/simple;
	bh=/C+cFrYpqLmlxVpBNNOU/6CpDENQ7DVtNNEYUnRaa+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E5dM7T/tzjAH69ijOwSaPvI1B8syVyMnKtbxmOq4t0JQnF0xA+1vzuQiwxWB8XGVMq/vmdj+lCH5s12H1rwNm15fcOGcOCKbIzWTLZwIv+xw6MVggL4zcxlfw0M0UDqiVLhosnyfRMzz0/tJ6AcjysyuvDgVcGy3EguTsFGe+b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=e+w8iW4M; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="e+w8iW4M"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764661171; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yRdYH01FEkeQpclMO1RuVH23vDNw2U3Nj6N6X6uXZow=;
	b=e+w8iW4Mp9s7SS0UmKJT4nkiXdp9PnY3x3UAfPcJ/KlAlcST231l3CDi3AQ86Eh2dzIZg+M+NFA6B9VgUt0QJaN8spqtsxwyNqT1T2IrILrj1YGK79CgOVkqv72WUBA152unkqz3ROvbvM+txTshMscYJ6kYdU8DBZypbes8Ig4=
Received: from 30.221.128.146(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WtvReiS_1764661170 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 15:39:31 +0800
Message-ID: <1636840d-0b22-4df7-8a54-2795583ae83d@linux.alibaba.com>
Date: Tue, 2 Dec 2025 15:39:30 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ocfs2: Convert remaining read-only checks to
 ocfs2_emergency_state
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>
References: <cover.1764643790.git.eraykrdg1@gmail.com>
 <1f329fa8f8b0496ecb88c6c48174ca3d8e339f8d.1764643790.git.eraykrdg1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <1f329fa8f8b0496ecb88c6c48174ca3d8e339f8d.1764643790.git.eraykrdg1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/2 10:54, Ahmet Eray Karadag wrote:
> To centralize error checking, follow the pattern of other filesystems
> like ext4 (which uses `ext4_emergency_state()`), and prepare for
> future enhancements, this patch introduces a new helper function:
> `ocfs2_emergency_state()`.
> 
> The purpose of this helper is to provide a single, unified location
> for checking all filesystem-level emergency conditions. In this
> initial implementation, the function only checks for the existing
> hard and soft read-only modes, returning -EROFS if either is set.
> 
> This provides a foundation where future checks (e.g., for fatal error
> states returning -EIO, or shutdown states) can be easily added in
> one place.
> 
> This patch also adds this new check to the beginning of
> `ocfs2_setattr()`. This ensures that operations like `ftruncate`
> (which triggered the original BUG) fail-fast with -EROFS when the
> filesystem is already in a read-only state.
> 

The above commit log is the same with patch 1 and doesn't reflect
the following changes.

> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> ---
> v2:
>  - Use `unlikely()` for status check
> ---
>  fs/ocfs2/buffer_head_io.c |  4 ++--
>  fs/ocfs2/file.c           | 17 ++++++++++-------
>  fs/ocfs2/inode.c          |  3 +--
>  fs/ocfs2/move_extents.c   |  5 +++--
>  fs/ocfs2/resize.c         |  8 +++++---
>  fs/ocfs2/super.c          |  2 +-
>  6 files changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 8f714406528d..61a0f522c673 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -434,8 +434,8 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
>  	BUG_ON(buffer_jbd(bh));
>  	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
> -		ret = -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret)) {

I'd like use the following style:
if (ocfs2_emergency_state(osb)) {
	ret = -EROFS;
	...
}

So that ocfs2_emergency_state() can be expended with other cases(properly
other return code), without touching these code flows.

Joseph

>  		mlog_errno(ret);
>  		goto out;
>  	}
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 253b4f300127..540b35ec02e2 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -179,8 +179,9 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
>  			      file->f_path.dentry->d_name.name,
>  			      (unsigned long long)datasync);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret))
> +		return ret;
>  
>  	err = file_write_and_wait_range(file, start, end);
>  	if (err)
> @@ -209,7 +210,7 @@ int ocfs2_should_update_atime(struct inode *inode,
>  	struct timespec64 now;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	if (unlikely(ocfs2_emergency_state(osb)))
>  		return 0;
>  
>  	if ((inode->i_flags & S_NOATIME) ||
> @@ -1949,8 +1950,9 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	handle_t *handle;
>  	unsigned long long max_off = inode->i_sb->s_maxbytes;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret))
> +		return ret;
>  
>  	inode_lock(inode);
>  
> @@ -2713,8 +2715,9 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
>  		return -EINVAL;
>  	if (!ocfs2_refcount_tree(osb))
>  		return -EOPNOTSUPP;
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret))
> +		return ret;
>  
>  	/* Lock both files against IO */
>  	ret = ocfs2_reflink_inodes_lock(inode_in, &in_bh, inode_out, &out_bh);
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
> index 86f2631e6360..9d2a2d054aa1 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -898,8 +898,9 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>  	struct buffer_head *di_bh = NULL;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	status = ocfs2_emergency_state(osb);
> +	if (unlikely(status))
> +		return status;
>  
>  	inode_lock(inode);
>  
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index b0733c08ed13..ae30ae67e220 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -276,8 +276,9 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
>  	u32 first_new_cluster;
>  	u64 lgd_blkno;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> -		return -EROFS;
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret))
> +		return ret;
>  
>  	if (new_clusters < 0)
>  		return -EINVAL;
> @@ -466,7 +467,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  	u16 cl_bpc;
>  	u64 bg_ptr;
>  
> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +	ret = ocfs2_emergency_state(osb);
> +	if (unlikely(ret))
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

