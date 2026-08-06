Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CBE372B58
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 19:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786045592; cv=pass; b=op374DnPTzcB04HDZERLzmIOI3zolpDOs6zdCf2mCOY4WdS/8hTkR9/ewD5Xm8VGWZ3f5ETWZoqtohSj9PW8wch+y8nXZ4chLUwv/FFA9nM1BB7nNhJXacl51HBVrLuHI58Lx80s09acgg+YAziJK0202M4xH5J9LKjhIiNj3as=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786045592; c=relaxed/simple;
	bh=/grpQlkFIsjOtZJ9kjTYgO1M00ZnDq0iZMthC0cITsY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZS2YOHB1WdZ9rxXA58a/Z1rzulF0D/FQuoZVX522vZA60TIstLGAPL+z5XYObSnRAP8l7yWYONX/U066LXuydod53n9RElwxHjRsmqft0Vnu5W/CiYiPlbpJW9na03zjUHCkBQLaW6ONHj9leK8Fv8Erb7CBZOSMG0SA7VVmoNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uom3yPLo; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uom3yPLo"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a0c8283146so4281105a12.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 12:46:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786045589; cv=none;
        d=google.com; s=arc-20260327;
        b=mXplgISUcNYmekV9OYqxLZxvZVDNUCRhBtht0XNEFTBJKYEQcc9AHYyvccrzeYlg0H
         CJs8m9WI1LgQozNzu8nGpDRuJnivOmf6pAdIllEG0ABszta0pk7xfOdkRBsjlQXrnnBE
         BNu69/JbKruw2lIt6f45pS1wN8c88OztMic34YiWwXk08T/eDwx2a40O2yN6VmTMM0hg
         eDdtlmDfgQV9xWsv/MBn3qgINXUo2uJTx3YfL4jnK9EuPpydcRaQZmuLOjDgROjuXRXf
         xG/j3bRmTOf8hkHP1/PleMh/I2POJKCzCiViKpCQ0UrS2czwrC1AmA8YvqkjowKcxp+J
         YPmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nLbIcjJWlLYm7ckgJdCevI6JSBS4OVTbw09CC4o45Ao=;
        fh=yVzwEpqh6e//D97hY+VwOctbBCsoegDd8NIc2zP8nPs=;
        b=jVUhOszoRW8zO5vzguzYsF4c0V4O1Wcib2zt7NTiTO+f3h+I/izcwwop9I4mX5qgVk
         Ip0uCfvmGzFLowhr/zVQ+AWDW9ADd7hko/dgQaPEUa3vn9y7BAoNEdw2y15EeZevod3E
         AgCNVZtMXTP/XnjxLOtwe1x1dQ9VVryALvsQ7tYCEKFJv+CexqXSKPmCT3vmd1kELAaY
         ySQ/kDmzOop0E/uwFXcWRqh/xv2i+I/dxE+x0ChSxqiF/wcPOdIeVa95CelBRJwWbdj7
         xeV1lZ7mNu+N12ND3S2Upi4W+2QqDgTELGctPoWftCMmPmzW12a43CCVTwKZhhIvIAwb
         RGsA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786045589; x=1786650389; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nLbIcjJWlLYm7ckgJdCevI6JSBS4OVTbw09CC4o45Ao=;
        b=Uom3yPLomjQUm3dlw+y8epgpPjcds4dFu6+z19dRsW+L+EKZRfCPqqAk2QzbyT9x97
         7+9a0Q+Iqn59DngeEHkgIz67rLrbt5MuSS6YylHK8qQEaYSb/0b2kz7qmsQkv5H68+lk
         XlzVY3DoEBE0rfgihKotaxQhYer/bs+i/SIwjGCaMd1pN+CK8qDy7AU025rBF/lgS4P5
         DdVGNc/A2zgyAgC71TzWbtXEb5ucW6NqwPts+beBB5rVy2g0cFnQZaAmIf94jABtmBgs
         UAAlGDeC9tsWwbP+KTn0a8dElsmm8sbRDboEwxmcWh8YOVgJS0Q3AhQ4Etnom5IdrYpr
         LCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786045589; x=1786650389;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nLbIcjJWlLYm7ckgJdCevI6JSBS4OVTbw09CC4o45Ao=;
        b=az1xm6TV58nxeJ0BmCitXabE3zlzBwGRNrtUJWsUAtzN2sCvZ9EYXzItDyGZL0DcYP
         oOAMG2qtOPk7jDiuIsT5hpMCYeVmHbqqN57rirnfiulg/aWEPvLk2hAwPneM3wXNZ9Yz
         GnekQKASAc6yQPTt6k8+ZSGNSzGxmCI/fnaoogkqk60doZL0DnoQ8cP4ttubN969xkKE
         sgxlHXWK1oWrPo1LH98xpDnsl29rNXL2nnFDGCJSDnjBWbUwgNyIPdvATxLaXD9yWZNn
         zOaGGG6zpSc1SwrURnoybixdPKOAGXa2F9lAJtgCgPjuV0xTeb93Cpbp4TcZGRtxbrOk
         Fy0w==
X-Forwarded-Encrypted: i=1; AHgh+RruL4XCO9DVehfA8eHq2tueUXjqdze+EqTmeydP6CNYU6EUN659sFfbboySHAv3fTLrROslwfJaD7R82g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyvKWOv/bIB7gv7CL9HSRL0HA2Vg+Kt7UhxGR0D3UyEIfr0uzjg
	dVHOkQBvr8n3xGVoUQF0m5hIXZ/25vwVmwH9EEVOEpGQGySR3HveUzF85CzL0SI+X3j+6t4iMKX
	7sMeD98+acVjTzG+m8laCMPJAtnAU0tA=
