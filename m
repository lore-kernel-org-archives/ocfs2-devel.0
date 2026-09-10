Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E3949158A
	for <ocfs2-devel@lists.linux.dev>; Thu, 10 Sep 2026 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053062; cv=pass; b=ZxNZx0DL/VgVcAdU+KxDO9fqsUiBfbcEorJIqOD88c90ivL/YC2wcE1D+jYKG2yJ/XW0HFttXS0Zqo1ZfUyviP+Co9NOngWAQPRarF+rSYonVeonMICsek6rxRfZi+MGI0FV9sKE/JRrBi89r9eVmBhWSBnnL4CpBsZhun4zR/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053062; c=relaxed/simple;
	bh=9skpiSPV7DYDQJGnCwUFDPERmPJb4uc3nwUCKryxz98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZewEGL6oDJP2wzyyzZv91/XCNZsotStk56m0xl1yCARNAr9D1pgiDSGhFkFmWPC3gz7+CdxSIackgNznlHVH/q2441oy3LHEDFGvttLd5krnZMXWJyT6D8Qhs8/SD0O7kO8MdiBWft0+Ps8MUqw2F8IlxY/t77JByFHMm/bzKNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oyHfypNw; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oyHfypNw"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a998436551so3050410a12.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:10:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789053053; cv=none;
        d=google.com; s=arc-20260327;
        b=FI/qbkaqQPhPBtKapBTOKzR0PvDrc3g8DTWPfXp+q9EXzcHKyNWI+iygqRxEdTTr/P
         hFBQUcTthkXRRLsyBnc2BpMce3ZPtVn0Xa2kN+TQ6C3WlxZieSx30sFxPwi62UVrWano
         e6XSo3YOgB9tcInELxwx5tUqKId7p6Wdc0rzWElzAYuoB+cS/0WkzFksPClKcidC8giH
         56KJHCU6imSS5iX/fAfFgKsAfQdtsktfSS7N8qmrEYiR8Y4c1+xJdy9wuIFWB8luIJDz
         O0QETMikj4GMpQT+LXTrGaji2KHlyXs8Ip4vJLwIX1RF1feb9Dq6jEMsowGd58bTIaWy
         Da7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bWHC+M7zvZqjQHZoXSSYG/rFYNQ6vDcay217qh/DvTk=;
        fh=wQfIh410/FWYMH3SRKvAe1LVzxdZdAZa41gkX3Fiws8=;
        b=Ri+Zm4zRpC2xw+wb9Kr3lBikXaNPNM6jMjbazVOv9s/W78gWjW1LTDALuN8KSrEaYn
         e/qWEf5BuS3l60Z6cCqc29csKS7GoA4r9Tammx1OCDuQh6nfs9S9ApSO3wb4f+ifR4Wi
         Srz8MDi8Geu+sxuv8FyrTimEBMahaWBrucJaKDhmd6wR+6lIuiMlUKKCe79aE2J6rdHB
         lGXgmRHr2780kl5k5tOGrRoOuRpi/SHIF9FYR9ZB49biIqZu6QrSH5nStyjuzQoHa+1f
         +UNiAdx44YdFth47C3tW7TEiYuLn54XI90/Jke1YP/HGgvMiZS68PapQS6X92W3j40Kl
         x7Ew==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789053053; x=1789657853; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bWHC+M7zvZqjQHZoXSSYG/rFYNQ6vDcay217qh/DvTk=;
        b=oyHfypNwX06WjKUQUn5ni5CzapoPImWlUn482S0x/d/lAZiLAgEzvXkFIhbHlUhMQj
         j8Z11RdrIuBoPnoOhVdeZ+p2gKb2197igGgbBCC+UJJKg4YBflreG56cjN7c7SZhyYyM
         qLG3Yp9WZXn8KgBuDx+7eKvZZS1019xIDn6hhpLSZTZGp8iHwIIzZWLv5LqzptEfCBpP
         Jztarhofq+7/s4R4ZhY4CQhFfkktB31+1fFApstgkHcQ7E+wB3QZ5ZsbzVguobv1cYCJ
         4tEHoh4E7GJIzi3sXzn6KfE8HbWvZvbXu1p3uS6UtIUXDA/TTXap3g2uZ5viL5+Uc/32
         ZyuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789053053; x=1789657853;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bWHC+M7zvZqjQHZoXSSYG/rFYNQ6vDcay217qh/DvTk=;
        b=LtMackUTivPYJVRO97+myYO1VDqoGay7BfenzLncE/NnV8UlIqbZc2kLE3x7fnXBiF
         NLTfV0si8w2hGx4/tVl7ckzZnP35v7xPS0lELkUcnhQbds9DKDDGFgnrj2yMeA7faX/U
         hhGxegOlPovBMn1PoatoKy55+AKf8cYl3Tn955Szapt8/4yOahiwfQY2KMY5+9vc3wC+
         V/mD44cDjij3EgpmyXTZaYW44gBw4slA0Be0udsHcM+wCrfNF9VfFGVposyJ4YXi9ZVW
         iYudApXgNQ3MC4Ms6ZJnP3ExlnrSUwxes/0AQ/j6WI53XQ+O07B47S0ojTlWgI3D6x2F
         Cr6w==
