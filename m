Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E5C4D9910
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 May 2026 15:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778859324; cv=none; b=nlyqFk8l6+fijS6sQ+ZdB9PQG+hGti1LKZa9i6/VGixRyHKQHv+bfhssWoaB+GEQaVwNfzxyhuGhv0rXjshZpy17vTZdqdhA3wtI3C+w32tjco8EeL5z9btokuOAqay4WZKzSeqCqfgA6COCVqKqVVkmKSJkD0T9nLyAEa0m0kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778859324; c=relaxed/simple;
	bh=IkY4f31IVI+sS2rTQ19APf2Kf6Tq7o1apDJKC1b+guU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKk39PKrQzMd1uU0tyVmS3jQf57Rv5XlRXLlRp52TwkLghLZAVCPX6iHMiVc34Ez9SIxzMVWEQGOCKqjjk65J2dhSt53fdJP3mknUKRoow6znboCXzi/XaSLhgS6WLm3dX00Jl6uVM5idFrqnMfF/ql1rapRhmbvHIf6miJLyBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CWF86bsN; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CWF86bsN"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-44c44af71f8so947322f8f.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 15 May 2026 08:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778859316; x=1779464116; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1PMkqrlxvVv2+zBG40scq5k2wIizxTATm8E5BebsVQs=;
        b=CWF86bsN/TdnziO8ym5MhmUzVc5dUKM+PaSB9b2thh29VuJmeIyg2haGrssj9sLeX6
         Ilv96Cutp3yVurMi+VKCuuXJCMqFwTPVCdfkTmDIqJQgK0goY4m5IbOtpvdpWU92Q4W6
         3ahKM/F87dvHEJ4f7nQAEK7IKukXGv2Tg4baOn6QHLjMnMRQ220uEmYJ1P+M7Qz+SOq3
         bRZVNHWaGzQwniXd9or04QUWtAc6uNYOODpNjcAv2KxhTuVSivEo3WTB+hylMQhKxYRb
         oUDQodQqW7dkc6BWQZiXr4tSG6MpoKQzrGTf352aUBxueft1omggT+QpBBIC9Y3DLVUf
         12Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778859316; x=1779464116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1PMkqrlxvVv2+zBG40scq5k2wIizxTATm8E5BebsVQs=;
        b=f9LfXUFApX13b9sPgRU1SZOYtdprrLvPlHkXvjD3C59Qb7qD/Oxi0KnsmFo37qtlWT
         PUitJZht3qQY+BjpMdZ+esohB6Rx2+C63nOF7OflKkWjUcHEaBFAebQGEIUVbiSgbye7
         3VMqhwKcMGnR/aJJuuAOGKxQt94qAdq5ZdcLJ04Uo6gxQLFM6ZrVScX3ju/FOJWLH4zZ
         NIN424poSvCu+gUIzYUShGyGbHmLIRKfRfWChkzATaadKT335Ooe3QVDzFJ7v9XpCvOp
         MMITZ8+3tlqIGG+Kka+Z7Pp6sz7HUFeMWhGxToqrKTFmB9A3EUZR7lNdrI4+mNaIx/qs
         4E1g==
X-Forwarded-Encrypted: i=1; AFNElJ/sfz0gDpyPKRTM3Xr0MDb+IEyl0xa4AKLX7zXNZLKY+Nr5g8N6PkhNU1ldNhkRQgEh4/+t6iENvKMp0w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzM88gFbtKLIDJULJaDyj//RcGoNrs3gBFYW0Y0aQcOMp+jJnrI
	Ci4ToTA+z4CF1U5a1IV1GmiyEn+wicMp8DpZmRn71sRVw0SKoaIi9+QmH3ALsIhJKCfd3maaauV
	8pOpw0xk=
X-Gm-Gg: Acq92OFoaOJAldvA/8ERDnhiPW/c5Oea2VVUygft8YlK2bXAAjTqQ/r+R/3omWB3nit
	z04ccV0TDdCaz2CdW6drzQ7g0DUpZwAuz2U1VEzUlGOwzppbcffdxzcjGa3G6RULADuegM9nVJO
	X90e8tFfvIXXKCR/tkE592Muz5QpHsNz4o+dWQaCpADigFuq6pBdty6bUt/BnvGeG1TPHp4KaBl
	yARIP9JRcua8jLFr8sZ4CCLJd6Cg2ubqbSLERngiNEXtSiSFrKAEA0Yi8fzBgyCShq3+uG+Xpjz
	LOp+zaYG2c/+ApcQapOBNse4HiYKbFIN4ArnB41NaIJJHPzRaITSN7SKd5FVvY1rTsNaFRn+xxM
	pklthmNc0hf1sVigwtJ6c6hM82wlkbv66rBdWV/zhXRmO/8FRPxiQZ7w6N3nl4/uIq6iI05oQfr
	qwZ5tGPJe5qR04tEa8hJoWqKBDzgUsLqTMaVn3WaWwkWQ=
