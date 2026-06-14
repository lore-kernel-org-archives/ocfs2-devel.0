Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556D03A782D
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Jun 2026 13:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781445443; cv=none; b=FCRq6o+igxN56mnCsdqe9KbvtuU+lzSaWBezyKUMycrZwymYl9T+0N9ohyfFCLzFUC+KdN2G/H+9Cp9WxMfnrAD6SIfPQqTXOaTiD01PGpkcl9Rmg4m8wCDgRJWS/2j349N+iWCaC+1aqE0mzW2jkQpBQ+cD7/ujGmORV8FQArI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781445443; c=relaxed/simple;
	bh=ZkvV6xqUEQN6s4L/lCJZM42GwQEMpl5nKu703E+7HAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rze/Vk7TNQvPS6/0jcBWjnHi59tz87ZRN9pTgsSm+E3oyAoOnsHGOEpMcYJIWilKuTEPr4nGsA7G0vR38ol4PtGVKevBEX9iPaiE2+DWOesqVV0Zn0/g72fjXJbMgtAWR4pj4OurZ0pFDxW4EjDIYh1/20Y+jjpNyUV0Vqgiq2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FNAmm11p; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FNAmm11p"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781445431; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pCRKJSt+wQ6EGRf9+Fwh8PwgeF50xpsk7ecKdRoO1w8=;
	b=FNAmm11pkPgEct881V0Hz7H4pHkCZKDSBSw5U3RHgqBhg9tb5mQ5XYBtdKsk6FPzuB3AXr3VfdilmZ3BbI7R63KkTw3fSOtZ1a4NHp0ZjAwq53DlZa7+cZmrPyl0tlByPYy4V56yoOjzK2rEbqKgDn5j/uTSWtkCgSGd69pxSDQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X4nelba_1781445430;
Received: from 30.134.110.188(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X4nelba_1781445430 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 14 Jun 2026 21:57:10 +0800
Message-ID: <00059109-c58b-4a91-9779-c4d1e0cf856f@linux.alibaba.com>
Date: Sun, 14 Jun 2026 21:57:09 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix NULL h_transaction deref in
 ocfs2_assure_trans_credits
To: Ian Bridges <icb@fastmail.org>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <airKTsM1fRVN-Wj7@dev>
 <dd6f703a-9877-468f-9a02-886e59770e25@linux.alibaba.com>
 <ai1KGobnHDtU2x_4@dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ai1KGobnHDtU2x_4@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/13/26 8:16 PM, Ian Bridges wrote:
> On Fri, Jun 12, 2026 at 09:19:31AM +0800, Joseph Qi wrote:
>>
>> On 6/11/26 10:46 PM, Ian Bridges wrote:
>>> [BUG]
>>> A direct write over unwritten extents can panic the kernel in
>>> ocfs2_assure_trans_credits() when the journal aborts during DIO
>>> completion. The crash is a general protection fault from a NULL pointer
>>> dereference.
>>>
>>> [CAUSE]
>>> ocfs2_dio_end_io_write() loops over a direct write's unwritten extents,
>>> marking each written under a single journal handle. If the journal
>>> aborts (for example after an I/O error) while the extent tree is being
>>> updated, the handle is left aborted with its transaction pointer
>>> cleared. The extent merge treats that failure as not critical and
>>> reports success, so the loop keeps using the handle.
>>> ocfs2_assure_trans_credits() reads the handle's remaining credits
>>> without first checking whether the handle is aborted, and that read
>>> dereferences the cleared transaction pointer.
>>>
>>> [FIX]
>>> A journal abort is recorded in the handle itself, so callers are
>>> expected to test the handle rather than rely on a returned error.
>>> Make ocfs2_assure_trans_credits() do that, as the other ocfs2 journal
>>> helpers already do, and return -EROFS when the handle is aborted.
>>>
>>> Fixes: be346c1a6eeb ("ocfs2: fix DIO failure due to insufficient transaction credits")
>> It seems this is introduced by commit d647c5b2fbf8 ("ocfs2: split
>> transactions in dio completion to avoid credit exhaustion")?
>>
>> Thanks,
>> Joseph
> The pattern of the bug appears present in the commit before d647c5b2fbf8.
> (510a75028707).
> 
> The loop reuses one handle for every extent (fs/ocfs2/aops.c):
> 
>     handle = ocfs2_start_trans(osb, credits);
>     ...
>     list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
>         ret = ocfs2_assure_trans_credits(handle, credits);
>         ...
>         ret = ocfs2_mark_extent_written(inode, &et, handle, ...);
>         ...
>     }
> 
> ocfs2_mark_extent_written() reaches a restart that sets h_transaction
> to NULL. jbd2__journal_restart() (fs/jbd2/transaction.c) leaves it NULL
> when start_this_handle() fails on an aborted journal:
> 
>     stop_this_handle(handle);
>     handle->h_transaction = NULL;
>     ...
>     ret = start_this_handle(journal, handle, gfp_mask);
> 
> ocfs2_extend_trans() (fs/ocfs2/journal.c) is what reaches that restart:
> 
>     status = jbd2_journal_extend(handle, nblocks, 0);
>     ...
>     if (status > 0) {
>         ...
>         status = jbd2_journal_restart(handle, ...);
>         ...
>     }
> 
> ocfs2_try_to_merge_extent() (fs/ocfs2/alloc.c) calls ocfs2_extend_trans()
> through ocfs2_extend_rotate_transaction() and swallows its error, so
> ocfs2_mark_extent_written() returns success with h_transaction left NULL:
> 
>     if (ctxt->c_split_covers_rec) {
>         ret = ocfs2_extend_rotate_transaction(handle, 0,
>                 jbd2_handle_buffer_credits(handle), path);
>         if (ret) {
>             mlog_errno(ret);
>             ret = 0;
>             goto out;
>         }
>         ...
>     }
> 
> The next ocfs2_assure_trans_credits() call in the loop then reads that
> NULL h_transaction and faults.
> 

Yes, you are right.

Thanks,
Joseph

