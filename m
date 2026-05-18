Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369D3352C5B
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 May 2026 04:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779080191; cv=none; b=QJs5eqIkxClgeyme+qq+ZIwQhmhg/kKIquuQftFWT04+AtLf8253SN1UT2h/2jmm9RFK3fclbOOAsLBavkP6GjtbO0ul7S0sKoAaPP9pK4RY0gq257g5Mlo7N7c9TcCUwGrlXE7/H1lOQEj2vRrsuwXDgr3YwiqH/v97Etgsdxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779080191; c=relaxed/simple;
	bh=jK17ra+U3QeRaBG3iM0+CtThYytvEeuX9BGPWLAfSjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1yzTYhuJrXO4U11ACNmEnrdSyYt1g43oWsKybjHvqwSuZCN6l7vn+DWP14FaOUFHR45MUDlKwCamJHKfDYCgK8pfGkDQGRxwP5ZtJkoWFjdoAq5owoXBPgndBomAXpze8fYXot+MgibiLQ63TZ/RgOiF4nDEAEx8pf6Y9mrJo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NY1ILSUJ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NY1ILSUJ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891cd5927dso2398265e9.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 21:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779080186; x=1779684986; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k0OZZFbtpd0P0l844Mf3BjaBFBMK33D0MsUv0CPwPZc=;
        b=NY1ILSUJ+al2rDB6kOtvGDxB81Ml+cPTXPm2L76hN6ZENhCxs2W0xaiYS3KHpYRkzi
         wJArUgxzeGetjr/z5t0BnFRdM/kepd1HFyluiuA8EO2rZn7UexYkluK0+dCGAXNiH2na
         d0f+8XyETdb3xnoZ+sTbk2XcDIaPtSoBoZVCnXkmxCmUkfRMK9Pb1e57FKsAfXjXGiK4
         okB4GQHLMgrlFAYz8vviftJsflClnUDO0S2NeWyIeQoIa3RMoKvYf2KpHwJa6UsA9JUY
         txqWtx/oifVuP6t4En7i9JMH/d04/dHR/0puA+LO7oq+xuEna5VuEM0eLIiieYAksUKA
         IVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779080186; x=1779684986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k0OZZFbtpd0P0l844Mf3BjaBFBMK33D0MsUv0CPwPZc=;
        b=Ou11z5ABweBn3JTrOd9/gPmP8ToGHgnH7UQ3H9ZhqQJRRy69t+COvzQ81I9av6ErKe
         sWu1bExcjWLy8z3BXul0c4RIylm9NbuY3A7io9TEZshSyJA5IYE7JKPWZpIBlNfJZchN
         O+YfTJKoFjDBzDg9+6DLjnaqdR6qTngqQxTAl2z+HtWZFZoO6vtKFwDHS/8fXI+Wick2
         KJ7iGu2MmpOSB593h82oYtD0+sE4oAHyHD62KxoLrPsDwvAY9eTSpFkIC+yUFUZy6Yqm
         MNktpiXO/hoU3jMVadYTPrktKSR4rWcmR2llg4f0XNZrG/+5kgT6UXbsBon1tTeGqicB
         OLnA==
X-Forwarded-Encrypted: i=1; AFNElJ/BAp6Cqu3K+ikTku2mrC6Hvmu3Ol8IkCtIzEE3JMo+cD/3n7cWC6HFJJzBDq7dKcmEyVkxRE1l4fQ0Ng==@lists.linux.dev
X-Gm-Message-State: AOJu0YwN22/yAVZJFGAlpJEmhSkXZv6BB2Aa1rP8yzP3fVprHirW2raF
	/F/3xGNXgnhKTsRHbl6uSHlw/bJ4Eu/+eTuY4zpo86W2+9qDXPfxtCPjTvXqIb2HsOo=
X-Gm-Gg: Acq92OGPfe64r7pRG3XHSbx39+JokU9xjZjvmKfcW82RRIG9O0yzOZlk4W96HOu/1AK
	bdEkmMO3S00s3FNQj9aRGqJrrHDEXg5hmRQU+OEE4nmv+zdHt1LOkUUWs8tx7KYsUAeE4fdF28j
	/Cdt0N5/XmBSbPpcTpvqxQIlAd5E03mQStRL+iDYvJ0GzYPrcjsrD+xvgYWnfxtm0pS/+bIYSOA
	C9v9JAf2+NlunIAkxLzS8ry8GWienVcMcxJe5eAZ2diDWI0+BBE9s0CQ2T6L18P3HuogKN3Gna9
	5xY1bJWlgllN/3yMS9JjyUnLIPw1X7G/nl5kcDeiDAZRNG1t5aatBCa7gp/Y2a8AxxCfP6b4bDD
	JbAGtR5VB3XNdld37ummLExNhH8kwXq87Ob9sfnbTyUCwTJwaQz2h8mKOa70gPaG1MKT6YliE/w
	4A2qCj/s584wEBlZfRKVWG7w==
