Received: from mail-yx2-f21.google.com (mail-yx2-f21.google.com [74.125.224.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B27A388E60
	for <ocfs2-devel@lists.linux.dev>; Wed, 23 Sep 2026 03:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.149
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790133985; cv=pass; b=fMXNi6x3F1jSMfbc5jL1wTuXSm7XZw6736lUR3cCk6VS+WBVxuTZXdiFVvfA0uc8xoAqv8sR7XCiCRpUlJjEQoXUF6BmmY9OhJzu/7c1mRBgXo036Ew5of/xeGYyWEwYDqplo/YRrOkCOKFhdzc+tg8kzpbFQiqBj5qf3EEwgeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790133985; c=relaxed/simple;
	bh=Omg5KR0EjDJz43MkkDKOw8fxlg1xqr/mciolGS1iQF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jN+xqttmF0LyunuQzdC0MfNhXyXekH2GA0GwEkEDL51FW1sJyc8HT4lAzyEjIgAXGuy6m1b3hYXoEZG/ORd4E8ut2PU3ZLBFOB3IRc/TjrCzrjOKkDgXjnMbTUDwe6GXxTJ7NU5uhWbau8eGmXwnKumBkb4/XDsudRyhyOe+ULQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jSLzJKwL; arc=pass smtp.client-ip=74.125.224.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jSLzJKwL"
Received: by mail-yx2-f21.google.com with SMTP id 956f58d0204a3-66e4ab1b9f7so241086d50.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 22 Sep 2026 20:26:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790133983; cv=none;
        d=google.com; s=arc-20260327;
        b=mtw6qG6YbOlrheJBeekl0rOMpmX7OntH8MXj/GOwPWx6nRUSJXvAN2LvpXEkIwZth6
         yakyUSb+W1d+BI2n8Glw/MK3JqRLywieOCLPAVrBXY9KuWtI5ngnphF1vdA9d81ktkBW
         Ce4FntmlSvTuIFdnUKCnvlSfzbu/9zTfFlR1CmudMNwuHHMer43Z8siSwIYi7dr9gDmk
         nCUDlOgLX8nQpyLU9tpaLSTBz5diSRABqwpNKG8UwHM3UFMtxm8xbtMpix/9Ik9pkanp
         gGdqO0KZABuOD7BPvULjgNGzTUrNe3F0IKD6kvnS+Ub4SGmx4kN/YsMo8n1PxAVoNTaZ
         gUFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TlVDedwOJszRf8guxkWv3WTHF9ytNYNROgU4kKLvbvI=;
        fh=Ov1/S4e2JfMwRWq+3MtCtdxkgPpp01mB3rNZXfesrNk=;
        b=qrLzhqVIS/Rn0C7zpnUBKLVzPOdvf53Fyot9o2a0+BrkcFk8yoEIGqGnxV48QCNrvn
         9PjMsyIz17gOw7jhF8trepMZmVFNua3pVd0oR+GIlXy43W4RM0LvgVJnuEWssbdy3yXB
         Ufs4yWLyCh5wu98CP1r1xLyq5XCUUGCoQO/SRIW51Cq8uoo/f4/pZJ6WzPAMvfuqg0Ne
         8iBmA0tLs+aWGsgRPydQIoOOhar6qJcAaup46qnCADCxrZpWC7LD0OIyKgH4Vb7ws+ZO
         CVugZoxx4C2EeukDP7FyiTExwiUjH/vQz0u7B7sTygCk2l+sBDxA2BodClPG/gNHOm8b
         I5Ew==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790133983; x=1790738783; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TlVDedwOJszRf8guxkWv3WTHF9ytNYNROgU4kKLvbvI=;
        b=jSLzJKwLoQsThUjIBjvICbNvGnfo4mm2K4E1DWu5/vfAZKny0VoI3FCJYJhR31BSn+
         +SdFun+FGRRlG1KhYoW7aWGkXtkM58pjv/Z2DNHzavXgt0KReIK15kOcAcijYsfD0nXs
         KuWCXVS5i8eP1gEksq6Yh8GBGKdqAwu9EszAgvJqDl0Gua1Oyd7EXoZFpJYroPjE/q3l
         CwzZms5M2S+rjKvy/G5J6Zj6qBdjzSy5WCd3T8FoJE3sIaA+sOXqdPCoyoK76lOLAQ/l
         2DGysodyapWOV0a6Tcn1DHTXgRnE0aEcUbYGtdVJKNHIer1y6Al4VAxy+g8aGxNmUaVW
         E50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790133983; x=1790738783;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TlVDedwOJszRf8guxkWv3WTHF9ytNYNROgU4kKLvbvI=;
        b=FjItSpWUk3nJ6Im9lcArPoYg4I0jccpGf7XuIMds/KGgM2LuzBqX/DP7Gq3E77d1lx
         aXHx+msRGwxBcB9YAQt1Sm1ID8sDvjwkKbHOniwWpWBR2HfNrfi58eGKPR/ZPQqbVUdp
         ArLSSdVXTY2UqVwUWItUzttlnediRTdVGUHEnhu7tQE2QMD2xgYUYIrmHtz4pXilcIJH
         NVvUA8PBmmfcpq4tkVReub0yzUQRS0O/hWyRMqVHsBKZcBPe7didhTsd5wMlbuN6pdDc
         PakXXyrr/FOXwgu5IzmUKJyJWwaQV22iFnvkBSJZ0TASYAVutJBVfNbzr9XbtWDFKUTd
         astw==
X-Forwarded-Encrypted: i=1; AKwUvBylEGEDMCp/t60QbsaVTs12q5u8PZKlLjwhJexq2SWyk0zOdY4o4RW0raCnFlYuABbEOOSjr6FdGtMEjg==@lists.linux.dev
X-Gm-Message-State: AFuF++ndUkfDvW6JYocJwp3XD2slg5Mwjxx8LuF9y/jyYjxCZIubmNoi
	q//USSBy3wk5mupf4UkkmPq7nUMYErgytabCLm74S0AbEp2914OHAyvRdg8sT8lfFehRy6uJ5GM
	KZRdyyBvfCF09jRkyjq5TftXAz6uXspI=
X-Gm-Gg: AYBFou2WLbMHf8Wy73LQhV156vzFsRx8bxYcgMkCV0VdKuUi7jFJkHf4Ls8YDbEU2/9
	E4QIL7RvOfqbxZI9n8zXRDz7MCsZKUBSGqD4ZShUXJlymF/XKHnaG4E6n05mHLCMB91ssC5vFTN
	14ATTPHHlMfVIMn8Tw8NmYlJdg+7PSOsrse7nKnCeq3JmUauSeAlcylb33SnwbJHHNIHDDa+mMG
	K9IX5w2jkcbs5+1CPzCKzXX4TBr28tSJ0JMLVZ1t5tRxCzlKrM2abjh95MzjBIGz3iGu+zLQRZB
	YgZhf0KR5vx7boXJvxCoNY45CGVHfv14eM3y38t4RhjbdyZjZbWsUNoH4iN2195w9BfGqlBvrF5
	aebsCnFKkInttUG/iMddum1++FckPEPxiAk/9OmQdYVA=
X-Received: by 2002:a05:690e:1444:b0:671:484e:5686 with SMTP id
 956f58d0204a3-672d58aaec2mr765014d50.20.1790133983287; Tue, 22 Sep 2026
 20:26:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904235710.16317-1-kartikey406@gmail.com>
In-Reply-To: <20260904235710.16317-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 23 Sep 2026 08:56:12 +0530
X-Gm-Features: AcwNN1Xi3pr9-XNdJGHdMuy6-rNdPWkFL914JN79XvGB6zt_znFheaWLnKBIk6Q
Message-ID: <CADhLXY6+vNT5UaeczdDsXC-wrDeotaj6ngpaKcN+vrjfELDmsw@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix use-after-free in o2hb_region_dev_store
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	akpm@linux-foundation.org, brauner@kernel.org, jack@suse.cz
Cc: zzzccc427@gmail.com, ericterminal@gmail.com, ocfs2-devel@lists.linux.dev, 
	christophe.jaillet@wanadoo.fr, linux-kernel@vger.kernel.org, 
	syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 5, 2026 at 5:27=E2=80=AFAM Deepanshu Kartikey <kartikey406@gmai=
l.com> wrote:
>
> Concurrent writes to a region's "dev" attribute can race, letting two
> tasks both allocate/free reg->hr_slot_data for the same region and
> causing a use-after-free. Add a per-region mutex to serialize
> o2hb_region_dev_store() against itself and against
> o2hb_region_release().
>
> Fixes: 1d3aa0b97c55 ("ocfs2: port block device access to file")
> Reported-by: syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D3025e3e8fc0b928af8f5
> Tested-by: syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 1c3def99bb07..6f03de1b6d4a 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -273,6 +273,9 @@ struct o2hb_region {
>
>         /* last hb status, 0 for success, other value for error. */
>         int                     hr_last_hb_status;
> +       /* Serializes dev_store() against itself and region_release() */
> +       struct mutex            hr_dev_write_mutex;
> +
>  };
>
>  static inline struct block_device *reg_bdev(struct o2hb_region *reg)
> @@ -1616,7 +1619,10 @@ static void o2hb_region_release(struct config_item=
 *item)
>
>         o2hb_quiesce_timeout(reg);
>         o2net_unregister_and_flush_handler_list(&reg->hr_handler_list);
> +
> +       mutex_lock(&reg->hr_dev_write_mutex);
>         o2hb_unmap_slot_data(reg);
> +       mutex_unlock(&reg->hr_dev_write_mutex);
>
>         if (reg->hr_bdev_file)
>                 fput(reg->hr_bdev_file);
> @@ -1879,9 +1885,6 @@ static ssize_t o2hb_region_dev_store(struct config_=
item *item,
>         ssize_t ret =3D -EINVAL;
>         int live_threshold;
>
> -       if (reg->hr_bdev_file)
> -               return -EINVAL;
> -
>         /* We can't heartbeat without having had our node number
>          * configured yet. */
>         reg->hr_node_num =3D o2nm_this_node();
> @@ -1906,12 +1909,20 @@ static ssize_t o2hb_region_dev_store(struct confi=
g_item *item,
>         if (!S_ISBLK(fd_file(f)->f_mapping->host->i_mode))
>                 return -EINVAL;
>
> +       if (mutex_lock_interruptible(&reg->hr_dev_write_mutex))
> +               return -ERESTARTSYS;
> +
> +       if (reg->hr_bdev_file) {
> +               ret =3D -EINVAL;
> +               goto out_unlock;
> +       }
> +
>         reg->hr_bdev_file =3D bdev_file_open_by_dev(fd_file(f)->f_mapping=
->host->i_rdev,
>                         BLK_OPEN_WRITE | BLK_OPEN_READ, NULL, NULL);
>         if (IS_ERR(reg->hr_bdev_file)) {
>                 ret =3D PTR_ERR(reg->hr_bdev_file);
>                 reg->hr_bdev_file =3D NULL;
> -               return ret;
> +               goto out_unlock;
>         }
>
>         sectsize =3D bdev_logical_block_size(reg_bdev(reg));
> @@ -2029,6 +2040,8 @@ static ssize_t o2hb_region_dev_store(struct config_=
item *item,
>                 fput(reg->hr_bdev_file);
>                 reg->hr_bdev_file =3D NULL;
>         }
> +out_unlock:
> +       mutex_unlock(&reg->hr_dev_write_mutex);
>         return ret;
>  }
>
> @@ -2149,6 +2162,8 @@ static struct config_item *o2hb_heartbeat_group_mak=
e_item(struct config_group *g
>
>         config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type=
);
>
> +       mutex_init(&reg->hr_dev_write_mutex);
> +
>         /* this is the same way to generate msg key as dlm, for local hea=
rtbeat,
>          * name is also the same, so make initial crc value different to =
avoid
>          * message key conflict.
> --
> 2.34.1
>

Gentle Reminder. Please let me know the status of this patch.

Thanks

Deepanshu