X-Received: by 2002:a05:600c:1f8c:b0:48f:d410:6076 with SMTP id 5b1f17b1804b1-48fe630e3d5mr28492035e9.7.1778859316419;
        Fri, 15 May 2026 08:35:16 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5cfe498asm64859135ad.39.2026.05.15.08.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 08:35:15 -0700 (PDT)
Date: Fri, 15 May 2026 23:35:13 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, jiangyiwen <jiangyiwen@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
Message-ID: <agc8kA2wxC_7091p@c73>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>

On Thu, May 14, 2026 at 04:09:25PM +0900, Tetsuo Handa wrote:
> Hi Heming,
> 
> I would like to clarify why the expectation of "being called only once" is logically
> incorrect, reply to your concern regarding the reference count leak and explain why
> this patch is completely safe and sufficient.
> 
> 1. get_local_system_inode() can fail under memory pressure:
>    get_local_system_inode() allocates memory internally. Under heavy memory pressure,
>    this allocation can fail and return NULL. When this happens, the caller
>    ocfs2_get_system_file_inode() must fall back to calling _ocfs2_get_system_file_inode()
>    again to read the inode from disk. Therefore, the filesystem design must inherently
>    support multiple calls to _ocfs2_get_system_file_inode().
> 
> 2. Why cmpxchg() is sufficient and safe without the mutex:
>    The only thing the system_file_mutex is needed was to prevent a race where two
>    threads concurrently execute _ocfs2_get_system_file_inode(), obtain the SAME inode
>    pointer (since the underlying VFS iget_locked() returns the identical address for
>    the same slot), and both mistakenly invoke igrab() on it, leading to a reference
>    count leak.
> 
>    This patch perfectly solves that race condition by using cmpxchg() on the target
>    pointer array slot:
> 
>      * The thread that wins the cmpxchg() successfully initializes the slot with the
>        fetched inode and get the extra refcount because it is the first time to store
>        into the slot.
> 
>      * The thread that loses the cmpxchg() detects that another thread has already
>        initialized the slot with the exact same inode. The loser thread returns
>        without getting the extra refcount because it is not the first time to store
>        into the slot.
> 
>    Therefore, the reference counting contract is strictly and atomically maintained.
>    No references are leaked, and the array slot is never corrupted.

Hi,

The logic here is incorrect. The purpose of the refcount is to track how many
consumers are using the inode.

In the original code, if two threads concurrently access ocfs2_get_system_file_inode()
while the inode is uninitialized, inode->i_count would ultimately be incremented
by 3. However, with your patch, i_count will only be incremented by 2.

To be more specific:
Your patch explicitly triggers a race condition: when the target local_system
inode is uninitialized and two threads enter simultaneously, Thread 1 wins the
cmpxchg() and increments the refcount before exiting. Thread 2, however, loses
the refcount increment simply because the atomic operation failed.

btw, The issue addressed in commit 43b10a20372d was that after two concurrent
threads returned, inode->i_count ended up being 4 when the correct value should
have been 3. With your patch, the value will end up being 2, which is insufficient.

In my opinion, the problem with the current code is that the scope of
mutex_lock(&osb->system_file_mutex) is too broad. This mutex only needs to be
held prior to calling _ocfs2_get_system_file_inode(). I previously highlighted
this point in my initial review comment on the patch.

Thanks,
Heming

> 
> 3. Standard filesystems do not use a global mutex for this:
>    Standard filesystems (like Ext4's ext4_get_journal_inode or XFS's
>    xfs_qm_init_quotainos) rely entirely on the VFS layer's internal hashing/locking (e.g.,
>    iget_locked) to serialize metadata/system inode lookups. OCFS2's system_file_mutex is a
>    redundant global lock that heavily pollutes the lock dependency graph, triggering
>    possible deadlock warnings that block us from testing and fixing genuine deadlocks.
> 
> Since the cmpxchg() approach guarantees atomic slot initialization + igrab(), the global
> mutex is completely redundant and should be removed.
> 
> Regards.
> 
