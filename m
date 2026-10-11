Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C759C30C160
	for <ocfs2-devel@lists.linux.dev>; Sun, 11 Oct 2026 15:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791733242; cv=pass; b=gkDTr7FJnjYF+/07RBI8nrmjTzdqELhOcyc3TvwTz6dYUrf/uMw5E4VmOAarj7sHjKDuDA71IVXZYTxQqnd8t55qhvoVrCcx00/UL6gYir4PIZtK/t5FfgjEyAjWUmzvI5dqTyT7uV9TTzULt1bo82W0CRXBi4kHr/hKQTitC80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791733242; c=relaxed/simple;
	bh=Ezuo7eM4E6Ezq35kJfRYN6/gEW+WhWnzkY1e/gLtXdw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jOn0ioam11eXI07+zGYwABYqfVTRu8LYTzpKgiCQBrqru5HdhXnOdO5rP5qc12y8Z/mS4cAZ3povyOqSNEQUbKOTiJaAYFIPH4cM0/tPvbNL6QfYc9lZtURuJwhrltjHCdqCDCCnnWLtG+wimFap/LyDfSGE3BGSYfxYjmDSzGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ss7/SGnZ; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ss7/SGnZ"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8ac8a2ac52bso9928747b3.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 11 Oct 2026 08:40:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791733240; cv=none;
        d=google.com; s=arc-20260327;
        b=k131YWz+SLtTpNZNtXdxyz968D5CMXP0y1eWD8oAPSrrq93AyzD27kq++lvK1hGID5
         nDKVzPE5rW8bBFFAkBHcwekbOC6tqV5HBwaCNl+4+Ih0CfWprDa7APm/xYs9A3cSfUP9
         yRzZlgGAQ8P0Nq9xnu2/HXOHW6oqOtTIYcfXrTgcGOHPK58JbrV5Tu2K6caGxm9mATqa
         kv/BwZgNTyC/PEUtQitAa27oYqD1maT2QlKEmWyaKvgnyYJmTHd2FbPbqKX4493fhPbA
         /DlJ+Z01ZJrbV8QcoWqNF/cYQ5iqoOj30pWYoslYantbp44ZY0KZYph7Z+2VG8qz39Z7
         Ljfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ezuo7eM4E6Ezq35kJfRYN6/gEW+WhWnzkY1e/gLtXdw=;
        fh=UbKh54GawnsLlhUdDHUIYnCDL/b+wghCDR1CSrjIrPk=;
        b=GZL3+TDA/9nRcu3lBn3bScSHviIIXcCJd9MZyypNTTzkh0QDCMMIUpKM2dik3ZxKiO
         nKHLDW5yE1nkTE47thJDJ5UfGrCY2EiSoOtl9pCuafXOAFa4d5VPk5azQZvCHTNkoFNM
         W3/eyXgTcdLq0JNmUyRCL1Jhh5KdCio7cjNf3l1TGbCEXiNrHIBQI3LtKiM/gnJp8D9Y
         hTZ8VIYxpfS1txc3xJs2Y4gwrK55gfh7PugqEs8IB8zkc3YrB3IwdK8VPSAYtCF9MQtR
         9tv/gYvGXMUNxueZeIXvuMooDYwoeCtinEEEMjXM+GiKCrXhbf3wL+m4OcXtj0O739Vq
         hRhQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791733240; x=1792338040; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ezuo7eM4E6Ezq35kJfRYN6/gEW+WhWnzkY1e/gLtXdw=;
        b=ss7/SGnZEys9g6bVNVskkFppt8kyXIvNmh073uMXsUUVJPCgbt1arCBKxket2XCU1q
         07S7ayJpHApqeieKq0k2w87BL3P9OsZgWfYpr13kgs0VD4oTSNixtkvZbWyRl4T9/1B5
         HCDzor01zsaXef472Ux30T7GzovMDmmkrzIsiivDMHIIgHecNI8NLdG6iMlx1pzbN0/o
         mElD1jYzMzx6erz1lJdXacGBvMHsFfK+SFYQVoaWhXjNsS1cpfzoOwKhAHO6FA6/kY36
         +H+ojx0ms0fNvB62159wzrgekwqeTcSTtKG5a9e0F0cMUGaQ10byp9lMXhF9saZPaTPN
         5rJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791733240; x=1792338040;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ezuo7eM4E6Ezq35kJfRYN6/gEW+WhWnzkY1e/gLtXdw=;
        b=nLwbpICeO19DT+SbzlJ1il7d5Zz3NLmCJNEswX12q6YrJLcx0Lq41eoJqPC1D/qvdP
         OyLKYIeNZnEi6SS5Ze1zn3Vr/K6ersY/EAA0/pgvRC1PtWiMfdWeLhlzqW7hIDvLiEGE
         YxZflxawMRX0lx5xN2eG2Y4yEqzzaPCmgfNS0n/2JNSaRddfvkbIiA+PE2axsiZnqVG2
         35Hh7zdgPbbw5dkBcJls45q7WgWZ2QbOzGjJlUkyOI7egKjVqTTxsv9uGZSJvaDmWT5h
         WFfbWFgehGrAzkOZvlDB6C+WJa4w/i2StgN+mwulSyMeBlDd7Z++e8upSW1Ap3thKnwW
         4pfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxhSefQFI2gGlE/ZSA5UEEi5BKCrTKKf9Of2zVj6oiI9/C6MsJCbep7+2oFGUrEFJX952zkyDCqTwGLvA==@lists.linux.dev
