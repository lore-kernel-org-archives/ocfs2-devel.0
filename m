Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0270338F54
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761749388; cv=none; b=JoZ0DPhJbb6jHnYdgF2JHtByjSDtijSE/IdcfGaMsCzmg2g+LxaqeAcxuobQUQSBr4zS9pXd5xTO7CF7oHJueT1/S0gxI4YQPC+x/qZVNO+5s4pAsRSlr6G6FQxoLk573cbJ+w4eEDtrb1mHFnstB4s/vSGYl8WoeQ56peT9a5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761749388; c=relaxed/simple;
	bh=N/H9Hc3aJwCtzPmRJOck3fIp82+NkA0LZ9tUFRkG0Bw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P9VsZ7V2jUmeG4/Wn9O4Mdy7/YcwYhgyZH0gvpyV58SI+7UARN+33xu1kFBwUXZQGicB13etn8BQiBs8pYQMTe7O9qyDBgHrYvbiLFa9qTfcwT3sq/4H/nzXz20Iuf5AyWkyqFOFU9q3ZNAF+vTQSxQMN+HFDgU1M7ag1QbbW+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=IwDY4gsl; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="IwDY4gsl"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-32ec291a325so5742508a91.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 07:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761749386; x=1762354186; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vsfcHn1joSx3FYcBHFCIU4wVQAcpbVHvkEyCsZn4M7g=;
        b=IwDY4gsl6isqBJGHjjZVFvz/+eA6ag+9zQ0DdjqjuwjAvWXbD9LCQKSVIG7i2o6w+9
         GOZJsupSW8plIFvIl3LEPBmA8D7PgdNYjPCi7iBAxoyBve1L4Bevb094ED1K4a2eAY5l
         ng3dNmrHj6h2FGgLWlK3O8FXdE/g6sv2L0U5s4LdhQ/8GN/20AhwCwAv2+PQG9jDHSoT
         MPGXEmWDxegQZIrZ9Mquwnk7ICPuEOIA3CetHWFtbqs3LTDljqt3QbZA3RmWjase/p6n
         s/YNCgWB80yKM2pN1BeVFGjAf2Ek16xdWhjQerAPlYxz9ujSsDK9mWE6Mkson27U5mpl
         AZ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761749386; x=1762354186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vsfcHn1joSx3FYcBHFCIU4wVQAcpbVHvkEyCsZn4M7g=;
        b=XtbpLVV3Qzhuz5PNgFRTySOeojxSMdllxxtLjt7WRYiMgy5xDkne0vLjb95TRx5ltg
         5WYN3zfFWV2BSFh7SOBLso8rb4/9FYcpMd3wUYBjaQRr8BLqz6yLgB2pw7JruD5yLxpe
         UvwuE+SANT12g8LQWu+maCo5cwgpQ3xvDezPLWj7pDx8S5J76Xcs1Vj7eQ2Ba/S59YeL
         HXpRulLrW9XIMuYDkaveSbFyJJPdPIxIJQcJ1uYY7H13MPDqZix4RXc8bRDcFfWSxFT3
         ls4jmrObFI/L87YxvHBefZMphIS+5cfF9z2cH0nvvoMw5QODFA79gopxROPH/PMf7wcT
         3siQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwM0YHTRwkxFAN1fTRL6pievrgutjOV1mBcqpMzCSZ+x7L9OkshFXW2V3rxRE3nDx6/OA/tyajysGtzQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxE1bhUH7YYlFrCwvOgnqBreDyJ98i0uKkFvTXrjvBaGCGZ51Ml
	IG/kAyWEeaXaIU3g8sbxyr1IDCJRmHVw+tLND9OvcYA3znC8SYeRdYo/aMQe+gZ/FS3VKUaYq7F
	m/vmeOyAEkRlBsV5bz6YujwHIWGi1oYQf9mt7UiAb
X-Gm-Gg: ASbGncvGFTHZ5sappY5sIlkBOpsJBIHjXjoYIi/HvWd6ndXqZS/qkGQlORsjNyyDema
	7b0NXEScx6xNpS7SEFGZ/GG8wpx6WLCQm1Xz1kLo91gGMtmUqZX0cHD/BniI5LSVYbI8p9mPSBV
	H2RmG6DOwQKTDdGGoNlKMn3vjMu9tDhVoWLo/b7KlggdM91cjlun21nSkyI0minYfeLDtE309TT
	Y3LXWMT1MuI6mzE+BgT0USINxAdLvLA0hl681JJhUm5vil5j2INRS7Iq5GH
X-Google-Smtp-Source: AGHT+IHiN2wVay8qKwNUCQNQedszNEqWD+gbH8QhJy+T+EtTl6Gz4GwA6YgaiehmmoZJBoAentF29nQI5J4sc3vsbuw=
X-Received: by 2002:a17:90a:d64d:b0:32e:5d87:8abc with SMTP id
 98e67ed59e1d1-3403a302f52mr3761415a91.36.1761749386246; Wed, 29 Oct 2025
 07:49:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-36-viro@zeniv.linux.org.uk> <CAHC9VhRQNmPZ3Sz496WPgQp-OkijiF7GgmHuR+=Kn3qBE6nj6Q@mail.gmail.com>
 <20251029032404.GQ2441659@ZenIV>
In-Reply-To: <20251029032404.GQ2441659@ZenIV>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 29 Oct 2025 10:49:34 -0400
X-Gm-Features: AWmQ_bkw5gzRbiAC20oxF8nOixccAI_lXABYmuYCSfnezye7FZYc2Gs15NqnG0I
Message-ID: <CAHC9VhRefx4MBDU78Qob7Pe2pDLK=1HK4b2EuTtENVssntHecQ@mail.gmail.com>
Subject: Re: [PATCH v2 35/50] convert selinuxfs
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

On Tue, Oct 28, 2025 at 11:24=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> On Tue, Oct 28, 2025 at 08:02:39PM -0400, Paul Moore wrote:
>
> > I suppose the kill_litter_super()->kill_anon_super() should probably
> > be pulled out into another patch as it's not really related to the
> > d_make_persistent() change,
>
> It very much is related - anything persistent left at ->kill_sb() time
> will be taken out by generic_shutdown_super().  If all pinned objects
> in there are marked persistent, kill_litter_super() becomes equivalent
> to kill_anon_super() for that fs.

Gotcha, thanks.

--=20
paul-moore.com
