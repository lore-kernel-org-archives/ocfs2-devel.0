Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D264528850D;
	Mon,  1 Dec 2025 07:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764572885; cv=none; b=uYN+pu3MhQGP+gi40o7YdPFoQNrr26zdq6wrYVfvtGmLvw0PF6j16jn+yfL1l8Q3MJZ63EAQWIR1yjTKF7oWqJ5LQ8OQtcsGO3nHPK+6BSI8fiDQMnn2ITcIhamx0NsNxXNFpZMRGXstMGyIBSlozz2Uhzh7JkV7+S+kR27ZOts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764572885; c=relaxed/simple;
	bh=S06juqHVjicOczAN6JTT4WVs2mZTTplBtAuw26LgCNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d/VwoMg/JcCVKcABC/HgF6k7/TlRDTuAriTdAOwEPXYFRvIRR3EPoIVWwGgakFulQUeW4atZGTMzqGH97TIzLMv2XzwMaZnJxgNOnmJGN3OMEys32OymY1cXaZ51N4jm7QTAZ098rlLqOUEZT4k91WbdwdBShGh6F8nO06FHakE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LwJViD2x; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LwJViD2x"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764572878; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=65ts2tSozbLS4nc4j0Zy7UOSSpN0krZAx0hDzrMNelk=;
	b=LwJViD2xts42pgzIllOGXiakJSHSpCm/zIWNFwDRNNOnaOFf93OTQThFK0g0AXBFZwBBYx+i9Ed5MH25hmonCEbNNyy1JYjrRn6WomBmLsyHVZY3Gt6GCqgZG+5/svsHqAdcjoFhahnvUbmP2xyG1sqUYmhjaQnSX2qaTL8uhdQ=
Received: from 30.221.128.145(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wtnenh7_1764572877 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Dec 2025 15:07:57 +0800
Message-ID: <95804297-3a21-4024-8eb0-e75e8a3c4f87@linux.alibaba.com>
Date: Mon, 1 Dec 2025 15:07:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
To: Prithvi Tambewagh <activprithvi@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
 skhan@linuxfoundation.org, david.hunter.linux@gmail.com, khalid@kernel.org,
 syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
References: <20251130104637.264258-1-activprithvi@gmail.com>
 <6d27a5aa-1e32-4dd3-997c-ddc015be88a3@linux.alibaba.com>
 <aS00nMK1juomYZkN@inspiron>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <aS00nMK1juomYZkN@inspiron>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/12/1 14:24, Prithvi Tambewagh wrote:
> On Mon, Dec 01, 2025 at 10:51:49AM +0800, Joseph Qi wrote:
>>
>>
>> On 2025/11/30 18:46, Prithvi Tambewagh wrote:
>>> syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
>>> `cl_next_free_rec` field of the allocation chain list is 0, triggring the
>>> BUG_ON(!cl->cl_next_free_rec) condition and panicking the kernel.
>>>
>>> To fix this, `cl_next_free_rec` is checked inside the caller of
>>> ocfs2_find_victim_chain() i.e. ocfs2_claim_suballoc_bits() and if it is
>>> equal to 0, ocfs2_error() is called, to log the corruption and force the
>>> filesystem into read-only mode, to prevent further damage.
>>>
>>> Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
>>> Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
>>> ---
>>>  fs/ocfs2/suballoc.c | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>>> index 6ac4dcd54588..84bb2d11c2aa 100644
>>> --- a/fs/ocfs2/suballoc.c
>>> +++ b/fs/ocfs2/suballoc.c
>>> @@ -1993,6 +1993,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>>>
>>>      cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
>>>
>>
>> This blank line can be eliminated.
>>
>>> +    if (le16_to_cpu(cl->cl_next_free_rec) == 0) {
>>
>> Better to add the upper limit check as well. e.g.
>>
>> !le16_to_cpu(cl->cl_next_free_rec) ||
>> le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)
> 
> Hello Joseph,
> 
> I went through the code in fs/ocfs2/suballoc.c, like this function
> static inline u16 ocfs2_find_smallest_chain(struct ocfs2_chain_list *cl)
> {
>     u16 curr, best;
> 
>     best = curr = 0;
>     while (curr < le16_to_cpu(cl->cl_count)) {
>         if (le32_to_cpu(cl->cl_recs[best].c_total) >
>             le32_to_cpu(cl->cl_recs[curr].c_total))
>             best = curr;
>         curr++;
>     }
>     return best;
> }
> 
> and in function ocfs2_block_group_alloc() these lines
> if (le16_to_cpu(cl->cl_next_free_rec) < le16_to_cpu(cl->cl_count))
>     le16_add_cpu(&cl->cl_next_free_rec, 1);
> 
After this, cl_next_free_rec may equal to cl_count.


> and observed that according to the architecture of ocfs2, the chain list is in the form of 0-indexed array. In that case, the change you suggested for upper limit, could be re-written as
> le16_to_cpu(cl->cl_next_free_rec) >= le16_to_cpu(cl->cl_count)
> 
> since value of cl->cl_next_free_rec greater than or equal to cl->cl_count will indicate that there are no available chains. Can you please review this?
> 
Yes, it's full. But 'cl_next_free_rec == cl_count' is a designed behavior, see mkfs or fsck.

Joseph