X-Gm-Message-State: AFq9FYLLfUjduz+gRMPsueJUHXc13e0y5njLd0MO9ppltmsYXwmknhV6
	ZqaeaBJ503X7V8nMGxNo+HdKvcVpoZ2n+pZD2wCjL10nNsxbvMfFhv8J/gLxdt8PFo/F0Z2/kBC
	5tI/D96EmXhOcleRPqMRHAejlp11FRII=
X-Gm-Gg: AYBFou1wWeLo4+wS5PjDVwAzdIvLOcsUaeQGZ3zjthfIN/UhECtJgWAXhieslRSrmwN
	bQnPsFQlM5duISMU2wQh/tnGDqW1vpnvgYlluFgllKiaDB4MP5XiYlxaNTZ+Nx+BNbjjrvMgkp6
	3032w2hvuilWibHkARwEB45xjsvcwruxQuXYUTLxkemW9pntVNSJb9DxCHLQU/Uy46AvBa0AbEr
	O4R24rbe3UoGXzHXuT/TQd3fHD6Q2adg7tHPcRm8J7SjUi9Ql/Ys5hOdusyJCuDqDmQbJRVkUTh
	zBGMKzcyqKbBQkA6j568X4kK6Mbow8uLH3uxBq5gnEM4ToI4Oo1uFE9L//U=
X-Received: by 2002:a05:690c:e3c8:b0:8b0:a4f7:7353 with SMTP id
 00721157ae682-8b0a4f775ffmr564347b3.13.1791733239782; Sun, 11 Oct 2026
 08:40:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0086-v2-646731c4254a02823b4d@gmail.com>
 <asnqJTe50D-EuhTb@p15>
In-Reply-To: <asnqJTe50D-EuhTb@p15>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Sun, 11 Oct 2026 23:40:29 +0800
X-Gm-Features: AclHuK8wl5bUDwHdsoPgyvGfRUE2IX5tcHCh4GdE2cF8ynKNq26ERA1R8Cvo4fU
Message-ID: <CAFRLqsVqawLcZK60Wt2GKszXCeeJj6WNEO09zwybxO+mkOUBaw@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: Publish the filecheck owner before adding sysfs attributes
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	akpm@linux-foundation.org, ghe@suse.com, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Heming,

Heming Zhao <heming.zhao@suse.com> =E4=BA=8E2026=E5=B9=B410=E6=9C=8810=E6=
=97=A5=E5=91=A8=E5=85=AD 15:38=E5=86=99=E9=81=93=EF=BC=9A
>
> setting to NULL is unnecessary, it becomes a harmless dangling pointer he=
re.
> Other code looks good to me.
>
> Thanks,
> Heming

Thanks for reviewing this.

I checked the failure path again with the help of LLM, and I think clearing
fs_fcheck is still needed on this baseline. If kobject_init_and_add()
fails, the
function puts the kobject and frees fcheck. Its caller in
ocfs2_fill_super() then
jumps to out_dismount, which calls ocfs2_dismount_volume() and, in turn,
ocfs2_filecheck_remove_sysfs().

That last function returns early only when fs_fcheck is NULL. Leaving
the dangling pointer would make it operate on the already-put kobject
and access the freed fcheck in ocfs2_filecheck_sysfs_free().

I may still be missing something, but based on this path it seems the NULL
assignment is still needed. Would you agree, or did I overlook a case where
it is safe to leave it?

Thanks again for taking a look.

Best regards,
Cen Zhang
