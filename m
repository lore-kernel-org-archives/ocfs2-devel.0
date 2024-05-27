Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E537F10E4
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 May 2024 03:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716780743; cv=none; b=EliVaqF/0eVlX1K/NxQ6a0+Cxbx738/2IAnRR95sr5KN5qZwWTXQJrA6EZMOpSWPx+DdJJx2a1EkeS+yqmDvGQhfS6vO+1IYEyxRk6yszmwoMLDXZPP6w01El36C7FUKDfTuUby64fYgddG6zOx2de6+vrq+tVe+E//ziWHWMYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716780743; c=relaxed/simple;
	bh=yn+cbqP583YJdlOLjztmyPQpFo4tMaUqPqoiqAmDuvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X+xwPpVU1e5gYWdwF+4OWC0PmdnaRB+Obpt71Z1Snz6BBto1REY+1j27BI2nh0RSh7n2fTArctkUiJOxwGhMvHIv96xSVu+0amcbtD1bSf2nZ8NWfsbrKzUFEmL9IGsmDqgFimDpbT0fi+4IPL1nSNSbPf1dqHBXs1ACnhdgph4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ta8Umyjd; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ta8Umyjd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716780730; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=QVCxb7S4ueaSi+l2yA1OVtkoCRaQevtwGnT3fWJMfpM=;
	b=ta8UmyjdCK2I79omHYEw7p/ZlhifPrzmBqDdrP+4fVAnI4BYc/ZIchKYtjKEpDeYPyOuPvucNeSeUMkFVJ4XdRHtEdRiZygrDEyX1mmxruLBclRBMPIT9syUlLdvL5X663BR88z4nbh3dxfH9ttl3QZDpb2sexsqElX+nespxbk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033022160150;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W7DF54._1716780728;
Received: from 30.221.129.180(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W7DF54._1716780728)
          by smtp.aliyun-inc.com;
          Mon, 27 May 2024 11:32:09 +0800
Message-ID: <3438b583-a48a-4517-99b4-8115207804a5@linux.alibaba.com>
Date: Mon, 27 May 2024 11:32:08 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add bounds checking to ocfs2_search_dirblock()
To: lei lu <llfamsec@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20240526110631.10618-1-llfamsec@gmail.com>
 <059f5953-4f6d-4580-9bc5-685a03364987@linux.alibaba.com>
 <CAEBF3_b6uSbo5s6dk=Vvt+mYzSjzzx0RMnaHQcc+YdWco6Dpzw@mail.gmail.com>
 <CAEBF3_anUzNk6gwLG0d=_5QyWeStvkmp_nT9Z_k9fFdjvJ-wiQ@mail.gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAEBF3_anUzNk6gwLG0d=_5QyWeStvkmp_nT9Z_k9fFdjvJ-wiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/24 11:19 AM, lei lu wrote:
> code in ocfs2_search_dirblock:
> if (de_buf + namelen <= dlimit &&
>     ocfs2_match(namelen, name, de)) {
> 
> I'm not sure what "de_buf + namelen < dlimit" means. I think "de_buf +
> namelen" maybe "<= dlimit", but "((struct ocfs2_dir_entry *) de_buf)->name
> + namelen" maybe "> dlimit". Or maybe we should check "de->name + namelen
> <= dlimit" here?
> 

Yes, I think you are right.
de->name + namelen is a more precisely check.

Thanks,
Joseph

> lei lu <llfamsec@gmail.com> 于2024年5月27日周一 11:11写道：
> 
>>> It seems that this check can be moved to:
>>> while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>>>        ...
>>> }
>>
>> Right, it also work.
>>
>>> dlimit = de_buf + bytes;
>>> So here you mean check de_len < bytes?
>>>
>>> Or should we check more precisely, like in ocfs2_check_dir_entry():
>>> (de - bh->b_data) + de_len > bytes - OCFS2_DIR_REC_LEN(de->name_len)
>>
>> "de_buf + OCFS2_DIR_MEMBER_LEN > dlimit" checks the fixed members don't
>> stray beyond valid memory region, and "de_buf + de_len > dlimit" for the
>> whole de. You should mean "((char *) de - bh->b_data) + de_len > dlimit"
>> which is similar to "((char *) de - bh->b_data) + rlen >
>> dir->i_sb->s_blocksize)" in ocfs2_check_dir_entry. But dlimit which is end
>> of the de list may not reach the block end.
>>
>>> This is already done in ocfs2_check_dir_entry().
>>
>> Right, We need to check "de_len < OCFS2_DIR_REC_LEN(de->name_len)" before
>> "ocfs2_match(namelen, name, de)", because if de->name_len is too large, I
>> think maybe trigger anther OOB in ocfs2_match. Or we should call
>> ocfs2_check_dir_entry earlier to do a full check for de.
>>
>> Joseph Qi <joseph.qi@linux.alibaba.com> 于2024年5月27日周一 10:33写道：
>>
>>>
>>>
>>> On 5/26/24 7:06 PM, lei lu wrote:
>>>> Add a check to make sure all members of the ocfs2_dir_entry
>>>> don't stray beyond valid memory region.
>>>>
>>>> Signed-off-by: lei lu <llfamsec@gmail.com>
>>>> ---
>>>>  fs/ocfs2/dir.c | 12 +++++++++++-
>>>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>>> index d620d4c53c6f..385576d86983 100644
>>>> --- a/fs/ocfs2/dir.c
>>>> +++ b/fs/ocfs2/dir.c
>>>> @@ -358,6 +358,17 @@ static inline int ocfs2_search_dirblock(struct
>>> buffer_head *bh,
>>>>
>>>>               de = (struct ocfs2_dir_entry *) de_buf;
>>>>
>>>> +             if (unlikely(de_buf + OCFS2_DIR_MEMBER_LEN > dlimit)) {
>>>> +                     ret = -1;
>>>> +                     goto bail;
>>>> +             }
>>>
>>> It seems that this check can be moved to:
>>> while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
>>>         ...
>>> }
>>>
>>>> +             de_len = le16_to_cpu(de->rec_len);
>>>> +             if (unlikely(de_buf + de_len > dlimit) ||
>>>
>>> dlimit = de_buf + bytes;
>>> So here you mean check de_len < bytes?
>>>
>>> Or should we check more precisely, like in ocfs2_check_dir_entry():
>>> (de - bh->b_data) + de_len > bytes - OCFS2_DIR_REC_LEN(de->name_len)
>>>
>>>> +                 unlikely(de_len < OCFS2_DIR_REC_LEN(de->name_len))) {
>>>
>>> This is already done in ocfs2_check_dir_entry().
>>>
>>>> +                     ret = -1;
>>>> +                     goto bail;
>>>> +             }
>>>> +
>>>>               if (de_buf + namelen <= dlimit &&
>>>>                   ocfs2_match(namelen, name, de)) {
>>>>                       /* found a match - just to be sure, do a full
>>> check */
>>>> @@ -371,7 +382,6 @@ static inline int ocfs2_search_dirblock(struct
>>> buffer_head *bh,
>>>>               }
>>>>
>>>>               /* prevent looping on a bad block */
>>>> -             de_len = le16_to_cpu(de->rec_len);
>>>>               if (de_len <= 0) {
>>>>                       ret = -1;
>>>>                       goto bail;
>>>
>>
> 
