Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DF2374A01
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Aug 2026 23:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785884486; cv=pass; b=jv4W2h2af+1lZ0q9+IRLtGqXHSquGNGz4mK80RpHCuLY6JBSnPTXhw+M7qMZwEbtzv6+Q5f4G6Vj+XDfhuojh2aeefPLwSXsgjB5oZz6hjbosQx10C99OEC8NS6AILoON4LZo/HMPFYE3LId4FITqPX5yfuxR7w+4Kst2FEv7yM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785884486; c=relaxed/simple;
	bh=IopsMBq3Iqrmhpt1GvIJX0f0inBUyip79dSnD2RW0vI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kIxHSXMuVglkg7mHRFcnLbasCx6uCQ2Yj+xx6f3tnRnVy4Gn1sj/IBY2ieMtywoaorP0E4atX0bOdWQAPHPo9zTCX2W1sFKoh3fXASFNxWVFL7sFCk1dowCM2kU5MJ/xR6txln6WRXxjqwCErVVXFDooIwUvcFwi3gaqJvjn05k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iD8dAnTm; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iD8dAnTm"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a0de062db5so502519a12.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 04 Aug 2026 16:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785884483; cv=none;
        d=google.com; s=arc-20260327;
        b=FVFhP+NEb8smcBggFwwaWgkPpJXHQj1BMuVmsBZooZBVyfAoeZAj6HOnllj43a1ZhM
         w7Vaast371OVxau0M5aX0GKDYzLbr7EnEJpgbtUtqht0PX8UYzBCAr4VvR9ADK7glUkq
         O7RRwo3L5g8iwRU1jWGzDylI58QlB8EuriiANmgfYWot53vcFv41naMR9rTgNpIm6Axs
         I4fI0tWkztibrCfVlVZoIM3jy6HaVFKf9TE8d9BERsE8lpUQd1QVHeaGSPuO4U7Pxn02
         6llE63IuY3dqmNeXiFDINF+Nm0+wY5F+mbII+P/F+Fwv9E9HNiFRFmbwJgG8H7bYWZ+s
         YvjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1yp2h2soLRnEcYsxIwWN6JD3tw9DOEM8R0hdKPhFP8g=;
        fh=JGvgGJRsnFZmY1Xaf/UN30nonKYN+pUZQS27N3rwEKg=;
        b=KgOKJqXHuQL6pTeihAPIPzxd8G4fGAmE52Cy/FF51GTZgcnECcE30u2gQLiIqNb+Ip
         kPuDvL7kQ34vY+viwL41F0cmlH4y1rnMiAIrZZPkrgsSky4Dpt8UHRumzXi1wRHEHtaU
         Utw7b38XHi/HvEsEU3USz3YIYrQQlkz8uIZi4smZoYl+2xgTz2ZUVlbUlKhSKb5ZdMLq
         Ee9ObUf2O+EsLjO1anxsIpuA7BiXw1TKwPxcHdhvy1PHK0vatqY7Klhe0lRvVXWUVrdB
         BMGEpBf+2Xn/0JrOu7h8b5gALwum2gXJMgxjozaoJ53BtgymX6yv1qOS/Vkh/1XiSO0l
         XZqg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785884483; x=1786489283; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1yp2h2soLRnEcYsxIwWN6JD3tw9DOEM8R0hdKPhFP8g=;
        b=iD8dAnTmjj32KeVLhFJRAy5Z1W6+lXLpHGWZPAvJGfN70QLVRT27vpwkMekdqNj20o
         eQLjJ72KaNYjtqzKBoLjxZVx0NJhL+eCzb0ICAgg48/wQcFl+xIqvW3okh5f0vMASUkU
         bItPU4UP6rZYXxG5xz0cEtV7UeJriFuFPl9vtC+/TWAtpfhlZY14eqDOc1no8e37iKMS
         3kb2H+MA1WoVYycyDv+TQjubKTiTu5QSKsII1wtDH6Duzzh/Rnh/PwApriQgyvR+sWt+
         cVUhiu+z3DVCnLMHgVfGsFBHu6b9QLs/a6fyaBYJIynf4b2t05N076bK3Ali1AmiisPV
         FPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785884483; x=1786489283;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1yp2h2soLRnEcYsxIwWN6JD3tw9DOEM8R0hdKPhFP8g=;
        b=ch4oiKyc0Gi38u5gHY87lXOZbWJlftfuPvVpMorec2zE+8W17QcyKD7f6xZMkSqN8L
         l/afAgNPu9dt5qjjFzFvP/Z/o847/XjzCmid9UHo6KPkH+XNzXfeY4QAaaIPs6lMuAr6
         muagp4FtXSGfV7YAT9h8r0CwMGLZ9JJDi42CKgoFjbE5m9AQhE7I3mbRYa+p/9u3jxBa
         9Euj/mMf8bGVj5IvFLILhO50auz/9koO+dI4u8TqGPGSWITTnYs6AUqovlD27Jon01O6
         e7EuXiTTIVPC7Bs2RngH8jA4mZj6bRBbRXsMq8H6DUGZTOIbDGIt3sfCc2GZ++Cd+Iex
         nY7g==
X-Forwarded-Encrypted: i=1; AHgh+RoZRgXNASYTNrDbiOT0KeJRlmwuuwCXpuxpBqcG9TV98n5x/NG0Gaz7v0o2vN85ATtJBnxV0D1PUs3nAA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6Kot46F9pZwIcyPvS6G0YMz55OhHxJZ7MUQ51xEoMhimyuiog
	uakEE6zBTgtvyjYVhRoukBbi0Hw4ae/taE63bi/dbp9kbTfy/xADPhhP3MBu1i5qv2xHTEB0vBS
	mpBf5oF+WV/UHKq4l2/dalrM2T8IaWJc=
