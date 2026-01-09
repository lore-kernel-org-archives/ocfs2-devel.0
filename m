Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2014518CBE1
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Jan 2026 01:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767920879; cv=none; b=VoZTo/9aALqYivdMDCp12myCNd7iZMo7RH8ZkBovoF1O4HlLxJMJEA0tRTSFX7E6rDk2dJ7ejpy/ZEAuh2bA7wm6YWqg+v3WZNExlSHgDbZxu+IxyY/rimevrmOWO/ujX+J5Yk6fhl1OGzgITRvgimaFOLFHvS9IhmHTusjvXwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767920879; c=relaxed/simple;
	bh=jrX0wUOtVPgvJulNDfXROAaRkXAf4ppoWx91ARqRrtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rfP3OM0fDf5cK8UZJE+gSJnY5CGqBqziFzbyiEjGpV5ha/KAYSVOcE2/UBjPcDOMqJsDf187dYGZh9toA+K5QkDffQjbuEX/9MJt04pXh5atGpd9oMdNYf3hUgxRFepHk2OaztN+QVLpIDCV5sReDrZ88VIrXJ9wHDqcdE+XB0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=J7xyooDN; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="J7xyooDN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767920875; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=o6mNkYeazllRNdYx/4GO7Lsh2S1PuvJfBHGcK4tmImQ=;
	b=J7xyooDNTl1BehIkDQyvFjwnq/R5r2Vig5SLkAMZv60hnyG00v9R5DEq1tsq6GWJaXqlogV13Tu5WJkMEJQ6u+sl218Z+kp24XoF3NUwD4krYJrdoYqngrvqhaufDa1XmAxM6FqHrmldiC04LPyN6JfiMYUNpbAF1irD4VQjC04=
Received: from 30.221.145.51(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wwe9LD8_1767920873 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Jan 2026 09:07:54 +0800
Message-ID: <25d90176-743e-4638-9643-861bd5792eed@linux.alibaba.com>
Date: Fri, 9 Jan 2026 09:07:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in
 ocfs2_acquire_dquot
To: Szymon Wilczek <swilczek.lx@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 syzbot+51244a05705883616c95@syzkaller.appspotmail.com
References: <20251227174251.121668-1-swilczek.lx@gmail.com>
 <1e0dba77-e8a3-43e2-b20c-fbac6fdc928f@linux.alibaba.com>
 <CAJRoVwh8LUOaFb2OcNtE3Y=LU-tmSGrkOiN43C5SiEunr_coZQ@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAJRoVwh8LUOaFb2OcNtE3Y=LU-tmSGrkOiN43C5SiEunr_coZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2026/1/8 22:15, Szymon Wilczek wrote:
> (Resending to mailing lists - apologies for the private reply)
> 
> Hi Joseph,
> 
> Thank you for the review.
> 
> You are right - my v1 patch was incomplete. Looking at the lockdep
> trace again, the issue is that ocfs2_start_trans() acquires sb_internal
> while holding ip_alloc_sem (taken by ocfs2_lock_global_qf). This
> conflicts with freeze/dismount paths that acquire sb_internal first.
> 
> The chain reported by lockdep:
> sb_internal -> sysfile_lock_key -> ip_alloc_sem
> 
> Problematic sequence was:
> ip_alloc_sem (via lock_global_qf) -> sb_internal (via start_trans)
> 

According to description of locking dependencies in quota_global.c,
this is the designed order.

Thanks,
Joseph 

> This is a lock inversion.
> 
> You correctly identified that my v1 patch left the direct
> ocfs2_start_trans() call after ocfs2_lock_global_qf(), which doesn't
> fix the problem.
> 
> I'm preparing a v2 patch that also moves ocfs2_start_trans() before
> ocfs2_lock_global_qf() to properly fix the lock ordering.
> 
> Thanks,
> Szymon
> 
> On Thu, Jan 8, 2026 at 9:43 AM Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2025/12/28 01:42, Szymon Wilczek wrote:
>>> Move ocfs2_extend_no_holes() to execute before ocfs2_lock_global_qf() to
>>> fix a circular locking dependency reported by syzbot.
>>>
>>> The issue occurs because ocfs2_extend_no_holes() internally calls
>>> ocfs2_extend_allocation() which starts a transaction (acquiring
>>> sb_start_intwrite). When called while holding the global quota file
>>> lock, this conflicts with mount-time operations that acquire
>>
>> It seems the following locking sequence is fine:
>> ocfs2_lock_global_qf -> start_trans
>>
>> So could you please elaborate more?
>>
>>> sb_internal first, creating the following circular dependency:
>>>
>>>   sb_internal -> ocfs2_sysfile_lock_key -> ocfs2_quota_ip_alloc_sem_key
>>>
>>> By moving the quota file extension before acquiring the global quota
>>> file lock, we ensure that any internal transactions complete before
>>> quota locks are held, breaking the circular dependency.
>>>
>>> Reported-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
>>> Tested-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
>>> Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
>>> ---
>>>  fs/ocfs2/quota_global.c | 26 ++++++++++++++------------
>>>  1 file changed, 14 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
>>> index e85b1ccf81be..136aaaae27f3 100644
>>> --- a/fs/ocfs2/quota_global.c
>>> +++ b/fs/ocfs2/quota_global.c
>>> @@ -821,6 +821,19 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
>>>       trace_ocfs2_acquire_dquot(from_kqid(&init_user_ns, dquot->dq_id),
>>>                                 type);
>>>       mutex_lock(&dquot->dq_lock);
>>> +     /*
>>> +      * Extend global quota file before acquiring global qf lock to avoid
>>> +      * lock inversion with sb_internal (via ocfs2_start_trans).
>>> +      */
>>> +     if (need_alloc) {
>>> +             WARN_ON(journal_current_handle());
>>> +             status = ocfs2_extend_no_holes(gqinode, NULL,
>>> +                     i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
>>> +                     i_size_read(gqinode));
>>> +             if (status < 0)
>>> +                     goto out;
>>> +     }
>>> +
>>>       /*
>>>        * We need an exclusive lock, because we're going to update use count
>>>        * and instantiate possibly new dquot structure
>>> @@ -843,19 +856,8 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
>>>       OCFS2_DQUOT(dquot)->dq_use_count++;
>>>       OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
>>>       OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
>>> -     if (!dquot->dq_off) {   /* No real quota entry? */
>>> +     if (!dquot->dq_off)     /* No real quota entry? */
>>>               ex = 1;
>>> -             /*
>>> -              * Add blocks to quota file before we start a transaction since
>>> -              * locking allocators ranks above a transaction start
>>> -              */
>>> -             WARN_ON(journal_current_handle());
>>> -             status = ocfs2_extend_no_holes(gqinode, NULL,
>>> -                     i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
>>> -                     i_size_read(gqinode));
>>> -             if (status < 0)
>>> -                     goto out_dq;
>>> -     }
>>>
>>>       handle = ocfs2_start_trans(osb,
>>>                                  ocfs2_calc_global_qinit_credits(sb, type));
>>
>> BTW, even if your analysis is right, here also calls ocfs2_start_trans().
>>
>> Thanks,
>> Joseph
>>

