Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEE07260D
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Jun 2026 01:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781400750; cv=pass; b=X2aL6MCCKp9jiCd9Pev4TIujxCOAonwhjXpGtu7Rppy1sdUAtFMAOqzt+2wv8fSAW/TEHycnmdo29tOYWO0AzO9yzm4ZAQ/HtMD0LaxtIEyqUxgde9JiRWxtKC0aRJK6UVDR6EpDo4B5Q8Bx3MonGwZoTf03Wlrcf6PbFLbdcCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781400750; c=relaxed/simple;
	bh=PLHv8n+5Z5dmP6+ukjwnit+rXrig202sb4I/heW4PJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hUo9hMh3aca7CQC/G64NHsBKSkAsltAYMaYkPM4IENS9v7gGGlUIwZbcIcaQL5AMJP6i2p6HhChhD0VvFCTfXNPHbjzIVAnlgT1l6YNKEAEWE/fiCYpwhjL9BcbXHYQTCScnvF1kyhjJNSy2xC3cJPghQKV7rAUym8k3dW4xfGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qWj0ozBY; arc=pass smtp.client-ip=209.85.208.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qWj0ozBY"
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-39677c80386so21414211fa.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 13 Jun 2026 18:32:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781400746; cv=none;
        d=google.com; s=arc-20240605;
        b=gnWcPOIZT/1Iom+caKOWWiLVh3jtDcRJl44AVjW0LNLDLs9/sbPj5fWCpJnjZpRjSU
         uViyP5PvncsNZfnmUPIG1ypXq6DKoEmp1KMaQYtWKwbvS+NaMNyHimGhLC1RhnqDl38N
         fdJBGxb16pPaEtuc68pa4Ua3Ap7RhQm/XvNDgkjshrScH9ajw+h4uaqmZ+44Hq7/zJsp
         rco7G6+svCJnMq4fXaZvnogmkYd62UuNqZC4UZgh4CpoOtQMk5vJSeEXEbyD5TX4E2xm
         J7ndP0FaNc1GLjtj7V6OzH5IXITJxQ78C12y3oUBgQZW37J84RiDFVftZgd47NNX5+7u
         KgCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=91nTbIu/HnaoiadjBQ7jCH85zB1cun3V2wKVVVY4Rak=;
        fh=03m5+eNLbtApDDs/duJGc/Fv/6ndu0DyInaK//2Ww8I=;
        b=QqjbkxaHXbEbm0/INgz7WH+m2v68XLuxA68DXoGPL3ZdSJ3pRtL3XopL4F7/7P3Lwq
         ni1si3jGi/qM1v8GQJJMnfNaKq/w07hIvCyT1I1PLWKam+H0eiQLcx1skrsMEN1olDJH
         Y08O+TxPnXKvzcsf1Gfj7T/cpBdhIjgAqwrbw/l3Gs/KEE6GB9tdzNSDhRIuH6KQzJjO
         xjbUU0Ctew1fkHhJh2GTk2Kvi+WvA8a0hd1X6NGhsd7m7uGBUI66c7SGJkupqlLdCfZg
         Fb1XEVfjrSQ5ZfaexatBoQpDsff25nP1WpD5zk9p2apOw+O4uGcJ/CKeKjPUZyivSkFb
         Yf+Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781400746; x=1782005546; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91nTbIu/HnaoiadjBQ7jCH85zB1cun3V2wKVVVY4Rak=;
        b=qWj0ozBYqvs4dnPofIelwxIM6r9AFMMmxtkljcBgVVxPEO7SSMW5GlyATjYEuRQZJC
         U7ERwpmxMKvBOVG+QcKQJeHxy70tHAMFQzl5DFK5cYpeSwWXXjf8R9Hbym6nssiFD6NB
         hGyPWnwkukDG4+s+SprNKUGUzGd8oNusc/psMaea4Vulhg9OuqQ8//g+BtRQmW/bOxsn
         rUztJjWD+e87VsUc6o8u0s7WiLgx6e1M5IyV4FdlhoGDqvop76FLWifvnOuiub0qd/K/
         TGycxflzEOPSJz5wS4zcTMTnk89nJtuvz4l3jqUQ9wmje+gfYI6EeWT2eNA04nGkSaC0
         PU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781400746; x=1782005546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=91nTbIu/HnaoiadjBQ7jCH85zB1cun3V2wKVVVY4Rak=;
        b=PWQdrB9c1xW4M2j1vEi7tvyDAST6DG3gBm0huNabHCwFNFAqmfxs7lGTpuMhvf4TLX
         zEyH3mxd//zE/nrQOy9AlFXw6Ofc5G2Xn+Qheax1+LW4IdSsv8m7NXX8hZLHv2Bo6aPZ
         p41MDZKHco/eliKLWRBRkJIyCH8Vl51tNKwjVHj5IN5c1aKCVYUlABIV+dADXbpYqN3Q
         wp7SxT39uDOp/eDnTJwvimEqhYZNX+t4/RejPuLfi9q/lO4RiwBFRNvHRr+yBoDMhTYx
         oUO/UoGebyqbWrWMwx/Wme0ChYKndOMDHIKfoD3/arTFKoMKk+JFkehJRbdwJUBVt/te
         4Crw==
