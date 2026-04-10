Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250DD38642C
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 10:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775817376; cv=pass; b=H7XIMInYFG/46fOYAxJMdD6rY+PrYBZPYWSJtAoG4LwGVfn/yaVUMt/ys8RVD8AI414MljYjfPIpEktza6mNlqFfmyufPipbhynRnM+twblgO3l8kBnNo6jpW3vpEbL6MBZnNCxS6aID/CaXmL/2Uh5RAAts1O+8JPZ4YUZwfMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775817376; c=relaxed/simple;
	bh=MSZwMuo1s2PQ3xpjuYD4tj4AGujUi5WE5c5TCwfSLsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mGkxiwPhS9mJoLV5/fji5ue6Quf6JJzJ5ZBSzhhcuCCAe1mribW+Nqm9VlCa/iMjcCObnU+hqh5dDpZElaU7Gc7WlB1QEbEZw0xB9Rdi2b/0JVdoB92l4hL45uy9YjvAJVDJGgXpQI5Lcdr/NBbtVNoPfON3HpGYgyBnXmNT4R0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bszV4UG8; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bszV4UG8"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b9c603ec2dfso268037666b.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 03:36:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775817373; cv=none;
        d=google.com; s=arc-20240605;
        b=G8Z2ZcJNp174BkQIGtnq5Pyrl8vwnmsCtegVIuoHQIvBzAtokGYhnySpVQWfht0DC3
         31s2xb4fYgh1dswhMPg7wDgQ1okFAOkWxDT59nhdlx7aEg73+Qo7SPc8u7OE0nYwN+Kh
         sg115+3TQgvr6md7bj+wLLkssdgCqQT/ftSJsDbH5Cy9Y9D7MfZ69ELvdq4HtXzjZ34i
         DRjH/7igfpKnBmnQvVKK5CU4QCf/rAJ+tWoZ6ELSrLa3C64IjCyORCgdGDlXCwAp3GhW
         pYR0Q3x6VrjGtNe/yr7dBb6+rfvYbimjJZZ9cgNRQyA5HFj0zwXqUpyr3kLaPg6Dt7ni
         i5VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=00SHmhIircwo8jSFx2a1LHX2q4NxFm9rLB+P2eIJFFM=;
        fh=FLRldhW73fzzUGsTXchr7wQPBS3DwSWYsZYi7QDX0Vc=;
        b=TGcSEL4LyiS2v1+fU8/ygpfEJncJdjv7hLZBgUgrsKrfrSOiM16nL6y7RTMfrDjPhz
         P/lwKJmrJ/mq61z+ngU+WSYPRFZi5VmZnpIflu4X5dsNUWa+GXsFWxAmQ+rM3Yr07yTf
         L1t4lF+izBgltsS0myVnlJbCa4IZaCo+IvsirCQrlG+SvDabiIbHFZywvppqq2jq5o31
         4TpfdrfSm7hfEyZvbiBtH6TBB6OePbc06k1mJUHkm00JLyQ6nz5jG4Byhs1da10h4iCz
         eBrMaqUPzD8nj8Fnd3d+x6fQaXUyJy8uKXVoaO2VLUR8iTkbABkAtt/ctxUgOlzRam9S
         ScvA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775817373; x=1776422173; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00SHmhIircwo8jSFx2a1LHX2q4NxFm9rLB+P2eIJFFM=;
        b=bszV4UG8bv9tPoOXhwdtbwI005nmVNVhbqfA3BKUt4aBLmSPxHe4TtUtzSFEmdKogp
         SmHPfltVgWSPodxK4So06/1ZQ4SpV75yNi/sxwHV0JaK6yL8Zz/2wCEb3pXIiH75iuMq
         bRocYtEdDQjUeozLBTSEchyav8/RRdpFi5LzZBTd0kG6X+Vh4CO3gOuYPXBBWlG39O/H
         /eqTtnXUJNewYSmX4qUq3l9FO+er9Hztwj/M4eIjDwre1MIMalIFgQM3hKVPFAWleRTa
         3tV+moJHAPj0Ubnjt6NMHhluki/OJfYDQebdmaK1tI7NlK3m4OSpnw2PaqHgOSMfgroB
         hHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775817373; x=1776422173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=00SHmhIircwo8jSFx2a1LHX2q4NxFm9rLB+P2eIJFFM=;
        b=Xmwo0Dd7o65c/WN3rXHY0zHJc8+31CvVk7EyL/nSPjEvr+XB6dGUsuXijX6C05KP51
         4I8sumJwq8OquImYq2vWbxp3mnE10IiS7jqXuLyS7DwpGlyd9ptchZNbJ+Dxyfsvk1HZ
         STvrE2Acerfj/FzDI7SQB38/2Yo9JZymGAUh7fktPlj1AYJVInJUq3axJOnnYn8Eifx2
         j3jZdvOu9FKa/ks4DeOosUZvs43ioJyfe9TgU61tFYb+PleGEVomGRzRDEqh5ZKeK+6F
         IDS0Ih0r4MjnIb3f93M4UBfwmDpSAk8sTuFfZHsIgJgMtynQfBLr+epl6oEV+4oJi+Ee
         T4sg==
