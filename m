Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFA23AC16
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jun 2024 08:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719390653; cv=none; b=tLmVFT9MK1vAqnCgzKOjJfE1ABTwaz+pMaoODphFufCNLJF4YVxlOR4umuD+OVS6/Mtbr2MTbmp/So//kGEwHjoOLf26mZmjxZrRX/54uW/L9Sb2okKhDbLnQw6mD6IUPoSGTCZPYFoLpCnERHvwRwaAGn60oAh7jF/FaKvw+aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719390653; c=relaxed/simple;
	bh=513+L0SiTZg97CVrQwNlh3hWMGPDiCCS4Vn2Q4n3lxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=olKJMRrjKn0RbUMfoA6HCjHcLFHb4FmA6Wlclbi1N0+5gFVbW6X4JEaKHO1dazDyVRHiGuupuapXCTYwCFbZJ8hUHv3l4Ey/um+CrxtiXeb+51ljz+GGgYMR1zTwANbpc9lSHbVYnY1Vvj0uQ2OViTiRtZ/iK0PEql2NsO06wgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dQKtIcfX; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dQKtIcfX"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ec17eb4493so86757601fa.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jun 2024 01:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719390648; x=1719995448; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NO7vChBpXL0TuRHZdXAJugfAw7qCGAFWS08aXayMciQ=;
        b=dQKtIcfXx+ueApJ+3WZq00t4Zs+BwDndwhbw8YqYmviCYtctQ69S5JDnWnIiiHrlD1
         H4bteWkOevIfuTsX7oejp+HxsfV0t6fnAYw+euZZPCu70Mq80tsGaeNovTLm1ZdgGdT5
         7nIEPLfNljIO5NgJ/JgupGpOFX4H3H6Hk4HNGkPEQHdMHhYdrr/A2VxWexnHqRIzjcxF
         eR4UcwgQknyv7VaqP+/zN4lfXPfsEMx7VBycw+prZ+qvtABjEjZ5xDdtEJZCzf+eRJ7D
         uCWUQo8DPH3wup6kitE8iKbWbE8vxx2Mv1rREDCusrOVwjAvFnMB6vt/YDEkB5HDt2Iy
         zzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719390648; x=1719995448;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NO7vChBpXL0TuRHZdXAJugfAw7qCGAFWS08aXayMciQ=;
        b=G0ZOVf9m1cl0j7ByYbb5FKQChVkEshQMrNWkR7SLIxkxCVZVlXR7X4c2L/fa5qK369
         jPnio67FfYLcqIn4A7zZuhQrSr2j4NUAmc1Z7le+MscwEJvLAVIPHMgX8PzznqmuWGh9
         C7MNDdHisFl+OEFnN/cLao2z46ZGumyHrprB8xlv0pCL8yXwYmDDyXwczkbgwqGK04Dq
         QtlreMT4YaBD1FlMMxlMSNWZf+kS2fMTkgqvvDQlNHSDjNVFzZ18yLv7n3RnPML7vDuD
         BIY1d2jyWGd7ovrzutx94fX4ODhPDJ5cV0BDASFMyx+BnueZB/q8hH6At0XK/GqSeYfj
         Sh8g==
X-Gm-Message-State: AOJu0YzJtd9f0gUPmmgR8WC8GYdP4lXhE/NzlyVkFNsxg0BxsCoWoEOg
	34H/9pes4b3o4irnGLuRkZpakBQR5ttuS3KjDOfH+h/QBq1Wqo3N5eG+c8C/fXTZrRNXVOZXhUs
	IC+vxag==
X-Google-Smtp-Source: AGHT+IFjuORebtrWMtOARsvNMy84nAlFfAAZQUzWPWRb45GGZxa/vZIBtA8UUz27yQtBQOeT8kXDiQ==
X-Received: by 2002:a2e:8646:0:b0:2ec:56b9:258b with SMTP id 38308e7fff4ca-2ec5b31d606mr76907561fa.33.1719390646380;
        Wed, 26 Jun 2024 01:30:46 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7068be428d7sm4550464b3a.30.2024.06.26.01.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 01:30:45 -0700 (PDT)
Message-ID: <0bfdc0ed-18ab-43e7-bc64-2d245e67db74@suse.com>
Date: Wed, 26 Jun 2024 16:30:41 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ocfs2: add bounds checking to ocfs2_check_dir_entry()
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, lei lu <llfamsec@gmail.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20240618065427.143612-1-llfamsec@gmail.com>
 <1af4ff4a-e963-4969-86cc-27419d326614@suse.com>
 <CAEBF3_Yeby=aeq21y5qq-pe9zP5OFV5Fo+FatwPV0cOnDJ+K_Q@mail.gmail.com>
 <6f97e658-6dcd-47e9-9cf4-3b413cdb5b57@linux.alibaba.com>
From: "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <6f97e658-6dcd-47e9-9cf4-3b413cdb5b57@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/22/24 08:31, Joseph Qi wrote:
> Hi Heming，
> Any more comments on this version?
> 
> Thanks,
> Joseph

