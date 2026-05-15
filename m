Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAB33F86FD
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 May 2026 23:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778889334; cv=none; b=FCiz8VWnQYyzuQHzBZPn+jlf9Mbt8/OPYBkA3XQWBxI5CRN/auWffewGU1/+cMw6HOxF5TtDRUiVDb1u8kH+DOyQauwXpa809w/X/IDdBq9ozQCO+/SiKEKkUDDzG58qn3AiBu51L4VYnA6vams0t8/CKXD2FZkBWktFWyg3I9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778889334; c=relaxed/simple;
	bh=R7QQmAF7rHIp4ZGfTNo0zSVDjHW0y7nCf5JljviK0mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQKrc9T3FraXVH0+Yq/kt58xdlORpoEId/mMshRfkMz947oMnqgUFWN1yNaQ9B4DupAr+9UoC16uccTWNZMX3LvvMuF4R0ql7Fg0W0s32z/4lnIIrzuopdU+RQtSE0t+wS7vd5Etlg9dys6rwibj+7dBA9uHuixGyOxg75piarg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F+PBzm1M; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F+PBzm1M"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48fde2f2d61so607005e9.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 15 May 2026 16:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778889332; x=1779494132; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=baRntiz3PGNRxi87FvWoZh70C9xltJeEBTGSkvMq1iU=;
        b=F+PBzm1MMqG/gLpN3Py1oM7yk98E5EcBNBvAloRQ3kuR5UMR8WSJymuDCYPBs8GX2q
         NhIzEqY8+nuMYa+G51fVJVZ9b7l0y0IWZQDS5faK+v9I8YkyTdLETQjSDml6FFJQjZYH
         sacN4cFU8dHlCTQ//ENEu6a4QfaQk//qDj4gPkbyb7cgZmApa0Q/bq/oYAEQIhtRb8CV
         xJfplqT2UWo+jYqfTQ0Dtp78PxcQ/nihX58aa8oGn0NJDr/X0005PsELJOlNhCOUlDYh
         nqcuzGarziRcJzLIpbqhezqUse22vLuLFCVM+NErFcdPwlkxA9SZ0W9IkPrr/ihKrAMP
         pRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778889332; x=1779494132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=baRntiz3PGNRxi87FvWoZh70C9xltJeEBTGSkvMq1iU=;
        b=h45hElIAx8gxb4yelL+VAS7U9kTwLVc/fgkK7Dp8vAHLlH44kgxVIp86coZR017Fh+
         xsO337MVr9m2w9w95wEWRnYs+lbcUj+0dH65KbSC8qFfITOyXiJCseIbyPulzlOsvbvv
         f3GiIhTcloXuKMQD8JOgWAO+jd+o3RAS+gtnkEweXuAvSpcCcCt0Gt+DjxGwO8+kWgiE
         lFVSvUarNL7NK1+7a8uhqEhTMhONhs5Bf0LoKC75Fcf24SDdIuVQ7PqIqPEsmcRRye7U
         b8b5OfvFA6151V0IKASXQtFfPy1s0JFTNB23cUNurgnD/xmKqidlP796JL5z0L9UQC4H
         Ts1A==
X-Forwarded-Encrypted: i=1; AFNElJ/tC6GfP2w7A6S6RahNngVWyEpSr/E0Md2RgZndnMo8Ehm3toqxZidEDZ/O2eGgLJcfBQaqs3CoFJBFPw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwrFG4+e9v5ZAxjsi2NZ6PwvkKqtarku8jYu3raDAqtzu2/7i9S
	z9/B39l+tUX7ZXxkGH4IFdaqsVzNxfxjIUHSxbeK6caHr0bUsW6v19vxTXQj0wudsBM=
X-Gm-Gg: Acq92OFIB2fdaIoARje79tLwrVVEDReUsKh/m1W003I99AyOBC8Kbxp04fNwAtzWqNj
	AMCQh9QX5aeyJE8hVbjqtQTEllAEl8PtknfCisvzuvTKq8cxuc+gwbHVezM5hKGKsP6U/kMbruD
	aE68n+Fng0tPdTgOifKnvWlt9LNqUmYHbG41OJlve5qqh2oaYRQvO7uqw0xa8+VPX3hh5sHPjlt
	xaf+s5A7Wjks/TVHysu2hSpubvr0E4ENiah5KV2FsCTthWOGslkWCMZNdms6GHDQ58SIyl5yqAG
	n0uIkKZ0ANLTY5QedhtCaVBa0CL11YO/zwcu6l8hHN4fBAb4UC6Bmx00YXk7ugYDQwyWyXeDvwL
	DwYBEgdRdZHIQz14tZsnx0MQztduM6rPdvZNvZq3OW4eQeqC3+nyxodWMP89nBmLKC21hHMvVtY
	+CwCQOX04FAi2YBVj0zQv6+w==
X-Received: by 2002:a05:600c:4fc5:b0:48e:65f3:a950 with SMTP id 5b1f17b1804b1-48fe5fd55cfmr41187575e9.1.1778889331852;
        Fri, 15 May 2026 16:55:31 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5fe51sm69503815ad.2.2026.05.15.16.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 16:55:30 -0700 (PDT)
