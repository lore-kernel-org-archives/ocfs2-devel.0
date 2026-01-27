Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05CC1F1513
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Jan 2026 00:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769475418; cv=pass; b=X4e7ClTtqwE8qkPt3uG8CTdyZ9YcKjk16CkP7gNG5UfBHcgbFsrtX+dmBF0vkSQQr5712M3KNWbrZx+lVg/jLLs8gOllSNIt1kAw1M2YMTwahx1zkvGXYaf3jEOTmWAAmBtyUHRyqq11+e4xn+PmST+ewH7jCdWzu36QQARyqI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769475418; c=relaxed/simple;
	bh=M7AIuDgpfxm84BpjBY6Y6bq5K2LBOrKkxU4MJnN61LQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kTSsN2ELoEiuerITZJ3J4RST/zyLtsAQlKhS6rF1uRUdBJ70fc0f+hsa4VB6LlAGgcb3840CDtXVxwu6XeoXGsH9IZQv0Ie4qAUSWk2ghKZIlyiKXpCd4eK+liu1s5Ln3KSSGTjbUhN+qL9TcFD2hJ+KqoBAGFmsrvkIydvKsTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MATsCuKl; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MATsCuKl"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65812261842so9902910a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 26 Jan 2026 16:56:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769475414; cv=none;
        d=google.com; s=arc-20240605;
        b=T3BvENox2Wd6aMB+0C3og4iK4/Osc7oTblKCu5707u1ATWZxHlcLmQGI+T+VlOSto4
         Qx9/Jz/ZYxHdDgT+ggDz63WdSQVfct/cp1ATSD1NEz4k8+hXub97d28XRApz/NbAElQA
         5CUiYav5y7/CJoCdcHG9C8cq9iJhrrMCYGMmcgdCh6+YhLikwigXBPAmL7sDuirMTJ74
         uDYX8RL4OgNA3CVrtbIGTzlO07VtklIKHHqX7pocZkTaOkQNwU/gWytGFRMHBFYNfo3R
         YrnOAQJl5xSwk2Ji1gMycd+7nRWxJ/gdiqtkSbU/RETOtmNl4GNNKYML54O2Mm4Y+Hf9
         jGtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3zLfNFu5Ej89ae2FOVFTz6sNNJ0wH6QKfxg5HAX5ASo=;
        fh=vALrUOFK3ZtviWTm17p8i7JWUtu7OrGkvjaJMC1I4DQ=;
        b=lYc0Wg19jHN8sw/bztgHqVrRc989ZRfFsoWw30IdBGYZHKNLrdDTfojBSvFuqH1C53
         BILCZIVuMjp/ymlVZHt7/nM/XyM5TY37gBVBiXpODI6q4i0qxHJitBCClMyXNlP8tU6w
         haPcAA6cuyskww8cRY12DG1qrbIyC+qT/li7smBjOt85xiD1avabYHzTtWZwDYOM1Ww1
         zCNg460YgKvEr1qx3W1N2pwg1i/Fn89qfToprrTXIjZRoa1MigDia0CrS0q3eQN9Opyj
         A4ngQp73ow++n27K3x42alqwIrUXDhai7NQsoSzhoVJTZ9iMzKXQnWXT1fZPcG47glSI
         eNSQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769475414; x=1770080214; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3zLfNFu5Ej89ae2FOVFTz6sNNJ0wH6QKfxg5HAX5ASo=;
        b=MATsCuKlisnMdbKIbKxiNp5cITvhC8abndxVeo08kKE4Vz0i0YcQTgsq3bO1E/c4b+
         6ZKGLbavqdoyjQGaddZkh7L/hueba+nJ5JQhxDYwutwNDpm3FunGaOvzQMrRCVtY2XDA
         foXcUOUZ8XB0wdUpZH4eSOuHGiF+WVhbjJC5dg4FGiflVyRjS3+9yem+Ahvb3ZWoZ9hQ
         tRsvCN7FTjfMMo1ba1w1VFcOV0m4MQ8NhHVLHtoSumsAYxDA2hfqweqrh6GdijxstHS6
         5J3W57TpFoddWy1H4f+SVH9Dto86YsyOteU8uwZtbZDTkuNmtf8CPBkSZ+yHkYpCY91L
         O8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769475414; x=1770080214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3zLfNFu5Ej89ae2FOVFTz6sNNJ0wH6QKfxg5HAX5ASo=;
        b=BZGaLIR3e2EfbzF9h+HM3Tgva/FWxy9JcsmzdyE2Oxk9NcdrKnuosZUApkEClioHCO
         5Ps9Filx7PRYOndcgK06tTvq4FcJTEWkEJRdhMNn06JJWo/cXi/YGekZfOWIBTufL2EK
         GOOfi83sMGMB1dgp1G2cFGmqDqK9QpRlroPjoOmXPVnDTW+mY8pjL21BB5TQXJ8JDcHe
         YER+IrghQkrzNwalynVBVknynJJUNILOj0enT1ODFDZBXP0b26x7Cam6ELttE6sp4ELQ
         sUFbgXlAmysxiDq1F7uy1NT6lB9W+uiYMowaiEfBCYEWrZbT+QNeO6/ymlZxGcmkF3Tc
         GWDA==
