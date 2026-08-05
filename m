Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA543DDAEB
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 19:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785956576; cv=pass; b=IBAMDhqqrqlh6wxhkLSqSSodQzvFa1MZ7t5PsvoHxTOGloy9EZ/smtluY3HMTKlU1XPUWe4TYmyPm4z32LXP/EhhDp71zfxqDvZ6aWpOntL7GkL4fj4BzI2dXYbIEg6jb5339y1WbBgiyGuTNVbv5IhYfELWRgEnFskFje0rUNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785956576; c=relaxed/simple;
	bh=ZkwANXvB/ZU9t3LgTT3w1mAN0VeV9gy04VEToUnWNWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vEGIEwPBet2ll622ng2otSdeAD/Ou7dAFq5SGrduDDCdWqrvVOvsNkBZLBdhGys93rJz+ui3yU8hk81mLLMcJVDeY/NfcnPOksGNMKiYe2yBsmMkYQyAnHwaEGhOHtPtkMqalIF7/fKp++jVLbv8f5eVQsLcrt/2lCrk76XKWhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BozGXhom; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BozGXhom"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a097f5ab95so2109872a12.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 12:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785956559; cv=none;
        d=google.com; s=arc-20260327;
        b=i3/H4U7QeRkBrj83KrDIoC0OTwmSMulNS2pPI/CWkwotqiBGT0NVcY/auEOGAZey5u
         R1ktcNkjtrX3Gbw1NzgW4gNGKnU2gZK7sRKyuB0mTjU4IMQs0/jNrjO0DqNamkhe1DXr
         io1ghGXx7SYhL7AX/9G2RH7fFWxHE/H6fLoz5XccwYzx61eB9rFQep/nCKKOEXTv7K2f
         JDXsCVRnOIbdCjvQ/iErE0gDQTku2wrUvC/vhsB2WlDqAdlvznhfWwCJrX6WSU41tssd
         ErIMzz7N63xmiCJ6d44dawy3ABcmIEnHvc6EUHkJqxOrJTaYweNHyDo2REJ48HayULMz
         XrKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yjE4xnT39vpf/cIgIYUv/kq7g7oy4MnCKn9bbbuZ18Q=;
        fh=6vbZqSDnnGwxRRy0yThs72OPnenDofPVBXYI9IdWSRE=;
        b=Wu74T5YIluWWTJCfMGlybkpFMCxAJdktsD+dMbflSTs6yWtF+FtRb7V0tAPAGKcPmJ
         dOKm1LM03ZH6BItynli06LXwL+9A4LUHGXQGFiKQkHOO/Wi8djQYaTaCcb18n1nptI/C
         9TYGq7ozyfCzVHXOTq0xdJN2yKjuI6Fk1ipbGWsKM06CLB/kbzQg6atnkNxpYhq1XdXJ
         GM1Ov6brkyFwwzwy7EJnimOJjzZywbSXTEFhqvo5YikAD6LxHZSzOmq/oNlcsEQbmFaI
         fQKzN8II8qLMxlq7JxYPRScPFyHZZdSETDxc0/gY3XF1FNZf/j+iJILa8uf3oZNHDGh5
         ecMw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785956559; x=1786561359; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yjE4xnT39vpf/cIgIYUv/kq7g7oy4MnCKn9bbbuZ18Q=;
        b=BozGXhomFP2lRRmxVDp8nCFYnznDWPGkczqnIN9QNvu/5VJDs0+kCnGwy1NQ7ZrPLW
         +3EY+S9W6qUYn83hT/AnyPkE95qP6ZmK2CeIixy1p0qe0HJ9lh7YUWJFyQvmvSXku6Tn
         Wj6q4DZJS05LHOt4OgGeoN9UbK/Or8irfrDNjCFlbGEF9VsFpMNduReYhing9VXDsKgb
         2pECzNna3Ohns4lMs6k4KYWb8yU9XmrAHWceV7RtkGFX9vVUp39WbKuVe+3+EEaA77yu
         VnTLmwNV8Ca/2o5+HCZzDD6J68OzdCxxclLGNvjVa+FZCt44KiWEgXPe9PswSeu6Q2j6
         fd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785956559; x=1786561359;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yjE4xnT39vpf/cIgIYUv/kq7g7oy4MnCKn9bbbuZ18Q=;
        b=hhmMclE+rTxKhQxrpC5WFJZHNbMbjZHq5anVjBPb1Zbjc1TWZS6o1NV45XAyUAu9rd
         KsXBGGv/f/PuU8kp5P3RdCFMPnAHxB7UPqJDRgrH898H7G0y4hPqBDkXu5CSjjCFFh9w
         upEXkp5ZIoaA7RMKK85waeYC4UqgHDESBhwwk8dXCUzSbc30GsYedL0IChVDcJfoRs1S
         dcW9wWrsVNukUuIBxm/jTSvT+zUu1CCiixLqsnwJGfLdZTC1haZHngdIEit0nIKYKVc4
         8On5PUCc12ojimzsc6VI8ICYNFcYpg/AbqT6YjCUBkFZ57q4IhrLXxBDZXLpSA7H1SSl
         z1Gg==
