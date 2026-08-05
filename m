Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471DA32E6BC
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 19:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785956550; cv=pass; b=YdE6iskjNJ/UsVMhtQsT78hqXIEnDt+K9ORU7Z5iYBwZ1C0ml+NDzoavHzHyZ6vnHb4nv6KXrHJi3udGxyQii4brCU4+ujTR0aM2ntbo/464ZW1WiPvEOEeP4PPWNa1sPr3+CmIbzp7rs8YkTowOonFrbDwGJ919vhaBYv60aNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785956550; c=relaxed/simple;
	bh=ALS4z1Gntn76BUGW7fczi1PamcwbMhAJ+HBZQNl5qW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YNOt0uHzJDde+LQQe2pSpO1FWaC+9/LUn4ivy5+x4YczkODcsxh82mLPQ9dfXdCdtRPVyQ3DpY+9oJZ50u2Fl1BAi6GOzZc++qOdZtmhcf20wtmw725kPzi2KlB81tQzkn8a7vhHc5F+RdVkw1ec0e7VtLCl55bolq0XXM/e4rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UwBH84UI; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UwBH84UI"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69fab5a852cso1956663a12.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 12:02:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785956537; cv=none;
        d=google.com; s=arc-20260327;
        b=edq+4tJIKSE/y2lOnppMK6lN9flRqMqFmQkdM0w2kuMUpKyxRuLTQaTXS/8vh3OFia
         mYdMJcZbyfkTNy7SMwfuNOPmpdsppGjlbc6q6dA9Mdu7Xh65LNbQi5FG7QGieoWiJCAp
         f8VEFCLYNgvY/Z7NBUJODvG7Fwa0My3jxVAjpLu+56EDhLB0opZKjhy9qF/M/l1IjQzj
         JT0hZfr3ZmBoGbFZ/w+ZM+xG3NUYejckGXYXp4hx6LPtMjd3lV+n0oNCxelVADXegTxN
         NlMBMeajpeIwZVRGQeW9FGw8Tgjkvqd4NVJUF87AID30pp0aqaWcX4J9gYTbHTO4LW3g
         2lDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bXL8fOwPfzW8cmIw726T8X174t2PQj7sWrk7UD/8Cqs=;
        fh=xtNLcWnLFX3GkA2eGzYk6DDjoClAbSOqgi7jd0H01W0=;
        b=BS4Z56mYJEBP+IUNMCFZhKjL/OS7hnsFlO9iC9daNLKpaU+9TCw953aV4wbVJ/6bbj
         2k+KEoR5u49c6QwdK2rhocFsx/I8yN82fAOLVTwxpdo0Kfq1k2xsQ9l4jEUjbWXm1W83
         bcv8U0nTCoppQeCVZW2dxx8I4nX+ssBx0efWB6HPX3lTpi0PrRF98OXwAoNy8BzAZjfk
         4fXWFm+zuK0Q0f3zVbvvZxBKsTzp41naF9orQeJb9z0Dc8eDXG0E+0sYRK5DtG5D25fY
         xsZm8SMfzYHs4Z05LdCiznOT245WC7II2O1jFXHHTmeLPfwshIXE/kIFc/Lmjox/YNSh
         CTKA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785956537; x=1786561337; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bXL8fOwPfzW8cmIw726T8X174t2PQj7sWrk7UD/8Cqs=;
        b=UwBH84UIh9cENcgk5qBeqoo5wOMVoVZUSMMOkkTHyPPeNX+7G80ZpYoI8397iDEY8C
         BFpZ8tcSrpDNPQlQjvNmfyHWa5R9MzJh6btRSQNB68hrRdiYiyP+mYvPkifvkugls/wk
         sIT+ab4mxw3rHXPc66KJd+iKi0kmQTouW+FBayubpJU68nYHFfh0rZmlvR2CchyJoqCb
         43omGUlA9hf+rSxpuKK7VpOwkKz4v2IAWDlKBvMbKtvFcF7ghABPN2pd4SEQfBUczAd4
         ySgjBQdI8DWxAYLWobUpVJopdFbCJkS1uNedddaNeNe/dmZ03zaHTu6MQSK9n5IHa9iV
         wjmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785956537; x=1786561337;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bXL8fOwPfzW8cmIw726T8X174t2PQj7sWrk7UD/8Cqs=;
        b=L3aOPrgnNa35+1MSQrPJS5y6mJPyjJlihzhMCWKRZzeWjpDVMN6FQXDDdjY7c+Hk54
         gRX73DuDJLFJciZLJpTiDtNIR8DgGcZTPtRqzu+6Y/NOKaiSXK8aBTVeej5HifG/5Zm7
         po3VeMyVw5jrcB57Bplv80hvpWcCGc/QgOgsqLsvQxhQALhfdap+CP4BTj6I9mU6OAhR
         lhKyn+rKswCpOmrh6GDElN4KBKpHQvMgOC6GMHvNxiHqoSds7tUV+b0qoneqB5zneKvF
         aRtQaj8fklhSL/mapNDMtYGuWu5sborNxFns52Y22cFuAMFtsxJGjk+/gcO6f0XhTNvf
         JLnA==