X-Forwarded-Encrypted: i=1; AJvYcCVcGQza5HRONqSdlDyp+nFd/DgYxPDTC5WnFEN9Y4VIwNKdSTifDLAYYkDS8CsrGBppeAyHV+wfqYd5Eg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyCW3oUuW6W+4B6PGbesBcj2cOgWORxCu3BtZ8UFNlFIz56MpbT
	NEyIePpZ3Ra3xYnU3KTen4zzOUBGpyj450VuLAMuEcgdEfWJw7gwHMEaRTKjG7xIdrxM3Lv4vpc
	UcRmhhrgEeFPJ4FxKrtdZIGmOKqZjduwpaO0mHNUe
X-Gm-Gg: AZuq6aIdEmAeHXhpCmPyRE3lqA1Ln48xgLB9JgQn91E5CT6qW8gtjFFbYYaplFrg3CC
	13hiON+bG0Oc2y2vE7k5+Lbyr4+E1nZXXl7EbQrFAuHj8EYYbHjwubl2ydyCPjfKMbKUnJuKOZa
	gDJFLUQrIHQMN8Uk8gGCwNwZhtNQf9rlonvi5AAX6T/kOHyiXbAaJvHMHLRJ/On60iBahryFd6U
	x33YLHObmSm7cYvRMqtZJqlmtNHNSw4Xx6qfsNq16s4/vpdx7IBgO6LMS41PGiBeTq+iGlWcKVp
	GSNuPe/qxNDy7IQpek7oX77FN3Rzkg==
X-Received: by 2002:a17:907:3e1f:b0:b70:4f7d:24f8 with SMTP id
 a640c23a62f3a-b8ceef90390mr472102366b.22.1769475414121; Mon, 26 Jan 2026
 16:56:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
