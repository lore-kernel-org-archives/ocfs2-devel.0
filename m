Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5F7470E99
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Jul 2026 03:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784775955; cv=pass; b=AmFLAOG+qqygo4DQL4paxkeIe6fhXw0Tly1RZdaT/QbhVGFmW2lLAWllISlq42asPg0JVSZAxDEoMYp13rPqSWr9tGz9CIh75DjChgjV6hgNBQNqNyhZCFB4KcKxPMiaYnLJVz9F+1h4xRrnLEfDb5sOs3V/pUNOWEeU9V5V5ss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784775955; c=relaxed/simple;
	bh=Ywi16la2ev4LRjH1+oCNOS7tFbgmgc1W7AlZbJJsJwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gby37PmKAmxvXubUca1/q3+AYRoREfpWWhmyPk2rV7GDtQSVL+ct7Df5UC2Bxm4FJrQAch0mO3AyUVyCpsuVQJ7s8kTS7Ohkr3jsG6wA0NfI0VetKTxultqhdZ5yE6vVAq45e/WGzc4bvsrTLScMQv2+SheIyl7ih6stVN7suJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nH7uOKPe; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nH7uOKPe"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-698ab9aae16so256287a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 20:05:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784775952; cv=none;
        d=google.com; s=arc-20260327;
        b=W9Rp5lYrg3hHmnkU76bgKC9Lvu8XYLtkxDl3fNs9uVIk2RlzCY4eSbyYX9CbGpTD2T
         7z1SUK3fmplqdXbmgXhmstCW36HoZbRxJ+QeA57ptzXSad2sxmC9yYdofIcxlCEw5Z0q
         9M3qGobUnUioRCh4eM4exSF3HppVoHP8NBkqBmRJfDUpYtGqxwIRXqU+QtDEcZBblUEM
         ZF+R+UBa6VU4EGUy0Ax4xTPE3faiZMhwCeziuesLvjbMSztpNDQv58YMkCK96UjsAXlS
         FBuBV4CqKBNyPCrDeQofvjZ89hN2rjWk+5u1RVA3EJ4XicH5je5czq3q/sSwS+DXZE/c
         Zs9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BodcrpWSt/SCqhkgSVarRBMMotNBRXICDagO3QG2Lm8=;
        fh=4skMUNmr0lZMBXEPlS+vYIHZnyxjxIbzAuUsmi82cBc=;
        b=mDosyE2cMkfM9igBAnJRwmY5s2+nOyl56e5sxh1FRwBZ3/EPh4QC/cOauDdxpoUwL4
         PY18ksTCElSgi703sYno/noFzZtC/62JPTZr+aqmU+E7iGRaPf1b7XNaNn157Z5nhzap
         45DPw8iB5JO51Fmi9jhJlmkpf5qqUx9KryCccl6c9qR77Y0CfMnrYm9V0jfhl1ZPkU3Y
         J7C0QEDLe8+vSLwnmj+aj1Klf9kuQ70P3Y5CC8P2awXRRUTt+0az88Z/t/uAyKaF2z59
         AuSTHfT4YqTlAGAfT4JVm/rYwvFRyS0zXviAFvWQboSsw09N2AW/2GBfnA8Sv+cxv21c
         xmvQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784775952; x=1785380752; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BodcrpWSt/SCqhkgSVarRBMMotNBRXICDagO3QG2Lm8=;
        b=nH7uOKPeJICAj4m7TdFwjYocYPKvwyR7vjQueJNNSIoCaE0DmS8H0thm/mRX8qj1rR
         L5GCmUM3X5MHlkvX1mbfSmbRPWthZkQBgfyFZkixzbhLnQCKoOfhqo6E0v4xJCM57OgT
         irtmF/0ZtffPT3ofqvnB9vzFZQhZuidB5UtXwDj0kYyX2XMA5DESLkSTBiAvM9cMGliu
         Nk2DsYzDNJgM/ITmda4xr3aZpdSeYuG/8jXZTGJGqDPiCB9MuKgQoyQCS5JA4H/wB0kN
         8MPTJV948s56wEcAm919ot8dgmH5VNGt5BuClfOKrMDKRJrP46WRHS87p4jTeUDZqv1h
         k+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784775952; x=1785380752;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BodcrpWSt/SCqhkgSVarRBMMotNBRXICDagO3QG2Lm8=;
        b=eIVfJc4k0vJkY8Gx0sUTVX/RMlLwptK61iE7mDCNr1gIyDD5jeECEIhjcypfJP1SV0
         vYo9GS/EQeBfQjHfC2ebc6I2ayfh882zrueqf0HVDzhhuHV8JGJ/yHOI7mmfhCn90oro
         yI6ru1qERQM8HRkHxA7S0DBQZ4/xRFbyo4wMtmtuRg9y2ojquHCddlhc1KGtHOF874c4
         zZhmrGS4cWgqOhqyOBBKu4L4RS1yi4QeQM+glgYeHbFjVkhIMWsIhc4LwkBncJzq9si2
         I88Eh55jlhpQRiDmLP3Sx4kwNMnE5FWjqtP8eSYbV5p7ZXEGdJiD3BPS6JGnBI/B6XeL
         8AWA==
