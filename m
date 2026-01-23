Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AEB3859DC
	for <ocfs2-devel@lists.linux.dev>; Fri, 23 Jan 2026 06:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769149446; cv=pass; b=exGsSg72/7x6aWQCXhY3qo3C0amGzPZ/FVKE7htrhUwnRVQWTyI95EyAHCNWICKeuWIERg9/W0VoIhMVL+N3D7vs2QceGvk3grCG2dyx3I2FqWeN9VxSymvzp7SF69G3DVwcd3W/9nL4Ccknk3VAahddIvhb7xstK1Rau0J7u/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769149446; c=relaxed/simple;
	bh=s3QgfBAeidOBYt7+kiyTW4gJW+1preYHRbtIweTxzJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HDutTyDxlpAuKCY0r4CjszDAQpZN6cxXjFyMKArgxuXNhyMbCFLmp0JNrC1c4qoMf91He1Iw88W8FVNyYkxgWlxDvd0aBn0VsGQzF22BaoBnI9vkQeBlAPtbF1bKdKg25NUj8vjyNzzFFxVDJzV5m0EoqP5CpK++X91Dr6YAH4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DCseBMa6; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCseBMa6"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6467b7c3853so1516585d50.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Jan 2026 22:24:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769149438; cv=none;
        d=google.com; s=arc-20240605;
        b=aHk/fC9vLPpBnejyMf76lT4gjBGi0QWos0nl9FY8e90hNycrbtozMCKDXkpk6jjMFD
         Ci24L6x3+ek9cqFnpMaARl8L34gxqyNqwRd9HJJeMpPI/txLYKEjiVoQD3Bc8Qd9R2o8
         HMB6qlAqquCCnVLCeoJkoMGKpcXyHxYI5hQgElur8et4/BSONqec2uW+e9ANibx5/7xX
         Gnkw5w4ggfbydGPjsdctPMlmznDiPHpM1/th9VpJGXCE7IiypGyKfbz3UUY8B52F3GZs
         fW0c7fVG3AonxXTh/qQuznWuagjvDOEkL6ctGUMyIJAF/9Xf7seoRKFkDZqQYMCJQFcV
         tlgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NJeYYGHMmC4xqevwf10WebMr//MGhsnoMgcdl7kULno=;
        fh=DRupMWrbpIlx5a1qZcYuULH9Re49abi6g5Q1fD6JoYE=;
        b=hci+aM7xSErE+2KboeDKm3a1opM1leUsGsBcBs8Q82r2BP/HViB82P6X3JbRpZ7QH7
         Tcx7exBqPRCuNCrg/aoIIUwjuNyT/TOjXtEQL/EFWsaJsH6WYxbXGZLAQvbsXvXBkTjR
         a9iD/5LcsUQd9P1+m8kOdQIw3aYURXh/TQ0tKK/fCCLGKYh+SSEZAKngkKVsG4KzdlcT
         SjHDhcddSeHly3X1NDgLg8x3t+gO8Fzvz0YEukQ+EOpz9yxCrpWwHkQOMCgm3fOr1JmQ
         J6qwtFNsWMxb5yBipAUkZBYeduy/lB2DXc1KLWX5s61pNDRU76dSoeS0HgvXvz1FBP9k
         e/KQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769149438; x=1769754238; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJeYYGHMmC4xqevwf10WebMr//MGhsnoMgcdl7kULno=;
        b=DCseBMa66l7LTprbkC8Z6ReujomBDvllo/a58BHiNLuPF4XYFz9Iy8E5J90aOIVHkH
         l31CQFH/LDGwhxoewtUWp9VwPjc/P8T9jGGPea825bQnK+yLMwZ1S+G6n4IyxLHw1s2G
         QOMGsraut3pf8AWLCThULSvf47sDaR0ttjDRkDCNEwn/GEjO+l+Rhx74nnP8RSYu7owj
         +uuz9/bN5JpmqMn/OGFVKyB2v63uHiyXn2wdXdG5AaeDhc7iDIJHA2oVSYnW+Bm3LA34
         nyTpYsrY2rckbdXzeRfdCcJtJYapkEY1hnDvZAoFr/LaIhB8i4OGCVsrLxa79zQ5rXMB
         4oaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769149438; x=1769754238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NJeYYGHMmC4xqevwf10WebMr//MGhsnoMgcdl7kULno=;
        b=Lw2tmfroUzNVQoFWCXAjg2qxMknpPOWvK2C7GEYE0heao0dSnNafPprk3sm8t0El5m
         r5y4zxmYywnTJhAUuIGYhy6S9mHvCV68zwz4pdwWqFReciI6RIjLe8BUnTJ/DWK2qiFq
         Xjo9a3c8DIk0u0dcBX9HEQWJ0rVWF2FapelsUCnGMNioSUmkLj5igWcGJgz8I29ooNkK
         ebBu4yc/DhhiX6EEtuHACElw/rHipwBC+RvF5pj9H/DXMQYMAJfDEW/bfKBAm4yhzq8W
         8dpWdB4V7qKJcyQln8g8BHlTcFOnR6X0Gflam0jhJR/TmTLHBQ3AHVwKC7+hsT6BOGkv
         WfPw==
X-Gm-Message-State: AOJu0YwdtCDi0RuQIESUKgClhip9S58t5Ue2RExaq2vpS8xcUt1plh9f
	tp5SUwb9QZoLJzBcJPW8FQ/ddGjBQ0iL/OjbHfbQTpm9bN40DgNoaSbpMtL1rMhWN/0w/4bE5+V
	OurcqI88lcJi3icnSCf4+6v/jMxRKKUk=
