Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039B3423A8C
	for <ocfs2-devel@lists.linux.dev>; Sat, 28 Feb 2026 10:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772275502; cv=none; b=ht9EeWH3SW1Gf6oZFp03RDTnuMRYAqjWBOdpgsEJYojXurKa1WFd9bMv1H8vunQwmpVUzfi4ooUi/X1CP/U0RH9T3abUvqD8G92PVCRV95irdoiDrbEC5rMgh0lbur+SvIGlMzB/XogfuCeU4CeFXWe9EM1KvkPszuD9aNvxjoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772275502; c=relaxed/simple;
	bh=zxbQUlEPnWlB+XePGxUJU8IwXFnzLXp7qql64TKjbog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uWUumSsm+ggZ6Bof7dVa5FJLsQw7JCW26SUBxqMJQdldnO/3I9flBCeLtFwGY5mgaQOtQ9uwBNQ5rwobBhqlJw1SC9bGaWWsQh0KeBWN1BwNlyzojWQjGiSfJSHfcD1k0NtKx0/I12HG9xqvnvJKQNbIosko5aZpRvYGuGMVYVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=IUP+wtXz; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="IUP+wtXz"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772275491; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PSaPm/GC7RXPnjAVj+9rbaZUdNTYpfNUbSS+LJJxycE=;
	b=IUP+wtXzIdxNrzuGWBy8ynL+PMvVyufMJzYZ2eGb3ZFdJNqfq+5hwXIU2alhy5Og/y5Vy+lAR6azGqbX7lPeYKS9/Iw9khPcUgwAo2sHREkW7f8g97Rpk8gRakcTXf4m4WZm6mftA9EQOQKP+llw8p1/HhBhzHO/die1jaZPyKo=
Received: from 30.221.129.112(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WzxIyUS_1772275489 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 28 Feb 2026 18:44:50 +0800
Message-ID: <d03aaf18-529a-43f0-90f2-d58322f461be@linux.alibaba.com>
Date: Sat, 28 Feb 2026 18:44:49 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix deadlock when creating quota file
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 activprithvi@gmail.com,
 syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com,
 akpm <akpm@linux-foundation.org>
References: <20260224084909.28361-1-heming.zhao@suse.com>
 <bd3926d7-3069-48cb-a04c-b8ab285d47e1@linux.alibaba.com>
 <2dbj3rn4xks774qkgfp6ecmjperq5xtkkayyn4vuo4i4c5of62@7pjybhlobopb>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <2dbj3rn4xks774qkgfp6ecmjperq5xtkkayyn4vuo4i4c5of62@7pjybhlobopb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/28/26 3:06 PM, Heming Zhao wrote:
> On Sat, Feb 28, 2026 at 02:01:55PM +0800, Joseph Qi wrote:
>> Hi Heming,
>>
>> On 2/24/26 4:48 PM, Heming Zhao wrote:
>>> syzbot detected a circular locking dependency. the scenarios:
>>>
>>>         CPU0                    CPU1
>>>         ----                    ----
>>>    lock(&ocfs2_quota_ip_alloc_sem_key);
>>>                                 lock(&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
>>>                                 lock(&ocfs2_quota_ip_alloc_sem_key);
>>>    lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
>>>
>>> or:
>>>        CPU0                    CPU1
>>>        ----                    ----
>>>   lock(&ocfs2_quota_ip_alloc_sem_key);
>>>                                lock(&dquot->dq_lock);
>>>                                lock(&ocfs2_quota_ip_alloc_sem_key);
>>>   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
>>>
>>> Following are the code paths for above scenarios:
>>>
>>> path_openat
>>>  ocfs2_create
>>>   ocfs2_mknod
>>>   + ocfs2_reserve_new_inode
>>>   |  ocfs2_reserve_suballoc_bits
>>>   |   inode_lock(alloc_inode) //C0: hold INODE_ALLOC_SYSTEM_INODE
>>>   |    //at end of this func, ocfs2_free_alloc_context(inode_ac) calls inode_unlock
>>>   |
>>>   + ocfs2_get_init_inode
>>>      __dquot_initialize
>>>       dqget
>>>        ocfs2_acquire_dquot
>>>        + ocfs2_lock_global_qf
>>>        |  down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)//A2:grabbing
>>>        + ocfs2_create_local_dquot
>>>           down_write(&OCFS2_I(lqinode)->ip_alloc_sem)//A3:grabbing
>>>
>>> evict
>>>  ocfs2_evict_inode
>>>   ocfs2_delete_inode
>>>    ocfs2_wipe_inode
>>>     + inode_lock(orphan_dir_inode) //B0:hold
>>>     + ...
>>>     + ocfs2_remove_inode
>>>        inode_lock(inode_alloc_inode) //INODE_ALLOC_SYSTEM_INODE
>>>         down_write(&inode->i_rwsem) //C1:grabbing
>>>
>>> generic_file_direct_write
>>>  ocfs2_direct_IO
>>>   __blockdev_direct_IO
>>>    dio_complete
>>>     ocfs2_dio_end_io
>>>      ocfs2_dio_end_io_write
>>>      + down_write(&oi->ip_alloc_sem) //A0:hold
>>>      + ocfs2_del_inode_from_orphan
>>>         inode_lock(orphan_dir_inode) //B1:grabbing
>>>
>>> Root cause for the circular locking:
>>>
>>> DIO completion path:
>>>  holds oi->ip_alloc_sem and is trying to acquire the orphan_dir_inode lock.
>>>
>>> evict path:
>>>  holds the orphan_dir_inode lock and is trying to acquire the
>>>  inode_alloc_inode lock.
>>>
>>> ocfs2_mknod path:
>>>  Holds the inode_alloc_inode lock (to allocate a new quota file) and is
>>>  blocked waiting for oi->ip_alloc_sem in ocfs2_acquire_dquot().
>>>
>>
>> When running into ocfs2_mknod->ocfs2_get_init_inode,
>> ocfs2_reserve_new_inode is finished and INODE_ALLOC_SYSTEM_INODE gets
>> unlocked in ocfs2_free_ac_resource at the end.
>> So I get confused about the above deadlock sequence.
>> Am I missing something?
>>
>> Joseph
> 
> ocfs2_reserve_new_inode only releases 'ac' when an error occurs (note the if
> condition: 'status< 0'). The normal path for releasing 'ac' is at the end of
> the caller ocfs2_mknod.
> 

I'm saying the calling ocfs2_free_ac_resource() at line 1170.
But take a look at it more, this will only be called in case ENOSPC
(the case of inode steal).
So I'm fine now.

Joseph
