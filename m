Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4DF1DA112;
	Mon,  6 Jan 2025 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736181016; cv=none; b=D8HtzhMGA10gnETBKOXL7XKCRBgBQZOTvsYqRw9TwJzO+dxftQ9AzIGb1AEkFtmKIilYGblKqQs8T3W/1l5lQ8HyBHQijvEiMtXl0mn+r+ufloezE2Ln2SRxjJ4jmTU5qQg5SCYQZEzm08NJ9pRhNA37o7ow+RLDAkDU2G+k4l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736181016; c=relaxed/simple;
	bh=/qs+BOcaNhErSCb4fvySGxaDLK/zRfV+EGaaO6Ibo4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSeFQUON36szaD+0GPU2SlY0oIC+ttqYZAMbozWcXJL7ESbWjIBDdfTOBYZ62EmE1ACQF8vOZW/Q4LqBeulSmcLUdZ9yJy5qze5fnOyMrNr+RpPiAfEtnu2nK+eL9FqDoUmCFcs6aV9c5WkWS2hbfqsPt1yC9K/DIMPT4m507Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HvTAxrmJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HvTAxrmJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=98TSEPpg6hVHkJd8lUJjbXXrk4iGm4+i+cgtqxivC+Y=; b=HvTAxrmJ61VwMlAw5Rom+Ef+OM
	R+AKF671mI6NnoA94PrByvjZ+tPIin+OmitKbVJ2V7bUSvqK6k7554RmYQPD9SuKZIzeqYWKtiuLu
	rhlrd20Yk4ZqBk9cwgQUA8dBA1nQfZYSoXq/oo9GB1vagej5HqINZQ+kaNT9SebpUXcZDRe+ys4lT
	0FNhn65RkIH4FcQHxVUmDLANbM2TmyiqkS+CQZimV6vAbgTNnVwAGAiRe798j+7TUPvIB8RSQpdsP
	Mq5bTV0HVgTM5v3+OHm+XfIAQ0gQL3NSEPSTnQ/SDeOYD8lUhRSmCVpnaw6smD5OwPiDV/iLpTdFj
	FvAs2j1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tUpza-00000001xnh-3Va2;
	Mon, 06 Jan 2025 16:30:14 +0000
Date: Mon, 6 Jan 2025 08:30:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] generic/620: add '-J block64' mkfs option for ocfs2
Message-ID: <Z3wFFs371-WNVreY@infradead.org>
References: <20250106140104.91880-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106140104.91880-1-glass.su@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 06, 2025 at 10:01:04PM +0800, Su Yue wrote:
> mkfs.ocfs2 is using 32bit journal as default.
> For 16T size device support, '-J block64' should be used.

Hard coding this into a specific test is weird.  I would expect
mkfs to pick the right one, but maybe the maintainers have a good
reason for not doing that?

But if not you probably want to force it in your config file or
we need a workaround in _try_mkfs_dev.

