Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1826A61FCD
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 12:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718712286; cv=none; b=Ac6S/WNDo5aqQmS57MAqYGxPXWUXVgdJf1cl1yHvcN03QBbTEuhMxUvP1UB7sbEGNIBQ77p4VOV7uB9H2eUf/yHEnQcZWVsuyk+uDyykAgxHk26Fsub29tID4TR+xWQh7b6DwVOpvf1BNZNU8vHo/KpYWxjSHwsNMttEUVEZ7Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718712286; c=relaxed/simple;
	bh=/XFax0SVXFcVJyYsAOV99pVwQLpo4rNzhcg+TmzDRXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=MxfdWH8ocTVo1H5gr55RnGkpHOAF23Mt5/n4unuw/zFyuglYEcaYqPZv6vlFxI2sdTw36gWS37sYYVepnRoAzThM4Xudptxk2xHBBj3OweEEpb6qT9uRjclz6gVkRRDQfCsGMgZU3pXZG7crFkVt5Bk5+0a4U0JQ9IB3Z/CyPQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AY3w9D12; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AY3w9D12"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2ec0f3b9cfeso47733861fa.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 05:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718712282; x=1719317082; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+L0B0oQ1TP2NLYHyBYvoUGvseGJfJyyhJmyE2lffbd4=;
        b=AY3w9D12LVxIul5jtVd+KdHIk+gc+40Qb/E4A7gm/AljmjwtMhyrvDRhkFtbdyJHxM
         hiiXN8VeOyaZb50m76SB7nJI7dwtLX/42zNmoEBeg11Oe7LEsg9HGyL9yhp0fpVrSzVq
         nWQXaFcfjE62tPnuIADftHJsxqe2miwtcBWYEkUkluLci625uDCCSdizNh0BSYiieM77
         BPjozn4jOZzOtLxHteA5CjaOJrCbx2YqdyP8nPhwzMhs1OWl5QEyaOuSdLLzHk911u71
         ilxil/S7bKtQ24ZsRvrE2m1PA3MSOpoaMHxjtiWB73i+oScSaAGMXXY+x5F3Iyd3lJcp
         EFhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718712282; x=1719317082;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+L0B0oQ1TP2NLYHyBYvoUGvseGJfJyyhJmyE2lffbd4=;
        b=hYXUh3tydlRam4kJObGUIiGXLi+4xx8e68BfbC4x+rxWaX+UPv0GZowCqm3PYFD7KI
         Qi3OPfjIOob/Zsgbt1d64zntSEDFYBUbyjKzigAnR3d69QWE3JSe+RO7x1nf7bTY2neX
         q8L49nFFSDUvBMltpJn641C6bn/ba5WyeR1dDdxszwPRN/0ReBs6JzpXv6ycTSGZ4+mz
         aba9bgeGg8QY8esIRjUAgAOWKz5Xcmb5u91zFOfTKm4a20PnfjTXvTiuy2lJReKZ9ogd
         vKzfVQVZJzkPsrZah9QhzoOqMAXiEhzJdMfJ51iTECQ2GL4y7h0isn9W0c9YnQRxfMwx
         uUFA==
X-Gm-Message-State: AOJu0Yyyu5zh5UwZT5+q3POwFQICiNBbMtwG258gL0oijzOcPewoTAnt
	VjGmo2PIiatCKIBzpFWJJJUMqstQHqsbphkbl/2b9EQnJWFUFoxDXK7INlLLiTW67aYQOiokFdo
	X
X-Google-Smtp-Source: AGHT+IH0U/MlgFXxe+a4Dxo5AKide3JaeTU+lozXgBHHvQUPN15LsM7dTGhOaPvUAQ75uj2Mj7xazw==
X-Received: by 2002:a2e:8006:0:b0:2ec:2278:679f with SMTP id 38308e7fff4ca-2ec22786a47mr51324921fa.40.1718712282076;
        Tue, 18 Jun 2024 05:04:42 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb8d98bsm8828426b3a.191.2024.06.18.05.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 05:04:41 -0700 (PDT)
Message-ID: <1af4ff4a-e963-4969-86cc-27419d326614@suse.com>
Date: Tue, 18 Jun 2024 20:04:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ocfs2: add bounds checking to ocfs2_check_dir_entry()
Content-Language: en-US
To: lei lu <llfamsec@gmail.com>, joseph.qi@linux.alibaba.com
References: <20240618065427.143612-1-llfamsec@gmail.com>
From: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev
In-Reply-To: <20240618065427.143612-1-llfamsec@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/24 14:54, lei lu wrote:
> This adds sanity checks for ocfs2_dir_entry to make sure all members of
> ocfs2_dir_entry don't stray beyond valid memory region.
> 
> Signed-off-by: lei lu <llfamsec@gmail.com>
> ---
>   fs/ocfs2/dir.c | 39 +++++++++++++++++++++++++--------------
>   1 file changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index d620d4c53c6f..cdd92b4f9bf1 100644
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

Hi Lei & Joseph,

I withdraw my previous saying: the rest codes look good to me.

I checked some code. In my view, if the code runs as expected,
next_offset should be equal to:  "((char *) de - bh->b_data) + rlen".

You could add codes here to verify, e.g:
   printk("...");
   BUG_ON(next_offset != (((char *)de - bh->b_data) + rlen));

This BUG_ON() will never be triggered.

Please take some time to build and run the test, If my thinking is right,
you need to send v6 patch.

btw, please don't forget to check my below comments.
It seems your code also has other bug.

@Joseph, I also need your opinion.

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
> +			if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, offset)) {


ocfs2 uses two ways to store dir entry:
  inline mode (OCFS2_INLINE_DATA_FL) & dir block mode

Above function (ocfs2_search_dirblock) handles dir block case, the code
can work under expectation.

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

This function (ocfs2_dir_foreach_blk_id) handles inline mode.

The de & data->id_data are both located in the inode struct, starting at
offset 0xc8 in ((struct ocfs2_dinode)->id2.i_data). however di_bh->b_data
points to the start address of the inode.

if ocfs2_check_dir_entry() uses de & data->id_data to compare the offset, it
misses the 0xc8 space.

  struct ocfs2_dinode
+----------------------------------+
|   ...      |    id2.i_data       |
|            |---------------------|
|            |           |id_data[]|
^------------------------^-------^-+
|                        |   ... |
0x0                     0xc8     0xc8+xxx: de
di_bh->b_data         data->id_da


(This patch) in ocfs2_check_dir_entry(), it uses "de - data->id_da" to get
the offset. However, from the above pic, the algorithm is wrong; it forgets
the [0,0xc8].
the correct way: (de - bh->b_data)

the same issue also occurs in ocfs2_find_dir_space_id().


Thanks,
Heming

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
> @@ -3339,7 +3349,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>   	struct super_block *sb = dir->i_sb;
>   	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>   	struct ocfs2_dir_entry *de, *last_de = NULL;
> -	char *de_buf, *limit;
> +	char *first_de, *de_buf, *limit;
>   	unsigned long offset = 0;
>   	unsigned int rec_len, new_rec_len, free_space;
>   
> @@ -3352,14 +3362,15 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
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
> +		if (!ocfs2_check_dir_entry(dir, de, di_bh, first_de, i_size_read(dir), offset)) {
>   			ret = -ENOENT;
>   			goto out;
>   		}
> @@ -3441,7 +3452,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
>   			/* move to next block */
>   			de = (struct ocfs2_dir_entry *) bh->b_data;
>   		}
> -		if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> +		if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize, offset)) {
>   			status = -ENOENT;
>   			goto bail;
>   		}

