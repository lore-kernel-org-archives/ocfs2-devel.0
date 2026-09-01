Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F60240DB3A
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 02:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788228491; cv=none; b=rrFZaKvO6SCEFWPmNqohIoZOota3n5gPkp4I6PA+tsopyYY6iDLwCaj8BPXk/dv7WNmPn59RYwjS+WcX8ZEwQt/10SPGV6y0krtKSnzVnGkYpX016dgCgJGMNXWgIrRzxr9YzapHbEf6vElOPfDByng9/1qnWltF6pwtTiSOABc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788228491; c=relaxed/simple;
	bh=n2eTo19hzzaJ24YL0udYA8ikboAPaYouSlWaKbg0mOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t08/P3PYPSLoh5FFoCDh2CKbM9fLpOiE2CIdldqpm5TKfAUkfmpj7bqmQ/nrelZMxnQgZZ8nwW9zi5BUQ0+2g4q5ioGMNDdkyZtWmBg+c1U0DjJaB5Bfdf8po1jCMTeWDtnrA2azASU7Myf7Yx54mYjacVAAQXLwNIVqgtB0VMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=srNMLOxE; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="srNMLOxE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788228482; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MAo2auWarsrlDgShc458uK/DPcXNNrbc9ue+v4W8czo=;
	b=srNMLOxEdwex3/wPpkzTRrlw3xg2PamFFJGp34OUgbnHKIVClB4OerD8jtKMPi0Q7M5nLEk8rUBra8atQ1oSD7AeAt7HeE/Dg6SWf4Lphb5chEHyzpOVrK7EdUFrXm5EuaI8FvLHSNbKaUqOxBtTShSyEibtXC+F2M8pM2SwXPA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA1AfdL_1788228480;
Received: from 30.221.129.88(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA1AfdL_1788228480 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 10:08:01 +0800
Message-ID: <c108020d-95d5-4efc-9590-06279b400ce7@linux.alibaba.com>
Date: Tue, 1 Sep 2026 10:08:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to
 system inodes
To: Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
 <20260831062848.2743436-2-joseph.qi@linux.alibaba.com> <apWJLyCNwqfdiRQb@p15>
 <fdd373d2-0c70-4a64-b2da-50f2dac194b1@linux.alibaba.com>
 <apYnADntUmNwIgcj@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <apYnADntUmNwIgcj@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/1/26 9:16 AM, Heming Zhao wrote:
> On Tue, Sep 01, 2026 at 09:08:26AM +0800, Joseph Qi wrote:
>>
>>
>> On 8/31/26 10:02 PM, Heming Zhao wrote:
>>> On Mon, Aug 31, 2026 at 02:28:45PM +0800, Joseph Qi wrote:
>>>> ocfs2_validate_inode_block() currently permits i_suballoc_slot to be
>>>> OCFS2_INVALID_SLOT for any dinode.  Only system inodes created by
>>>> mkfs.ocfs2 are allocated from the global allocator and thus
>>>> legitimately carry this value; regular inodes are always allocated
>>>> from a per-slot suballocator and hence must have a valid slot.
>>>>
>>>> If a corrupted regular inode with OCFS2_INVALID_SLOT is accepted,
>>>> ocfs2_remove_inode() will pass the slot to ocfs2_get_system_file_inode()
>>>> and get_local_system_inode() will hit BUG_ON(slot == OCFS2_INVALID_SLOT)
>>>> when the inode is deleted.  This can be triggered by an unprivileged
>>>> user unlinking such a corrupted file.
>>>>
>>>> Reject OCFS2_INVALID_SLOT for non-system dinodes during validation,
>>>> while still accepting it for system inodes.
>>>>
>>>> Fixes: fe7a283b3916 ("ocfs2: add suballoc slot check in ocfs2_validate_inode_block()")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>>>
>>> LGTM.
>>> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
>>
>> Thanks, sashiko has some review comments, I'll fix them and send v2 later.
>>
>> Joseph
> 
> It seems sashiko review comments only go to the patch submitter/author.
> In my view, they're also sent to ocfs2-devel@lists.linux.dev, which is nice as 
> it lets others on the list see them."
> 

Yes, now it only sends to author and maintainers.
I'll send a patch to cc list as well.

Thanks,
Joseph
