Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1CA1DF736
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 03:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761883155; cv=none; b=HWQcZyRUf+Hi1SK+jZeLEkYEsFJxOyDa9kLY2AOKontv7rPEw08k0ko2Qns5RkpJIUI1p3nGCL5FH/rhgUBkr52PWytpHS1fXdHIVFSCTvo7vUsI6S/3OdUgp1hPuOZmvFD3BQgmAkrw/DN8ueJe5NUQ+wkNYW7StPIf4kuerm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761883155; c=relaxed/simple;
	bh=K463F0WgtQayvGVKq8pk4vbCuftR3MqSiQYta790Raw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/N7bC7eGW1A9q+WLgLzi86V9JJxZBoPNSpQR9qH/cWOZFpyCT0ofoTNJM2MRqP2h1n/Fw5OObCjSjK+1E1E9hIbVGHDJR61il3rHzU7E4oFP5k9uVEb65ABTyFh8OMFAG/hphM94KD+hJjcIchiGrpUz7rh/FJeJHomwwiszGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ANddp6fn; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ANddp6fn"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-940dbb1e343so119770939f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 20:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761883151; x=1762487951; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CVzgaw4KSyg5cjdxONzSMPRVaLN7EB7muCaP1M+QOZ4=;
        b=ANddp6fn6Nq90s6/xAITH/zYHCnV2FCqPnjtxK92cPpFCaqo1uESf/T4dBh0Hhla5i
         Ih+fxSiQBLA2R/pwPRYouv/qznaFniGQN2eCnqnEZ7PJP2BeNXHRCJ5c/Qp/Ojb4tPzb
         FM3Tvggh+B9pfJfZuAz+TlO09ldViIXc5TFN4dvn/nL+XWLJ5klrURtimmPSRBtwkH04
         mCG13Ox3P3FRE91Z9eaDwGJ2ep8wjQpjc7y0rDaRlBGl7vrFJ10g9ll7/QsVsQq6zQCA
         3wQfabX43IYHvrR6RSYGoFvG1LePTIRN7X5KpsgpTS7DUhN0r+Sgzdz2+uUUIEcLeyAn
         Ujzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761883151; x=1762487951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CVzgaw4KSyg5cjdxONzSMPRVaLN7EB7muCaP1M+QOZ4=;
        b=W+aPK8zR6XFnxcWJCppHM97Xn7mNDhy1Van1R0Bfu5KJJYwf2SiarU9z5MQg6MBT2o
         upsODHgjX9qArohL7K3+uSI9kx4Lr+4ejDFOTQ9L6M0N1oBW/aukq2cQhrdV7RK+KCuh
         8vl3/7sg/L+Ha9h2/1aNI2sVLHVOI7c3frGYU8vHL0l/Y+/4BAVfhSRpiz0gWTL3z+/H
         BenGOHMzxf7GYiXwJ1kVfgtQL4V+zY54sh98JMsQiYS0DTjXdy+LkgXs7g2DTXQ6YU8K
         mfpZ61H0RKVkWhSxiwZCeHXZE4+oHjA04xSAp+m0cNdiRwZycEhFJguek3Eeo3b7P+gY
         haFA==
X-Forwarded-Encrypted: i=1; AJvYcCXYHruWLLuotZMiT797vv93ahxr0LrhEUMVTyi0XsS2Nwcw4GIFobdoSKz+ogW+zR0lcFCSDPLQdUdbZg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzH0vy+UezxbXrOBxzGkiJ3DUnF1KleWYf5n0MeG8Q/2mekQhAM
	OHfGj9STXIDE/QexuyyzqtcMg4lCVom1k1QNj1IypHgRyWcOsADDzecx
X-Gm-Gg: ASbGnct3MG098gRXeyRAQVZAXkVQw4jQOkk2Tyus8SzRNfq1o05HqFp5s33gkXjZTGh
	ZP3wYCJKPFobtr7nzXocESJrW8iX//WcehHbR6RHtCYkPN8/cuUedywNc3xs47geAzcS8FUjt5Q
	c7ijm/Up8O0IAZrm/VXOSAQWR3c6vg922UUd5iXtnC+TBN2WpMjr3u70qFeI5ZW2XziXmWAA75u
	cvjsQfzt6Q/UAEmZoHwgE6AXvLw66hrCgudTgcMHsSpbxi5mWA9tsxVAANJwL7F6ak+dQMpB3VY
	OY4699fIP2v59NO7lKjDr54IaBeayjI+q9MDRTA5sMBRJnAz/6TUkBtV3AmBAgFJWzzixC/qaar
	WaG0jRF1DoVzElZS3jgL2LuEgrssIq+ZFMGi6QucB41kiwM+QEJzoQR+CHwhF5zv7QSFg0h4=
X-Google-Smtp-Source: AGHT+IG4begvpcbVwzfsZabnnFSMeIq+HmErPXe/nObkhvCU/XUbrqj72iI4aGEGSEYIIOWKCkdzuA==
X-Received: by 2002:a05:6e02:1aab:b0:42f:a4d7:ebac with SMTP id e9e14a558f8ab-4330bd94293mr37773685ab.4.1761883151459;
        Thu, 30 Oct 2025 20:59:11 -0700 (PDT)
Received: from arch-box ([2607:fea8:54de:2200::c98d])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43310322c59sm2341965ab.20.2025.10.30.20.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 20:59:10 -0700 (PDT)
Date: Thu, 30 Oct 2025 23:59:08 -0400
From: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
	syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
Subject: Re: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure
 during read
Message-ID: <aQQ0DLqL0iVN7D15@arch-box>
References: <20251029225748.11361-2-eraykrdg1@gmail.com>
 <wzykonhpj76qowdn24inwtaji4zfclesmc3lqnnc7cn6jkyjl4@oauagnarupov>
 <CAHxJ8O_7-PfJRyGp9-1KOkwmYJWQDzCvvo_P-jxzbzHoqXyH9Q@mail.gmail.com>
 <qfizhbe5rwzddwnoekr6xjy3gozbqbtl64c5xmfeuudxvficmv@onazesxv4ur6>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qfizhbe5rwzddwnoekr6xjy3gozbqbtl64c5xmfeuudxvficmv@onazesxv4ur6>

Hi Heming, Thanks for the feedback.

> > I had one question about your proposal to combine this patch with
> > Albin's [1]. When you mentioned, "We should forbid any write
> > operations," were you referring to Albin's read-only check in
> > ocfs2_setattr as the mechanism to "forbid" the operation? Or
> > were you suggesting we should use the inode size sanity check
> > itself (e.g., by converting the BUG_ON to an -EIO return)
> > as that mechanism?
> > 
> 
> The 'forbid' refers to the read-only check in ocfs2_setattr.
> We can refer to ext4_setattr(), which calls ext4_emergency_state()
> to forbid write operations.

I just looked at the ext4 implementation you mentioned. When we were working on
it, I actually referenced how XFS's setattr was handling this because I
couldn't find the exact ext4 implementation for this at the time, so I wasn't
sure. From what I understand now, ext4 is doing something similar too.

If everything looks good, we can combine these two patches and send them as a
patch series.

Best,
	Albin