X-Forwarded-Encrypted: i=1; AHgh+RrpmH0Wc4YKMfrvpxjAXhtoz6TmA6o7oandfcozZhegFq7muKcq9RtBcaVQ8h2XlrSWEV2xbTEL8a9l3A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwwSxwdTdCImVLPLaxnSohoQohs4v0jnYh+PlZoUIOc1BbCoYbO
	WmR/a8p4xm4cyIKQGyzDbXNN/3wAQCvp3lCYDEWuXY8osqYLUTHP2TbPMPeNzFo9w4aKxcKOjRg
	O8IaWph+1HlZoW8ahGrNg9gJFVAhC0YM=
X-Gm-Gg: AR+sD13LpFKffVzAiDXCz3I3NIRyycX3hlgSmkj/gsl0S6OvEFrH2/DW85h/xWdU6WI
	U25bsaYDbKIRnUANaXq8l9xHKt/sbYY17ZuwnasmhbN7Y8SK77vwuKFbJrOoPl4SNEYevhqYhby
	g1pI6MGVzGgXQQEDKaYWZ/GYVdzR+QJTi+2Hegsg3KZxNlj91HqfPNUCfO27ci1NGKr1mifiPwY
	OCc/vNyct2IoYeOhdC4KAh2FwoVo5WOs2aKSiuailJNvohs/MzEB5/pVi9mJOHQbwyTSiNwHPgI
	NlHS/lb/LmLxlxaYnNDwcLs3wjl6/HWd0rDB/m34tFUQ
X-Received: by 2002:a05:6402:324d:b0:6a0:ecc9:79ad with SMTP id
 4fb4d7f45d1cf-6a14f27eb8cmr4200909a12.20.1785956559020; Wed, 05 Aug 2026
 12:02:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>
 <aqyhnzlgxo4x2v6bfpi43ueoob2drnpcxkmy7fpx3i7bcrvkzj@rm2bn66enfc3>
In-Reply-To: <aqyhnzlgxo4x2v6bfpi43ueoob2drnpcxkmy7fpx3i7bcrvkzj@rm2bn66enfc3>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 15:02:27 -0400
X-Gm-Features: AUfX_mw6M87toR509y6pAXXK646xUVHCYetXkG3wp8ZS--BnNZ1uTuGmAkGSoO8
Message-ID: <CACd_6n1YDk=S1MWd=7TH29mTcyiijLQn8jZOyjGo=p9yduZ06Q@mail.gmail.com>
Subject: Re: [PATCH 03/19] jbd2: point the shadow buffer at the frozen data directly
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

Hi Jan,

Thanks for the suggestion - done in v2.  new_folio, new_offset and the
frozen flag are all gone; folio_set_bh() moved into the one path that
still needs it, and the two copy-out paths just set new_bh->b_data.
b_folio is already NULL out of alloc_buffer_head(), so nothing has to
clear it either.

Chao

