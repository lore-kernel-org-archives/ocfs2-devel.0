Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6911B1FE451
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 02:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775011200; cv=pass; b=V8sa8eZ3UmrnEu2ytHcBmk5lWFH7T1erfoHqe8I5FTFnZVCjTaSZs16Xukc0yhQtsjb6nTf2Hbf0wS0RXrUVEVJFLv7qi5wEXy7gIzQlox8ER5+wtgMVGf+a29jGzmmO1fwYOdm8rIKZhm1yYGrFHbv5Vrt0VxZ2equMDs4tOF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775011200; c=relaxed/simple;
	bh=Zdnrw2m6wqDlJ4ccEr82EJf+zhSdNp2SXG9iC+yXQwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V2DBA+YBVbIJa6o/J49TgBX+Cg2YKPABgQxbb7iaYAykozyyR51N88d//aY5e2pSsSlTxRj9cJTlxhfHcfFv59Kjparqj16YM/qwjEP1b6GGgmzkrOWHNFONm5IswQY9tAdLjitgowyLd5t93ROjGcgfTe0CxZvIZdy32yxbb3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dh2FnP02; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dh2FnP02"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-66c24b42efbso3031293a12.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 31 Mar 2026 19:39:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775011185; cv=none;
        d=google.com; s=arc-20240605;
        b=dB4PO70kXHW2ex4u/wIy3fV6ZIf5PKx4uQq0uPA8aoOgeO8J3iLW2Rh1HNy5JUpey6
         z4hJyjfRBvuYS3LKMJP7KchEZLXrfi/Qejf4+bKe4fEyQCqhuIxvVIKUL+XJKPy2wTf1
         4pW6slZwRM6NqCmIvb/xszICtlz8Rd2IV47RqdoI3MGbUpmEdX6+MwF48wji0/JMIc7k
         6IiPYUx97hMncJVONZJvDIP/CBxux3PDJwYpt9BEZKngwa3u9EdhALYB/bN7AyKl4XUO
         YXLlA0XIxkaSp8/kYn4zO4WQYnvzpN5HcPim2IIZnqaiOTQVDa0Mg+lEVXBHvCyXSSDC
         jRVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zdnrw2m6wqDlJ4ccEr82EJf+zhSdNp2SXG9iC+yXQwQ=;
        fh=lqOS71aPJkVbHWkMCAPoy90LL5+OjSZsPFjwTKFoTdE=;
        b=ZDgjtH8wBBvwr4PHqUGnKdXXfytflYn7KI4029ywM504NoOM16KOAUy9HhVVGoBXmV
         5P3pmZQKRZedIBllOfz0FVkerrdVNAMrUuXLYg8iJKHZ9UHhlA+IqiDEAoESigM4BQ9Y
         5qs1HNDifEA9/vTd8yt+mizvsU4zciFsbUTAD7hYRuLhJWDVnV4K2n5b/NDFdeyssxdj
         NTBaIOHNq1YyQcMCGUFR9/MK+VhXGa2lE/d3jWEw2T5LZGLwE7mDLWfy1cyAMWU/CUMR
         lm5N8i3gP4a7WwWe6bq0dVq46+DwTWr58rGsP0aLvBTXwG4LCJwB5FUe5ekXof+0mD0y
         dArw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775011185; x=1775615985; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zdnrw2m6wqDlJ4ccEr82EJf+zhSdNp2SXG9iC+yXQwQ=;
        b=dh2FnP02Y7XtYSVH/FTscYd5mUu4ygfZfIx06ezYTiwiZOI+0tcrwGCA0Dblih6dCX
         qXdqUTOfpECWwlk2os1ND+y/Qn+YO3v48o+SPtt1VT7lWAHByOL4ckerdk7EmVepiSPv
         r+HMvEc6vh1OVxb2ms4jf9V9WMPCgEkr7bEQGetP0kHtmcTrOZCI4Opob8p38aayooe/
         qqWKidprQDOp1DtduUJA77AWBmlCxRYPXTJSzxf0Jy+7rXgWC3KDaOiPNn/sb2sGn2AR
         b4IZmNshFVSiM3sNK38q7e4G5JTyJ+rEMUGuOhgM9Bx/OLAT4qmqKu8RKl5Ydu7Jzrkz
         FOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775011185; x=1775615985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zdnrw2m6wqDlJ4ccEr82EJf+zhSdNp2SXG9iC+yXQwQ=;
        b=KLLvv+3Sm264N24jTo/KNIqBvnsb62YKFXUR4BDH7H66fifOns2mEWt7FonQjM54KJ
         tchawX2B+iKVDCjjSnSwnnhmOnaXyFOu12JNGrY2WvdY7cSKkURHF1FtGibBMVONtDXM
         ysHqwFuSruMfSVP0f6IyfrCBJ9jVSGADfdrQM5fO+YYEl+312C6q+UExZ4QBfYG3Idwg
         tfNTDd5Yom/ZlC0l12tUvM0lefUVMS0siJA5E5CQtFvbXSMxQ70A+eIc//YBOlu0R0z4
         CT4ZG/E0Dkdn5cpg5vxzdqZ/mHdC5FOQiD2hNDDVxDF9XzRBXTzEOLEO7jwbaMriiZjJ
         SWfg==
