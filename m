Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793696608;
	b=Z3+7Of4ztHVO9g6eIO21ksO+dTwo1cNvLGIwzp9jYgLsZJUe6qqjayjbUn+NXh9u+eEi
	 +GVvqcHFFDGjosB8wewW4SRWzVH+fSbaPuWLT+RU8tWgw2cj1Zne6+fSxJKV05WMjdexL
	 XpDTcVX2rKXCwf3MRvr3QQVsMjIIH76FrUOMSq5c4gX1QV6UbqWyZKEuFCN3NalojBqub
	 7ZU50W/VNHuuUQGTyGPpQzfFLMmRNL2z+lrwj6s+DWgGP6Vc861iwTX8ZysnR6a5nt0cK
	 sCX8hNrVWfshvG7YwS3XS5Dss4Ox+F7dLbxx9mmCentW3RDQByH6gVhLpGZn+cVFxtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793696608;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=GHGz850caSwjJKS3oE56h9NFkxUphg5/vIJAawh3jok=;
	b=pOYzt9jDAtXJblSgSl8F9SDzVSbqlF7MewhrgJJua1WLBjKyH/GQC9/2P+PMe1oO23Eh
	 mrorLjs94cqdUyMhiyRjyfE4NEdZb88wNII6Vwgjtv5Oy7dhmrTjvyQiPZrzHazbMpgUQ
	 dqIk//ho63YvNJ3TWtj0w1SQ9uYuLAmPyvn72DqRxDoKHWJLUBTrU8An/H4v4EHiLa0O6
	 Bg4ZQox6IZ0sGebP+Vd9cmYJVAu6YfxELvwZVYCRLTRxq8OMvGNRm07av5+Vx6UaKEJic
	 d42kU6aIrj2pORFAQI32G6m1s+pabmoau+nZvj85y/YB/Df83QBs+W0X75Kgz3yVTMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1035606A326;
	Tue,  3 Nov 2026 09:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1035606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5881F68B05; Tue,  3 Nov 2026 10:03:23 +0100 (CET)
Date: Tue, 3 Nov 2026 10:03:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 33/34] xfs: allow remounting read-only after a
 shutdown
Message-ID: <20261103090323.GA5314@lst.de>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org> <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org> <20261103054155.GB1559@lst.de> <20261103-galgen-ehebruch-stehen-a967c14ce53e@brauner>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103-galgen-ehebruch-stehen-a967c14ce53e@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 03, 2026 at 09:41:58AM +0100, Christian Brauner wrote:
> On Tue, Nov 03, 2026 at 06:41:55AM +0100, Christoph Hellwig wrote:
> > Btw, if my previous reply wasn't clear:  please add the test for this
> > to xfstests where they actually get run regularly and not the kernel
> > selftests which for file systems are basically unused.
> > 
> > Bonus points for having generic tests instead of purely file system
> > specific ones.
> 
> I can drop the tests from this series but xfstests for this will be a
> follow-up.

I'd much prefer to have one canonical place for the tests over having
them in two places.
