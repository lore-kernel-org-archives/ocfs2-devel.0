Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D1620ED
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Jul 2026 00:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784160536; cv=none; b=QvtT/efLqxcHYv41pVhkgul4XJq1XqX/4+66bpx/CF6Ggu2V+x+WVcgeKl3peBgmjUkkEVGo4BjzcpRwI37uf1urlR+ulwNuZQvY2XZLcv2fnswBna1HvLjMCBZp4QGehqGZMXxHfU/GLMhjEXg7ZWkuBMAqvdd0VMIUqgFg6tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784160536; c=relaxed/simple;
	bh=edm+o1poLBaX+Zgd7MELrnQcglifvh/n77uGGSvqid0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ETcSnkdTESyakDwcnBaVlprphcFUpxqTlz1avMt60co0MgRUbRLVp1uyC1/l2PY7b/eyDrGehWGnRm0SZMZCLTTOHGjhTpZroV6AMgRe3O4z950ILi5ccVhaWdwYBvmRfLNMaPGLoHL6g3kqA3Hv694Q2Ll2Y8+SyNoCiAFgbl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=DB3sINc1; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="DB3sINc1"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-80c5cb9a888so53960677b3.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 15 Jul 2026 17:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1784160534; x=1784765334; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=edm+o1poLBaX+Zgd7MELrnQcglifvh/n77uGGSvqid0=;
        b=DB3sINc1pC0X3148bq4ZLesOd9XDsXAe27nDBbWYGpfY3AVd7nTu58mv4D5cZc58OU
         e3qKMenNcbm17W4jBItaWrrhKgm4s486/L8QeFb9sJNKWdjZKbT7aOmmEBxBx3ldmeKL
         PxPqBvfDUDM+ezdlYrbmg23d0yHCdVJoEuRm9z8T5//CfRYNg6qrFbFJfjMFA7Tt8Evb
         YgN0Pd3rmnPk1aTZ6OVHHsoOs3eGC/3vRvO0uYxmPMnsPQW9Pjl9EtacvE/6A90RvwA+
         Gq93HGUFaA2aPWHrvk+qSBwPr+EJCDlOKjaozdiRHh9h9+92Qa5g02II567kCrIEvnTV
         Wifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784160534; x=1784765334;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=edm+o1poLBaX+Zgd7MELrnQcglifvh/n77uGGSvqid0=;
        b=XzTEmKxMv4ED/ti8l3/z17rEl9UwHChWULFXfEGWgjDbT3qeuQ1X3E9Yaxcx7pa/3b
         LUpXNEq6Y31jwPBSZI55FPFaGDSX7FWyUIHXHyQDHPwKmWZl2JCb0DuLaaaxFg6X9kmp
         R6QNJZ2KPICcIdG+Fuw5rH29WGTrmEqrUMmVZEBC+5IxvVip8p3yEH8LopQry59Xt8tA
         VEyeCJJ6xqKXErgZln+rEe0m/FTWVfnI/YkOrSp3bq3fovE5TQpHbBWaMLJuy725sUaN
         fNlVCvsM/bXf9oIfoLhTIhdNmW/jvVLB4elhp+OozMopl5bErDkZ6UZc2QbhNJaj4N10
         M6Bw==
X-Forwarded-Encrypted: i=1; AHgh+Ro4uWDGA1cIEUkXkBo0JL2cxkI75hqQ0MoJ23Vh+mISvYvIdc3FnyXWNTEpqAnBUYAeukrio8E09xGizw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0imzQ5yOloG23LgK9dGOEn02ZeXTiGYbMgYXjjEOnbBZkfLBW
	evCW7nKCB0SfnWH0baUfnEI9WiGZLPty3qVyd9r3AB/WZmcs+QyT8Ov4E+tf6MNjSaw=
X-Gm-Gg: AfdE7ck1c372NOgdvS7+qbYc+YahVR2PoFbw9kT1MVChm7XifaKUDua21zPY3/1+As2
	4XeqkDPJwLQ2ZCrXIhKWQzMUX4apR3unJQLyrgY/e7/RS3bMk39w+uEKZCFsAmMQqlUSXOUtdBg
	XbFSH/D/Zfp4SqiZbB28rHFbYh0OZ1LofziCug2HxrqluufJYn8C0qi2nc0LsskWoDJ1zYivRvO
	uvaOxs6eHcpfqV2jkb2iSMT5j2BpOc98rX/0tBX9r0nzBtJPH+nxDP/9OaIsAqmoQFn3cKTIRiD
	riHjqxxBrl0Q9SCKiH5s14zscDJpWucqAuuIQXE+SKrw1jn15ymgrJQ0HdIMFQUDfp8jP4OnGpx
	xRWlNihMpR0hmRIH0knBEUuDM6ToO+WibXyiPp7rX0Cf7W4FPbSwS2xuHuW9cWtLw6bgN3oZzu2
	JGVWRZEU0TcbMZhrVJlp6UCkhaQR546byopYYI0+x0rTG+hB9T/9hoOiVdR+jDlpLPVnM5R/Dq8
	GGli+YOdRRNmNCLsdfG3ji0ASDoEt7AY9+KQyKAl2fZHgJ5kjnbMbln2vEFOlNumWLxFxM=
