Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7584A15B141
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 May 2024 06:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716963342; cv=none; b=PUa1w960B3qHxsZhgRwTr8YNH6ypH/RMJ36EQ+GK1f9R8s49wE2ALRIsHljJ9ygX5bml6Slllpuicu0AiaJP2f91LYXeqx+sxVo7lnFniHw3WiRyCP+HYRtORo1r0kW7VyWs7iq/Ccr2fcaYZItvKS0eYoC+UTT7zqITtZaYCrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716963342; c=relaxed/simple;
	bh=isbxkQVAOKVOfp1DI4pfP5p8WbkqvoFwMdTPVCVyYyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KtH54YWY+NCtH3GsmO7reKeuxGTAlHjQ6wG7YKjdlzvKGZa6eiQKhvvxtB0b8YCw910atRHLQF4NFcCAIvoKONvUWVrEolbNJKAZDZhyFKTchtPhYlHTkuqA/ycafG5afUrj0qVCdioUnHusgULAGr6+qbKWTG/LmxiLeLpYdB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RF6qg4aH; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RF6qg4aH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716963338; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jhBba5L+bzx1rsNzc/SPiQxBhw3LBCx9EX87LltCNos=;
	b=RF6qg4aHK8RzQWAFamozBKaFCmfzThZxZPreTAkvUcjMmHLimq2FU2Zv3mxIrOZdSOGZh+KEFaiDgp+A+cfbJOqdiMZtvdUkGDMvbOdWQ/MEozQEYbdPl+6PjuK1MZ4myktmJYH3q9UL/JcPg0AAOi4o7lL1CYuQaDqDlkekk8k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045075189;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W7RihPn_1716963336;
Received: from 30.221.129.43(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W7RihPn_1716963336)
          by smtp.aliyun-inc.com;
          Wed, 29 May 2024 14:15:37 +0800
Message-ID: <89f8c4b1-46c5-4eec-9595-5cf456621887@linux.alibaba.com>
Date: Wed, 29 May 2024 14:15:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add bounds checking to ocfs2_search_dirblock()
To: lei lu <llfamsec@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev
References: <20240528120140.15550-1-llfamsec@gmail.com>
 <22f06d3c-5781-43d8-8169-678ef2299ddb@linux.alibaba.com>
 <CAEBF3_bE4vkF3En7MKJFbgvRruS-n61g5RiuMDk6nT4ig7GmZg@mail.gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAEBF3_bE4vkF3En7MKJFbgvRruS-n61g5RiuMDk6nT4ig7GmZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/29/24 11:18 AM, lei lu wrote:
> Joseph Qi <joseph.qi@linux.alibaba.com> 于2024年5月29日周三 09:33写道：
>>
>>
>>
>> On 5/28/24 8:01 PM, lei lu wrote:
>>> Add a check to make sure all members of the ocfs2_dir_entry
>>> don't stray beyond valid memory region.
>>>
>>> Signed-off-by: lei lu <llfamsec@gmail.com>
>>> ---
>>>  fs/ocfs2/dir.c | 15 ++++++++-------
>>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>> index d620d4c53c6f..56e2f8c62106 100644
>>> --- a/fs/ocfs2/dir.c
>>> +++ b/fs/ocfs2/dir.c
>>> @@ -352,19 +352,20 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
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
>>> +             /* do a full check */
>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>> +                     ret = -1;
>>> +                     goto bail;
>>> +             }
>>
>> What's the difference by moving full check above?
>> As I commented in v1, we may add a more check in ocfs2_check_dir_entry().
> 
> Thanks for your time.
> 
> If no match is found, there is no check for de. I'm not sure if there
> will be any OOB elsewhere when "de->rec_len <
> OCFS2_DIR_REC_LEN(de->name_len)".
> 
> I'm not sure what "(de - bh->b_data) + de_len > bytes -
> OCFS2_DIR_REC_LEN(de->name_len)" means in V1, bh->b_data is the start
> offset of ocfs2_dinode. bytes is just the size of the de list. Maybe
> we should check "((char *) de - bh->b_data) + rlen > sizeof(struct
> ocfs2_dinode) + bytes" which is same as "((char *) de - bh->b_data) +
> rlen > dlimit".
> 

You can refer ext4_check_dir_entry() for details.

>>
>>> +
>>> +             if (de->name + namelen <= dlimit &&
>>
>> As discussed in v1, this change looks reasonable.
>>
>> Thanks,
>> Joseph
>>
>>>                   ocfs2_match(namelen, name, de)) {
>>> -                     /* found a match - just to be sure, do a full check */
>>> -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
>>> -                             ret = -1;
>>> -                             goto bail;
>>> -                     }
>>>                       *res_dir = de;
>>>                       ret = 1;
>>>                       goto bail;
