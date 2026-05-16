Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F2137BE8E
	for <ocfs2-devel@lists.linux.dev>; Sat, 16 May 2026 12:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778934473; cv=none; b=XU87sls+0GL/MMyjAYMFtgNu/KM0bUI6goHd1LfoSxcQrkP/5BTjKISn/lKhjMSN77THkbBqAfAZZJxY6C3rsi9o1AkVGhrit3HHDwOyN9ag8Or81sAGp2KSMAZOKqIj3jAuwuzd6MBEe95Gi6aolxT/RPdQM+aqCDkCOnSbmNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778934473; c=relaxed/simple;
	bh=FDdNeMpkQfNoY1ia2cF+0Pnsr0sjnEXveZzDEFeB0v0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PeU4terszi5L/TZyBiumL3s7a0qiJ/t/X4Jv5bodgc+/+x254h1fu9jkR56zIvANPFQi+vsEiUnIplDYJpLOGSaylqK3Sv4cj/KFXI31GS6OLZZ9H8R0r6nj/0PqgMbK0XILnM9c9qCxlPFqrNkX6CCGGLn9aZyq47o+8zxVl/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L1LFczfE; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L1LFczfE"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48d10c981e4so1051535e9.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 16 May 2026 05:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778934470; x=1779539270; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0fktphNxA5658y8QqAPddXq1GVKd3kmeCeKdv6cddIg=;
        b=L1LFczfEivY44TIH/RvzAjFcWARZz/TMNWQaHI6ZKjTMAyN2OqaP0oM7s6u23Ltz0D
         WCZn37M5Hj+mJUep3VyEsnFBTURbttubCZNQWToB+QnzbUnU5Bf0Imn2LfNxeP4EcmFj
         6ewDPLn/rFqtem9QQY/T57Ke2DhSxxt0ZTq2VDhhA3DlFyppTMSbAqTZ6XkD+u+k4rIF
         7BdORJl5B4snkYdeCxE2lCoxqWk5ny6eacwv/6ZSkKPxMf8bThEdHDNbnZ6C3jNCLPF0
         lYh6U4ocFPy7HUGm+iwF1Am7VKegsGlr8/MM0Oc85KVP4LpF93Vn7gTjPQx1nAkSYxFZ
         tiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778934470; x=1779539270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0fktphNxA5658y8QqAPddXq1GVKd3kmeCeKdv6cddIg=;
        b=WuxQunJIYj/+aCNB3QmHIlNywdUokt0pxPguGahxo6R+6R98hf9m0ZDwHhDsMbE1JX
         PQ4CegGISTQq/Tks7qdJnOEytpNWrL3cEl6804sNGFKXog1ljrzJFd4X5V2ZaxvNZMdN
         o2pf3x30kGhfgdSRufBXR/602lOMVZMjzj2wbZCnl6lyF0qtcRgtGsdhwTUdaKA+MbgI
         UUYhyeqWLWWopXeMxhFK5yZHHRcZsJy/6YZljE1iT/AODMmEveqes8OBWin9T0PzWAVl
         Cvo/PQe58S3SDVFBh36XNw+Gy59RWTWn6+k571dk6kswF97vP3bemk6IEy7a6RDSpd1d
         wxag==
X-Forwarded-Encrypted: i=1; AFNElJ8RBq+9uyn2laFA4n/CzCcL2pG95gIES99zKF6r8R/phHp4/NO7cIidoklnxb1kiXTLrkyqmeq+SIIHHA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwPP8MfzD4eF9fXxwgbV1MRRS5mP6OdA3U41Q+qo1xEJveakGOS
	SS/GzyqfmqqfFkFHxPrdwDskXZuyIKNtSLdMhQR9LqwDYIh+D+nzBY1f8xXOUIPllxtehzlezVq
	E9foMG/wMxw==
X-Gm-Gg: Acq92OGT0ZDYmqUwyMtrZmU2q9DM7gCOZf0kCmfmJW7uuCUW6HIc5jfJcAeBMEDji21
	wern9V/46bBB9i7fLNH5AO9NUzfD/jRRpE4ehUyE9dQQnLJ/7lkpDbUAZC/BKq9iNJeGdLFcSJP
	Fpf+d/B5qs78rrUZ4zwyn/HW2v2FsZPZ4bqXUedDu9zst5Cy+EKC0Yt2oGppOsbEyhyIAj5Pgxy
	fC56l0UKrRtuhaZVxCuHCpyGC9TGQkn0NPorSrBnm9rHXxmTtQ+R/kxJaEKrtEH28jORMWyhobu
	WQZkwawS8MRFouNtzqH7pvNjJDy7Rokk4tHlo05J79B5bSyqCwNtuKrHC67/TRn84rKN87pcCaH
	FEkKTQSHFUnmYX8+8cZ/doxsXpT/Ewx8hgK7qYY0vqz8fkyGN1kdOciDsjw9vviTi96A6uBJ/JS
	wDjZBuaDH7MozWC58LLvKWoS2/LHBd3PwG
