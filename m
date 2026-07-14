Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55D23F39D8
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jul 2026 07:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784015673; cv=pass; b=EsbIkSB9B29Ge6APJjSH/DK+ZO5AntLyuZKxCeWFxEqaq14GXGFmI9WY2nkmbQjaywYUAP/YVuGOmzAH7tjoRgPKaKLwJv5+7HaSfYcwMBeVORUAw50qcoaTQZsRTMdwYiRzb7M47s13ektDrvMZAVcY6vGAw2xN4Ldn4/aHfog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784015673; c=relaxed/simple;
	bh=h/HAz738sWCCW4QIL1LT89j3USLGWYxgNnlJHAJT/b4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h2Z9tE/MHQiUwl0cfcKpnMbr9w5z0dC53A/oBKdqqMOkUkHQ8HH0vgozbNhKw57iYhGf+d0/ilC7PEyvVPh7KetT7+7BtKGbo3Bde/ELC492geu8909jLRzNh7liRXSO8ou6eSLP5I7Flp3hUZj9iFqs3TGpHnDE5edNnBhjReY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X08YBafU; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X08YBafU"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-667971437d6so6456548d50.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jul 2026 00:54:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784015671; cv=none;
        d=google.com; s=arc-20260327;
        b=laQ8MJUaiBkAsgJUUW3LMKQoI5FFnkBMYEDb9ayOiHRtcR0Ev1szo2bUruO6WnBVeH
         +s8ggdYNL+EI0/5kTFBpP7iOY6axzx1KFNRo+tmT8+WBXGE58KnrmURa5AjnnBypxxaC
         BIS3lpS5Rd+rgYwUNbrsMkDlpoJdgLhWSzVsW+ZrDu90lMcb65XPzqTi9xc6VgtJCYzF
         wk4AoCmfXOx3ohuSRkgtgjtl98c++nLJ6rZ2B6nPHWTo4yrvATckwTg66QoDZ69s6lbk
         pDE/MYXz2dOMTynURlhD1mB3CqQsU1HrAa80zOXso8xIiHjedRn6SSa2JhDL1YWT0EFO
         BlPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tp47eXyvNj+jd5kwLE/njorNqHasF4qtkp1+t0fIdY8=;
        fh=VFiyofP1oCthHMbiwP5YsJiDalGi2l1A2m2MMDp6Rvo=;
        b=WM4fAogsc5jQSwUz53xcGWmvbvdrGu0UPyRUW0zAvxBJGgwWlwaH8FHv5wja9SXvIk
         SRqqrxSP3mhXlVQQM3HZV/cb2rjjokZyrw0gc1c2Oft5Tb9WClx80KSIkXaN2UWLmjmk
         dCPZf/W1YuPrFh0FHn2ovV+Bt7LEOO1MOGRXVrL0S/OUehatqfkP9kgQGEPzNJsw2Vpn
         idT+5aoXeZZRCXM9wy6uESAobVowI+RDWo75M8p5OkrKYpBh/5j1IPE1Kru+pAftHLB2
         evmfSJHcEblbn0MQysbuyPhj8rsHiAkQ+oAmnItWk3Ld2sYX9vDoAjgx56hC2crw9XeK
         QcAQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784015671; x=1784620471; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tp47eXyvNj+jd5kwLE/njorNqHasF4qtkp1+t0fIdY8=;
        b=X08YBafU1qkALpvC6EDMNzhWK3HMVaS1iNo5EjNwWr3cuv5vbqz+09f8OmFbqqYjqb
         Ma50i9DvKq5wkS74Qg1UO2Zxh1S+LIWxIbTc85NbAXK6yP5P3caoBxRVC26w/Wf3AR/R
         isbZ20k5covxi1KAWiv5QE87+PoA0kgkveuVYstxPhgmWYoezdtB5jJ5q6o/gf8TMXTM
         9lvO/OEtxEQ66zC2Svb38Uq2ZVRej76o/5v/HqR/UtF5sl56JlSykMNUVcJQy9I+7fhK
         qqNUO8vxYClEHFYl0vYmoHpDKpxJkJjmLNwA6fYW4wUXxp5tUtG4Wlh/ZxXwRnp+ZiyX
         GoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784015671; x=1784620471;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tp47eXyvNj+jd5kwLE/njorNqHasF4qtkp1+t0fIdY8=;
        b=aw+qC056lBanZaxiYVsV7/jtdQXAJnJ4CW/EYiHIlnwMLJ98mcD3RSPlg47wkpL8j3
         5SRmhxi0GCiYa8Tueo62rpRGOBRsWYafAhb2PNhNwC6gE1PbGwASz0C1copgS6HYF0JO
         sUuh3kNKyDmeMQvJowxS7TTdMJFRqt2gEIM4jzp4ts1WqGvqByiUqMfDQA7vNlz51h8k
         mH3AT4YZb4Ma4jxB6P2L5nKFsrymT+6GwU7nLtRHADHX5NZklZyNb/aKkJc/AehgLgpk
         p9Xo0cGelZxio9aATH2s+jWicW1zylOcFq3srbWSeC17eoLAcKbof1FAnzGiujhtRa1m
         0vwg==
