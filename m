Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60501199B0
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 06:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718691214; cv=none; b=U5oK+AemduQ19wHvbq8oAgxgvOp54nRunffyfPKBnDiatYIlv8jYZeXxGj/Jk8qfnyNPOWGJvmcsEmB8GNbi8wHAw5ho4FKT2AZ3UNfoTPTyNPKIZd1oXQbRtRL0dBZWQkZW/xzBEqju0Ap9L58cZ2vkcrUFYLVFrAfCogy6xus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718691214; c=relaxed/simple;
	bh=Vt140QI1BU9AVtFAJwWl7N/Je19fmVyzpN/yGuzwInM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H/SVTgoJJ64Ny9lov3JKnK1TTgzmKWzDgS7Iz5oaGZO6qidDud6rrO6xWqNI78tlHRFUIrzJf+d5mhPjqeeEIy3gEYVNGlvVdJHpRopvKPybuMzOFvCTgtdUQ2E8ASYGZIGY5121AvoC11PO4LIti5hazDKoK1yWJIZvW5Mc5EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JdNIOEsa; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JdNIOEsa"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2ec10324791so52277841fa.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 23:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718691209; x=1719296009; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZbZjKab5S+kkXerPq0yd2w8Hof2XJJBzzWcWSuydxH4=;
        b=JdNIOEsaeDeQ8ym4/3Jq7eQOqi06EvnEtFcFKS0r9fxiUfMyP6R41w3XZS3PAGo/O8
         Jad04L6LWDHZByjYtgJoXfzvq8vDkw4IGmvwcejakC0Ce1FD0igMB/kHhcIpAsSncJVO
         b1bYuybqKgG/QXJ3rBjSbr99Rik7elt0HXjQgqImBsOa+WL9sO4WAK7Cl0bzO82COUdJ
         GodzuHqKi0eUzeFN9ej8THrtdyIEJip1yP1keJ+gy7OJtf3ora7zZRHmGNm4NMjB40St
         rJWZ+i+J0xJazoIvbqsu0u1huw2XqCnycDflCVRID8nQ5iJnphVM4i2UbNG/PXkOF2pc
         TmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718691209; x=1719296009;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbZjKab5S+kkXerPq0yd2w8Hof2XJJBzzWcWSuydxH4=;
        b=afbdm7aY5lJ1ExHDmjzdMhtAvG2KTaUPz2ZXDUW5U04PjkExzhu6Xc5jXRUwLTlQCE
         RzSdJlWaKXul9X+Z2+FS0+17Fk5KgoJusYZ2+QjZgExqWOpps3m/E7V5miwi5aqrGD9b
         ov+gOFBBFzCTHq5BWzr6ipkuQJKs718paOlNfbfL5lm1PMbodptb6F1N/jo/HOugy8NE
         1GAeb3ufZuKGJRQjIAK1TPnkw9HkcKwH1DH1wIDgUUwnhN5Jh6f0ecKtg64XTOPt6I0R
         3vlgyCkErTrqOKJECW4nP+aPxep8do6SWTBN6ARAnB6p6LAJh4OTuykK+y8XiyOc3DY4
         6iOw==
X-Forwarded-Encrypted: i=1; AJvYcCWMx2wwBVhkZwBTgxcJS0B/nUXH1FaCOtMZVgXfOhPjp+v/Z0Fq+7/6xpejUNP1AW4Yck/1F8DSxRZqPOzpBxMmZblljh8d/fXaoz4=
X-Gm-Message-State: AOJu0YzTa/i1Me6ZegbC6w3PFaCQ1OZx2taxg2gEB0Hm+cA0wb9F1Ih9
	1aBJBe+ooOIkwxHhYtnHzp9tWt8RckjVOS+6z38BpifVhe/S2SGsYl9YNuc8ggU=
X-Google-Smtp-Source: AGHT+IF3nWPjsrMGw2SJiTvzeG7E+rpOOsRv235P9wZ9WGHlcQ5qeHxWl0p9ErEXIgqO16r2LNPgCA==
X-Received: by 2002:a2e:9615:0:b0:2eb:fc09:801f with SMTP id 38308e7fff4ca-2ec0e5b5f1bmr76997101fa.11.1718691209327;
        Mon, 17 Jun 2024 23:13:29 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c738c1d57asm394422a91.1.2024.06.17.23.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 23:13:28 -0700 (PDT)
Message-ID: <106d3676-d689-45a6-bdfb-f0db1a020ed4@suse.com>
Date: Tue, 18 Jun 2024 14:13:24 +0800
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
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <CAEBF3_be2K059_WqisKXUL-mm9-vqXshzrkGpc1-7AVdB=xcVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/18/24 13:58, lei lu wrote:
> On Tue, Jun 18, 2024 at 11:29 AM Heming Zhao <heming.zhao@suse.com> wrote:
>>
>> On 6/17/24 19:40, lei lu wrote:
>>> This adds sanity checks for ocfs2_dir_entry to make sure all members of
>>> ocfs2_dir_entry don't stray beyond valid memory region.
>>>
>>> Signed-off-by: lei lu <llfamsec@gmail.com>
>>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>>> ---
>>>    fs/ocfs2/dir.c | 34 ++++++++++++++++++++++------------
>>>    1 file changed, 22 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>> index d620d4c53c6f..562f61daf77d 100644
>>> --- a/fs/ocfs2/dir.c
>>> +++ b/fs/ocfs2/dir.c
>>> @@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
>>>     * bh passed here can be an inode block or a dir data block, depending
>>>     * on the inode inline data flag.
>>>     */
>>> -static int ocfs2_check_dir_entry(struct inode * dir,
>>> -                              struct ocfs2_dir_entry * de,
>>> -                              struct buffer_head * bh,
>>> +static int ocfs2_check_dir_entry(struct inode *dir,
>>> +                              struct ocfs2_dir_entry *de,
>>> +                              struct buffer_head *bh,
>>> +                              char *buf,
>>> +                              unsigned int size,
>>>                                 unsigned long offset)
>>>    {
>>>        const char *error_msg = NULL;
>>>        const int rlen = le16_to_cpu(de->rec_len);
>>> +     const unsigned long next_offset = ((char *) de - buf) + rlen;
>>
>> from this patch, there are two cases for the parameter 'buf':
>>
>> 1>
>> 'de' is the same as 'bh', de & bh both are the latest dir_entry offset.
>> the sanity check always passes below cases. e.g:
>> - ocfs2_search_dirblock()
>> - ocfs2_find_dir_space_id()
> 
> Thanks for your time.
> 
> Sorry, I don't quite understand what you mean.

Oh, sorry for my typo, my mean: 'de' is the same as 'buf' not 'bh'.

The patch code in ocfs2_search_dirblock() is:
   if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes, offset))

