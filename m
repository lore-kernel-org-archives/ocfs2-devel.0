Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891E1313545
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 01:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788399761; cv=none; b=sbCyl/s5XA8CNkQpzSC0Tz4m9nSHj8OwuYtEKte1VSSCK4NXFEPoL4aCoxXA3sCYRLdqgcYLvBl9qStfoQ9KZciN6uimCJQ2W2lJUMz1oqLcJtUS74H6FZiVseopK9vmYq7zSu2rGzbYW+vJNt4YcspDMSrkwYbD27AiB7DKHM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788399761; c=relaxed/simple;
	bh=FNcYYpqAx4t7Tg8NXDC/d1JYOUwY0k0Sk/UqtRlm+ss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TJzylrUKZ6WFTZ8S8ndjigXAwRASmIEKpqgtbXi/LIi7UvpLGWKO0EQqsOheaoqGutPrS2gbjVhQGHRoUB/CEIGWpSTVJ6sFMgjQgEXR5AF8VmE9hTNTgrINju9Ogh4Mos++hizuZe/7IrC/dtPoU8oYBtEoyAu88Y+uxtO1OVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tEYkhTR2; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tEYkhTR2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788399751; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pz0SH5Z8tWL0cZjtiUWm1pYvYPC5lNfbjWJ9jl9XU9M=;
	b=tEYkhTR2h2AWaEp+gZfRZk/fA30LK1UWaFia/DeTpOsZUEPDocw5smh34sHDMhKPyeFyr2v9TD4R72NtybgARnJVBgzTrIxpxhQ0yGfYuA5aCVPSr8gvOWBzPOeWwiMhbL9jJl2RpCdaC62CNEx2CDNQwF8EuTNkQz830iNxn7w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XAEOkYR_1788399747;
Received: from 30.221.131.71(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAEOkYR_1788399747 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 09:42:28 +0800
Message-ID: <c3be2678-72e6-4122-94de-ae95e980578b@linux.alibaba.com>
Date: Thu, 3 Sep 2026 09:42:27 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
To: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>,
 Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Srikanth Aithal <Srikanth.Aithal@amd.com>,
 Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
 <apiMiLlwujmqyYLP@user>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <apiMiLlwujmqyYLP@user>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/3/26 4:52 AM, Yalagada Pavan Kumar wrote:
> On Wed, Sep 02, 2026 at 09:33:57AM +0800, Joseph Qi wrote:
>> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
>> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
>> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
>> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
>> directly") made them point b_data at the kmalloced frozen data rather
>> than a folio.  Submitting such a buffer during journal commit oopses:
>>
>>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>>   Call Trace:
>>    jbd2_journal_commit_transaction+0x932/0x1b10
>>    kjournald2+0xb2/0x250
>>
>> Hit by the ocfs2-testsuite fill_verify_holes test running with
>> data=writeback.
>>
>> Dropbehind only applies to buffers backed by a folio, so skip the check
>> when b_folio is NULL.
>>
> Hi,
> 
> I was working on a fix for this syzbot report [1] and didn't realize that you were
> already working on it. I noticed your patch on the mailing list, so i won't
> send a duplicate patch.
>  
>> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
> 
> Could you please add the Reported-by: and Closes: tags from the syzbot report
> to your patch? This will help syzbot associate the patch with the reported
> issue and track the fix.
> 
> [1]: https://syzkaller.appspot.com/bug?extid=41453ea05ab61c075f1f
> 
Hi Christian,
Could you please address the above when apply the patch? Or should I
resend the patch with them?

Thanks,
Joseph 
