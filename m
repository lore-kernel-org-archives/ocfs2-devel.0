Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB412E11A6
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 02:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761877820; cv=none; b=J8a5W661iAQPOZg1D7pcF0nKinO+ZEs4nGgZc6JfPhS8N0siSqb3mGNSEwlFH+V7vFf+gQKcfM9N13VkL6s4KcQxbTtddhqiVPvP6L2/Tvlb4pBdbzCUplriVCbcKBhNj5Lz18rd0MvF1xm2zgHAbFpNoBDPaOOgyzujkj1SnTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761877820; c=relaxed/simple;
	bh=yrxKixVojpbluBisYu0EAkFCmy3swUxaiKLewdtDk78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WQaj8Gfx3dH43QvxH/wCIAlCnu8JQgUaXdt687dD7+kXhRcMjcWtf3ToTqRB9ApwRgp64GrIz7SGCrpmdX8Eo5n+aqCs7qzI3N7mJTOe+V0E1cYCAf0m5ii7YmceGQ19PJlfxQbgZG4QokTphVj3L5yv29gMy1Ht3RINVqRHCeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d27s5kHI; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d27s5kHI"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-429bee84e7eso49784f8f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 19:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761877805; x=1762482605; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s70uKhnFnCqxMqoMAQZ8ZdV7WdC7wWM/IA4PJPlpz1o=;
        b=d27s5kHI9aA8ZBZwD4KF3fAlAKgu+2GpKWNtrgZVFUcNL87F6x487V4VqxPaXMC+Be
         Bnfa7po+7w1ZGvHnW63eL6q1LGFY1CXmuxGVTUFM7oVB3hOOGmesgcHPmfS85Ex0OarQ
         AEmVveG+PQ6KVnqlpQNV61rxo/NdKxKF9rzEQIjJ1K6FP0lwXlGfGEqtflOwUn626ACQ
         /uLMJECAmy04vcrYCDwm5vGgkrCGv7ay/rljMwVk7uXzhZFBr319UkFMLJciWw7QMh1I
         8C67WH15ZMNRPhLkuBL9BEry/GG2M1mlV7gYCC2D1FEGK1e1QMamLhCWocGtT1S4drXY
         EGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761877805; x=1762482605;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s70uKhnFnCqxMqoMAQZ8ZdV7WdC7wWM/IA4PJPlpz1o=;
        b=Yytr9vWLZKwED/lXzwZ2awUyLn62TjcnPiSLYFkVAqmJzfCqeLQZ9uYZwMUO29dlzr
         v50DCKcx7MRidRZUoOD1CdzQkx22DGHrLuwsTNoxW+Shg6DE5x5irkUa75q5+Ri5GzT+
         jQUckuq+BWUWDzuQHHkkoabwEpXECw3Mt+O43urpnyl+5YEF1DzOUP0FQLE1Jq5MhPpY
         mErepiepbBvboolptI4QqrlEXh/zygHCNzRbjMHlfdM32QbCOOdwysir1+tHBMFhsYO4
         T9H8B1znTpFiUPbcmGrBeDeMWxxLYWMRLO1c5ikC3tUa3gAGH24Xf68M0ICARXYxVA44
         v4kg==
X-Forwarded-Encrypted: i=1; AJvYcCWxu1qWoxyvUczqSpbq/hGZEPjv4SVljMOIXR9CFYszFISe8vFFt3Qr8xwAW3VC5pOKe6Tu2O4BlAe4tQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwWqUT0CXdwLa96xsN84jqqrwVvbHnkKB1bZ0+6DKoqzWugGgY7
	0TydMWAsE/t1ap/bKEVF0XB8K7+3Thy8cey81+gbC1hOXvA0xLY+mIFKtHUJO1ZfWyc=
X-Gm-Gg: ASbGncssSGFzktjLspZKfgZmVnU+98gUa9DzdzGUN7alEsUwQDJ5pp+42UVLFX5Y9m9
	c+x5fUJMLlSbwn9sIhLx5Q2zh2WhbqoYgr0iGVCmZfXDLXSaS0uxAWxYqyvrXyJw4JIBp/LbtFL
	zmli7Y4YB0ZuhLY2jYrW5hhbCiaFekKHLXylhtQFcgldVjbPSpcyyPfhaiM527n9bfJRumBN2ML
	Q4CwjtnGY6iU4GOUHDUm3p31Tb2lMtuG7S8/MUP07LQaUNyVzAaxxeFMhBj+Temce4rn9WVPzzQ
	01bLaDDICEQ9TDh7wLsSe8i+OLPzOdELVNoGCyZmycOWIQJavW+wfj1QOJMOlO+Rr+58SL3O23c
	Z2xVSG7JFfwAarorc6oaszYV8DiQW8aA5ZM5ysgtiA2opUlV11vBXvdpok4Lnf7HuPOIeLyDNZe
	E=
X-Google-Smtp-Source: AGHT+IED8Spg75WLEwDjYgLgNpdvHfKONetNjswzCY8ahrupW6jvolIdByK8SLvyz9YbHnzsZdhrdw==
X-Received: by 2002:a05:6000:2c0b:b0:3ed:e1d8:bd7c with SMTP id ffacd0b85a97d-429bd67c441mr683707f8f.2.1761877804602;
        Thu, 30 Oct 2025 19:30:04 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b93f1d8f1desm214555a12.2.2025.10.30.19.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 19:30:04 -0700 (PDT)
