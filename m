Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F6B3C0624
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Aug 2026 23:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785884821; cv=pass; b=IWcX/nT/14jqqJr5CRwaPxDp8U1m1XP6JI1oWoAfecG34VINqVhBCIenzW/fBFgyTDKhbxSnyJKlKyzmVEj0zqUryQJV+Tv1CdRG2frhCeab6oCCmMJ6AG3QiWgVcy4EIl6F/4E/HqcdWrw2KyBv9mugVFv5UgtB6dSwmf5QMx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785884821; c=relaxed/simple;
	bh=PMpFo1HfD8khbAAlxqkyKZRs/E05UT5D9hNFmyw/iB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KbtX+sk2aUOfC+DvQsvM+YkgblO4V+Xc8OWOttRl6MyYurSSNBEaXs9THmVDtBydMmi1ypxGtSlCwmpnhTmLBmMGWc5QJ2JqBiVRdSiPusidXI/kB3iZrEAfQtvfRRMS9vrwnLub2Wem8qV9jt+ULFdcEujWw17dk7dsMdJqb8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HNxdEG4B; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HNxdEG4B"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-69fc2261f2bso509032a12.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 04 Aug 2026 16:06:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785884818; cv=none;
        d=google.com; s=arc-20260327;
        b=iqk/vIyfrWTGMElF3BHCdkVE7PYxiZ+EbeuXDNu92K8gKtMfXb4h3dvwIAtCgTATVd
         +u/gOOAijC4zxO/sEV/q8Dl3h/dB1CNvGmdhKa8suxZ2Wd54873X8U3jzP+0dGcVbU+o
         Bh3T2C5PBIjcrohoWF5IXsJYJpMSIucsGOxGtoNdGjwU/WRLbxsTmfNI8aiqPNAKjgaJ
         OTvAZ7CqKW4tPbihm0ivICzSfyaoKpfPHu2gU6PJ8uTRLichGDyIc5p7dxS6pBYbbBWj
         hLyYT3/TUSBx6XLZiOKmWGmWfXdlOjJlC/rj/cExAvzXNrIib7myEwF+ADola2HmAfKy
         zExw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qtp00HQe0YEhUVbmZKFkfm9h9fZb8SFvoPIno10cSVE=;
        fh=19dGHdTwS1eH3J2v209x2oTSVUK8AHW9XeJx1vNTJ5Y=;
        b=CfaRQ2PZe2SvNDmjuAzIWrV0xSnG62mS1LvrAeRv1f7vecC6dAFzoGSLnSeC0eP/Aa
         n7P8LQp0UQX/ibzMemTIWqSbP/g4saTyh5sRldHpFrIDhIdgU/uf6HlwSx83g3Jy4R/5
         Lf09UToUiT7ACwUsF/cFrUeR3tk9DEbdJGz/ezF3x0NkQ+Rb3T49y7v/jVns5xxD0tf0
         poONd1p69mekQaQQtyBPuy5Vz1OukqKPgPsq/640XyGumOiYy32IszNuImL7qkaiaC+G
         XKAQx8Mm6FN4VqkVTenVfs6sm7UZr/hdXymPlyI7v1SAfuv4C77D2Jw6hWYW2FcOBnT8
         KS1g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785884818; x=1786489618; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qtp00HQe0YEhUVbmZKFkfm9h9fZb8SFvoPIno10cSVE=;
        b=HNxdEG4BVQkTzcb15cRRQgf00vX6hRXkC56dqxeH3T5SK2jheDr0l2JWXRnblGlVJe
         OwVX0XbVBujaZVYiF/TUTIwfPDPvw9QwP5MYYOT291h9Fqs0uztNXeY2YNn3J5Sv1Xk9
         7glqDLT9AVlra+1mg0XdxxuO7W4DfAhO+0z6rQg84wfFwSb579drAAC1XTurCgk12slL
         mTrVue7v2xx8GGtRKxG0ED3znNop44PCCbZY4dqwLfRC4CiWarwwGI6Q6yOo2MmoKRpc
         mH7KBSMX0h5Z+hwNtEDfD+DDjmqRWmvd114MkuYQHJcZJcNlJs1NYjzJDAeWuCB8BBrd
         3xiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785884818; x=1786489618;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qtp00HQe0YEhUVbmZKFkfm9h9fZb8SFvoPIno10cSVE=;
        b=oBtqspoAI1IfbGn7kEk3T7ZqIQ6cnNa8OaaNnoDztsOYvg8VCrTWmbTfB94LIVj0+2
         n//oE0dIfBNIk2mmB96s+MtbNGjNqJatAQVCSQ9kcDfkzXBfHbDK3WrQVX/ZREG33xAv
         YAsvD88QG/vTWWqDMJ317sVab5L5pGPzNGvQMlMSBXcWKDJGMvMlfsbJ5fv9p4LsJSRf
         wpoFIrlK+eaD284SL+LcvDGwPxyr34gjfIavBypxapjznKHjf+GrVR4+SILA+W3MIO6x
         SkUnLQClMUblOOtxxeMYl6HHxfwbxEbDBwglXhZQPxneDHIw3YHFKYiNZnpI9bcR2sWw
         EgXQ==
X-Forwarded-Encrypted: i=1; AHgh+RpLxkGoAk4VmQjrzYmjcwgWNC7oZMZHgBZwVWMSikCWDSudZYLHLgPq4n8sxjtAn2ntpE09fJAf6RoW9Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YysYH6VooZEnMkJNegUNGG2wl4kVD4B6S+ntToNGAPv7tOWh6UO
	yrozsoNMHVa0IJ+TFBVrnNwvPj7ZNKMUfwHuRsCuYyY9esRpqgq0g1+TfcNpViMkhizmHjDp/DW
	FaSInLegFW2Sg0MD2LyteMBOogHYvTvM=
