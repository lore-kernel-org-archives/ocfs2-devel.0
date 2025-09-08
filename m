Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883BA30E0EC
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Sep 2025 15:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757345978; cv=none; b=q6nKsmS5i/tEbrMUBvNiTfwbdrZHXeXxoPwK0SF5sT4opu0uINzxMW4vkJLQaKHTGMxkz8ja2IF3/bMmU7ShGUoIi7njguDBFxqueAap0gcOyiCZTxfZG+ptyPrizzop7cX6dOknOONBa5d/2esTu/1lZsM4RBQGQ9WaaGdyURg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757345978; c=relaxed/simple;
	bh=mkS7Q2XXsAh/hnvFTx5Ju9PCADKOOyXqSzzlVMxjm3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JEVkUacHkpYG+UTw95D8LcCoDJ1nYyjwN/tRvjVEMWxaldFRXwiJRA998UmN4UzKw1GUBoSAR8LtdfwLkKX8lprBevC488oirHma+wG6MAtq3oXoyLkNFEFLlUAc1Z9+sBrFJ0jVVfom82YWdeaHIjRI8Ug6LIkewRrBAtQwY04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ci/FYrJv; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ci/FYrJv"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6228de280a4so4443516a12.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 08 Sep 2025 08:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757345975; x=1757950775; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HlYi0zuf18CTjrvUd8KAUPgIego6gfmKRVz1YHq0aBY=;
        b=Ci/FYrJviUMwQiSWXSDexdZHcGUvnpDeg/ekmeWNLYfdN6BdNitetofZrFMd1WXQM6
         hRtAnGxGqA4ftAk8oSpewBTOs368CFJGDzaHQvrfdx20N0rjKQ/d5x+o7J0g9qjBRA7S
         NJlCSgfLCrZsbigQQw5+nRDH55FEIGzOLmU2wvzzyEQuwNPRFKPWl+JKxl0r6y5IW2wd
         wR3hlZvaPIulHs+wJ7M3s2/+7FKwaU662FSLmcgefqrJ+j3UiiaeOg2j7uU0IyDJq86u
         f7z7wuFKa/2kiGkhfSAcj0eVYHGa7qYWnKGaF/Y/e0tkBh0sBDenu+W5vEJiNVZDrCgA
         5Xwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757345975; x=1757950775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HlYi0zuf18CTjrvUd8KAUPgIego6gfmKRVz1YHq0aBY=;
        b=XKE3DKy3TR9Zbi/CUJrXpuCVfqTxQemd5+1zAxZtwKdG4Ki1YGU5/0yPmUVQsO+PTb
         5bhTolN2zPFnkHSnWvyka/WuIhBlVFNJw5l8azeJbrNIypLEI7AmqJjMIPWJZpCtyWHN
         GTk+DrzWxG4DscPbBHn4KPBFvvf//6ywf2QsaztoH7F3GQAieTMXj5QBHS/e7utIZVWl
         Vyf16hMawMVZGCC4e1Akp/hpNsO/r6w0PInFtCsAqO+WTz+66rW6SmQV6D9fdm1RmfnO
         ypomgDK/sEkDsEbcrHEa3PgtISDlEoMS/LIzDxD4kk2FgLmfKw5h07NTwgr7zgpReQqW
         dIJg==
X-Forwarded-Encrypted: i=1; AJvYcCVz6l61pVOi2in4Vc/VRiFXRg8rcymQKJtBc26ldNCeND1b/16doEuai7uPKulMH5s+e+V/93+7kYaIiQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxvXYTUAgDwNu+nz83sjcKJ4rWsGELkqxq5Klz6sNGm7iQ15zR7
	Gz6X1x+Sm1rb4hiU3uT91VAdY5CS8uSmYJzsm6M1K36DcCs1pewinl8G4hq8PL0/bLaNQOr4LX9
	GsZKnhVNJEAOHDMvTvJRTVdF++c2dxcw=
