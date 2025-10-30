Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBF8329C4D
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 02:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761791561; cv=none; b=CDP1ky5jwtNj5MqooRmH/DZNdE4XpuLanrnyjpH7iOBohNTmBcp4C02Rjgv9/0yQtqJUXfihCxJAfSX3WMjcyaFFNZs/m2eriZiANENz5F4p09X/6qHpVmwBxd6pjLqdFz1S7nTP9b6f7qYlUdDLkMmQNSypLKKiw/oWb2mERg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761791561; c=relaxed/simple;
	bh=dKPc08mtYnpM/cgEWmK/Qkufk4Y80zwbBm7xORBT5Ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnDi6vsNIXAiwFLO6v7lSU09ZWu6U3OgMHNT3w05ib52wZfQB8qBC9/q5QmaGJmfW8IjbcopnvlwXQgKoPxJsG35EKpgeexYa9XmfYIb160H12fsbcHCx/G8VLdCjLl48TJ8va+dV3M5WNae3NcESJSF2PlV5M7zv32ChV+K+Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ULQZ2KA6; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ULQZ2KA6"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-429b3c7725bso50617f8f.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 19:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761791555; x=1762396355; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N8bMeEVaPwo80WgjembpiQsvLscz7tQiFKpxD4La4t8=;
        b=ULQZ2KA6fRiuVM4M/mGGrUbNuot1NQT2+BzSquVG6XJ/QCWSmErX7QUvgjP4vKNsJ/
         TgoeA7XHz+9wrlSbF7lXSOdye8UbmjUXB1CW8dSAKuJO3CMTv8bxT+8Ob6VTPEegolBs
         amBpLyhDLt4krrISAyt4vy1uV3UfcuFsT5RdqdJUBB5QrOeEX+p5cMUPpQ/WInXz5pk8
         ot9h2QEMXJjJYv6Qmy5SQYdkqG0hWkWo9A/jbnhytbDcYazr0HlSO9YDTU/R6WdCBQqm
         5GhxWAbeQwPQbEMFBkIIff98o3m1tXrmzhacopqkDp675aFvWJbeaLAZYt1vyDvr4vSZ
         AyHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761791555; x=1762396355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8bMeEVaPwo80WgjembpiQsvLscz7tQiFKpxD4La4t8=;
        b=Kw07AZkipCnFT6cK5sFo6JwJnWMiAFg43iyNCDVygGX1tIE/C5CqhmcfOaxHMX7uro
         YRTr6sEitcsUExZfnUSHoi4UgVF7vYVZr0sxLWSco81vswRthoYxk06otdytqVUGjuKu
         FvDqIHuWtmd6GROY/qCB15nlOV8lr2hDH4VIOrgxi9sOzPEr1g44NnIfFJ0kxiwpzjWn
         uY0vA2NSQdEEvIg2qPE24XEGIpvGg1n9L4EnRZWmlomcfAbXPB+IEWRuVvX0DrqHpGK4
         ap+m3VO1708OwWQZXNcElb+xYXvpT1okyO330SXB7xAqsreL5o3m8R5nJQ3lvQHjVNTR
         g/2A==
X-Forwarded-Encrypted: i=1; AJvYcCUL3BR+5zL9DYhcDMTlIosnJpSk9JQgWzTQ+9M9fsoNTLVtSGORHiuZMyU9Nq4I2Yc7b0BZgBNK8SVTLQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyn4iA3qPwgcANdTMMhTfmCaSh0RN62PDPT8yLpcEZzsUYa3tY/
	SMIr9sBxkGt1X4n5aG837ov1PrSuFOqanh9U73REtbcQD8AlkY9itFFGdO7GiqKc2Y8=
