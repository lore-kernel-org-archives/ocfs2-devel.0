Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FC772618
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Jul 2026 08:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189889; cv=none; b=mT14H3zfYqAWgQWJTdT3UZgVtvcfYmIBKis+CpFy2XHHaet+2oQr0uAAzBx1RP9xmUJqu9Nu4BIRjfVrci+2fwZSs8v0+3Skh/q8FV6yVDoqlxMd8qVQavVeULSlPT/wy3+vY3RIRyRtrM7I8/IZgqZkot2YmSlauRjPzWRs0lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189889; c=relaxed/simple;
	bh=/vYo3E4kv4adEu0RnpYGmEXGdRHBbdrRYE3i7xymbIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5W7oDbT5ornvMw+lngpTBVcWqa14YWspjhevOYEqrv77S8hBS3CenQ5LRXzXkPknCOXdNjLCt3PLtL05XdZNYIJlZoEx+C4NGXCEay8iRFMQ2lmb2hS2TnJ0grutQNZ6ft8vSVdjvaxa264yEBs4PdeHCwVqszsg5NVKdTn3gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 638926732A; Thu, 16 Jul 2026 10:18:04 +0200 (CEST)
Date: Thu, 16 Jul 2026 10:18:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>, Dave Kleikamp <shaggy@kernel.org>,
	Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: removing the remaining blockdev_direct_IO users
Message-ID: <20260716081804.GB12330@lst.de>
References: <20260710050744.GA6720@lst.de> <fea4c4f25afb7711d1e8fbe6ca5ab654ec522186.camel@dubeyko.com> <20260713095857.GB10501@lst.de> <af41e2dd178bbc4068317f1b9e09401cb49e7228.camel@dubeyko.com> <1421ca7e131663e594806f43cdad34f3282bd915.camel@dubeyko.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421ca7e131663e594806f43cdad34f3282bd915.camel@dubeyko.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 15, 2026 at 05:08:49PM -0700, Viacheslav Dubeyko wrote:
> I have a very initial state of patchset for HFS+ file system. I am
> testing it by xfstests now. As far as I can see, currently, this
> patchset introduced multiple xfstests failures. If you like I can share
> this patchset for discussion and review. Otherwise, let me fix the
> found xfstests failures at first and, then, I'll share the patchset for
> the review.

The unfinished one isn't too interesting to review.  But if you're
stuck on failures you need help with, feel free to send it along
with the question.

