Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B53E341AC7
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 07:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780299771; cv=none; b=JiWdjsqAYE3KQsiMxfz0s8m6JlK63jaAT23+YWJmoP+z3yJilnTl5yuVtZfzsdK64sBFYpW2nE0uTKfJ/M5d3Dm6xuKLPhK/fUJQkF8osf72zLT5Ut0+Nv85M3r8fFvouX54Efa3NH980Fr2QhQP8UJxkRGbOTqs9tTtUyka+9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780299771; c=relaxed/simple;
	bh=MQlkpCXOfkFXYHn5hTfIkSda3DcbkmRlTIqP2zAegBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bswfrw/q9wYVeNqYcI3wimBY03D+1A5QXsBVNTQpNYbKK3of1Fg92QZYsRYlhEl+zaWHJPxCnRZKbiXD/7jHhc0vOJ+X6okS8vqVEs1RF3OOOMmsU9T8WzZNB7YMfjrZ0sNmbp3WvxWgKKy0xEnk7uiwcTbmGVeaxS10OVM45Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CTs10Pxj; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CTs10Pxj"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-68d05f6b3cbso214602a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Jun 2026 00:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780299767; x=1780904567; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1IusEb6RLqw9/UYNFngRbqN9yEMuGucdhl2O7Tgx7HU=;
        b=CTs10PxjcUal8/fgEtk212k8R6EtBAX0o08+EB8QaTi16IMwqyqC0oPqIwhOJ+PJR1
         FpMhrMTE2lT3O5hMfWdQj1A49XKR2oGi2vkF/Wsii2ra0gNCxzkHED0J3rEm5po7oZ13
         BzRPlzWhIzDVutT/4O8VvMAOhN44ga5+khY4TdjZS0iek4jCOpT5YyoZh5XDGniG0Ta0
         Yb795MftoiB3CP2NUVdvP/PG1N2beQY/Mfyxm1z0Jozru6nTLhG3qPxtHEJXFBOqKO1R
         8510ui+N/fQKAgdGfoH+uCJWm2uxq+UmcxsDLK2RzNDFK8Y/cOvwMmA8mGeRo/UXz5KX
         6/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780299767; x=1780904567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1IusEb6RLqw9/UYNFngRbqN9yEMuGucdhl2O7Tgx7HU=;
        b=i59qjcsoiGfmDDj9cfO0riLvDXIDdY79qeMDTOY844WTWrMoBz67+RMeaUZh/ymzoc
         Qpre7sezf+zzRr897pGft13PHsO05gIYLT00NGNPrxfQAp3Z9UJvx8XyalQC8HUfZYEv
         uOAGDJGtxNJz0U7lUNEpRJLjpVO/w9oFgNk8mFgwtltSyJLtyD+ycHBEHGtKD7ErdQW/
         a0qzk2xv8XtCVz7I0xAGS7xR5M72Xcxt44LolSk5hZuBjFTyCiQ40jT0JH3mT32EbFYI
         mJN83R0ltXylB5RnaKnMOb2iR6cXZNUeCZDSjYDY1/otlfUy53z4q1C+DTD+mZGsCz4V
         bJ3A==
X-Forwarded-Encrypted: i=1; AFNElJ9ZNGS1SOOmtbq92GyXI9//qLYB/Rngbsc6VYNm8gIukhhNIi6TMKykJsK4kUmcIEKC/ur5sq3dObrhYQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+7xDdSeT6EMPUt4ak8HsKKl84B0qxFdpGtjoBm12qc5jbiLA7
	mqezMFivHVZh4lwi33cGQHsjXTNAi27VKOvOT+aKjcLvKq/NLZ1y9fd0E8jCmhuHhq8=
X-Gm-Gg: Acq92OFUUjiAE/26dKfhBZWaL5cvXuFYj/lN9G6V87ILbnNKfuT9S9R2OupsZLaHK2x
	LzbzgR/C/8LJnzLwlsPweMxI0l2sF4gBd/uZz7wKi+y6y4BEMbrdBjYPiv6Q6HBg8E9w8Q6Fzqb
	D43emlL0Bkk+J44Kyta7+FbxMvZkAsu33uQ+dnHQxWiUYP/IaRFtxtutgBaD8BYBnrsGrWkmZQY
	6M1gPB8hdJexnHVuMA0fwKFhFUPBrEDYmXIHYpx9g+sXLYdneKtTWOaff8FAdgYHsZmYX7IFRXX
	MCkbHLqBZlqdX9M/1UjV0GyHtxS94Ef8xQ9B/0U4gTu+0q7lDDHCljYA6hbPFvtY56HolqnZmDP
	PLgnsRekfF0tmwzWROY9wA8kTIrEOF3QDD3oV1bwL1my/W3QD2vs2Z5wO2Adwszt0k/ttDDoBD3
	jEn+B80FSXPTRYAUtvj2wD0ueYECjzfBVI
X-Received: by 2002:a17:907:da15:b0:bce:9695:ff63 with SMTP id a640c23a62f3a-beab265be90mr228282366b.6.1780299767377;
        Mon, 01 Jun 2026 00:42:47 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842269d68c5sm7025739b3a.27.2026.06.01.00.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 00:42:46 -0700 (PDT)
Date: Mon, 1 Jun 2026 15:42:44 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Farhad Alemi <farhad.alemi@berkeley.edu>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
Message-ID: <ah03yKJAuczk5LDG@p15>
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

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

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
>  	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
>  		/* WARNING: This only kicks off a single
>  		 * checkpoint. If someone races you and adds more
> -- 
> 2.39.3
> 