X-Received: by 2002:a05:690c:4d0a:b0:80c:85b6:75bd with SMTP id 00721157ae682-81ec00d806fmr58924687b3.70.1784160534106;
        Wed, 15 Jul 2026 17:08:54 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:3081:a422:f6f3:c07c? ([2600:1700:6476:1430:3081:a422:f6f3:c07c])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6c201dc7sm182018617b3.41.2026.07.15.17.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 17:08:53 -0700 (PDT)
Message-ID: <1421ca7e131663e594806f43cdad34f3282bd915.camel@dubeyko.com>
Subject: Re: removing the remaining blockdev_direct_IO users
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Christoph Hellwig <hch@lst.de>
Cc: David Sterba <dsterba@suse.com>, OGAWA Hirofumi	
 <hirofumi@mail.parknet.co.jp>, John Paul Adrian Glaubitz	
 <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, Dave
 Kleikamp	 <shaggy@kernel.org>, Jan Kara <jack@suse.com>, Mark Fasheh
 <mark@fasheh.com>,  Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Christian Brauner	 <brauner@kernel.org>,
 linux-fsdevel@vger.kernel.org, 	jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, 	ocfs2-devel@lists.linux.dev
Date: Wed, 15 Jul 2026 17:08:49 -0700
In-Reply-To: <af41e2dd178bbc4068317f1b9e09401cb49e7228.camel@dubeyko.com>
References: <20260710050744.GA6720@lst.de>
		 <fea4c4f25afb7711d1e8fbe6ca5ab654ec522186.camel@dubeyko.com>
		 <20260713095857.GB10501@lst.de>
	 <af41e2dd178bbc4068317f1b9e09401cb49e7228.camel@dubeyko.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hi Christoph,

On Mon, 2026-07-13 at 15:33 -0700, Viacheslav Dubeyko wrote:
> On Mon, 2026-07-13 at 11:58 +0200, Christoph Hellwig wrote:
> > On Fri, Jul 10, 2026 at 09:51:09AM -0700, Viacheslav Dubeyko wrote:
> > > On Fri, 2026-07-10 at 07:07 +0200, Christoph Hellwig wrote:
> > > > Hi all,
> > > >=20
> > > > we have 7 users of blockdev_direct_IO and one of the lower-
> > > > level
> > > > __blockdev_direct_IO left, and I'd really like to get rid of
> > > > them.
> > > >=20
> > > > The filesystems are affs, fat, hfs, hfsplus, jfs, nilfs2, udf
> > > > and
> > > > ocfs2,
> > > > and you are the relevant maintainers.=C2=A0 In 7.2 exfat converted
> > > > entirely
> > > > to iomap, which would be a really good example for a "simple"
> > > > file
> > > > system.=C2=A0 Another options especially for the file systems
> > > > supporting
> > > > foreign formats would be to just drop direct I/O support and
> > > > reduce
> > > > the support burden.
> > >=20
> > > I like the idea. I think we can try to switch HFS/HFS+ and NILFS2
> > > on
> > > iomap approach. Do you have some initial patches for this? Which
> > > particular commit(s) converted the exfat to iomap? It will be
> > > good
> > > to
> > > take a deeper look into this conversion to estimate the
> > > complexity
> > > of
> > > HFS/HFS+, NILFS2 modifications.
> >=20
> > Almost all commits in fs/exfat/ in 7.2-rc1, starting with
> > 623f0aa1eca5c2a94ca1e4e5de719d062eac3b6c
>=20
> OK. Thanks for sharing this. :) Let me take a look and spend some
> time
> on this. I should have a time for checking commits during this week.
> I
> hope so. :)
>=20

I have a very initial state of patchset for HFS+ file system. I am
testing it by xfstests now. As far as I can see, currently, this
patchset introduced multiple xfstests failures. If you like I can share
this patchset for discussion and review. Otherwise, let me fix the
found xfstests failures at first and, then, I'll share the patchset for
the review.

Thanks,
Slava.
