Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FDF17BA5
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Apr 2025 03:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743995616; cv=none; b=r5qAfjnfm62AjeZM1Z2/d9C1aIBGPMK5E3sg1cdKTYKOg0MvWzG2+kiukdGc2IkhWNs73tfaL2AOEtzAxGby0MGyvg2sblZE1whYdvoZKWGU5L6Ae3mBIEncc1asqUpRbOl/VXu/t02WvQdBO5aNq9+c5ThjACfLAnbQ617djsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743995616; c=relaxed/simple;
	bh=yGC7W48pGIR14uwgfpwb5QbtLcySgKLjTGaKrunxkxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=vFPzch17iUFIZGr075F0PGRsNFyzHY+3wkWSZ9zmbv7/axcvZMwaOcY7I1VVibuaDSGjeyPxdyarAw0mUYgThwexO4uCKyyp7obj5MqXtWAcOI847jESrqt/g0o6D6sW85az4m5pq4xY/MyF/z5mPbzDltIJVFv9qNVqduNJ3jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i22pLxxK; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i22pLxxK"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-476a304a8edso38147051cf.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 06 Apr 2025 20:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743995613; x=1744600413; darn=lists.linux.dev;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vPQVY4WOstGEl2DC9PQd1EMUw4jAZBuklAEaNTH+0Os=;
        b=i22pLxxKEj//tkxHfWFiBSqJZQ5H+69w7iN2o0+53dl7FzHEWN9IwBYahChLEZhwXT
         3Poom3rR8gjJkoL23IjfuegyN344lqZVTd+gxljyj/M5uNc7sjgDqcgIZ8G4goKtABAg
         7yeSEnWUCq/7HgcTWk3fHIW9KbdVSJnn7ImjWjAETvAt0nkZO+X7AlkZS+O3xaUJRrsS
         BTTWfxXN+m1FOjKCkidF+EunzeBzjxgf7i+c2iG26a9kJVZHi6HIu6Y91kbR6aVx8+WO
         yabK8Pu8zN9yfwVUECDusBcDEjoFbBjSDVnGnrPZ5ZXfk1ScreK4lNHEmM0EzrB4x+Op
         F0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743995613; x=1744600413;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vPQVY4WOstGEl2DC9PQd1EMUw4jAZBuklAEaNTH+0Os=;
        b=mX9hxU6xD+hmHUtFAAOvzu1LFx8YDMGLqWNPaahSqVIMimNM8wblFLolESjs55V2m3
         SzhuHcBJkUjN1urfU/6JmB9aP7+IgUvHnA/dgJ4efiNUVBuNCdUpFdIOYBgrW84MQ2c1
         ffLlO9RuDA7JcDpMvUXIXepN4maJLXO0FXaXykiwwoge9FJfDPc9vBBOnvPPd8o2e1AJ
         bzqZ7faxeew7PCopOIK0/yPszXKMB4A5tWHuaqmrsoWInhEasgvjnWhGremBirr4YUlr
         N45thXALaRFxGdDbjzYAaXMU1mPgHootQ87sF8hRViAabOwXaKrChwbuh+t4FcTWdhc9
         O+lw==
X-Forwarded-Encrypted: i=1; AJvYcCXGXXs8dr4sNpLJFE3ckvkZFSAor2jhnwobj1DAbE+JoLKraiz4jckFrXo4GfTaYiLIytuMXtLm8F0hDQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3L4gQ3AWbIx8/9VISk24lvNzTAWYSEMhFUqEMQRX043LqnPaA
	k36/siaONalEUkRtZWpiZgaP1WanvCA+C6oVtbrdRdxWZrWUE4nJKGFdYZOwHdNF1Zst3YkOSeP
	UKtHSXshnRckI4M2o0cchz0OL4dc=
X-Gm-Gg: ASbGncuVTDkAvZFWpW7oSvXbfSnT86KGhfC6NxNEH9k1oL//l2GNaKni+uEOEiy0pgc
	OE+ySwo6ycnbtOVBqQGMZh5tDSl27vaPydlAvyXoQaxt1HOyf4T9h1iFLTBgn7t1MZarQC09ZmW
	zrHcn+LcAqE99xQK+SEnAahsS/c24=
