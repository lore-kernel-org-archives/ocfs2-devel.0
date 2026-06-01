Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E633DD87C;
	Mon,  1 Jun 2026 17:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780335558; cv=none; b=b4ceU4SvIGlesTyELnIBgu5B6IeWGnZDClOMSuoIiO0wEP/HnWBueO2OqDQvUZFPS61ToAf4WPanNhIALAjxodH8/4g1lExQidhSqaYBpwC+Se8OJ6dYXxzjVqIxQOKXig3A1bqIVkuSlqcY+80BVMfiF4hy6q8axFNkjYEu5Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780335558; c=relaxed/simple;
	bh=tLudQeEJJZDtFK+5qOc9mUH8gl7h2TIO9ww8w7ORKiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qc+hg/2AWz21LBlXy32shnw2Z3D7v4+g1ebsn7fcT8OCH+PFHggfUzila2ipJ9efvfNQWfDxyqWFGV2dHhDM7W+ooyN+3VFbOlvdTy00SQ23sFdq2wAexG+wiw02L568P7r9jVMw22NzFkP29DSJusVHMzm0LsS06M5H4JD+0tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=evilplan.org; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=fail (0-bit key) header.d=infradead.org header.i=@infradead.org header.b=QvELIstK reason="key not found in DNS"; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=evilplan.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=infradead.org header.i=@infradead.org header.b="QvELIstK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hQJrieaWJI73YeXNyAEIZ/Yxty3YHjK+dmhqfWY0PX8=; b=QvELIstKd/f5F75dj7d2AAfKdQ
	mfXPf44Mre9hID4+9+hilSpEaejx4EsT/7DXuZN7sDksZ5Ny8WD+/AcZd6iLXIqRNZVRhUWgIYM8x
	eXKkqSm4gXJmtS7PP9XmSFuIbOQAmKtcFPDlUcgM4YXGPrWESf0qHoXr+rtwSK+b5xyeGkr0gwK4g
	e72QDxvwsI0ZAHpEpl4G+BbSA7XLxQYQ6KtK6wGG999dBxbegnQYw4QOfQx/r05oraBsuNv9NZLD+
	lU0umGpUYeym/UCdwa1ufaO8TT4+myXVzzx/ZMfgnEfx5/0//KcQPBCyNpnSt8skUr+i7Ynx/kEBW
	7d+P9F1w==;
Received: from jlbec by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wU6bZ-00000003OOM-15bQ;
	Mon, 01 Jun 2026 17:39:13 +0000
Date: Mon, 1 Jun 2026 10:39:09 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
	ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ocfs2: harden inode validators against forged
 metadata
Message-ID: <ah3DvUPLC9AG2q6N@google.com>
Mail-Followup-To: Michael Bommarito <michael.bommarito@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260517111015.3187935-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517111015.3187935-1-michael.bommarito@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
Sender: Joel Becker <jlbec@ftp.linux.org.uk>

On Sun, May 17, 2026 at 07:10:11AM -0400, Michael Bommarito wrote:
> This series adds three structural checks to
> ocfs2_validate_inode_block() that catch attacker-controlled bytes
> in a freshly read dinode before ocfs2_populate_inode() copies them
> verbatim into the in-core inode.  All three checks fire on the
>
> ...
>
> Threat model
> ============
> 
> The validator is the chokepoint that protects
> ocfs2_populate_inode() from a malformed dinode whether the
> malformation got there via:
> 
>   (1) An attacker-supplied disk image mounted by a privileged
>       user.  The mount path runs every dinode through this
>       validator before any unprivileged user opens a file on
>       the volume.  This is the same threat model the existing
>       inline-data, refcount, and chain-list checks in this
>       function were written for.
> 
>   (2) A compromised cluster peer with raw write access to the
>       shared block device.  OCFS2 is a clustered filesystem;
>       the on-disk blocks behind bh->b_data live on shared
>       storage that other cluster nodes can write.  The local
>       node's cache-eviction re-read runs the newly fetched
>       block through this validator before ocfs2_populate_inode()
>       runs again.  Oracle's BlockErrorDetection design document
>       scopes the existing CRC32 + Hamming integrity primitive
>       explicitly as defense against memory and wire corruption,
>       not as authentication of peer writes; the field-level
>       validators are therefore the kernel-side defense
>       whichever path produced the forged block.

Thank you for the excellent description of the threat model, and for
devising the comprehensive model in the first place.  It really helps
consider these patches in the right context.

Can you make sure this info carries on to later versions of this patch
series, so it isn't lost?

Thanks,
Joel

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

			http://www.jlbec.org/
			jlbec@evilplan.org
