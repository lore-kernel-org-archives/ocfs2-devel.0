Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEED5384
	for <ocfs2-devel@lists.linux.dev>; Sat, 22 Jun 2024 00:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719016322; cv=none; b=HRZZ9c6jtfUM9uDMfdPL96juPNYBHWmzwsY8WzuQt712zOGjhHOEJXjbJfbvMANC4BJO8eodo1X361H7dVjsre+LeBybhKKS1QBC9V7M7oWF81F/N4jcQnDlV4XF20Io8ZCtTIYKhgw20aJh0qEjRvYC8Ep8ENXMOU2+Y3cxYxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719016322; c=relaxed/simple;
	bh=ODnbx8AZLGkfoj4rtwitG40WMKWXT6wrkyohCRqMANI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VqG5FD+mYkzv5tzDf891d+5exxPqtmNx5EWenoHvc7z09yxUhPBEXhMO7X5uRTPHPBd6pnhgPlfBuKmk5IEYynZ8e5A+BcXS7PcdoN3u28SImLywnJaYoOlPjZ73NEJsYAjJAYIjv3qgQXlU3hdmxHk42JlNduuejPeoKw2tv3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Y226snLF; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Y226snLF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1719016309; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YahOcd0GT7H1WMW76zlE3sMvGTtmpJ69A1gJsg09h8s=;
	b=Y226snLF0GTh03n+uXHPKJvHIhxKVUfAktQZbVvrhs+uveeFZwSbldj7ZL3gWhlr4n1d1/A1k4KVPowUgsa4VlFWPWozMBexV0/4OcPuE9xcPhy/mrrmBW9JYbbbVUiFzGtmW0S+et8RIgeUtvik4F0kKv9Dq5AXBtcxV/VqP8I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067111;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W8xZ2Xb_1719016308;
Received: from 192.168.31.113(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W8xZ2Xb_1719016308)
          by smtp.aliyun-inc.com;
          Sat, 22 Jun 2024 08:31:49 +0800
Message-ID: <6f97e658-6dcd-47e9-9cf4-3b413cdb5b57@linux.alibaba.com>
Date: Sat, 22 Jun 2024 08:31:45 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: lei lu <llfamsec@gmail.com>, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20240618065427.143612-1-llfamsec@gmail.com>
 <1af4ff4a-e963-4969-86cc-27419d326614@suse.com>
 <CAEBF3_Yeby=aeq21y5qq-pe9zP5OFV5Fo+FatwPV0cOnDJ+K_Q@mail.gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAEBF3_Yeby=aeq21y5qq-pe9zP5OFV5Fo+FatwPV0cOnDJ+K_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Heming，
Any more comments on this version?

Thanks,
Joseph

