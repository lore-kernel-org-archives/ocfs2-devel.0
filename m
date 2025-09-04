Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B6E15B971
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Sep 2025 00:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756947565; cv=none; b=eJTceAA/7/4BeqwH2E0+e2/2v4iLFa86qW2NHL7wqWXKdsxjKR4fqU7y+cXLxsTgs8oVBEN4Tth7DunG+S/gRtvPgiGJH56gF7R1/RtqwyR4bTpRDDi0HJPMz8ioWtJBOhCxRij7l2S9BRkuise7mmDfs/UvEeWThdQig+wo+Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756947565; c=relaxed/simple;
	bh=LqKOMnMZAfpiXuUjaiCFZ7Qqbi1FvIZfeGAONez52aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGCEdKa4Cc1ooEbRxutjcvvoYnOtpqIwik7PWbLH5BuDEeUC1HLRCbaC2OwSo4FHMibQiLtBzZQ9d6yHv6IWBxJU2EufDeKazqBhAbbWGVzml00GBWk2wY8yjs2BFoa59sp8af3tajzBNur01rB0tnGPW7J0RRyjOAnQfRAKS+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=oDT5V4pP; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="oDT5V4pP"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-77250e45d36so457026b3a.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 03 Sep 2025 17:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1756947563; x=1757552363; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u3GvwTlIRqRrcE9RSws1yhkNXcT0Fb86bqICqyCnRiE=;
        b=oDT5V4pPczOBEG0W8EGH+mTnugBgqJKs5GWXIZkgiREpGklgV4w7Jg9uL2NTD4wepy
         XEvhhf+ks3rBQD2gzcmqSDj2lqtmWjP7iiKa8iS2FIwitXehw/oBUI64tIFe7XzDIhnB
         WHowz7+ILFiQmVeDZ6msPYuoc53DJNMDTVVCmaAZjYrTQ0bRxTSNmh2h2kkIKknCZFzt
         L5eCUc8/vWrhtSeOEqAmWr/3SLfQS0+zmipuUN9iz/GPtxukHFLBtbDLh57ucovpPvdC
         L0okuOFxNJgNvSP7B1f6+ETJExNMK3waUxhRMLTb6frZ6zKvwjGOT3eW5gbLTM7YFIAU
         kbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756947563; x=1757552363;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3GvwTlIRqRrcE9RSws1yhkNXcT0Fb86bqICqyCnRiE=;
        b=u4bxjIWYsDPfqv0ZafCbQ8fEVgKqdWyHtH/mc12uobN7FMemn3H/AkY6hdiLN3aRul
         XDUlsK+iEZofm0IDyTH9gVPW8rG7chno0wisiXTpuQM6wrvUqQgt586KO3J2aStu17nv
         Ahs2nTSe7YartG5EZajybWXz12RcZAz6jJHC94whKdvOHldH/qtxS6k3D8pqr6izSArH
         m7tFizXooY+vBh04Psr98Va/cRaszLikskt8nKuQ73VIfJW58ivwx3Ha+GpSHC2c8Qsm
         psWvn7L3XAe0xlK1UarUX6MKodm1rvvkKnjmn9m8NCH3Ig/5q/ZMrIewnXDrPTMcJbcL
         vXcA==
X-Forwarded-Encrypted: i=1; AJvYcCWlUJkVfbBvYMbSbswYHtS9OUq6XlJ4qLfOWOWrg3pu+d+kZ9vkISReQsXQi8qGhtWqCmWm87j02dNfxQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt14vlMhhOUSs/04x2Z3xCcdDEcqLmVGv82tvLhIx0HPUHF3Si
	HafOwTuh1hisLUDesT/ISjSl7vUdRcs/y/MsaaMZzRdhVb3M8Bn4qe5jLaFPAvTyOLc=
