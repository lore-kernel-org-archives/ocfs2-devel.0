Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005B32BE7A7
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Jul 2026 04:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785212229; cv=none; b=SZgksPvpKpgIey8Q10gO9W0I8qEe6jRTtEdlqz1Kxl0xqNKS42bJwAY6IlSQ7wAr+zAnegyROkSXwqG2UmD8ZsiYU/zty32D8A6ezZ1gDo5VNcMcw4DyQ1E87IpjUsyvnDc1yMJet01pyVMGxPk5dRCHWkYKF2ipWqouK8ZOOKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785212229; c=relaxed/simple;
	bh=eDQRG2ugfLw1csQ6DocqOaravUSuWyXZWR3fdxS9HRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TC78SdsECPRPVb4G3IiVDi3z+hm/a64GCZks2FKclkgzoytiLSX/HPaA/ao0Thg5N0y52NENjzs9pP7Ss41+MvK0VV1frPdLq+R6Y5iiNlcQ5Gss2EYHe72f/dH2nHWCE3xdY2Tbj+awx5F2D/zKqzWMTTDTbYU6bR1BNhV451o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70FF268AFE; Tue, 28 Jul 2026 06:16:57 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:16:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
	hch@lst.de, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] ocfs2: switch dio read path from
 buffer_head to iomap
Message-ID: <20260728041657.GB19573@lst.de>
References: <20260727061802.18485-1-heming.zhao@suse.com> <20260727061802.18485-3-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727061802.18485-3-heming.zhao@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 27, 2026 at 02:17:58PM +0800, Heming Zhao wrote:
> This patch migrates the DIO read path from the legacy buffer_head

Please never start commit messages with "This patch", that context
is implied already.

> The rw cluster-lock level is not stashed in iocb->private: iomap DIO owns

Explaining what you don't do is always a bit odd, I'd start with what
you do, and only really mention what not later if really needed.

> that field (it stores a bio there for polled I/O and unconditionally
> clears it before calling ->end_io), so any side-channel packed into
> iocb->private is corrupted and would trip the end_io lock-state check.
> Instead the unlock level is encoded by which iomap_dio_ops is passed -
> ocfs2_iomap_dio_ops_pr (PRMODE) or ocfs2_iomap_dio_ops_ex (EXMODE) - and
> the *_iter() functions use the split __iomap_dio_rw() + iomap_dio_complete()
> API so they can determine unambiguously, from the return value, whether the
> completion handler already dropped the lock (real I/O, sync or -EIOCBQUEUED)
> or whether the caller must drop it (no I/O issued, or buffered fallback).

.. and a lot of this just seems to be about the locking, but very little
about the iomap changes.

> +	if (flags & IOMAP_WRITE) {
> +		/* todo */

should this be a WARN_ON for now?

> +	if (direct_io && ocfs2_should_use_dio(iocb, to, inode)) {
> +		struct iomap_dio *dio;
> +
> +		dio = __iomap_dio_rw(iocb, to, &ocfs2_iomap_ops,
> +				&ocfs2_iomap_dio_ops_r_pr, 0, NULL, 0);
> +		if (dio == NULL) {
> +			/* No I/O issued; rw_lock still held. */
> +			ret = 0;
> +		} else if (IS_ERR(dio)) {
> +			ret = PTR_ERR(dio);
> +			if (ret == -EIOCBQUEUED)
> +				rw_level = -1;
> +		} else {
> +			ret = iomap_dio_complete(dio);
> +			if (ret != 0)
> +				rw_level = -1;
> +		}

What information is missing if you use plain iomap_dio_rw here?

> +		/*
> +		 * A 0 result means the mapping bounced us back to buffered I/O
> +		 * (e.g. inline data); the rw_lock is still held. Clear
> +		 * IOCB_DIRECT so generic_file_read_iter() takes the buffered
> +		 * path rather than re-entering direct I/O.
> +		 */
> +		if (ret == 0) {
> +			iocb->ki_flags &= ~IOCB_DIRECT;
> +			ret = generic_file_read_iter(iocb, to);
> +		}
> +	} else {
> +		iocb->ki_flags &= ~IOCB_DIRECT;
> +		ret = generic_file_read_iter(iocb, to);
> +	}

Can you share this code somehow?