X-Forwarded-Encrypted: i=1; AKwUvBzSGSAgPnuQ+sbESGMsANQ+OU8+1a10j8NcqAKOR/nIbz3Kv3/l0r9lr2+l8KJOB3TGV4LRe7p057QWIQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lV2iG6odHpjkXIHlWkAUYHnWGAiwtW/TVTLasBVdUGQ0l2dB8y
	Uw0HPkIX5F4xsBPogJQua5nQlIeq7yHVzN1sRMZ0p9lHrCkKFYjviG/u9Ky69saxbknJmliK/KL
	NXyPr09ryiit1k8i7oX9xTDD6Ftd6yH0=
X-Gm-Gg: AYBFou315bM+jRpCHTkAZdATHZ8zcrhzngskRWrsD4Uy+GF+IdiSFHxCDRJTtiGZtoX
	8MeFNzjDL/gWV9naWPVPpjETnHlrrReDQQqjPmWo9oJaSgbKsX//lKwx7ysR7NxizaTPOhmnKgL
	8xlM/WRuzSlpoTPJVuEj3RXu3hImynlOIu4+XPEGTEprwoJg4gzkm01TbCcPUl3VW2BsIHOGi2b
	2jhmMJIvUBGV2y7l9M0txZvaKHobep4guEsvDFMYDPN71HGcBYzIEmesTwyRLhEErwdPXif2RyX
	cbhg5X3aoBmeE8SFfnajMQHWKN3o5OuKbBzb/HtyMZ00BI/tDnXVRJoo29OFOaUo3A==
X-Received: by 2002:a05:6402:518c:b0:6a9:9e4c:369c with SMTP id
 4fb4d7f45d1cf-6a99e4c37b3mr3264200a12.6.1789053052338; Thu, 10 Sep 2026
 08:10:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785951556.git.coshi036@gmail.com> <6140cd23beb88e99f40eaeff4044a16213f6caab.1785951556.git.coshi036@gmail.com>
 <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>
In-Reply-To: <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>
From: Chris S <coshi036@gmail.com>
Date: Thu, 10 Sep 2026 11:10:39 -0400
X-Gm-Features: AcwNN1U41RMda9PS3tJ1f-4qq1SLLxZz5cMWZGDVulUPpbONrWJH-lAeXw5zNEc
Message-ID: <CACd_6n29x8AKP=7zNQfBTq1AE-LtvxOdR8Nt9qw674Aw9WNVqQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/21] jbd2: point the shadow buffer at the frozen data directly
To: Joseph Qi <jiangqi903@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for fixing this. I appreciate it. Looks the problem is I
didn't run it in linux-next to check.
Sorry about that. Appreciate your help!

Thanks,
Chao

On Mon, Aug 31, 2026 at 11:37=E2=80=AFPM Joseph Qi <jiangqi903@gmail.com> w=
rote:
>
>
>
> On 8/7/26 12:58 AM, Chao Shi wrote:
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
> > address_space when it does not.  buffer_set_crypto_ctx() already has to
> > work around this, and it is the reason mark_buffer_write_io_error() can=
not
> > be called on a shadow buffer today.
> >
> > Point the shadow buffer at the frozen data itself instead: leave b_foli=
o
> > NULL, which it already is out of alloc_buffer_head(), and set b_data.  =
The
> > previous patch taught fs/buffer.c to submit such a buffer.  folio_set_b=
h()
> > is now needed on only one path - the one that journals the page cache c=
opy
> > directly - so it moves there, and new_folio, new_offset and the flag th=
at
> > used to pick between them all go away.
> >
> > The two commit-path checksum helpers reach the shadow buffer's contents
> > through a new kmap_local_bh()/kunmap_local_bh() pair, which handle a bu=
ffer
> > with or without a folio.  Memory outside the page cache is always mappe=
d,
> > so for those there is nothing to map or unmap.  Mapping it anyway would=
 be
