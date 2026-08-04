Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2C741A4EF
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Aug 2026 06:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785825995; cv=none; b=edA/yfUcRYFvn9vdPaQ7lwPa63poHgaZQ+h8JOgCc7RRR3c1E5fz3Mo63TavC4NeymZZMvk0iDteoSoAWaqM2IgTfX4L2HG7Q9fwwMfwVQNx8hDSxEk0/V2cv7XkZXs4GCJycgj+vedZLFKqpzWe0g6tKBeWXdW9Q0sBhnZDtqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785825995; c=relaxed/simple;
	bh=TdoDJBqAL49aGwWrIiKiXUHTMxuLFPTc0xgrYsF5KWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h4PnmdW3RNGQ5Xixfh5YJx/arBhp8+/pfgw0nWn/ADOVd3vtaxU0tYBf0xggWX5chZEkKpOE2fkZpB2yccwC7Jpp4GRS9hUN/x1HetiF6NsbEZxICcRHHn8G3M6m2W0TMjxMN3pz8U0qbJzpQdfHQn7VbV4ite4BZOXu219zfZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FaVD0NF7; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FaVD0NF7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785825989; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TxAZX5bOt9TC1wdkPL4Jn1gmKFsdKxOoJ2UkG1LRBsg=;
	b=FaVD0NF7h2hsp0UhNrZDPUw65ROXaSDuDOzm0Mvpt38u+baIuyfV9Mr0acUpnaafhXrdKbcfYVA+Y+l+eLDme/2/CWL0rvBqoPSl6/YBcpMYL75NPk9Ye2m+HTSRumHMuek9wxzsmuaKRk/9cLdbRcQmdoBpIQ7Cm5fde4TDe+8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X8N8A8G_1785825988;
Received: from 30.221.129.86(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8N8A8G_1785825988 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Aug 2026 14:46:28 +0800
Message-ID: <fda8c3c2-ed04-4f73-a320-32204b3bdf70@linux.alibaba.com>
Date: Tue, 4 Aug 2026 14:46:28 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in reflink
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260731113425.4130293-1-joseph.qi@linux.alibaba.com>
 <20260731112136.803da03ad3dd3ed119e88262@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260731112136.803da03ad3dd3ed119e88262@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/1/26 2:21 AM, Andrew Morton wrote:
> On Fri, 31 Jul 2026 19:34:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> Lockdep reports a possible deadlock involving ip_alloc_sem,
>> j_trans_barrier, and ip_xattr_sem:
>>
> 
> Cool.
> 
> Sashiko said a couple of things:
> 	https://sashiko.dev/#/patchset/20260731113425.4130293-1-joseph.qi@linux.alibaba.com
> 

The issue sashiko has found is real.

After a deep look, I think it can be fixed by breaking j_trans_barrier
-> ip_xattr_sem instread of ip_xattr_sem -> ip_alloc_sem, which is
actually posted by Krystian Kaniewski in thread (I've ACKed):
https://lore.kernel.org/ocfs2-devel/f98ff905-74bf-4017-a673-fd28f30f11d3@linux.alibaba.com/T/#t

So please drop this patch and let's keep the existing order for
ip_xattr_sem -> ip_alloc_sem.

Thanks,
Joseph


>> Fix by swapping the lock order in both functions to acquire
>> ip_alloc_sem before ip_xattr_sem, consistent with the rest of the
>> codebase.
>>
>> Fixes: 09bf27a00020 ("ocfs2: Implement ocfs2_reflink.")
>> Fixes: 8b2c0dba5159 ("ocfs2: Call refcount tree remove process properly.")
> 
> Should we backport this into -stable kernels?
> 

