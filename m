Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7650822A4D6
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 15:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761750138; cv=none; b=kdXM9UutDrFEWyy6Si83H2Bw+bmfsgYnj1trM1vCn+gWC/HTfIfBq7PpjNh5CSjKtlAZGITU8behg6Tf/V/9NHGkxjJIKvTtaix3hPDIVMTZBM2BHQ0Ac57HRkKO6nN9cWe3ZaE+ELfnJ7Ef3p5U6Bff9ypHQNGcy55z83ihGQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761750138; c=relaxed/simple;
	bh=EtUhswymVMQHOpqsxRbh1N0WNlqbwva0l0wUNZ1mOXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=alwTLDtjRwDhKJay/6xz8ttqCLtE6W6ZZM6dXvXjkmtqwdpCY55C3zk+/6jFAMvV5W8LdXsa5iZUh33xqXJduSt2VN5XDgDS/MISyVuuTfvMab8UM8cI8x7VOHmd+V+i48fNWtHcFpRIS43mqCMiFEArkTSAMa/TGXkYOrU+ya0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BpnnEsnY; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BpnnEsnY"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-63d97bcb898so62046d50.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 08:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761750136; x=1762354936; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EpOjZgm2V4L8ELcigzO9YtF8ftHrknnJRbCrky8ghSI=;
        b=BpnnEsnYMU/fbLVkCp0VmYGELR+NAnsMtUC3AVPR7z6xYHO3IrK7kFtIch8bqeTsn1
         9r7Y5HXU8DAQlVBT2C3vlVRwy0ZHo4pbhRgLwH105Gs0/akMm8efWZmFvEjg5jEsGMI5
         +fLZZxqODLzb0tOFr5r5emjCUtCOZg5ur8F0/xOzOXt9a5agDHIsDxD7hr062R75cbTg
         zgRrZ+v60VZvrTwDhgY/E5qJKGcGVXav4O26MWv9EX+skILL+i5ZD6/NXHzxEzveXm40
         71MgR6Ls+STtu7SP3d1+tAF+bDomnCznryYuxTVl3ItDzBkvVAUQOtW0w55jb13AgPgp
         NQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761750136; x=1762354936;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EpOjZgm2V4L8ELcigzO9YtF8ftHrknnJRbCrky8ghSI=;
        b=RZwOJWy+GYcXK3yIX+xlGQ0TI1jYD4zPcnkCp1muPYCnCeZIcxOFtCtt8lAcbqm22O
         6/lY+ZD0oyHxZc2oTvw5odvGH2RVQ2Z4SRSIwoOF8/pX+Ns+XijY5nEbgSP6KmhUhqI8
         4Vv4VTTi2TAK6FCYm1iFGTCCigLYH9asH0B6cLkwOGnz6sk6809a0AOyVYIvcgYVlF4t
         ca0niEUpTlREbCHGzr3NGgFeGCELMlwZ6YhrunXOj7Cgh/CHUZ5GLFy6XNFK4PtP2eTh
         1UnJKXk+aEVEAFmajMgV0Ck1iU+L8mTcMANoKFEyXypwElKdWMpd+RoDu2jf7Oc1GCq1
         MZog==
X-Forwarded-Encrypted: i=1; AJvYcCV++5goCeFYDd2BAlqfv5V164VaQhD2ZPPHr4fTOT0UFC39wsA1qm8LVYKBT+hy95VPw2fBHWlzO9QNyw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyI7TRY6n5M0ALcG74dZseI54i197SEbysPiXFxgsFqK84CFYE0
	OXSIPxd16XhFQZ5jZ6+SctyZWpuaCYYjZQwKZBfNVGsaxnyTYGzuIdxud5irkXXdethzyhppRb4
	HkNRlSquo0vufta6apOKswR2DnQ3uerE=
X-Gm-Gg: ASbGncsKomAAjuheGEQoOoX3Lrn53hqkTWJyMqOiHWmpw1IGz2xhgq3Ahd4/MLSobXT
	atfu7sg5XiwE8RhH+gsg7FP95m//E5xMHvucZjNdDc92+qb9rQqeoZwl/O3g3c/DnM0nqUmsKwE
	KSWBA/OD/tuQdrp3siCkwVh5R9CtQTjfy4wlg0Pj+FYkn2voNZoCl+08ttMVa3cMS576h9q5UWY
	BkZ29OwPMFSBHbM2fzhehM5W/wWtsKCnGi8gfNRykWwt/UVO0KNvhw/smn4w6XSGbaEpmnkZMse
	OImSxrsyO+ddTP2GxQ==
X-Google-Smtp-Source: AGHT+IFAJzl5v9GfpcorgskAIw0N+sbQsVmVk5qMk26i6GHpKnzhmIFtR14lUA8CotmhIkiQgzMOeZvu1/s9UCthEH4=
X-Received: by 2002:a05:690e:155c:20b0:63f:3ea7:34f4 with SMTP id
 956f58d0204a3-63f6c6a955bmr4871405d50.28.1761750136042; Wed, 29 Oct 2025
 08:02:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru> <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com> <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
In-Reply-To: <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 29 Oct 2025 20:32:03 +0530
X-Gm-Features: AWmQ_bnQNvM9ISUhmXuRIJo2fyxeSKUb6i7sy6N9sFbQj-uIe8E_7aysaq27MoQ
Message-ID: <CADhLXY7Uy-y8gAtXD1=xmc_UBocVci1z-nE17iA7q-y01Y_WFw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, akpm <akpm@linux-foundation.org>, 
	Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Dmitry,

Thank you for catching this issue! Since this validation was originally my
contribution, I'd like to help fix it.

To debug this properly, I need some information:

1. When you run `mkfs.ocfs2 -b 512`, what value does it actually write
   for cl_bpc on disk? The error shows "bits per cluster 1" but our
   calculation expects 8 (4096/512). Is the on-disk value really 1, or
   is there something wrong with how we're reading it?

2. Could you share the complete error output with the expected value?
   The current message only shows the on-disk value, but it would help
   to see what our calculation produced.

3. For reference, what are the cluster size and block size settings
   being used in your test? (e.g., 4KB clusters with 512-byte blocks?)

4. Do you have access to the filesystem image or can dump the on-disk
   structures with debugfs.ocfs2?

I suspect either:
- Our calculation is wrong for non-4KB block sizes
- The cl_bpc field is stored/interpreted differently than we think
- We need to validate differently (range check vs exact match)

I'd like to investigate this and send a fix. Let me know what additional
information you have, or I can create test filesystems with different
block sizes and debug it myself.

Thanks,
Deepanshu
