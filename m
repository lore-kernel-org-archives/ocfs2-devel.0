Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5698619B3F3
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 03:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718681381; cv=none; b=JAYC01X6L26cJ1G/vwXSyzuMjlBy9lskxoLIXOvCITb0Y+O0aQ7qlD3j+4MMMI262l3tajNhrzpLoUtkZ5zfxRwiw8t67FtXKtgdi/uuQuCZoNGZOaWBpTdUL5p5/Swb0tENhawt08wqi+uIovd2vfk9VosJ8W/UUhXSBum9hRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718681381; c=relaxed/simple;
	bh=92QzPb5D4M+DO+gZEIkZKVVdg3YpZV2j+340T8TFGdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=cTfwnWkJoECHjBdeNhIQXT7fuzwCF3nUfF3Fsqra2M7b3XrM3WbklaanToB6xECyRtNqFjHS3GtAgpaFh7PSA9ehvq4PqoZjibT9LuEdh8r+yza6kc18SQVEK4r23cCD78y5G1MB0Mknj4GVTB3AGoH13Drmh3llQPk+q05XUbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=crNfWrLB; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="crNfWrLB"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2ebe3bac6c6so55467001fa.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 20:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718681376; x=1719286176; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VDW5fW1YvaFkCOXLPw9hNqoPkryEucTkUFijBEY7Ikg=;
        b=crNfWrLBnKdjN6dIt6EyFO1B/dZFlpbzCKPh7CRIqd1l252f6Zi3TGbXsVG3sRiTeg
         gKjJoJiDasi9phboZUZpvpvBjfGpJQE3jrbU+222tjM+6uYF7W955yswJgFunJhrJdct
         ICGZ1iL59e2Anf34cn64jAdDpFc8+RDz+Zk/8PQprzPuXa4lsRZd7XaFhGH9DzsSvouM
         IK45ZHP7o5UAVEwW8QUn8B+u7fzq2+cXvKaeVR7plmE7h+pdEFeiAaBvJUdCisXiY+uh
         vLMKs/5wKcirjA110iyXHOlPGsc7xH9bZdA8CAELOc1np/he0K0PlEoQbqOrIT35gL7x
         W7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718681376; x=1719286176;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDW5fW1YvaFkCOXLPw9hNqoPkryEucTkUFijBEY7Ikg=;
        b=wtT6L2OhRd4/wxkhtXaxN4myU/FCRm5vYLj/gBijOtA0o/SjiqA7J/ldfcGI1SVYSG
         QKfekjVCrmQ5bF2QNJn16fj2ONmwzGIawpPWpv3PgYoXOXVjPtuTto2zTXKCMOUSTbEb
         ee+lwInDG1r0MEQTaYNNOXCLQvg7TMfDdEtkXN4UxKPe+YCDk/jfih7cidzniKe+GJoX
         LSyFhbC+XR4KDUF12TomAZ9Ly3tFeroQtUHtWJjDMg7OrUsh7BevvHRc7TxzY3DgJTol
         BFqfWGQvoVQV+a+BvjJ1fvhG6iwUwwGlTXfAfPQpQrAf3ZwSVCXEo4MFvV0vH6net075
         dg7A==
X-Gm-Message-State: AOJu0YyUf7VV4Ng0ZJ+/vs7qj8kJZ3qGMfqCMygj0SYnJ33P2gH7AUsw
	poxM56VKaQeDrIlGpWhkF36HSJKhJvgp9Opa/QzMBw//nH1S1V8ZL7M2/+8O/VZJoGY7CS1fNO0
	R
X-Google-Smtp-Source: AGHT+IG7jb6L82TqTqVB5bHV4wVdG62bbZbI3lW0WWI+HS+nuAcapffDStsU5ScATQCUUPp1/+4MGg==
X-Received: by 2002:a2e:9799:0:b0:2eb:fe31:cae6 with SMTP id 38308e7fff4ca-2ec0e60109bmr85695381fa.37.1718681376210;
        Mon, 17 Jun 2024 20:29:36 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f1c9a3sm86820765ad.224.2024.06.17.20.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 20:29:35 -0700 (PDT)