I made a mistake in the last mail. For inline mode, the 'size' parameter 
of ocfs2_check_dir_entry is the size of di->id2.i_data.id_data[], not 
the whole inode size.

ref:
ocfs2_fill_new_dir_id
  + size = le16_to_cpu(data->id_count); //id_data[] size 

  + i_size_write(inode, size); //record in inode

So the algorithm of v5 patch is correct. there is only one minor issue 
needs to be fixed. see below.

> 
> On 6/18/24 9:09 PM, lei lu wrote:
>> On Tue, Jun 18, 2024 at 8:04 PM Heming Zhao <heming.zhao@suse.com> wrote:
>>>
>>> On 6/18/24 14:54, lei lu wrote:
>>>> This adds sanity checks for ocfs2_dir_entry to make sure all members of
>>>> ocfs2_dir_entry don't stray beyond valid memory region.
>>>>
>>>> Signed-off-by: lei lu <llfamsec@gmail.com>
>>>> ---
>>>>    fs/ocfs2/dir.c | 39 +++++++++++++++++++++++++--------------
>>>>    1 file changed, 25 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>>> index d620d4c53c6f..cdd92b4f9bf1 100644
>>>> --- a/fs/ocfs2/dir.c
>>>> +++ b/fs/ocfs2/dir.c
>>>> @@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
>>>>     * bh passed here can be an inode block or a dir data block, depending
>>>>     * on the inode inline data flag.
>>>>     */
>>>> -static int ocfs2_check_dir_entry(struct inode * dir,
>>>> -                              struct ocfs2_dir_entry * de,
>>>> -                              struct buffer_head * bh,
>>>> +static int ocfs2_check_dir_entry(struct inode *dir,
>>>> +                              struct ocfs2_dir_entry *de,
>>>> +                              struct buffer_head *bh,
>>>> +                              char *buf,
>>>> +                              unsigned int size,
>>>>                                 unsigned long offset)
>>>>    {
>>>>        const char *error_msg = NULL;
>>>>        const int rlen = le16_to_cpu(de->rec_len);
>>>> +     const unsigned long next_offset = ((char *) de - buf) + rlen;
>>>
>>> Hi Lei & Joseph,
>>>
>>> I withdraw my previous saying: the rest codes look good to me.
>>>
>>> I checked some code. In my view, if the code runs as expected,
>>> next_offset should be equal to:  "((char *) de - bh->b_data) + rlen".
>>
>> Hi,
>>
>> As you said below, In inline mode, dir entry list starts at
>> bh->b_data->id2.i_data,
>> In the dir block mode, dir entry list starts at bh->b_data directly.
>>
>> So the prerequisite for checking here is to make sure that buf is the first_de
>> and size is the de list size. We make sure that de don't stray beyond the de
>> list regardless of its mode.
>>
>> The above patch code refers to the __ext4_check_dir_entry.
>>
>>>
>>> You could add codes here to verify, e.g:
>>>     printk("...");
>>>     BUG_ON(next_offset != (((char *)de - bh->b_data) + rlen));
>>>
>>> This BUG_ON() will never be triggered.
>>>
>>> Please take some time to build and run the test, If my thinking is right,
>>> you need to send v6 patch.
>>>
>>> btw, please don't forget to check my below comments.
>>> It seems your code also has other bug.
>>>
>>> @Joseph, I also need your opinion.
>>>
>>>>
>>>>        if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>>>>                error_msg = "rec_len is smaller than minimal";
>>>> @@ -308,6 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
>>>>                error_msg = "rec_len % 4 != 0";
>>>>        else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
>>>>                error_msg = "rec_len is too small for name_len";
>>>> +     else if (unlikely(next_offset > size))
>>>> +             error_msg = "directory entry overrun";
>>>> +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
>>>> +              next_offset != size)
>>>> +             error_msg = "directory entry too close to end";
>>>>        else if (unlikely(
>>>>                 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
>>>>                error_msg = "directory entry across blocks";

the existing code " '((char *) de - bh->b_data) + rlen > 
dir->i_sb->s_blocksize' " should be removed. the reason is same with 
commit 226ba972b0863 ("ext4: refactor __ext4_check_dir_entry() to accept 
start and size").

Thanks,
Heming

>>>> @@ -352,16 +360,16 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>>>>        de_buf = first_de;
>>>>        dlimit = de_buf + bytes;
>>>>
>>>> -     while (de_buf < dlimit) {
>>>> +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>>>>                /* this code is executed quadratically often */
>>>>                /* do minimal checking `by hand' */
>>>>
>>>>                de = (struct ocfs2_dir_entry *) de_buf;
>>>>
>>>> -             if (de_buf + namelen <= dlimit &&
>>>> +             if (de->name + namelen <= dlimit &&
>>>>                    ocfs2_match(namelen, name, de)) {
>>>>                        /* found a match - just to be sure, do a full check */
>>>> -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>>> +                     if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, offset)) {
>>>
>>>
>>> ocfs2 uses two ways to store dir entry:
>>>    inline mode (OCFS2_INLINE_DATA_FL) & dir block mode
>>>
>>> Above function (ocfs2_search_dirblock) handles dir block case, the code
>>> can work under expectation.
>>
>> I think ocfs2_search_dirblock handles both two modes? Because In the caller
>> ocfs2_find_entry_id, the first_de is from di_bh->b_data->id2.i_data->id_data.
>>
>>>
>>>>                                ret = -1;
>>>>                                goto bail;
>>>>                        }
>>>> @@ -1138,7 +1146,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
>>>>        pde = NULL;
>>>>        de = (struct ocfs2_dir_entry *) first_de;
>>>>        while (i < bytes) {
>>>> -             if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
>>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
>>>>                        status = -EIO;
>>>>                        mlog_errno(status);
>>>>                        goto bail;
>>>> @@ -1635,7 +1643,7 @@ int __ocfs2_add_entry(handle_t *handle,
>>>>                /* These checks should've already been passed by the
>>>>                 * prepare function, but I guess we can leave them
>>>>                 * here anyway. */
>>>> -             if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
>>>> +             if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start, size, offset)) {
>>>>                        retval = -ENOENT;
>>>>                        goto bail;
>>>>                }
>>>> @@ -1774,7 +1782,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>>>>                }
>>>>
>>>>                de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
>>>> -             if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
>>>> +             if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
>>>> +                                        i_size_read(inode), ctx->pos)) {
>>>
>>> This function (ocfs2_dir_foreach_blk_id) handles inline mode.
>>>
>>> The de & data->id_data are both located in the inode struct, starting at
>>> offset 0xc8 in ((struct ocfs2_dinode)->id2.i_data). however di_bh->b_data
>>> points to the start address of the inode.
>>>
>>> if ocfs2_check_dir_entry() uses de & data->id_data to compare the offset, it
>>> misses the 0xc8 space.
>>>
>>>    struct ocfs2_dinode
>>> +----------------------------------+
>>> |   ...      |    id2.i_data       |
>>> |            |---------------------|
>>> |            |           |id_data[]|
>>> ^------------------------^-------^-+
>>> |                        |   ... |
>>> 0x0                     0xc8     0xc8+xxx: de
>>> di_bh->b_data         data->id_da
>>>
>>>
>>> (This patch) in ocfs2_check_dir_entry(), it uses "de - data->id_da" to get
>>> the offset. However, from the above pic, the algorithm is wrong; it forgets
>>> the [0,0xc8].
>>> the correct way: (de - bh->b_data)
>>>
>>> the same issue also occurs in ocfs2_find_dir_space_id().
>>>
>>>
>>> Thanks,
>>> Heming
>>>
>>>>                        /* On error, skip the f_pos to the end. */
>>>>                        ctx->pos = i_size_read(inode);
>>>>                        break;
>>>> @@ -1867,7 +1876,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>>>>                while (ctx->pos < i_size_read(inode)
>>>>                       && offset < sb->s_blocksize) {
>>>>                        de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
>>>> -                     if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
>>>> +                     if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
>>>> +                                                sb->s_blocksize, offset)) {
>>>>                                /* On error, skip the f_pos to the
>>>>                                   next block. */
>>>>                                ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
>>>> @@ -3339,7 +3349,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>>>        struct super_block *sb = dir->i_sb;
>>>>        struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>>>>        struct ocfs2_dir_entry *de, *last_de = NULL;
>>>> -     char *de_buf, *limit;
>>>> +     char *first_de, *de_buf, *limit;
>>>>        unsigned long offset = 0;
>>>>        unsigned int rec_len, new_rec_len, free_space;
>>>>
>>>> @@ -3352,14 +3362,15 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>>>        else
>>>>                free_space = dir->i_sb->s_blocksize - i_size_read(dir);
>>>>
>>>> -     de_buf = di->id2.i_data.id_data;
>>>> +     first_de = di->id2.i_data.id_data;
>>>> +     de_buf = first_de;
>>>>        limit = de_buf + i_size_read(dir);
>>>>        rec_len = OCFS2_DIR_REC_LEN(namelen);
>>>>
>>>>        while (de_buf < limit) {
>>>>                de = (struct ocfs2_dir_entry *)de_buf;
>>>>
>>>> -             if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
>>>> +             if (!ocfs2_check_dir_entry(dir, de, di_bh, first_de, i_size_read(dir), offset)) {
>>>>                        ret = -ENOENT;
>>>>                        goto out;
>>>>                }
>>>> @@ -3441,7 +3452,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
>>>>                        /* move to next block */
>>>>                        de = (struct ocfs2_dir_entry *) bh->b_data;
>>>>                }
>>>> -             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize, offset)) {
>>>>                        status = -ENOENT;
>>>>                        goto bail;
>>>>                }
>>>
