Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F44C24729A
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Oct 2025 09:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761297044; cv=none; b=ndhie5Dh3gXzRzuf/1NOO5PQqFpmLMiLVoF+iNfbxHSKIypP5DAkruNbwFcV84CbMyr27vlcRejc+5enNoS3tg0vcUdmm3MsMIKZXttNNmmnhTJ08N8AwVqlInqRV0KswLvrBwCwMeTu3hM3vyHAbqL5da+UXRE2xsBK0r0ZM9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761297044; c=relaxed/simple;
	bh=/W+al37GzQQb5aZb69PYPWyr9S2HWZz7yvDLxVMdYog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IL5UiCl27nd0OHrSZsegXJtnTN3h0Isj42Iht9EHfOVnu0nlNS0fRS1PT5z4jWiqStMMtavktggjhSz2MRvsd/ahNRDrk6IC5YFe9qaqQUqld+VDtySA8C8O3jsPjThznrDeAZ7ogVwNn3jDRokZqdXEZ5qF93DPXgu7/iuoDJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wAUb0Jkj; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wAUb0Jkj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761297034; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6Xr0elksJrShotruf/xPwoAFrW0FD6czpnX1xkdjypY=;
	b=wAUb0Jkj6fev1jN6Nf0qV6bvml3PIOkymwHZJlnaRWCueGkRqbsMntW40U/lA1G7ed+XQ/p9w5oO4Z0TRdG6MkNl8H4YjMv/Bix10T4X/IYmM5GMEf8+TGqppjnBXW0pTuIhyWGP7p4XApTUUECyR/bfowDdMahnmOevnhzFuLs=
Received: from 30.221.128.124(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WqtmNpe_1761297033 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Oct 2025 17:10:33 +0800
Message-ID: <6c276c88-24ef-4854-8008-a468bd3cee7f@linux.alibaba.com>
Date: Fri, 24 Oct 2025 17:10:32 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add inline inode consistency check to
 ocfs2_validate_inode_block()
To: Dmitry Antipov <dmantipov@yandex.ru>, Heming Zhao <heming.zhao@suse.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
References: <20251023141650.417129-1-dmantipov@yandex.ru>
 <75608a44-e803-4265-9000-f93d048cc30e@linux.alibaba.com>
 <43f2a8e8-b7bf-450c-b00c-dafe31b538b1@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <43f2a8e8-b7bf-450c-b00c-dafe31b538b1@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/24 13:06, Dmitry Antipov wrote:
> On 10/24/25 4:09 AM, Joseph Qi wrote:
> 
>> s/has no clusters/has clusters?
> 
> Hm. Reading the comment at the beginning of ocfs2_truncate_for_delete(),
> I assume that a dinode with inline data should have i_clusters set to 0.
> 

Yes, if dinode with flag OCFS2_INLINE_DATA_FL set and also has clusters,
something goes wrong, right?

Thanks,
Joseph

> This crash was triggered by using crafted filesystem image containing
> dinode with inline data but non-zero number of clusters, see
> https://syzkaller.appspot.com/x/log.txt?x=11960258580000. In particular,
> dinode with inline data should never be passed to ocfs2_commit_truncate().
> 
> Dmitry