X-Gm-Gg: ASbGncuT0gCOAK8bRlQV6t5d7kuQ1mIoYScJuqgDnSQd/UAznPQspOy1FSx0mDYW7gw
	9/XZQR4iYNB0gkwP3o7gwWr9krjxyrvIfL7Q82lfMmV3nEgQuOikB6kEn7bV7ya9kJi3Px4sTrm
	DsUGvo/HNbOBd7FmHI1YLQBOzhXiJ5PVD/bcwT1QtQlNmQAlCWRO66Kvtz49i8O7g8MjbZ6sXZz
	9OEdFYv2mUTRyN1xsZGB484srERniGc6k2o8Uj6EbgS3P1FxOC3RTZDIINHoLEmiN+ySEGDxbW5
	wV1CTvCR8+Sttzm9puykrRmCy5aOqea7MDzk/BhNbwgweYPDzJE7WaVXOQ21IxNCkj24+4FTZoY
	WR8AizpOG3k7/uutkiaeddm4FtMetX2EHwwxaSEK8brSk5zTUw56x3Q5uPrgP9u2/nqZ6ZruXdg
	==
X-Google-Smtp-Source: AGHT+IGWjhGVrffakImftX7HMuN5xDgaTX10BZo8PPjxryX85jRas4ic+0AC/oRXJ5/9Oo+xit05qg==
X-Received: by 2002:a05:6a20:72a2:b0:243:9ae7:f891 with SMTP id adf61e73a8af0-243d6f4244bmr24090032637.40.1756947563279;
        Wed, 03 Sep 2025 17:59:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-772590e0519sm10288997b3a.84.2025.09.03.17.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:59:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1utyJr-0000000Ex5Q-381y;
	Thu, 04 Sep 2025 10:59:19 +1000
Date: Thu, 4 Sep 2025 10:59:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, ocfs2-devel@lists.linux.dev,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [External] : Re: [WIP RFC PATCH] fs: retire I_WILL_FREE
Message-ID: <aLjkZ1P7vOcfsGvW@dread.disaster.area>
References: <20250902145428.456510-1-mjguzik@gmail.com>
 <aLe5tIMaTOPEUaWe@casper.infradead.org>
 <d40d8e00-cafb-4b0d-9d5e-f30a05255e5f@oracle.com>
 <CAGudoHE4QqJ-m1puk_vk4mdpMHDiV1gpihE7X8SE=bvbwQyjKg@mail.gmail.com>
 <CAGudoHFKmXJGRPedZ9Fq6jnfbiHzSwezd3Lr0uCbP7izs4dhGw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHFKmXJGRPedZ9Fq6jnfbiHzSwezd3Lr0uCbP7izs4dhGw@mail.gmail.com>

On Wed, Sep 03, 2025 at 05:19:04PM +0200, Mateusz Guzik wrote:
> On Wed, Sep 3, 2025 at 5:16 PM Mateusz Guzik <mjguzik@gmail.com> wrote:
> > On Wed, Sep 3, 2025 at 4:03 PM Mark Tinguely <mark.tinguely@oracle.com> wrote:
> > For now that would indeed work in the sense of providing the expected
> > behavior, but there is the obvious mismatch of the filesystem claiming
> > the inode should not be dropped (by returning 0) and but using a side
> > indicator to drop it anyway. This looks like a split-brain scenario
> > and sooner or later someone is going to complain about it when they do
> > other work in iput_final(). If I was maintaining the layer I would
> > reject the idea, but if the actual gatekeepers are fine with it...
> >
> > The absolute best thing to do long run is to move the i/o in
> > ->evict_inode, but someone familiar with the APIs here would do the
> > needful(tm) and that's not me.
> 
> I mean the best thing to do in the long run is to move the the write
> to ->evict_inode, but I don't know how to do it and don't have any
> means to test ocfs2 anyway. Hopefully the ocfs2 folk will be willing
> to sort this out?

gfs2 calls write_inode_now() from ->evict_inode, so it is definitely
possible to do this.

However, given that ocfs2 is largely a legacy filesystem these days,
I suspect that you are going to have to do this conversion yourself
if you want this approach to progress in a timely manner. :/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
