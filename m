Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C894466AED
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 08:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582704; cv=pass; b=XdmiZS/4NVYGMcSTDZBgAsonvVzpJkCcM+eAcMwrdbWxhJ7dOIlX19XOGlyV/J8U1jGsr9iAziqvoyGM2tSZjhesvGGbBdjWx+5f3CPhfMZ3MQy2WbzM81lz2L5cNWd/ICgCYSYANwYoIHeNeBYjdWolhW+WqXtUsk1HiaOznOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582704; c=relaxed/simple;
	bh=rYGzTv4II1xcif7R0OCDIGqLZTgPuzaXkmrhhhmD0oI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rDB8DTmMtKlQI42RTUeEhI/cdCcIOXalDa035+rgOvZoRv6zOv3fLCet2LCUGsu17Yc9p5hA44fruEKG8CM67JStDLd4t7qT7ASqjCEZ/HqwY2JeEwp7acTY7GOM/nk0r80tr7lj7L3sxk37XLt+kuylLFvgl7rP3MWyDXzlPIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7FE6EDt; arc=pass smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7FE6EDt"
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-6730c3bdb35so1643482d50.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 01:05:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790582701; cv=none;
        d=google.com; s=arc-20260327;
        b=oArVf4qHFBqTZ1JQdECuiU3hRVSsZRvWZAm+4gP4UkttxUxhToBSDlv3yIiNttJwaw
         StUfEcoEY1uDRh5iDIHmgy0n71mOWTgm+koWIa0cVDZxEXdzpBTUQMzZBJVwLJBFTfrg
         w7dgQRyqGX5eZFZ/RsG0FIYfP2ps/JP323OLeOUzGNbq9JQJqau+j92e7O/b2LQAZu6n
         h9mJn1N20kIb2Q/GmhCaf+m8ikZnS3ZtnZ4yZkejkgGueXWwdVijXRO7urMISRtcUuoR
         1JM090Na3A+VcDuqizB5G3vbS+M9l3OA4PXnlJtS6gCGDYKdWybaS1/V9BcJCn2x7XIa
         fQ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=weemlP5ww78KHBN9CNOBBf9t9fcK7VK8fKkN44aV56o=;
        fh=pmPOXAqPKXYsRV81qCzttcnlvUro4EAqnGxc9D03bc0=;
        b=d1EAirS3k6ucbp8yHWhtJPDl5XnOQCpuPKEpZCsGowbXVHetu0YaM7EGMmasBG7ZBZ
         pRRiC4AE3HGj+VlWOmiWeBm//AZsKlyNQJnnGPcGRLhgzMXLyFKYwWwf8lTW5bCRTwBK
         6nc7uijsIZNcxpr9vmax5SSlgr8pRpt4JHrc9xJTW98mhbFVfllMSrjEnseiU/WRva+k
         kuGVflj/zzZhuyjMICpX69FYrrg6QQnIEPjcIsgyoJKVDtlucMHGpCTq5D6L8sriMEtG
         HP0GxBpCqWhH60V0sfkNwbikv/1gbrR5yiMUzJ5oLzledev7F/v9LOgFuSqoANz4VN0i
         RkpA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790582701; x=1791187501; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=weemlP5ww78KHBN9CNOBBf9t9fcK7VK8fKkN44aV56o=;
        b=A7FE6EDty5s9s6qTGYlmz63+0KfqKlMrQebKa4FOiA5ib8IcwI1p81UWKxeFDdNhiX
         aOJX53mrxM1N31rG0tkpmo0/M19IU1789iJ6KGYNYE+i42MKox+xfpulL6ntNiV0oaX/
         wHBt9AoUgqL82/Se0KIOTam4mT2TTSVg73mMeBTF4rrFlsXL/p+LLMBYNzX1q3owWKFU
         THlnFS8uznjV96B0fQG7ylaRkRwkokYDwlXIWidU+VHXE86AtQgbVH5cRHh0q0x+jBFE
         i4JV3Be0aEpJccNXxiQM4BocVE+rBKLTjsfaHQ7RG87/qUeqpnUkBPYWxQCR9sW9dD5e
         8img==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790582701; x=1791187501;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=weemlP5ww78KHBN9CNOBBf9t9fcK7VK8fKkN44aV56o=;
        b=cCJt42/rC5b69dLGtgeBgw79aPOTFAhxjVJE1TlEow2bPeEmGj6/CER0rgFGIRsVBR
         EHJ2rqk3ziMgdl3DvakDfpRcMKMbqM4oFwu2b9Aj2ZErYgCJ700X8oP4YWY60dQb/apf
         ZwEoKEKvgq63wkdvg8mH5nHc3Yj88pr9Ls1POOYwawXZ4uBtC4g3HQ1O/ZpGmi9/B62f
         /Mi0GZ+8WGntpcMwGkaS76mcGDyyRYdsTU5RVQZPJ2RJMlHjx+fI/DeiHAv4lkwE8x2J
         Qk3L6EDurAU766U355O0f/+hJ6bzTUB2pc3htezUgSjOstxPx9fzJq3jFm90+ZebT1jp
         NV6w==
