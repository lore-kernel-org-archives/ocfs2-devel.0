Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5A73CB2E9
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 20:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785961854; cv=pass; b=hYfH3lSvgXfBjvAE+WSyP5mHdAcZx44iNPYlIpQszF3HCqWyfYoW+YmoGBrdw1w3PohELCxp23kHeUCwwlgzFp/bA206Qonv3gD4rYMIS0dU2UrLA/5fNZ0itVs2FL16Otsh7BQbvXL2k05HoWlHOZZyuF+G15OMzVx+jbTGTe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785961854; c=relaxed/simple;
	bh=f8z1M1nzjLf68Sy9PkkSF+yweuJVjVDeAp0nHMvwWIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NEbhpsqNELzchGdY/D0N+KjX15fBK5KFknUuUt2quth7pRd8etKMxHXzSFIZp7m9rfN2iQ5ky8ek/3G/Y0CVpvwh07k1bEIyJOqoh9jsH3pbRHTFvpI9byyJRDxgqTb/vJpG3nvPOhmxcPaPAJgIfA4DeGSWscyokDW0XylPgPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sfesb6z1; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sfesb6z1"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6a18e24ad25so509470a12.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 13:30:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785961849; cv=none;
        d=google.com; s=arc-20260327;
        b=Nu5KgME9llML6i61fG6iP52zA2MarO/8LdV7w3i0kRFnGKwJoJa5Kam9ufb8pjZUfm
         nCi48KetDCBfrzCXmnqx6Z0Xk4yI4rDczrRNk+0b6Ppqh31OvDwFdMCTBQnJ6iSfSWUa
         AIcAaeSGrvEKlcxQh+Vm4eEY0xgeWK/2TxbmAhXu/nJDwAfVTM1nt1V8V72HMVwYjyjD
         bnHZs0FGGymeBCiuKWCt+lnt/Q16GnpMWYHSuzLPmTMvhCzNZtlOMIX/Fyf//8juMGx/
         6k1z/YkVsVgOb1zEdafcINEiWNa5X2vFM/zlKYUPjckH5F6ef1g1MZ4CrFZX3PmWPvgi
         tsUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ukL6w1a2HyKi8WGdg/EkyTugmN726KV6XvHTOGb21IA=;
        fh=9ZlyTx30+olMqUjRodipnirp2I7Ib8sZYykzPq+Ekpo=;
        b=BxEKxI8WpNKHuCGq4++WMhKVB7iwbWYYuGgclADoVBN+xa3yt4h5K8zykc1Vg5eeVv
         5TpdEro2KE0t4kNKuMO+ZsDmSjhKLfKPiM5/jUk9wUkRpV27sDvskNJt3eqF2VSRyQiI
         xx5Ukt8NyYjtzKyyfM+m196A8K6ailop99eYGqfUJOxx9KdV9IswfHI0+rlHYUm/emc3
         /iHWCdHOFmhEtsB7PaxEd+ESwHPbwrtJdJ8fd/6jy9KdHe/p1TrMckneB1yiPPjxFQlN
         kzUzfL0lphRrFBEPTdxSL8x8a21k8dznFx3OrlsQSepeCv0PDKekJXvbY8T55gZw0AmN
         nJZQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785961849; x=1786566649; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ukL6w1a2HyKi8WGdg/EkyTugmN726KV6XvHTOGb21IA=;
        b=sfesb6z1qdYYp7waQUxddHNAy70DKqYWWPQNBhu08PcWpyW+0a+X90OlzilB3uPwew
         X5J2OmUBTf8DG5FGwuU1hEE7QuB2WzCpmqAXh/v9gBgAUjw8w1onE5dyvZvMJnFQ+hOF
         CmIjRi77lMa43xaRwQvltI2BD6svfz7i+3iRa5kgVqu3oTbXtiAi9dXo1icob3WeLBaq
         zGTyBe09snDSo6zbfZbO+lS1htD5A1FnCp4saqpl+RYUHl7FbWi9hOvJMOK1SequZnQK
         Dn2m/7h0u4dm65ic0QdvfQ4LgvrGOVpfp6TexYboKUvb3MvJdneLstM2KvhS8Wls3YWG
         YLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785961849; x=1786566649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ukL6w1a2HyKi8WGdg/EkyTugmN726KV6XvHTOGb21IA=;
        b=JZPIt5wyeViwuQPTtkV3Pwmy62mCT99Eswo66toDl0cUhiJJ3dmhd72r/sNlTcUBNA
         9HSumgdYefIiAm2VgMGqxc0K+Y1w93AMM0QPyinPxs+lDz0j4u7fFKkCCr4CnEODB+Uh
         PiP/aWjX2Rdw0LqKGK2/MrkTe7NqKuPSvRFa2THrgjmO9j7nx2DY3bj6aWV3CRdI0cUh
         LztNefgeoX4flBSRmpaUD7EMwFyKZjYRhyvsf5BvfIuoF7c+rfxT9ts3JcVCTUqSp25p
         Bd3bqAK1j/VXcuaonqNxnq7kTndmpDD8y6qHTR3GRvTU2AEREuDk8eodVZvTRsnwpIyT
         0ykw==
