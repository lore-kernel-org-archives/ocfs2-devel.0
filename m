Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B533A2E00
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Jul 2026 04:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785212400; cv=none; b=g8t4hpQjTKuw3akE+krzHxFSS+N4XLWVNcMBos9h4PR0ikKKsU77CvrCkeLgJy2fxwe8C0h4bmhcLgFPYKygvzaajD3apekRRQoimoO45GJ/JfQM2SMBTCI6XtQAQK0P7+u+W/WedeHiuSxFqkyWl0Pd3YVDYcFTvYYP3BGK25M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785212400; c=relaxed/simple;
	bh=leEXk3kdNeXuVSeZlP3npENIJC8tp9fqof/DLVDWJYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APVpUcTJkJowYTlSaC3c0gsrNUYOXJ9tcAeTQ6/Whet+STNhfRceonktWGbEbG9scMkyDWx/Xl6Fe/1ASHfXhcCWsLANIUtr7Cj2qE7P+MvjRh6+wsu64oI+BtGjbIFdAZVjV/2oZZe44V5iws2Wzvbq9yX8JK/N7HmVh0rinFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 99C4B68AFE; Tue, 28 Jul 2026 06:19:56 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:19:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
	hch@lst.de, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/4] ocfs2: remove legacy blockdev direct-IO
 path APIs
Message-ID: <20260728041956.GD19573@lst.de>
References: <20260727061802.18485-1-heming.zhao@suse.com> <20260727061802.18485-5-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727061802.18485-5-heming.zhao@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

After this __blockdev_direct_IO is unused except to implement
blockdev_direct_IO.  So please fold blockdev_direct_IO into
__blockdev_direct_IO and remove all the code that is now unused
