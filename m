Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FE03DC4BD
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 20:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962138; cv=pass; b=Lso/uaaZ2eVEyTin832xrC9pkknSI9fP6y7ixVr9ZrUiS4alE6RJo45B+ibgyTMpnhqxVe7t6luMW5FyR3UGEIrshnM/GMhVjDPSvm9QIKNwPLIYhzr/yJfuXyLHc/+Ky5qnL46ZDS81j3BEUSs+HjTT3OsGr8M59DC/99iPfCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962138; c=relaxed/simple;
	bh=WSEBgYXrHwYXrkVW8w+RdPxc+qhI3MgH0bYqPdxwfqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SSP2mgxy6KL7ywQqGjOp05PZTsgI2oqq0YDlFlHAhraIZi7So1E8lpxoNm/mxXFaff1sgF4MqOIBqwltkGr3M9dgxdBQn1MiP45wnP4P7DVBQRg1ZbFmV4SsBUihbXi1Rt1iQGVYTa5NzCBiFIN9Ku4laSFbKuW7VKq2vevw8Cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qjqtGoMP; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qjqtGoMP"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6aaea785032so922367eaf.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 13:35:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785962136; cv=none;
        d=google.com; s=arc-20260327;
        b=pn7Rc5rOuLVwNoOtb3htXE1/6Qe8tJBkrdxs4zcQ74bn4kI4/f/yb0dDA+6+kznOvm
         rXnbT0Rv0wSC2tAkT4CS4fqqYkgi1CSUm7g1xxb/hUNNjsyUDvoOwi+UmLUOB8qghkdD
         gznZ5G+TMTc9gG2zx27qqRGrElVj0OiDv5nE9W2sGvzNY21O1sqoKVXNPpfViO94o63/
         AU0AoMGH8GykiTsC3U49qJx+W7Lyn/kbzV2BCWgJ1niq9x6X7praixqD2s7QRCVuw3fV
         lI37IarcFz980OiW+/Uo0wHWQb7jReW48F4hhjF69UHKjKkjv316xFw4lB1+K0JFKMmN
         wWZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BQuE5p94CfqyEpHjKQoO3ghb1Rb0W+FJ1ncrC2gXf/s=;
        fh=LFyqLfEFAhpsrEDZMWsW0Ji5CbbX+zpFWDvPre/YKW4=;
        b=StX2q8kZd8kHHtqK45SSZ6qs4qfPkG89YgFlkNysfQgB9S9g/GeioNYUFFvueB3M2s
         Oun1qOlfiz2iF6kix3/DS06xhyqM3hqcBs65ahCsGZXu5bbzuoP9d37bwv32FL1SZgra
         y1SU05m+PImTbD+FODsCkBb0Umnn9uVXxiPnuK1pXtYirLzJNE2flUzYEcxq+8fS1+Py
         GmLhDw9rdHTGrTgipd9C9krztP7JEtOvIwJyOBv47rGNCR1pvTVZZiNuy6LUJNMcpHy2
         H6zMhwEOx4a7fdeXS7cFO9Tefzx3pKk0qG5gu/pop+BwmzJBslLyR3LGo9sTtw3Dhzwu
         gBSQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785962136; x=1786566936; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BQuE5p94CfqyEpHjKQoO3ghb1Rb0W+FJ1ncrC2gXf/s=;
        b=qjqtGoMPXcXFCgW5+s5ZGuV1XDTs6JeSUabEUvmifiuzzjzJd43gWfGgL13OVGXKzf
         6TodvB4Wa1aJKNla+sz53gNLDllHxIfb/fSS5FVgTyBpFpJySxNCTS1xyxJE0x12j8tP
         bFNT79EW4MmrHpps81NWldOF31hGP2EnDJ/GqwfkwaBVi38bhMxuNq60Dim6AgpU8LzO
         +CtP4z/WwI44i4q1qvJO9+jJ2B3A/hcaj6ADYULpjTLk90+zTyKPuz5VI4ncK0uBzY3H
         +tchWcgROxHEUqI4xJrjUuJ2TfHMeNuWOxVovkFcWsKLPFrjMU8UHq6cX2/59lsas2dj
         KeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785962136; x=1786566936;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BQuE5p94CfqyEpHjKQoO3ghb1Rb0W+FJ1ncrC2gXf/s=;
        b=PK6ICPU+Q3tkBcG99WwcZq+KITp2Fhh5FWIaYA/U/+kVDfbh2qE0yzbwHbou/LAOzX
         kbYpPyhWpICEXWeNgkTkIN4Hh+xKe/xSYHW5BY8tXIpsps9xd7uNz0S+xr0UqiABg9BJ
         fBBtlQqP2dSQsLNgUGRNknfFQrS/6ZPt5BR4HZmIr8F6GamK1fpBhCKmpdMpgB93JGZ6
         QC7n4on/ZIOqb542udkdoQ6aa1kylzjFplsq9x7FzKhis9drgR+q+2OjmQzYCdqBRmq1
         JKJsc3qYmUbDAjdNBY9zZiMvkZv2Ae12N/mxpEP+PLBLe8FWnPisZHdZ/DtMvekyhPyV
         /eKQ==