X-Gm-Gg: ASbGncvoLHJLWsJMs3oAJLN4en9x2xYNCB0keh+kgLK2tqhpRHgJGjLxu+8YZIsKOsB
	ySnJkdYAQPwAbZVmHvGeYbbFI5kRN3FF0Xqj0wvyMIz6k3HKl1ABAKV88TYdrcJeL3mNT8WHwRo
	YKwXt8U0ySRnQdHFp1loesZHdXArSMlvfv2iWnvivTdOCzaS7kf2h07m2Za3PQ/4CUlAmd7X5PM
	CwG196tQOYw9CHwEw==
X-Google-Smtp-Source: AGHT+IGML91YmFHQAUDt0ahS98UGZdZ6TH072YQ585VVAQwaUmKdCU3wBiaMqQKljISwAsFDS8TgqDxeVR/5WQwPuXk=
X-Received: by 2002:a05:6402:3549:b0:62b:2899:5b31 with SMTP id
 4fb4d7f45d1cf-62b28995cabmr1224668a12.5.1757345974456; Mon, 08 Sep 2025
 08:39:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <766vdz3ecpm7hv4sp5r3uu4ezggm532ng7fdklb2nrupz6minz@qcws3ufabnjp>
 <20250904154245.644875-1-mjguzik@gmail.com> <f3671198-5231-41cf-b0bc-d1280992947a@oracle.com>
 <CAGudoHHT=P_UyZZpx5tBRHPE+irh1b7PxFXZAHjdHNLcEWOxAQ@mail.gmail.com>
 <8ddcaa59-0cf0-4b7c-a121-924105f7f5a6@linux.alibaba.com> <rvavp2omizs6e3qf6xpjpycf6norhfhnkrle4fq4632atgar5v@dghmwbctf2mm>
 <f9014fdb-95c8-4faa-8c42-c1ceea49cbd9@linux.alibaba.com> <fureginotssirocugn3aznor4vhbpadhwy7fhaxzeullhrzp7y@bg5gzdv6mrif>
In-Reply-To: <fureginotssirocugn3aznor4vhbpadhwy7fhaxzeullhrzp7y@bg5gzdv6mrif>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 8 Sep 2025 17:39:22 +0200
X-Gm-Features: AS18NWCDQLs5fysu8uWSj8ezNb9KhOg04xwtuZGK4FM2mMvAO4xkNE39g6GrKLU
Message-ID: <CAGudoHGui53Ryz1zunmd=G=Rr9cZOsWPFW7+GGBmxN4U_BNE4A@mail.gmail.com>
Subject: Re: [External] : [PATCH] ocfs2: retire ocfs2_drop_inode() and
 I_WILL_FREE usage
To: Jan Kara <jack@suse.cz>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Tinguely <mark.tinguely@oracle.com>, 
	ocfs2-devel@lists.linux.dev, viro@zeniv.linux.org.uk, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	josef@toxicpanda.com, jlbec@evilplan.org, mark@fasheh.com, brauner@kernel.org, 
	willy@infradead.org, david@fromorbit.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 8, 2025 at 3:54=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 08-09-25 20:41:21, Joseph Qi wrote:
