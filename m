Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C506BDDC5
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 06:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718693039; cv=none; b=RCrmUO+g402S1uqKs+t1j88KtsnMOOxDAHr6fYoMnGJupH+I11hcZjiWgkbINbQrj9WxhNmakic/7AiwOqGJmIIUj9HwAkuyCXdfiHMTbVy11wS+7RrAxLuAAfLdKRiPVJSA0Zhbl4zL3wq1CrtLRSiJPzlDU89E8tqf6r3QTY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718693039; c=relaxed/simple;
	bh=1M3PAh54bPesi6QmUIkOlnxzGiroHy5xqfaloP18UtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q6VlfDFKynfS6PxnBILACALhWxcwVbt2JDijGAOPE//uP+oQfiH+rse0kktMvWzJQDmSindsw5KL+i7qREbkKeIH+m7A+WTIvD2W/sIuZOavxwLFp7o6MGIJsrPicOOBpLjK356xt5KVK95wThnM5FxjmwHVBzBpS5Knqui8Lrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PPJzAyMv; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PPJzAyMv"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3609e730be5so406682f8f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 23:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718693033; x=1719297833; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7+c5pFmpA6medflvlj181pbTfqeewm7dWEq5jR4JYes=;
        b=PPJzAyMvPIrhL/z2EHBqjU5kOXMOe6j+ydlpQxZpIMLs0AUEFLlnvfy3iibyf+KV2P
         8lofLKeYAvLUzGsk3hGR83S7GFGFZo6DXm1yV1cfJfFfI1LqLiUTmURB2m7jzUS7rJsQ
         +WLsn1P5X4652Nx5MjbV2+Q3neqXw2qgisusQcpF0mHanHPEoXZmBGcdxw81a7SvIs1c
         5w1jBn65dAjrWn7DKHLHOyFrjQoaOLVyl0uUcbc/lSErugY6vSDo1j3AKPZU2Nlv2krQ
         fiRxxt7jE5jH4k7q410QJmj7DQbF5LaXTkPgMkAG6Wn/ZDU5XVmEdRyR9+x9xn+S63wi
         scVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718693033; x=1719297833;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7+c5pFmpA6medflvlj181pbTfqeewm7dWEq5jR4JYes=;
        b=cfYNyZV33mG3uKtli2DR6Xq1VVRgQ5U9gHLgWXKwccoSHnct5g0tCEDEYF0xu3RXX5
         OanvciFcF6+r0+tKjWWK/8LjZS9cae2ncjYRs4u9oqCcHxm9ZV3V2ZN9JhBtHczIqT9I
         4HOlaO+doF5T792jPzxGbDZzAP+l8q2mqXPrxMgO4V/0xU8z/qGCO73p6cFb1VKQ1LZe
         b5OJW85aB5xP784rooMdYrzjrUWcKp6eNRtscCcl4M9USNVKHLRkZCSi2SYTmRXKhiTP
         t8tX9AOu2F4EjI5+HBOa2hYZuqjLWLHJVHYl2K3Kdkt8JoMeQLoKvq8eM7QlaJV8NIXc
         9/XA==
X-Forwarded-Encrypted: i=1; AJvYcCWvPDFFNDr/CLSQ4FhKq8Ots1PZepMC4jdozd5WytBJvmqDFLn/MzKAlDAfC6hIH34KPqQTVQchLgTtUSVNK7MsLRxPF0e7jplKEyc=
X-Gm-Message-State: AOJu0YwEzEVCC5ZnLDJ0x4UIxoC9a/tR+J8sAgZRwhSo0dnattfllR9B
	BeMs9yxW9OlTtBDovkh3+7Vu//+OSXwHIaX/14u+lGt7noMEi8va/US0nDqpFpY=
X-Google-Smtp-Source: AGHT+IGRvILg5iRQ60m83ARian5Mlc6ySLaApIMTnr+Jaj827+Mba/zYzt72xvXD7Mmv6DqFXazU3Q==
X-Received: by 2002:a5d:4009:0:b0:362:5f91:901a with SMTP id ffacd0b85a97d-3625f91a24amr248468f8f.31.1718693032973;
        Mon, 17 Jun 2024 23:43:52 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a769aedbsm12323432a91.43.2024.06.17.23.43.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 23:43:52 -0700 (PDT)
