Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFB13890E2
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 May 2026 06:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779085264; cv=none; b=FniGxbct2zBKoBuhDVzNi1vCJFCATYM0MEVxioXtjy5lRwZENCpyZIn25GBAZIkOMtcAMJjpYubR5FUBRom0WKTzFLKJbE4curaFpDhboPO6GVaz6zeH9Wmeqp76PwHwgV2OYCS2/rifgha2SrUKhUgWDv2R/KYT2GSccf9UeEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779085264; c=relaxed/simple;
	bh=WHXh80JFewQtPX0O+56ZqbuFZW0Tbg2oTfkXyZAWics=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FHCWJDnMpoWqXp4xKDizD+MtKgJLkaoJfiDuyzV5ddI83AKp0CrzyETa6/MrueT0siL92GHiQKSRqt7K1R4wip9hMvlH3zNcQErSR+dYhiwQyVP9Htv2jfOHzr/l8C20Miu3c3MMcXfYFhhnsyov0X8M8sMPby7XBRoZbvxOzHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=A2VhS0Sq; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="A2VhS0Sq"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779085252; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=w/jqDD6PVEb8s2kEIkigdLnGHyrfqWf1nzDogKWzCs4=;
	b=A2VhS0SqPpEUNlcRfhys8ZjTGWEv1GLPI1ct1F3Ea9T34Z1bn12kJrdDQaU1b2fBjDpKMwYzPKfmnbXskKl5kn0TqycK0L0fI5DE4T40Xrk+MEFMMDZpHivgU45YU5Bsb1q1jNMyABoQ0Dtskp/Fqf6oA+IrXww+i/O2avlYiHI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X34bGuh_1779085250;
Received: from 30.221.129.172(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X34bGuh_1779085250 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 14:20:51 +0800
Message-ID: <b2ba54ce-3fe0-4ba1-a047-57d724d85096@linux.alibaba.com>
Date: Mon, 18 May 2026 14:20:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: kill osb->system_file_mutex lock
To: Heming Zhao <heming.zhao@suse.com>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 jiangyiwen <jiangyiwen@huawei.com>, ocfs2-devel@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
 <agc8kA2wxC_7091p@c73> <ageuwl9o3nzktMrz@c73>
 <fb0685c4-bcee-4c7b-8ac4-a1af702b8600@I-love.SAKURA.ne.jp>
 <aghfx-XhwoE4fBYR@c73>
 <670882aa-b637-4565-adf0-ddcd9d7a588b@I-love.SAKURA.ne.jp>
 <agp0sACmJl3tePyr@c73>
 <fea8d1fd-afb0-4302-a560-c202e2ef7afd@I-love.SAKURA.ne.jp>
 <agqbeO8Ykf6ntxNX@c73>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <agqbeO8Ykf6ntxNX@c73>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/18/26 12:56 PM, Heming Zhao wrote:
> On Mon, May 18, 2026 at 01:23:40PM +0900, Tetsuo Handa wrote:
>> Commit 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding
>> mutex lock") tried to avoid a refcount leak caused by allowing multiple
>> threads to call igrab(inode). But addition of osb->system_file_mutex made
>> locking dependency complicated and is causing lockdep to warn about
>> possibility of AB-BA deadlock.
>>
>> Since _ocfs2_get_system_file_inode() returns the same inode for the same
>> input arguments, we don't need to serialize _ocfs2_get_system_file_inode().
>> What we need to make sure is that igrab(inode) is called for only once().
>> Therefore, replace osb->system_file_mutex with cmpxchg()-based locking.
>>
>> Fixes: 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding mutex lock")
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> LGTM. Thanks for the patch.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>> Changes in v2:
>>   Updated patch description.
>>
>>  fs/ocfs2/ocfs2.h   | 2 --
>>  fs/ocfs2/super.c   | 2 --
>>  fs/ocfs2/sysfile.c | 9 +++------
>>  3 files changed, 3 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index 7b50e03dfa66..62cad6522c7a 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -494,8 +494,6 @@ struct ocfs2_super
>>  	struct rb_root	osb_rf_lock_tree;
>>  	struct ocfs2_refcount_tree *osb_ref_tree_lru;
>>  
>> -	struct mutex system_file_mutex;
>> -
>>  	/*
>>  	 * OCFS2 needs to schedule several different types of work which
>>  	 * require cluster locking, disk I/O, recovery waits, etc. Since these
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index b875f01c9756..6dd45c2153f8 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -1997,8 +1997,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>  	spin_lock_init(&osb->osb_xattr_lock);
>>  	ocfs2_init_steal_slots(osb);
>>  
>> -	mutex_init(&osb->system_file_mutex);
>> -
>>  	atomic_set(&osb->alloc_stats.moves, 0);
>>  	atomic_set(&osb->alloc_stats.local_data, 0);
>>  	atomic_set(&osb->alloc_stats.bitmap_data, 0);
>> diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
>> index d53a6cc866be..67e492f4b828 100644
>> --- a/fs/ocfs2/sysfile.c
>> +++ b/fs/ocfs2/sysfile.c
>> @@ -98,11 +98,9 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>>  	} else
>>  		arr = get_local_system_inode(osb, type, slot);
>>  
>> -	mutex_lock(&osb->system_file_mutex);
>>  	if (arr && ((inode = *arr) != NULL)) {
>>  		/* get a ref in addition to the array ref */
>>  		inode = igrab(inode);
>> -		mutex_unlock(&osb->system_file_mutex);
>>  		BUG_ON(!inode);
>>  
>>  		return inode;
>> @@ -112,11 +110,10 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>>  	inode = _ocfs2_get_system_file_inode(osb, type, slot);
>>  
>>  	/* add one more if putting into array for first time */
>> -	if (arr && inode) {
>> -		*arr = igrab(inode);
>> -		BUG_ON(!*arr);
>> +	if (inode && arr && !*arr && !cmpxchg(&(*arr), NULL, inode)) {
>> +		inode = igrab(inode);
>> +		BUG_ON(!inode);
>>  	}
>> -	mutex_unlock(&osb->system_file_mutex);
>>  	return inode;
>>  }
>>  
>> -- 
>> 2.54.0
>>
>>