X-Received: by 2002:a05:600c:4fc5:b0:48e:65f3:a950 with SMTP id 5b1f17b1804b1-48fe5fd55cfmr95968225e9.1.1779080186449;
        Sun, 17 May 2026 21:56:26 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5c2631basm129395475ad.34.2026.05.17.21.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 21:56:25 -0700 (PDT)
Date: Mon, 18 May 2026 12:56:22 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, jiangyiwen <jiangyiwen@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ocfs2: kill osb->system_file_mutex lock
Message-ID: <agqbeO8Ykf6ntxNX@c73>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
 <agc8kA2wxC_7091p@c73>
 <ageuwl9o3nzktMrz@c73>
 <fb0685c4-bcee-4c7b-8ac4-a1af702b8600@I-love.SAKURA.ne.jp>
 <aghfx-XhwoE4fBYR@c73>
 <670882aa-b637-4565-adf0-ddcd9d7a588b@I-love.SAKURA.ne.jp>
 <agp0sACmJl3tePyr@c73>
 <fea8d1fd-afb0-4302-a560-c202e2ef7afd@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fea8d1fd-afb0-4302-a560-c202e2ef7afd@I-love.SAKURA.ne.jp>

On Mon, May 18, 2026 at 01:23:40PM +0900, Tetsuo Handa wrote:
> Commit 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding
> mutex lock") tried to avoid a refcount leak caused by allowing multiple
> threads to call igrab(inode). But addition of osb->system_file_mutex made
> locking dependency complicated and is causing lockdep to warn about
> possibility of AB-BA deadlock.
> 
> Since _ocfs2_get_system_file_inode() returns the same inode for the same
> input arguments, we don't need to serialize _ocfs2_get_system_file_inode().
> What we need to make sure is that igrab(inode) is called for only once().
> Therefore, replace osb->system_file_mutex with cmpxchg()-based locking.
> 
> Fixes: 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding mutex lock")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

LGTM. Thanks for the patch.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
> Changes in v2:
>   Updated patch description.
> 
>  fs/ocfs2/ocfs2.h   | 2 --
>  fs/ocfs2/super.c   | 2 --
>  fs/ocfs2/sysfile.c | 9 +++------
>  3 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 7b50e03dfa66..62cad6522c7a 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -494,8 +494,6 @@ struct ocfs2_super
>  	struct rb_root	osb_rf_lock_tree;
>  	struct ocfs2_refcount_tree *osb_ref_tree_lru;
>  
> -	struct mutex system_file_mutex;
> -
>  	/*
>  	 * OCFS2 needs to schedule several different types of work which
>  	 * require cluster locking, disk I/O, recovery waits, etc. Since these
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index b875f01c9756..6dd45c2153f8 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1997,8 +1997,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	spin_lock_init(&osb->osb_xattr_lock);
>  	ocfs2_init_steal_slots(osb);
>  
> -	mutex_init(&osb->system_file_mutex);
> -
>  	atomic_set(&osb->alloc_stats.moves, 0);
>  	atomic_set(&osb->alloc_stats.local_data, 0);
>  	atomic_set(&osb->alloc_stats.bitmap_data, 0);
> diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
> index d53a6cc866be..67e492f4b828 100644
> --- a/fs/ocfs2/sysfile.c
> +++ b/fs/ocfs2/sysfile.c
> @@ -98,11 +98,9 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>  	} else
>  		arr = get_local_system_inode(osb, type, slot);
>  
> -	mutex_lock(&osb->system_file_mutex);
>  	if (arr && ((inode = *arr) != NULL)) {
>  		/* get a ref in addition to the array ref */
>  		inode = igrab(inode);
> -		mutex_unlock(&osb->system_file_mutex);
>  		BUG_ON(!inode);
>  
>  		return inode;
> @@ -112,11 +110,10 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>  	inode = _ocfs2_get_system_file_inode(osb, type, slot);
>  
>  	/* add one more if putting into array for first time */
> -	if (arr && inode) {
> -		*arr = igrab(inode);
> -		BUG_ON(!*arr);
> +	if (inode && arr && !*arr && !cmpxchg(&(*arr), NULL, inode)) {
> +		inode = igrab(inode);
> +		BUG_ON(!inode);
>  	}
> -	mutex_unlock(&osb->system_file_mutex);
>  	return inode;
>  }
>  
> -- 
> 2.54.0
> 
> 