Message-ID: <3b15c7ad-da8b-4184-9d86-7e173411394a@suse.com>
Date: Tue, 18 Jun 2024 14:43:49 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: add bounds checking to ocfs2_check_dir_entry()
Content-Language: en-US
To: lei lu <llfamsec@gmail.com>
Cc: joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev
References: <20240617114027.139982-1-llfamsec@gmail.com>
 <c5a6ab63-884a-4328-bfbe-7045f5469141@suse.com>
 <CAEBF3_be2K059_WqisKXUL-mm9-vqXshzrkGpc1-7AVdB=xcVQ@mail.gmail.com>
 <106d3676-d689-45a6-bdfb-f0db1a020ed4@suse.com>
 <CAEBF3_ay8oXvM1RNNVvUUG3ju8aEN6ve0yCJbKm8ZoxSJJi59Q@mail.gmail.com>
 <CAEBF3_YYM85TzD6r+fMP3Yyb-15g2QAQ8y45DD_f6NfG07zMkQ@mail.gmail.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <CAEBF3_YYM85TzD6r+fMP3Yyb-15g2QAQ8y45DD_f6NfG07zMkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/18/24 14:32, lei lu wrote:
> Hi,
> 
> Do you have further comments and/or suggestions? I will remake the
> patch to fix the issue in case <1>.
> 
> Thanks,
> LL

The rest of your patch codes look good to me.

Thanks,
Heming

