Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60451E4BE
	for <ocfs2-devel@lists.linux.dev>; Sat, 16 May 2026 13:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778937069; cv=none; b=ZgwFoEEmx+5swHxBnA7fpvNsCBwRdDGwkyq6Ls+yno6OHppvzcp51j8LhF0fCc0iB6Q2jmb4rJT7jvgWGDag4m0WQwLYCoMejiGuK3jTTtci7Qw0JqgnXplJ7hfk+SpPyC2GtJqCYx7wEoEqFDy12lzSC/YVGnlq3rtx7ZLtYMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778937069; c=relaxed/simple;
	bh=Ljrzvk5mmX+3sep2leTRQetaOeNaGYUgwr9lIdyMDTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lGHRMKVaHsvs6HLrhKmqfLtEN2y2kQuTspI0hx2ASJacfi/vxZW5eYPKMnuv6mSkO4507hBax+7WFUo4+o/52brg9KhJ+lgo08IReI2O7e/Tvb0yz3o4khVKOPk2KUyoYJw3eUV/TY0Jl5dRSOR36LlBOEwe+/BvPP54R+d5Xl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 64GDAkrL008892;
	Sat, 16 May 2026 22:10:46 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 64GDAk0D008889
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 16 May 2026 22:10:46 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <670882aa-b637-4565-adf0-ddcd9d7a588b@I-love.SAKURA.ne.jp>
Date: Sat, 16 May 2026 22:10:44 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
To: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        jiangyiwen <jiangyiwen@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
 <agc8kA2wxC_7091p@c73> <ageuwl9o3nzktMrz@c73>
 <fb0685c4-bcee-4c7b-8ac4-a1af702b8600@I-love.SAKURA.ne.jp>
 <aghfx-XhwoE4fBYR@c73>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <aghfx-XhwoE4fBYR@c73>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav104.rs.sakura.ne.jp

On 2026/05/16 21:27, Heming Zhao wrote:
>>>> In my opinion, the problem with the current code is that the scope of
>>>> mutex_lock(&osb->system_file_mutex) is too broad. This mutex only needs to be
>>>> held prior to calling _ocfs2_get_system_file_inode(). I previously highlighted
>>>> this point in my initial review comment on the patch.
>>
>> If you meant
>>
>>  struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>>                                           int type,
>>                                           u32 slot)
>>  {
>>         struct inode *inode = NULL;
>>         struct inode **arr = NULL;
>>
>>         /* avoid the lookup if cached in local system file array */
>>         if (is_global_system_inode(type)) {
>>                 arr = &(osb->global_system_inodes[type]);
>>         } else
>>                 arr = get_local_system_inode(osb, type, slot);
>>
>> -       mutex_lock(&osb->system_file_mutex);
>>         if (arr && ((inode = *arr) != NULL)) {
>>                 /* get a ref in addition to the array ref */
>>                 inode = igrab(inode);
>>                 mutex_unlock(&osb->system_file_mutex);
>>                 BUG_ON(!inode);
>>
>>                 return inode;
>>         }
>>
>> +       mutex_lock(&osb->system_file_mutex);
>> +
>>         /* this gets one ref thru iget */
>>         inode = _ocfs2_get_system_file_inode(osb, type, slot);
>>
>>         /* add one more if putting into array for first time */
>>         if (arr && inode) {
>>                 *arr = igrab(inode);
>>                 BUG_ON(!*arr);
>>         }
>>         mutex_unlock(&osb->system_file_mutex);
>>         return inode;
>>  }
>>
> 
> Yes, this is what I expected.
> 
>> , that brings us back to before commit 43b10a20372d, for two threads can hit
>> the "*arr = igrab(inode)" line.
> 
> I don't think this bring us back, because igrab() uses a spinlock to protect the
> refcount.

You are missing the point. What is wrong with above change is that two threads can
sequentially enter into the "if (arr && inode) { }" block, for we are not checking
whether the slot is already NULL or not. The cmpxchg() is the magic that guarantees
that only one thread can enter into that block.

>>
>> Even if you also change the "if (arr && inode) {" check in order to make sure that
>> the second-reached thread won't again hit the "*arr = igrab(inode)" line when the
>> first-reached thread already hit the "*arr = igrab(inode)" line, the second-reached
>> thread is fully blocked by the first-reached thread. Not serializing two threads
>> allows these threads to return as quick as serializing these threads.
> 
> with the mutex protection removed, and relying on igrab()'s internal spinlock,
> the code logic is already correct for concurrency. 
> 
> there are two kinds of locks involved in this discussion: 
> - inode->i_lock: protects the inode's refcount (used by igrab())
> - osb->system_file_mutex: protects the array slot.

You are missing the point. The lock used inside igrab() is irrelevant.
The cmpxchg() is the lock that protects the array slot (in other words,
serializes two threads) without using the system_file_mutex lock.