X-Gm-Gg: ASbGncscwbJSj0n3nwiJ57IK+S60rF6m3P68InLfSHmSu1N4J4FxFEAdnulJB2kOtHB
	wOfS8P9+aVM13Gq2LrlIT+2/HLUe1HREgjo3peAT6URk9QTGx5xuxXic++QBuZjnXXOQOBPRmnM
	se1eJbNM4C7TL1MZVbA/rpZh+KxtUfVl+Bm4ZDK9UqSaZGr2FBXhybFrNUdYnjfFpHMEkFGpCPQ
	jQ69wJqPPCaFVvD7tTsIQzsWR+vy81Ofu9jyJt+HbWP12dgODq68+Av92ckwWCH+n3x1AydoG4x
	Vx7+vuFFN9ydF1XuKrXFRBnXY4gfpGeb3rwo+BD4fHpr9xpahPY5KbI/aP+PRpnugix1whVeXnb
	mgPv8QcgwaavdI1RThO8loqjMZpyRXnHSPTlkxvZr9T/NgxQFXyn5emvwGQ2FqQVtk3Yc3jOjcT
	8=
X-Google-Smtp-Source: AGHT+IEC1ZnawAzhyiAweFjgEPLWJf7nK7gLmOHHmkH1pRUSyf36zcSh/zg++5y2SumOecPCktKS0g==
X-Received: by 2002:a05:600c:4f81:b0:46e:5cb5:8ca2 with SMTP id 5b1f17b1804b1-4771e1744e7mr29173155e9.2.1761791555087;
        Wed, 29 Oct 2025 19:32:35 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d42558sm166092075ad.69.2025.10.29.19.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 19:32:34 -0700 (PDT)
Date: Thu, 30 Oct 2025 10:32:31 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, 
	Deepanshu Kartikey <kartikey406@gmail.com>, akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to
 prevent divide-by-zero
Message-ID: <kpinb33rra6csr2cp5gyx27s5ltwp6fumem4to2f4zj2d6t5r3@kc6zsvphbaoy>
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
 <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
 <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
 <503243eb-3289-4f1b-8698-4b496065e622@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503243eb-3289-4f1b-8698-4b496065e622@linux.alibaba.com>

