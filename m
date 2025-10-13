Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4442EC56F
	for <ocfs2-devel@lists.linux.dev>; Mon, 13 Oct 2025 08:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760343317; cv=none; b=XrGDiLLONYali4Xvc6kqNGHdfT24wNWKuRtNlSP+pvP9BvI05U+xpz7RIg+CDhtAVUH6LJEiT9u9X5y8pbBJclCJKnWpDTD7NUVmBt9pTRAHNlKsVabRB7CvYtAfGHLU4fQ/sRGF9sKSpiClQQvH8QpdSdw152/lxkvfPSoyCKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760343317; c=relaxed/simple;
	bh=ZDF9V6SdJC6O5Ci089i93CmqQdlIvNR7SmEpklYtaiI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l4cI47CHRQd+0uuOPQK61rPYxPqjrlXm/HxnY9geKFzcYK475+1k5VP1Ys6ffqa8/t/jI56MTNnkwMsqCyUaNCp72LZninjMp+Bn0nSdh39fNRSEiSxSffe1sLw1Pl+moe+IPHoRjADN2fiMGHtE5CFKqaqcluxSLwiTGqTCIrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Gu7D0XjR; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Gu7D0XjR"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4256866958bso2105353f8f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 13 Oct 2025 01:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760343312; x=1760948112; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R740my9A/r0yGv8JF/opdryBZzIxczQeXr2k5izULh4=;
        b=Gu7D0XjRXE2eRjRt2lPVqPH6yqn9K9izlGBQOhMvFc3JgXIx2tYc3XosThsa1bZHeG
         eAM7A8961wi2qVUIHJPGz/NdG+/Q0tVo02Sh84AVMG1MiLYSWZkXTkEv2hP21C56XRsF
         lpz0oluCnMYtujH5pOPfYwGYoACyCfvZ1X86OVcBBBPfQhzXHtkDpi3OOY8mN5SEk+b8
         a5huuWhyc1Zus0AnudzRDWWeJ/FuAuKPa2kjaV4cVwmiblu+jVU02f85D2/tDYInzZ4J
         +EyfByLSBMUiOQaoKCUzGCRROOQ7kjt3Vw6mnMNpvffSKaOpI5d162UraHgzSKXDiG9k
         4jLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760343312; x=1760948112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R740my9A/r0yGv8JF/opdryBZzIxczQeXr2k5izULh4=;
        b=O9zPAsnMxqf5XVEh/7wBU3WbFG6bYYCpSJ9Xq45x9oJmygMubV459AS+djOn0ohivN
         TK+W+KpeCBJLeYSDHNms8wj14CiOhWGpbcKy4FOFiSiOalO1M1XSw+/8W8XMm7LknJyX
         MHq68ibpjPWFziCPqBfTe0Z3cFiV1P9LnM9DmRS2dQvwMgArQjjJ+JP/3NEzbU4hnpXa
         huYg4EqY+mVS0MLCgRz1Q6yKLsO5IPzam0IMgBdV6jqWSAXvUJFmQXEpzEr9WPml4ppj
         0r4rjVZDSHJLMgm4xDzTkySk40/qHolmPdkd5+F21TvkJ9xwa7yPV71hI/AyUoE/4xIL
         rZwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPGPhrJ9OFstLedVxLiZuPTCwpkx0Bs9bYIP1VxfowlEajVJ3C7eQz45D/NzNVR3sEpv7N8/ibCAd9YA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxYHPc3FzjLtDsGorItTa9iOBSniLUvZIfRXqYyRacYw3oT9IXW
	+Nha6fhVJkYybpJvz2umsUTFIHjFqvxjsdfP7nKKcMFudRRw062/r3wIZF7pnQiYyOgfwIT2uPU
	H9dONeQj8Qkx74UFtaNhukiOlIskTnLJQNEpkQajuGQ==
X-Gm-Gg: ASbGncuHYFlCsnvVlEOvSy/bHKJr4Oew5lohuLvZpZWImEoLsVTvIlKWl2O8UEp4KY/
	HCSQSD/xSjlWwq/Gw9b7a7aypPQrwmeo8nkBH5ffuQZ1je1zX9zPVofQUABX1nyYpZmE5Wa+RT4
	hvvNHeAx+nptfh1fL/U4sFwBSxoILwyoeQ4izoqFjs73aTNgX0OgZ+44SbKsDAJrHygPZ6yh7P8
	wNKm93+OYPvlzW4GnjsUuHGAMCfzvFBuxw=
X-Google-Smtp-Source: AGHT+IEXSnK8vgh5qb4+sZ5l2hFRJWnorbBdcfDu2E4RvgYsaMIAeq5q8p6/Cp6GKDAeCkB0EX+DEBuZJrHy3pYKRvM=
X-Received: by 2002:a05:6000:430b:b0:3ed:e1d8:bd72 with SMTP id
 ffacd0b85a97d-42666da6dc9mr13043087f8f.17.1760343312390; Mon, 13 Oct 2025
 01:15:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013025808.4111128-1-hch@lst.de> <20251013025808.4111128-6-hch@lst.de>
 <65aad714-3f1d-4f4b-bb8f-6f751ff756b7@kernel.org>
In-Reply-To: <65aad714-3f1d-4f4b-bb8f-6f751ff756b7@kernel.org>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 13 Oct 2025 10:15:01 +0200
X-Gm-Features: AS18NWCgT3XSP_MN-BMfr65K92-imDhnpGub1dZ7jpbkZ5N0Fj6p03e4QIM-oxw
Message-ID: <CAPjX3FdRvkie6XMvAjSXb4=8bcjeg1qNjYVT5KOBUDrc+H=nDQ@mail.gmail.com>
Subject: Re: [PATCH 05/10] btrfs: push struct writeback_control into start_delalloc_inodes
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Oct 2025 at 09:56, Damien Le Moal <dlemoal@kernel.org> wrote:
>
> On 2025/10/13 11:58, Christoph Hellwig wrote:
> > In preparation for changing the filemap_fdatawrite_wbc API to not expose
> > the writeback_control to the callers, push the wbc declaration next to
> > the filemap_fdatawrite_wbc call and just pass thr nr_to_write value to
>
> s/thr/the
>
> > start_delalloc_inodes.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> ...
>
> > @@ -8831,9 +8821,10 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
> >                              &fs_info->delalloc_roots);
> >               spin_unlock(&fs_info->delalloc_root_lock);
> >
> > -             ret = start_delalloc_inodes(root, &wbc, false, in_reclaim_context);
> > +             ret = start_delalloc_inodes(root, nr_to_write, false,
> > +                             in_reclaim_context);
> >               btrfs_put_root(root);
> > -             if (ret < 0 || wbc.nr_to_write <= 0)
> > +             if (ret < 0 || nr <= 0)
>
> Before this change, wbc.nr_to_write will indicate what's remaining, not what you
> asked for. So I think you need a change like you did in start_delalloc_inodes(),
> no ?

I understand nr is updated to what's remaining using the nr_to_write
pointer in start_delalloc_inodes(). Right?

--nX

> >                       goto out;
> >               spin_lock(&fs_info->delalloc_root_lock);
> >       }
>
>
> --
> Damien Le Moal
> Western Digital Research
>
