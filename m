Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EED333430
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 23:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761695937; cv=none; b=QWjv24b3MQj+Nd9IKZYEAXdxOha3Ngz2gPnetBe/VHXDoKspR7pZfnFn5c3XBA8DiZvG8CooUtzCUJADrauV8KkpIuRDSVPrQonF5pZH70GfB/KlCmUtcKKWmFbNm/fO7ZTdnnu9IYrTeuUWJN5R8bZWRnm6TTMo6v287VIEfCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761695937; c=relaxed/simple;
	bh=kk8zkzm83REChxkZSsstjBUXBS7wFfE2QPwc7AaZrqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kjB35b0asHckj9NZgCAG7LkRcGTjZDxiSY3GisIPZO6aHb7ELS/+lsM8H2D/qbMY4T+4rQoA9rUvbwLMClslN4zgA0xx0wMmtsFyEI7smaOI+jHJqokdUPRckXSx02DK2FAG9SG0E2XzEMI2qv3ibOz64jGAiRP23hXbGllXBr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=H2Eht2ch; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="H2Eht2ch"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-63c31c20b64so10359793a12.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 16:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761695933; x=1762300733; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/WE4n4TCb18hPsMXmSS/+ET4xqQfmAur/mQUYq6ibGY=;
        b=H2Eht2chJpnmuYnyAjbdsrIzevqQYKWKiFwBsgqJQrjdxHWVYJrbisOLLimsIBqvjl
         jy+tPpi97aJrIhrovVQsuUtQIWRkVZynfbHD4WHjHIjyeh96rOUs3avO9UxkokLYDquG
         YsmCZVjKVLzvtF1IZA+VBgUCqW2RPmH2H095NraGep46a95qXUlk7Gh1gVmHMqXthiqn
         okvdbR8GI5GxA33hg4+EqB/RANrgr6NLbSGiHr/woKbI9Bqc9+UYr6vsyGzEmZOh6YkA
         scUNVdsimg9YJNMk3WUzZZ2qNDHphjJoLKVl7VTGyDgc+UEl40u6HOYl3kvxkTkA/p24
         ZA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761695933; x=1762300733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/WE4n4TCb18hPsMXmSS/+ET4xqQfmAur/mQUYq6ibGY=;
        b=w2U9ceiNgb2Yad0/7Qsjh1P3yW1sT9CagnW4K0JVHxbTZ2nndz3naEuv64h+zI2JjT
         HF+5S4JHzyyj0coXzxN5lEKa6eZy16M0VVP3fG1UELjAgMnI5eHHbV15jTzQcX1Yl64+
         Wg9cfip5sqV8+gHXAVMCrkT9l3LMxdSOcymIMh3kuGlLWeKu0TFw7PnEtIoSAQ4+sfNx
         J7aJHf3sGllvTZmAEDueF20PXWIJTl3ZhFFeeIuJCxhNLfLCFErW6cACtYlQsuwoLGKq
         Yrl5bFM/dmpAvTCyaJymW7X4HHyX8CD45ZZYRECxlbqJj2SsjF6lXAiSibz4Kp3FErN0
         52Lg==
X-Forwarded-Encrypted: i=1; AJvYcCUUI3LW8j9/+5F62n9l0yJY4WtQQeoIP4wnNXrFzc4Y9pUmDvoWqIjmvjnqvM8t7h0L9PjEgvHnEv0bfw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8aZhO95Q5oBhK1hgsqJxOhX9Wp9N8i7ogXS5wG4S7EUaOPupq
	I4F7wuemmYPp15aToBLpiV1iP5CD2lg5haYzXlWQ1LlSSPyD8uYvM7uNgLzacT2Tsh+fvvnW8Od
	kQsI5tN4MAnzUAw5GYG38I5MEPHtJGj6ggMuSF2qd
X-Gm-Gg: ASbGncuoPniyoTShpz7FsY5L5HboTALqAI25al1mi9hX2NQwBT4aj2qvkgaEkYaaOa5
	9wH2HLEii5+43hFnWdnfye+OIQd3KYLvp+2CrNb0iSC0qmamkRcKhFIio5kpTkdvOcSq4hHq8aZ
	l1Hf3AGWrY52hLiurOrfKbSqEJS/iWc2/jcD6/Kec2IUlykFJgLGZiMsYbnZviX5JOBEr9MwWI2
	0rF2TbVAjJjqAVEJTRAvM8G2Jb0OryPZvgqwZm8yTEZsDtben/wJOpiWYyX
X-Google-Smtp-Source: AGHT+IHvIzFCAVsIe9KLnMzhe7HeHw161tWjaGF8dq9LK8mHTJ5LNBNsg03z1RN2kv4hUoIzYntUB79AzDiL37F2WAo=
X-Received: by 2002:a05:6402:50d0:b0:638:74dc:cf78 with SMTP id
 4fb4d7f45d1cf-64044380bd9mr816143a12.34.1761695932545; Tue, 28 Oct 2025
 16:58:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-11-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-11-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 19:58:33 -0400
X-Gm-Features: AWmQ_bnbOFuYYw7q6A3vKx1W9tiGVviHbdGsSFCW7Z6eJ8jFBd6mwoz2mbQdJG4
Message-ID: <CAHC9VhR4nO+TanWwz4R-RQijy9h5B2h6HuBDXxBNp0+kAE4Asw@mail.gmail.com>
Subject: Re: [PATCH v2 10/50] configfs, securityfs: kill_litter_super() not needed
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
> These are guaranteed to be empty by the time they are shut down;
> both are single-instance and there is an internal mount maintained
> for as long as there is any contents.
>
> Both have that internal mount pinned by every object in root.
>
> In other words, kill_litter_super() boils down to kill_anon_super()
> for those.
>
> Reviewed-by: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/configfs/mount.c | 2 +-
>  security/inode.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Paul Moore <paul@paul-moore> (LSM)

--=20
paul-moore.com