X-Gm-Message-State: AOJu0YxB7OL2OVowlbKpADo1xkVAm++BIHXs+PJrICacgzKVUWU/JOA0
	5rOLUtnSVcnoVQSf9Kzf+ttl65YFLHN4AwuoIxMx217VudSrNINLohtqLgr9kq4dPRDLtFNdSF0
	NJtLjZaSfCeobIohWTd4AZ26uALG9sDs=
X-Gm-Gg: AeBDieu/vmvb8AkNnjnpvDoLbOm+6uzvE3Fx31ys6v7E1r1VJOMrLuRR6rKAG5Uk6vN
	1AI/E9HSPnkWncz8MnRur1KD+GPBZ9E72xMIlC+7jepPCdexDj4BoMZDo9LHqa/VenUlhur9Pux
	yPupSdpSR5TEsEHdIpso1eZNE3co0aJ/F/KChsrNNUgy232/l/DeO8JhvQa24o3gHjuE/53Xmy7
	OW+3mOqWmJGdDa7zqBIuVWMMNl334CQ7eX93xvgIhhMcj+pSHAXLHLDqAjgjSY4zfIIdV2g4+FK
	M+3zdzRb72DGZsPKHNWSuguv8VhMmbZLFT5/JUigPEMVN4Mjg5Kc9Bk=
X-Received: by 2002:a17:906:eec7:b0:b98:528b:844a with SMTP id
 a640c23a62f3a-b9d72ac40e6mr157825666b.51.1775817372972; Fri, 10 Apr 2026
 03:36:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260410062227.3881209-1-gality369@gmail.com> <1dbba5a6-a7e2-49b4-8475-9f1d338efb5c@linux.alibaba.com>
In-Reply-To: <1dbba5a6-a7e2-49b4-8475-9f1d338efb5c@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Fri, 10 Apr 2026 18:35:46 +0800
X-Gm-Features: AQROBzAkWY7kVUy0qgfA8kJL7EvjqYGxMjw2lFHbVF4fIW1OewmAjDKnvGLyyg4
Message-ID: <CAOmEq9X2YQpPu81nxnMj2Pr9KsVci7GqjvKf5-e2c4K8Pu-=Cg@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate inline dir size in ocfs2_dir_foreach_blk_id
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2026 at 6:03=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
> On 4/10/26 2:22 PM, ZhengYuan Huang wrote:
> > [BUG]
> > A crafted inline-data directory can set i_size larger than id_count.
> > readdir then walks past data->id_data and KASAN reports:
> >
> > BUG: KASAN: use-after-free in ocfs2_check_dir_entry.isra.0+0x31f/0x370 =
fs/ocfs2/dir.c:305
> > Read of size 2 at addr ffff8880088f0008 by task syz.0.1936/4656
> > Call Trace:
> >  ...
> >  ocfs2_check_dir_entry.isra.0+0x31f/0x370 fs/ocfs2/dir.c:305
> >  ocfs2_dir_foreach_blk_id+0x203/0xa70 fs/ocfs2/dir.c:1805
> >  ocfs2_dir_foreach_blk fs/ocfs2/dir.c:1933 [inline]
> >  ocfs2_readdir+0x4ba/0x520 fs/ocfs2/dir.c:1977
> >  wrap_directory_iterator+0x9c/0xe0 fs/readdir.c:65
> >  shared_ocfs2_readdir+0x29/0x40 fs/ocfs2/file.c:2822
> >  iterate_dir+0x276/0x9e0 fs/readdir.c:108
> >  __do_sys_getdents64 fs/readdir.c:410 [inline]
> >  __se_sys_getdents64 fs/readdir.c:396 [inline]
> >  __x64_sys_getdents64+0x143/0x2a0 fs/readdir.c:396
> >  ...
> >
> > [CAUSE]
> > ocfs2_dir_foreach_blk_id() uses i_size_read(inode) as the loop bound
> > after reading the inode block. Inline directories are only valid while
> > i_size <=3D le16_to_cpu(data->id_count), but that invariant is never
> > checked on read. Once ctx->pos reaches id_count, data->id_data +
> > ctx->pos points past the inode block and can land in a freed neighbor
> > page.
> >
>
> ocfs2_read_inode_block() has already validated dinode->i_size.
> So how it happens for the corrupted in-memory i_size?
>
> Thanks,
> Joseph

Thanks, my previous description was inaccurate.

The issue is not that inode->i_size becomes corrupted in memory after
ocfs2_read_inode_block() validates the dinode. The issue is that the
current dinode validation does not check the inline-directory
invariant i_size <=3D id_count.

ocfs2_validate_inode_block() does basic dinode validation, but it does
not verify that inline directory size fits within id_count. Then
ocfs2_populate_inode() / ocfs2_refresh_inode() /
ocfs2_refresh_inode_from_lvb() copy that unchecked size into the VFS
inode.

So the actual problem is an unchecked corrupted on-disk i_size, not a
post-validation in-memory corruption.

Once such an inode is loaded, readdir can legally reach
ocfs2_dir_foreach_blk_id(), which uses i_size_read(inode) as the upper
bound.

Based on your comment, I think the cleaner fix is to reject such
inline directories when the inode is loaded or refreshed, rather than
only checking in ocfs2_dir_foreach_blk_id(). I will respin the patch
accordingly.

Thanks,
ZhengYuan Huang
