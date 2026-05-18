Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFE337B413
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 May 2026 02:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779072746; cv=none; b=VukY3gq/Bre/whv4HzclcseW+hRPVFBMF94ltMVqBSDbBXA90oxfTTnIR1nFIte9Vf8m47ntFCQWUHrjQCc9IG2LgKCljWDAIXTVNrnjKvSNVCGQ8HrYD6lbgkqPKiaAjyzH++oU6MXKpRdYwdCXbdS8AkrJeJCRYqw2rB7D+NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779072746; c=relaxed/simple;
	bh=srjcodAozv4JLuO7X9acfYWYMGPSwx6Uadd2oOcjSA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSQiFgamXHQzjJYqFX0GfM3XlOjFdE0DCf+RHfYyDBgquU7XY4eODnGjZC3svjeiAlrUpGhdNH64fxtON5mdUbC764Cb4/FP0p9Zyg/GVDbcoysG1Dxk2kqPoT1vznTUetz8zyqINfGmr2bl7DD3YJTOLMWCLr6JKlJQoHRGUZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XkMutPQ6; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XkMutPQ6"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48e69e60063so817095e9.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 19:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779072743; x=1779677543; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BJLlaxjhYndtoJyGrs9NNxoX5Vmo11cQYCIpaiSe9Hw=;
        b=XkMutPQ69xDMGpcUvM7pBQgLjFkq/QJknc9juMl2aWR3AdBn/wdNYDGB3xhoPP8vgt
         V5+CxmEYlMziJKNG3AX1Pty5vePTxcUrp7+2YrbOeHc2N9DCZ4wpemyAhe1cemLi0WuZ
         eDj5ahnh81UUlvujS6AJDUT9l/na5oxUBvB5iQG9F+BfMnjrVTl8sGSQNRufgRppYBoZ
         i67SGGMxnURiGhTjbUHyrdSzj4/oxfXWvTfcqVkeD0S+VP6zvKMSQR5o6kzGBa6xxBPV
         5EMwnyChkIsHvHtbeX4hBMVOliL+bDT8f+xTjtnz3QN+dO9fIxcZe5VI3++O2u2L8dJO
         fIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779072743; x=1779677543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJLlaxjhYndtoJyGrs9NNxoX5Vmo11cQYCIpaiSe9Hw=;
        b=iHl39yzYMRAe8n1WDJ1pT07Q5DJvKSj2fVjY/fSlY9yjZaOMFort+fD6YrcBIZq63h
         K61izkUbIBIm2Ktnh4+jRrd7VFM1HeU2FxBmE2i1q4C3HQz9FnNQoU4G3HVxVAnKGtNe
         kHhZANpYdiLkXcpFmTZThHc8IN0CTZxnJwBewiDwOKozAMebAUQvhbh33CQOmkWU0gIw
         huPIO7pSH8Zzfb72SL+vh655d/bitnOqj4zHOC4pMQf5elSJiTiD76v/Js+tudCzhZRm
         8TRYhRQQWeMra7l+0yKUWuoKYpGdFnxLIeV8mwyW9LK/ylEjkyPWC3jGyiL48W6DeBU1
         2qAg==
X-Forwarded-Encrypted: i=1; AFNElJ+1QqyRbeVNe6P0JvZgz/7WDSvHTsQ/ZooVxwtJEIzwfcc1iGNph+UcHXA7wLcFF8+LkE83ISL4NKfGag==@lists.linux.dev
X-Gm-Message-State: AOJu0YylwZSK3BPPKEEGHmYfi/QyElXlcPfRYQd+oRJ8T3bTOGvTE02I
	3bpWNcP8TZCHMKCthQ0apeWv3FGmLUQ9DgZ2EGn+f5fz0u66CkQ9Ephct8L8xTnGSO8=
X-Gm-Gg: Acq92OFhZnCNqLdnQ78DJcyPmCaFA6U2JCVeDJT6MwiU54l+TRpxLQwOdkGZtJ4WBMx
	NtXyA5fB/DhC86yhLnvU+SMENphHn/6ycUSOzgQ95hhIRtTOucRxSvzjpfL0ntgiGbno8HZEBXh
	zSdCy2+yRhiuTJtGlFGezjQ8mLUCN7XnWBu7tzylFPQDFFRsYWCbsKkjSMcWyB01To9clg6rZEA
	pyP27Dxma3ik0wvNzx2y9i7e6KwKTF5paoffgnqhInVTjB9GzaqU3Yrhx7giUhidvoJ4EPWIy5H
	JO8W32zcN1CXxrEoXd/Y9x9b3N2POesFzfKO+xERlj7+ROke73pL/WVOHxtV+b+UqsQfrf1GTAN
	QJMQ93ZB9MBPrs/FQ1zc0WLGJiNsZPMY/1Efdqgf4zaoFguos3EXoW86w7IxvIex1UGFTpdCh3J
	8Z/cHLMxjYsm8B+HB7d/7S0Q==
X-Received: by 2002:a05:600c:198d:b0:489:6c28:dbb4 with SMTP id 5b1f17b1804b1-48fe62f7cbbmr109725735e9.5.1779072743330;
        Sun, 17 May 2026 19:52:23 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb114a70sm14642994a12.22.2026.05.17.19.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 19:52:22 -0700 (PDT)