X-Gm-Message-State: AOJu0Yw9g8NYdt0m7781ApwwFSR5WLxF2cg50YC2EN9K6db3bUgucc55
	9A6VJeEBfSwA0ikGnneapD7w2wao5wSIscjAgNjcxtxA7Hz4xAoYs9/T18361HRmuNWna5UuEGp
	mq1hsVZvdSv2PaIYd1tiqJI3qPPX6FMY=
X-Gm-Gg: Acq92OENudjVFHMDs2sQhafDJdsqhdk6ZTmNZs/iExE90OrtIc3+FwvSSPl03DjQXvz
	NNy3mFM3yNwxl2/vsC9TXsRVT98ODWxB0l7OL7RSQv00Myf7XkGrgJsS8IIfi62M1L/E95XweJC
	+cVov/j545uzlOPborzzW7qkrlQD7+fT3GMXA4OkxzWgNpyb1Hvg1O5WBiscU7N3seCDzIZLuFF
	o226f3qH95uU05TK6uAKGZ8SeKMyi7JYjEFIW3K2pdt57Jvps4Muul8EUFoclz3zxsKk+/nQTyX
	SC9SpP5OUg==
X-Received: by 2002:a05:651c:1511:b0:38b:f632:e0fc with SMTP id
 38308e7fff4ca-3992af7cea4mr27065041fa.1.1781400746084; Sat, 13 Jun 2026
 18:32:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260525070604.360875-1-rollkingzzc@gmail.com>
In-Reply-To: <20260525070604.360875-1-rollkingzzc@gmail.com>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Sun, 14 Jun 2026 09:32:14 +0800
X-Gm-Features: AVVi8Cf1yljSrWRTGPYbP-yKSajqBBd0rN-AIjBfx86a0xQZejYFFLZGh4Ct9QM
Message-ID: <CAB7XQsEKUD_xHCQ0kZeW-cLx5U3G_CvoqDG3XO6RtNBq5ZbmDA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: remove debugfs before shutting down recovery
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com, 2045gemini@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

Just a gentle ping on this series.

I would appreciate any feedback or guidance on whether further changes
are needed.

Thanks for your time and review.

Best regards,
Zhang Cen

