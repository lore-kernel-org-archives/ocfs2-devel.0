Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790EE1F94D
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Sep 2024 02:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725244474; cv=none; b=d3p8jJhREAg7mbGMWijcAIU+YBlbEQj/AXipMPBmw/au18oaC3mD3c8CdVsenPIEfprWpmlQVIuBjwibIIBt+umfvMs+kF0CRA3EcIZrQaq9x4/wnYCzgotYZkAjAgUouvJzBf/dB6CgJrvaGplzXpbS4Q/Z3l/dWRtbgDM787c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725244474; c=relaxed/simple;
	bh=AcIBiqqvfUIQSGajA81GOBiuzvmLEtalaWuypO3p9Ag=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jEo5Pmvm6ZxgXhroWmndttwvAwUAbXnHsdhflMavlsD5r4pNYO+V4o46duOoDVlcG6M04rypVCHpbeqpmoRgw2L99m5MUlRb8Z9UOe80V/qXf5Uo3mopOIMq9GS7vo4fzRyICuOQW4RCkwkT/Zgs/Z4Lm+pR9za0726djhdzIwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ekaiof+B; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ekaiof+B"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7cd9d408040so2722986a12.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 01 Sep 2024 19:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725244473; x=1725849273; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AcIBiqqvfUIQSGajA81GOBiuzvmLEtalaWuypO3p9Ag=;
        b=ekaiof+BAlujlVGqAiSvl2L+yIgTGBBNUY2yPmcTwXVYAJ6s3JPMYHi7vBOW/bIBVK
         ktrT1+pS8IIWG669qTxA8QIWCuBsKup6/myLO073TMSKn4iDvXUZ1Ajpq2RJkYPXMi80
         p2Ba/HbeSgLnEm3WpgGRnyYMOTJdd/ZzRrBvEPVadxQYe6RcwS18c/Ao0/ZcoMwVvddQ
         JzJK6CaXqOmbhU3W23V1wtb3x19qTwg5JNH0SjdmTbN2PRgpG9ZG3DJrA4TNVXJVqaBP
         tS8kq4EqPHoGjtyKf+Y8YfMzuuUjMiF59M5JDSsPk5iGy7ikEHdJoE3AOlOCFdp0L3Lj
         b5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725244473; x=1725849273;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AcIBiqqvfUIQSGajA81GOBiuzvmLEtalaWuypO3p9Ag=;
        b=Fu4v4wu8iFN62h6EjKCgh9iRxjF6cedpPR7EcWgTr0Inwm/c9gpm3e3M0a4VSRXxZb
         stdEHXmcWyAeR5uUMQ91Rr1vGabHoQHs2eWkm2TlZSCjOvJU9pcaSxetuVl4y+ybAbZF
         QCnVPMKgvJrO4orIWvOA0Qdmf1R9epGgB+XVu22Ph1JHoJ+RHVo47SNzZiF83kedIGtW
         WkhJbqwMwWO4kDgBGq+48vSKJ83yr1DyL2KKWn5a3xg1Bk+W/q9ivf3FoSzDQgMW9BkX
         jtgDA+VkY9irqNcoNgnwxZuAvsYOZiAe6jShkbHY6ejelc+fMzPUOKyY5SRujnDu2zPf
         N+CQ==
X-Forwarded-Encrypted: i=1; AJvYcCWK1otF4oe+gkxLedkssQKIHagcIAOv/13U768dNvADWdZ9m9+RSJVmzxMHZo38wMOM+ecS/QL66bTLDg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0jMqL1ZwXsqY+qFwth+FhRl6Da20Qd6sJLuztLVpYWNx6XKZy
	GzFu851/npAi8CLLaQMKYcsQl/Y3xRNDCe6ituqC9/2Tul4hOt0I
X-Google-Smtp-Source: AGHT+IHMajpvUNnjCXQWheRwPzQ8Um6tDMPhTCzOOGbbRDZMGujiJCTI/yYIUXm84ppmBq7dqv+tyg==
X-Received: by 2002:a17:902:ebc5:b0:1fb:4a68:b7bf with SMTP id d9443c01a7336-20546b35bd7mr72308745ad.45.1725244472447;
        Sun, 01 Sep 2024 19:34:32 -0700 (PDT)
Received: from [127.0.0.1] ([103.85.75.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-205152d5a7esm57284725ad.97.2024.09.01.19.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 19:34:31 -0700 (PDT)
Message-ID: <785a5975c61a466a067c88b6bff747fc9562c62a.camel@gmail.com>
Subject: Re: [PATCH v3] ocfs2: fix null-ptr-deref when journal load failed.
From: Julian Sun <sunjunchao2870@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev, 
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org, mark@fasheh.com
Date: Mon, 02 Sep 2024 10:34:25 +0800
In-Reply-To: <f08b8440-5df5-45cb-9ec2-43601b9aadda@linux.alibaba.com>
References: <20240830110853.101060-1-sunjunchao2870@gmail.com>
	 <f08b8440-5df5-45cb-9ec2-43601b9aadda@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-09-02 at 09:32 +0800, Joseph Qi wrote:
>=20
>=20
> On 8/30/24 7:08 PM, Julian Sun wrote:
> > During the mounting process, if journal_reset() fails
> > because of too short journal, then lead to
> > jbd2_journal_load() fails with NULL j_sb_buffer.
> > Subsequently, ocfs2_journal_shutdown() calls
> > jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
> > __jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
> > ->lock_buffer(journal->j_sb_buffer), resulting in a
> > null-pointer dereference error.
> >=20
> > To resolve this issue, we should check the JBD2_LOADED flag to
> > ensure the journal was properly loaded. Additionly, refine
> > code to make it cleaner.
>=20
> s/Additionly/Additionally
>=20
> Additionally, use journal instead of osb->journal directly to
> simplify
> the code.
Yeah, sorry for the typo..
>=20
> >=20
> > Link: https://syzkaller.appspot.com/bug?extid=3D05b9b39d8bdfe1a0861f
> > Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
> > Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> > ---
> > =C2=A0fs/ocfs2/journal.c | 5 +++--
> > =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > index 530fba34f6d3..ff2a6538b46e 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -1074,9 +1074,10 @@ void ocfs2_journal_shutdown(struct
> > ocfs2_super *osb)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0osb->commit_task =3D NULL;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0BUG_ON(atomic_read(&(osb->jo=
urnal->j_num_trans)) !=3D 0);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0BUG_ON(atomic_read(&(journal=
->j_num_trans)) !=3D 0);
> >=20
> Please do the same change for the above one:
>=20
> num_running_trans =3D atomic_read(&(journal->j_num_trans));
Ok.
>=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ocfs2_mount_local(osb)) =
{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ocfs2_mount_local(osb) &=
&
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (journal->j_jou=
rnal->j_flags & JBD2_LOADED)) {
> Align it to the right place, please.
Sure.
>=20
> Thanks,
> Joseph
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0jbd2_journal_lock_updates(journal->j_journal);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0status =3D jbd2_journal_flush(journal->j_journal=
, 0);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0jbd2_journal_unlock_updates(journal->j_journal);
>=20

Thanks,
--=20
Julian Sun <sunjunchao2870@gmail.com>
