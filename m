Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D792EA490
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 02:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761789630; cv=none; b=UqbqhiX50Q1/q3MrcOpRlQHimSc5FFIwE2vgbUKr0C/hmY6bqs6ovK1T+jx2DBH5yul7H6m84DdUQ0MMX0LdK8LW3HXiBRije34TJUz8QVLszORpkUjYu/qZK0Wotl4+QNqLBk1t+d+9x8qKMpex/FQ8X2aM6v3n6sNx9iFSViw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761789630; c=relaxed/simple;
	bh=p8SnwxjnSqG12IWBiMP+CsQrAGNYeJ10QkGddZr29vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHAINLvRb2/DUDStxSz/CLwjN+xlB2RTdbLhJQWYUHgSvrPBvGiwqpyW40aC0xqVkTEeZJmP1dCJ6fE3ecrNkD9ACXyIcgo+WFoOJQeNks64c2JIQ3h4hj7HmbFKr1WPJ8S5M8gOtu3O6E8okJFt5jhixyZzfTPJxOyNJ5YHqU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dPJBclji; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dPJBclji"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4271234b49cso46153f8f.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 19:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761789626; x=1762394426; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vucS6q8pjRYP+Smpk7q52J/WPrFOwHMjXlUQhVpPGJU=;
        b=dPJBcljib1alJWq9fwOyP4nqUA5KD+9A/W0UPXQDgRGCOXJtX+BHuB2SFM1Z1fKFBA
         d7eRc1G9NAJDs31cQyMZ1+sZPvrQolMZJsRqk0l/tP/h8wT/kg+kSEJggMP/4tAciFV0
         83YoBdaEIie3eY4Z3hrf4FrlVfG4ibS8g3w/M717GW9zteRF5oSLqy3ZuzFa1bmnsORp
         tY6HGCiJNCccHmQw6ysrLTSEJeJMtmEb3EzEUhRDqeDV1HKo0yNHAhL0T7Ej7cmwtr7Y
         jXLA8Lbe+6MfteOAp7qAyKuJwzx3Wi4942yChANh0w7XIxY4bDxNRDiq5Oi1IA2o3dSi
         zQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761789626; x=1762394426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vucS6q8pjRYP+Smpk7q52J/WPrFOwHMjXlUQhVpPGJU=;
        b=JZLOCQECPb2oJXZ4KNcMF8MKn/MCe8vufBx80kP+UQr/c++oA5sB6a2NXjnjmaO0dR
         GaC5YiN8CtHCd0f7LpyyuP5xgC1vkUy2njNdOmSGKzGzPuGcXItXA05tSfTtV/Gfhsv7
         yez7B3jn1Nk7bTRr9febTDOO1Nn4SzJmozFm7SgzZFm6x2Zx77zJcUfXwdP1SdKk+lTm
         TSLZdyvXbAPaVf8Le9B9mShmHjVtDP4bIgVBA1tyFetyyyQClrBz+ok7oSYz8/Tt3A0s
         37RrHFp9WEg5qXeJ/l3r+m57OBHScqPTnQlkzc/B2VNL/SzJkJOKVweytIREYuQxvhw6
         ivOw==
X-Forwarded-Encrypted: i=1; AJvYcCWkujUMXPTyKdUxeRMNXy/aKXog+Y6xxbZzUa+G+vY/di6AyMyz/F8FOoatvkr+tgtRCnTrOVFDMJfJTg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxGLf87ARhSBVrs6wihYlCh+NJGKsVw0dOzB8KMuOvHonOIGtF6
	i+2cuExfCUxWO0M1dRqDcsWuHmBeNCrqTHZzA7QyjOKlot/HdheVIcsXhawjny0JRN4=
X-Gm-Gg: ASbGncsjslyuP7u0o7N/u2by7VCP7siR5auQ64+BoOiikYP+rTDe6Hdi4QFQdZzJeMv
	8a9449i2wtzkptDaqxJu4piAJTCHSt/R0tYiKBGu4vtB/l8YTsLMiBuBEmTvLCRvcQOfEtOgKcH
	KBX8ERpLCm8Y8yVy2qRdc+3kCL5WMhjRHHwdfKTd/j51S32W4916BNaugOeniIYkCW44pD4z2Ow
	GcZbCrEdz73DCF6DEc832iDEPeXdgT69JhlZl5Mkux2mGcWHblFXvERfTZPEcQU6ZBneFab4HUh
	scwH4fPmK4UXaugwq38SPQZ01lf7bLUHkxqTfPzAjc0pdD14y76UBqiLNAkuDeJYVT8aDqBbN1o
	c6gB7+Gl2LGmfiUfWIrFphCM18A3b0qU0E+70R0dh6wjkoWkr2iNolagAbWl6kFekto+jq+gRgi
	A=
X-Google-Smtp-Source: AGHT+IHb+riyegmF+uDPixQSC6DtkQkoI1JoD8L8JboZ+Lt5y5KhfTqtTlNhw88qHy/6/Jou1sjOCg==
X-Received: by 2002:a05:600c:4450:b0:46e:6778:c631 with SMTP id 5b1f17b1804b1-4771e11b889mr25677385e9.0.1761789625575;
        Wed, 29 Oct 2025 19:00:25 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d0c6eesm166565185ad.42.2025.10.29.19.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 19:00:25 -0700 (PDT)