X-Received: by 2002:a05:600c:4704:b0:489:1ca4:c999 with SMTP id 5b1f17b1804b1-48fe66550aamr50096145e9.8.1778934470242;
        Sat, 16 May 2026 05:27:50 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d11cbdesm91037675ad.71.2026.05.16.05.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 05:27:48 -0700 (PDT)
Date: Sat, 16 May 2026 20:27:45 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, jiangyiwen <jiangyiwen@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
Message-ID: <aghfx-XhwoE4fBYR@c73>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
 <agc8kA2wxC_7091p@c73>
 <ageuwl9o3nzktMrz@c73>
 <fb0685c4-bcee-4c7b-8ac4-a1af702b8600@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb0685c4-bcee-4c7b-8ac4-a1af702b8600@I-love.SAKURA.ne.jp>

On Sat, May 16, 2026 at 02:52:29PM +0900, Tetsuo Handa wrote:
> On 2026/05/16 8:53, Heming Zhao wrote:
> > On Fri, May 15, 2026 at 11:35:13PM +0800, Heming Zhao wrote:
> >> On Thu, May 14, 2026 at 04:09:25PM +0900, Tetsuo Handa wrote:
> >>> Hi Heming,
> >>>
> >>> I would like to clarify why the expectation of "being called only once" is logically
> >>> incorrect, reply to your concern regarding the reference count leak and explain why
> >>> this patch is completely safe and sufficient.
> >>>
> >>> 1. get_local_system_inode() can fail under memory pressure:
> >>>    get_local_system_inode() allocates memory internally. Under heavy memory pressure,
> >>>    this allocation can fail and return NULL. When this happens, the caller
> >>>    ocfs2_get_system_file_inode() must fall back to calling _ocfs2_get_system_file_inode()
> >>>    again to read the inode from disk. Therefore, the filesystem design must inherently
> >>>    support multiple calls to _ocfs2_get_system_file_inode().
> >>>
> >>> 2. Why cmpxchg() is sufficient and safe without the mutex:
> >>>    The only thing the system_file_mutex is needed was to prevent a race where two
> >>>    threads concurrently execute _ocfs2_get_system_file_inode(), obtain the SAME inode
> >>>    pointer (since the underlying VFS iget_locked() returns the identical address for
> >>>    the same slot), and both mistakenly invoke igrab() on it, leading to a reference
> >>>    count leak.
> >>>
> >>>    This patch perfectly solves that race condition by using cmpxchg() on the target
> >>>    pointer array slot:
> >>>
> >>>      * The thread that wins the cmpxchg() successfully initializes the slot with the
> >>>        fetched inode and get the extra refcount because it is the first time to store
> >>>        into the slot.
> >>>
> >>>      * The thread that loses the cmpxchg() detects that another thread has already
> >>>        initialized the slot with the exact same inode. The loser thread returns
> >>>        without getting the extra refcount because it is not the first time to store
> >>>        into the slot.
> >>>
> >>>    Therefore, the reference counting contract is strictly and atomically maintained.
> >>>    No references are leaked, and the array slot is never corrupted.
> >>
> >> Hi,
> >>
> >> The logic here is incorrect. The purpose of the refcount is to track how many
> >> consumers are using the inode.
> >>
> >> In the original code, if two threads concurrently access ocfs2_get_system_file_inode()
> >> while the inode is uninitialized, inode->i_count would ultimately be incremented
> >> by 3. However, with your patch, i_count will only be incremented by 2.
> >>
> >> To be more specific:
> >> Your patch explicitly triggers a race condition: when the target local_system
> >> inode is uninitialized and two threads enter simultaneously, Thread 1 wins the
> >> cmpxchg() and increments the refcount before exiting. Thread 2, however, loses
> >> the refcount increment simply because the atomic operation failed.
> >>
> >> btw, The issue addressed in commit 43b10a20372d was that after two concurrent
> >> threads returned, inode->i_count ended up being 4 when the correct value should
> >> have been 3. With your patch, the value will end up being 2, which is insufficient.
> > 
> > My above analysis contains a mistake.
> > With the patch, the refcount is also 3. However, I don't think the code logic is
> > correct.
> > 
> > Before commit 43b10a20372d, the refcount was 4:
> > Thread 1: _ocfs2_get_system_file_inode (refcount +1), "*arr = igrab(inode)" (refcount +1)
> > Thread 2: does the same job as Thread 1.
> > 
> > Current code logic, the refcount is 3:
> > Thread 1: _ocfs2_get_system_file_inode (refcount +1), "*arr = igrab(inode)" (refcount +1)
> > Thread 2: "inode = igrab(inode)" (gets inode from array, refcount +1)
> 
> Yes, commit 43b10a20372d ("ocfs2: avoid system inode ref confusion
> by adding mutex lock") was to prevent
> 
>  struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>                                           int type,
>                                           u32 slot)
>  {
>         struct inode *inode = NULL;
>         struct inode **arr = NULL;
> 
>         /* avoid the lookup if cached in local system file array */
>         if (is_global_system_inode(type)) {
>                 arr = &(osb->global_system_inodes[type]);
>         } else
>                 arr = get_local_system_inode(osb, type, slot);
> 
> +       mutex_lock(&osb->system_file_mutex);
>         if (arr && ((inode = *arr) != NULL)) {
>                 /* get a ref in addition to the array ref */
>                 inode = igrab(inode);
> +               mutex_unlock(&osb->system_file_mutex);
>                 BUG_ON(!inode);
> 
>                 return inode;
>         }
> 
>         /* this gets one ref thru iget */
>         inode = _ocfs2_get_system_file_inode(osb, type, slot);
> 
>         /* add one more if putting into array for first time */
>         if (arr && inode) {
> 
> two threads concurrently reaching here.
> 
>                 *arr = igrab(inode);
>                 BUG_ON(!*arr);
>         }
> +       mutex_unlock(&osb->system_file_mutex);
>         return inode;
>  }
> 
> > 
> > With the patch, the refcount is also 3:
> > Thread 1: _ocfs2_get_system_file_inode (refcount +1), "*arr = igrab(inode)" (sets array, refcount +1)
> > Thread 2: _ocfs2_get_system_file_inode (refcount +1)
> 
> Yes, and what prevents you from accepting my patch?
> 
> > 
> > In theory, _ocfs2_get_system_file_inode() should only be called once after mount.
> > The performance penalty in the current ocfs2_get_system_file_inode() comes from
> > doing "inode = igrab(inode)" while holding the mutex lock.
> 
> My patch is required for simplifying locking dependency chain, for serializing
> call to _ocfs2_get_system_file_inode() using mutex is causing lockdep warning.
> 
> Eliminating possibility of deadlock is far more important than worrying about
> performance penalty for rare race condition. We don't need to serialize because
> _ocfs2_get_system_file_inode() can return the same pointer for the same input.
> 
> > 
> > - Heming
> >>
> >> In my opinion, the problem with the current code is that the scope of
> >> mutex_lock(&osb->system_file_mutex) is too broad. This mutex only needs to be
> >> held prior to calling _ocfs2_get_system_file_inode(). I previously highlighted
> >> this point in my initial review comment on the patch.
> 
> If you meant
> 
>  struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>                                           int type,
>                                           u32 slot)
>  {
>         struct inode *inode = NULL;
>         struct inode **arr = NULL;
> 
>         /* avoid the lookup if cached in local system file array */
>         if (is_global_system_inode(type)) {
>                 arr = &(osb->global_system_inodes[type]);
>         } else
>                 arr = get_local_system_inode(osb, type, slot);
> 
> -       mutex_lock(&osb->system_file_mutex);
>         if (arr && ((inode = *arr) != NULL)) {
>                 /* get a ref in addition to the array ref */
>                 inode = igrab(inode);
>                 mutex_unlock(&osb->system_file_mutex);
>                 BUG_ON(!inode);
> 
>                 return inode;
>         }
> 
> +       mutex_lock(&osb->system_file_mutex);
> +
>         /* this gets one ref thru iget */
>         inode = _ocfs2_get_system_file_inode(osb, type, slot);
> 
>         /* add one more if putting into array for first time */
>         if (arr && inode) {
>                 *arr = igrab(inode);
>                 BUG_ON(!*arr);
>         }
>         mutex_unlock(&osb->system_file_mutex);
>         return inode;
>  }
> 