Message-ID: <c5a6ab63-884a-4328-bfbe-7045f5469141@suse.com>
Date: Tue, 18 Jun 2024 11:29:32 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: add bounds checking to ocfs2_check_dir_entry()
Content-Language: en-US
To: lei lu <llfamsec@gmail.com>, joseph.qi@linux.alibaba.com
References: <20240617114027.139982-1-llfamsec@gmail.com>
From: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev
In-Reply-To: <20240617114027.139982-1-llfamsec@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/24 19:40, lei lu wrote:
> This adds sanity checks for ocfs2_dir_entry to make sure all members of
> ocfs2_dir_entry don't stray beyond valid memory region.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>   fs/ocfs2/dir.c | 34 ++++++++++++++++++++++------------
>   1 file changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index d620d4c53c6f..562f61daf77d 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
>    * bh passed here can be an inode block or a dir data block, depending
>    * on the inode inline data flag.
>    */
> -static int ocfs2_check_dir_entry(struct inode * dir,
> -				 struct ocfs2_dir_entry * de,
> -				 struct buffer_head * bh,
> +static int ocfs2_check_dir_entry(struct inode *dir,
> +				 struct ocfs2_dir_entry *de,
> +				 struct buffer_head *bh,
> +				 char *buf,
> +				 unsigned int size,
>   				 unsigned long offset)
>   {
>   	const char *error_msg = NULL;
>   	const int rlen = le16_to_cpu(de->rec_len);
> +	const unsigned long next_offset = ((char *) de - buf) + rlen;

from this patch, there are two cases for the parameter 'buf':

1>
'de' is the same as 'bh', de & bh both are the latest dir_entry offset.
the sanity check always passes below cases. e.g:
- ocfs2_search_dirblock()
- ocfs2_find_dir_space_id()

2>
'de' is different with 'bh', bh is the first dir_entry offset, de is
the latest offset. these cases should be the expected code paths, e.g:
- __ocfs2_delete_entry()
- ocfs2_dir_foreach_blk_id()
- ocfs2_dir_foreach_blk_el()
- ocfs2_find_dir_space_el()

If my thinking is right, case <1> needs to be revised to follow the design.

-Heming
>   
>   	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>   		error_msg = "rec_len is smaller than minimal";
> @@ -308,6 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
>   		error_msg = "rec_len % 4 != 0";
>   	else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
>   		error_msg = "rec_len is too small for name_len";
> +	else if (unlikely(next_offset > size))
> +		error_msg = "directory entry overrun";
> +	else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
> +		 next_offset != size)
> +		error_msg = "directory entry too close to end";
>   	else if (unlikely(
>   		 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
>   		error_msg = "directory entry across blocks";
> @@ -352,16 +360,16 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>   	de_buf = first_de;
>   	dlimit = de_buf + bytes;
>   
> -	while (de_buf < dlimit) {
> +	while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>   		/* this code is executed quadratically often */
>   		/* do minimal checking `by hand' */
>   
>   		de = (struct ocfs2_dir_entry *) de_buf;
>   
> -		if (de_buf + namelen <= dlimit &&
> +		if (de->name + namelen <= dlimit &&
>   		    ocfs2_match(namelen, name, de)) {
>   			/* found a match - just to be sure, do a full check */
> -			if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> +			if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes, offset)) {
>   				ret = -1;
>   				goto bail;
>   			}
> @@ -1138,7 +1146,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
>   	pde = NULL;
>   	de = (struct ocfs2_dir_entry *) first_de;
>   	while (i < bytes) {
> -		if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
> +		if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
>   			status = -EIO;
>   			mlog_errno(status);
>   			goto bail;
> @@ -1635,7 +1643,7 @@ int __ocfs2_add_entry(handle_t *handle,
>   		/* These checks should've already been passed by the
>   		 * prepare function, but I guess we can leave them
>   		 * here anyway. */
> -		if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
> +		if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start, size, offset)) {
>   			retval = -ENOENT;
>   			goto bail;
>   		}
> @@ -1774,7 +1782,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>   		}
>   
>   		de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
> -		if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
> +		if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
> +					   i_size_read(inode), ctx->pos)) {
>   			/* On error, skip the f_pos to the end. */
>   			ctx->pos = i_size_read(inode);
>   			break;
> @@ -1867,7 +1876,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>   		while (ctx->pos < i_size_read(inode)
>   		       && offset < sb->s_blocksize) {
>   			de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
> -			if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
> +			if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
> +						   sb->s_blocksize, offset)) {
>   				/* On error, skip the f_pos to the
>   				   next block. */
>   				ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
> @@ -3359,7 +3369,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>   	while (de_buf < limit) {
>   		de = (struct ocfs2_dir_entry *)de_buf;
>   
> -		if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
> +		if (!ocfs2_check_dir_entry(dir, de, di_bh, de_buf, i_size_read(dir), offset)) {
>   			ret = -ENOENT;
>   			goto out;
>   		}
> @@ -3441,7 +3451,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
>   			/* move to next block */
>   			de = (struct ocfs2_dir_entry *) bh->b_data;
>   		}
> -		if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> +		if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize, offset)) {
>   			status = -ENOENT;
>   			goto bail;
>   		}