the de is same as de_buf, so in ocfs2_check_dir_entry() the next_offset becomes
   next_offset = rlen; //because "de == de_buf"

In this case, rlen is not the current dir entry end boundary.

> I think 'de' is not the same as 'bh'. e.g.:
> - ocfs2_search_dirblock(): de is the latest dir_entry offset, bh is
> the ocfs2_dinode offset, buf is the first dir_entry offset

buf is not the first dir_entry offset.

> - ocfs2_find_dir_space_id(): de is the latest dir_entry offset, bh is
> the ocfs2_dinode offset, buf is the first dir_entry offset

ditto

-Heming
> 
> Thanks,
> LL
> 
>>
>> 2>
>> 'de' is different with 'bh', bh is the first dir_entry offset, de is
>> the latest offset. these cases should be the expected code paths, e.g:
>> - __ocfs2_delete_entry()
>> - ocfs2_dir_foreach_blk_id()
>> - ocfs2_dir_foreach_blk_el()
>> - ocfs2_find_dir_space_el()
>>
>> If my thinking is right, case <1> needs to be revised to follow the design.
>>
>> -Heming
>>>
>>>        if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>>>                error_msg = "rec_len is smaller than minimal";
>>> @@ -308,6 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
>>>                error_msg = "rec_len % 4 != 0";
>>>        else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
>>>                error_msg = "rec_len is too small for name_len";
>>> +     else if (unlikely(next_offset > size))
>>> +             error_msg = "directory entry overrun";
>>> +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
>>> +              next_offset != size)
>>> +             error_msg = "directory entry too close to end";
>>>        else if (unlikely(
>>>                 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
>>>                error_msg = "directory entry across blocks";
>>> @@ -352,16 +360,16 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>>>        de_buf = first_de;
>>>        dlimit = de_buf + bytes;
>>>
>>> -     while (de_buf < dlimit) {
>>> +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>>>                /* this code is executed quadratically often */
>>>                /* do minimal checking `by hand' */
>>>
>>>                de = (struct ocfs2_dir_entry *) de_buf;
>>>
>>> -             if (de_buf + namelen <= dlimit &&
>>> +             if (de->name + namelen <= dlimit &&
>>>                    ocfs2_match(namelen, name, de)) {
>>>                        /* found a match - just to be sure, do a full check */
>>> -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>> +                     if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes, offset)) {
>>>                                ret = -1;
>>>                                goto bail;
>>>                        }
>>> @@ -1138,7 +1146,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
>>>        pde = NULL;
>>>        de = (struct ocfs2_dir_entry *) first_de;
>>>        while (i < bytes) {
>>> -             if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
>>>                        status = -EIO;
>>>                        mlog_errno(status);
>>>                        goto bail;
>>> @@ -1635,7 +1643,7 @@ int __ocfs2_add_entry(handle_t *handle,
>>>                /* These checks should've already been passed by the
>>>                 * prepare function, but I guess we can leave them
>>>                 * here anyway. */
>>> -             if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
>>> +             if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start, size, offset)) {
>>>                        retval = -ENOENT;
>>>                        goto bail;
>>>                }
>>> @@ -1774,7 +1782,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>>>                }
>>>
>>>                de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
>>> -             if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
>>> +             if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
>>> +                                        i_size_read(inode), ctx->pos)) {
>>>                        /* On error, skip the f_pos to the end. */
>>>                        ctx->pos = i_size_read(inode);
>>>                        break;
>>> @@ -1867,7 +1876,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>>>                while (ctx->pos < i_size_read(inode)
>>>                       && offset < sb->s_blocksize) {
>>>                        de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
>>> -                     if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
>>> +                     if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
>>> +                                                sb->s_blocksize, offset)) {
>>>                                /* On error, skip the f_pos to the
>>>                                   next block. */
>>>                                ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
>>> @@ -3359,7 +3369,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>>        while (de_buf < limit) {
>>>                de = (struct ocfs2_dir_entry *)de_buf;
>>>
>>> -             if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
>>> +             if (!ocfs2_check_dir_entry(dir, de, di_bh, de_buf, i_size_read(dir), offset)) {
>>>                        ret = -ENOENT;
>>>                        goto out;
>>>                }
>>> @@ -3441,7 +3451,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
>>>                        /* move to next block */
>>>                        de = (struct ocfs2_dir_entry *) bh->b_data;
>>>                }
>>> -             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize, offset)) {
>>>                        status = -ENOENT;
>>>                        goto bail;
>>>                }
>>

