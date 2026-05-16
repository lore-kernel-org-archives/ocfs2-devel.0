Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B53175A7B
	for <ocfs2-devel@lists.linux.dev>; Sat, 16 May 2026 05:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778911025; cv=none; b=HFuFGTkVUs34IYWtLlow7FcomSJOYb4g2nw9jsJ+6Ez4GK7UEQzktyMzs2k/je9MWZl57PNc9hbi5ObQFBwcKoqO+vjBUGBU9XiX0Qn2Nw/seOSM8WhwNTHD+PWi2UN3BHPP2M/R16CFLA70MOG2678J93J3CdN23bzY/1+1I/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778911025; c=relaxed/simple;
	bh=yMavxEftnOH9N7SYKmzSUfXk60OgFraE6MElsbKX7J4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sfyP//vkc0sLkG51EImfjtAwNJYEjImm9Y9vWa+8/byMoSmUZtYyW07VqYVGfpz5GobZuo0csiMT6hqn6CFIVjd6GOY/fv00QLo5+FhquPXIqVz2fHACjFHmJnx4Mcy7p0nenf9yV0rpFSIJGLvJQQuT+ymesEtS62psOMOBFzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 64G5qTRc073514;
	Sat, 16 May 2026 14:52:29 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 64G5qTO2073511
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 16 May 2026 14:52:29 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <fb0685c4-bcee-4c7b-8ac4-a1af702b8600@I-love.SAKURA.ne.jp>
Date: Sat, 16 May 2026 14:52:29 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
To: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        jiangyiwen <jiangyiwen@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
 <agc8kA2wxC_7091p@c73> <ageuwl9o3nzktMrz@c73>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <ageuwl9o3nzktMrz@c73>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav402.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/05/16 8:53, Heming Zhao wrote:
> On Fri, May 15, 2026 at 11:35:13PM +0800, Heming Zhao wrote:
>> On Thu, May 14, 2026 at 04:09:25PM +0900, Tetsuo Handa wrote:
>>> Hi Heming,
>>>
>>> I would like to clarify why the expectation of "being called only once" is logically
>>> incorrect, reply to your concern regarding the reference count leak and explain why
>>> this patch is completely safe and sufficient.
>>>
>>> 1. get_local_system_inode() can fail under memory pressure:
>>>    get_local_system_inode() allocates memory internally. Under heavy memory pressure,
>>>    this allocation can fail and return NULL. When this happens, the caller
>>>    ocfs2_get_system_file_inode() must fall back to calling _ocfs2_get_system_file_inode()
>>>    again to read the inode from disk. Therefore, the filesystem design must inherently
>>>    support multiple calls to _ocfs2_get_system_file_inode().
>>>
>>> 2. Why cmpxchg() is sufficient and safe without the mutex:
>>>    The only thing the system_file_mutex is needed was to prevent a race where two
>>>    threads concurrently execute _ocfs2_get_system_file_inode(), obtain the SAME inode
>>>    pointer (since the underlying VFS iget_locked() returns the identical address for
>>>    the same slot), and both mistakenly invoke igrab() on it, leading to a reference
>>>    count leak.
>>>
>>>    This patch perfectly solves that race condition by using cmpxchg() on the target
>>>    pointer array slot:
>>>
>>>      * The thread that wins the cmpxchg() successfully initializes the slot with the
>>>        fetched inode and get the extra refcount because it is the first time to store
>>>        into the slot.
>>>
>>>      * The thread that loses the cmpxchg() detects that another thread has already
>>>        initialized the slot with the exact same inode. The loser thread returns
>>>        without getting the extra refcount because it is not the first time to store
>>>        into the slot.
>>>
>>>    Therefore, the reference counting contract is strictly and atomically maintained.
>>>    No references are leaked, and the array slot is never corrupted.
>>
>> Hi,
>>
>> The logic here is incorrect. The purpose of the refcount is to track how many
>> consumers are using the inode.
>>
>> In the original code, if two threads concurrently access ocfs2_get_system_file_inode()
>> while the inode is uninitialized, inode->i_count would ultimately be incremented
>> by 3. However, with your patch, i_count will only be incremented by 2.
>>
>> To be more specific:
>> Your patch explicitly triggers a race condition: when the target local_system
>> inode is uninitialized and two threads enter simultaneously, Thread 1 wins the
>> cmpxchg() and increments the refcount before exiting. Thread 2, however, loses
>> the refcount increment simply because the atomic operation failed.
>>
>> btw, The issue addressed in commit 43b10a20372d was that after two concurrent
>> threads returned, inode->i_count ended up being 4 when the correct value should
>> have been 3. With your patch, the value will end up being 2, which is insufficient.
> 
> My above analysis contains a mistake.
> With the patch, the refcount is also 3. However, I don't think the code logic is
> correct.
> 
> Before commit 43b10a20372d, the refcount was 4:
> Thread 1: _ocfs2_get_system_file_inode (refcount +1), "*arr = igrab(inode)" (refcount +1)
> Thread 2: does the same job as Thread 1.
> 
> Current code logic, the refcount is 3:
> Thread 1: _ocfs2_get_system_file_inode (refcount +1), "*arr = igrab(inode)" (refcount +1)
> Thread 2: "inode = igrab(inode)" (gets inode from array, refcount +1)