> 
> On Tue, Jun 18, 2024 at 2:20 PM lei lu <llfamsec@gmail.com> wrote:
>>
>> On Tue, Jun 18, 2024 at 2:13 PM Heming Zhao <heming.zhao@suse.com> wrote:
>>>
>>> On 6/18/24 13:58, lei lu wrote:
>>>> On Tue, Jun 18, 2024 at 11:29 AM Heming Zhao <heming.zhao@suse.com> wrote:
>>>>>
>>>>> On 6/17/24 19:40, lei lu wrote:
>>>>>> This adds sanity checks for ocfs2_dir_entry to make sure all members of
>>>>>> ocfs2_dir_entry don't stray beyond valid memory region.
>>>>>>
>>>>>> Signed-off-by: lei lu <llfamsec@gmail.com>
>>>>>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>>>>>> ---
>>>>>>     fs/ocfs2/dir.c | 34 ++++++++++++++++++++++------------
>>>>>>     1 file changed, 22 insertions(+), 12 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>>>>> index d620d4c53c6f..562f61daf77d 100644
>>>>>> --- a/fs/ocfs2/dir.c
>>>>>> +++ b/fs/ocfs2/dir.c
>>>>>> @@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
>>>>>>      * bh passed here can be an inode block or a dir data block, depending
>>>>>>      * on the inode inline data flag.
>>>>>>      */
>>>>>> -static int ocfs2_check_dir_entry(struct inode * dir,
>>>>>> -                              struct ocfs2_dir_entry * de,
>>>>>> -                              struct buffer_head * bh,
>>>>>> +static int ocfs2_check_dir_entry(struct inode *dir,
>>>>>> +                              struct ocfs2_dir_entry *de,
>>>>>> +                              struct buffer_head *bh,
>>>>>> +                              char *buf,
>>>>>> +                              unsigned int size,
>>>>>>                                  unsigned long offset)
>>>>>>     {
>>>>>>         const char *error_msg = NULL;
>>>>>>         const int rlen = le16_to_cpu(de->rec_len);
>>>>>> +     const unsigned long next_offset = ((char *) de - buf) + rlen;
>>>>>
>>>>> from this patch, there are two cases for the parameter 'buf':
>>>>>
>>>>> 1>
>>>>> 'de' is the same as 'bh', de & bh both are the latest dir_entry offset.
>>>>> the sanity check always passes below cases. e.g:
>>>>> - ocfs2_search_dirblock()
>>>>> - ocfs2_find_dir_space_id()
>>>>
>>>> Thanks for your time.
>>>>
>>>> Sorry, I don't quite understand what you mean.
>>>
>>> Oh, sorry for my typo, my mean: 'de' is the same as 'buf' not 'bh'.
>>>
>>> The patch code in ocfs2_search_dirblock() is:
>>>     if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes, offset))
>>>
>>> the de is same as de_buf, so in ocfs2_check_dir_entry() the next_offset becomes
>>>     next_offset = rlen; //because "de == de_buf"
>>>
>>> In this case, rlen is not the current dir entry end boundary.
>>>
>>>> I think 'de' is not the same as 'bh'. e.g.:
>>>> - ocfs2_search_dirblock(): de is the latest dir_entry offset, bh is
>>>> the ocfs2_dinode offset, buf is the first dir_entry offset
>>>
>>> buf is not the first dir_entry offset.
>>>
>>>> - ocfs2_find_dir_space_id(): de is the latest dir_entry offset, bh is
>>>> the ocfs2_dinode offset, buf is the first dir_entry offset
>>>
>>> ditto
>>
>> Oh, you are right, We should use first_de here.
>>
>> Thanks,
>> LL
>>
>>>
>>> -Heming
>>>>
>>>> Thanks,
>>>> LL
>>>>
>>>>>
>>>>> 2>
>>>>> 'de' is different with 'bh', bh is the first dir_entry offset, de is
>>>>> the latest offset. these cases should be the expected code paths, e.g:
>>>>> - __ocfs2_delete_entry()
>>>>> - ocfs2_dir_foreach_blk_id()
>>>>> - ocfs2_dir_foreach_blk_el()
>>>>> - ocfs2_find_dir_space_el()
>>>>>
>>>>> If my thinking is right, case <1> needs to be revised to follow the design.
>>>>>
>>>>> -Heming
>>>>>>
>>>>>>         if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>>>>>>                 error_msg = "rec_len is smaller than minimal";
>>>>>> @@ -308,6 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
>>>>>>                 error_msg = "rec_len % 4 != 0";
>>>>>>         else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
>>>>>>                 error_msg = "rec_len is too small for name_len";
>>>>>> +     else if (unlikely(next_offset > size))
>>>>>> +             error_msg = "directory entry overrun";
>>>>>> +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
>>>>>> +              next_offset != size)
>>>>>> +             error_msg = "directory entry too close to end";
>>>>>>         else if (unlikely(
>>>>>>                  ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
>>>>>>                 error_msg = "directory entry across blocks";
>>>>>> @@ -352,16 +360,16 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>>>>>>         de_buf = first_de;
>>>>>>         dlimit = de_buf + bytes;
>>>>>>
>>>>>> -     while (de_buf < dlimit) {
>>>>>> +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>>>>>>                 /* this code is executed quadratically often */
>>>>>>                 /* do minimal checking `by hand' */
>>>>>>
>>>>>>                 de = (struct ocfs2_dir_entry *) de_buf;
>>>>>>
>>>>>> -             if (de_buf + namelen <= dlimit &&
>>>>>> +             if (de->name + namelen <= dlimit &&
>>>>>>                     ocfs2_match(namelen, name, de)) {
>>>>>>                         /* found a match - just to be sure, do a full check */
>>>>>> -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>>>>> +                     if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes, offset)) {
>>>>>>                                 ret = -1;
>>>>>>                                 goto bail;
>>>>>>                         }
>>>>>> @@ -1138,7 +1146,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
>>>>>>         pde = NULL;
>>>>>>         de = (struct ocfs2_dir_entry *) first_de;
>>>>>>         while (i < bytes) {
>>>>>> -             if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
>>>>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
>>>>>>                         status = -EIO;
>>>>>>                         mlog_errno(status);
>>>>>>                         goto bail;
>>>>>> @@ -1635,7 +1643,7 @@ int __ocfs2_add_entry(handle_t *handle,
>>>>>>                 /* These checks should've already been passed by the
>>>>>>                  * prepare function, but I guess we can leave them
>>>>>>                  * here anyway. */
>>>>>> -             if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
>>>>>> +             if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start, size, offset)) {
>>>>>>                         retval = -ENOENT;
>>>>>>                         goto bail;
>>>>>>                 }
>>>>>> @@ -1774,7 +1782,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>>>>>>                 }
>>>>>>
>>>>>>                 de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
>>>>>> -             if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
>>>>>> +             if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
>>>>>> +                                        i_size_read(inode), ctx->pos)) {
>>>>>>                         /* On error, skip the f_pos to the end. */
>>>>>>                         ctx->pos = i_size_read(inode);
>>>>>>                         break;
>>>>>> @@ -1867,7 +1876,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>>>>>>                 while (ctx->pos < i_size_read(inode)
>>>>>>                        && offset < sb->s_blocksize) {
>>>>>>                         de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
>>>>>> -                     if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
>>>>>> +                     if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
>>>>>> +                                                sb->s_blocksize, offset)) {
>>>>>>                                 /* On error, skip the f_pos to the
>>>>>>                                    next block. */
>>>>>>                                 ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
>>>>>> @@ -3359,7 +3369,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>>>>>         while (de_buf < limit) {
>>>>>>                 de = (struct ocfs2_dir_entry *)de_buf;
>>>>>>
>>>>>> -             if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
>>>>>> +             if (!ocfs2_check_dir_entry(dir, de, di_bh, de_buf, i_size_read(dir), offset)) {
>>>>>>                         ret = -ENOENT;
>>>>>>                         goto out;
>>>>>>                 }
>>>>>> @@ -3441,7 +3451,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
>>>>>>                         /* move to next block */
>>>>>>                         de = (struct ocfs2_dir_entry *) bh->b_data;
>>>>>>                 }
>>>>>> -             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>>>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize, offset)) {
>>>>>>                         status = -ENOENT;
>>>>>>                         goto bail;
>>>>>>                 }
>>>>>
>>>