X-Forwarded-Encrypted: i=1; AHgh+RoTO2OjXfsTfIE/zp/vZtOAHNTrGipdyKA6onSQ5LLuQvBnpdbd1vtFg41sWTGbqM+bpJiFxKzwjzsJwA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzMNfTqDZ5BEV4/hMdam8mGDmI/ULxgLtrvVzDUqToElNM8EFpd
	j126AF3JQxbv3K2Q01TUg+8CSsSop6UY5yw5sP3a8uOwFw++71u6yc0+bbRwumJjsDg294NhEdk
	VOfncGAy6UwkCrMaEuZwIdfUSMrjWbzY=
X-Gm-Gg: AR+sD10+LnmRyvohJK+vJuUHM7VtaFNqZ6rwDeuVO+t5BifOsoSq4X1oNeH8COFjvlH
	bMs4qs1lpb2NSzKsoc2pRCgn4SmOLnN51Oj9tDoKsi73HcE4376Qjr7oVT6czViZc+NbBsA9fa7
	tcgdYK6U3janJR1S880yECdWPtW9uvaC9CiBpK6GaClePqqXUhjqzLw2S8Gr3x06W5rDllv+LzR
	ik9ysqQ7LOK5eqR2+f1HBAge04fJ5R2zoCyrk1ID9D/8t8th5HqtkLL/ardyPI+HTYmgRWNGzTa
	srLWEyqt3vggpLMvdvEyLXmkkHhW3tibNcEyB6yEqrJM
X-Received: by 2002:a05:6402:e87:b0:6a1:28d8:2306 with SMTP id
 4fb4d7f45d1cf-6a14f07bc72mr5050205a12.1.1785956536576; Wed, 05 Aug 2026
 12:02:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>
 <anDZ5YG-Ljflv7Vm@casper.infradead.org> <anFYf1iKrNLAjJMw@casper.infradead.org>
In-Reply-To: <anFYf1iKrNLAjJMw@casper.infradead.org>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 15:02:05 -0400
X-Gm-Features: AUfX_myV5AVdy2Vk3b4_r8TJRgGAg0iuSL9FFYfHvWZSH4sclQZJlO_bQY1K40Y
Message-ID: <CACd_6n2GY2RRQPeKtJEuVkHcSBN-Ne2gJdHRfwxg2i=OT06MFg@mail.gmail.com>
Subject: Re: [PATCH 03/19] jbd2: point the shadow buffer at the frozen data directly
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

Thank you so much.
Taken, with a change: the helper needs a matching unmap, and must not map
the folio-less case at all.

static inline void *kmap_local_bh(const struct buffer_head *bh)
{
if (!bh->b_folio)
return bh->b_data;
return kmap_local_folio(bh->b_folio, bh_offset(bh));
}

static inline void kunmap_local_bh(const struct buffer_head *bh, void *addr=
)
{
if (bh->b_folio)
kunmap_local(addr);
}

Two reasons.  kmap_local_page(virt_to_page(bh->b_data)) loses the offset
within the page, and b_frozen_data is kmalloc(b_size), which is only
guaranteed page aligned when the block size is at least PAGE_SIZE.

The second one is your other point.  With CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=
,
__kmap_local_page_prot() maps even a lowmem page, one page at a time.  So
mapping memory that is already permanently mapped would walk this path
straight into the bs>PS problem you just described, which it is otherwise
immune to - b_data covers the whole block whatever its size.  Returning
b_data and calling kunmap_local() on it anyway is not an option either:
kunmap_local_indexed() WARNs on an address outside the fixmap range under
that config.  Hence the pair.

On the bs>PS folio path itself: agreed it is real and predates this series.
I would rather not fold a fix into this one, but I will take it - I'll look
at it separately once this has settled.

Chao

On Mon, Aug 3, 2026 at 11:12=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Mon, Aug 03, 2026 at 07:11:49PM +0100, Matthew Wilcox wrote:
> > On Sat, Aug 01, 2026 at 06:00:47PM -0400, Chao Shi wrote:
> > > @@ -330,6 +330,8 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, =
struct buffer_head *bh)
> > >     char *addr;
> > >     __u32 checksum;
> > >
> > > +   if (!bh->b_folio)
> > > +           return crc32_be(crc32_sum, bh->b_data, bh->b_size);
> > >     addr =3D kmap_local_folio(bh->b_folio, bh_offset(bh));
> > >     checksum =3D crc32_be(crc32_sum, addr, bh->b_size);
> > >     kunmap_local(addr);
> >
> > This is awkward.  How about ...
>
> ... Oh.  It's not just awkward.  The current code is actually wrong.
> If one uses ext4 on a bs>PS device and one has
> CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP enabled, it'll only map one
> page of the buffer and we should get a crash when trying to checksum
> the entire block.
>
> Supporting mapping multiple pages from a folio simultaneously is
> something we haven't figured out how to support.  Since HIGHMEM is
> dying (see Arnd's recent work), I'm not inclined to spend effort
> on it.
>
> We probably just need to make ext4 depend on !DEBUG_KMAP_LOCAL_FORCE_MAP
> or something?
>
> > static inline void *kmap_local_bh(const struct buffer_head *bh)
> > {
> >       if (bh->b_folio)
> >               return kmap_local_folio(bh->b_folio, bh_offset(bh));
> >       return kmap_local_page(virt_to_page(bh->b_data);
> > }
> >
> > (this is also somewhat awkward because it feels like we could just
> > return bh->b_data, but kunmap_local_indexed() does some ... stuff)
> >
> > Anyway, it all gets optimised away on non-HIGHMEM.  Or if it doesn't,
> > you can force it to ;-)
> >
> >