> > worse than pointless: with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP,
> > kmap_local_page() hands back a one page mapping even for such memory, w=
hich
> > is not enough for a buffer bigger than a page.
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
> > Acked-by: Weidong Zhu <weizhu@fiu.edu>
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> > ---
> >  fs/jbd2/commit.c            |  8 ++++----
> >  fs/jbd2/journal.c           | 29 +++++++++++++++++------------
> >  include/linux/buffer_head.h | 29 +++++++++++++++++++++++++++++
> >  3 files changed, 50 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > index 3029cb6f6d64..0c85af91f9b2 100644
> > --- a/fs/jbd2/commit.c
> > +++ b/fs/jbd2/commit.c
> > @@ -330,9 +330,9 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, st=
ruct buffer_head *bh)
> >       char *addr;
> >       __u32 checksum;
> >
> > -     addr =3D kmap_local_folio(bh->b_folio, bh_offset(bh));
> > +     addr =3D kmap_local_bh(bh);
> >       checksum =3D crc32_be(crc32_sum, addr, bh->b_size);
> > -     kunmap_local(addr);
> > +     kunmap_local_bh(bh, addr);
> >
> >       return checksum;
> >  }
> > @@ -357,10 +357,10 @@ static void jbd2_block_tag_csum_set(journal_t *j,=
 journal_block_tag_t *tag,
> >               return;
> >
> >       seq =3D cpu_to_be32(sequence);
> > -     addr =3D kmap_local_folio(bh->b_folio, bh_offset(bh));
> > +     addr =3D kmap_local_bh(bh);
> >       csum32 =3D jbd2_chksum(j->j_csum_seed, (__u8 *)&seq, sizeof(seq))=
;
> >       csum32 =3D jbd2_chksum(csum32, addr, bh->b_size);
> > -     kunmap_local(addr);
> > +     kunmap_local_bh(bh, addr);
> >
> >       if (jbd2_has_feature_csum3(j))
> >               tag3->t_checksum =3D cpu_to_be32(csum32);
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 09efa337649e..6e05dc47e20a 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -327,8 +327,6 @@ int jbd2_journal_write_metadata_buffer(transaction_=
t *transaction,
> >  {
> >       int do_escape =3D 0;
> >       struct buffer_head *new_bh;
> > -     struct folio *new_folio;
> > -     unsigned int new_offset;
> >       struct buffer_head *bh_in =3D jh2bh(jh_in);
> >       journal_t *journal =3D transaction->t_journal;
> >
> > @@ -348,24 +346,31 @@ int jbd2_journal_write_metadata_buffer(transactio=
n_t *transaction,
> >       /* keep subsequent assertions sane */
> >       atomic_set(&new_bh->b_count, 1);
> >
> > +     /*
> > +      * b_frozen_data is slab memory, not page cache, so when we use i=
t the
> > +      * shadow buffer gets no folio at all: b_folio stays NULL from th=
e
> > +      * allocation and b_data points straight at the copy.  Pointing i=
t at
> > +      * the slab folio instead would hand its overloaded ->mapping to
> > +      * anything that goes looking for an address_space.
> > +      */
> > +
> >       spin_lock(&jh_in->b_state_lock);
> >       /*
> >        * If a new transaction has already done a buffer copy-out, then
> >        * we use that version of the data for the commit.
> >        */
> >       if (jh_in->b_frozen_data) {
> > -             new_folio =3D virt_to_folio(jh_in->b_frozen_data);
> > -             new_offset =3D offset_in_folio(new_folio, jh_in->b_frozen=
_data);
> >               do_escape =3D jbd2_data_needs_escaping(jh_in->b_frozen_da=
ta);
> >               if (do_escape)
> >                       jbd2_data_do_escape(jh_in->b_frozen_data);
> > +             new_bh->b_data =3D jh_in->b_frozen_data;
> >       } else {
> > +             struct folio *folio =3D bh_in->b_folio;
> > +             unsigned int offset =3D offset_in_folio(folio, bh_in->b_d=
ata);
> >               char *tmp;
> >               char *mapped_data;
> >
> > -             new_folio =3D bh_in->b_folio;
> > -             new_offset =3D offset_in_folio(new_folio, bh_in->b_data);
> > -             mapped_data =3D kmap_local_folio(new_folio, new_offset);
> > +             mapped_data =3D kmap_local_folio(folio, offset);
> >               /*
> >                * Fire data frozen trigger if data already wasn't frozen=
. Do
> >                * this before checking for escaping, as the trigger may =
modify
> > @@ -379,8 +384,10 @@ int jbd2_journal_write_metadata_buffer(transaction=
_t *transaction,
> >               /*
> >                * Do we need to do a data copy?
> >                */
> > -             if (!do_escape)
> > +             if (!do_escape) {
> > +                     folio_set_bh(new_bh, folio, offset);
> >                       goto escape_done;
> > +             }
> >
> >               spin_unlock(&jh_in->b_state_lock);
> >               tmp =3D kmalloc(bh_in->b_size, GFP_NOFS | __GFP_NOFAIL);
> > @@ -391,7 +398,7 @@ int jbd2_journal_write_metadata_buffer(transaction_=
t *transaction,
> >               }
> >
> >               jh_in->b_frozen_data =3D tmp;
> > -             memcpy_from_folio(tmp, new_folio, new_offset, bh_in->b_si=
ze);
> > +             memcpy_from_folio(tmp, folio, offset, bh_in->b_size);
> >               /*
> >                * This isn't strictly necessary, as we're using frozen
> >                * data for the escaping, but it keeps consistency with
> > @@ -400,13 +407,11 @@ int jbd2_journal_write_metadata_buffer(transactio=
n_t *transaction,
> >               jh_in->b_frozen_triggers =3D jh_in->b_triggers;
> >
> >  copy_done:
> > -             new_folio =3D virt_to_folio(jh_in->b_frozen_data);
> > -             new_offset =3D offset_in_folio(new_folio, jh_in->b_frozen=
_data);
> >               jbd2_data_do_escape(jh_in->b_frozen_data);
> > +             new_bh->b_data =3D jh_in->b_frozen_data;
> >       }
> >
> >  escape_done:
> > -     folio_set_bh(new_bh, new_folio, new_offset);
> >       new_bh->b_size =3D bh_in->b_size;
> >       new_bh->b_bdev =3D journal->j_dev;
> >       new_bh->b_blocknr =3D blocknr;
> > diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> > index 699970b4bbf2..20b8fca1abfa 100644
> > --- a/include/linux/buffer_head.h
> > +++ b/include/linux/buffer_head.h
> > @@ -172,6 +172,35 @@ static inline unsigned long bh_offset(const struct=
 buffer_head *bh)
> >       return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1=
);
> >  }
> >
> > +/**
> > + * kmap_local_bh - Map the data of a buffer.
> > + * @bh: The buffer.
> > + *
> > + * Buffers usually live in the page cache, but a few are built over me=
mory
> > + * which is not.  Those carry no folio and b_data is already a kernel =
address
> > + * which is always mapped, so there is nothing to do for them.  Pair w=
ith
> > + * kunmap_local_bh().
> > + *
> > + * Return: A pointer to the buffer's data.
> > + */
> > +static inline void *kmap_local_bh(const struct buffer_head *bh)
> > +{
> > +     if (!bh->b_folio)
> > +             return bh->b_data;
> > +     return kmap_local_folio(bh->b_folio, bh_offset(bh));
> > +}
> > +
> > +/**
> > + * kunmap_local_bh - Unmap the data of a buffer.
> > + * @bh: The buffer.
> > + * @addr: The address returned by kmap_local_bh().
> > + */
> > +static inline void kunmap_local_bh(const struct buffer_head *bh, void =
*addr)
> > +{
> > +     if (bh->b_folio)
> > +             kunmap_local(addr);
> > +}
> > +
> >  /* If we *know* page->private refers to buffer_heads */
> >  #define page_buffers(page)                                   \
> >       ({                                                      \
>
> When tested ocfs2 on next-20260831, I've encountered the following NULL
> pointer dereference:
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>     jbd2_journal_commit_transaction+0x932/0x1b10
>     kjournald2+0xb2/0x250
>
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit(). But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio. So submitting such a buffer during journal commit oopses.
>
> A simple fix:
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk=
_opf_t opf,
>
>         bio =3D bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>
> -       if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +       if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +           op_is_write(opf))
>                 bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>
>         if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
>
> Thanks,
> Joseph
