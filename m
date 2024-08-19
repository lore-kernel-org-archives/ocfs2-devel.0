Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00EC16CD22
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 14:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724078628; cv=none; b=Dwn1XFAnLxVOsfDfLR/9lwPJPJafUJBDxZr7zLuM9WOLnim0N9+JVGbOYkTZHFdUtsCVSxbtxB5x4R9knadd+xzBLRYqsPnWlhY56R9mn8YUN1TOYNHjMXqglSRekowwQyc0AEgxKc33kmEKtj5qV5ckA00n+NRaJeXjN7LUH8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724078628; c=relaxed/simple;
	bh=/VrtbbhB5xuTgjJzRXsBZ2qu6eNnfqcRtLePfkE5eJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=doh6igiFJgxrS7NSxKUnhCsfh+SJqBxSHh8r3W4wc17aJB05tiIharHTM5Fam3Ma01l3G3zvSxpNUeoRr187/QuPqRZqJ3thC8JuZ0qGx3Zpxco4g0UWyJ5bUdOz5+e/uYluYtEM/VV8q/PEQk4PZvXK4di5N0D+Vni2t4Ba1Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzuxyHgR; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzuxyHgR"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5bef295a2b4so386978a12.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 07:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724078625; x=1724683425; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuND7K0ekUC0YS6IT+t8ylUpD84fd3Qi1ukfVX2K7jA=;
        b=RzuxyHgRVHcbeu4szdO+qtECcN89lbDq5jCTNuu8x+XbFEfyzXDKwEgc/CLaMV6rTn
         oPt2PxSULPNovUOnXfr5wJSnq2m2qfNq0z861QP31f0GUB1h7oP4PZdj/vLdDDeZ+3R6
         ucTaPpjeuD8D5ydKGfUhU0bcAlimSHw9HLfHZicV+zLsQN6nrZywJgCO3CaRfKBWZn6m
         mkg5kF78LjcrMNm40x9O/zSsa/Ox6uV9lowyHWQvmO3PODmnl5nlWzPTnBrIowhwJF2s
         c2WUAZl0G/VwR87xr9mt++gNn4ifKQPy/mDJTBKJmescDouPYPgf5awqSIlXSBk0msN8
         JHTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724078625; x=1724683425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JuND7K0ekUC0YS6IT+t8ylUpD84fd3Qi1ukfVX2K7jA=;
        b=Lt++9w1AjwaAjFh7XgpstB035GAP1X6h+zAvzM6YlbjQLlz8d+AYhGdM6358yom9+I
         5wrldD/YR9+VlK0JGlQ9pA+9E9kApEJEHGhCewdjonecp/8+Ofsgr7HXUF3cihg3l61A
         sxRVxM1kEtAA5lVUswK1fooUgsymjzeeQ4RlxIrRyxbp/dSN4CisQsHWY4al9AYkM1ld
         NNpmBQ+izp2uWc35Hck4X8duHd1ml/IBtn7+cxE9WIT+pcScYqN9Yh4DVCnsNThP54/F
         ysWWw88Ge5Z1U1FvxAVmklioyRnoNt1g4Qp4j4hsCNxbI1//ptWjGay/ZBoGPl/qPlVk
         lFmw==
X-Forwarded-Encrypted: i=1; AJvYcCW/oSVpM4UQqs1XTg0t3Ij/NhaVrcTwzX5GyLU8MvUA1RTYISyNGnrUVBriwpoQU6/YUFLRb9ILLgyAO4D0PVvTedhh06GUXyx8MKM=
X-Gm-Message-State: AOJu0YwjAUvNHLYpO1Cd0lEfR7+ah0AVIp+mHo5TAllzCcvu0mN5nIwM
	Wys9Cs78AyiPJ17487Z9t4u74YXmiO4W3wusAWrbkiV2f/c6BLe5L3JfKSbeVHg7JgCmSqy7LH1
	Vm8JSqQ6nQFQ/yAYax45BicbcNk4=
X-Google-Smtp-Source: AGHT+IE73IQ5JAxt0eECgIIPdmod+EHyCAWPj8hpNshRr2NIZmu68lEsn9ZJxxBY4mjZB1wHnf/RVXTezw/2zogm5Ew=
X-Received: by 2002:a05:6402:40c5:b0:5be:fa53:f74 with SMTP id
 4fb4d7f45d1cf-5befa531123mr4271487a12.0.1724078624824; Mon, 19 Aug 2024
 07:43:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <000000000000742b9d062005fc1c@google.com> <tencent_879750E9E2EF32CD287A2E6C9C2C856F1C0A@qq.com>
In-Reply-To: <tencent_879750E9E2EF32CD287A2E6C9C2C856F1C0A@qq.com>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Mon, 19 Aug 2024 22:43:32 +0800
Message-ID: <CAHB1NajJsvZgF5AdpaaZbnbBYt4L=Atcymag3aqTknLL0PeGTQ@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: Fix null-ptr-deref in jbd2_journal_update_sb_log_tail
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com, jack@suse.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Well,In my modest opinion, j_sb_buffer is an internal variable of
jbd2. Directly accessing internal variables from other modules can
degrade the maintainability of the code (for instance, this variable
might be removed at some point in the future). I have just sent
another patch to address this issue [1].

[1]: https://lore.kernel.org/ocfs2-devel/20240819131120.746077-1-sunjunchao=
2870@gmail.com/

Edward Adam Davis <eadavis@qq.com> =E4=BA=8E2024=E5=B9=B48=E6=9C=8819=E6=97=
=A5=E5=91=A8=E4=B8=80 21:41=E5=86=99=E9=81=93=EF=BC=9A
>
> Journal too short will cause ocfs2_check_volume failed, and will set
> journal->j_sb_buffer to NULL in journal_fail_superblock before running
> journal shutdown.
>
> Reported-and-tested-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail=
.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D05b9b39d8bdfe1a0861f
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/ocfs2/journal.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 530fba34f6d3..25821077b855 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1077,9 +1077,11 @@ void ocfs2_journal_shutdown(struct ocfs2_super *os=
b)
>         BUG_ON(atomic_read(&(osb->journal->j_num_trans)) !=3D 0);
>
>         if (ocfs2_mount_local(osb)) {
> -               jbd2_journal_lock_updates(journal->j_journal);
> -               status =3D jbd2_journal_flush(journal->j_journal, 0);
> -               jbd2_journal_unlock_updates(journal->j_journal);
> +               if (journal->j_journal->j_sb_buffer) {
> +                       jbd2_journal_lock_updates(journal->j_journal);
> +                       status =3D jbd2_journal_flush(journal->j_journal,=
 0);
> +                       jbd2_journal_unlock_updates(journal->j_journal);
> +               }
>                 if (status < 0)
>                         mlog_errno(status);
>         }
> --
> 2.43.0
>
>

Thanks,
--=20
Julian Sun <sunjunchao2870@gmail.com>