From: Samuel Wu <wusamuel@google.com>
Date: Mon, 26 Jan 2026 16:56:42 -0800
X-Gm-Features: AZwV_QiBMrJYd91OXm8P7lUFLNbyvK6EaRwh_3htJKxjg87yoCQ5TeewXmGGNPs
Message-ID: <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 9:15=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> Some filesystems use a kinda-sorta controlled dentry refcount leak to pin
> dentries of created objects in dcache (and undo it when removing those).
> Reference is grabbed and not released, but it's not actually _stored_
> anywhere.  That works, but it's hard to follow and verify; among other
> things, we have no way to tell _which_ of the increments is intended
> to be an unpaired one.  Worse, on removal we need to decide whether
> the reference had already been dropped, which can be non-trivial if
> that removal is on umount and we need to figure out if this dentry is
> pinned due to e.g. unlink() not done.  Usually that is handled by using
> kill_litter_super() as ->kill_sb(), but there are open-coded special
> cases of the same (consider e.g. /proc/self).
>
> Things get simpler if we introduce a new dentry flag (DCACHE_PERSISTENT)
> marking those "leaked" dentries.  Having it set claims responsibility
> for +1 in refcount.
>
> The end result this series is aiming for:
>
> * get these unbalanced dget() and dput() replaced with new primitives tha=
t
>   would, in addition to adjusting refcount, set and clear persistency fla=
g.
> * instead of having kill_litter_super() mess with removing the remaining
>   "leaked" references (e.g. for all tmpfs files that hadn't been removed
>   prior to umount), have the regular shrink_dcache_for_umount() strip
>   DCACHE_PERSISTENT of all dentries, dropping the corresponding
>   reference if it had been set.  After that kill_litter_super() becomes
>   an equivalent of kill_anon_super().
>
> Doing that in a single step is not feasible - it would affect too many pl=
aces
> in too many filesystems.  It has to be split into a series.
>
> This work has really started early in 2024; quite a few preliminary piece=
s
> have already gone into mainline.  This chunk is finally getting to the
> meat of that stuff - infrastructure and most of the conversions to it.
>
> Some pieces are still sitting in the local branches, but the bulk of
> that stuff is here.
>
> Compared to v3:
>         * fixed a functionfs braino around ffs_epfiles_destroy() (in #40/=
54,
> used to be #36/50).
>         * added fixes for a couple of UAF in functionfs (##36--39); that
> does *NOT* include any fixes for dmabuf bugs Chris posted last week, thou=
gh.
>
> The branch is -rc5-based; it lives in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.persiste=
ncy
> individual patches in followups.
>
> Please, help with review and testing.  If nobody objects, in a few days i=
t
> goes into #for-next.
>
> Shortlog:
>       fuse_ctl_add_conn(): fix nlink breakage in case of early failure
>       tracefs: fix a leak in eventfs_create_events_dir()
>       new helper: simple_remove_by_name()
>       new helper: simple_done_creating()
>       introduce a flag for explicitly marking persistently pinned dentrie=
s
>       primitives for maintaining persisitency
>       convert simple_{link,unlink,rmdir,rename,fill_super}() to new primi=
tives
>       convert ramfs and tmpfs
>       procfs: make /self and /thread_self dentries persistent
>       configfs, securityfs: kill_litter_super() not needed
>       convert xenfs
>       convert smackfs
>       convert hugetlbfs
>       convert mqueue
>       convert bpf
>       convert dlmfs
>       convert fuse_ctl
>       convert pstore
>       convert tracefs
>       convert debugfs
>       debugfs: remove duplicate checks in callers of start_creating()
>       convert efivarfs
>       convert spufs
>       convert ibmasmfs
>       ibmasmfs: get rid of ibmasmfs_dir_ops
>       convert devpts
>       binderfs: use simple_start_creating()
>       binderfs_binder_ctl_create(): kill a bogus check
>       convert binderfs
>       autofs_{rmdir,unlink}: dentry->d_fsdata->dentry =3D=3D dentry there
>       convert autofs
>       convert binfmt_misc
>       selinuxfs: don't stash the dentry of /policy_capabilities
>       selinuxfs: new helper for attaching files to tree
>       convert selinuxfs
>       functionfs: don't abuse ffs_data_closed() on fs shutdown
>       functionfs: don't bother with ffs->ref in ffs_data_{opened,closed}(=
)
>       functionfs: need to cancel ->reset_work in ->kill_sb()
>       functionfs: fix the open/removal races
>       functionfs: switch to simple_remove_by_name()
>       convert functionfs
>       gadgetfs: switch to simple_remove_by_name()
>       convert gadgetfs
>       hypfs: don't pin dentries twice
>       hypfs: switch hypfs_create_str() to returning int
>       hypfs: swich hypfs_create_u64() to returning int
>       convert hypfs
>       convert rpc_pipefs
>       convert nfsctl
>       convert rust_binderfs
>       get rid of kill_litter_super()
>       convert securityfs
>       kill securityfs_recursive_remove()
>       d_make_discardable(): warn if given a non-persistent dentry
>
> Diffstat:
>  Documentation/filesystems/porting.rst     |   7 ++
>  arch/powerpc/platforms/cell/spufs/inode.c |  17 ++-
>  arch/s390/hypfs/hypfs.h                   |   6 +-
>  arch/s390/hypfs/hypfs_diag_fs.c           |  60 ++++------
>  arch/s390/hypfs/hypfs_vm_fs.c             |  21 ++--
>  arch/s390/hypfs/inode.c                   |  82 +++++--------
>  drivers/android/binder/rust_binderfs.c    | 121 ++++++-------------
>  drivers/android/binderfs.c                |  82 +++----------
>  drivers/base/devtmpfs.c                   |   2 +-
>  drivers/misc/ibmasm/ibmasmfs.c            |  24 ++--
>  drivers/usb/gadget/function/f_fs.c        | 144 +++++++++++++----------
>  drivers/usb/gadget/legacy/inode.c         |  49 ++++----
>  drivers/xen/xenfs/super.c                 |   2 +-
>  fs/autofs/inode.c                         |   2 +-
>  fs/autofs/root.c                          |  11 +-
>  fs/binfmt_misc.c                          |  69 ++++++-----
>  fs/configfs/dir.c                         |  10 +-
>  fs/configfs/inode.c                       |   3 +-
>  fs/configfs/mount.c                       |   2 +-
>  fs/dcache.c                               | 111 +++++++++++-------
>  fs/debugfs/inode.c                        |  32 ++----
>  fs/devpts/inode.c                         |  57 ++++-----
>  fs/efivarfs/inode.c                       |   7 +-
>  fs/efivarfs/super.c                       |   5 +-
>  fs/fuse/control.c                         |  38 +++---
>  fs/hugetlbfs/inode.c                      |  12 +-
>  fs/internal.h                             |   1 -
>  fs/libfs.c                                |  52 +++++++--
>  fs/nfsd/nfsctl.c                          |  18 +--
>  fs/ocfs2/dlmfs/dlmfs.c                    |   8 +-
>  fs/proc/base.c                            |   6 +-
>  fs/proc/internal.h                        |   1 +
>  fs/proc/root.c                            |  14 +--
>  fs/proc/self.c                            |  10 +-
>  fs/proc/thread_self.c                     |  11 +-
>  fs/pstore/inode.c                         |   7 +-
>  fs/ramfs/inode.c                          |   8 +-
>  fs/super.c                                |   8 --
>  fs/tracefs/event_inode.c                  |   7 +-
>  fs/tracefs/inode.c                        |  13 +--
>  include/linux/dcache.h                    |   4 +-
>  include/linux/fs.h                        |   6 +-
>  include/linux/proc_fs.h                   |   2 -
>  include/linux/security.h                  |   2 -
>  init/do_mounts.c                          |   2 +-
>  ipc/mqueue.c                              |  12 +-
>  kernel/bpf/inode.c                        |  15 +--
>  mm/shmem.c                                |  38 ++----
>  net/sunrpc/rpc_pipe.c                     |  27 ++---
>  security/apparmor/apparmorfs.c            |  13 ++-
>  security/inode.c                          |  35 +++---
>  security/selinux/selinuxfs.c              | 185 +++++++++++++-----------=
------
>  security/smack/smackfs.c                  |   2 +-
>  53 files changed, 649 insertions(+), 834 deletions(-)
>
>         Overview:
>
> First two commits are bugfixes (fusectl and tracefs resp.)
>
> [1/54] fuse_ctl_add_conn(): fix nlink breakage in case of early failure
> [2/54] tracefs: fix a leak in eventfs_create_events_dir()
>
> Next, two commits adding a couple of useful helpers, the next three addin=
g
> the infrastructure and the rest consists of per-filesystem conversions.
>
> [3/54] new helper: simple_remove_by_name()
> [4/54] new helper: simple_done_creating()
>         end_creating_path() analogue for internal object creation; unlike
> end_creating_path() no mount is passed to it (or guaranteed to exist, for
> that matter - it might be used during the filesystem setup, before the
> superblock gets attached to any mounts).
>
> Infrastructure:
> [5/54] introduce a flag for explicitly marking persistently pinned dentri=
es
>         * introduce the new flag
>         * teach shrink_dcache_for_umount() to handle it (i.e. remove
> and drop refcount on anything that survives to umount with that flag
> still set)
>         * teach kill_litter_super() that anything with that flag does
> *not* need to be unpinned.
> [6/54] primitives for maintaining persisitency
>         * d_make_persistent(dentry, inode) - bump refcount, mark persiste=
nt
> and make hashed positive.  Return value is a borrowed reference to dentry=
;
> it can be used until something removes persistency (at the very least,
> until the parent gets unlocked, but some filesystems may have stronger
> exclusion).
>         * d_make_discardable() - remove persistency mark and drop referen=
ce.
>
> NOTE: at that stage d_make_discardable() does not reject dentries not
> marked persistent - it acts as if the mark been set.
>
> Rationale: less noise in series splitup that way.  We want (and on the
> next commit will get) simple_unlink() to do the right thing - remove
> persistency, if it's there.  However, it's used by many filesystems.
> We would have either to convert them all at once or split simple_unlink()
> into "want persistent" and "don't want persistent" versions, the latter
> being the old one.  In the course of the series almost all callers
> would migrate to the replacement, leaving only two pathological cases
> with the old one.  The same goes for simple_rmdir() (two callers left in
> the end), simple_recursive_removal() (all callers gone in the end), etc.
> That's a lot of noise and it's easier to start with d_make_discardable()
> quietly accepting non-persistent dentries, then, in the end, add private
> copies of simple_unlink() and simple_rmdir() for two weird users (configf=
s
> and apparmorfs) and have those use dput() instead of d_make_discardable()=
.
> At that point we'd be left with all callers of d_make_discardable()
> always passing persistent dentries, allowing to add a warning in it.
>
> [7/54] convert simple_{link,unlink,rmdir,rename,fill_super}() to new prim=
itives
>         See above re quietly accepting non-peristent dentries in
> simple_unlink(), simple_rmdir(), etc.
>
>         Converting filesystems:
> [8/54] convert ramfs and tmpfs
> [9/54] procfs: make /self and /thread_self dentries persistent
> [10/54] configfs, securityfs: kill_litter_super() not needed
> [11/54] convert xenfs
> [12/54] convert smackfs
> [13/54] convert hugetlbfs
> [14/54] convert mqueue
> [15/54] convert bpf
> [16/54] convert dlmfs
> [17/54] convert fuse_ctl
> [18/54] convert pstore
> [19/54] convert tracefs
> [20/54] convert debugfs
> [21/54] debugfs: remove duplicate checks in callers of start_creating()
> [22/54] convert efivarfs
> [23/54] convert spufs
> [24/54] convert ibmasmfs
> [25/54] ibmasmfs: get rid of ibmasmfs_dir_ops
> [26/54] convert devpts
> [27/54] binderfs: use simple_start_creating()
> [28/54] binderfs_binder_ctl_create(): kill a bogus check
> [29/54] convert binderfs
> [30/54] autofs_{rmdir,unlink}: dentry->d_fsdata->dentry =3D=3D dentry the=
re
> [31/54] convert autofs
> [32/54] convert binfmt_misc
> [33/54] selinuxfs: don't stash the dentry of /policy_capabilities
> [34/54] selinuxfs: new helper for attaching files to tree
> [35/54] convert selinuxfs
>
>         Several functionfs fixes, before converting it, to make life
> simpler for backporting:
> [36/54] functionfs: don't abuse ffs_data_closed() on fs shutdown
> [37/54] functionfs: don't bother with ffs->ref in ffs_data_{opened,closed=
}()
> [38/54] functionfs: need to cancel ->reset_work in ->kill_sb()
> [39/54] functionfs: fix the open/removal races
>
>         ... and back to filesystems conversions:
>
> [40/54] functionfs: switch to simple_remove_by_name()
> [41/54] convert functionfs
> [42/54] gadgetfs: switch to simple_remove_by_name()
> [43/54] convert gadgetfs
> [44/54] hypfs: don't pin dentries twice
> [45/54] hypfs: switch hypfs_create_str() to returning int
> [46/54] hypfs: swich hypfs_create_u64() to returning int
> [47/54] convert hypfs
> [48/54] convert rpc_pipefs
> [49/54] convert nfsctl
> [50/54] convert rust_binderfs
>
>         ... and no kill_litter_super() callers remain, so we
> can take it out:
> [51/54] get rid of kill_litter_super()
>
>         Followups:
> [52/54] convert securityfs
>         That was the last remaining user of simple_recursive_removal()
> that did *not* mark things persistent.  Now the only places where
> d_make_discardable() is still called for dentries that are not marked
> persistent are the calls of simple_{unlink,rmdir}() in configfs and
> apparmorfs.
>
> [53/54] kill securityfs_recursive_remove()
>         Unused macro...
>
> [54/54] d_make_discardable(): warn if given a non-persistent dentry
>
> At this point there are very few call chains that might lead to
> d_make_discardable() on a dentry that hadn't been made persistent:
> calls of simple_unlink() and simple_rmdir() in configfs and
> apparmorfs.
>
> Both filesystems do pin (part of) their contents in dcache, but
> they are currently playing very unusual games with that.  Converting
> them to more usual patterns might be possible, but it's definitely
> going to be a long series of changes in both cases.
>
> For now the easiest solution is to have both stop using simple_unlink()
> and simple_rmdir() - that allows to make d_make_discardable() warn
> when given a non-persistent dentry.
>
> Rather than giving them full-blown private copies (with calls of
> d_make_discardable() replaced with dput()), let's pull the parts of
> simple_unlink() and simple_rmdir() that deal with timestamps and link
> counts into separate helpers (__simple_unlink() and __simple_rmdir()
> resp.) and have those used by configfs and apparmorfs.
>

Hi Al, when I apply this patchset my Pixel 6 no longer enumerates on
lsusb or ADB. It was quite hard to bisect to this point, as this is
non-deterministic and seems to be setup specific. Note, I am using
android-mainline, but my understanding is that this build does not
have any out-of-tree USB patches, and that there are no vendor hooks
in the build.

My apologies as I can't offer any other clues; there are no obviously
bad dmesg logs and I'm still working on narrowing down the exact
commit(s) that started this, but just wanted to send a FYI in case
something stands out as obvious.

Thanks!
Sam
