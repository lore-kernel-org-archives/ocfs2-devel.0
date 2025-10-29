Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11211D54E2
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 00:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761696501; cv=none; b=fg5/tXUpXxwP4ZuW4clTWoO5k4A3mTHChJhKMkN3+T3wm4V3aeFs7WxiHvBGIQRKdF8obmLEBUPnMRQSfsGkYDZqKs3wsWSeixCtygV6q4zLCGgjDR4V4BsOBcLF7KWbadDWFygwLqXd7ZBxrbdOTELrH9NMM/TGy6hsxMtaus4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761696501; c=relaxed/simple;
	bh=4+0VmKS7izmdzBSkGnuSr1zXLYq/caM1BpBnvQPHwUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TRqDXAqPL4EYAW3QU+8nS3jY+4RK2I0oUiCb+J6ho8itbKNBMDC6u6tl0wOgmz66hJ06XEj7P+LiQrWUuTWJuRr6AKe0XhstpVDELPlxyac5ymswcyIX/MCiHW9gJHGZOKq4kzT9VvRKKqFv6mbSHup77ECBLHchM5hNvF128F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=POez6qBW; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="POez6qBW"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34029c5beabso1686978a91.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 17:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761696499; x=1762301299; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cZjzJP5BDJixdHcjsD4MEtXcdIeCfYM/75TifkWeDww=;
        b=POez6qBW57hV3taQ0oMjGQYVL6pFFVdVYfKRHN2eM/6BvKKUQopDWTxO0iAOKYEC8P
         oOKlLWqOtqSH8CybdiWPLfHWJp/cXn7AcadQGO+wxjG8K4D4aZUzTzCLCBOFQ+bxvbu+
         Sgh8YZ1pN1AjyYEKyzZFsZjgoXzOpvcquWfNMHwkPbOZuTuyymYK5pRl1fzldgL01Tmv
         r9t3cQWkfbVPsl3VeHf7ACDAmQC0oOSIV9JECWu50bSlMtzQMZzw7ErFchJtMBl/6s/h
         ZaQWemoOxqEjLawyY9ah3cn9KSYw93N/F8EDxxX5f9DRgkHd6Rnr3xXkh0h8HUD9/xz/
         ofqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761696499; x=1762301299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cZjzJP5BDJixdHcjsD4MEtXcdIeCfYM/75TifkWeDww=;
        b=xSgeQF0FXzeJSjHbpMiTNdZlbdbVl3ljnO62B9150A+IfEOQ3+zfZnMcYxQrcVD22w
         rc1sJkJaI1K1kIregWFLzK+8G0Ep3GNsWfnZ0xvBQ/1uQ/G6N0M7P6963YvvncwUbnfI
         GTmGbfZrHiXO/3qJLydxmYHIr+Lit0uAwl1akUfnx5N9yusLc0LGXUGmFruvBRW2RMhc
         moSKb3XktVeHakAIiylyq7s4qr2ONoC0X8X3ZaHnDdGQ7f+oPBbMHu3PqBk9CGvyJLpG
         jzOZvo2hVHBZYRWGPHgy/Ym22wt+mG6sSKR7t3meRJ4WIpJycBgiyRfcuV+W8B3oZYoi
         7Urg==
X-Forwarded-Encrypted: i=1; AJvYcCUs+r1t9Q1zKgB+c9PNigfRWTkzrJMAc522SUHE33uO7tPSRjVoK9xcviBfUzb+XjKZAFWCFGfgmjjx0g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyZhZqQsJ/dUTQeWN0KJbETpi7z/7ZH2cWIXK2BImA8lzHe18hl
	eO5wm4YCIZ74JGVEI7PWVvXvAl0LH30Op5kvw5V0Day3ZkG4uOteKv5kvFU1BkgARjN+NLcGjSq
	C0ikM3AZDjYFekvjXZPe/tBtYIOFwaVa54BKWe60l
X-Gm-Gg: ASbGncuSwwu67OV1wThffw+l3fED6PGZs8QY5ph23dHMiKCkE/BaiHhS+O7cXAtQXdm
	Q+noCxGEZkuwYMzKXrMXRXq4urLsKIBEMnuuopxCyKg3ziJ9WZ6QxH7bhPLB2JLJGP/+r6dwDEl
	Hw/a7WY80RWyV9GPhF/gxyeYnmKsDSIoMeSkmPC+N9GqelvVtTFwTTb03qDP17pWt2LYSp7czJy
	D5KjwLVw5qsFniUIaBGe1NcNDF8/92FWWvXS3BqKieOmdaAQEOYAwdkMJJ1
X-Google-Smtp-Source: AGHT+IGEKRPFq5L2rd6w/ubcuTn//BXhetf/wOj9xAOGHPjYYno+UXGan0WlvoJBaoZ1JF4tIK0SCxZjeiDlUqLjb6g=
X-Received: by 2002:a17:90b:4a05:b0:339:ef05:3575 with SMTP id
 98e67ed59e1d1-3403a294f2fmr971614a91.26.1761696498871; Tue, 28 Oct 2025
 17:08:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-34-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-34-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 20:08:07 -0400
X-Gm-Features: AWmQ_blBn2fdqYcxKi_H91_QLngZD09fAUzDyH5oMtRPekpRq9pqWMOuQKzGUHw
Message-ID: <CAHC9VhSeiK=qqLMUDAKRTgS5EEHdVvLD7-afuDqJWYFindvfUA@mail.gmail.com>
Subject: Re: [PATCH v2 33/50] selinuxfs: don't stash the dentry of /policy_capabilities
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 8:46=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> Don't bother to store the dentry of /policy_capabilities - it belongs
> to invariant part of tree and we only use it to populate that directory,
> so there's no reason to keep it around afterwards.
>
> Same situation as with /avc, /ss, etc.  There are two directories that
> get replaced on policy load - /class and /booleans.  These we need to
> stash (and update the pointers on policy reload); /policy_capabilities
> is not in the same boat.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  security/selinux/selinuxfs.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
