Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DBF6FC5;
	Thu, 15 Jan 2026 04:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768452486; cv=none; b=IV0dAScSVwPneWpDHvUxVyYoCe02+PxSuLjnRUXhzfl6S54JaT2CBxYVVEItG6Fh6/XDn0fBeF6lVlnDU2p0DPxeaVzg5gse1VVehVrAR/M1bgwwwLHrgwwTxlbSMKX96o31cke/Pn+L/47Z4JuzwcFiXRnx1WYja9u3Fkf4Qds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768452486; c=relaxed/simple;
	bh=47OtzQgY6nHGb4lxcI/4PzOywfsjoHrQCdwasbHu3Xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shmKmXODwf2n0f0lM/D2yx7EgpW/dPd/5QZTbpd5AKSrkVBt/YYhYuJ0vzZRuLV18whx2OKSzPzK8a94+fXI1D4MBFiYSGm6ElP2a6c2HXSd/cx9YrZnwh35atgekY2KZKFIHqM26QZdqNy4dBQtAfx/hLmi6NkgrCVDUt5TAI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pu4laoO2; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pu4laoO2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D87Ch2KqlTEe3e8iwoPHWXFYV51pB8QmLIpUm7OMBBk=; b=pu4laoO21I+dXLugCg7RHmuqFE
	E8/hTSNKjZVwuWVfEs2Ko2NAC+4pj5hSMKurZ3SIrZBhbXt2hfF6+TIV6zGZ5VNt6gez+CbyVgAh4
	DViBVRDU1NImDjs2SgzsY7BaaIMrv4AaW1DkxYgLghGLzbO4Jni7Vjc83/eOOa++Nn+C4MwXhVKXk
	CabyDFF5Wr4Ra9VZlse0AIZtnThPoe2U8b4B1GUl+zBjRYR4RvUUGhAAy6vbkp9LEeLaVp4FIbq00
	F8k5bBawBRQNzlh4T8p++LHq194rgJxI3k1uAsMBQtZ5psv85kksks/17/ZuTV7kFDA5wREv2OJ5x
	Vq5e+A8w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgFH2-00000007DOE-1UeB;
	Thu, 15 Jan 2026 04:47:56 +0000
Date: Thu, 15 Jan 2026 04:47:56 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Prithvi <activprithvi@gmail.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
	heming.zhao@suse.com, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org
Subject: Re: [PATCH] ocfs2: Fix circular locking dependency in
 ocfs2_del_inode_from_orphan()
Message-ID: <aWhxfLwUvHDswsIY@casper.infradead.org>
References: <20260106125100.327980-1-activprithvi@gmail.com>
 <94b4189d-dfb6-4443-a336-abbae89d36ad@linux.alibaba.com>
 <20260108183652.ro4xueuj6itfaph3@inspiron>
 <20260115031809.w7ksrj2ostwyxa54@inspiron>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115031809.w7ksrj2ostwyxa54@inspiron>

On Thu, Jan 15, 2026 at 08:48:09AM +0530, Prithvi wrote:
> On Fri, Jan 09, 2026 at 12:07:00AM +0530, Prithvi wrote:
> > IIUC that would be the case when ocfs2_dio_end_io_write() operates on normal
> > files. However, according to the report of the bug, ocfs2_dio_end_io_write()
> > is holding &ocfs2_quota_ip_alloc_sem_key so I think due to random fuzzing by 
> > syzkaller, the function is curently operating on a quota file.

So the right fix is probably to disallow DIO to a quota file, wouldn't
you say?
