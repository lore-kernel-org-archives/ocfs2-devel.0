Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E92238D52
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 03:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780284749; cv=none; b=kKLbKMb4F8WkGSYPa6XIsEt6UIHQmgGaW31oPZBLhqN9RYYCY2fkWk8oWHBc7iuxtZtf+HTzW6SDs0a7kdacY2sIqNLzz7LM69rZWbyZeegE1jm3fb6dnWsO35XAOV3L8kqVmpPtwnEIS1oxQNFGcmzaFm8ZORZz/b5TZg5q0gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780284749; c=relaxed/simple;
	bh=Ez4+pddAX91CJpxsPk8EVjvdomZKOM/Oayp8GRL1x5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ma0meS/0bBAYl9pOVJ/m6tOsmxqUCjkaPgIStwNql3eyAvoQFIYWCs7lp4KgevjEpUJqOOhmrUw+iOn2X8z/XiHRGhMeNA6/1tYEklz0n+LUigGZZZXK39hykktHjGOvPkS1xta12pCycJKZzCzt9rdqjxaA/1sSsA5AtjYf2uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RfDa0kVK; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RfDa0kVK"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45ef4332d89so130641f8f.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 31 May 2026 20:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780284745; x=1780889545; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SAGjCkfmtz6WXqXlINsXqWBTT+9LX3eW3SU/43Z592s=;
        b=RfDa0kVKCClxxiZfS7GrfPCjk/eP4rl9+SfHRizNqI0ZzYB11rXCUYFWMPu4m5WIlo
         lhQSUhxsOufafImcdQJnbqLE3NJWMwHZ0pM3HGPC0JVBe2t96fNCT0dcCK6bYXGobXPH
         SVNsqCvZ3wAjaRgORNVFWIaOYrvHreRlMAToaHqQOkhFvFoZacrzMFvacAXK952cvi3U
         9JVRYQGwG8JlNYT535ixjlrg0VAM4O3JSaaQB1jRhiYBm90kxTQtuUHUJkJAu4zYehl1
         E5JOe8bBeUoFK9DHtKYCVKo8XM/1iqZAVvks2q0F7zcvjUUYOZnqs3jkp/818REC3v+q
         1eiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780284745; x=1780889545;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAGjCkfmtz6WXqXlINsXqWBTT+9LX3eW3SU/43Z592s=;
        b=YKpJu5Ky4NjFNgh8l+ETP+7UYGEOFZcH1Pc+FVimU3/JaeZl2PNOyIuO+jKDtl974y
         9FoixM4hxU0sVQpJmxQ6AxFzzLxSJ2Uu/sHeWWxsEBXt06vUp5W6lThvFtRyGgkPiEhZ
         K/kyuSdSUGep3hG2XVSlga37OXv82AJowgNJN+UQ1t30t0EesweM4renmMbF1qB2mpiC
         xwKldoUuTA/GZkJyjOp5kWLxZd+pqV1Ib77Yg5vdDpNJRMwhQcoyZTIyfo1/hxa0KFRO
         j1qxAzokJyw/0Lu0ke29fBZHyBF52FTYscbTb32yA/jGDPzl4+AAxhy+U3O8gP/icWpM
         e1Lg==
X-Forwarded-Encrypted: i=1; AFNElJ+9g88f4l6rT452puC6CIPuGhDuDRC4KNl+5XX6b8xHShxOHU6uD1i2nMHhrGbrXDAEmooulKpSHly3uw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzdsQBnJlHLIpnw8H0pvBxyUkQPbWW87RCUJUqZcigZAehUYvAU
	2NwgGNvj2iOP2EcAn9Q+fpSn4T320HjQ8Ytji/pCx0ppjr0FzNmw34AELLy7PmI4ps4=
X-Gm-Gg: Acq92OFD0FdDoZb4xZDQXqNZetu0KoNqd/uwObV8eRj9HxVfdO7QLfbUbgm1L8XukAE
	7B7PbSLHO8/opAaTAI2RShtLk7SDtvFMrbekHoa0SlWqH0P7IyaHpl9dSJQTrsvLYhMgUe1gzJ/
	r8STYIb8RXA0HHzz0xH5vbuuPahDUdo98Va1t8S2sNfuyho7lIxcGtKIBhOB8X2suX8dX4s0SHq
	iRElUNvK6lma98LVMOz4fLQLgRuTI76F4B1NEmDRSlMhsfQomhoywQdzo71goIx8Uxjdydi4aWp
	CupIXl/hGcWJr7hmqF7CxysjmyCuk25KNsJvC2gpz5P1r7gGEz/II+6YUZu7fWL4m/4ABWnAb2E
	l49r10kB4bF+q3KYBku2UEISh0vr29q7J3ckqUkl5ef3wC+F/HCQ7BwHFyY3/GTd16cTdPOqS5i
	1/mm8toI6WANDe2f6o6QrcEDO5WU8KBLPp
X-Received: by 2002:a05:600c:4f8e:b0:490:3fdd:d344 with SMTP id 5b1f17b1804b1-490a2910990mr65570835e9.1.1780284745146;
        Sun, 31 May 2026 20:32:25 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bbdcd0a2dsm5345843a91.2.2026.05.31.20.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 20:32:24 -0700 (PDT)
Date: Mon, 1 Jun 2026 11:32:21 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Farhad Alemi <farhad.alemi@berkeley.edu>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
Message-ID: <ahz8oSUC5GXrJM_b@p15>
References: <20260531131645.3650299-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531131645.3650299-1-joseph.qi@linux.alibaba.com>

On Sun, May 31, 2026 at 09:16:45PM +0800, Joseph Qi wrote:
> During unmount, ocfs2_journal_shutdown() frees the journal and sets
> osb->journal to NULL. Later, when VFS evicts remaining cached inodes,
> ocfs2_evict_inode() -> ocfs2_clear_inode() -> ocfs2_checkpoint_inode()
> -> ocfs2_ci_fully_checkpointed() dereferences osb->journal, causing a
> NULL pointer dereference.
> 
> Fix this by adding a NULL check for osb->journal in
> ocfs2_checkpoint_inode(). If the journal is NULL, it has already been
> fully flushed and destroyed during shutdown, so there is nothing to
> checkpoint.
> 
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Tested-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> ---
>  fs/ocfs2/journal.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 6397170f302f..f8b3b2a3d630 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -196,6 +196,9 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
>  	if (ocfs2_mount_local(osb))
>  		return;
>  
> +	if (!osb->journal)
> +		return;
> +

In my view, the code is correct for this bug.
However, the if condition is insufficient if ocfs2_journal_shutdown() sets
"journal = NULL" immediately after this line.

Thanks,
Heming
>  	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
>  		/* WARNING: This only kicks off a single
>  		 * checkpoint. If someone races you and adds more
> -- 
> 2.39.3
> 
