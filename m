Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6C61802A3
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 09:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718618336; cv=none; b=og4itkJlzJS8Ar6ILA4WaUsUBhAAkAhRP/1C+wN3df8QOCAVN7LLqaUNoM39+cQ2Vr8QH97RDyAj8yXY5nmzNz/KDjhmiuP5qhq4+YutRb7Poi2W6/++sey/fL6BXwdAqmtSR9UxLQMiBvp2kb5YqBsngXxvdm2snBoh2883MFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718618336; c=relaxed/simple;
	bh=sq5LPecvhJW8QfYdc45o1X6QCI2WjYtEFYavALjSw3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uwacQ+1/N1KFxPdvTUJeIvCm3nihQcJl6M9fM5ndpx7hbktMaCM2mN0fmdAGW7fRjER071YE44XCLuKWzudS0W4mnAqGsGkCk0pXcmnQgoirXVqNbo1UudYQ0/O11a9eqrOA62TPEUmlmsCJfrd+uxVAaWuajeEfSStvZoVRm6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=izkzguej; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="izkzguej"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718618331; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=r0CEwlDzmRba7B6ZDYmWPDZHOFJsNkquq5F2zjbZv2w=;
	b=izkzguejpYq5U8guLEF9WsRPaSjWS0Ces8uqVPOYBvrLJI/njU5ESzcepSPKuK1YY8PZ3bwHNnoF8e2N1qIZI+40s4SkuW+psbW9j1/zArR7/7rf6lJOQgUAqFynIkJWA+zKeZjRREFtwGB0JqeW4Ig0nit+6BJ6Y4QJEjZh3yc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032014031;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W8cC0g5_1718618330;
Received: from 30.221.129.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W8cC0g5_1718618330)
          by smtp.aliyun-inc.com;
          Mon, 17 Jun 2024 17:58:51 +0800
Message-ID: <76e9f48b-8d23-45a5-8cba-1dc7d852781d@linux.alibaba.com>
Date: Mon, 17 Jun 2024 17:58:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: lei lu <llfamsec@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: heming.zhao@suse.com
References: <20240615044107.135012-1-llfamsec@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240615044107.135012-1-llfamsec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/15/24 12:41 PM, lei lu wrote:
> This adds sanity checks for ocfs2_dir_entry to make sure all members of
> ocfs2_dir_entry don't stray beyond valid memory region.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>
> ---
>  fs/ocfs2/dir.c | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index d620d4c53c6f..ada97ac6e2ea 100644
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

I'd like move 'buf' and 'size' each to a new line.
This is to be consistent with the existing code style.

Other looks good. With the above comments addressed,
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

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
> +						   sb->s_blocksize, offset)) {
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
> +		if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize, offset)) {
>  			status = -ENOENT;
>  			goto bail;
>  		}
