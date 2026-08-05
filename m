Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A395E3246ED
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 20:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785960515; cv=pass; b=GzWvwZQTlDjsg+ZK+F+jcPgYM8yMjiUBQ8mFj8sf5jtJklu/uHLC32/IXlvepZrbUrZmEtvpYFMsnCtDMN7Ix6J1MMUn9JovGjq8VAWU9SS5e7fJ1T/rwzhSvNflPIMeRMeu6Y3xQo+KujXb27OpoW997FDo06xbbdkMxwEYc+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785960515; c=relaxed/simple;
	bh=dcnH6nAMoToD8W2PlOqGbdIQ0CwYDRECs1EnTxefy+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZwoQzY7rACC8PRecVmT2Y9nozOr2W++tWanf0vu0y9tXbX5aKjFACwo05vZalAMEWLkMUBV8saOAKNsU9bZTuqFbY4NlCrcv40iXlnMIDbopEyqi8E53419yOqTHMvTnLyCOYb7Do9xTxwI7zpJduFpaqJWRFnJIfwctitVlEN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DNxYErtu; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DNxYErtu"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69fc9f25118so1534899a12.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 13:08:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785960511; cv=none;
        d=google.com; s=arc-20260327;
        b=J45bNd1P5GmfbWz/ArEH8VFUobHyoZex+2HxUreaN6iMnC6AcfYDABZgmMsjTKgjyU
         buIZrWhDUiKzsJkVBiIhR4BUFvzhEjIBtxDAwVLPPgy1/YC1YrvNy4skw14lMJUjUk8h
         AP07/0u0D0MPq3w9ho86X8gAxf+SYAraKghYAIcgX2ZA9gAADYvoZCghe+s0zp6h5Ead
         yGqB+ovfg+QI3u1K2ZlfGRPqpemFGkxjHtkWRqbu7y3grG6zOUTgraRCE56zwDLppojT
         jWIY30qhKfMZQn5yVSXX+BhFmCp0Yt+zCJfSNn1mVaqsOJFVnrkzoaVSMCGIkf91BtWi
         //rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ynrqdlhZ91y0Zv8KPKDZQ6wEEWPqJVnZyD9Ks4Cipks=;
        fh=XAL/6jid+FJNoMhxpLFziYd0esli1sAONCdqfQsJmNk=;
        b=Udt5KvjjRPh6JrAFi7Z1Khrb6DV8Os50xCJbmNw7VDThXMRe7IBhkgj5lsoSC96ASY
         IEUPETE9Dca+bl/ea2icKEzfIS4c+7qa0Cmercz7h6O7g0tZApEg+55mSScrhO6kCgAe
         3enD5SNJVh8G0xYNEoNmEf1ZlUhgd7J0DziI7wAQZMhzbssWUAoqCt00uAo2tWCyY/Eo
         D4cai8xpQjx2vTFwHPUVZDf0Q47bbiZLr6rQhbjqp89hiFNgRFeNGLC+tbIvdVtXpwVg
         aTzrr3xpJwpwV2iv49HKZT7/wH/LV0MAS1+3Li00WmiF8fiun34GksVLsWv9xbB4pFfx
         aj2Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785960511; x=1786565311; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ynrqdlhZ91y0Zv8KPKDZQ6wEEWPqJVnZyD9Ks4Cipks=;
        b=DNxYErtu9Qff+tSwBlU1FJQhHv4Aypb9fGn5dfXZoh+8/SbwUXuAYzeSapEQhFzDwu
         Vjw0eO4gnXJ13CDFVrU1tgGd3ZnfD2XezBpyo3C0+BmAW3X9G7oVhV/uuINLFvHNFP7Z
         msRjJ4wnGMK8P0xw6q6Uf4DBsUP8Y1PwcRReDGFgmIL9W4Mg+ZOVdqwN433bSzO1wMez
         3tj4LJ+MhDWCpSaJhBEQxZx9ysuYlIGylKy7ZCCy2hITw8AtyDs+85KGqD2INr0BATwc
         xq5lyiuHNdvQ5gX/9LagwuSV5D0yxhET3+Y+o09mx1ZouAtkIQ9wqbRXHq0y6SBnB3Y4
         36bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785960511; x=1786565311;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ynrqdlhZ91y0Zv8KPKDZQ6wEEWPqJVnZyD9Ks4Cipks=;
        b=rQrFb6i/LVErfarGncmx/1DH0mwMXH7U2HtV0uUezoASBeBEuIgQ9kd80CWNYHB9yt
         0Oh981Gse9SLY9xPG5zZ29Mtbz95okoOS5mrQ7E4uHKObflUjMtJf4sbMQM2BZ2e8AP/
         mja1FNNNYG7Ad9auktJc73A8r0IJD9jRre3N4L8aiKmucGgFlOul3diZfHBl4j9kszSF
         bcmvWo3HKCP/OZMDNtF9f58v81l1qOqAO5qMKQzzInWPsH1b3XopHDt6hX/3i4km7VA2
         KdRpJlVyL6pBOclfLXI46CbmctCYrQqgV69XXoGZIgcqnFWXgcE6fOVA6qy+nkvSa0qv
         0N0Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqq7rx6Ygar/YXsdnWrpZFj89NCnTRwuL8lLL+4f2RVDyVyVl8rPinK7YMSmzjKgshj+ModTsJ5+DD8AQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwAWay/saofuEOsRZlzHouX5JkQXvCWxWihpF7WlQy4XCQ8zBV0
	0byHyT/5DIPXghWxhKQK3xl1seYwat/rjyQ+ta/lHIZtu+IQbZZR811OHUBA/2mJ5tAuxd/YLPI
	1Rzga/6pnQbyeH7qWpQujpX8xyNGYaZg=