X-Gm-Gg: AZuq6aK0p4sbF6J3EqO0oB8qODK57+pY9wu23W1UEq57f4M8xt3HOTESu6BWyNkIC05
	MK/l6CFSg6lEkzFu3a59NdzENpKYeDwdzS2dXGW8GA98haPQm9efww+o0fEuoqjqPcoMUDA9xTb
	3QuZfB5u9/ZRmof7Gljl/x0P6eXcNf1rgRTQ8NJ1uJLs5bFntCQIiz3oApZTiGStomR5ezNRff8
	xFyKoYPCsSQkjLVXM1VccHhgCBaZu0YxXGxqRxLjma2KT/KGduL6aGsDcpe+bu3BKLUhaeR8dc7
	TTf9AIwxup6t18vwnV1HwarpBZkOQ2L14rMwc4g1sJxfeRrnNPaikeG+ZLI=
X-Received: by 2002:a53:b606:0:b0:649:462d:b774 with SMTP id
 956f58d0204a3-6495c01c89dmr1171913d50.68.1769149438207; Thu, 22 Jan 2026
 22:23:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260110054443.604944-1-kartikey406@gmail.com>
In-Reply-To: <20260110054443.604944-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Fri, 23 Jan 2026 11:53:46 +0530
X-Gm-Features: AZwV_Qh4nHRCuKEwEmHRmVRCxOJXyjEHPuNiI3mfKMN4Z76SxjAa3RtvuFtbX4g
Message-ID: <CADhLXY6Dojpckbkq7Dk_T7BrHML9_AAscJ+xKt3aPiV9v1V73w@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: validate allocator type to prevent BUG_ON in ocfs2_block_group_search
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 10, 2026 at 11:14=E2=80=AFAM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
> ocfs2_is_cluster_bitmap() checks whether an inode is the global bitmap
> by comparing ip_blkno with osb->bitmap_blkno. A corrupted filesystem
> can have either the superblock's bitmap_blkno field corrupted to point
> to the inode allocator block, or the inode allocator's i_blkno field
> corrupted to match bitmap_blkno. In either case, ocfs2_is_cluster_bitmap(=
)
> returns true for the inode allocator.
>
> When the code later calls ocfs2_block_group_search(), it triggers
> BUG_ON(ocfs2_is_cluster_bitmap(inode)) causing a kernel panic.
>
> Call trace:
>   ocfs2_block_group_search+0x1c7/0x2c0 fs/ocfs2/suballoc.c:1611
>   ocfs2_search_chain+0x38a/0x1010 fs/ocfs2/suballoc.c:1764
>   ocfs2_claim_suballoc_bits+0x3a4/0x650 fs/ocfs2/suballoc.c:1978
>   ocfs2_claim_new_inode+0x95/0x130 fs/ocfs2/suballoc.c:2137
>   ocfs2_mknod_locked+0x129/0x510 fs/ocfs2/namei.c:568
>   ocfs2_mknod+0x5c7/0x11d0 fs/ocfs2/namei.c:802
>   ocfs2_create+0x136/0x170 fs/ocfs2/namei.c:852
>
> Add validation in ocfs2_reserve_suballoc_bits() to check that the
> allocator inode type matches the expected type:
> - Global bitmap allocator must be the cluster bitmap
> - Other allocators (inode, extent) must NOT be the cluster bitmap
>
> This follows the existing pattern of validating OCFS2_CHAIN_FL in the
> same function and uses ocfs2_error() for graceful error handling.
>
> Reported-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D44c564a3cb08605f34a1
> Tested-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/20260104014028.305029-1-kartikey406@gma=
il.com/T/ [v1]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> v2: Fix commit message - ocfs2_is_cluster_bitmap() checks ip_blkno
>     against bitmap_blkno, not a flag (Joseph Qi)
> ---
>  fs/ocfs2/suballoc.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 8e6e5235b30c..fb72c062a8d5 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -813,6 +813,26 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_=
super *osb,
>                 goto bail;
>         }
>
> +       /*
> +        * Validate allocator type matches expected bitmap type.
> +        * Global bitmap must have BITMAP flag, other allocators must not=
.
> +        * This prevents a corrupted filesystem from triggering BUG_ON
> +        * in ocfs2_block_group_search() or ocfs2_cluster_group_search().
> +        */
> +       if (type =3D=3D GLOBAL_BITMAP_SYSTEM_INODE) {
> +               if (!ocfs2_is_cluster_bitmap(alloc_inode)) {
> +                       status =3D ocfs2_error(alloc_inode->i_sb,
> +                                            "Global bitmap %llu missing =
bitmap flag\n",
> +                                            (unsigned long long)le64_to_=
cpu(fe->i_blkno));
> +                       goto bail;
> +               }
> +       } else if (ocfs2_is_cluster_bitmap(alloc_inode)) {
> +               status =3D ocfs2_error(alloc_inode->i_sb,
> +                                    "Allocator %llu has invalid bitmap f=
lag\n",
> +                                    (unsigned long long)le64_to_cpu(fe->=
i_blkno));
> +               goto bail;
> +       }
> +
>         free_bits =3D le32_to_cpu(fe->id1.bitmap1.i_total) -
>                 le32_to_cpu(fe->id1.bitmap1.i_used);
>
> --
> 2.43.0
>


Hi Joseph,

Just wanted to follow up on this patch. Do you have any further
comments or suggestions?

Thanks,
Deepanshu