X-Gm-Gg: AR+sD13E38hYdilcSKBRn8I+vjjJ7DdfgW//GXFRlLre6YsOhI0fxSPmYq47iFHDy/D
	wOmyRMKwTwBTXr4/0lKmZwMkpI3ilgwaukT3aAb9M5dp2vWGJvoc+dW8KjFp2zn3K+8j7AZ4ZJA
	PwEUHZZWa82o+5OQoRYAPev8P/Un1PHl/3zTYJEIWL/9dSaZ08FVBnpfof1n79zDYr++mw6w6Zv
	3UCSFhJ/DJr3V4HtPTABF7IFxaVvtbn53yEYmKa/TUzBYHs6/un20YSFPknNNPhEfj8D6NQ4zlH
	WtrtKmXWcJmq/ji3Sel8USHOJV4YJ2LXBR82xxUcJtrBGI9USWWLg8c=
X-Received: by 2002:a05:6402:5023:b0:699:12e8:1c54 with SMTP id
 4fb4d7f45d1cf-6a14f103f88mr1267020a12.5.1785884818029; Tue, 04 Aug 2026
 16:06:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
 <z5jfe6bsxhgqqgjtxcm7ass2fslc4ynizvpmzlqxtr6rrfaopu@fxzntlxafmxj>
 <anDW5UTbF2d0EQmr@casper.infradead.org> <74ts4lwsq73mce3rvc7imisot436742ykzahnogysnbklot45b@q3nhfq55knx3>
 <anHyBATDe8yQEFNi@casper.infradead.org>
In-Reply-To: <anHyBATDe8yQEFNi@casper.infradead.org>
From: Chris S <coshi036@gmail.com>
Date: Tue, 4 Aug 2026 19:06:46 -0400
X-Gm-Features: AUfX_mywycbzfMLtI3iRX8QYjwuoGt1JUOb_Y0mmTpKfptijtN3o82-3luOQJN0
Message-ID: <CACd_6n0zcg85_p=+dcVK__SECdom8K01BBsdzakuwJ1ibMhKJQ@mail.gmail.com>
Subject: Re: [PATCH 02/19] buffer: allow a buffer_head to point at memory
 outside the page cache
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
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

Agreed, and done - but not in this patch, which is worth flagging because i=
t
is not obvious.

folio_mapping() is doing two jobs here.  The one you are objecting to is th=
e
swap cache mapping.  The other is that it returns NULL for a slab folio, an=
d
that is the only reason this path is safe for jbd2's shadow buffers today -
they are the slab-backed buffers this series is getting rid of, and they do
reach buffer_set_crypto_ctx() through __bh_submit().

So doing it in this patch would leave one commit where shadow buffers still
sit on slab folios, and this code reads folio->mapping directly, i.e., hand=
s
fscrypt a struct kmem_cache and dereferences ->host on it.  Fine at the end
of the series, broken in the middle of it.

v2 does it as its own patch 4, after the jbd2 change.

Chao

On Tue, Aug 4, 2026 at 10:07=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Aug 04, 2026 at 10:07:39AM +0200, Jan Kara wrote:
> > > Yes, agreed.  I think it's fine to add in some 'if (!bh->b_folio)'
> > > tests, but only where they're needed for the occasional consumer.  Th=
is
> > > really is a rare (but legitimate) case.
> >
> > Yes. If we were to write this code from scratch, I'd rather push for
> > forming and submitting the bio directly instead of trying to bend the b=
h
> > layer for these temporary bhs. Eventually we might want to do this clea=
nup
> > anyway (since bhs don't really buy us much in this path) but not in thi=
s
> > patch set.
>
> I think that would be better, but it is out of scope.
>
> > > > >  static void buffer_set_crypto_ctx(struct bio *bio, const struct =
buffer_head *bh,
> > > > >                                   gfp_t gfp_mask)
> > > > >  {
> > > > > -       const struct address_space *mapping =3D folio_mapping(bh-=
>b_folio);
> > > > > +       const struct address_space *mapping;
> > > > >
> > > > >         /*
> > > > >          * The ext4 journal (jbd2) can submit a buffer_head it di=
rectly created
> > > > > -        * for a non-pagecache page.  fscrypt doesn't care about =
these.
> > > > > +        * for memory that is not in the page cache at all.  fscr=
ypt doesn't
> > > > > +        * care about these.
> > > > >          */
> > > > > +       if (!bh->b_folio)
> > > > > +               return;
> > > > > +       mapping =3D folio_mapping(bh->b_folio);
> > > > >         if (!mapping)
> > > > >                 return;
> > >
> > > Do we want to call folio_mapping() here?  The only case where I can s=
ee
> > > this being useful is if we attach a buffer_head to an anonymous folio=
,
> > > and I don't see a good reason to do that.  I think this can just be
> > >
> > >     mapping =3D bh->b_folio->mapping;
> >
> > For all I know yes, bh->b_folio->mapping should be enough here. But I
> > thought folio_mapping() is kind of preferred to open-coding?
>
> It rather depends on the path we're talking about.  Looking at the
> implementation of folio_mapping(), it's actually mildly dangerous
> to call folio_mapping() in this path.  If we were ever to point a
> buffer_head at some memory on a page in swap cache, we'd get a pointer
> to a swap_address_space.  I think we'd safely crash in that case because
> mapping->host would be NULL, but in other contexts doing things to a
> swap mapping would be quite bad.
>
> So I think this should just be folio->mapping; don't risk getting a
> pointer to a swap mapping.
