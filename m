Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91BD79F5
	for <ocfs2-devel@lists.linux.dev>; Sat, 15 Jun 2024 02:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718418480; cv=none; b=FNXIm4Uqvrucvd5ALstE2nEUa24dEEL75wkhpvoZxe26uXJbkcUMDXhjIxZpQ899t6u7i8oee9B7uyTjLvOy2nGRg1RPanPWiLwb5fgjNEmpwW5X+uZOF2dvivhPdvc8vig2+1s45bqfW0rrGNDKllU92VEjLHcAH225c191uHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718418480; c=relaxed/simple;
	bh=ONcnfetFIKzbNM5uqXTMcclrLzmPJnsZxbFZ/nMzOQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=O1O5bNfsp+4osTiTN6gpFgPv/0KNYezag8TToY0c2LfQ2xiKCKtucfNyEdEFUAaL/xSTx5JMxmfTJJ4igwqeIfQOgay9c4Os4m7uw7IMuysy5jchBbKpuS2Fyep1LWfFm8/yd/jEhFVUq4KrSXznNTLkh9RVHlBD2xV9fq15djg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MT40ZJP2; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MT40ZJP2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718418475; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=G/TFDsOD2VWj5CU9hMCKl/yH2PnQtsjRunqIpv5URBc=;
	b=MT40ZJP2kmM/HF+hQvXU/hIG54u9mFsW4xU28iiRgRrNnDa39XWlhPaakwDZmfxIsLs8+Y6dAphFxMDDZsOLIMf2Jqb/WCwPxJM4g6JEgPJxeVBhxYNzp/o6xVOOVVL56NJ3jW31S059QFSAMD7c9FI4t71lBiidUx0mqbze0HE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045075189;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W8SMaKE_1718418473;
Received: from 30.32.103.198(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W8SMaKE_1718418473)
          by smtp.aliyun-inc.com;
          Sat, 15 Jun 2024 10:27:54 +0800
Message-ID: <9d4d24b6-72c7-442d-b8fb-0077e45320c2@linux.alibaba.com>
Date: Sat, 15 Jun 2024 10:27:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: lei lu <llfamsec@gmail.com>, ocfs2-devel@lists.linux.dev
References: <20240613022538.121631-1-llfamsec@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240613022538.121631-1-llfamsec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/13/24 10:25 AM, lei lu wrote:
> This adds sanity checks for ocfs2_dir_entry to make sure all members of
> ocfs2_dir_entry don't stray beyond valid memory region.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>
> ---
>  fs/ocfs2/dir.c | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index d620d4c53c6f..7aa4a5733993 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -294,13 +294,14 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
>   * bh passed here can be an inode block or a dir data block, depending
>   * on the inode inline data flag.
>   */
> -static int ocfs2_check_dir_entry(struct inode * dir,
> -				 struct ocfs2_dir_entry * de,
> -				 struct buffer_head * bh,
> +static int ocfs2_check_dir_entry(struct inode *dir,
> +				 struct ocfs2_dir_entry *de,
> +				 struct buffer_head *bh, char *buf, unsigned int size,
>  				 unsigned long offset)
>  {
>  	const char *error_msg = NULL;
>  	const int rlen = le16_to_cpu(de->rec_len);
> +	const unsigned long next_offset = ((char *) de - buf) + rlen;
>  
>  	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>  		error_msg = "rec_len is smaller than minimal";
> @@ -308,6 +309,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
>  		error_msg = "rec_len % 4 != 0";
>  	else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
>  		error_msg = "rec_len is too small for name_len";
> +	else if (unlikely(next_offset > size))
> +		error_msg = "directory entry overrun";
> +	else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
> +		 next_offset != size)
> +		error_msg = "directory entry too close to end";
>  	else if (unlikely(
>  		 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
>  		error_msg = "directory entry across blocks";
> @@ -352,16 +358,16 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>  	de_buf = first_de;
>  	dlimit = de_buf + bytes;
>  
> -	while (de_buf < dlimit) {
> +	while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>  		/* this code is executed quadratically often */
>  		/* do minimal checking `by hand' */
>  
>  		de = (struct ocfs2_dir_entry *) de_buf;
>  
> -		if (de_buf + namelen <= dlimit &&
> +		if (de->name + namelen <= dlimit &&
>  		    ocfs2_match(namelen, name, de)) {
>  			/* found a match - just to be sure, do a full check */
> -			if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> +			if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes, offset)) {
>  				ret = -1;
>  				goto bail;
>  			}
> @@ -1138,7 +1144,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
>  	pde = NULL;
>  	de = (struct ocfs2_dir_entry *) first_de;
>  	while (i < bytes) {
> -		if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
> +		if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
>  			status = -EIO;
>  			mlog_errno(status);
>  			goto bail;
> @@ -1635,7 +1641,7 @@ int __ocfs2_add_entry(handle_t *handle,
>  		/* These checks should've already been passed by the
>  		 * prepare function, but I guess we can leave them
>  		 * here anyway. */
> -		if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
> +		if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start, size, offset)) {
>  			retval = -ENOENT;
>  			goto bail;
>  		}
> @@ -1774,7 +1780,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>  		}
>  
>  		de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
> -		if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
> +		if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
> +					   i_size_read(inode), ctx->pos)) {
>  			/* On error, skip the f_pos to the end. */
>  			ctx->pos = i_size_read(inode);
>  			break;
> @@ -1867,7 +1874,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>  		while (ctx->pos < i_size_read(inode)
>  		       && offset < sb->s_blocksize) {
>  			de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
> -			if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
> +			if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
> +						   i_size_read(inode), offset)) {

Seems we have to use sb->s_blocksize instead i_size_read(inode) here.
This is not the case of inline data.

>  				/* On error, skip the f_pos to the
>  				   next block. */
>  				ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
> @@ -3359,7 +3367,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>  	while (de_buf < limit) {
>  		de = (struct ocfs2_dir_entry *)de_buf;
>  
> -		if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
> +		if (!ocfs2_check_dir_entry(dir, de, di_bh, de_buf, i_size_read(dir), offset)) {
>  			ret = -ENOENT;
>  			goto out;
>  		}
> @@ -3441,7 +3449,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
>  			/* move to next block */
>  			de = (struct ocfs2_dir_entry *) bh->b_data;
>  		}
> -		if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> +		if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, sb->s_blocksize, offset)) {

Can use blocksize directly since it is already defined.

Thanks,
Joseph

>  			status = -ENOENT;
>  			goto bail;
>  		}
