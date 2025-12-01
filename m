Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A072B2DA
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 02:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764555427; cv=none; b=QmLXS+RsnhLQbesGbF2jaNGXFihfRWagCVI5hKt8XU3gjImbBqy43Z1i3NdkqWalIK1Q7tyypoEOBrnZuVC6zifYuHuGWwvusC60MDjtY8FU6kFSvyGaJt6x0UZsNj+rrbp+myub8b4ZZji+gYTeUhBwAFl2eJjb6ahCTK8qKQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764555427; c=relaxed/simple;
	bh=ovm1f3eblzsM09i5jSf6X2p/gxrvxFc8fIImEMwroU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GkSU4ksVl3sT/zYAMJfZPaqq+E6bN1qY7s/iCByJJL2WiV9ItULHULePTfUy+pwS+mjAkweFdhVj5E/1KFrQIEacKumV6cvRVNhvNf6AYmyR0MZqWapnjvsfusK9oQMtkbQGbexit7DXMDilq9u3mX7ycL95Q0Y0MBrM+hnyKs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OzZhbLmr; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OzZhbLmr"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429c5e0f94eso412567f8f.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Nov 2025 18:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764555424; x=1765160224; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iWIs/YDA1nzzX4jOEgpbV5QmPVgD/b4meZuDSCuGs4s=;
        b=OzZhbLmrgYeGpyxuXrpunVwXPSFTBH312duLqWgCttnfbG3kNbBbxxeSKl9kZ9GKO6
         ARzB4NKHjOX9eXW6roN7MCp4w/oFRfrtCgxzKXV103/nTs/PxGZfs6IiP5NjSD/ab14T
         RQ3wBObZXOjOMqG7VEM96gwEiEHQQw2S68WZGgh+UjZ8w6iA2oZaqFvLvXboJ+2Jt37O
         D6cgSlM7AjjLLdmZb7U9rf/53Pt3msu8r9w9ILxmZyo+eyL0XmteMTt2Gj3/q7+bAKbv
         0hP59xtUP1Vl9ZMX1mZV4mt9vetuk8qKygaySbzwh7/SBkXd8D0zY/9bRftTmQC7pand
         KNwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764555424; x=1765160224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iWIs/YDA1nzzX4jOEgpbV5QmPVgD/b4meZuDSCuGs4s=;
        b=MdnseaBXg0MF1vDjRaInvWeiapDe7JUawqGiwj8+GJzHcUTFcJK4oDoTyOVUBsX6Bk
         FKuyVeHjV03W4khri010jCjRds8G7tVYAxIesIxhJJD0i2LlqFFuZKN6zpqAfhkudjax
         mclbQS2big26XkUZq1abAirEn1Uh4Hfg/mHwlQYs4UH48jBazziZB0e0/8b1qQo/Jnzh
         /+hbCc0lIY3hgmZ/8wdDrmQR2QnOm/vBoBE/cWsXo+S9KAuOoLZdR9lpSVavOM8o4Nop
         l0dJpmp9UaDDGN24h6LMz13k4HetL/YM5VL5uZhUZsGZ//X9vlFnc0uhxuVRyrXBBqJQ
         a5Og==
X-Forwarded-Encrypted: i=1; AJvYcCWmGqf7nsR0WIdg3yDm8eQZdpN4ykZnCP/nTx9FWsBXAPcgv9pW8LspjEC4jzAfGQOTPwxpcEv79AjesQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxJ6TMouTXH/gJui1n9+w4eNxB0xXGzxyoCaVBAvRVMtmsOIrfr
	Go94Qflk9A95pwIqyI0/cqQUqd4KeErgAnBcvLA28Eu6G4ZGF3f6HleF7AFJXKsDQeE=
X-Gm-Gg: ASbGncuSxXFBJfjv67/9Mgoo+XLIULz2XLp9RfMWj3NNB+YQ7L43xf5VrVEtuZUXUMy
	8YwriT059rQU1yiXUweCwA/IhJ3krffyHvlXFiU36zbMxjTvuIlkmVDHyzfAsIrVra+gPrioeOl
	0KRGh5DsaZyv99i63SPtQIyHmu/i6ejQ5oaOmP7unceMtRGUefXgfxBWyt7b1IEKtrgtmb67qGc
	1oaDLZakM0JVv9dgwlgs2YaCXt8xGIm5gOwGVEEOjC/gL835vbALOaG1gQgGAXVAsPFn9ojHyRc
	YwyxAOACKPUGe9DCoY6TwxwV398PtqfpG7uRd99IpM/YFof5ELHS0TI+Zvwq1GO5X/jtRzNghRT
	Gj6xha2/J2SAsZcfd4GrkSc6bvXlvnEUn5BpNmMoGG6KHOk5I5zQ7EJ/3yAua8ZruJ3kh5O8EbD
	fEF8Kr27Q0Lg==
X-Google-Smtp-Source: AGHT+IEWrSHatavDU8PlmpUBXJN7D6018oNrTzyVUkNLbmGlmmIGVzbQLsOyrUBxc7hJxYUGTx/LNA==
X-Received: by 2002:a05:600c:4f14:b0:477:9c40:2fa1 with SMTP id 5b1f17b1804b1-477c315f8a1mr204739915e9.4.1764555423919;
        Sun, 30 Nov 2025 18:17:03 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3475ff9fed2sm9078965a91.6.2025.11.30.18.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 18:17:03 -0800 (PST)
Date: Mon, 1 Dec 2025 10:17:00 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com, 
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH v3] ocfs2: Invalidate inode if i_mode is zero after block
 read
Message-ID: <7re2pyy6jcqhqxvsrye7osbsoepmoumzsrlty6kjsrv2iqjt55@b4llca3qxoml>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251119221723.171746-2-eraykrdg1@gmail.com>
 <lkeaoxtkqccd3knpskbewkbn4cimlxaufix4evugcfkplk6u4b@oi36e4iu3x3r>
 <aSmzVvAy4lM6BsuL@eray-kasa>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSmzVvAy4lM6BsuL@eray-kasa>

On Fri, Nov 28, 2025 at 05:36:06PM +0300, Ahmet Eray Karadag wrote:
> Hi all,
> 
> Just a kind reminder regarding this patch.
> 
> Since We are participating in the Linux Kernel Mentorship Program and have
> a nearing deadline, your feedback would be incredibly helpful for us to
> move forward.
> 
> Thanks,
> Ahmet Eray

I have provided my comment on the v3 patch. The sanity check is expensive,
costing about six lines of asm code for ocfs2_read_links_count() on a big-endian
architecture.

Also, since I'm not the maintainer, if Joseph agrees with your patch, he can
provide his Reviewed-by tag.

PS: Kindly note that the kernel mailing list generally discourages separate
emails for patch review threads.