> >
> >
> > On 2025/9/8 18:23, Jan Kara wrote:
> > > On Mon 08-09-25 09:51:36, Joseph Qi wrote:
> > >> On 2025/9/5 00:22, Mateusz Guzik wrote:
> > >>> On Thu, Sep 4, 2025 at 6:15=E2=80=AFPM Mark Tinguely <mark.tinguely=
@oracle.com> wrote:
> > >>>>
> > >>>> On 9/4/25 10:42 AM, Mateusz Guzik wrote:
> > >>>>> This postpones the writeout to ocfs2_evict_inode(), which I'm tol=
d is
> > >>>>> fine (tm).
> > >>>>>
> > >>>>> The intent is to retire the I_WILL_FREE flag.
> > >>>>>
> > >>>>> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> > >>>>> ---
> > >>>>>
> > >>>>> ACHTUNG: only compile-time tested. Need an ocfs2 person to ack it=
.
> > >>>>>
> > >>>>> btw grep shows comments referencing ocfs2_drop_inode() which are =
already
> > >>>>> stale on the stock kernel, I opted to not touch them.
> > >>>>>
> > >>>>> This ties into an effort to remove the I_WILL_FREE flag, unblocki=
ng
> > >>>>> other work. If accepted would be probably best taken through vfs
> > >>>>> branches with said work, see https://urldefense.com/v3/__https://=
git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=3Dvfs-6.18.inode=
.refcount.preliminaries__;!!ACWV5N9M2RV99hQ!OLwk8DVo7uvC-Pd6XVTiUCgP6MUDMKB=
MEyuV27h_yPGXOjaq078-kMdC9ILFoYQh-4WX93yb0nMfBDFFY_0$
> > >>>>>
> > >>>>>   fs/ocfs2/inode.c       | 23 ++---------------------
> > >>>>>   fs/ocfs2/inode.h       |  1 -
> > >>>>>   fs/ocfs2/ocfs2_trace.h |  2 --
> > >>>>>   fs/ocfs2/super.c       |  2 +-
> > >>>>>   4 files changed, 3 insertions(+), 25 deletions(-)
> > >>>>>
> > >>>>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > >>>>> index 6c4f78f473fb..5f4a2cbc505d 100644
> > >>>>> --- a/fs/ocfs2/inode.c
> > >>>>> +++ b/fs/ocfs2/inode.c
> > >>>>> @@ -1290,6 +1290,8 @@ static void ocfs2_clear_inode(struct inode =
*inode)
> > >>>>>
> > >>>>>   void ocfs2_evict_inode(struct inode *inode)
> > >>>>>   {
> > >>>>> +     write_inode_now(inode, 1);
> > >>>>> +
> > >>>>>       if (!inode->i_nlink ||
> > >>>>>           (OCFS2_I(inode)->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)=
) {
> > >>>>>               ocfs2_delete_inode(inode);
> > >>>>> @@ -1299,27 +1301,6 @@ void ocfs2_evict_inode(struct inode *inode=
)
> > >>>>>       ocfs2_clear_inode(inode);
> > >>>>>   }
> > >>>>>
> > >>>>> -/* Called under inode_lock, with no more references on the
> > >>>>> - * struct inode, so it's safe here to check the flags field
> > >>>>> - * and to manipulate i_nlink without any other locks. */
> > >>>>> -int ocfs2_drop_inode(struct inode *inode)
> > >>>>> -{
> > >>>>> -     struct ocfs2_inode_info *oi =3D OCFS2_I(inode);
> > >>>>> -
> > >>>>> -     trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
> > >>>>> -                             inode->i_nlink, oi->ip_flags);
> > >>>>> -
> > >>>>> -     assert_spin_locked(&inode->i_lock);
> > >>>>> -     inode->i_state |=3D I_WILL_FREE;
> > >>>>> -     spin_unlock(&inode->i_lock);
> > >>>>> -     write_inode_now(inode, 1);
> > >>>>> -     spin_lock(&inode->i_lock);
> > >>>>> -     WARN_ON(inode->i_state & I_NEW);
> > >>>>> -     inode->i_state &=3D ~I_WILL_FREE;
> > >>>>> -
> > >>>>> -     return 1;
> > >>>>> -}
> > >>>>> -
> > >>>>>   /*
> > >>>>>    * This is called from our getattr.
> > >>>>>    */
> > >>>>> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> > >>>>> index accf03d4765e..07bd838e7843 100644
> > >>>>> --- a/fs/ocfs2/inode.h
> > >>>>> +++ b/fs/ocfs2/inode.h
> > >>>>> @@ -116,7 +116,6 @@ static inline struct ocfs2_caching_info *INOD=
E_CACHE(struct inode *inode)
> > >>>>>   }
> > >>>>>
> > >>>>>   void ocfs2_evict_inode(struct inode *inode);
> > >>>>> -int ocfs2_drop_inode(struct inode *inode);
> > >>>>>
> > >>>>>   /* Flags for ocfs2_iget() */
> > >>>>>   #define OCFS2_FI_FLAG_SYSFILE               0x1
> > >>>>> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> > >>>>> index 54ed1495de9a..4b32fb5658ad 100644
> > >>>>> --- a/fs/ocfs2/ocfs2_trace.h
> > >>>>> +++ b/fs/ocfs2/ocfs2_trace.h
> > >>>>> @@ -1569,8 +1569,6 @@ DEFINE_OCFS2_ULL_ULL_UINT_EVENT(ocfs2_delet=
e_inode);
> > >>>>>
> > >>>>>   DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_clear_inode);
> > >>>>>
> > >>>>> -DEFINE_OCFS2_ULL_UINT_UINT_EVENT(ocfs2_drop_inode);
> > >>>>> -
> > >>>>>   TRACE_EVENT(ocfs2_inode_revalidate,
> > >>>>>       TP_PROTO(void *inode, unsigned long long ino,
> > >>>>>                unsigned int flags),
> > >>>>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > >>>>> index 53daa4482406..e4b0d25f4869 100644
> > >>>>> --- a/fs/ocfs2/super.c
> > >>>>> +++ b/fs/ocfs2/super.c
> > >>>>> @@ -129,7 +129,7 @@ static const struct super_operations ocfs2_so=
ps =3D {
> > >>>>>       .statfs         =3D ocfs2_statfs,
> > >>>>>       .alloc_inode    =3D ocfs2_alloc_inode,
> > >>>>>       .free_inode     =3D ocfs2_free_inode,
> > >>>>> -     .drop_inode     =3D ocfs2_drop_inode,
> > >>>>> +     .drop_inode     =3D generic_delete_inode,
> > >>>>>       .evict_inode    =3D ocfs2_evict_inode,
> > >>>>>       .sync_fs        =3D ocfs2_sync_fs,
> > >>>>>       .put_super      =3D ocfs2_put_super,
> > >>>>
> > >>>>
> > >>>> I agree, fileystems should not use I_FREEING/I_WILL_FREE.
> > >>>> Doing the sync write_inode_now() should be fine in ocfs_evict_inod=
e().
> > >>>>
> > >>>> Question is ocfs_drop_inode. In commit 513e2dae9422:
> > >>>>   ocfs2: flush inode data to disk and free inode when i_count beco=
mes zero
> > >>>> the return of 1 drops immediate to fix a memory caching issue.
> > >>>> Shouldn't .drop_inode() still return 1?
> > >>>
> > >>> generic_delete_inode is a stub doing just that.
> > >>>
> > >> In case of "drop =3D 0", it may return directly without calling evic=
t().
> > >> This seems break the expectation of commit 513e2dae9422.
> > >
> > > generic_delete_inode() always returns 1 so evict() will be called.
> > > ocfs2_drop_inode() always returns 1 as well after 513e2dae9422. So I'=
m not
> > > sure which case of "drop =3D 0" do you see...
> > >
> > I don't see a real case, just in theory.
> > As I described before, if we make sure write_inode_now() will be called
> > in iput_final(), it would be fine.
>
> I'm sorry but I still don't quite understand what you are proposing. If
> ->drop() returns 1, the filesystem wants to remove the inode from cache
> (perhaps because it was deleted). Hence iput_final() doesn't bother with
> writing out such inodes. This doesn't work well with ocfs2 wanting to
> always drop inodes hence ocfs2 needs to write the inode itself in
> ocfs2_evice_inode(). Perhaps you have some modification to iput_final() i=
n
> mind but I'm not sure how that would work so can you perhaps suggest a
> patch if you think iput_final() should work differently? Thanks!
>

I think generic_delete_inode is a really bad name for what the routine
is doing and it perhaps contributes to the confusion in the thread.

Perhaps it could be renamed to inode_op_stub_always_drop or similar? I
don't for specifics, apart from explicitly stating that the return
value is to drop and bonus points for a prefix showing this is an
inode thing.

--=20
Mateusz Guzik <mjguzik gmail.com>
