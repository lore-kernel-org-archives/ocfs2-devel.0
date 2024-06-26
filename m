Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D2C19BC6
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jun 2024 12:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719405961; cv=none; b=OhMctIINqC/+4uXzSeAflvsiDcoYL87UE03GGNsB0m/0tPJpGq4mmGa4eIRalYqJBZPuwM9qr7u5J9/+ZxdJ+fWG3ASBzncaR2ahzDcBNMcwLahGjtLjMMmgtvSZcUxG8FKGtwxNX8x9O8qGxjc5iZCjsb++EqJlbdntUiJSbWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719405961; c=relaxed/simple;
	bh=n+LimPI+40vQJSbV97vm9hWNFboZyvncqM1pw/aAvS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ei5ARFGCpgJ4RvHs5og1JIfvmM7Nf9cb7axLnV8AZgLu2Tom3uH2vT1zTWiqQHvFUPSywm3I1KOPtRF9OB9AjUuJCuLGbfoly8A1qFo/eAoXnp62hdqdHxjAA71EfxyVUvPmqAlOe3kii3LqBccMJt5P5Uf2S8DL0nxWdF7TEiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G/Ux9A+b; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G/Ux9A+b"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2eaa89464a3so76012761fa.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jun 2024 05:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719405956; x=1720010756; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YRr/z3h2LQiBfmsuPK6Cllfb4wt80dA5OJ3vAiwolYc=;
        b=G/Ux9A+bPbCV1wGxbzRUCwNkRhfWsEb127DtoMnn/X8GPDrOVI2Fp36ot1p+FUBJHk
         0fkuSYybM0rtY2s1hZtUybLF87ikCF4JLMoCzgoYd0FW0JG0MOMztCPKjS5wQ7AkmssG
         NXJ5WSo4XMovJvCmAj3BABbX/2TS82ojB9dHfSeYGrEvLP3+G1c2OY0jteqGRjaBFiO6
         zWX70bD5otwEezO4gRsrZkc/5rIb5f9mxNabPea5B9/2pVsyEKMQ23+xCnYoNvkBbzkt
         kyrRkw477EaH45d+9Qh43JmTSgkbRPSaOj/fQA6H7Nh8mlJSTF8Vvz5b7OS7PvDH/PQ3
         ikgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719405956; x=1720010756;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YRr/z3h2LQiBfmsuPK6Cllfb4wt80dA5OJ3vAiwolYc=;
        b=BW7O2gxQhRNXhZEzZZYjxNeTwUWhiKiYjeDlTwT09BdFOzD3sKFtfuIUOycuwooCWJ
         te/T1UvzZ1p9z1rZ/k5JXO5F8uaLSFt9d+/Kncu9ulDUwuAKjRkhre3L0NT0UVMAapRt
         dnLEIMY1hfNzy5TcOvWIcBDbN12lsBmSO8QvsCbk7l58pxG5lSQJ3EmpnS+iDykwH9zL
         kZQKvvxF+/s0Orljh/EJJycNTTv8+NFG79r8hsQlfdWhgkVEu4EbIhB9UEC0EXu9QUOk
         RRJ0V4dTHxGJv97contJosH8hZRc6aCl8lmgYrtHcdulZtZN6pt2Nc4r/D3IHJzQWOE0
         cnTw==
X-Gm-Message-State: AOJu0Yz/kvqhiDj9jBDU8GgInsaXpJLxdLUT03uU5O+Eoene4KmOX4OH
	3Kun3SatKMTNV0a1Vz7B5+pUU+wDe5zpmnIciqny2G/GmWnIL44wsQAPVpKfH6k=
X-Google-Smtp-Source: AGHT+IFJP+cay7eSrgmu69Mu2eslyN4lbFdhmVR6Z9XxGwi6xpZKsOGnYtdoumIpPubZaRM76uJTww==
X-Received: by 2002:a2e:9890:0:b0:2eb:dd0b:b9ec with SMTP id 38308e7fff4ca-2ec5797a362mr72652911fa.20.1719405956508;
        Wed, 26 Jun 2024 05:45:56 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c591bsm98921295ad.165.2024.06.26.05.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 05:45:55 -0700 (PDT)