X-Forwarded-Encrypted: i=1; AHgh+RpGzUBBErYkw7A2Y+/FkT/9z7YPrmASq5cseq1cHGkJ5ufziDzJJ+ALePptEX8Lb1NveXIY68IUXH863g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwF8FyFjPNijjby7u+D97EhnvzaTPOxr+LeIQ5IAlkclh5/MN3l
	Yvbm9JPVWatewoNDLgai04iKuigX8OS5GFkaWsWhaY1Fgflut4vgo3DWfCAmpMJUVUoNqubLZrh
	4puPSXcXON2O++jmnmXlqKvo191oLARg=
X-Gm-Gg: AR+sD125/UfAMxTTTb9ULVVeYfFrkOV4EzOqh9DJRPc9NrHzpscIaPonZh34XwT1Cnd
	Ss4NrwTaFjtgXtsrD3yI2PcB/XY8pLu26pw9/EAEg2wq6FuzL/nF48LUF4RDG92TwthlWHYTBIw
	mF1QXUQTZTr6i8rtX2iYWOez/1MPrF6qipaj82PZ9rF8ND2Oao3dZX5x6FSlj4HcPcZuOzR5mlG
	+pXQTPOgyYUM4fb6wbwESyEfk1GQrSU0ypg4YH265E3KPc+f4jBvq1WOGy08+7sIhtLUNkZat2X
	iFtoJIYtKUaZvfOVoFQI24S3y8PRyg==
X-Received: by 2002:a05:6402:3226:b0:699:728e:48c3 with SMTP id
 4fb4d7f45d1cf-69f6b823e69mr387555a12.9.1784775952077; Wed, 22 Jul 2026
 20:05:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260722091157.3141414-1-gality369@gmail.com> <de598854-410c-4fae-95a5-8db0ee6d47e5@linux.alibaba.com>
In-Reply-To: <de598854-410c-4fae-95a5-8db0ee6d47e5@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 23 Jul 2026 11:05:24 +0800
X-Gm-Features: AUfX_mwtPGLgrilC3fU57yh6krB3R2Goar8AreP6TD29sKro4UYGA1sds72HuEo
Message-ID: <CAOmEq9V-g+AxUw9XZr2Kk5_MYffAndsrbTPfXOyKDiH-eGSKGg@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate truncate log dinode before caching
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, tom442288@tuta.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 8:56=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
>
>
>
> On 7/22/26 5:11 PM, ZhengYuan Huang wrote:
> > [BUG]
> > A corrupted truncate log dinode can pass through mount initialization a=
nd
> > reach the delayed flush worker, where it triggers:
> >
> > kernel BUG at fs/ocfs2/alloc.c:6019!
> > Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> > RIP: 0010:__ocfs2_flush_truncate_log+0xa87/0xf10 fs/ocfs2/alloc.c:6019
> > Call Trace:
> >  ocfs2_flush_truncate_log fs/ocfs2/alloc.c:6084 [inline]
> >  ocfs2_truncate_log_worker+0xa9/0x180 fs/ocfs2/alloc.c:6097
> >  process_one_work+0x8e0/0x1980 kernel/workqueue.c:3263
> >  ...
> >
>
> I've encountered this BUG occasionality. But I don't see why it happens.
> Do you have more clues on how to reproduce it?
>
> Thanks,
> Joseph

Thanks for looking into this.

This bug was originally found by our fuzzing tool. We tried to
reproduce it using the automatically saved disk image and syscall
program, but so far we have been unable to reproduce the BUG in
__ocfs2_flush_truncate_log directly. Instead, the same artifacts have
triggered two other issues:

KASAN: use-after-free Read in ocfs2_dx_dir_search
kernel BUG in ocfs2_grow_tree

For the use-after-free in ocfs2_dx_dir_search, I previously submitted
a patch that addresses what I believe is its root cause:

https://lore.kernel.org/all/20260416082105.1295887-1-gality369@gmail.com/

However, I have not received any feedback on the patch yet, and at
this point we are not sure whether that issue is related to the
truncate-log corruption reported here.

We are continuing to investigate and will share any new findings. In
the meantime, the original artifacts generated by our fuzzer are
available here:

https://drive.google.com/file/d/1zCJoUb2uwVqTrGIM4JFLbwkcHRz04TJo/view?usp=
=3Dsharing

The archive contains the disk image, the PoC program, and a kernel
log. To run the reproducer, mount the supplied disk image and execute
the PoC. Please note that, in our current tests, these artifacts can
trigger the two issues mentioned above, but they do not reproduce the
BUG in __ocfs2_flush_truncate_log. The archive also includes the
kernel log captured when the original BUG occurred, which may help
with further investigation.

Thanks,
ZhengYuan Huang