X-Gm-Gg: AR+sD13J6VETC++AFdESxH1qVhYjb59LyyspbqnbGqCC0wBKvVYQBtCQvg19+lOm54q
	hxn/U3uTUH4a1S0dVsFxannpEN6F4RW/wTc/qDK4ts6Yfp+D1d7LvJXctQE4+Iiodi0ihFcqeJQ
	NdryPDAvfWGUJnih3g9G5Wc67N+6k+6ISJLnhHnWp+3sVH9mTXA1UtwcNvQyR4qbUu9Np6uQWxv
	0yUhw0OXKlJY0AXOJpouwWhyv8jHCVIaDpcskdIo5am4NlFIP6fi8lNzWrNtLlva6NSKIlXihOd
	vrTVj4ZCtwDS46g8kfaAxwlFqnARnkcYl/zoaeo9P+5d
X-Received: by 2002:a05:6402:5416:b0:6a0:926e:f8f9 with SMTP id
 4fb4d7f45d1cf-6a14f07bbc4mr5124454a12.2.1785960510703; Wed, 05 Aug 2026
 13:08:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
 <z5jfe6bsxhgqqgjtxcm7ass2fslc4ynizvpmzlqxtr6rrfaopu@fxzntlxafmxj>
In-Reply-To: <z5jfe6bsxhgqqgjtxcm7ass2fslc4ynizvpmzlqxtr6rrfaopu@fxzntlxafmxj>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 16:08:18 -0400
X-Gm-Features: AUfX_mxgWX_SrUpIktUbfQ75eZAdB8HOgpBdd-DDrx5djXTy8AE98I_F_BmiHsU
Message-ID: <CACd_6n0GGwW16bU2PguYhCou8v0q3K5tU=tLS=QfknpUkQinYA@mail.gmail.com>
Subject: Re: [PATCH 02/19] buffer: allow a buffer_head to point at memory
 outside the page cache
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
Thanks - changelog reworded along those lines in v2: a folio-less buffer is
a narrow thing, most of the buffer_head API will not tolerate one -
touch_buffer(), the async read completion path and plenty more - and it is
the job of whoever builds such a buffer to keep it away from all of that.
NULL only buys us that getting it wrong fails loudly instead of quietly
following a slab folio's ->mapping.  Reviewed-by carried; the code itself
is unchanged.

On your folio_mapping() question: it is the right call in general, just not
on this path, for the reason Matthew gave - it would hand back a
swap_address_space if a buffer ever sat on a swap cache folio.  v2 does
make that switch, but in a new patch, v2's 04, rather than in this one; my
reply to Matthew has why it cannot be done here.  And agreed on forming the
bio directly for these temporary bhs eventually - that is a bigger cleanup
than this series.

Chao