X-Gm-Message-State: AFq9FYLxCzIlnr17DNijjydgGPSI1S/gkMtPrW8RsRHN9PlTMj5gkRig
	w4XqWT/jxa4RNpN3kUSvuz5IVgQgKrHEZ+XSsKRavoIP12y7Wpee/Mn0VDL7KZIgFEHHeQAdWbq
	nlBTAlDlF6q4BAQ34bG5r1dUe+TeDJFQ=
X-Gm-Gg: AYBFou1SneNJxZE/MNCClr6krn1CBMHcp3+8M05jBgwpd9FFFvCjJDobQ5pdBV78+Jn
	pPLkiDLNocZj6N0vmTBbM/yNOmCBZW2+fB9RGG1OXQWhUKhir1e75zg2zoQjQsQuI3Y6Z/OIS4s
	L1fmA12mqSyBUPG+ISdUL+NLtBKaQt7vOi58GHx6ZFrvGsisfg1IbCawfBYJ+jvf9KgQ2NZKfwO
	2WmHqzu1SWaw1dNPjTZFBeARgw1EXFqgh65iLrCGCI7SUEOc68g/kDnPHK6AUYF8fHvi+fvcu9n
	53adP2Kj3jgW9yv5sBhk+e3wRJFjxydWR5vJpVgaLNeg2H/dEoHOLy8=
X-Received: by 2002:a53:d4cc:0:b0:672:ae78:caf1 with SMTP id
 956f58d0204a3-672ed553f55mr3376425d50.50.1790582700894; Mon, 28 Sep 2026
 01:05:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922060048.13158-1-ginger.jzllee@gmail.com> <97f59588-8236-4566-bd8c-7be1a735cc1e@web.de>
In-Reply-To: <97f59588-8236-4566-bd8c-7be1a735cc1e@web.de>
From: Ginger <ginger.jzllee@gmail.com>
Date: Mon, 28 Sep 2026 10:04:49 +0200
X-Gm-Features: AclHuK86-mxPjYzK6T9aKDFOww6nLLaEc7jcFJWsZ-8gLplzX4I03ZZcu834sZE
Message-ID: <CAGp+u1ZcA5vNhZ_Vx2HscEP2x3uXc_CrLQ0f7FNTa3UKFYyVTA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: Protect local_alloc_state updates in load/shutdown
To: Markus Elfring <Markus.Elfring@web.de>
Cc: ocfs2-devel@lists.linux.dev, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,

Thanks for checking. Do the following changes match your expectation? Thank=
s.

Sincerely,
Ginger
---
 fs/ocfs2/localalloc.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -342,8 +342,10 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
  goto bail;
  }

- osb->local_alloc_bh =3D alloc_bh;
- osb->local_alloc_state =3D OCFS2_LA_ENABLED;
+ scoped_guard(spinlock, &osb->osb_lock) {
+ osb->local_alloc_bh =3D alloc_bh;
+ osb->local_alloc_state =3D OCFS2_LA_ENABLED;
+ }

 bail:
  if (status < 0)
@@ -392,7 +394,9 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *os
  goto out;
  }

- osb->local_alloc_state =3D OCFS2_LA_DISABLED;
+ scoped_guard(spinlock, &osb->osb_lock) {
+ osb->local_alloc_state =3D OCFS2_LA_DISABLED;
+ }

  ocfs2_resmap_uninit(&osb->osb_la_resmap);

@@ -441,8 +445,10 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *os
  ocfs2_journal_dirty(handle, bh);

  brelse(bh);
- osb->local_alloc_bh =3D NULL;
- osb->local_alloc_state =3D OCFS2_LA_UNUSED;
+ scoped_guard(spinlock, &osb->osb_lock) {
+ osb->local_alloc_bh =3D NULL;
+ osb->local_alloc_state =3D OCFS2_LA_UNUSED;
+ }

  status =3D ocfs2_sync_local_to_main(osb, handle, alloc_copy,
   main_bm_inode, main_bm_bh);
--=20
2.43.0

On Thu, Sep 24, 2026 at 6:55=E2=80=AFPM Markus Elfring <Markus.Elfring@web.=
de> wrote:
>
> =E2=80=A6
> > Take osb->osb_lock when updating both fields.
>
> May lock guards be applied in affected function implementations?
>
> Regards,
> Markus
