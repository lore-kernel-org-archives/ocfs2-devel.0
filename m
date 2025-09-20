Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0F32AE90
	for <ocfs2-devel@lists.linux.dev>; Sat, 20 Sep 2025 16:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758385610; cv=none; b=NSGpbGGJU2zd4KJv0rk3mqSHYOD4p7AcBoBqbaISYj3pyCmaN6z1KrJh9bi/+jjuRKBDujP+MweyB8MA/CfUDfVI5dYZm1zcScsFilrqkNpX3Gmy0oUiCTzcOQYbYO09uCJ8z/4nZUirF1+QCjDPHa7xOHkiGTHF1CF083G4OA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758385610; c=relaxed/simple;
	bh=mNO5F5NJlTITJbrMxJ3wyu2jz7VIBwYhTqCKBzbt4xw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HMW8d1/HMTKJHX9wK/1JK2ZZfAV5pudn5jb2Ndt8KRHEa+2Ily52Jp22Cb31ULn7/vH2u2Bt8h9+2aX5N8ZzQ/Hi3hN/AsLI3OdkZjrt1qJvGozFDpOH3sM7AHJyYeWtK+BzEHGLuOBazrZmTvlZpcNUMYevSvZ9TsBoc0tkeNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e7RKNTyH; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e7RKNTyH"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-62fca01f0d9so2970382a12.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 20 Sep 2025 09:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1758385606; x=1758990406; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GvLRCncIiqRrC6qT6Y0+vbtoZaqXeTLbbsZoYra2n2s=;
        b=e7RKNTyH7WbD6qTBIZYZyzprpzqQAcvVubRWmAwIeYUwYu8uVTr1x5eCjCaN0o26zq
         o9E8KnjO3f29kWtAl9LugYjVPkw1cGekMbkqIhKEvX4+tTGo4ftN5dSyCZ/1bqiSMgEw
         Z3Xzt9IBVSuc4fJyXdns3R9X3PXPUM3p0pTcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758385606; x=1758990406;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GvLRCncIiqRrC6qT6Y0+vbtoZaqXeTLbbsZoYra2n2s=;
        b=tdLUQEkFX5WZUp1zhc1nFoNBqaTFn447hP0PGvgUFZ3Vim2mPNJE+h5twYGnOfMF7w
         U/GMu1N2Yp9WFmBadljFPezdWWEnQue0ZeMVP1v1WWB4ohEL2yJxGk0d6aG28N9b3tH9
         5+8UGbeVLMEV9wY2xBQR3wtWK3oXSBWoD7IjzE3FfgYIcRdAzzaRtH2+clHEzIRs2NIp
         ABCShXZVzfVD1b9A58rKJTUBjp0PGwBMp9kD/9uZyabNS0EiRFyeMIG6EWirAyPqWic4
         h0r3PD0AB1XWZ5ftpAsiRAfMoxtMNPWcsSOc3CRJkulxaTugfJIvtakLq8/vldoJHdNq
         qG3w==
X-Forwarded-Encrypted: i=1; AJvYcCW58roj3dqHJLraC4lXwPVuVI/nHTV9rxzwyueXvbkfbrK8oVkGvkuzqslV9ocaiTtrMQbF143DvR8ciQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy78X5mTiI+HT8DjQfls8ym9oQ12LzSVHcmWmGhNPy87Ibq3e4
	CxAR5TfOeoD4eCNo4dwFt/npEVgSDOV7duRPbBmPLF59CvuQyLsyk47/awT/0Pbxz7vZYi+Km5e
	fUgnW7y8=
