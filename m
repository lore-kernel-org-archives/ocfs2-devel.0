Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948B21DFCB
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 01:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760406622; cv=none; b=MHuZG0e4tlCRJd6lXz8pA25fCzBoP3sN7UQxcYzftgStxwVdRvS2LC0jyk4pcGNFEwpZB0/CHAlDT9sLfTOtw578AiT0l5mYYy9WU0AFhk+jaDxxcjsTJ+wxSKfWGagixXv+2Hxb82c9l8JpnYYr/aBkTYHYoh9zDc7IMW7XPDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760406622; c=relaxed/simple;
	bh=PQNxGGumugj9aH0dTYJS4VS5zuo/m44xQg2NmTec9Fs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HN06qRNjjwc8kTGlzNWbEMIAsV9UsKwnccPk7x7SVfvCLGdhlrJq300oDxzg8b/RVw+hEjnPiJBfkAvma5FycIEpxY8qSjySILoN0xzJaTaVuYF58KjCLIycvr0XAhujMT0BVK3aL4XuW1q8U9J58c9kLjRlNwIeZKiWUuINvLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VGwMeQwZ; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VGwMeQwZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760406608; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7+NFG660eEbV4xby1BalJ48cNaoHJOhLTyVrInEsLXo=;
	b=VGwMeQwZuiTlRS9/4kR0h356YBY0JSmmL1jiVz691zeQlcYCuFSD8CYxSUMVDsxi/jMRPfqf7ZnE2NxMyWUvKuU8TnLnlAMhB13NZjcAYrL3mzLk70nQn1i30EAxErJqdHvDBVHNr31tvfkRFJDBRkbve4kpIginWHaVh7aRTqo=
Received: from 30.221.128.131(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wq9tArR_1760406606 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Oct 2025 09:50:07 +0800
Message-ID: <17ed3d05-ef27-44dd-83a0-a8bdb0069511@linux.alibaba.com>
Date: Tue, 14 Oct 2025 09:50:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix __counted_by_le() usage in
 ocfs2_expand_inline_dx_root()
To: Heming Zhao <heming.zhao@suse.com>, Dmitry Antipov <dmantipov@yandex.ru>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20251013153002.167377-1-dmantipov@yandex.ru>
 <0383ab66-9b8a-4e10-b6a9-d25d127dd797@linux.alibaba.com>
 <9efedaaf-3600-4d1e-9fb7-77f55f1524e5@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <9efedaaf-3600-4d1e-9fb7-77f55f1524e5@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/10/14 09:44, Heming Zhao wrote:
> Hi,
> 
> I have a different view.
> 
> On 10/14/25 08:55, Joseph Qi wrote:
>>
>>
>> On 2025/10/13 23:30, Dmitry Antipov wrote:
>>> After annotating 'l_recs[]' VLA member of 'struct ocfs2_extent_list'
>>> with '__counted_by_le(l_count)', 'l_count' should be initialized
>>> before touching 'l_recs[]' with 'memset()' to avoid false positives
>>> from buffer overflow guards when CONFIG_UBSAN_BOUNDS is enabled.
>>>
>>> Fixes: aa545adbe491 ("ocfs2: annotate flexible array members with __counted_by_le()")
>>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
>>
>> Looks fine.
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>>
>> Andrew, could you please help fold this into the origin patch? Thanks.
>>
>>> ---
>>> note: since the commit in subject is not merged to upstream yet, Fixes: reference is taken from
>>> https://web.git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-unstable&id=aa545adbe491
>>> ---
>>>   fs/ocfs2/dir.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>> index 3c2dacba9b0a..d9a2fcb63bbb 100644
>>> --- a/fs/ocfs2/dir.c
>>> +++ b/fs/ocfs2/dir.c
>>> @@ -4133,10 +4133,10 @@ static int ocfs2_expand_inline_dx_root(struct inode *dir,
>>>       }
>>>         dx_root->dr_flags &= ~OCFS2_DX_FLAG_INLINE;
>>> -    memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
>>> -           offsetof(struct ocfs2_dx_root_block, dr_list));
>>>       dx_root->dr_list.l_count =
>>>           cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
> 
> If the memset cleans dx_root->dr_list->l_recs[], or "osb->sb->s_blocksize -
> (offsetof(struct ocfs2_dx_root_block, dr_list) + offsetof(struct ocfs2_extent_list, l_recs))" this patch is correct.
> 
> But the subsequent memset() call cleans all the members of dr_list.
> Therefore, dr_list.l_count is reset to ZERO and the data is corrupted.
> 
Oops, my mistake.
Yes, you're right. Thanks for pointing out this.

Joseph