X-Forwarded-Encrypted: i=1; AHgh+Rpv9tQQJ26rx0sXcDZBb1hfsafQibY/swIdswrTk1uRR3xs4dshTPuzd1E1RN625uxOEvseH6/GNUrYSg==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywiw1t5vPINQAVVjOpCZrwbPdqL2etqw3VSk53Jo6kZnYX7n9zz
	QSfpPQc9Lexrejd7wP6w29dyKvNWYw65WTd203zUgpltS0cyWDCjUepBecZglgSg8GMIx6E00HM
	wmgffvu/fAJpDDlggtHzRZD4Us/Kx/i8=
X-Gm-Gg: AfdE7ckr2EfH2lXZOj71Bep2ganJ29ruImD0huNXo/1yjUhRsTYIxoCYa66PdPUXcq6
	T72MVww/hHmk49E8blsbUsBuE9TTbhwBvrr4aE/bl0LaG+3AmFjpV/G4JBAcETrniLE3XL5vSWe
	tBtUnqD9XEbfx8gmgv/H1ZANwletCUFdWhFLr/tMAAz/CXNWZQiMTuLqmdJZPm4o8rVK3Ap97nq
	cq7cVVOrpxxaM3vxd6PvBrRWAjvd275apQrzYpsJY0O5Fuxfd3yk8/4NoJAj87RYsGc9Xz9PbI=
X-Received: by 2002:a53:cf51:0:b0:667:c532:a185 with SMTP id
 956f58d0204a3-667d7edb7fcmr6237074d50.89.1784015670754; Tue, 14 Jul 2026
 00:54:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260708062212.715437-1-lgs201920130244@gmail.com> <12edcc56-8f9f-4f36-b5ca-8a4ba0f3d9f3@linux.alibaba.com>
In-Reply-To: <12edcc56-8f9f-4f36-b5ca-8a4ba0f3d9f3@linux.alibaba.com>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Tue, 14 Jul 2026 15:54:20 +0800
X-Gm-Features: AVVi8Cc7hmvd09gLByZDZpeMbaurT00gVCP8hv-UwV-m5okafaprawe5TiN1R3Q
Message-ID: <CANUHTR8JM29R=uyc_Abn-Cf=7T9QCvRi-hEPVD9-kksWf1Np9Q@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: free claimed clusters when defrag move fails
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Jul 2026 at 11:59, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>
>
>
> On 7/8/26 2:22 PM, Guangshuo Li wrote:
> > ocfs2_defrag_extent() claims new clusters before calling
> > __ocfs2_move_extent(). If __ocfs2_move_extent() fails, the newly claime=
d
> > clusters have not been attached to the inode extent tree, but the error
> > path only logs the error and continues.
> >
> > The following ocfs2_cow_sync_writeback() call can then overwrite the
> > original error with 0, while the claimed clusters are left allocated an=
d
> > unreferenced.
> >
> > Set need_free and leave through out_commit when __ocfs2_move_extent()
> > fails, so the claimed clusters are released and the original error is
> > returned to the caller.
> >
> > Fixes: 202ee5facb2c ("Ocfs2/move_extents: defrag a range of extent.")
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> >  fs/ocfs2/move_extents.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> > index ad1678ee7cc4..4f1745d58a88 100644
> > --- a/fs/ocfs2/move_extents.c
> > +++ b/fs/ocfs2/move_extents.c
> > @@ -310,8 +310,11 @@ static int ocfs2_defrag_extent(struct ocfs2_move_e=
xtents_context *context,
> >
> >       ret =3D __ocfs2_move_extent(handle, context, cpos, new_len, phys_=
cpos,
> >                                 new_phys_cpos, ext_flags);
> > -     if (ret)
> > +     if (ret) {
> >               mlog_errno(ret);
> > +             need_free =3D 1;
> > +             goto out_commit;
> > +     }
> >
> >       if (partial && (new_len !=3D *len))
> >               *len =3D new_len;
>
> __ocfs2_move_extent() calls ocfs2_split_extent() partway through, which
> repoints the tree at new_phys_cpos, then can still fail in
> ocfs2_decrease_refcount() (-ENOMEM from ocfs2_read_refcount_block()) or
> ocfs2_truncate_log_append() (-ENOSPC). Neither aborts the handle.
>
> On those failures the new out_commit path frees new_phys_cpos/new_len and
> commits, so the clusters are both referenced by the extent tree and marke=
d
> free.
>
> Thanks,
> Joseph

Thanks, you are right. My patch incorrectly assumed that every error
from __ocfs2_move_extent() occurs before the extent tree is repointed.
The ext_flags validation failure I was targeting is pre-split, but
ocfs2_decrease_refcount() and ocfs2_truncate_log_append() can fail
after a successful split. I will rework the fix to preserve the
original error while freeing the claimed clusters only when the split
has not been attempted.

Thanks=EF=BC=8C
Guangshuo
