Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3268D3F4121
	for <ocfs2-devel@lists.linux.dev>; Thu, 14 May 2026 07:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778742903; cv=none; b=bHUEJy2+MVUVHnFj7e0JvrdH4rNBWZ8b01sSnZEWG6ad4pdcxqZ4UIJkNK2jCNEyFwoLpUI50WlWBQt55pvfkISDfybwSrIGAt1riMvUjh+B+3FuVB5WFzaxnC8kyDBnX3P9ABaaHAETDjeXmjcoEL3Wg3FYuAm8cxSltIovFx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778742903; c=relaxed/simple;
	bh=SZRlX9gBVvnH2bmlXVKehrthVmcOmdDerUAyt+pVi64=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=DVkunA+jRk5I6A1wi30/0qkrXGbupbVk6iPuSPnaM/qXfWPGLB5B5jS4ZQhZtigbmcJKw9c65ubZYJHyvqAmX54vTU/Rayy6kxYrrhwRJgHgFjdFCKyPk1T/H34ItL3ED3D5GsVmZs0QGoqAHfBU/ot4aF2UzqJct9U+1nXYcOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 64E79SHD033504;
	Thu, 14 May 2026 16:09:28 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 64E79RqS033500
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 14 May 2026 16:09:28 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
Date: Thu, 14 May 2026 16:09:25 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        jiangyiwen <jiangyiwen@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev,
        Heming Zhao <heming.zhao@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
Content-Language: en-US
In-Reply-To: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav403.rs.sakura.ne.jp
X-Virus-Status: clean

Hi Heming,

I would like to clarify why the expectation of "being called only once" is logically
incorrect, reply to your concern regarding the reference count leak and explain why
this patch is completely safe and sufficient.

1. get_local_system_inode() can fail under memory pressure:
   get_local_system_inode() allocates memory internally. Under heavy memory pressure,
   this allocation can fail and return NULL. When this happens, the caller
   ocfs2_get_system_file_inode() must fall back to calling _ocfs2_get_system_file_inode()
   again to read the inode from disk. Therefore, the filesystem design must inherently
   support multiple calls to _ocfs2_get_system_file_inode().

2. Why cmpxchg() is sufficient and safe without the mutex:
   The only thing the system_file_mutex is needed was to prevent a race where two
   threads concurrently execute _ocfs2_get_system_file_inode(), obtain the SAME inode
   pointer (since the underlying VFS iget_locked() returns the identical address for
   the same slot), and both mistakenly invoke igrab() on it, leading to a reference
   count leak.

   This patch perfectly solves that race condition by using cmpxchg() on the target
   pointer array slot:

     * The thread that wins the cmpxchg() successfully initializes the slot with the
       fetched inode and get the extra refcount because it is the first time to store
       into the slot.

     * The thread that loses the cmpxchg() detects that another thread has already
       initialized the slot with the exact same inode. The loser thread returns
       without getting the extra refcount because it is not the first time to store
       into the slot.

   Therefore, the reference counting contract is strictly and atomically maintained.
   No references are leaked, and the array slot is never corrupted.

3. Standard filesystems do not use a global mutex for this:
   Standard filesystems (like Ext4's ext4_get_journal_inode or XFS's
   xfs_qm_init_quotainos) rely entirely on the VFS layer's internal hashing/locking (e.g.,
   iget_locked) to serialize metadata/system inode lookups. OCFS2's system_file_mutex is a
   redundant global lock that heavily pollutes the lock dependency graph, triggering
   possible deadlock warnings that block us from testing and fixing genuine deadlocks.

Since the cmpxchg() approach guarantees atomic slot initialization + igrab(), the global
mutex is completely redundant and should be removed.

Regards.

