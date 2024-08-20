Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31D3190049;
	Tue, 20 Aug 2024 15:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724166006; cv=none; b=CcGtw1PviE6xIJNGUovg13CSA8NJah5bfwACP2rEsDxQrGS8z2Ee7OWZrXGUhVO3MvRRKGAh5BH7nLyV0FsC6p6oi3WBTaCpyU4NMXdGCXJIekkZUpSQca9v4jdsSL34bBBnjpW9nZpxoF6vPJ/N4xP1+HVp7wbMvHaQwOFlwNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724166006; c=relaxed/simple;
	bh=rzgrEC8lRFPAXYB4OSAGeyH90CC+VVrYhLEpPPpPF+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjVdXd9mYucCNQ/g9DqFn8vvC7ZfY9AmWOPYa1Pt/TAluTLZekmYpUs3AEyF/yBZg2dYnPT87kL5zQZkzeXVPm4HaVBAFv+SG5rdSvu83zQBnzRZzpvhUhFdIC5uwYkQm4tSJAjtuFOHzxA9UfcGm2IVtrAij98weLv1nlwkZZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bQAwbE+n; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bQAwbE+n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HL1vsKAtn2iEODNzGANE2yFAezcN9rto0d7NosUEPdQ=; b=bQAwbE+nHwWdJwH2I76IZqVD0O
	lYUNHwZFO0tcelquI5k/t2enMRzJg/GsMoo/9pLurM1Et/O/3Cjjgn2kc+ajWDhLOW7i73SVabqCK
	QvVZT7CypsIMOi3FKxhun/8mYRPhPbgZOLQKwbIcugIu6H+fzS7e1w9dyA5OStFQwitre3cw793AI
	UjBkCGshVHdmTmk1Id10hxGfGQC2KO+xKpm9mx/SKLPwbtGgR2idtVptG3J0QL9FqkOO8fn4/8HYx
	Yuv51TY42snXCKmCCjmmo/JWvvNJKev1U2so6g42HRdK0QgeBKFHdu8zD1xNEfrFcM4kwHk/Lu166
	vhTlh8nA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgQKy-0000000852n-3VOX;
	Tue, 20 Aug 2024 14:59:56 +0000
Date: Tue, 20 Aug 2024 15:59:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org, mark@fasheh.com,
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] ocfs2: Add i_size check for dir
Message-ID: <ZsSvbDxMtUEHEldl@casper.infradead.org>
References: <0000000000005894f3062018caf1@google.com>
 <tencent_EC9ACDC0793A6F742D7D6FA094F0E96AEF0A@qq.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_EC9ACDC0793A6F742D7D6FA094F0E96AEF0A@qq.com>

On Tue, Aug 20, 2024 at 08:08:38PM +0800, Edward Adam Davis wrote:
> When the i_size of dir is too large, it will cause limit to overflow and
> be less than de_buf, ultimately resulting in last_de not being initialized
> and causing uaf issue.
>  
> +	if (i_size_read(dir) > OCFS2_MAX_BLOCKSIZE)
> +		return -EINVAL;

Surely directories can be more than one block in size?