Yes, commit 43b10a20372d ("ocfs2: avoid system inode ref confusion
by adding mutex lock") was to prevent

 struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
                                          int type,
                                          u32 slot)
 {
        struct inode *inode = NULL;
        struct inode **arr = NULL;

        /* avoid the lookup if cached in local system file array */
        if (is_global_system_inode(type)) {
                arr = &(osb->global_system_inodes[type]);
        } else
                arr = get_local_system_inode(osb, type, slot);

+       mutex_lock(&osb->system_file_mutex);
        if (arr && ((inode = *arr) != NULL)) {
                /* get a ref in addition to the array ref */
                inode = igrab(inode);
+               mutex_unlock(&osb->system_file_mutex);
                BUG_ON(!inode);

                return inode;
        }

        /* this gets one ref thru iget */
        inode = _ocfs2_get_system_file_inode(osb, type, slot);

        /* add one more if putting into array for first time */
        if (arr && inode) {

two threads concurrently reaching here.

                *arr = igrab(inode);
                BUG_ON(!*arr);
        }
+       mutex_unlock(&osb->system_file_mutex);
        return inode;
 }

> 
> With the patch, the refcount is also 3:
> Thread 1: _ocfs2_get_system_file_inode (refcount +1), "*arr = igrab(inode)" (sets array, refcount +1)
> Thread 2: _ocfs2_get_system_file_inode (refcount +1)

Yes, and what prevents you from accepting my patch?

> 
> In theory, _ocfs2_get_system_file_inode() should only be called once after mount.
> The performance penalty in the current ocfs2_get_system_file_inode() comes from
> doing "inode = igrab(inode)" while holding the mutex lock.

My patch is required for simplifying locking dependency chain, for serializing
call to _ocfs2_get_system_file_inode() using mutex is causing lockdep warning.

Eliminating possibility of deadlock is far more important than worrying about
performance penalty for rare race condition. We don't need to serialize because
_ocfs2_get_system_file_inode() can return the same pointer for the same input.

> 
> - Heming
>>
>> In my opinion, the problem with the current code is that the scope of
>> mutex_lock(&osb->system_file_mutex) is too broad. This mutex only needs to be
>> held prior to calling _ocfs2_get_system_file_inode(). I previously highlighted
>> this point in my initial review comment on the patch.

If you meant

 struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
                                          int type,
                                          u32 slot)
 {
        struct inode *inode = NULL;
        struct inode **arr = NULL;

        /* avoid the lookup if cached in local system file array */
        if (is_global_system_inode(type)) {
                arr = &(osb->global_system_inodes[type]);
        } else
                arr = get_local_system_inode(osb, type, slot);

-       mutex_lock(&osb->system_file_mutex);
        if (arr && ((inode = *arr) != NULL)) {
                /* get a ref in addition to the array ref */
                inode = igrab(inode);
                mutex_unlock(&osb->system_file_mutex);
                BUG_ON(!inode);

                return inode;
        }

+       mutex_lock(&osb->system_file_mutex);
+
        /* this gets one ref thru iget */
        inode = _ocfs2_get_system_file_inode(osb, type, slot);

        /* add one more if putting into array for first time */
        if (arr && inode) {
                *arr = igrab(inode);
                BUG_ON(!*arr);
        }
        mutex_unlock(&osb->system_file_mutex);
        return inode;
 }

, that brings us back to before commit 43b10a20372d, for two threads can hit
the "*arr = igrab(inode)" line.

Even if you also change the "if (arr && inode) {" check in order to make sure that
the second-reached thread won't again hit the "*arr = igrab(inode)" line when the
first-reached thread already hit the "*arr = igrab(inode)" line, the second-reached
thread is fully blocked by the first-reached thread. Not serializing two threads
allows these threads to return as quick as serializing these threads.

>>
>> Thanks,
>> Heming
>>
>>>
>>> 3. Standard filesystems do not use a global mutex for this:
>>>    Standard filesystems (like Ext4's ext4_get_journal_inode or XFS's
>>>    xfs_qm_init_quotainos) rely entirely on the VFS layer's internal hashing/locking (e.g.,
>>>    iget_locked) to serialize metadata/system inode lookups. OCFS2's system_file_mutex is a
>>>    redundant global lock that heavily pollutes the lock dependency graph, triggering
>>>    possible deadlock warnings that block us from testing and fixing genuine deadlocks.
>>>
>>> Since the cmpxchg() approach guarantees atomic slot initialization + igrab(), the global
>>> mutex is completely redundant and should be removed.
>>>
>>> Regards.
>>>


