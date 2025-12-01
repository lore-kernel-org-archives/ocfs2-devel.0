Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D97E1C84C0;
	Mon,  1 Dec 2025 06:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764569288; cv=none; b=V10oF9Mxy8qayRqj5NKDggM5TFgQvUK2YxxBoszzLBmLjMQS1TJFpHa1wzOfoz3ty6ukENqC9YVOJYt8eoPGqBiWDGugo17Itpc4m9F215F8WW4uCEWDM56UTUV0RcCD31iaR68RZd+X2AT77+fF/mvVkl2ZkTLoa/UD9WH1x5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764569288; c=relaxed/simple;
	bh=Mr7xPTGZ1sVyHjYzV6u99VN7wHOlwTlKDJDNJt/dU5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OBJtQNWpSC60stoKp0NyNwDIM69Sp3hvvbKygLE0/78zVx9a70QAcTlVzwimOqWrpC44vfrEye0J7mxxOcLcvCtIEBGa/7gFJA8+cEmrfqM/IwlGU/doHWF92YK9QpvTjaoHwOTWWEZL7+70dB1vQtLify4gAxT+bRmT8EXtAag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=A+cdv0t0; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="A+cdv0t0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764569277; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nd0Hc2ha8jdK0dQE8Ie9fUBZvNiH7gzKqMotzEvH30c=;
	b=A+cdv0t0u/HK1LQP/xKcXp5lD/ze716oykFVvP4P0S45h+kx28dQvQZmkRdNA4ot5NTWzB6PsEDEr3JmFEPhLva/nJxPvhi/SgrYLbCE2EMhaTyZoSud8PaYMldLGJM6iWy9DuzyAXTkbZ1faTAOowk+W2JjZFWwJYV0pgJtEZ4=
Received: from 30.221.128.145(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WtmfiCJ_1764569275 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Dec 2025 14:07:56 +0800
Message-ID: <8a55832e-28cf-4272-b5b8-4fa07ae8c582@linux.alibaba.com>
Date: Mon, 1 Dec 2025 14:07:55 +0800
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
 <aS0sqmSpqWTi5T3v@inspiron>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <aS0sqmSpqWTi5T3v@inspiron>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/12/1 13:50, Prithvi Tambewagh wrote:
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
>>
>> Thanks,
>> Joseph
>>
>>> +        status = ocfs2_error(ac->ac_inode->i_sb,
>>> +                     "Chain allocator dinode %llu has 0 chains\n",
>>> +                     (unsigned long long)le64_to_cpu(fe->i_blkno));
>>> +        goto bail;
>>> +    }
>>> +
>>>      victim = ocfs2_find_victim_chain(cl);
>>>      ac->ac_chain = victim;
>>>
>>>
>>> base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
>>
> 
> Hello Joseph,
> 
> Thanks for the feedback! I will make the changes in the patch. I wanted to confirm that the new patch should be sent as v2 on this same thread, along with the change log since v1, right?
> 

No need on the same thread, just v2 with the change log since v1 is enough.

Joseph 