X-Google-Smtp-Source: AGHT+IHNm4DcMOYCFt5CSjMwqq0XExLgak27FoxSmqtjNEkPsxuFQudJxcHK3Hljvd54+UWbfKkumfHlYBjnulyZ+oQ=
X-Received: by 2002:ac8:58c2:0:b0:476:7b0b:3110 with SMTP id
 d75a77b69052e-47930f97387mr105228281cf.20.1743995613351; Sun, 06 Apr 2025
 20:13:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CALf2hKtnFskBvmZeigK_=mqq9Vd4TWT+YOXcwfNNt1ydOY=0Yg@mail.gmail.com>
In-Reply-To: <CALf2hKtnFskBvmZeigK_=mqq9Vd4TWT+YOXcwfNNt1ydOY=0Yg@mail.gmail.com>
From: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Date: Mon, 7 Apr 2025 11:13:22 +0800
X-Gm-Features: ATxdqUHw2AYcYwDncI101N28YFmcnPdXhi2dhhGFlrzPD-Y6Dyb5mAtf5TeKAuM
Message-ID: <CALf2hKtNemTQPCGkbCfRZj3Lkd_2-L2QX+Y2rUxGgxMgdpJ8Jw@mail.gmail.com>
Subject: Re: [Kernel Bug] BUG: unable to handle kernel paging request in const_folio_flags
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Is there any update on this issue? Shall I sumit a patch for it? If
there is anything that I can help with please let me know.

Wish you have a nice day!

Best,
Zhiyu Zhang

Zhiyu Zhang <zhiyuzhang999@gmail.com> =E4=BA=8E2025=E5=B9=B43=E6=9C=8823=E6=
=97=A5=E5=91=A8=E6=97=A5 01:52=E5=86=99=E9=81=93=EF=BC=9A
>
> Dear Developers and Maintainers,
>
> We would like to report a Linux kernel bug titled "BUG: unable to
> handle kernel paging request in const_folio_flags" found in
> Linux-6.14-rc7 by our modified tool. We have reproduced the crash and
> applied a patch that can avoid the kernel panic. Here are the relevant
> attachments:
>
> kernel config: https://drive.google.com/file/d/1vHuHlQyiKlXbyuo03sZTiuaA5=
jZ5MtV6/view?usp=3Dsharing
> report: https://drive.google.com/file/d/11LD1uFid1u3r7brsvd85-SrBzvXwH-w2=
/view?usp=3Dsharing
> syz reproducer:
> https://drive.google.com/file/d/10v3FtkewHcAnTjsUGqFCDl7k7hiCJ12-/view?us=
p=3Dsharing
> C reproducer: https://drive.google.com/file/d/1L9WTVbO2pfqXLjXyQcMy4f-Am3=
obTJcN/view?usp=3Dsharing
> crash log: https://drive.google.com/file/d/1zwYU3061pnTSVIEpuZ-EBR7FYvWPx=
X4z/view?usp=3Dsharing
>
> We speculate this vulnerability arises from a missing check for error
> pointers in the array folios[i] within the function
> ocfs2_unlock_and_free_folios(). When the kernel fails to write or
> allocate folios for writing (e.g., due to OOM), the wc->w_folios[i]
> may be assigned an error pointer (e.g., -ENOMEM) in
> fs/ocfs2/aops.c:1075, which is then returned as an error to
> ocfs2_write_begin_nolock(). Within ocfs2_unlock_and_free_folios(),
> there is no proper handling for error pointers, so the function
> attempts to process folios[i] directly. This results in the kernel
> attempting to dereference an invalid pointer during the call chain:
> ocfs2_unlock_and_free_folios->folio_unlock->folio_test_locked->const_foli=
o_flags.
> Specifically, during debugging, we observe that the kernel attempts to
> read data from rbx+0x8 (where rbx =3D 0xfffffffffffffff4), causing a
> page fault and kernel panic.
>
> I tested the following patch, which prevents the kernel panic by
> checking for error pointers before accessing folios[i]:
>
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -767,7 +767,7 @@ void ocfs2_unlock_and_free_folios(struct folio
> **folios, int num_folios)
>         int i;
>
>         for(i =3D 0; i < num_folios; i++) {
> -               if (!folios[i])
> +               if (!folios[i] || IS_ERR(folios[i]))    // or use
> IS_ERR_OR_NULL instead
>                         continue;
>                 folio_unlock(folios[i]);
>                 folio_mark_accessed(folios[i]);
>
> However, I am not sure if the analysis and patch are appropriate.
> Could you check this issue? With the verification, I would like to
> submit a patch.
>
> Wish you a nice day!
>
> Best,
> Zhiyu Zhang