X-Forwarded-Encrypted: i=1; AHgh+RoLp6S5PPUn/o0sSZ58j9yjPUYiwlaWtuZPS3En5jLSnmdGd1maVYRQG87FYisYCxbPuby04a/p0KN4nA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzzA4TN9jfXY6Nt6KSxtyTYvdfPllhXSesdZDul1gjsuMMqWveB
	Z2+MlZS49KnFUY7XYmYWFZd62eIC6LOTn7w1n9BoZJ4JfN97GFL0N10eTk+82cpEBjEVoF3n/3+
	ft5visW2/oC6t09qvAdIMDto7CAC9/PbbzO1r8mDRJw==
X-Gm-Gg: AR+sD13xKO0pqKK16o8kQSSMrBoHVjs4pJgwqThQa9qS3esV6wLN2ABcxN7sRnbXV+z
	qJOe8/lrTuSnh1htwvOPw4pACXXolOkYyKipVscLVhRTiucFBqXyPMK7QE2pIB2fG1C9YJXFskw
	jd2plbpe0RGglxFT79u/tMwdK+ZkiP2aIhwVu9GBsXD7Mx+0lEmv7Rwa84UlM0OlDGwpxRR9ZYe
	oGfpLsNZl4I2c8DJButT2C/Y1gIDPUUGHnEvSOB9jqZvgc7noq0q+8NAHqDiizBf987Uaimhwvz
	sDskWompgmnPK5NdNeesonQ31L+kBLPQypcuhWcK3zc4
X-Received: by 2002:a05:6820:4c89:b0:6aa:d97f:453b with SMTP id
 006d021491bc7-6ae96f98f86mr5123270eaf.28.1785962135693; Wed, 05 Aug 2026
 13:35:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <7f988ec74b5d1135d5d67771240639e57ba9e0f4.1785621505.git.coshi036@gmail.com>
 <liddhnv7367ifj3mk5qokdax5jexltpvbtxpkqpkt6qzolv7af@zll26cngckwl>
In-Reply-To: <liddhnv7367ifj3mk5qokdax5jexltpvbtxpkqpkt6qzolv7af@zll26cngckwl>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 16:35:22 -0400
X-Gm-Features: AUfX_mzdjJBKSgnSNsYzRJsmY3qVZyWC6pZRSrcY0PRBQu9JTSn19N7htgMKD1Q
Message-ID: <CACd_6n0tmOQpams--XGDWcBWA9VTKgN1QOxU9i1FbbgnNCuqyw@mail.gmail.com>
Subject: Re: [PATCH 18/19] ext4, jbd2: report fast commit write errors with BH_Write_EIO
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

Done in v2 - 'success', no set_buffer_uptodate(), and the debug messages no=
w
talk about the write rather than the buffer:

     if (success) {
                   ext4_debug("%s: Block %lld written", ...);
     } else {
                   ext4_debug("%s: Block %lld write failed", ...);
                   mark_buffer_write_io_error(bh);
     }

Both arms kept so the tracing stays symmetric; patch 21 adds the
clear_buffer_write_io_error() to the first one.

Best,
Chao

On Tue, Aug 4, 2026 at 5:07=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:01:02, Chao Shi wrote:
> > ext4_end_buffer_io_sync() is the third completion handler in this
> > series that reports a failed write by clearing BH_Uptodate, and
> > jbd2_fc_wait_bufs() is the only thing that looks at the result.
> > Convert both.
> >
> > They have to move in the same patch.  The handler lives in ext4 and
> > the wait in jbd2, but neither is used by anything else: the buffers
> > are ext4's fast commit blocks, submitted by ext4_fc_submit_bh() and
> > waited for by jbd2_fc_wait_bufs().  Converting one without the other
> > silently disables fast commit write error reporting.
> >
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> > ---
> >  fs/ext4/fast_commit.c | 2 +-
> >  fs/jbd2/journal.c     | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> > index 8e2259799614..8cd60c9f2272 100644
> > --- a/fs/ext4/fast_commit.c
> > +++ b/fs/ext4/fast_commit.c
> > @@ -213,7 +213,7 @@ static void ext4_end_buffer_io_sync(struct bio *bio=
)
> >       } else {
> >               ext4_debug("%s: Block %lld not up-to-date",
> >                          __func__, bh->b_blocknr);
> > -             clear_buffer_uptodate(bh);
> > +             mark_buffer_write_io_error(bh);
> >       }
>
> Again, this is only ever used for writes and buffer is guaranteed to be
> uptodate so please rename 'uptodate' to 'ioerr' and remove the setting of
> uptodate bit as well. And the ext4_debug() messages need slight update as
> well.
>
>                                                                 Honza
>
> >
> >       unlock_buffer(bh);
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 9e4cb04587b4..ffe7a22e6699 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -890,7 +890,7 @@ int jbd2_fc_wait_bufs(journal_t *journal, int num_b=
lks)
> >                * Update j_fc_off so jbd2_fc_release_bufs can release re=
main
> >                * buffer head.
> >                */
> > -             if (unlikely(!buffer_uptodate(bh))) {
> > +             if (unlikely(buffer_write_io_error(bh))) {
> >                       journal->j_fc_off =3D i + 1;
> >                       return -EIO;
> >               }
> > --
> > 2.43.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