On 6/18/24 9:09 PM, lei lu wrote:
> On Tue, Jun 18, 2024 at 8:04 PM Heming Zhao <heming.zhao@suse.com> wrote:
>>
>> On 6/18/24 14:54, lei lu wrote:
>>> This adds sanity checks for ocfs2_dir_entry to make sure all members of
>>> ocfs2_dir_entry don't stray beyond valid memory region.
>>>
>>> Signed-off-by: lei lu <llfamsec@gmail.com>
>>> ---
>>>   fs/ocfs2/dir.c | 39 +++++++++++++++++++++++++--------------
>>>   1 file changed, 25 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>> index d620d4c53c6f..cdd92b4f9bf1 100644
>>> --- a/fs/ocfs2/dir.c
>>> +++ b/fs/ocfs2/dir.c
>>> @@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
>>>    * bh passed here can be an inode block or a dir data block, depending
>>>    * on the inode inline data flag.
>>>    */
>>> -static int ocfs2_check_dir_entry(struct inode * dir,
>>> -                              struct ocfs2_dir_entry * de,
>>> -                              struct buffer_head * bh,
>>> +static int ocfs2_check_dir_entry(struct inode *dir,
>>> +                              struct ocfs2_dir_entry *de,
>>> +                              struct buffer_head *bh,
>>> +                              char *buf,
>>> +                              unsigned int size,
>>>                                unsigned long offset)
>>>   {
>>>       const char *error_msg = NULL;
>>>       const int rlen = le16_to_cpu(de->rec_len);
>>> +     const unsigned long next_offset = ((char *) de - buf) + rlen;
>>
>> Hi Lei & Joseph,
>>
>> I withdraw my previous saying: the rest codes look good to me.
>>
>> I checked some code. In my view, if the code runs as expected,
>> next_offset should be equal to:  "((char *) de - bh->b_data) + rlen".
> 
> Hi,
> 
> As you said below, In inline mode, dir entry list starts at
> bh->b_data->id2.i_data,
> In the dir block mode, dir entry list starts at bh->b_data directly.
> 
> So the prerequisite for checking here is to make sure that buf is the first_de
> and size is the de list size. We make sure that de don't stray beyond the de
> list regardless of its mode.
> 
> The above patch code refers to the __ext4_check_dir_entry.
> 
>>
>> You could add codes here to verify, e.g:
>>    printk("...");
>>    BUG_ON(next_offset != (((char *)de - bh->b_data) + rlen));
>>
>> This BUG_ON() will never be triggered.
>>
>> Please take some time to build and run the test, If my thinking is right,
>> you need to send v6 patch.
>>
>> btw, please don't forget to check my below comments.
>> It seems your code also has other bug.
>>
>> @Joseph, I also need your opinion.
>>
>>>
>>>       if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>>>               error_msg = "rec_len is smaller than minimal";
>>> @@ -308,6 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
>>>               error_msg = "rec_len % 4 != 0";
>>>       else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
>>>               error_msg = "rec_len is too small for name_len";
>>> +     else if (unlikely(next_offset > size))
>>> +             error_msg = "directory entry overrun";
>>> +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
>>> +              next_offset != size)
>>> +             error_msg = "directory entry too close to end";
>>>       else if (unlikely(
>>>                ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
>>>               error_msg = "directory entry across blocks";
>>> @@ -352,16 +360,16 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>>>       de_buf = first_de;
>>>       dlimit = de_buf + bytes;
>>>
>>> -     while (de_buf < dlimit) {
>>> +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>>>               /* this code is executed quadratically often */
>>>               /* do minimal checking `by hand' */
>>>
>>>               de = (struct ocfs2_dir_entry *) de_buf;
>>>
>>> -             if (de_buf + namelen <= dlimit &&
>>> +             if (de->name + namelen <= dlimit &&
>>>                   ocfs2_match(namelen, name, de)) {
>>>                       /* found a match - just to be sure, do a full check */
>>> -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>> +                     if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, offset)) {
>>
>>
>> ocfs2 uses two ways to store dir entry:
>>   inline mode (OCFS2_INLINE_DATA_FL) & dir block mode
>>
>> Above function (ocfs2_search_dirblock) handles dir block case, the code
>> can work under expectation.
> 
> I think ocfs2_search_dirblock handles both two modes? Because In the caller
> ocfs2_find_entry_id, the first_de is from di_bh->b_data->id2.i_data->id_data.
> 
>>
>>>                               ret = -1;
>>>                               goto bail;
>>>                       }
>>> @@ -1138,7 +1146,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
>>>       pde = NULL;
>>>       de = (struct ocfs2_dir_entry *) first_de;
>>>       while (i < bytes) {
>>> -             if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
>>>                       status = -EIO;
>>>                       mlog_errno(status);
>>>                       goto bail;
>>> @@ -1635,7 +1643,7 @@ int __ocfs2_add_entry(handle_t *handle,
>>>               /* These checks should've already been passed by the
>>>                * prepare function, but I guess we can leave them
>>>                * here anyway. */
>>> -             if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
>>> +             if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start, size, offset)) {
>>>                       retval = -ENOENT;
>>>                       goto bail;
>>>               }
>>> @@ -1774,7 +1782,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>>>               }
>>>
>>>               de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
>>> -             if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
>>> +             if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
>>> +                                        i_size_read(inode), ctx->pos)) {
>>
>> This function (ocfs2_dir_foreach_blk_id) handles inline mode.
>>
>> The de & data->id_data are both located in the inode struct, starting at
>> offset 0xc8 in ((struct ocfs2_dinode)->id2.i_data). however di_bh->b_data
>> points to the start address of the inode.
>>
>> if ocfs2_check_dir_entry() uses de & data->id_data to compare the offset, it
>> misses the 0xc8 space.
>>
>>   struct ocfs2_dinode
>> +----------------------------------+
>> |   ...      |    id2.i_data       |
>> |            |---------------------|
>> |            |           |id_data[]|
>> ^------------------------^-------^-+
>> |                        |   ... |
>> 0x0                     0xc8     0xc8+xxx: de
>> di_bh->b_data         data->id_da
>>
>>
>> (This patch) in ocfs2_check_dir_entry(), it uses "de - data->id_da" to get
>> the offset. However, from the above pic, the algorithm is wrong; it forgets
>> the [0,0xc8].
>> the correct way: (de - bh->b_data)
>>
>> the same issue also occurs in ocfs2_find_dir_space_id().
>>
>>
>> Thanks,
>> Heming
>>
>>>                       /* On error, skip the f_pos to the end. */
>>>                       ctx->pos = i_size_read(inode);
>>>                       break;
>>> @@ -1867,7 +1876,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>>>               while (ctx->pos < i_size_read(inode)
>>>                      && offset < sb->s_blocksize) {
>>>                       de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
>>> -                     if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
>>> +                     if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
>>> +                                                sb->s_blocksize, offset)) {
>>>                               /* On error, skip the f_pos to the
>>>                                  next block. */
>>>                               ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
>>> @@ -3339,7 +3349,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>>       struct super_block *sb = dir->i_sb;
>>>       struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>>>       struct ocfs2_dir_entry *de, *last_de = NULL;
>>> -     char *de_buf, *limit;
>>> +     char *first_de, *de_buf, *limit;
>>>       unsigned long offset = 0;
>>>       unsigned int rec_len, new_rec_len, free_space;
>>>
>>> @@ -3352,14 +3362,15 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>>       else
>>>               free_space = dir->i_sb->s_blocksize - i_size_read(dir);
>>>
>>> -     de_buf = di->id2.i_data.id_data;
>>> +     first_de = di->id2.i_data.id_data;
>>> +     de_buf = first_de;
>>>       limit = de_buf + i_size_read(dir);
>>>       rec_len = OCFS2_DIR_REC_LEN(namelen);
>>>
>>>       while (de_buf < limit) {
>>>               de = (struct ocfs2_dir_entry *)de_buf;
>>>
>>> -             if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
>>> +             if (!ocfs2_check_dir_entry(dir, de, di_bh, first_de, i_size_read(dir), offset)) {
>>>                       ret = -ENOENT;
>>>                       goto out;
>>>               }
>>> @@ -3441,7 +3452,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
>>>                       /* move to next block */
>>>                       de = (struct ocfs2_dir_entry *) bh->b_data;
>>>               }
>>> -             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize, offset)) {
>>>                       status = -ENOENT;
>>>                       goto bail;
>>>               }
>>