Date: Fri, 31 Oct 2025 10:30:01 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com, 
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure
 during read
Message-ID: <qfizhbe5rwzddwnoekr6xjy3gozbqbtl64c5xmfeuudxvficmv@onazesxv4ur6>
References: <20251029225748.11361-2-eraykrdg1@gmail.com>
 <wzykonhpj76qowdn24inwtaji4zfclesmc3lqnnc7cn6jkyjl4@oauagnarupov>
 <CAHxJ8O_7-PfJRyGp9-1KOkwmYJWQDzCvvo_P-jxzbzHoqXyH9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHxJ8O_7-PfJRyGp9-1KOkwmYJWQDzCvvo_P-jxzbzHoqXyH9Q@mail.gmail.com>

On Fri, Oct 31, 2025 at 01:07:56AM +0300, Ahmet Eray Karadag wrote:
> Hi Heming,
> 
> Thanks a lot for the review and comments.
> 
> Regarding the placement of make_bad_inode(), our patch places it in
> ocfs2_read_inode_block_full() because
> ocfs2_validate_inode_block() itself doesn't have access
> to the inode object. I believe this (in the caller) is the
> correct layer, as it seems to match other patterns in OCFS2
> where the caller handles the make_bad_inode upon validation
> failure.

Thanks for pointing that out. I agree with the above comments.
> 
> I had one question about your proposal to combine this patch with
> Albin's [1]. When you mentioned, "We should forbid any write
> operations," were you referring to Albin's read-only check in
> ocfs2_setattr as the mechanism to "forbid" the operation? Or
> were you suggesting we should use the inode size sanity check
> itself (e.g., by converting the BUG_ON to an -EIO return)
> as that mechanism?
> 
> Thanks,
> Eray

The 'forbid' refers to the read-only check in ocfs2_setattr.
We can refer to ext4_setattr(), which calls ext4_emergency_state()
to forbid write operations.

- Heming
> 
> Heming Zhao <heming.zhao@suse.com>, 30 Eki 2025 Per, 10:59 tarihinde şunu yazdı:
> >
> > Hi,
> >
> > In my view, combining this patch and another patch [1] is a complete
> > solution for this bug.
> >
> > According to the oops stack, the FS is already in read-only mode.
> > We should forbid any write operations and then perform the inode
> > sanity check.
> >
> > And I think ocfs2_validate_inode_block is a good place for make_bad_inode().
> >
> > [1]:
> > https://syzkaller.appspot.com/text?tag=Patch&x=1287f614580000
> > - by albinbabuvarghese20@gmail.com from:
> >   https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
> >
> > Thanks,
> > Heming
> >
> > On Thu, Oct 30, 2025 at 01:57:49AM +0300, Ahmet Eray Karadag wrote:
> > > Potentially triggered by sequences like buffered writes followed by
> > > open(O_DIRECT), can result in an invalid on-disk inode block
> > > (e.g., bad signature). OCFS2 detects this corruption when reading the
> > > inode block via ocfs2_validate_inode_block(), logs "Invalid dinode",
> > > and often switches the filesystem to read-only mode.
> > >
> > > Currently, the function reading the inode block (ocfs2_read_inode_block_full())
> > > fails to call make_bad_inode() upon detecting the validation error.
> > > Because the in-memory inode is not marked bad, subsequent operations
> > > (like ftruncate) proceed erroneously. They eventually reach code
> > > (e.g., ocfs2_truncate_file()) that compares the inconsistent
> > > in-memory size (38639) against the invalid/stale on-disk size (0), leading
> > > to kernel crashes via BUG_ON.
> > >
> > > Fix this by calling make_bad_inode(inode) within the error handling path of
> > > ocfs2_read_inode_block_full() immediately after a block read or validation
> > > error occurs. This ensures VFS is properly notified about the
> > > corrupt inode at the point of detection. Marking the inode bad  allows VFS
> > > to correctly fail subsequent operations targeting this inode early,
> > > preventing kernel panics caused by operating on known inconsistent inode states.
> > >
> > > [RFC]: While this patch prevents the kernel crash triggered by the reproducer,
> > > feedback is requested on whether ocfs2_read_inode_block_full() is the most
> > > appropriate layer to call make_bad_inode(). Should this check perhaps reside
> > > within the caller or should the error propagation be handled differently?:
> > > Input on the best practice for handling this specific VFS inconsistency
> > > within OCFS2 would be appreciated.
> > >
> > > Reported-by: syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
> > > Link: https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
> > > Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > > Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > > Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> > > ---
> > >  fs/ocfs2/inode.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > > index fcc89856ab95..415ad29ec758 100644
> > > --- a/fs/ocfs2/inode.c
> > > +++ b/fs/ocfs2/inode.c
> > > @@ -1690,6 +1690,8 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
> > >       rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
> > >                              1, &tmp, flags, ocfs2_validate_inode_block);
> > >
> > > +     if (rc < 0)
> > > +             make_bad_inode(inode);
> > >       /* If ocfs2_read_blocks() got us a new bh, pass it up. */
> > >       if (!rc && !*bh)
> > >               *bh = tmp;
> > > --
> > > 2.43.0
> > >
> > >
