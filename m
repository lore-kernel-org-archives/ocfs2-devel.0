Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFE51940B1
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jun 2024 23:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719445304; cv=none; b=H+ztZ5wiiqCgeTeV7j4+BM65Bo+fMAnfLpDErHATQS+FPr1dtmxJWUDsuQvklUCTSKxjNbkoyTFS+h2Mw4icIAuoLU6XSbF/axnQ6e779VbZFdZNoSw73S89hsc1mFpEGjn2+QOHnvRJzrCQnXeKRnTK6fV2nxDT/VwJjquiHKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719445304; c=relaxed/simple;
	bh=UCMi93VfUaosbAattyv3tcM6wncJnhJtwc9aHc+AFzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OpnBL7qlvgDr+J0U4eGDPdMvQVnIsFFSNp+gGZeZ/eR3hTO6LH9PMI2czriVdHtCbotKwHMqE67tBNXbkrNjXfu5xj++BLzftRS57kmbdxVovZf052pU8ny4l52yRI7dhJ4Ve3ZOwkVgsIUApGv7S/gEZ/pbdaUN4bXClAEL934=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KOmykp/u; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KOmykp/u"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1719445298; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jRTLwCmUOROhm11K9m0qxi79ASP7rRkJ4eM89yHbBvg=;
	b=KOmykp/uYV+pBqdgDsaIiHgbi0chyG9RMk1JKYwqCKXjfMXoAuJGDEcX0IGY584afKj1mynKGmfUEN1o7OvFnuiFFvk0fvsxiRvjmKXS3fxngxILPuvfFcRLF9kXrDgPX7ecy0zUnYH5PUZxwhhhdTLj2Qzi14LHitnJNYWncjw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045075189;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W9KfV4u_1719445296;
Received: from 30.120.133.163(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W9KfV4u_1719445296)
          by smtp.aliyun-inc.com;
          Thu, 27 Jun 2024 07:41:37 +0800
Message-ID: <e99dce61-b618-4df6-b492-6d48992a526e@linux.alibaba.com>
Date: Thu, 27 Jun 2024 07:41:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: Heming Zhao <heming.zhao@suse.com>, lei lu <llfamsec@gmail.com>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev
References: <20240626104433.163270-1-llfamsec@gmail.com>
 <8c923e93-fcdb-4dee-9a7c-f854f35482b9@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <8c923e93-fcdb-4dee-9a7c-f854f35482b9@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 6/26/24 8:45 PM, Heming Zhao wrote:
> On 6/26/24 18:44, lei lu wrote:
>> This adds sanity checks for ocfs2_dir_entry to make sure all members of
>> ocfs2_dir_entry don't stray beyond valid memory region.
>>
>> Signed-off-by: lei lu <llfamsec@gmail.com>
> 
> 
> Looks good to me.
> 
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> 

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