X-Gm-Gg: ASbGnctW1+2ki3628kcUQnx36JbayZL50uU7brh/6zOmsk/+N8SqSq6oVxjBoLxxF20
	uDpd7hzjvaVYnXLiVZforVqO87cdLYgFD70elTx/Jp3Mj2rMU5pnIqafXEoLaCtfJ+CIPMw5lFT
	wLTMTHqWJ5reTVKlw0LrRyWvdgP8JKgyXWUOxJtMcmZYlt3gkH4Sgt5pUpNl1QVZAnTOK2o2nGL
	soJb08mFJE4+Y1JWaF8z5HoJVZDBTi62e5cM8zMEh94M5JyqFANPj3otab1afbtu44T6SSpzMPv
	SBB0PwPGmvLx7XiUmiyDe2ycJ/S+S3nsOW2CtReXEkQPcuMWHnaqtOi7zdeeDrncLcomqw2PKxM
	EuxlvJoV0r5OOLVfebu9cnSRYGP3xOT4cN6hjGye2YhpRPqUzKVdXZF3kmJtA4o1sqcdF0cqF
X-Google-Smtp-Source: AGHT+IFNtkkun+AsdS4oUIPzltxNFaGjis0ZNEYOaLY9H1FL6Jco6Dr7dKr4rI7mOeVOpIyiLm326w==
X-Received: by 2002:a17:907:60ca:b0:b04:5059:3b50 with SMTP id a640c23a62f3a-b24ee8e40c5mr747537966b.15.1758385606106;
        Sat, 20 Sep 2025 09:26:46 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b2761cb52a2sm248756766b.53.2025.09.20.09.26.44
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Sep 2025 09:26:44 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b07883a5feeso600156566b.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 20 Sep 2025 09:26:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWMhOt93u/Wblgy5pvTvcPQaFthnCSS9dYHsVzu6je3epdQkoe3YEuSI0subI+by5XOPMHfVb+x6a/nPw==@lists.linux.dev
X-Received: by 2002:a17:907:1c89:b0:b1d:285d:155c with SMTP id
 a640c23a62f3a-b24ed88702cmr706169166b.7.1758385604052; Sat, 20 Sep 2025
 09:26:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250920074156.GK39973@ZenIV>
In-Reply-To: <20250920074156.GK39973@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Sep 2025 09:26:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiXPnY9vWFC87sHudSDYY+wpfTrs-uxd7DBypeE+15Y0g@mail.gmail.com>
X-Gm-Features: AS18NWCBuRxfjxFE7tKBAQqhhkva7pQWM9EJwSLVmis6atYjgiGA5eqHrxKhjLE
Message-ID: <CAHk-=wiXPnY9vWFC87sHudSDYY+wpfTrs-uxd7DBypeE+15Y0g@mail.gmail.com>
Subject: Re: [PATCHES][RFC] the meat of tree-in-dcache series
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, Ian Kent <raven@themaw.net>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Hindborg <a.hindborg@kernel.org>, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, Kees Cook <kees@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-usb@vger.kernel.org, Paul Moore <paul@paul-moore.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, linuxppc-dev@lists.ozlabs.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Sept 2025 at 00:42, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> The branch is -rc5-based; it lives in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.persistency

I reacted to the "d_make_persistent() + dput()" pattern, and wondered
if it should just use the refcount that the caller has, but it does
look like that alternate approach would just result in a
"d_make_persistent(dget()))" pattern instead.

And I guess you already get the lock for d_make_persistent(), so it's
better to do the dget while having it - but arguably that is also true
for the dput().

I think you did pick the right model, with d_make_persistent() taking
a ref, and d_make_discardable() releasing it, but this series did make
me think that the refcounting on the caller side is a bit odd.

Because some places would clearly want a "d_make_persistent_and_put()"
function. But probably not worth the extra interface.

Anyway, apart from that I only had one reaction: I think
d_make_discardable() should have a

        WARN_ON(!(dentry->d_flags & DCACHE_PERSISTENT))

because without that I think it can mistakenly be used as some kind of
"dput that always takes the dentry lock", which seems bad.

Or was that intentional for some reason?

Talking about WARN_ON() - please don't add new BUG_ON() cases. I
realize that those will never trigger, but *if* they were to trigger,
some of them would do so during early boot and be a pain for people to
ever even report to us.

BUG_ON() really should be shunned. I think it makes sense to you and
for automated testing, but it really is absolutely *horrendously* bad
for the case where the code hits actual users.

                 Linus