Date: Sat, 16 May 2026 07:53:52 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, jiangyiwen <jiangyiwen@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
Message-ID: <ageuwl9o3nzktMrz@c73>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
 <agc8kA2wxC_7091p@c73>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agc8kA2wxC_7091p@c73>

On Fri, May 15, 2026 at 11:35:13PM +0800, Heming Zhao wrote:
> On Thu, May 14, 2026 at 04:09:25PM +0900, Tetsuo Handa wrote:
> > Hi Heming,
> > 
> > I would like to clarify why the expectation of "being called only once" is logically
> > incorrect, reply to your concern regarding the reference count leak and explain why
> > this patch is completely safe and sufficient.
> > 
> > 1. get_local_system_inode() can fail under memory pressure:
> >    get_local_system_inode() allocates memory internally. Under heavy memory pressure,
> >    this allocation can fail and return NULL. When this happens, the caller
> >    ocfs2_get_system_file_inode() must fall back to calling _ocfs2_get_system_file_inode()
> >    again to read the inode from disk. Therefore, the filesystem design must inherently
> >    support multiple calls to _ocfs2_get_system_file_inode().
> > 
> > 2. Why cmpxchg() is sufficient and safe without the mutex:
> >    The only thing the system_file_mutex is needed was to prevent a race where two
> >    threads concurrently execute _ocfs2_get_system_file_inode(), obtain the SAME inode
> >    pointer (since the underlying VFS iget_locked() returns the identical address for
> >    the same slot), and both mistakenly invoke igrab() on it, leading to a reference
> >    count leak.
> > 
> >    This patch perfectly solves that race condition by using cmpxchg() on the target
> >    pointer array slot:
> > 
> >      * The thread that wins the cmpxchg() successfully initializes the slot with the
> >        fetched inode and get the extra refcount because it is the first time to store
> >        into the slot.
> > 
> >      * The thread that loses the cmpxchg() detects that another thread has already
> >        initialized the slot with the exact same inode. The loser thread returns
> >        without getting the extra refcount because it is not the first time to store
> >        into the slot.
> > 
> >    Therefore, the reference counting contract is strictly and atomically maintained.
> >    No references are leaked, and the array slot is never corrupted.
> 
> Hi,
> 
> The logic here is incorrect. The purpose of the refcount is to track how many
> consumers are using the inode.
> 
> In the original code, if two threads concurrently access ocfs2_get_system_file_inode()
> while the inode is uninitialized, inode->i_count would ultimately be incremented
> by 3. However, with your patch, i_count will only be incremented by 2.
> 
> To be more specific:
> Your patch explicitly triggers a race condition: when the target local_system
> inode is uninitialized and two threads enter simultaneously, Thread 1 wins the
> cmpxchg() and increments the refcount before exiting. Thread 2, however, loses
> the refcount increment simply because the atomic operation failed.
> 
> btw, The issue addressed in commit 43b10a20372d was that after two concurrent
> threads returned, inode->i_count ended up being 4 when the correct value should
> have been 3. With your patch, the value will end up being 2, which is insufficient.

My above analysis contains a mistake.
With the patch, the refcount is also 3. However, I don't think the code logic is
correct.

Before commit 43b10a20372d, the refcount was 4:
Thread 1: _ocfs2_get_system_file_inode (refcount +1), "*arr = igrab(inode)" (refcount +1)
Thread 2: does the same job as Thread 1.

Current code logic, the refcount is 3:
Thread 1: _ocfs2_get_system_file_inode (refcount +1), "*arr = igrab(inode)" (refcount +1)
Thread 2: "inode = igrab(inode)" (gets inode from array, refcount +1)

With the patch, the refcount is also 3:
Thread 1: _ocfs2_get_system_file_inode (refcount +1), "*arr = igrab(inode)" (sets array, refcount +1)
Thread 2: _ocfs2_get_system_file_inode (refcount +1)

In theory, _ocfs2_get_system_file_inode() should only be called once after mount.
The performance penalty in the current ocfs2_get_system_file_inode() comes from
doing "inode = igrab(inode)" while holding the mutex lock.

- Heming
> 
> In my opinion, the problem with the current code is that the scope of
> mutex_lock(&osb->system_file_mutex) is too broad. This mutex only needs to be
> held prior to calling _ocfs2_get_system_file_inode(). I previously highlighted
> this point in my initial review comment on the patch.
> 
> Thanks,
> Heming
> 
> > 
> > 3. Standard filesystems do not use a global mutex for this:
> >    Standard filesystems (like Ext4's ext4_get_journal_inode or XFS's
> >    xfs_qm_init_quotainos) rely entirely on the VFS layer's internal hashing/locking (e.g.,
> >    iget_locked) to serialize metadata/system inode lookups. OCFS2's system_file_mutex is a
> >    redundant global lock that heavily pollutes the lock dependency graph, triggering
> >    possible deadlock warnings that block us from testing and fixing genuine deadlocks.
> > 
> > Since the cmpxchg() approach guarantees atomic slot initialization + igrab(), the global
> > mutex is completely redundant and should be removed.
> > 
> > Regards.
> > 
