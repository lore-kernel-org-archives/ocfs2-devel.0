Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B5C26ED59
	for <ocfs2-devel@lists.linux.dev>; Mon, 13 Jul 2026 22:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783982417; cv=none; b=GaPbavtge4M2Rrwp5p4s0YmuZKi5T1YHlm1RelFS7AE3BL+nAVhiuV1t2Ilcbo0xPi/EFMHkglghPXZxg0PSBkK/+vXOJaNeimX0YeD1oOXh7VK51KcHRXhGHDc9MLtB1G6fDhtUHjW+0B7TpBhLj2PIOUUi77v4EszwTGkkfIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783982417; c=relaxed/simple;
	bh=Ox6BVqo9uQAHzFJ89Dkk5sMUjCTGHUh4RcAozmVDRhU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EUaLSb8k9FpYczyVYNT4Qw+qb9Hwf+inwrYB445Q7RVFKGlugQe3FKmc07ZkCRqnLEnNW9Wjr7KDto3ObEcfh+r0MXrhdIi6Xi0qkddCa4pcUXxU2zAbkbqxx3pAn8kTRzeufSJjfSmE7fDAzvGgE5J2r46hP6dTESkjsZz6+a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=PI9pLejr; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="PI9pLejr"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4a416619cb2so271906b6e.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 13 Jul 2026 15:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1783982415; x=1784587215; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ox6BVqo9uQAHzFJ89Dkk5sMUjCTGHUh4RcAozmVDRhU=;
        b=PI9pLejrjjrcvD9n7J5oVe3HC+7DTZlC6LeZBOAod9sIzXGYGeSvjR59ICdsxJAGOZ
         ANllE5OP+jJh6bHhKX41ZJxg52p0TgULwCI8CvGLlsh/d6EyDMunWDxzif0Xf4OhfGPK
         5KDbQs/My41emKZonoFEzZ/Xhe/vZxOsLNv6+r6vMn/xcyOXozJHS4cpMXme2Ch+M+g2
         dnpRG1P1rbJj4Ze/cqeDuC1EVmuCvXBRabNLbdtYJejAgPR9ObAHi217YqpJ6saFcjKa
         pqs8Lc62y4BOPVcdHOb4RaPJdA8QsMmrxDOGgEimMM+d/LXsT6ER8xJuW4w14VDOpj0m
         enXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783982415; x=1784587215;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ox6BVqo9uQAHzFJ89Dkk5sMUjCTGHUh4RcAozmVDRhU=;
        b=KYpQ79OHxMiqawRJL8RKffMZ9iYzGwm5dIQrN+D8ZiFhFZpTButIQZbrAf7fV3YjGe
         OEImGp9Ys8Yze1zewkA2cfD57OshwhwpjXlTovTZDhEuHtKVpt3MVUh/20cLWcgQfiah
         d7/PR0YOe2ZuS2Z2veBD+96lmEkUhvyLJ1p3VQWalqzVu/7OOlhqtOAxZ8hZL6nZPtMO
         o9NRfDfHaBG5yGU+dgOG1QVJ9LmP06XuMkEMgDu1vVJA9HUvpWiJD+dXkJgkxKjQAJ9Q
         ZIGmw2kkYKxVPDBReh7W2WWNP3452xmYn5BmZ5C1AF7hGRSlaDP1ARSEudvigsDCM3xi
         JJww==
X-Forwarded-Encrypted: i=1; AFNElJ9dYO2+pXC0vbHwg4lFEE82XpYON9lZsWQymYbPRzT922bfCYquEjf/T0LATRIHqBkhWnr+lkRywthrVQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyIh/V29Thapn47TSd1EXv1VOh6/ECELEYO88U5znv4HCUhT09Y
	ch0LsmRIWEpZo0vFjZEqzWhZoVSirufaRVbvCYuQZxc/oOkZg9MEavz7dVnE0PrlD2AlwV/zre/
	OUgP7APFi1Q==
