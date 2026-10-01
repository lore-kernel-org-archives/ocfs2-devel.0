Received: from mail-yx2-f41.google.com (mail-yx2-f41.google.com [74.125.224.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7133449BD9D
	for <ocfs2-devel@lists.linux.dev>; Thu,  1 Oct 2026 08:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790843026; cv=pass; b=LQySQ6JCr+iXB4QOuX8F7Tup2tpgh21+nq8cVGfI2J61OQeZVXOylLbHETQvqFYUCdNWvdNt255YeLO+jpToMGn3c+z2YDqGT+xolT6DghpoR3pSfSx5bpkBA0LcZ/iYhr26WX3sM7FLu59/br2RYZwUMuFN+PR0BXE6rD5heEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790843026; c=relaxed/simple;
	bh=lHQDiiV/WUvzs9De5jG805tKo/GgvxYUYTY/p0xl4tw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IKmdpR1cPaXWw3qkbqLA3EINzSrgXmvorPFldIeKd4TbO6/aeE9nqBvZA0gLj4EWDAjysG2v+iqgUcAJj820vFBT8y+jFZxCE9gwDJqujm6mF0iOK5gmFdzOcc7Vn7Mt9nxXO8aEh/HHktnQYFNuCuwra5gncrUXX+5pt0gMzCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W9xwU16Q; arc=pass smtp.client-ip=74.125.224.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W9xwU16Q"
Received: by mail-yx2-f41.google.com with SMTP id 956f58d0204a3-67408b109e3so2919640d50.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 01 Oct 2026 01:23:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790843020; cv=none;
        d=google.com; s=arc-20260327;
        b=cLuegr56YZ0eAVoQ+1J4681yTJgBTsHqmQzDUl9OGE7Pqd2qTRymSA1YbOMJTol3yX
         lfTa8wQUJJ0m0m6l8PkgPWFQO9sLa1ODPU4ZbpR4rE46wdXQVpNHS0gCB2mGO+hHqr9N
         u3BGQzAQy8ViYEahYjnJxhttmZ81l9zA25VcCd78kO5dSpNdodPlBTNPa0GaCxyOmI8I
         ZthzZDfjIeVeDB0d9PYtb3wdQcWQHYe4F9UKoO/9LlhYRo95QO5LRaWuvvPlX+0FMC+p
         C87CErwVegikOWWFV1ewa5wXntNfKebrc8NinZnQohrlRVVKBhYyL8GdaMn+PhZM0nL3
         ap8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bbedR3iTIAKAz4DArSRZRO28ONnwzU/LJzRUQ18/bQU=;
        fh=FoVQ7U25fT9bHESHp8yl8blYsfmTjFrFUFBHpfDtcrA=;
        b=L+sEC4OPxVSwqRWiNUfibEREAOH9Z+E6j0F7+jsLvxeRBjOZoEeYl8dL8y5qJ7drLf
         rvfnOG7Wc/TSOJ+HgkTdXp7ZlM32RQEYzomhHHM4rXEZTJbv6uJqpga5+n33AhGIYw5s
         bWQX1ikj1JU4ZQ0yTNwfmk69v6cdW4PCJEadDqSL1mZPVYa3L1+/SiHotD7qn7yXWqIV
         UeSGP3PGZQ/KkdITmDpv1LPQKVCb68eT1NAM2+Iij0U5ntyxcsZA2Vo7ZZMhv4T5HL+P
         onqKLUAy95MGwfss5jtFZzvi/447bpZz+VGJdPhi+jKW79ImY4BPbFSqSxp/RDjU/Obo
         Jzrw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790843020; x=1791447820; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bbedR3iTIAKAz4DArSRZRO28ONnwzU/LJzRUQ18/bQU=;
        b=W9xwU16QcAhqg6KaAE38TJXIsPSn1xEe+2XUgwYHQqppkl0LVi+6h27/QnnMmlvLE4
         P01kwGyh+vc03pW5TnSotCmcj+JVK2KJlzIZonFFoGYgB8qiY3f7bCGW1QPQw50VJRcB
         V5O/19NOQSLb6Z+68VUyt4GuLblZm7wRD3ZNMESfXHSjBbUI1BzNt8xbywy4XT7pTMVt
         HpdnZypOcZCsH+6dmkWakLGmGK1UaHls6DWz/2TVRU8DpLTWsCKRquthKdI+Tor8jDnW
         jTm/c25UoIyow1x+9go8hDY0Lw5wrraX5PIYKPh7ZNc9wK4RwalIEeMZ8HaOjZwg0mHm
         AdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790843020; x=1791447820;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bbedR3iTIAKAz4DArSRZRO28ONnwzU/LJzRUQ18/bQU=;
        b=jEmpefWeivVOdXcbcMcpq/dk+J3asZR/2ZXBmRs7Onrwcl7dzwh21G/l7lAlaSzoUU
         mTBv8xzfUBTOwNWvVATqkv30QHC5UXQl8+4OCJMdhTSbQpYDAlQPTCJg1Hqt2R82ryDv
         64HBqJ+oDn4W09zpR2x5Bqcq8DEXTjPN2Sj/fdPYZW7w6wcpgwRHzpVgIUchRBKh50aH
         gXKQm78Ef7Gy9+TPQebI67MXpuMi3m/5Hq5KJ/usQ+2qhgINzsqjNo0kvg14KVQDFhs7
         Kg1hm5qda+s4j7NVfZdWqSvVy+LiDQt8d9ImZZlpA5J3ONxsUd8oo7l1DueEqUlZCHLk
         v+qg==
X-Forwarded-Encrypted: i=1; AKwUvBwwabmBeN+Np4JIYVEfNC3VfRrTJSSMRABKgfixLdxdvGIr6SSTAqLkoZaYYCbnwSXCB5+U9KvtnoYnZQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYLhRrY5b1RSPMQASx4HbjgNYkXch6If1eL+Rg3khDDSIH+bXodU
	0oz12xnweV12nno8Fy2Pcf5NFfeWUJpppnMA68W6LhDt6peXtp0rayS2CLdmtvmfMIYM8psgvcs
	kWVNbcdNfbd3YRezvy3v9tZtbCswHQ+0=
X-Gm-Gg: AYBFou3Y7s8OL99jXyzSQ1sJdkzVK3xymAf+naZdtceXQw2OGqDLny+HZ0OUgKtOQhd
	1YhTihL6KBk+RjFai6SjWe1VT7VXbRJAvT+9l8c0BF330j3qP+ngeXO6ldBcxissTLC6vJkSyjj
	Ca4GwFCsvfJILrNzET3YArVAkAQAuedun3xM691cbcx6xJ2D74i1wMvVGtDPnQLz73haU++p9TB
	jg74+iQG1wyurIChfQ3W9LPzGjPSGfEOxubpbeXN282ZVOAuJ57id0EEKeYHt+lN+Wa3SQO9QCO
	tDPpsiUPHBf5tpGvbOrNpJByBmI8XNNfGBcggIt9AgPLONhnUJOX1UAQlMPkbWG9KjBsXGl4Ubl
	sJqlw3B6x8elNR53QecrJXVjh2c/0/ILauFBIfBGtx8NBBkm/GvIIig==
X-Received: by 2002:a05:690e:480a:b0:675:34b8:78a9 with SMTP id
 956f58d0204a3-676910a8875mr566395d50.37.1790843020410; Thu, 01 Oct 2026
 01:23:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904235710.16317-1-kartikey406@gmail.com> <4f62bfee-857e-4343-a194-9afd6dceeca4@linux.alibaba.com>
In-Reply-To: <4f62bfee-857e-4343-a194-9afd6dceeca4@linux.alibaba.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Thu, 1 Oct 2026 13:53:28 +0530
X-Gm-Features: AclHuK98YRavuogSrofipE2fkk4-Usw-wEQF_cqkXn9it1rSmCFq2Bd0LASJrZI
Message-ID: <CADhLXY49iDq=pZCXwn8Mp_jL0Ty3WyQ+D6KLk-AynBLcXO=jiw@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix use-after-free in o2hb_region_dev_store
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, akpm@linux-foundation.org, 
	Heming Zhao <heming.zhao@suse.com>, brauner@kernel.org, jack@suse.cz, 
	zzzccc427@gmail.com, ericterminal@gmail.com, ocfs2-devel@lists.linux.dev, 
	christophe.jaillet@wanadoo.fr, linux-kernel@vger.kernel.org, 
	syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 5:37=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
>
>
>
> On 9/5/26 7:57 AM, Deepanshu Kartikey wrote:
> > Concurrent writes to a region's "dev" attribute can race, letting two
> > tasks both allocate/free reg->hr_slot_data for the same region and
> > causing a use-after-free. Add a per-region mutex to serialize
> > o2hb_region_dev_store() against itself and against
> > o2hb_region_release().
> >
>
> The description is too simple.
> Please describe the issue in detail, better with a race flow.
>

Two tasks can concurrently write to the same region's "dev" configfs
attribute, each through its own open fd.

The only guard against a second writer is an unlocked check near the
top of o2hb_region_dev_store():

    if (reg->hr_bdev_file)
            return -EINVAL;

This check happens well before hr_bdev_file is actually assigned --
several validation steps and an fd lookup sit in between. If a second
task runs this same check before the first task has gotten around to
assigning hr_bdev_file, it also reads NULL and also proceeds, even
though the first task has already committed to setting up this
region.

Both tasks then go on to call o2hb_map_slot_data(), which allocates
reg->hr_slot_data, and later, on any failure, o2hb_unmap_slot_data(),
which frees it. Since hr_slot_data is also unprotected, one task can
free it via its own failure path while the other task is still
populating or using the array it allocated, producing the
use-after-free seen in the syzbot report.



> > Fixes: 1d3aa0b97c55 ("ocfs2: port block device access to file")
>
> Why blames commit 1d3aa0b97c55? It seems it just renames hr_bdev_handle
> to hr_bdev_file and swaps bdev_release() for fput().
>

You're right, that commit is just the hr_bdev_handle -> hr_bdev_file
rename and the bdev_release() -> fput() swap, not the source of the
race. I'll update Fixes: in v2.


> > Reported-by: syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D3025e3e8fc0b928af8f5
> > Tested-by: syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
> > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> > ---
> >  fs/ocfs2/cluster/heartbeat.c | 23 +++++++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.=
c
> > index 1c3def99bb07..6f03de1b6d4a 100644
> > --- a/fs/ocfs2/cluster/heartbeat.c
> > +++ b/fs/ocfs2/cluster/heartbeat.c
> > @@ -273,6 +273,9 @@ struct o2hb_region {
> >
> >       /* last hb status, 0 for success, other value for error. */
> >       int                     hr_last_hb_status;
> > +     /* Serializes dev_store() against itself and region_release() */
> > +     struct mutex            hr_dev_write_mutex;
>
> Please use tab instead space.
>

I will this in v2

> > +
> >  };
> >
> >  static inline struct block_device *reg_bdev(struct o2hb_region *reg)
> > @@ -1616,7 +1619,10 @@ static void o2hb_region_release(struct config_it=
em *item)
> >
> >       o2hb_quiesce_timeout(reg);
> >       o2net_unregister_and_flush_handler_list(&reg->hr_handler_list);
> > +
> > +     mutex_lock(&reg->hr_dev_write_mutex);
> >       o2hb_unmap_slot_data(reg);
> > +     mutex_unlock(&reg->hr_dev_write_mutex);
> >
>
> Seems frag_sem in configfs serializes store and rmdir. So don't
> understand the race.
>

I'll drop the locking in
o2hb_region_release() in v2,  the mutex is only needed in
o2hb_region_dev_store() to guard against two concurrent stores.


> >       if (reg->hr_bdev_file)
> >               fput(reg->hr_bdev_file);
> > @@ -1879,9 +1885,6 @@ static ssize_t o2hb_region_dev_store(struct confi=
g_item *item,
> >       ssize_t ret =3D -EINVAL;
> >       int live_threshold;
> >
> > -     if (reg->hr_bdev_file)
> > -             return -EINVAL;
> > -
> >       /* We can't heartbeat without having had our node number
> >        * configured yet. */
> >       reg->hr_node_num =3D o2nm_this_node();
> > @@ -1906,12 +1909,20 @@ static ssize_t o2hb_region_dev_store(struct con=
fig_item *item,
> >       if (!S_ISBLK(fd_file(f)->f_mapping->host->i_mode))
> >               return -EINVAL;
> >
> > +     if (mutex_lock_interruptible(&reg->hr_dev_write_mutex))
> > +             return -ERESTARTSYS;
> > +
> > +     if (reg->hr_bdev_file) {
> > +             ret =3D -EINVAL;
> > +             goto out_unlock;
> > +     }
>
> This seems buggy.
> We have to do this before the hr_node_num assignment. Otherwise it will
> conflict with the logic in o2hb_region_dev_store().


You're right, I'll move the lock and hr_bdev_file check back to the
top, before hr_node_num is assigned, in v2.

>
> > +
> >       reg->hr_bdev_file =3D bdev_file_open_by_dev(fd_file(f)->f_mapping=
->host->i_rdev,
> >                       BLK_OPEN_WRITE | BLK_OPEN_READ, NULL, NULL);
> >       if (IS_ERR(reg->hr_bdev_file)) {
> >               ret =3D PTR_ERR(reg->hr_bdev_file);
> >               reg->hr_bdev_file =3D NULL;
> > -             return ret;
> > +             goto out_unlock;
> >       }
> >
> >       sectsize =3D bdev_logical_block_size(reg_bdev(reg));
> > @@ -2029,6 +2040,8 @@ static ssize_t o2hb_region_dev_store(struct confi=
g_item *item,
> >               fput(reg->hr_bdev_file);
> >               reg->hr_bdev_file =3D NULL;
> >       }
> > +out_unlock:
> > +     mutex_unlock(&reg->hr_dev_write_mutex);
> >       return ret;
> >  }
> >
> > @@ -2149,6 +2162,8 @@ static struct config_item *o2hb_heartbeat_group_m=
ake_item(struct config_group *g
> >
> >       config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type=
);
> >
> > +     mutex_init(&reg->hr_dev_write_mutex);
> > +
> >       /* this is the same way to generate msg key as dlm, for local hea=
rtbeat,
> >        * name is also the same, so make initial crc value different to =
avoid
> >        * message key conflict.
>
