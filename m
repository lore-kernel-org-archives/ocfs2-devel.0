Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D2525761
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 01:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711591116; cv=none; b=PhwGde08+LqQe2U82f/XlJLgwgTuadeR746IAnN/8m/UfIDu5nTxsuH5tJmkxPgSa1N8ThnicUXQLG+dCcCR2Nd2WW1ZiiwOGObh+7Ft1ugGzhq6sUdZqVlsC7pyc+xtDfJJrqj04ukQHAGYfr4UmWCz90j+vzFq539QahTdITA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711591116; c=relaxed/simple;
	bh=AenMpykDUzU+UJS3dwOMMnYelLnZQaUfEASpzt085To=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mPgnQtfZl5OqMiCj9rFtJQX2gjs77UUFbacLl4XT+dV8qg6tTxN0Jrm49O71gpbyWnQM9JS4hcmOHtpfk2NPvViSUqP+9vnCPxzxOJUPUhtIr/6L8H9J8o+EbeCTL8B4/XzmOH76axU6ACQggK/QOtxvu9agN98UCidu9T4wyZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=w0BUQ76V; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="w0BUQ76V"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711591110; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MYywB8geEBnU0qJvrJVyA4vps0EFW91fNYA0hcis6zA=;
	b=w0BUQ76VPkMw/cDxvihW1M7tlCOwMPUb9GZkXX1Nc7t01e7ZUtNibiZ57og8q+VEGeJpSz8UwOwFUwAOe7ZlFFt234yJoqXwD/MwcNzgfKlmuYoRLXdoagYQ6PN1yZ6sVP81sREPUdVl3jrGSR8MqE/LB6RBbutBn1cQ0NA4ekM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W3QILI2_1711591108;
Received: from 30.221.129.70(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3QILI2_1711591108)
          by smtp.aliyun-inc.com;
          Thu, 28 Mar 2024 09:58:29 +0800
Message-ID: <b6038cf4-9966-47ad-b3e5-e0ad76270deb@linux.alibaba.com>
Date: Thu, 28 Mar 2024 09:58:28 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] ocfs2: adjust enabling place for la window
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240327082146.6258-1-heming.zhao@suse.com>
 <20240327082146.6258-3-heming.zhao@suse.com>
 <326496c2-ab47-462d-87ca-bb98aa796dfc@linux.alibaba.com>
 <b7879679-e0e9-43e6-8cc8-1fe3014363d5@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <b7879679-e0e9-43e6-8cc8-1fe3014363d5@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/27/24 8:59 PM, Heming Zhao wrote:
> On 3/27/24 19:05, Joseph Qi wrote:
>>
>>
>> On 3/27/24 4:21 PM, Heming Zhao wrote:
>>> After introducing gd->bg_contig_free_bits, the code path
>>> 'ocfs2_cluster_group_search() => ocfs2_local_alloc_seen_free_bits()'
>>> becomes death when all the gd->bg_contig_free_bits are set to the
>>> correct value. This patch relocates ocfs2_local_alloc_seen_free_bits()
>>> to a more appropriate location. (The new place being
>>> ocfs2_block_group_set_bits().)
>>>
>>> In ocfs2_local_alloc_seen_free_bits(), the scope of the spin-lock has
>>> been adjusted to reduce meaningless lock races. e.g: when userspace
>>> creates & deletes 1 cluster_size files in parallel, acquiring the
>>> spin-lock in ocfs2_local_alloc_seen_free_bits() is totally pointless and
>>> impedes IO performance.
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>>   fs/ocfs2/localalloc.c | 15 ++++++++-------
>>>   fs/ocfs2/suballoc.c   |  9 ++-------
>>>   2 files changed, 10 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>>> index c803c10dd97e..2391b96b8a3b 100644
>>> --- a/fs/ocfs2/localalloc.c
>>> +++ b/fs/ocfs2/localalloc.c
>>> @@ -212,14 +212,15 @@ static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
>>>   void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
>>>                         unsigned int num_clusters)
>>>   {
>>> -    spin_lock(&osb->osb_lock);
>>> -    if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
>>> -        osb->local_alloc_state == OCFS2_LA_THROTTLED)
>>> -        if (num_clusters >= osb->local_alloc_default_bits) {
>>> +    if (num_clusters >= osb->local_alloc_default_bits) {
>>> +        spin_lock(&osb->osb_lock);
>>> +        if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
>>> +            osb->local_alloc_state == OCFS2_LA_THROTTLED)
>>>               cancel_delayed_work(&osb->la_enable_wq);
>>> -            osb->local_alloc_state = OCFS2_LA_ENABLED;
>>> -        }
>>> -    spin_unlock(&osb->osb_lock);
>>> +
>>> +        osb->local_alloc_state = OCFS2_LA_ENABLED;

Seems the above should be along with cancel_delayed_work()?

>>> +        spin_unlock(&osb->osb_lock);
>>> +    }
>>
>> This makes checking osb->local_alloc_default_bits outside osb_lock.
>>
>> Joseph
> 
> I known, in my view, osb->local_alloc_default_bits doesn't change
> after mounting the volume. So, using osb_lock to protect this
> variable is pointless.
> 

Okay, it will be only set during fill super, so I think it's fine.