X-Gm-Message-State: AOJu0Yxhb8bDu4nQkREC11WWY4enT0mYTKufMWRKAh67xDxxQlG11NBL
	X0Us1GjadmvDrg/KEsl0npFU/NSYq0+esKUj/p/LpXQpN8o30RyQSBTnPx/flRxeyOXXMsz9lIS
	TaEWerIeLohtWAsfKxJb0YoVgkYcGZLXY7NoQHEtC0g9g
X-Gm-Gg: ATEYQzxJQezGwjiJEz9ZIS9BuIvbSYk3j4pZf3RFUsenzBZS1eOlinbbY6/K58A8f+R
	ZNdvFT1gIwvgBmtijj3T7vLpuGFICk76iv+Hg+TKBtg2fjLiEk461io6dJ+PDKexzL7LgXD6O7o
	Rd2inGkwwroytCMetYqQVoP+9pW/UIHUbaVKJ2sqDgnNkD2CRTMq62hM38Wyi4+eMrbgeCmdWM7
	A0bGVLh0IDGL868zD1144dEqIDoRKUYvyfLbpQSMHF1B7HnvimUARZFsZ9lSARUYmeWmRicTzFI
	RNl5aLisc3BveroLPooQMlqMlQdLSAYoiY71zpCIKd7m9FYDR5wjoyg+/Fq+LtYlPeQ=
X-Received: by 2002:a05:6402:448c:b0:66b:582b:71dc with SMTP id
 4fb4d7f45d1cf-66dafdace31mr1005773a12.3.1775011184608; Tue, 31 Mar 2026
 19:39:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260330092712.1288264-1-gality369@gmail.com> <0ba66c9c-208b-4dd6-9350-96b6dfa33eb3@linux.alibaba.com>
In-Reply-To: <0ba66c9c-208b-4dd6-9350-96b6dfa33eb3@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Wed, 1 Apr 2026 10:39:17 +0800
X-Gm-Features: AQROBzDtEcnoEXr414kwgItigPv8Roh5pXuh9xg5JUTEUAkxMn1ZZaGdXt6-PM8
Message-ID: <CAOmEq9XmnYQH=CFtmOeF-Ydrm-H_5s2OGYZ3TwOXty1WOqOi2A@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: fix lock inversion between ip_alloc_sem and
 transaction start
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>, 
	Wengang Wang <wen.gang.wang@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 1, 2026 at 9:34=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba.c=
om> wrote:
> On 3/30/26 5:27 PM, ZhengYuan Huang wrote:
> >
> > [FIX]
> > Fix the ordering by starting the transaction before taking
> > ip_alloc_sem in ocfs2_setattr(), matching the ordering used by other
> > ocfs2 paths that need both locks.
>
> It looks more complicated.
> Most places also take ip_alloc_sem first then start transaction. And it
> seems that we can't do the changes ealily.
> e.g. ocfs2_truncate_file()
>
> Thanks,
> Joseph

You are right. I rechecked the locking more broadly and my current patch
assumed a transaction-first ordering that is not actually the common OCFS2
pattern. Paths like ocfs2_truncate_file() and ocfs2_dio_end_io_write() also
take ip_alloc_sem before starting a transaction, so changing ocfs2_setattr(=
)
alone is not a good direction.

I=E2=80=99ll drop this patch and re-audit whether this report is a real dea=
dlock or
a lockdep false positive caused by missing serialization context such as th=
e
VFS inode lock / ocfs2 inode lock. If it turns out to be only a lockdep
modeling issue, I=E2=80=99ll come back with a much smaller annotation-based=
 fix.

Thanks,
ZhengYuan Huang