Yes, this is what I expected.

> , that brings us back to before commit 43b10a20372d, for two threads can hit
> the "*arr = igrab(inode)" line.

I don't think this bring us back, because igrab() uses a spinlock to protect the
refcount.
> 
> Even if you also change the "if (arr && inode) {" check in order to make sure that
> the second-reached thread won't again hit the "*arr = igrab(inode)" line when the
> first-reached thread already hit the "*arr = igrab(inode)" line, the second-reached
> thread is fully blocked by the first-reached thread. Not serializing two threads
> allows these threads to return as quick as serializing these threads.

with the mutex protection removed, and relying on igrab()'s internal spinlock,
the code logic is already correct for concurrency. 

there are two kinds of locks involved in this discussion: 
- inode->i_lock: protects the inode's refcount (used by igrab())
- osb->system_file_mutex: protects the array slot.

Thanks,
Heming

> >>>
> >>> 3. Standard filesystems do not use a global mutex for this:
> >>>    Standard filesystems (like Ext4's ext4_get_journal_inode or XFS's
> >>>    xfs_qm_init_quotainos) rely entirely on the VFS layer's internal hashing/locking (e.g.,
> >>>    iget_locked) to serialize metadata/system inode lookups. OCFS2's system_file_mutex is a
> >>>    redundant global lock that heavily pollutes the lock dependency graph, triggering
> >>>    possible deadlock warnings that block us from testing and fixing genuine deadlocks.
> >>>
> >>> Since the cmpxchg() approach guarantees atomic slot initialization + igrab(), the global
> >>> mutex is completely redundant and should be removed.
> >>>
> >>> Regards.
> >>>
> 
> 
> 