On Thu, Oct 30, 2025 at 10:17:41AM +0800, Joseph Qi wrote:
> 
> 
> On 2025/10/30 10:00, Heming Zhao wrote:
> > On Wed, Oct 29, 2025 at 05:25:03PM +0300, Dmitry Antipov wrote:
> >> On 10/29/25 12:53 PM, Joseph Qi wrote:
> >>
> >>> On 2025/10/29 13:53, Dmitry Antipov wrote:
> >>>> From: Deepanshu Kartikey <kartikey406@gmail.com>
> >>>>
> >>>> The chain allocator field cl_bpc (blocks per cluster) is read from disk
> >>>> and used in division operations without validation. A corrupted filesystem
> >>>> image with cl_bpc=0 causes a divide-by-zero crash in the kernel:
> >>>>
> >>>>    divide error: 0000 [#1] PREEMPT SMP KASAN
> >>>>    RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
> >>>>    RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
> >>>>    Call Trace:
> >>>>     ocfs2_block_group_alloc+0x7e9/0x1330 fs/ocfs2/suballoc.c:703
> >>>>     ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
> >>>>     ocfs2_reserve_new_inode+0x4f4/0xcc0 fs/ocfs2/suballoc.c:1074
> >>>>     ocfs2_mknod+0x83c/0x2050 fs/ocfs2/namei.c:306
> >>>>
> >>>> This patch adds validation in ocfs2_validate_inode_block() to ensure cl_bpc
> >>>> matches the expected value calculated from the superblock's cluster size
> >>>> and block size for chain allocator inodes (identified by OCFS2_CHAIN_FL).
> >>>>
> >>>> Moving the validation to inode validation time (rather than allocation time)
> >>>> has several benefits:
> >>>> - Validates once when the inode is read, rather than on every allocation
> >>>> - Protects all code paths that use cl_bpc (allocation, resize, etc.)
> >>>> - Follows the existing pattern of inode validation in OCFS2
> >>>> - Centralizes validation logic
> >>>>
> >>>> The validation catches both:
> >>>> - Zero values that cause divide-by-zero crashes
> >>>> - Non-zero but incorrect values indicating filesystem corruption or
> >>>>    mismatched filesystem geometry
> >>>>
> >>>> With this fix, mounting a corrupted filesystem produces:
> >>>>
> >>>>    OCFS2: ERROR (device loop0): ocfs2_validate_inode_block: Inode 74
> >>>>           has corrupted cl_bpc: ondisk=0 expected=16
> >>>>
> >>>> instead of a kernel crash.
> >>>>
> >>>> Link: https://lore.kernel.org/ocfs2-devel/20251026132625.12348-1-kartikey406@gmail.com/T/#u [v1]
> >>>> Link: https://lore.kernel.org/all/20251027124131.10002-1-kartikey406@gmail.com/T/ [v2]
> >>>> Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
> >>>> Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
> >>>> Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
> >>>> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> >>>> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> >>>> [dmantipov: combine into the series and tweak
> >>>>   the message to fit the commonly used style]
> >>>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> >>>
> >>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> >>>> ---
> >>>>   fs/ocfs2/inode.c | 8 ++++++++
> >>>>   1 file changed, 8 insertions(+)
> >>>>
> >>>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> >>>> index 1b6bdd9d7755..efb930da0920 100644
> >>>> --- a/fs/ocfs2/inode.c
> >>>> +++ b/fs/ocfs2/inode.c
> > 
> > The cl->cl_bpc field represents "bits per cluster". This means:
> > - for a 4k (min size) cluster block, cl_bpc is 12
> > - for a 8k, cl_bpc is 13
> > - for a 16k, cl_bpc is 14
> > 
> > The OCFS2_SB(sb)->s_clustersize_bits is the same value as cl_bpc.
> > Its values are 4k:12, 8k:13 and 16k:14
> > 
> >>>> @@ -1505,6 +1505,8 @@ int ocfs2_validate_inode_block(struct super_block *sb,
> >>>>   	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
> >>>>   		struct ocfs2_chain_list *cl = &di->id2.i_chain;
> >>>> +		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
> >>>> +				sb->s_blocksize_bits);
> > 
> > The meaning of above line is "bits shift from block to cluster".
> > Not "bits per cluster"
> > 
> >>>>   		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
> >>>>   			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
> >>>> @@ -1518,6 +1520,12 @@ int ocfs2_validate_inode_block(struct super_block *sb,
> >>>>   					 le16_to_cpu(cl->cl_next_free_rec));
> >>>>   			goto bail;
> >>>>   		}
> >>>> +		if (le16_to_cpu(cl->cl_bpc) != bpc) {
> >>>> +			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
> >>>> +					 (unsigned long long)bh->b_blocknr,
> >>>> +					 le16_to_cpu(cl->cl_bpc));
> >>>> +			goto bail;
> >>>> +		}
> >>>>   	}
> >>>>   	rc = 0;
> >>
> >> Oops. This seems prevents from mounting filesystems with any block size except 4k
> >> (mkfs.ocfs2 -b 512, mkfs.ocfs2 -b 1024, mkfs.ocfs2 -b 2048) with the following message:
> >>
> >> OCFS2: ERROR (device sdb): int ocfs2_validate_inode_block(struct super_block *, struct buffer_head *): Invalid dinode 23: bits per cluster 1
> >>
> >> Dmitry
> >>
> > 
> > The value of cl_bpc is an intentionally crafted value designed by syzbot
> > 
> > under bsize:4k csice:4k, the patch code:
> >  "1 << (OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits)"
> >  => "1 << (14 - 14)" => "1 << 0" => 1 (just same as cl->cl_bpc)
> > 
> > The values are the same, but it's logically meaningless 
> > 
> > Based purely on code logic, the original patch code:
> >  if (le16_to_cpu(cl->cl_bpc) != bpc)
> > should be changed to:
> >  if (le16_to_cpu(cl->cl_bpc) != OCFS2_SB(sb)->s_clustersize_bits)
> >  (and remove the line: u16 bpc = ...)
> > 
> Ummm... IIUC, 'cl_bpc' stands for bits for cluster, while here one bit
> is corresponding to a block.
> 
> Joseph
> 

from format_file()@ocfs2-tools/mkfs.ocfs2/mkfs.c, you are right.

if (rec->flags & OCFS2_CHAIN_FL) {
    ... ...
    di->id2.i_chain.cl_bpc = s->cluster_size / s->blocksize;
    ... ...
}

I withdraw my analysis above, and I am confused by Dmitry's error log now.

- Heming
