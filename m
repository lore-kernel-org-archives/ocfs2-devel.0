Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA75719D08A;
	Mon,  6 Jan 2025 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736181097; cv=none; b=TWYe5Njqh1tMUTYeWkGa3P44OUr7gMTASGpdk+5olMsWFNOdhh0LNOS2uPqjh6q3KRj2dlw+DIRbo5JCrdmvKCyTUA84n0zUSz1Qu2QCtOLIViycg3IUGFdwHp+JzGyJXt6YjbesJpVL2mxPFbylgyayMlc6TjrHvQ+U4edxgf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736181097; c=relaxed/simple;
	bh=ZVkl0o1TEGbXk6vnJtTy44Fg8dNZDtCa+9K4r+tDdFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVh2QP+cPZnegm16l3UMYfldtWlIYzSco8LgGPqZUsookIHFQgsjYYFgAUKt4Vc0gCyLLyi0N8txUn88I11ZT+/KD1v3YYAWefFupy0aR/JyLZaKrUpJGW7bI/9RU4fYwNCBZDP5X6O6W5KzaY8fVl694EY4UVt45hNoVmvYrLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2UJfgJaX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2UJfgJaX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TrveJXPJKaY1s6rR0wgEJdiPv2Igv9sY0b3n6TI0PWY=; b=2UJfgJaXeIs4q+89wrYhX6E8oY
	ehrr/bvXi++MtdZlH37cbIwriHh0JooZZA4983/2Bdws2dHvfUd7osUbEvfumgwKd2AMB9IHtt/mw
	m3cTsg+MZ9BuBAmbowvgahp7qagJcEs9vsZHcJfW92zpty1gvSDhOfXEzh1YSQm3RUgWW01MIocMT
	6crALCQZjZo2QelOiPMhbo+l7+q6VoXwQqR68O6kXKZWVpQ01H4KQ7mfpKaOp/mC4rWzkRHODxdJH
	F7JYmh7pblFAk38QB5OoyFqPoicBt83qTloxl0N88Zy4MesrjCV58lV7SmSMJ3txyyejTAjtJWe6I
	/jMuKQ8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tUq0s-00000001xvu-2rfQ;
	Mon, 06 Jan 2025 16:31:34 +0000
Date: Mon, 6 Jan 2025 08:31:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] generic/420: skip test for ocfs2
Message-ID: <Z3wFZtcCPmr-vdsK@infradead.org>
References: <20250106140131.91946-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106140131.91946-1-glass.su@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 06, 2025 at 10:01:31PM +0800, Su Yue wrote:
> ocfs2 doesn't support fallocate with
> mode=FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE so skip it.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>  tests/generic/420 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/generic/420 b/tests/generic/420
> index edd9655fd3a3..e67442f8979b 100755
> --- a/tests/generic/420
> +++ b/tests/generic/420
> @@ -15,6 +15,7 @@ _begin_fstest auto quick punch
>  
>  
>  # Modify as appropriate.
> +_supported_fs ^ocfs2
>  _require_test
>  _require_xfs_io_command fpunch

_require_xfs_io_command should be checking for hole punch
support.  If that doesn't work we'll need to fix it instead
of throwing in undocumented blacklisting of file system types.
