Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76352AE68
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 00:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025775; cv=none; b=q5AQNvdzBdbW9U8PEYTtBVBQrzJzWIb8Z7G6he2EP4zN27R02FAgtKuhU1ESKGzWrV7SeEluuvRQz2FNOBniQxqfHOV9rZkIyuxYEXqwFu1x91Vhttb451DmMzmR6wqOOaPwJx6iihq46qccfcvnKBvaKRfPdKp6Seqgl/PRFrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025775; c=relaxed/simple;
	bh=q/5JUGSHxQEcGfb5zJ8nWWv2tTCa6ZzCCN+qIAsk18Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bHVVUBZOOZ6XwpaSJmo+IqsglxZXCcNS2W8QLiHm/n1ewcqv/q9iLUJYZaLNExsEP8aXkICspmvcn1bhtFmYjiZaCjWxeKgr9APL1DXV83Flufr74z4zBHyIergyCAwe8CcJ06EhCgH1ejrDtEBAI+9jN/53ax1pzfEoC+acPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=H7+atuVu; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="H7+atuVu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792025769; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Xc2/quJBTUOfJC1n3uvaie/5AYgyo8YZ90+dymiITHI=;
	b=H7+atuVulOXfMcVm3OE3aYrdI1d4/QpRNyOgyR3j5Amd1FuYImC0fsfnA+A/CtXJI4SbdzbshHnuBhcF6xZZ4O3n8qJjlxt9OIFVfNEbb/u565t805w4Lz/z/TjCu0z7rrYZtz+8Cz/YKtqQaq7OOxrPn4e4jdTT4iCHHoZBEXY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XCpy1O7_1792025768;
Received: from 30.221.144.234(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCpy1O7_1792025768 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 15 Oct 2026 08:56:08 +0800
Message-ID: <93e4c76b-a855-469e-a210-eccb9da855c2@linux.alibaba.com>
Date: Thu, 15 Oct 2026 08:56:07 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/dlm: hold the lookup reference across convert AST
 enqueue
To: Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20261014112321.2955584-1-joseph.qi@linux.alibaba.com>
 <as-cs6Pxot8LavVG@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <as-cs6Pxot8LavVG@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/14/26 11:18 PM, Heming Zhao wrote:
> On Wed, Oct 14, 2026 at 07:23:21PM +0800, Joseph Qi wrote:
>> dlm_convert_lock_handler() drops the reference it took when it found the
>> lock on res->granted at its leave label, one statement before it calls
>> dlm_queue_ast().  dlm_free_dead_locks() takes res->spinlock and drops the
>> list and base references, so a peer death landing in that gap leaves the
>> handler's own put as the one that frees the lock, and __dlm_queue_ast()
>> then reads lock->lockres from freed memory.
>>
>> The handler is registered next to dlm_create_lock_handler(), so a convert
>> message buffered on a dying peer's socket arrives on the same o2net
>> receive work that o2net_disconnect_node() does not wait for.  The two can
>> interleave as follows, with the reference counts as they are before this
>> fix:
>>
>>   Socket data-ready       Node-down thread      Receive worker
>>   -----------------       ----------------      --------------
>>   o2net_data_ready()
>>     select sc under
>>     callback read lock
>>                           o2net_disconnect_node()
>>                             queue shutdown
>>                             begin flush; new color
>>     queue sc_rx_work
>>     in the new color
>>     release callback lock
>>                             shutdown socket
>>                             flush returns
>>                                                 read buffered convert_lock
>>                                                 dlm_convert_lock_handler()
>>                                                   find lock on res->granted
>>                                                   dlm_lock_get()  refs = 3
>>                                                   lock res->spinlock
>>                                                   __dlmconvert_master()
>>                                                     call_ast = 1
>>                                                   unlock res->spinlock
>>                           DLM node-down cleanup
>>                             lock res->spinlock
>>                             dlm_free_dead_locks()
>>                               unlink lock
>>                               put list ref  refs = 2
>>                               put base ref  refs = 1
>>                             unlock res->spinlock
>>                                                 dlm_lock_put()  refs = 0
>>                                                   free lock
>>                                                 dlm_queue_ast()
>>                                                   __dlm_queue_ast()
>>                                                   read lock->lockres
>>                                                   (use-after-free)
>>
>> __dlmconvert_master() only moves the lock between lists, so the count
>> entering the gap is base, list and lookup.  Drop the lookup reference
>> after the AST is queued instead of before it and the race ends with the
>> one __dlm_queue_ast() took, which dlm_flush_asts() releases later with
>> ast_pending cleared and ast_list unlinked.  No extra get is needed, and
>> the normal case ends with the same count as before.
>>
>> dlmconvert_master() has the same shape but is only reached from dlmlock()
>> for a lock this node owns, which dlm_free_dead_locks() never matches.
>>
>> Fixes: 2c5c54aca9d0 ("ocfs2/dlm: Add missing dlm_lock_put()s")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> The code looks good to me.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> 
> btw, how do you find the issue?
> 

This is found when I review patch:
  ocfs2/dlm: hold a lock reference across grant AST enqueue

Since they address difference flow, so I send it as a separate patch.

Thanks,
Joseph

