Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60613139D1E
	for <ocfs2-devel@lists.linux.dev>; Sun,  3 Nov 2024 17:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730656230; cv=none; b=ca9bILe3mRZxkWxwAv1O7HwzRU0I7vOY87tlBSN7kjZFeR1tLSbs+Y/pg+HuB+wJRD+ZFsKIUXaArfmRrOeR3Lp9NYPaY2PdH8pzAdqzoWSkvZ+g2Ja2NCy8UvmJjDN35y6Swq5ysNWeb0oK/6XK+6zXU0yOdAI2hMvv5Js1Cyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730656230; c=relaxed/simple;
	bh=rV8Dw31hL8PJUzAzId38ufghwsRz51LOwUvKyOAp6xA=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I6Hz1USS6xd8lMN5dKeGlp5baZJendzkuxvbkVjFTWAUMqD8+gGH/3huIgCwcPsyslb8tN1pTn21mpshKW2e49DvfZEnRLBU0CppONRuuPGQ6b84kz892bcqujsKW2aKjxOl1P63C6KYrkz7JtBQoZazRzWUss6W07EdCh1ae4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AgLTtCy2; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgLTtCy2"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a99f646ff1bso449085666b.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 03 Nov 2024 09:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730656226; x=1731261026; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Ltbmxni4Ig6VIv7g8rtjq19v+cbmckPc/oW9ZpyR8L0=;
        b=AgLTtCy2xfVLJlGqmKUNuTadDc+8YyDYOh0OZACCvjZ3SFyhqPKVAwBGFMUocEhnp9
         9pZhUuZmtSp28ZQP2JRqCzqb9CvESmOuNl5fgefdMiClOXTJUMD07vcMEIvvlN36Sudz
         oDPKLgBimIxnlG4MrmThWGcBGOTLoAuy+gvje8tkml1D/Y1V8O1DeQPuhJViMzA04FcF
         mKa+JHpQYYhRx2KnIuCSc7t+u2zY55ybge+7hZEHR3wRNLIojhuOOph7zpHpR04/2GMr
         tpvzb0QBgzWobpbuzA+5zpFssRFkfI3wiqF1Bzh0fMjkis4fBa0cVPbwzE0PsKzVI6Jc
         pRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730656226; x=1731261026;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ltbmxni4Ig6VIv7g8rtjq19v+cbmckPc/oW9ZpyR8L0=;
        b=fv1ZL+5LiNI3540JAGa4a4W8uesHhGAN6+q6iKGbJn58484OdP6A/SAZ8BlujkzOAI
         e4b+YbFhblwmPxz3j9liPcPJeNgudrZU+k54E1ChVtn6vDLwhsgyeT9GdlF2pS8Yr4/a
         uFgQj3tpchg81q2YeZGP0rAbYYoVUVxPo6fIggcoCNkSZnmubtzvjWOcdplPPhniNPjq
         sR7SDJypvXdtXACbJbsjN3qs2xDrDPs7bbrc0pQo/jDlOOon8QjXHQqA4V28n/z/WG6M
         yEfGGwwqRw90W7BKSks1169isKbVp1dnaAtfMtS6AN+3ivMHQesaZ9YfryzBTV8PCMAR
         qwoA==
X-Forwarded-Encrypted: i=1; AJvYcCWl5Y3bCSaKSqIaSg9Ce+0KrbGsllRmNevlQ7xAI/RvqPUQ6U/eLtQMk1OpICS1tYKbJOc3sEzaeijtgQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxwm/9b62zjqn1f2v6R6T9TCCduVTe7TN52v8xxOI284pWDITjq
	iddlRRxjDvPU5FUWkxhzLJSiwLPowUzzsxlMPEjmNt/eXJWIeI/m
X-Google-Smtp-Source: AGHT+IENCImvfO2QCr1lf+/YLNCq2Ar5y9VgTYTz+UawvMnJepxeEvYadyyXZrISn1tbPDhGiTomxw==
X-Received: by 2002:a17:906:c10e:b0:a99:f183:ea8a with SMTP id a640c23a62f3a-a9e3a61d7cfmr1748975066b.28.1730656225357;
        Sun, 03 Nov 2024 09:50:25 -0800 (PST)
Received: from akanner-flex. ([79.140.148.216])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e565ea53dsm446538666b.114.2024.11.03.09.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 09:50:24 -0800 (PST)
Message-ID: <6727b7e0.170a0220.294c3c.d58a@mx.google.com>
X-Google-Original-Message-ID: <Zye34hCwhRI9vwu/@akanner-flex.>
Date: Sun, 3 Nov 2024 18:50:26 +0100
From: Andrew Kanner <andrew.kanner@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: remove entry once instead of null-ptr-dereference
 in ocfs2_xa_remove()
References: <20241029224304.2169092-2-andrew.kanner@gmail.com>
 <cfd351ed-01d5-42e6-a764-2d915bd3adeb@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd351ed-01d5-42e6-a764-2d915bd3adeb@linux.alibaba.com>

On Fri, Nov 01, 2024 at 08:53:18PM +0800, Joseph Qi wrote:
> [...]
> > --- a/fs/ocfs2/xattr.c
> > +++ b/fs/ocfs2/xattr.c
> > @@ -2036,7 +2036,7 @@ static int ocfs2_xa_remove(struct ocfs2_xa_loc *loc,
> >  				rc = 0;
> >  			ocfs2_xa_cleanup_value_truncate(loc, "removing",
> >  							orig_clusters);
> > -			if (rc)
> > +			if (rc == 0)
> 
> Seems in this case, we have to ignore rc and directly goto out?
> 
> Thanks,
> Joseph

It looks so. After ocfs2_xa_value_truncate(loc, 0, ctxt) we might have
ocfs2_xa_value_clusters(loc) <= orig_clusters.

But we already do everything we should for '<' case in the following
ocfs2_xa_cleanup_value_truncate(). And probably should just return
error code for '=' case.

I'll send v2 with your suggestion. Thanks.

-- 
Andrew Kanner