X-Forwarded-Encrypted: i=1; AHgh+Rp2P0KA4wxBJ9izNuIYRAHBuVc7uO5sLqz0MKNEMM5ndO1FmYYKzqfvYVUjL4MksIAA26XhP94T2Q8fVg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxKXk6gpqEGauzQm2botarM7gFKHcHVrkai1I1nANauEMNt6Nrq
	c4rX7cNlhbpQD37LXvPP3kKX+N9CjO5xQf3NVYe1zTiPwkPuhRGAmBJ0RmSI9VoaxEsoALFMVIT
	TIO3u4GVJoDvfQYrdYm1Ko14vTd6A/qs=
X-Gm-Gg: AR+sD1097S2Dyq1IP6xsmQbbeXNfWG46VncK9LYyTMXVKo2KaAtlIb31ZQIv6dS4BHk
	MhkkMk01kDtCLYfAGnVx/1dd1sKd3o/OSXMUQq39CAUaSlYUo6gKBn0nToU9MlUtwpF3m9Vi48X
	BvtqYVp/5kjKjxaQDB4YyPpqz2811H3qCUVipqwwDEZ+Ic0mEOxtOs/jjEk2Ek5H9+UMBVkYlxT
	HpE1JZLodFimuVBwfTHw1c4CjMUKIIZzu5bjakXsMA4OBpJzuPXzRIp9pc27aUxuT6D6aJmotgR
	WUE7RuufUsQgFOCPVh+WdJFoJDuIsMPSMXjr+sgeds2M
X-Received: by 2002:a05:6402:50ca:b0:698:3469:fa99 with SMTP id
 4fb4d7f45d1cf-6a14effe17bmr5079698a12.0.1785961849170; Wed, 05 Aug 2026
 13:30:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <bd2c982e7c91fcfdb8a326ae8166853351398aa2.1785621505.git.coshi036@gmail.com>
 <zr3we2xntqhn7ieev2khdkqvoi44vrkyd5hhgxjol2bggcllhr@g4wpvgfolwni>
In-Reply-To: <zr3we2xntqhn7ieev2khdkqvoi44vrkyd5hhgxjol2bggcllhr@g4wpvgfolwni>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 16:30:38 -0400
X-Gm-Features: AUfX_mw_SS8RGdpRx5YbwF50WJ1pFJNPD4n9XzsvkEDLkwiQIoG_VK4piD_G0XA
Message-ID: <CACd_6n0ZrHf+oGmZbvvAnMZHRDKhsV0DjHiLBPFGsuO0=Nd4Jg@mail.gmail.com>
Subject: Re: [PATCH 13/19] ocfs2: check for a metadata write error with buffer_write_io_error()
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