Zhang Cen <rollkingzzc@gmail.com> =E4=BA=8E2026=E5=B9=B45=E6=9C=8825=E6=97=
=A5=E5=91=A8=E4=B8=80 15:06=E5=86=99=E9=81=93=EF=BC=9A
>
> ocfs2_osb_debug_open() builds the per-mount fs_state snapshot by calling
> ocfs2_osb_dump(), which reads osb->recovery_map. During normal unmount,
> ocfs2_dismount_volume() currently calls ocfs2_recovery_exit() before it
> removes osb->osb_debug_root, so a concurrent fs_state open can still
> enter ocfs2_osb_dump() after the recovery map has been freed.
>
> operations, so moving it ahead of ocfs2_recovery_exit() closes the
> post-free/pre-remove window without changing the recovery-state logic.
> This also makes the normal unmount path match the existing mount-error
> state.
>
> The buggy scenario involves two paths, with each column showing the
> order within that path:
>
> 1. Open the per-mount fs_state file      1. ocfs2_dismount_volume() start=
s
> 2. ocfs2_osb_debug_open() calls          2. ocfs2_recovery_exit() frees
>    ocfs2_osb_dump()                         osb->recovery_map
>    osb->recovery_map                        runs later
>
> Validation reproduced this kernel report:
> KASAN slab-use-after-free in ocfs2_osb_debug_open+0x478/0xaa0
> RIP: 0033:0x7f65fc97a001
> The buggy address belongs to the object at ffff8881049c3da0 which belongs
> to the cache kmalloc-8 of size 8
> The buggy address is located 0 bytes inside of freed 8-byte region
> [ffff8881049c3da0, ffff8881049c3da8)
> Read of size 4
> Call trace:
>   dump_stack_lvl+0x66/0xa0 (?:?)
>   print_report+0xd0/0x630 (?:?)
>   ocfs2_osb_debug_open+0x478/0xaa0 (fs/ocfs2/super.c:343)
>   srso_alias_return_thunk+0x5/0xfbef5 (?:?)
>   __virt_addr_valid+0x188/0x2f0 (?:?)
>   kasan_report+0xe4/0x120 (?:?)
>   full_proxy_open_regular+0x113/0x170 (?:?)
>   do_dentry_open+0x233/0x7f0 (?:?)
>   vfs_open+0x5a/0x1b0 (?:?)
>   security_inode_permission+0x19/0x60 (?:?)
>   path_openat+0x679/0x1540 (?:?)
>   kmem_cache_alloc_noprof+0x1ea/0x5f0 (?:?)
>   do_getname+0x2e/0x1d0 (?:?)
>   do_sys_openat2+0xa4/0x150 (?:?)
>   __x64_sys_openat+0xd0/0x140 (?:?)
>   do_syscall_64+0x10c/0x640 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
>   do_file_open+0x190/0x2a0 (?:?)
>   __lock_acquire+0x42f/0x1a60 (?:?)
>   _raw_spin_unlock+0x23/0x40 (?:?)
>   alloc_fd+0x210/0x350 (?:?)
>   do_sys_openat2+0xce/0x150 (?:?)
>   irqentry_exit+0xac/0x6e0 (?:?)
> Freed by task stack:
>   kasan_save_stack+0x33/0x60 (?:?)
>   kasan_save_track+0x14/0x30 (?:?)
>   kasan_save_free_info+0x3b/0x60 (?:?)
>   __kasan_slab_free+0x5f/0x80 (?:?)
>   kfree+0x30f/0x580 (?:?)
>   ocfs2_dismount_volume+0x168/0x560 (fs/ocfs2/super.c:1868)
>   generic_shutdown_super+0xc3/0x220 (fs/ocfs2/super.c:?)
>   kill_block_super+0x29/0x60 (fs/ocfs2/super.c:?)
>   deactivate_locked_super+0x66/0xe0 (fs/ocfs2/super.c:?)
>   cleanup_mnt+0x13d/0x210 (?:?)
>   task_work_run+0xfa/0x170 (?:?)
>   exit_to_user_mode_loop+0xd6/0x430 (?:?)
>   do_syscall_64+0x3cb/0x640 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
>
> Fixes: 5e7a3ed9f1a6 ("ocfs2: further debugfs cleanups")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> ---
>  fs/ocfs2/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index b875f01c9756..357f210b6a43 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1826,6 +1826,9 @@ static void ocfs2_dismount_volume(struct super_bloc=
k *sb, int mnt_err)
>
>         ocfs2_truncate_log_shutdown(osb);
>
> +       ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
> +       debugfs_remove_recursive(osb->osb_debug_root);
> +
>         /* This will disable recovery and flush any recovery work. */
>         ocfs2_recovery_exit(osb);
>
> @@ -1865,9 +1868,6 @@ static void ocfs2_dismount_volume(struct super_bloc=
k *sb, int mnt_err)
>
>         ocfs2_dlm_shutdown(osb, hangup_needed);
>
> -       ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
> -       debugfs_remove_recursive(osb->osb_debug_root);
> -
>         if (hangup_needed)
>                 ocfs2_cluster_hangup(osb->uuid_str, strlen(osb->uuid_str)=
);
>
> --
> 2.43.0
>
