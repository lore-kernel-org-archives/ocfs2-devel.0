Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4BA334372
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Nov 2025 10:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762856911; cv=none; b=ED+fe3inv0gBMhLl+DT6/GdmHdo7qmyFXROW2PiL6sQ4b3yPrW07V0Em9agIr88xLoIqNCMhrbj9P1kDmycR2aGIVCas+6uiq3JowveHyM0C6Zz+E2h2vSpsYPP2R6PCZHjqfpegRHisEJac/chidbXNSdoMehf4EFfrFDZH0SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762856911; c=relaxed/simple;
	bh=AFJjiFOvGyHo0S6e8akF06HQkuXboJRcqUguRvorBaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qo1nD7SYtRLDnO6MlXtbOqCjHbC1rFuXtsMXNMMt0KMzl6H9XTlgARTo466MW8MDyRz+i/kkX5IbIzkVC+7aKTOLLF1ql8P0H9DjBrW4DsGUvktFMR5ZCKcXfiwxHwYG6WP+johiqwuBJcxSuGPBb3m28sqxgT54V1aUx/trv+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ghrLUyqN; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ghrLUyqN"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4edb029249aso20330921cf.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 11 Nov 2025 02:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1762856909; x=1763461709; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h/p7mEepN8jUuWyprYCkVkbNxCuAN/nU2Y/T4HHlQA0=;
        b=ghrLUyqNXJ3pW+VXX5qRANMjkaqJPJiN0aq5bC/WXq8B56N/M+3dxovCHM0DZHs3lb
         TQX3thH3MGFdI12BfckCC+gpgwbnXMytCcjZKfX3b4DLIbqkY7LeOxGY27hoqmWL7fFV
         mbcGprG6tDV8H/mYcClQecE/dvuKSDkoCpdLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762856909; x=1763461709;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/p7mEepN8jUuWyprYCkVkbNxCuAN/nU2Y/T4HHlQA0=;
        b=dk17I8Xgn2IL4qdqyHuDu2kMiry2FX9Ijhu4QOFnKrOKtXn5nOnXNyCZgf1x6CcWW/
         QyJlI+h2fV+ciWTgyZvt1cdhbPtkG9i+va6sPZTmNXbBd2kaZHrL68pdR1CzzZsso26t
         w/I/CADiAvXVCgOGDQvyfDmJuQMZiqcgkqEYt1hmF5TwLFg5aGr5QbNPDwlJF1M1W72y
         6i8rxkVY0R2rmKSMz9LDEjTOP9xcwG2VgoOp+558zp8ykz358r31Z9ih0u8TBzfS4Cq0
         7dImx3Kj8sMy+iCp4I15Eyt1ji9W01uB3bvSqkUR8z+isrpPKZG0ZZFDA19zSpqmHfWL
         vS5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXe8LebSFApzz8CIDjr6wsDDjRErp3fTaKbARQVLt7m0DMs43KZ5GhNeKkvXpTyTcARFowMPbTSYyx3lg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9Yp65vYUDSTplYHZ5QEsMYIKaF7pNLAWHxA5vf3eb/ecRfRBP
	+M0c4DnVo7KeWYNH2lc2+4LmH+ZKpdlr9J4i2cyaQ5F1ac+yuUlPRXW9wH4acWzmjCbx1PowRXe
	BvGNywSihWJjfxIxaM2F/laxKGUt5yCQuiR6zNu4AzA==
X-Gm-Gg: ASbGnctkZIwiUYbkKNGV5dnl4YEs/GLSB1eU+UR8aLq6FthH9VeGgG0scLcE5DaXlpF
	X6OVSGqu1zYSCn38f1dsOHYfh0YtJUT9JIDo8K3K52KPBuB2uhstbv+R9immaUqbPooRThdhKiC
	3ey2W9VxlIpHwbmJqXa6e/kEA5V96oh4iaxbazotyDHmm81uNhfAZUb2Fk+99pf+NKf8RiQXUpv
	Urr21NQ71aGxKOS5P6tdMgg/rhIFR4iVBhBCrr0arCYPKOrgMjIJJvLulM=
X-Google-Smtp-Source: AGHT+IF2jsXtOYznzAlKiswAAYjfBT86jbKpGaMbobTgICmObIV//j5aCRxdPYkP+19MfGrAnajQvcSXxRuiu1TbWoM=
X-Received: by 2002:a05:622a:1898:b0:4ed:602d:dfb8 with SMTP id
 d75a77b69052e-4eda5043040mr135933731cf.82.1762856908949; Tue, 11 Nov 2025
 02:28:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk> <20251111065520.2847791-18-viro@zeniv.linux.org.uk>
In-Reply-To: <20251111065520.2847791-18-viro@zeniv.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Nov 2025 11:28:17 +0100
X-Gm-Features: AWmQ_bl7He3VQsld2UXN2E831Naa9ot3hmwpZMaWScQnQVWsufspzsog6zo2yMQ
Message-ID: <CAJfpegv0jMq96xD8gSbMBydj=1wRixVGy+qd3feC2vSSn7v_rg@mail.gmail.com>
Subject: Re: [PATCH v3 17/50] convert fuse_ctl
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, neil@brown.name, 
	a.hindborg@kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org, 
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, paul@paul-moore.com, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Nov 2025 at 07:55, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> objects are created in fuse_ctl_add_dentry() by d_alloc_name()+d_add(),
> removed by simple_remove_by_name().
>
> What we return is a borrowed reference - it is valid until the call of
> fuse_ctl_remove_conn() and we depend upon the exclusion (on fuse_mutex)
> for safety.  Return value is used only within the caller
> (fuse_ctl_add_conn()).
>
> Replace d_add() with d_make_persistent() + dput().  dput() is paired
> with d_alloc_name() and return value is the result of d_make_persistent().
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>