Date: Thu, 30 Oct 2025 10:00:22 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Deepanshu Kartikey <kartikey406@gmail.com>, akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to
 prevent divide-by-zero
Message-ID: <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
 <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
 <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>

On Wed, Oct 29, 2025 at 05:25:03PM +0300, Dmitry Antipov wrote:
> On 10/29/25 12:53 PM, Joseph Qi wrote:
> 
> > On 2025/10/29 13:53, Dmitry Antipov wrote:
> > > From: Deepanshu Kartikey <kartikey406@gmail.com>
> > > 
> > > The chain allocator field cl_bpc (blocks per cluster) is read from disk
> > > and used in division operations without validation. A corrupted filesystem
> > > image with cl_bpc=0 causes a divide-by-zero crash in the kernel:
> > > 
> > >    divide error: 0000 [#1] PREEMPT SMP KASAN
> > >    RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
> > >    RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
> > >    Call Trace:
> > >     ocfs2_block_group_alloc+0x7e9/0x1330 fs/ocfs2/suballoc.c:703
> > >     ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
> > >     ocfs2_reserve_new_inode+0x4f4/0xcc0 fs/ocfs2/suballoc.c:1074
> > >     ocfs2_mknod+0x83c/0x2050 fs/ocfs2/namei.c:306
> > > 
> > > This patch adds validation in ocfs2_validate_inode_block() to ensure cl_bpc
> > > matches the expected value calculated from the superblock's cluster size
> > > and block size for chain allocator inodes (identified by OCFS2_CHAIN_FL).
> > > 
> > > Moving the validation to inode validation time (rather than allocation time)
> > > has several benefits:
> > > - Validates once when the inode is read, rather than on every allocation
> > > - Protects all code paths that use cl_bpc (allocation, resize, etc.)
> > > - Follows the existing pattern of inode validation in OCFS2
> > > - Centralizes validation logic
> > > 
> > > The validation catches both:
> > > - Zero values that cause divide-by-zero crashes
> > > - Non-zero but incorrect values indicating filesystem corruption or
> > >    mismatched filesystem geometry
> > > 
> > > With this fix, mounting a corrupted filesystem produces:
> > > 
> > >    OCFS2: ERROR (device loop0): ocfs2_validate_inode_block: Inode 74
> > >           has corrupted cl_bpc: ondisk=0 expected=16
> > > 
> > > instead of a kernel crash.
> > > 
> > > Link: https://lore.kernel.org/ocfs2-devel/20251026132625.12348-1-kartikey406@gmail.com/T/#u [v1]
> > > Link: https://lore.kernel.org/all/20251027124131.10002-1-kartikey406@gmail.com/T/ [v2]
> > > Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
> > > Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
> > > Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> > > [dmantipov: combine into the series and tweak
> > >   the message to fit the commonly used style]
> > > Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> > 
> > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > > ---
> > >   fs/ocfs2/inode.c | 8 ++++++++
> > >   1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > > index 1b6bdd9d7755..efb930da0920 100644
> > > --- a/fs/ocfs2/inode.c
> > > +++ b/fs/ocfs2/inode.c

The cl->cl_bpc field represents "bits per cluster". This means:
- for a 4k (min size) cluster block, cl_bpc is 12
- for a 8k, cl_bpc is 13
- for a 16k, cl_bpc is 14

The OCFS2_SB(sb)->s_clustersize_bits is the same value as cl_bpc.
Its values are 4k:12, 8k:13 and 16k:14

> > > @@ -1505,6 +1505,8 @@ int ocfs2_validate_inode_block(struct super_block *sb,
> > >   	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
> > >   		struct ocfs2_chain_list *cl = &di->id2.i_chain;
> > > +		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
> > > +				sb->s_blocksize_bits);

The meaning of above line is "bits shift from block to cluster".
Not "bits per cluster"

> > >   		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
> > >   			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
> > > @@ -1518,6 +1520,12 @@ int ocfs2_validate_inode_block(struct super_block *sb,
> > >   					 le16_to_cpu(cl->cl_next_free_rec));
> > >   			goto bail;
> > >   		}
> > > +		if (le16_to_cpu(cl->cl_bpc) != bpc) {
> > > +			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
> > > +					 (unsigned long long)bh->b_blocknr,
> > > +					 le16_to_cpu(cl->cl_bpc));
> > > +			goto bail;
> > > +		}
> > >   	}
> > >   	rc = 0;
> 
> Oops. This seems prevents from mounting filesystems with any block size except 4k
> (mkfs.ocfs2 -b 512, mkfs.ocfs2 -b 1024, mkfs.ocfs2 -b 2048) with the following message:
> 
> OCFS2: ERROR (device sdb): int ocfs2_validate_inode_block(struct super_block *, struct buffer_head *): Invalid dinode 23: bits per cluster 1
> 
> Dmitry
>

The value of cl_bpc is an intentionally crafted value designed by syzbot

under bsize:4k csice:4k, the patch code:
 "1 << (OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits)"
 => "1 << (14 - 14)" => "1 << 0" => 1 (just same as cl->cl_bpc)

The values are the same, but it's logically meaningless 

Based purely on code logic, the original patch code:
 if (le16_to_cpu(cl->cl_bpc) != bpc)
should be changed to:
 if (le16_to_cpu(cl->cl_bpc) != OCFS2_SB(sb)->s_clustersize_bits)
 (and remove the line: u16 bpc = ...)

- Heming
