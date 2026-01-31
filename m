Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA755224249
	for <ocfs2-devel@lists.linux.dev>; Sat, 31 Jan 2026 00:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769818940; cv=none; b=Rlsb6U7VXELYZVcKDK7RMRHVVmHfia57Y+BUhlkojHeLK88SSQRrsX1XrRDsG8GwJmUK2TvwS/dztnWSj6JcoiAb2ZlOf2zTNeqBuoWcN36iAqY1ZJ39FVIRectyPPqmMVsDcQTciJSq4ewMb2cBDuUV483bkFar2/k0yvmdJPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769818940; c=relaxed/simple;
	bh=w7+B8N3XRoFg3Of/Fw9iyPoy/mghU2Qrl0CPBbBgDGk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eE/3K/gp0ywT7q5p9e7ilTSp0OiuWWpEQZDumZuadIHYtUHOtM0xdbgWES+pkBwxI56xhrUutZJd1+e9a3OI46C4TvwJvMQU4mdxrwrgP+s3TF7baph+uPCTe3C8VT13LGYa4BtLuqAVhy3Sc68YuAS7cpquc9xHDjz1JaZAOuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gZN4xk7M; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gZN4xk7M"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65807298140so4438162a12.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 16:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769818937; x=1770423737; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qV4mmOV+uOXX/Y9XduJfQAli873FtpKVEKD92eDGYCM=;
        b=gZN4xk7M6FhPjBdonvYfa2M26+3K5E0ZSg0DCIhe9UJ50IXbnLt0MIEz9mvelgRz35
         BxqSW0B74UaD8lDs4+3PQgbBHTYB2DG53IeMga/ymkrWyQuLA7QwriaMWXBfsLRvGNXA
         4EoCLd3PlN0gsR2o68YB39ObiAguKFcJAb3Ik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769818937; x=1770423737;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qV4mmOV+uOXX/Y9XduJfQAli873FtpKVEKD92eDGYCM=;
        b=I+kxs2iMcBod91K70ELjTqTWPrdD/70ZP4kd2aFy8heiOQRkYCXxFg6ctGUwWQyjno
         mu79iaZ2wxB8jaLNmIdSLGpodWdnehWh9fuOwJnRLTXdZDxGmWxzUs8p8HIRWd/mOPby
         FNK26Wkmu9KbodCaUyeeJJP8NuSdc0dpg17kDCkaovXbmAxbi2Dbg7a3pGwHIpWd5mh2
         Dsu675HaoMZBKk6l6InaAF28YRRfWdsch6lQ79KZj4ufamAZiR93cgiYEd47EFrxtw33
         b+p0y1WkuSngsnvgUm8ZoxK3KGal7AJLvIs5fNlYyGS9rfQyHII15VoLlCujoOBQJ5Vf
         S+0g==
X-Forwarded-Encrypted: i=1; AJvYcCXuVVmUjYTyxXrEvPYPGTVUOt1MAqp7kDw+uW8XJnA+myPwy3Rmx8p1oRF3oSO1KDL3a93AmSALthr47A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzSS64gfaICVwDP27rjMo+NtQFsvK8w2cCFL2FTjwk/8K60Y1Ge
	BpRk/Nb3I0c6+PfbIsBVA8NhglO4o34r5+Fj7t6nWG3MNbNCxsTeXnSy1+TyBUrdnIWTyWQcwSw
	LPF1k7lk=
X-Gm-Gg: AZuq6aIRCNCH6Gnx0/YNpaOQJZGfvczO7HEuPQqQu69MvrDC7YLDbgqsThMnYuAKaGt
	un/DpAAXp+N9auLDNeQLSmSPJ+wa86T7tfclswvBbdreBinsVDibywQL1p7MTFvBFUm1V2vi6DR
	E1mNKaQ4cgg52qYyFFcrVYXmDipE7RkaIG9m8gV7U3AY/OwljC7Ym+8p0xGuN7KIwxFTK22/od5
	W25+snD2sIVc39pchjx98YOsA2Ff8tHObj6s44/o8CdB5AVAzAWqv4mCj3qRZFUygqUi1sxJPvn
	6NRlldwQfYKFcdLw8Xl5q1aoKGrFoz1sYb38q4XZmv/MkWhAn0h2lepYM4ePDbkj2wSM43SKRIe
	jCALfvCOuAiYEHOMOZl/zZF+v0pOcqsHtk1v4iM684xnQjZFCAx1QskrohjHuLDbtUCoaYExISL
	bv6F3xWvSNR5cmjZZ4z+/E8zYnh2rJUv/K6l81PPYtwVqiPm/IcS2wGnYNZg2g
X-Received: by 2002:a05:6402:1ed5:b0:658:b76f:da7a with SMTP id 4fb4d7f45d1cf-658de5536femr3015593a12.12.1769818937049;
        Fri, 30 Jan 2026 16:22:17 -0800 (PST)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b4691dbfsm4801045a12.20.2026.01.30.16.22.16
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jan 2026 16:22:16 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so417159066b.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 16:22:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWVD5jBFDWomLI0ZZsL8WrBISqKBB6ZIBtWhSA+B2eUqxbhMzv4hcAZf4SgUWNg/uVO/mVvjw5yfgbOow==@lists.linux.dev
X-Received: by 2002:a05:6402:1d54:b0:64b:4f44:60ef with SMTP id
 4fb4d7f45d1cf-658de593957mr2779765a12.27.1769818504441; Fri, 30 Jan 2026
 16:15:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV> <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV>
In-Reply-To: <20260130235743.GW3183987@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Jan 2026 16:14:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgk7MRBj4iwQLHocVCa94Jf0cMEz2HzUAS9+6rGtnp4JA@mail.gmail.com>
X-Gm-Features: AZwV_QjK3epqif7-e_sBGUc-n0f418Z3nV80PkvQC8yX5DIdQ4ynfWKt9EE0KMI
Message-ID: <CAHk-=wgk7MRBj4iwQLHocVCa94Jf0cMEz2HzUAS9+6rGtnp4JA@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Samuel Wu <wusamuel@google.com>, Greg KH <gregkh@linuxfoundation.org>, 
	linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 30 Jan 2026 at 15:55, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> So we have something that does O_NDELAY opens of ep0 *and* does not retry on
> EAGAIN?
>
> How lovely...

Actually, I think that is pretty normal behavior.

Generally, O_NDELAY and friends should *NOT* turn locks into trylocks
- because user space has no sane way to deal with kernel lock issues,
and user space simply shouldn't care.

So O_NDELAY should be about avoiding IO, not about avoiding perfectly
normal locks.

Of course, that horrendous driver locking is broken, since it holds
the lock over IO, so that driver basically conflates IO and locking,
and that's arguably the fundamental problem here.

But I suspect that for this case, we should just pass in zero to
ffs_mutex_lock() on open, and say that the O_NONBLOCK flag is purely
about the subsequent IO, not about the open() itself.

That is, after all, how the driver used to work.

                Linus