Date: Mon, 18 May 2026 10:52:19 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, jiangyiwen <jiangyiwen@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
Message-ID: <agp0sACmJl3tePyr@c73>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
 <agc8kA2wxC_7091p@c73>
 <ageuwl9o3nzktMrz@c73>
 <fb0685c4-bcee-4c7b-8ac4-a1af702b8600@I-love.SAKURA.ne.jp>
 <aghfx-XhwoE4fBYR@c73>
 <670882aa-b637-4565-adf0-ddcd9d7a588b@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <670882aa-b637-4565-adf0-ddcd9d7a588b@I-love.SAKURA.ne.jp>

On Sat, May 16, 2026 at 10:10:44PM +0900, Tetsuo Handa wrote:
> On 2026/05/16 21:27, Heming Zhao wrote:
> >>>> In my opinion, the problem with the current code is that the scope of
> >>>> mutex_lock(&osb->system_file_mutex) is too broad. This mutex only needs to be
> >>>> held prior to calling _ocfs2_get_system_file_inode(). I previously highlighted
> >>>> this point in my initial review comment on the patch.
> >>
> >> If you meant
> >>
> >>  struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
> >>                                           int type,
> >>                                           u32 slot)
> >>  {
> >>         struct inode *inode = NULL;
> >>         struct inode **arr = NULL;
> >>
> >>         /* avoid the lookup if cached in local system file array */
> >>         if (is_global_system_inode(type)) {
> >>                 arr = &(osb->global_system_inodes[type]);
> >>         } else
> >>                 arr = get_local_system_inode(osb, type, slot);
> >>
> >> -       mutex_lock(&osb->system_file_mutex);
> >>         if (arr && ((inode = *arr) != NULL)) {
> >>                 /* get a ref in addition to the array ref */
> >>                 inode = igrab(inode);
> >>                 mutex_unlock(&osb->system_file_mutex);
> >>                 BUG_ON(!inode);
> >>
> >>                 return inode;
> >>         }
> >>
> >> +       mutex_lock(&osb->system_file_mutex);
> >> +
> >>         /* this gets one ref thru iget */
> >>         inode = _ocfs2_get_system_file_inode(osb, type, slot);
> >>
> >>         /* add one more if putting into array for first time */
> >>         if (arr && inode) {
> >>                 *arr = igrab(inode);
> >>                 BUG_ON(!*arr);
> >>         }
> >>         mutex_unlock(&osb->system_file_mutex);
> >>         return inode;
> >>  }
> >>
> > 
> > Yes, this is what I expected.
> > 
> >> , that brings us back to before commit 43b10a20372d, for two threads can hit
> >> the "*arr = igrab(inode)" line.
> > 
> > I don't think this bring us back, because igrab() uses a spinlock to protect the
> > refcount.
> 
> You are missing the point. What is wrong with above change is that two threads can
> sequentially enter into the "if (arr && inode) { }" block, for we are not checking
> whether the slot is already NULL or not. The cmpxchg() is the magic that guarantees
> that only one thread can enter into that block.

To avoid my code issue, the code should be:

     mutex_lock(&osb->system_file_mutex);

     if (arr && !*arr) {
         /* this gets one ref thru iget */
         inode = _ocfs2_get_system_file_inode(osb, type, slot);

         /* add one more if putting into array for first time */
         if (inode) {
             *arr = igrab(inode);
             BUG_ON(!*arr);
         }
     } else if (arr && *arr) {
	 /* get a ref in addition to the array ref */
	 inode = igrab(*arr);
	 BUG_ON(!inode);
     }
     mutex_unlock(&osb->system_file_mutex);

If apply this change, the code will look too complicated and hard to maintain.
Regarding the removal of the mutex, your patch looks good to me now.

My new comment for your patch:
Because this issue was triggered by syzbot testing Diogo Jahchan Koike
<djahchankoike@gmail.com>'s patch for bug[1], I think it's better to removed the
'Reported-by' and close' tags, and describe the history in commit log. 
Current 'Reported-by' & 'close' tags are misleading.

[1]: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b

Thanks,
Heming
> 
> >>
> >> Even if you also change the "if (arr && inode) {" check in order to make sure that
> >> the second-reached thread won't again hit the "*arr = igrab(inode)" line when the
> >> first-reached thread already hit the "*arr = igrab(inode)" line, the second-reached
> >> thread is fully blocked by the first-reached thread. Not serializing two threads
> >> allows these threads to return as quick as serializing these threads.
> > 
> > with the mutex protection removed, and relying on igrab()'s internal spinlock,
> > the code logic is already correct for concurrency. 
> > 
> > there are two kinds of locks involved in this discussion: 
> > - inode->i_lock: protects the inode's refcount (used by igrab())
> > - osb->system_file_mutex: protects the array slot.
> 
> You are missing the point. The lock used inside igrab() is irrelevant.
> The cmpxchg() is the lock that protects the array slot (in other words,
> serializes two threads) without using the system_file_mutex lock.
> 
