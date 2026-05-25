Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB3E2D9787
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729699; cv=none; b=KQUso9fbPXAPk73HqmgETiKEhs0WISYZ9cnUgF601nhuy5Gbl/B0aF+jO/zURZXUv9oVQgg81r6Ok9JMintK0RnrCfgn5LSZXkdae2JontvLvRt8dv9bF7SPArl/wQU9bQCeZsnbhLUhj+tMU1oCc2ljI6ydHh3jzKQBiTIzzyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729699; c=relaxed/simple;
	bh=VCEFYOA8bvBB0He6GPuue1J5cPggJ9r83oKY1RULIeM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jh3+loVD6uKCQcH1SJbmdbrnUhGEM1oU4u6rxHK+NDh4LzX5HRoU5SBh44rJGzLnFt1A8B1ggp7aeuatgmMyuXyK+RjJiMLu6tTtX7WPQVX2YeSauKZ9ZW22Xt4q+JYllxBIUez5LOw6CKBVX1aiGyrF6lRcUUSFcjJyUTjlq4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcal4mM4; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcal4mM4"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so102272705e9.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 10:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779729696; x=1780334496; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNWXusXZo+ITDqzjd8lv9UPW26DbKQzVTY3kSMXJqIc=;
        b=bcal4mM4IhdFMdLBSosTW6VWrUc0Y57whPjHcUutOYpNTMa6Th5CH0mkYi2Ge7rV2b
         Bd8MSUuontvvWT4XoAFg4JvMAD+ab4oAS9wPyr0yileFwjX9ZVpB/FZEXDg5t5whbimk
         wjL+7DdjSQPi2AU7+t7xygcbRPzmNgCdTJCxX7O46zkaC70N04nQoshsVV194zrh1Ng9
         +s2nm1zTG+QTXDWizTdzomNdHSfb6yOyfP3+7ADkZ48afJ+PH9Obd1Nl8PlQVNz2QJsA
         OHrRG2RGOl/7NDazNX0SiiuhG6azMcepwMC5UAa8zYcVHeisAtGB6Fvk5daQb06uCPfv
         ZY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779729696; x=1780334496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sNWXusXZo+ITDqzjd8lv9UPW26DbKQzVTY3kSMXJqIc=;
        b=I0oD/MqOK9F+VLx+Dgl4a5KVque60ui6K8ve6E42/DiYeLN2ydvp1DUBwJZi2DxWOd
         W424bp8GW7y+c5VModRtUnYeW5H2BRVTQTjvQ8pD1PyL2dkL+DYXp2uT7CPjIkJ0F7K/
         n3Vc4GMZu+Gxvf3WI/EDIjKNiqEX5LkVPUhvwpHJ8AWuVY2h+kuD/N9DRr2QXVWIjfxr
         dAkHtySX4GdwGT1XLe0nL+cG46H41+b9f3ezo9uRRW4fBQbF3ykdCqISW8tTOh7QAzWE
         U5HNXpt1WGjTTD77I5kF2T/cRMKulrVUnrPmCHHfHGn0ET9vz4NSB/U6jdd8hQr67cBR
         4zYw==
X-Forwarded-Encrypted: i=1; AFNElJ91ueUHe2w2YBNWcp8lZsGZiZx6SMWHiNeB/7FmvzlvIB/QhyNFMh2DiqEZmJnpegewNedChnv5LsIPPQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YytkCVw95g4ppPxZmEoMBqrkS10if810ROo0BBWWvOmYw3SuggP
	P1iRZFWuIv6UfOqIvudDRExzU8JqLO5OjkkZ4y7ucXnXIOfaOoeBfwum
X-Gm-Gg: Acq92OGXzo1xh82lR1EhV8nsDfu1A3zWSGfyoSx2/sqvSvCJr0fiwqw3dwZSHfbG1T0
	QcGdV7RMM8bsNZyO2TvhVeLYEQCi6BTvsgn7eJ0u0FAdY3zK9qlqUerXvhSGzjT1S3aNVqAukhZ
	WcN4THsrGD21XF7aoUyM4/oxjh6JgaIVHu+qphuH2U3iSumwPv+ulBGMzXGfEaqg+UMZLBU8wm4
	o+uxrTTPh0rtIoKpevTvjOLGzs08AivYb4plGg+U2k17JAjReGLlaXpbc6L5apJdCF+VC91rM7Q
	iBPw6dXDZTgWGaaRyJ5TGIku5yLFnFFksKKi4Ka03LLQtD5Lds2Dk4BvV2SWD3i7cNaO8B9DmrS
	dE8UNOxLb0hHmuucMh7LKSGYCf8tqMNp41JWxFX3Uqzf22YutlAMxoSHrqCNlJcDPFlXnQ3AIrQ
	WevBjMqpQuOaOwDRmqExiqA8O7TZalsX23Mqky2ZOCVa1TQ3638aIkvFTJLGCCl6oT
X-Received: by 2002:a05:600c:83c6:b0:490:5872:e641 with SMTP id 5b1f17b1804b1-4905872e758mr158057335e9.18.1779729696288;
        Mon, 25 May 2026 10:21:36 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490428d63f8sm88577605e9.18.2026.05.25.10.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 10:21:35 -0700 (PDT)
Date: Mon, 25 May 2026 18:21:34 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jan Kara <jack@suse.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Dave
 Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Miklos Szeredi
 <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao
 <leitao@debian.org>, Kees Cook <kees@kernel.org>, "Tigran A. Aivazian"
 <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <20260525182134.04045610@pumpkin>
In-Reply-To: <2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	<20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
	<2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 May 2026 18:17:04 +0200
Jan Kara <jack@suse.cz> wrote:

> On Sat 23-05-26 20:54:22, Mike Rapoport (Microsoft) wrote:
> > jbd2_alloc() falls back from kmem_cache_alloc() to __get_free_pages() for
> > allocations larger than PAGE_SIZE.
> > But kmalloc() can handle such cases with essentially the same fallback.
> > 
> > Replace use of __get_free_pages() with kmalloc() and simplify
> > jbd2_free() as both kmem_cache_alloc() and kmalloc() allocations can be
> > freed with kfree().
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>  
> 
> Looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> I'll just note that we allocate here fs block size large buffer so the same
> kind of allocator as we use for folios would be even better. But that's a
> different cleanup I guess.

Would kvalloc() be more appropriate here?
Does __get_free_pages() return physically contiguous memory?

-- David

> 
> 								Honza
> 
> > ---
> >  fs/jbd2/journal.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 4f397fcdb13c..1137b471e490 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -2784,7 +2784,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
> >  	if (size < PAGE_SIZE)
> >  		ptr = kmem_cache_alloc(get_slab(size), flags);
> >  	else
> > -		ptr = (void *)__get_free_pages(flags, get_order(size));
> > +		ptr = kmalloc(size, flags);
> >  
> >  	/* Check alignment; SLUB has gotten this wrong in the past,
> >  	 * and this can lead to user data corruption! */
> > @@ -2795,10 +2795,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
> >  
> >  void jbd2_free(void *ptr, size_t size)
> >  {
> > -	if (size < PAGE_SIZE)
> > -		kmem_cache_free(get_slab(size), ptr);
> > -	else
> > -		free_pages((unsigned long)ptr, get_order(size));
> > +	kfree(ptr);
> >  };
> >  
> >  /*
> > 
> > -- 
> > 2.53.0
> >   