X-Gm-Gg: AR+sD13BMDUtWjosnexBoc/VqALppVezvnX/ZkiT5XBy7ar8qWUq6EZCNiI4rSJZail
	Rhti9F3LVrdAC6DtpmmiaF+Pw0jbMJTFFliboteXG+i8nrHvp75TCoUkOt06ZBfI2MAbq4LCOmQ
	RRuphmgD09jvhiOtNuQwXuVIIKYgsUeZd8F3U5CSu9SVzbteuKHSgyPCtAbYWYPigHIQ1u8XOgk
	WlQtJQarqc6onOIA/Q3NVT9JmVd34I7f8atYvdLkSbaw+l4O6JSf+u96kEEG2v1uSVlXiTQwdVp
	Mc3uJD7W7qYo3jYa/cFIDcpe9Y6QAlHXq132NPzyhOTL
X-Received: by 2002:a05:6402:a5ca:20b0:6a1:8ec3:764b with SMTP id
 4fb4d7f45d1cf-6a18ec37760mr3594879a12.17.1786045589025; Thu, 06 Aug 2026
 12:46:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>
 <anDZ5YG-Ljflv7Vm@casper.infradead.org> <anFYf1iKrNLAjJMw@casper.infradead.org>
 <CACd_6n2GY2RRQPeKtJEuVkHcSBN-Ne2gJdHRfwxg2i=OT06MFg@mail.gmail.com> <anOf4vNU_XPvyhb0@casper.infradead.org>
In-Reply-To: <anOf4vNU_XPvyhb0@casper.infradead.org>
From: Chris S <coshi036@gmail.com>
Date: Thu, 6 Aug 2026 15:46:17 -0400
X-Gm-Features: AUfX_my3MOnB94S3irinQYPvJ_IWdDZWDeP-gGrdJ_Rtf7S3jrdVnkhoJS9GiKE
Message-ID: <CACd_6n2pHtu3aKWc0TbQ04BEwa7Loqcug_=5i5KGo9w_-tZBGw@mail.gmail.com>
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

folio_vmap() sounds like the right shape, and nothing in this series is
waiting on it, so there is no hurry from my side.

One thing worth settling before anyone writes it, because it decides what
the callers have to look like: kmap_local_folio() documents "Context: Can
be invoked from any context" and has no failure return, while vmap() does
might_sleep() and returns NULL on failure.  So folio_vmap() would inherit
the weaker contract from the one case that needs it, and every caller would
have to be written for may-sleep and may-fail even though on !HIGHMEM
neither can ever happen.  That costs the jbd2 commit path nothing - both
checksum callers run under jbd2_journal_commit_transaction() in kjournald2,
which sleeps freely - but it is not free everywhere, so this may want to be
two entry points rather than one.

Glad to talk it through, and happy to write it if that would help.  I
already owe you a look at the bs>PAGE_SIZE callers once this series
settles, and this is the same errand, so it would be no extra work for me
to start there.  Entirely your call.

Best,
Chao

On Wed, Aug 5, 2026 at 4:41=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Wed, Aug 05, 2026 at 03:02:05PM -0400, Chris S wrote:
> > Thank you so much.
> > Taken, with a change: the helper needs a matching unmap, and must not m=
ap
> > the folio-less case at all.
> >
> > static inline void *kmap_local_bh(const struct buffer_head *bh)
> > {
> > if (!bh->b_folio)
> > return bh->b_data;
> > return kmap_local_folio(bh->b_folio, bh_offset(bh));
> > }
> >
> > static inline void kunmap_local_bh(const struct buffer_head *bh, void *=
addr)
> > {
> > if (bh->b_folio)
> > kunmap_local(addr);
> > }
>
> Ah, I hadn't considered that option.  Yes, I think this is the right
> approach.  Thanks!
>
> > Two reasons.  kmap_local_page(virt_to_page(bh->b_data)) loses the offse=
t
> > within the page, and b_frozen_data is kmalloc(b_size), which is only
> > guaranteed page aligned when the block size is at least PAGE_SIZE.
>
> Yeah; my bad.  I should have added in PAGE_MASK(bh->b_data) to that,
> but what you have is better.
>
> > The second one is your other point.  With CONFIG_DEBUG_KMAP_LOCAL_FORCE=
_MAP,
> > __kmap_local_page_prot() maps even a lowmem page, one page at a time.  =
So
> > mapping memory that is already permanently mapped would walk this path
> > straight into the bs>PS problem you just described, which it is otherwi=
se
> > immune to - b_data covers the whole block whatever its size.  Returning
> > b_data and calling kunmap_local() on it anyway is not an option either:
> > kunmap_local_indexed() WARNs on an address outside the fixmap range und=
er
> > that config.  Hence the pair.
> >
> > On the bs>PS folio path itself: agreed it is real and predates this ser=
ies.
> > I would rather not fold a fix into this one, but I will take it - I'll =
look
> > at it separately once this has settled.
>
> I've been considering adding a folio_vmap() which would be a nop for
> !highmem, kmap_local() for order-0 highmem folios and vmap() for
> large highmem folios.  It's not reached the top of my todo list yet.