On Tue, Aug 4, 2026 at 4:28=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:00:47, Chao Shi wrote:
> > When a metadata buffer has to be copied out before it can be journalled=
,
> > jbd2_journal_write_metadata_buffer() writes jh->b_frozen_data rather th=
an
> > the page cache copy.  b_frozen_data is kmalloc()ed, so folio_set_bh() m=
akes
> > the shadow buffer point at a slab folio.
> >
> > That is not something the buffer_head layer can reason about.  A slab f=
olio
> > overloads ->mapping, so a shadow buffer looks like it belongs to an
> > address_space when it does not.  buffer_set_crypto_ctx() already has to=
 use
> > folio_mapping() to avoid tripping over this, and it is the reason
> > mark_buffer_write_io_error() cannot be called on a shadow buffer today.
> >
> > Point the shadow buffer at the frozen data itself instead: leave b_foli=
o
> > NULL and set b_data.  The previous patch taught fs/buffer.c to submit s=
uch
> > a buffer.  The two commit-path checksum helpers are the only other user=
s of
> > the shadow buffer's contents, and they take the data directly rather th=
an
> > kmapping a folio that is already mapped.
> >
> > Note that the shadow buffer must not be passed to bh_offset() while
> > b_folio is NULL.  All four callers that can see one are handled here an=
d in
> > the previous patch.
> >
> > Tested with ext4 mounted data=3Djournal,journal_checksum on a metadata_=
csum
> > filesystem, writing files whose every block begins with the JBD2 magic =
so
> > that escaping forces the copy-out, then crashing with sysrq-b without
> > unmounting and replaying the journal on the next mount.  Recovery
> > completed, the file contents matched, e2fsck -fn was clean, and an
> > instrumented build confirmed the b_folio =3D=3D NULL path was taken.
> >
> > Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
>
> ...
>
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 09efa337649e..9e4cb04587b4 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -329,6 +329,7 @@ int jbd2_journal_write_metadata_buffer(transaction_=
t *transaction,
> >       struct buffer_head *new_bh;
> >       struct folio *new_folio;
> >       unsigned int new_offset;
> > +     bool frozen =3D false;
> >       struct buffer_head *bh_in =3D jh2bh(jh_in);
> >       journal_t *journal =3D transaction->t_journal;
> >
> > @@ -354,8 +355,7 @@ int jbd2_journal_write_metadata_buffer(transaction_=
t *transaction,
> >        * we use that version of the data for the commit.
> >        */
> >       if (jh_in->b_frozen_data) {
> > -             new_folio =3D virt_to_folio(jh_in->b_frozen_data);
> > -             new_offset =3D offset_in_folio(new_folio, jh_in->b_frozen=
_data);
> > +             frozen =3D true;
> >               do_escape =3D jbd2_data_needs_escaping(jh_in->b_frozen_da=
ta);
> >               if (do_escape)
> >                       jbd2_data_do_escape(jh_in->b_frozen_data);
> > @@ -400,13 +400,22 @@ int jbd2_journal_write_metadata_buffer(transactio=
n_t *transaction,
> >               jh_in->b_frozen_triggers =3D jh_in->b_triggers;
> >
> >  copy_done:
> > -             new_folio =3D virt_to_folio(jh_in->b_frozen_data);
> > -             new_offset =3D offset_in_folio(new_folio, jh_in->b_frozen=
_data);
> > +             frozen =3D true;
> >               jbd2_data_do_escape(jh_in->b_frozen_data);
> >       }
> >
> >  escape_done:
> > -     folio_set_bh(new_bh, new_folio, new_offset);
> > +     if (frozen) {
> > +             /*
> > +              * b_frozen_data is slab memory, not page cache.  Point t=
he
> > +              * buffer at it directly rather than at a slab folio, who=
se
> > +              * ->mapping is not an address_space.
> > +              */
> > +             new_bh->b_folio =3D NULL;
> > +             new_bh->b_data =3D jh_in->b_frozen_data;
> > +     } else {
> > +             folio_set_bh(new_bh, new_folio, new_offset);
> > +     }
>
> Can we please simplify the flow in this function? folio_set_bh() is now
> done only for a single branch in this function. You can move it there and
> completely avoid new_folio, new_offset, and frozen variables (you just ne=
ed
> to set new_bh->b_data in the two branches where frozen data is used).
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