>> ---
>>   fs/ocfs2/dir.c | 46 +++++++++++++++++++++++++++++-----------------
>>   1 file changed, 29 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index d620d4c53c6f..f0beb173dbba 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
>>    * bh passed here can be an inode block or a dir data block, depending
>>    * on the inode inline data flag.
>>    */
>> -static int ocfs2_check_dir_entry(struct inode * dir,
>> -                 struct ocfs2_dir_entry * de,
>> -                 struct buffer_head * bh,
>> +static int ocfs2_check_dir_entry(struct inode *dir,
>> +                 struct ocfs2_dir_entry *de,
>> +                 struct buffer_head *bh,
>> +                 char *buf,
>> +                 unsigned int size,
>>                    unsigned long offset)
>>   {
>>       const char *error_msg = NULL;
>>       const int rlen = le16_to_cpu(de->rec_len);
>> +    const unsigned long next_offset = ((char *) de - buf) + rlen;
>>         if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>>           error_msg = "rec_len is smaller than minimal";
>> @@ -308,9 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
>>           error_msg = "rec_len % 4 != 0";
>>       else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
>>           error_msg = "rec_len is too small for name_len";
>> -    else if (unlikely(
>> -         ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
>> -        error_msg = "directory entry across blocks";
>> +    else if (unlikely(next_offset > size))
>> +        error_msg = "directory entry overrun";
>> +    else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
>> +         next_offset != size)
>> +        error_msg = "directory entry too close to end";
>>         if (unlikely(error_msg != NULL))
>>           mlog(ML_ERROR, "bad entry in directory #%llu: %s - "
>> @@ -352,16 +357,17 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
>>       de_buf = first_de;
>>       dlimit = de_buf + bytes;
>>   -    while (de_buf < dlimit) {
>> +    while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>>           /* this code is executed quadratically often */
>>           /* do minimal checking `by hand' */
>>             de = (struct ocfs2_dir_entry *) de_buf;
>>   -        if (de_buf + namelen <= dlimit &&
>> +        if (de->name + namelen <= dlimit &&
>>               ocfs2_match(namelen, name, de)) {
>>               /* found a match - just to be sure, do a full check */
>> -            if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>> +            if (!ocfs2_check_dir_entry(dir, de, bh, first_de,
>> +                           bytes, offset)) {
>>                   ret = -1;
>>                   goto bail;
>>               }
>> @@ -1138,7 +1144,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
>>       pde = NULL;
>>       de = (struct ocfs2_dir_entry *) first_de;
>>       while (i < bytes) {
>> -        if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
>> +        if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
>>               status = -EIO;
>>               mlog_errno(status);
>>               goto bail;
>> @@ -1635,7 +1641,8 @@ int __ocfs2_add_entry(handle_t *handle,
>>           /* These checks should've already been passed by the
>>            * prepare function, but I guess we can leave them
>>            * here anyway. */
>> -        if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
>> +        if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start,
>> +                       size, offset)) {
>>               retval = -ENOENT;
>>               goto bail;
>>           }
>> @@ -1774,7 +1781,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
>>           }
>>             de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
>> -        if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
>> +        if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
>> +                       i_size_read(inode), ctx->pos)) {
>>               /* On error, skip the f_pos to the end. */
>>               ctx->pos = i_size_read(inode);
>>               break;
>> @@ -1867,7 +1875,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>>           while (ctx->pos < i_size_read(inode)
>>                  && offset < sb->s_blocksize) {
>>               de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
>> -            if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
>> +            if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
>> +                           sb->s_blocksize, offset)) {
>>                   /* On error, skip the f_pos to the
>>                      next block. */
>>                   ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
>> @@ -3339,7 +3348,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>       struct super_block *sb = dir->i_sb;
>>       struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>>       struct ocfs2_dir_entry *de, *last_de = NULL;
>> -    char *de_buf, *limit;
>> +    char *first_de, *de_buf, *limit;
>>       unsigned long offset = 0;
>>       unsigned int rec_len, new_rec_len, free_space;
>>   @@ -3352,14 +3361,16 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>       else
>>           free_space = dir->i_sb->s_blocksize - i_size_read(dir);
>>   -    de_buf = di->id2.i_data.id_data;
>> +    first_de = di->id2.i_data.id_data;
>> +    de_buf = first_de;
>>       limit = de_buf + i_size_read(dir);
>>       rec_len = OCFS2_DIR_REC_LEN(namelen);
>>         while (de_buf < limit) {
>>           de = (struct ocfs2_dir_entry *)de_buf;
>>   -        if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
>> +        if (!ocfs2_check_dir_entry(dir, de, di_bh, first_de,
>> +                       i_size_read(dir), offset)) {
>>               ret = -ENOENT;
>>               goto out;
>>           }
>> @@ -3441,7 +3452,8 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
>>               /* move to next block */
>>               de = (struct ocfs2_dir_entry *) bh->b_data;
>>           }
>> -        if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>> +        if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize,
>> +                       offset)) {
>>               status = -ENOENT;
>>               goto bail;
>>           }