Message-ID: <8c923e93-fcdb-4dee-9a7c-f854f35482b9@suse.com>
Date: Wed, 26 Jun 2024 20:45:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: lei lu <llfamsec@gmail.com>, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240626104433.163270-1-llfamsec@gmail.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240626104433.163270-1-llfamsec@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/24 18:44, lei lu wrote:
> This adds sanity checks for ocfs2_dir_entry to make sure all members of
> ocfs2_dir_entry don't stray beyond valid memory region.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>


Looks good to me.

Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
>   fs/ocfs2/dir.c | 46 +++++++++++++++++++++++++++++-----------------
>   1 file changed, 29 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index d620d4c53c6f..f0beb173dbba 100644
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
>   
>   	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>   		error_msg = "rec_len is smaller than minimal";
> @@ -308,9 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
>   		error_msg = "rec_len % 4 != 0";
>   	else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
>   		error_msg = "rec_len is too small for name_len";
> -	else if (unlikely(
> -		 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
> -		error_msg = "directory entry across blocks";
> +	else if (unlikely(next_offset > size))
> +		error_msg = "directory entry overrun";
> +	else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
> +		 next_offset != size)
> +		error_msg = "directory entry too close to end";
>   
>   	if (unlikely(error_msg != NULL))
>   		mlog(ML_ERROR, "bad entry in directory #%llu: %s - "
> @@ -352,16 +357,17 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
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
> +			if (!ocfs2_check_dir_entry(dir, de, bh, first_de,
> +						   bytes, offset)) {
>   				ret = -1;
>   				goto bail;
>   			}
> @@ -1138,7 +1144,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
>   	pde = NULL;
>   	de = (struct ocfs2_dir_entry *) first_de;
>   	while (i < bytes) {
> -		if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
> +		if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
>   			status = -EIO;
>   			mlog_errno(status);
>   			goto bail;
> @@ -1635,7 +1641,8 @@ int __ocfs2_add_entry(handle_t *handle,
>   		/* These checks should've already been passed by the
>   		 * prepare function, but I guess we can leave them
>   		 * here anyway. */
> -		if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
> +		if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start,
> +					   size, offset)) {
>   			retval = -ENOENT;
>   			goto bail;
>   		}
> @@ -1774,7 +1781,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>   		}
>   
>   		de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
> -		if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
> +		if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
> +					   i_size_read(inode), ctx->pos)) {
>   			/* On error, skip the f_pos to the end. */
>   			ctx->pos = i_size_read(inode);
>   			break;
> @@ -1867,7 +1875,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>   		while (ctx->pos < i_size_read(inode)
>   		       && offset < sb->s_blocksize) {
>   			de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
> -			if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
> +			if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
> +						   sb->s_blocksize, offset)) {
>   				/* On error, skip the f_pos to the
>   				   next block. */
>   				ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
> @@ -3339,7 +3348,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>   	struct super_block *sb = dir->i_sb;
>   	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>   	struct ocfs2_dir_entry *de, *last_de = NULL;
> -	char *de_buf, *limit;
> +	char *first_de, *de_buf, *limit;
>   	unsigned long offset = 0;
>   	unsigned int rec_len, new_rec_len, free_space;
>   
> @@ -3352,14 +3361,16 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>   	else
>   		free_space = dir->i_sb->s_blocksize - i_size_read(dir);
>   
> -	de_buf = di->id2.i_data.id_data;
> +	first_de = di->id2.i_data.id_data;
> +	de_buf = first_de;
>   	limit = de_buf + i_size_read(dir);
>   	rec_len = OCFS2_DIR_REC_LEN(namelen);
>   
>   	while (de_buf < limit) {
>   		de = (struct ocfs2_dir_entry *)de_buf;
>   
> -		if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
> +		if (!ocfs2_check_dir_entry(dir, de, di_bh, first_de,
> +					   i_size_read(dir), offset)) {
>   			ret = -ENOENT;
>   			goto out;
>   		}
> @@ -3441,7 +3452,8 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
>   			/* move to next block */
>   			de = (struct ocfs2_dir_entry *) bh->b_data;
>   		}
> -		if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> +		if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize,
> +					   offset)) {
>   			status = -ENOENT;
>   			goto bail;
>   		}

