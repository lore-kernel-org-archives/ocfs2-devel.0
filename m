Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DBD2C375A
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 05:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761629649; cv=none; b=pdJC3KUsFUx15LL7ceAOzCuwZBxizJFxgO9yaXuBPVS5fMoJ9RFkqffl7lrmNYLn+uTy0pdA7JkMZszsx6DnWYs6px2884cK7sWR+pqxxAHILYb61z02v6MLnnmgsW94Bv4/ROlwNr16wHJolzLml5EXrpS4DHkKL6gRYTc5P/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761629649; c=relaxed/simple;
	bh=UX3h0Pes41IJIATGA34ZfcGcoxGHwBRZyrCwKR+AqI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pTp8c7rrZ8Y4SfienrhzumO6iNZX2ePydAPz+WWCFWCsakY4rufCBpxzD+QXLlMwHEiOgJD8b/ukzQ2jeIB2n6RxMQMVCMq4BY7YYiWgEFEg4L+NAx0E7UcD+hGOFh6+iYLC6nh2JzTFDW9RtL7WtDMS7Xub4m5QClJ8kreAIRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CcRcZXx3; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CcRcZXx3"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63c556b4e0cso2604166a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 22:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761629645; x=1762234445; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kLpGC29sIJuMD8EW6D6+ekLf15xOznYOaep7iLxbnWw=;
        b=CcRcZXx3rBtg69jeTeDzEV/M3Z2IFSzwqEt/wVJGfMCjrTtmDOIs0v6XEfnV9XgS4w
         E53IgeJ8eEq9lm/XBPIyN1UP1gJCSmrAx1nLDosh52yOdhZoxTAgmX9CkjsjVtjxVPFI
         pN9aldosUeZTAEFizxiNyadgpF0VlObVQJq68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761629645; x=1762234445;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kLpGC29sIJuMD8EW6D6+ekLf15xOznYOaep7iLxbnWw=;
        b=oWCFcsR4bqCVzSfnmneHWoAF9VTXWWOBbndmfp+ozI/l8iHxjvcS3QUKsbizhbrbia
         cEqffy3n3AjCWXQgRR+KTQMM90eWwNQbTqzonRZSNz4YC/roLVe+BwljLQXruDt3zvrB
         /d/An2M1jhiYO3GbVoYG8QMyFjfG5bYEyhlKBdpFkkuHz4fXhZ62nMzWvYbYseKgnhJp
         tEYzN2dPx8Mxi9n7mxnWyg8/7Z3zr2XxoROAeNTC5t98ZizrV0iGAdWkL6/R6o30i+V3
         Em4mWf2QUPiJZ3zqYcmW+9f261hRxZcYdqtT+9xjzGlebSkG2Pst+OnPMUmJA5zN/Jvl
         pjdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsq0smAoAjT30q4e1yErJ/lZ9zWLkjsKzQ//zZlRip4lUWWD7Jr5+i9BK8M6d9EL8nTosV7vcDCZM4Ew==@lists.linux.dev
X-Gm-Message-State: AOJu0YwkEiJ1A/lqwDuPvT2Q/PSmuaz0CiVYDS2izxgsFneE6bYYQfq2
	EuFzS7gFqPmBfhMJuvZNEagKgyzlEpnO8CcyEpddGxy4+h9yFd1R5SQYxvUr5MExgkcS/p79ZXQ
	p9hsV3ky9cQ==
X-Gm-Gg: ASbGncsonR/Q6M1Xor4a2CDoKwfVYaMK5YxlTT0It8+SgYydsB9JDstfsyrDd+vB1ak
	m2k5iI1YSVOcuejl90AZnRgRRdnqG2EidzXTQ34qFcn34Xy/NRlRSJ6/and6qzZdH9+IK/l9r5l
	MQ9Am67rMwAdfjCWAHU4CXUDxzqsrNvjy+Ol2zjzyOoK0qlIM5PkvGmlcMMk8zfbnY/wkgmg0Sd
	HelR1Kp4CCo4Y6xqDPYgn3/X5DOPVpoG81cOCa67RzbX6WJWzQYizsu44IYkqQDYSWJoynTnGtl
	qvMRzmolY5Awi90gPN1SVKEkWm7uE4MJHuko2AHDu/Gb642jygdLgX8iSoQlOaQX9EoEG4j9VRH
	l3FYmjmEKJafbVppAyx8HhkddxxfNTsgosjRN5ZK8r2jETCy/8YvM9rsJZY+MIVv3+nn6Rb90Dw
	OaiLN/Kwt5rS8lrMf238HkIVhW8OSK5Y0DMj9PjXQMg3uNij7bZ7VnCRA/oP10
X-Google-Smtp-Source: AGHT+IFXg6BoF3f/Nf4p7GUaDex/fqJfmy9xwKVriyZQOqALhNSXMVTl6qO14zhkqHKO6qowJlGBHA==
X-Received: by 2002:a05:6402:1941:b0:634:4d7a:4d94 with SMTP id 4fb4d7f45d1cf-63ed8cd610emr1917569a12.34.1761629645268;
        Mon, 27 Oct 2025 22:34:05 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e8036cdd4sm7924607a12.22.2025.10.27.22.34.02
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 22:34:04 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-63e076e24f2so2483918a12.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 22:34:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUgYgaMj6/O4TQeZvuRn12cVOHV1/7U15DhYsJZkIiyGatebjfrgvUcLAjpRUtT1nTsXiep3RQLZQs07w==@lists.linux.dev
X-Received: by 2002:a05:6402:2681:b0:63b:ef0e:dfa7 with SMTP id
 4fb4d7f45d1cf-63ed848cba3mr2102592a12.6.1761629641674; Mon, 27 Oct 2025
 22:34:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Oct 2025 22:33:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg_FZnLha9Qr2sMQPXa1go4FPq2p5d7CnMoOnCimS2Wzg@mail.gmail.com>
X-Gm-Features: AWmQ_bkfyF7pn4e6fUY7bNVBhf2DrgjCvQYqt5ZlzergSjGB0BKOD2LLrniXl7E
Message-ID: <CAHk-=wg_FZnLha9Qr2sMQPXa1go4FPq2p5d7CnMoOnCimS2Wzg@mail.gmail.com>
Subject: Re: [PATCH v2 00/50] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org, 
	linux-usb@vger.kernel.org, paul@paul-moore.com, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com, 
	selinux@vger.kernel.org, borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Oct 2025 at 17:48, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Things get simpler if we introduce a new dentry flag (DCACHE_PERSISTENT)
> marking those "leaked" dentries.  Having it set claims responsibility
> for +1 in refcount.
>
> The end result this series is aiming for: [...]

The series looks sane to me. Nothing made me really react negatively.
But that's just from reading the patches: I didn't apply them or -
shudder - test any of them.

            Linus
