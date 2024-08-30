Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD908190074
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Aug 2024 10:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015541; cv=none; b=GGF4RlImLdB+kgjbluV5vysWBKof+WdlnxPf6GdRFAp7YNe9kqfNwIt02568Rr1mdJTenQFNc6rE/Qc8UJWDJoCXdEUmOE7Zi3d8C/+kaohaT9AeOZX7l5wt8Lfqc3ge6sHWNpbgObD6SUuwOw9/LN1IUg8ETxTq/HxI5O6CHeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015541; c=relaxed/simple;
	bh=5wGzTJdJfv8dBhAaqFbYvpN+InUE2G/fBJTEI+iNjKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jNn4mb3G5bu6sazDFIRChSM7Bl/MGk3pzDUrHoUkMRjO1uHX1leh0hyBE+RDimZps7/b2oqdxiptyKu5A61evLJw+9fJUBF9s8BfbPSNfr78abWivNI6xo3G23UmWptmUhvcsnnDfee1lym/jL8B9YTtZ8WmC2uCqArQnd0lLyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lykyplu7; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lykyplu7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725015530; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gtQmzgGA2xvT9jwr1kq7vXgk3iSxb0pN4tF7PSYwGQ4=;
	b=lykyplu796vcAJ3yjBpf7jD5FRIXkR8jLGSUXnJcuwbK0Tgxe9SWPYBiruMdHtExEfp0CeZUvjkxF1TDSWJVCEKy/Yz9DoDY2feIamrJRE7FV0UXIQuUwwFgBlQo7Bfx/6Ew/DnAEVRkqrk2g9vzQptVKiWxL35a5YUEi2YF5Zk=
Received: from 30.221.128.136(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WDwiUGI_1725015528)
          by smtp.aliyun-inc.com;
          Fri, 30 Aug 2024 18:58:49 +0800
Message-ID: <fe86da76-555d-424a-828f-ea99b05b363f@linux.alibaba.com>
Date: Fri, 30 Aug 2024 18:58:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix null-ptr-deref when journal load failed.
To: Julian Sun <sunjunchao2870@gmail.com>, ocfs2-devel@lists.linux.dev
Cc: lbec@evilplan.org, mark@fasheh.com,
 syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20240823083150.17590-1-sunjunchao2870@gmail.com>
 <07dea72e-8b93-4095-9347-4ff765a2539d@linux.alibaba.com>
 <cf4174af158587cabd525ae23d35c0b399eade47.camel@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <cf4174af158587cabd525ae23d35c0b399eade47.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/30/24 6:11 PM, Julian Sun wrote:
> On Fri, 2024-08-30 at 17:40 +0800, Joseph Qi wrote:
>>
>>
>> On 8/23/24 4:31 PM, Julian Sun wrote:
>>> During the mounting process, if journal_reset() fails
>>> because of too short journal, then lead to
>>> jbd2_journal_load() fails with NULL j_sb_buffer.
>>> Subsequently, ocfs2_journal_shutdown() calls
>>> jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
>>> __jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
>>> ->lock_buffer(journal->j_sb_buffer), resulting in a
>>> null-pointer dereference error.
>>>
>>> To resolve this issue, a new state OCFS2_JOURNAL_INITED
>>> has been introduced to replace the previous functionality
>>> of OCFS2_JOURNAL_LOADED, the original OCFS2_JOURNAL_LOADED
>>> is only set when ocfs2_journal_load() is successful.
>>> The jbd2_journal_flush() function is allowed to be called
>>> only when this flag is set. The logic here is that if the
>>> journal has even not been successfully loaded, there is
>>> no need to flush the journal.
>>>
>>> Link: https://syzkaller.appspot.com/bug?extid=05b9b39d8bdfe1a0861f
>>> Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
>>> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
>>> ---
>>>  fs/ocfs2/journal.c | 9 ++++++---
>>>  fs/ocfs2/journal.h | 1 +
>>>  2 files changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>>> index 530fba34f6d3..da0ffcc5de0a 100644
>>> --- a/fs/ocfs2/journal.c
>>> +++ b/fs/ocfs2/journal.c
>>> @@ -968,7 +968,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb,
>>> int *dirty)
>>>  
>>>         ocfs2_set_journal_params(osb);
>>>  
>>> -       journal->j_state = OCFS2_JOURNAL_LOADED;
>>> +       journal->j_state = OCFS2_JOURNAL_INITED;
>>>  
>>>         status = 0;
>>>  done:
>>> @@ -1039,6 +1039,7 @@ void ocfs2_journal_shutdown(struct
>>> ocfs2_super *osb)
>>>         int status = 0;
>>>         struct inode *inode = NULL;
>>>         int num_running_trans = 0;
>>> +       enum ocfs2_journal_state state;
>>>  
>>>         BUG_ON(!osb);
>>>  
>>> @@ -1047,8 +1048,9 @@ void ocfs2_journal_shutdown(struct
>>> ocfs2_super *osb)
>>>                 goto done;
>>>  
>>>         inode = journal->j_inode;
>>> +       state = journal->j_state;
>>>  
>>> -       if (journal->j_state != OCFS2_JOURNAL_LOADED)
>>> +       if (state != OCFS2_JOURNAL_INITED && state !=
>>> OCFS2_JOURNAL_LOADED)
>>>                 goto done;
>>>  
>>>         /* need to inc inode use count - jbd2_journal_destroy will
>>> iput. */
>>> @@ -1076,7 +1078,7 @@ void ocfs2_journal_shutdown(struct
>>> ocfs2_super *osb)
>>>  
>>>         BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
>>>  
>>> -       if (ocfs2_mount_local(osb)) {
>>> +       if (ocfs2_mount_local(osb) && state ==
>>> OCFS2_JOURNAL_LOADED) {
>>
>> The only intent of the new introduced state is to identify if journal
>> is
>> truly loaded or not.
>> So it seems that the simplest way to fix this is just check
>> JBD2_LOADED
>> here.
>>
>> if (ocfs2_mount_local(osb) &&
>>     (journal->j_journal->j_flags & JBD2_LOADED)) {
>>         ...
>> }
> Hi, Joseph, thanks for your review and comments. 
> 
> Yeah! It's absolutely the simplest and cleanest way to fix this issue.
> Thanks for your suggestion.
>>
>> BTW, could you please also replace 'osb->journal->j_num_trans' to
>> 'journal->j_num_trans'?
> Sure.
>>
>>>                 jbd2_journal_lock_updates(journal->j_journal);
>>>                 status = jbd2_journal_flush(journal->j_journal, 0);
>>>                 jbd2_journal_unlock_updates(journal->j_journal);
>>> @@ -1174,6 +1176,7 @@ int ocfs2_journal_load(struct ocfs2_journal
>>> *journal, int local, int replayed)
>>>                 }
>>>         } else
>>>                 osb->commit_task = NULL;
>>> +       journal->j_state = OCFS2_JOURNAL_LOADED;
>>
>> It seems that this has to be moved just after jbd2_journal_load().
>> Anyway, I don't think we have to introduce a new state. See above.
>>
> Agreed. And now OCFS2_JOURNAL_LOADED is set when ocfs2_journal_init()
> succeed, it may led to some misunderstanding: the journal was not
> really loaded when OCFS2_JOURNAL_LOADED was set. I would like to rename
> it to OCFS2_JOURNAL_INITED in another patch to make it clearer.

Umm... You can treat it as ocfs2 journal state only, not jbd2.
Also jbd2 doesn't have 'initialized' state either.
So I don't think we have to do this change in the fix.

Joseph  