X-Gm-Gg: AfdE7ckJ0VSjifVzmvATJiy3cY6IATOK3VGkllFvxNe080bxcNOnih7PaaizdJhOUxq
	/E0Xd83Z4pVLous1PYWz9J79Tv1evTIXmqegUzuN+IESdJBdmlt1w0DT4nXXLis4Rxj9rWJ/vjb
	VPmgvr53DTtdPpJs553MWGRtaaAKhRLWg35Pf2XOstMjtkoGZh4kmRYu7c2cRdP91zgclKqDlGe
	JYORYWi7BlqhNrTIsS8sVubyu9BMOtmiLzgC9fpezg6E7UrKTqNFfHCF1auGMJlrYTk0opHE8Ud
	es5itmiI71nEIIQKLsLMqwd/Cbhqon/mLbTcJ5OYVAvR4157tOAqavAhY7tNYogQHcxzvPhE3C3
	a0U7r+SL3oPWo/wkuN58ymD5KBw9O/3aPLctRxf64lOIdkpRFcmEeox7JTeCyDJWmaU3DDUWnlp
	pycMfiVPJCEV9fu1vwcscAb3SJM8+VIF89nU/tB9Ex3l1Mj5Gdr6vag6ZTBwKotgPM6ncjIJHpe
	rr9R3miivh6KSWrrSiDEqftsLh5y5d52fy/ayg/C2C1iA==
X-Received: by 2002:a05:690e:169b:b0:668:159:32d5 with SMTP id 956f58d0204a3-6680159343bmr1421801d50.87.1783982011683;
        Mon, 13 Jul 2026 15:33:31 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:e472:ff2d:20b0:742d])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-667877aaadesm14714239d50.7.2026.07.13.15.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 15:33:31 -0700 (PDT)
Message-ID: <af41e2dd178bbc4068317f1b9e09401cb49e7228.camel@dubeyko.com>
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
Date: Mon, 13 Jul 2026 15:33:29 -0700
In-Reply-To: <20260713095857.GB10501@lst.de>
References: <20260710050744.GA6720@lst.de>
	 <fea4c4f25afb7711d1e8fbe6ca5ab654ec522186.camel@dubeyko.com>
	 <20260713095857.GB10501@lst.de>
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

On Mon, 2026-07-13 at 11:58 +0200, Christoph Hellwig wrote:
> On Fri, Jul 10, 2026 at 09:51:09AM -0700, Viacheslav Dubeyko wrote:
> > On Fri, 2026-07-10 at 07:07 +0200, Christoph Hellwig wrote:
> > > Hi all,
> > >=20
> > > we have 7 users of blockdev_direct_IO and one of the lower-level
> > > __blockdev_direct_IO left, and I'd really like to get rid of
> > > them.
> > >=20
> > > The filesystems are affs, fat, hfs, hfsplus, jfs, nilfs2, udf and
> > > ocfs2,
> > > and you are the relevant maintainers.=C2=A0 In 7.2 exfat converted
> > > entirely
> > > to iomap, which would be a really good example for a "simple"
> > > file
> > > system.=C2=A0 Another options especially for the file systems
> > > supporting
> > > foreign formats would be to just drop direct I/O support and
> > > reduce
> > > the support burden.
> >=20
> > I like the idea. I think we can try to switch HFS/HFS+ and NILFS2
> > on
> > iomap approach. Do you have some initial patches for this? Which
> > particular commit(s) converted the exfat to iomap? It will be good
> > to
> > take a deeper look into this conversion to estimate the complexity
> > of
> > HFS/HFS+, NILFS2 modifications.
>=20
> Almost all commits in fs/exfat/ in 7.2-rc1, starting with
> 623f0aa1eca5c2a94ca1e4e5de719d062eac3b6c

OK. Thanks for sharing this. :) Let me take a look and spend some time
on this. I should have a time for checking commits during this week. I
hope so. :)

Thanks,
Slava.