On Mon, Aug 3, 2026 at 12:13=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:00:46, Chao Shi wrote:
> > jbd2 builds a temporary buffer_head to write out the frozen copy of a
> > metadata block, and that copy lives in slab memory.  Today jbd2 points =
the
> > temporary buffer at the slab folio backing it.  A slab folio's ->mappin=
g is
> > not an address_space, so anything that follows bh->b_folio->mapping the=
re
> > gets garbage rather than NULL; mark_buffer_write_io_error() does exactl=
y
> > that, and we are about to start calling it on this buffer.
> >
> > Rather than teach every such helper about slab folios, allow bh->b_foli=
o to
> > be NULL and let b_data point straight at the memory.  Code that needs t=
he
> > folio has to check.  There are two places in this file:
> >
> >  - __bh_submit() adds the data by virtual address using
> >    bio_add_virt_nofail(), and skips the cgroup accounting: a buffer tha=
t is
> >    not in the page cache has no owning folio to attribute writeback to.
> >
> >  - buffer_set_crypto_ctx() returns early.  fscrypt has no interest in a
> >    buffer that is not part of a file mapping, which is why it already
> >    returns when folio_mapping() comes back NULL.
> >
> > Nothing sets b_folio to NULL yet, so this patch is a no-op on its own.
> >
> > This is deliberately not a general capability.  Buffers over highmem ha=
ve
> > no permanent kernel virtual address, which is why folio_set_bh() record=
s a
> > folio and an offset instead of an address.  A folio-less buffer_head is
> > only valid over memory that is always mapped, and must not be passed to
> > bh_offset().
>
> There are much more things you cannot do with a bh that doesn't have vali=
d
> b_folio - touch_buffer(), end_buffer_async_read(), ... and many more. But
> that's a bussiness of the code that sets up such temporary bhs. I agree
> that setting b_folio to NULL will if nothing else lead to much more obvio=
us
> failures than when we accidentally get slab folio. So I'd prefer we updat=
e
> the description a bit in this direction but otherwise feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>                                                                 Honza
>
> >
> > Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> > ---
> >  fs/buffer.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index be8b57a635cd..04fcc34e4fa6 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -1099,12 +1099,16 @@ EXPORT_SYMBOL(__bforget);
> >  static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer=
_head *bh,
> >                                 gfp_t gfp_mask)
> >  {
> > -     const struct address_space *mapping =3D folio_mapping(bh->b_folio=
);
> > +     const struct address_space *mapping;
> >
> >       /*
> >        * The ext4 journal (jbd2) can submit a buffer_head it directly c=
reated
> > -      * for a non-pagecache page.  fscrypt doesn't care about these.
> > +      * for memory that is not in the page cache at all.  fscrypt does=
n't
> > +      * care about these.
> >        */
> > +     if (!bh->b_folio)
> > +             return;
> > +     mapping =3D folio_mapping(bh->b_folio);
> >       if (!mapping)
> >               return;
> >       fscrypt_set_bio_crypt_ctx(bio, mapping->host,
> > @@ -1142,7 +1146,11 @@ static void __bh_submit(struct buffer_head *bh, =
blk_opf_t opf,
> >       bio->bi_iter.bi_sector =3D bh->b_blocknr * (bh->b_size >> 9);
> >       bio->bi_write_hint =3D write_hint;
> >
> > -     bio_add_folio_nofail(bio, bh->b_folio, bh->b_size, bh_offset(bh))=
;
> > +     if (bh->b_folio)
> > +             bio_add_folio_nofail(bio, bh->b_folio, bh->b_size,
> > +                                  bh_offset(bh));
> > +     else
> > +             bio_add_virt_nofail(bio, bh->b_data, bh->b_size);
> >
> >       bio->bi_end_io =3D end_bio;
> >       bio->bi_private =3D bh;
> > @@ -1152,7 +1160,8 @@ static void __bh_submit(struct buffer_head *bh, b=
lk_opf_t opf,
> >
> >       if (wbc) {
> >               wbc_init_bio(wbc, bio);
> > -             wbc_account_cgroup_owner(wbc, bh->b_folio, bh->b_size);
> > +             if (bh->b_folio)
> > +                     wbc_account_cgroup_owner(wbc, bh->b_folio, bh->b_=
size);
> >       }
> >
> >       blk_crypto_submit_bio(bio);
> > --
> > 2.43.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
