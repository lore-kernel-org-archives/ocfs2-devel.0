Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A82445026
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Sep 2024 03:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725420480; cv=none; b=i4EyfOfDo8wqDs5MHyiVd+fiBxmQsfOdeUuNlKCKBaMVMmD6ThyrZ//SbP556aMAPcE4jxrgBE2eg7Vhw97ot1NiFs0PYQzWVKtUM+AT0sWM89a1TNUgTjJBSR8BGaCkm43vweL040VW/Asre5kHWwaXmdtKmzb5gWsSMEvjZoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725420480; c=relaxed/simple;
	bh=iKimEOBU8JyGJrXOzv5YRa89jOelJhmGQlDkUASNshw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mp2yBJg/ogQyo4wL4YdyW7Dyf0jEZ3tEZ4fFCbTvOPsFRYDwhcmTOQ6uTewTkaZU81NAAPrWP4nfEyt6UkSTpuSBWBs7oh+V2+gJXr6JKVrZ5m+iOrRgngeYJ0+224JQ72LTWup2VeA1+keqsVxY4SHjcBcGjo+Sk0Nt5AdqHR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nRjk/57+; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nRjk/57+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725420470; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=y3R7YSD9XXAcdGXOjNphN9H4XVNhAwYmwiUf1Q5rd/c=;
	b=nRjk/57+LAVuv0U4vds2HTy6OShNMxqOHW0l3BY2F+6xTsfJKt9niEv1ec9rWs+ZKgf0tzLpxqFyaNB52GQN9LtSJwbHcAac1mV71A1ZWta2gykszCcbR1xXYm/Be8O3wTPW8PZboF/M8txFkeicdcz+kWFT34qSRkwHLVsyT9c=
Received: from 30.221.129.119(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WEFUYf2_1725420467)
          by smtp.aliyun-inc.com;
          Wed, 04 Sep 2024 11:27:48 +0800
Message-ID: <e1496ade-7505-47bb-ac96-4dd48e2e530f@linux.alibaba.com>
Date: Wed, 4 Sep 2024 11:27:47 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: cancel dqi_sync_work before freeing oinfo
To: Heming Zhao <heming.zhao@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
References: <20240904020949.1685198-1-joseph.qi@linux.alibaba.com>
 <0d6730e8-9a58-45ba-9e57-c22039f03253@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <0d6730e8-9a58-45ba-9e57-c22039f03253@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/4/24 10:56 AM, Heming Zhao wrote:
> On 9/4/24 10:09, Joseph Qi wrote:
>> ocfs2_global_read_info() will schedule dqi_sync_work. So any error
>> occurs after it, we have to cancel this delayed work first before
>> freeing oinfo, otherwise it will trigger the following warning with
>> CONFIG_DEBUG_OBJECTS_* enabled:
>>
>> ODEBUG: free active (active state 0) object: 00000000d8b0ce28 object type: timer_list hint: qsync_work_fn+0x0/0x16c
>>
>> Link: https://syzkaller.appspot.com/bug?extid=f7af59df5d6b25f0febd
>> Reported-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
>> Tested-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
>> Fixes: 171bf93ce11f ("ocfs2: Periodic quota syncing")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>>   fs/ocfs2/quota_local.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
>> index 8ce462c64c51..ebe0dbc8db4a 100644
>> --- a/fs/ocfs2/quota_local.c
>> +++ b/fs/ocfs2/quota_local.c
>> @@ -782,6 +782,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>>           if (locked)
>>               ocfs2_inode_unlock(lqinode, 1);
>>           ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
>> +        cancel_delayed_work_sync(&oinfo->dqi_sync_work);
>>           kfree(oinfo);
>>       }
>>       brelse(bh);
> 
> In my view, there is one problem:
> If ocfs2_global_read_info() returns error before ->dqi_sync_work is
> initialized, above code will trigger wild pointer error.
> 

You're right. Will update and send v2.

Thanks,
Joseph