X-Gm-Gg: AR+sD13qCHzl82ihBbGbIxkY6/dB/JWT/0I+RA7mK83KD1p7ri59hy9kErdayZAbEwo
	2pHuQoKXMzn3cc2OnlH7QH0RPNoJmIv0P+M1Rve1DIzkST2dsqQY+OpSn4YSQMpNvH0q6seloMy
	mWNlyiRc2b/dTxs0+WhfcuwvrpeetyB3a5LA556kdcAbr2Mzv1HsB/8S8FnA+RcsO008GDzdQIV
	zgm9UrR+e0NSDjBZRdaqkfKaR+bERUCgVJ9tv9yYzrE5ZNUcyfjIoEX3RA2O9/dv+deBv1RoWD1
	t9V/JG7uJRZXf3XdeW7nY57oYLIBKLJhnJabnQd6OyNRBKyvQ4+T7u+J
X-Received: by 2002:a05:6402:1f4b:b0:69f:d4b7:9476 with SMTP id
 4fb4d7f45d1cf-6a14f0e51c5mr1269188a12.4.1785884482828; Tue, 04 Aug 2026
 16:01:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <3aa278c3b75de2bca8a94ec0c0e40922b1170881.1785621505.git.coshi036@gmail.com>
 <k6v2pwtt67ifaeqyeiv5fiwuui7vttyet3firu6v3huxbq334q@jhl56exixqru>
In-Reply-To: <k6v2pwtt67ifaeqyeiv5fiwuui7vttyet3firu6v3huxbq334q@jhl56exixqru>
From: Chris S <coshi036@gmail.com>
Date: Tue, 4 Aug 2026 19:01:10 -0400
X-Gm-Features: AUfX_mxYao6cSkbq9heyNF_IuXvbT2WPjBf_yLUjm-kTEtW0_MWXVTs6WeiPsWA
Message-ID: <CACd_6n3dYd6PatZqCEBcctkfzA0AzVMZJfPvdAxUA01zhXbAEQ@mail.gmail.com>
Subject: Re: [PATCH 19/19] buffer: stop clearing BH_Uptodate when a write fails
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jan, Thanks for your suggestion, changes on v2.

Write completion no longer touches BH_Uptodate in either direction, here
and in the jbd2 and ext4 fast commit handlers.  I instrumented all four
with WARN_ONCE(success && !buffer_uptodate(bh)) and exercised ext4
(data=3Djournal, fast_commit, -o sync), vfat and exfat - creates, rewrites,
hardlinks, renames, deletes.  It never fired.

The BH_Write_EIO change is a separate patch at the end, since it has to
move all five handlers and __bh_submit() together to stay bisectable.
gfs2's handler is in it too; it already marked errors this way and needed
the matching clear.  __bh_submit() keeps set_buffer_req(), and the local
'op' goes with the clear - it had no other user.

Chao

On Tue, Aug 4, 2026 at 5:19=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:01:03, Chao Shi wrote:
> > A buffer whose write failed still holds exactly the data the filesystem
> > asked to be written.  It is the disk that is out of date, not the buffe=
r.
> > Clearing BH_Uptodate says the opposite, and callers act on it:
> >
> >  - mark_buffer_dirty() has a WARN_ON_ONCE(!buffer_uptodate(bh)).  A
> >    filesystem that dirties the buffer again after a failed write - whic=
h is
> >    the normal way to retry - trips it.  That is the warning this series
> >    started from.
> >
> >  - a buffer that is not up to date gets re-read from disk, which replac=
es
> >    the data the filesystem was trying to write with the stale on-disk c=
opy,
> >    silently.
> >
> >  - the window between the write completing and the buffer being marked =
not
> >    up to date is visible to anyone holding the folio lock, so the state=
 is
> >    not even self consistent while it lasts.
> >
> > BH_Write_EIO already records the failure, and by now every place in the
> > tree that needs to know about it tests that flag instead: the two core
> > helpers in this file, adfs, exfat, ext2, ext4, fat, gfs2, jbd2, ocfs2 a=
nd
> > omfs, converted one filesystem at a time in the preceding patches.  The
> > private completion handlers in jbd2 and ext4 fast commit were converted
> > along with their waiters.  Nothing is left that reads BH_Uptodate to fi=
nd
> > out whether a write failed, so the clears can go.
> >
> > Found by FuzzNvme.
> >
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> > ---
> >  fs/buffer.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index ac978d9090c2..0002f0736398 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -207,7 +207,6 @@ void bh_end_write(struct bio *bio)
> >       } else {
> >               buffer_io_error(bh, ", lost sync page write");
> >               mark_buffer_write_io_error(bh);
> > -             clear_buffer_uptodate(bh);
> >       }
> >       unlock_buffer(bh);
> >  }
> > @@ -441,7 +440,6 @@ void bh_end_async_write(struct bio *bio)
> >       } else {
> >               buffer_io_error(bh, ", lost async page write");
> >               mark_buffer_write_io_error(bh);
> > -             clear_buffer_uptodate(bh);
> >       }
> >
> >       first =3D folio_buffers(folio);
>
> Please remove setting of the uptodate flag from these functions as well.
> Write IO completion shouldn't really touch the uptodate flag at all...
>
> Hum, maybe we should actually clear the BH_Write_EIO flag on successful
> write completion in all the end io handlers. And then we can drop the
> clearing from __bh_submit(). And this will actually also address the
> concern Sahiko raised (mostly harmless but still) that if the user gets t=
o
> check BH_Write_EIO after another process managed to redirty the buffer an=
d
> resubmit it for IO, it can miss detecting IO error that happened.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