Agreed, and thanks for the tag.

ocfs2-devel and the ocfs2 maintainers are on Cc for v2, and the cover lette=
r
calls this out by name so it does not get lost in a 21 patch series.

To be concrete about what they are being asked to look at.
ocfs2_write_block() has never removed a block from the cluster uptodate
cache when its write failed, and the comment it carries today says why: the
buffer is not marked locally up-to-date, so the stale cache entry can do no
harm.  That reasoning stops holding at patch 20.  ocfs2_read_blocks()
decides whether to go to disk on the cluster cache alone, so it skips the
read either way; today it then fails the !buffer_uptodate(bh) test and
returns -EIO, but once the buffer stays up to date that read succeeds and
hands back the in-memory copy - the right data, but data that never reached
the disk, and another node reading the same block will not see it.

I do not have a cluster set up to test this on at the moment, so I would
rather ask than assume.  If it turns out to be a problem for ocfs2, I am
happy to fix it in the next version.

Best,
Chao

On Tue, Aug 4, 2026 at 4:49=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:00:57, Chao Shi wrote:
> > ocfs2_write_block() and ocfs2_write_super_or_backup() detect a failed w=
rite
> > by looking at BH_Uptodate afterwards.  That relies on the write complet=
ion
> > handler clearing BH_Uptodate on error, which this series removes: a buf=
fer
> > whose write failed still holds the data the filesystem asked to be writ=
ten,
> > so declaring it not up to date is wrong and makes callers re-read it.
> >
> > Test BH_Write_EIO instead.  Note that ocfs2_write_block()'s test is the
> > positive one, so the sense has to be inverted rather than the flag simp=
ly
> > swapped.
> >
> > The comment in ocfs2_write_block()'s error arm needs updating for the s=
ame
> > reason.  It said the clustered uptodate information did not have to be
> > removed because the buffer was not marked locally uptodate; after this
> > series it is, so the reason no longer holds.  Not advertising the block=
 to
> > the cluster is still the right thing to do - the data is in memory but =
not
> > on disk - so only the justification changes, not the behaviour.
> >
> > No behaviour change today - a failed write sets BH_Write_EIO and clears
> > BH_Uptodate together.  It stops being a no-op at the end of the series,
> > where the new test is the one that still works.
> >
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
>
> This looks ok to me so feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
> but it would be good to get a feedback from ocfs2 maintainers whether the
> logic change in ocfs2_write_block() where we now keep the cluster cache
> block uptodate after write IO error doesn't break some expectations of
> ocfs2.
>
>                                                                 Honza
>
> > ---
> >  fs/ocfs2/buffer_head_io.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> > index 7bfe377af2df..733ceda79ca1 100644
> > --- a/fs/ocfs2/buffer_head_io.c
> > +++ b/fs/ocfs2/buffer_head_io.c
> > @@ -66,12 +66,14 @@ int ocfs2_write_block(struct ocfs2_super *osb, stru=
ct buffer_head *bh,
> >
> >       wait_on_buffer(bh);
> >
> > -     if (buffer_uptodate(bh)) {
> > +     if (!buffer_write_io_error(bh)) {
> >               ocfs2_set_buffer_uptodate(ci, bh);
> >       } else {
> > -             /* We don't need to remove the clustered uptodate
> > -              * information for this bh as it's not marked locally
> > -              * uptodate. */
> > +             /*
> > +              * The buffer still holds what we tried to write, but it =
did
> > +              * not reach the disk, so don't advertise it to the clust=
er
> > +              * as up to date.
> > +              */
> >               ret =3D -EIO;
> >               mlog_errno(ret);
> >       }
> > @@ -446,7 +448,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super =
*osb,
> >
> >       wait_on_buffer(bh);
> >
> > -     if (!buffer_uptodate(bh)) {
> > +     if (buffer_write_io_error(bh)) {
> >               ret =3D -EIO;
> >               mlog_errno(ret);
> >       }
> > --
> > 2.43.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
