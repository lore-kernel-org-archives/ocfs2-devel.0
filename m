Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B0434CDD
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Sep 2025 01:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756689056; cv=none; b=f6xneFu4+c4GSr05Uq4+vApCuf9XZr5otWGh7bSn0HNpRZqcxcPfanCh32gh5VwbuxP7x+IGlrXlUOOLtF5EExsPRDBM96IsSt/mxfPhXMbEIEonM4GKg8hsokcPsmFQW+DB8zddUrG8WMzp5Y+s5MZzn/g5JFHML6sjJgRU2dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756689056; c=relaxed/simple;
	bh=l3YyNWRRnpk1oA9/LL9b/Tic8CSRVO/+aK7pCI3K0Go=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XQqvZ2lQPt8X3tiFOxY15tpXcsEJmrapY4KNxqbpkbsOIRPKGKMB846T0SQommWWq+ye7ktYcCLZPID6Q3XSWQJ4NP5BK8kbu7tefaJ8ABUV7nuE9KhLjKSstzNQe+7DWt6aBFSEcu+tsiVFHeVzfw0Cgsie68Y2KWisUTRxLus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Cf5/WVNB; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Cf5/WVNB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756689044; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IzB3YMdOmSN+riQBvKjNBQTpWgw6tYtR9O0JAPpcWJA=;
	b=Cf5/WVNB0gJRO9jZNebNuRQ5blYqMYhRM276bcLFxKXvWbOPfCPDF1/22vJ695e4T6X64nLEFwHYS7h1CcYSsLGRfGRzbQyO6eibbAerRZ3cdw8K9y16jahJ5Nf2RY81neRIBFno4aPK6r1NeZIhP03X8syuaB2cAw7RpUYYL3o=
Received: from 30.221.144.175(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WmxejsH_1756689043 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Sep 2025 09:10:44 +0800
Message-ID: <f5aa2c37-fe66-4f79-8277-c6ee7346a8f6@linux.alibaba.com>
Date: Mon, 1 Sep 2025 09:10:43 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v4 PATCH] ocfs2: fix recursive semaphore deadlock in fiemap call
To: Andrew Morton <akpm@linux-foundation.org>,
 Mark Tinguely <mark.tinguely@oracle.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Heming Zhao <heming.zhao@suse.com>,
 syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
References: <20250829150620.22710-1-mark.tinguely@oracle.com>
 <61d1a62b-2631-4f12-81e2-cd689914360b@oracle.com>
 <20250831121458.6f195657f94c35005b5bc38d@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250831121458.6f195657f94c35005b5bc38d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/9/1 03:14, Andrew Morton wrote:
> On Fri, 29 Aug 2025 10:18:15 -0500 Mark Tinguely <mark.tinguely@oracle.com> wrote:
> 
>> syzbot detected a OCFS2 hang due to a recursive semaphore on a
>> FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.
>>
>> context_switch kernel/sched/core.c:5357 [inline]
>>
>> ...
>>
>> ocfs2_fiemap() takes a read lock of the ip_alloc_sem semaphore (since
>> v2.6.22-527-g7307de80510a) and calls fiemap_fill_next_extent()
>> to read the extent list of this running mmap executable.
>> The user supplied buffer to hold the fiemap information page faults
>> calling ocfs2_page_mkwrite() which will take a write lock (since
>> v2.6.27-38-g00dc417fa3e7) of the same semaphore. This recursive
>> semaphore will hold filesystem locks and causes a hang of the
>> fileystem.
>>
>> The ip_alloc_sem protects the inode extent list and size.
>> Release the read semphore before calling fiemap_fill_next_extent()
>> in ocfs2_fiemap() and ocfs2_fiemap_inline(). This does an
>> unnecessary semaphore lock/unlock on the last extent but simplifies
>> the error path.
>>
>> Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=541dcc6ee768f77103e7
> 
> So I'm thinking
> 
> Fixes: 00dc417fa3e7 ("ocfs2: fiemap support")
> cc:stable
> 
> yes?

Yes, thanks for the improvement.

Joseph

