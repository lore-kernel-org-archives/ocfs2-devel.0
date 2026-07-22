Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2504D38836C
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 02:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784687411; cv=none; b=PkL74up4l9do0hFP6OBmStITI9aDSjuXQG35hsdMJF09WH7V3auYwKZ0C/Rdfw+E1hCAubv2ifAFf7fDj3hvh0eV4OCp5gmf6N9ErkIhYI0Ai/6h39sbzuinAJEjEFNBMQ9uSQuF+Rplaq8vmZFYkHy6xce8yxs0UQhzDleXwNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784687411; c=relaxed/simple;
	bh=ozBo2e1GLpmILrJNcQixkd4hWotjeRHTvA6aUYP7CT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bDD+s9rCKo3x3EtQQiRfhd2cZYwMwFB1e+vJDPqaWoxd/PNOdaBQcgfUnjWPnl0psDYnIvcwBEzSU9yWQPDnY/+h8g6QB79rBV81to0659CCAgDpIoNTQIyw2IIv7lQA6NDInSXrJcmh1kbuobmy4EMwFr3cHAWg4pXtRBRYjLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=L5tEIc5L; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="L5tEIc5L"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784687397; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SNJAfhT4EWFs53djTUtMR6N3tuO0IoZPtaoNf8ohbjQ=;
	b=L5tEIc5LAw4mvSsMBbS1R1gmFfO2tZrgSKPWd0udz6PHIgVzT3YgtY3rKo8yUCLgpmJDpS/O23o9ZyyaLDKgrz3MQ+NuPa/wv6ZBZa05oVPCz8kv950p3JTsY+7F8SL6iTelmEZIACXNNxrFklgVA8PTY9aLjJppZ3osBL4QCcI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X7bpjUR_1784687393;
Received: from 30.221.129.75(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7bpjUR_1784687393 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jul 2026 10:29:54 +0800
Message-ID: <1f5f04e9-9284-4e22-9d27-276a524fc05f@linux.alibaba.com>
Date: Wed, 22 Jul 2026 10:29:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: cluster: don't sleep while holding o2hb_live_lock
 in o2hb_region_pin()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260721114916.2098617-1-joseph.qi@linux.alibaba.com>
 <20260721105600.4b9532cb049ea1add5e671f6@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260721105600.4b9532cb049ea1add5e671f6@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/22/26 1:56 AM, Andrew Morton wrote:
> On Tue, 21 Jul 2026 19:49:16 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> o2hb_region_pin() is always called with the o2hb_live_lock spinlock held
>> (from o2hb_region_inc_user() and o2hb_heartbeat_group_drop_item()), but it
>> calls o2nm_depend_item() -> configfs_depend_item(), which sleeps: it pins
>> the configfs filesystem and takes the configfs root inode rwsem. Under
>> CONFIG_DEBUG_ATOMIC_SLEEP this triggers:
>>
>>   BUG: sleeping function called from invalid context at kernel/locking/rwsem.c
>>   in_atomic(): 1, ... name: mount.ocfs2
>>     down_write
>>     configfs_depend_item
>>     o2hb_region_pin
>>     o2hb_region_inc_user
>>     o2hb_register_callback
>>     dlm_register_domain_handlers
>>     ...
>>     ocfs2_dlm_init
>>     ocfs2_mount_volume
>>     ocfs2_fill_super
>>
>> Rework o2hb_region_pin() to pin one region at a time with the lock
>> dropped across the sleeping call: under o2hb_live_lock find the next
>> eligible region and take a config_item reference to keep it alive, drop
>> the lock, call o2nm_depend_item(), then retake the lock and record the
>> pin. The config_item_put() is done with the lock released as well, since
>> o2hb_region_release() also acquires o2hb_live_lock and can sleep. The
>> region list may change while unlocked, so the scan restarts from the
>> top after each pin. Local heartbeat still pins only the matching region;
>> global heartbeat pins all eligible regions.
> 
> Thanks, I'll add cc:stable to this.
> 
> Sashiko might have a found a couple of pre-existing issues in there:
> 
> https://sashiko.dev/#/patchset/20260721114916.2098617-1-joseph.qi@linux.alibaba.com

Thanks, the two comments seems real pre-existing issues.
I'll look into them later.

Thanks,
Joseph

