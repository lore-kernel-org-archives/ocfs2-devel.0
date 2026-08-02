Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EEB2C11E8
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Aug 2026 10:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785666617; cv=none; b=O/T3dOkD7Ics2n7wL8B4sBG8SWtLOYtnucNEjSSf51YMgfy0miytGXAQfjsV1+8DuSXWCAf6alxYh7XW7bvblCjbIco59ygbqxS28uzMwIXDWor9zPNDf2cUWGvxrBAwktvtJUYgGuB5FHqH2dB3NjcWO2iUplHtuRI036gokJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785666617; c=relaxed/simple;
	bh=KCoDI5ESWHtORyzqca/rH+I6IC9kneGwg0J/LBYN6N0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D+Cx6cP/q78RXzUjhy5uGj236OrC6neFqAIULrLS2iO0pB+F9zW1d2YPlWAo7K0oTMfbcbVF+08z4eih1FQvP1Ht8altrjRrJBR2r4+pFQdaby1x5MFjSOumIKGZlLhxNXXbsfRkYTOaRaCxoxfrpl6kDSawmDHyb1s0EfdEjgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cCInr/DZ; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cCInr/DZ"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-69e0f4eb4ecso543008a12.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 03:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785666614; x=1786271414; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PqCQcjOei1MEqWMExYN6Cl7+Q3LMozj2JD/0MEjkPCQ=;
        b=cCInr/DZqwj/K8w9kbcLRl5XdPalr29y9gfoKWZwQjXUIB3lyolq7oCT6yzO9GcF7g
         +bVs/nAIXXZOK5seCSjl90Vfx2kxTWRzOpHbxdpc+h8JDuBy9Uf2gfI1RbMF7iYFjjYh
         quz9pOl/ydqu2apqVA26Wc/Bm22vSN4EaZEgO2i6KGgUJjXwCiQMPAJ/2Os2KmsfTuRV
         upe7L3gVqLOA8aGaPwW7eQQXLk90g12k03mkhVKbQP8wfhX3JS9kZZ+1TU4gR+AijAPW
         BSfEFohhykQlcnMZe8Y039Muxdz7WYKoLHCrm0uDFGw/VWVbNsYW1QLvdxMXexSD8uci
         WoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785666614; x=1786271414;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PqCQcjOei1MEqWMExYN6Cl7+Q3LMozj2JD/0MEjkPCQ=;
        b=HjTmkYqya2ScsQA+ymVX9YV+MNSs/tFZClRQA3S7eJkq5IBWjLC9tS4SLbdJjkhI0t
         j8pVWGOe0FyPqdS/yyAiPGH00xV1mPj9JIc8vze8FUyMVBQWx3SNVZ8KywBIUfuKQa7T
         38dXo+OQBCj3vRtUXbqMqNIU7ttNNqL7UyqaNujJy4hFYlL9B5Jags+mlo6CexJKZTuD
         AoAdekOOvfS/dpyzRLJSndsC8Na+wmyID1UGFHMPcSe7/DwqB00/mksJbvnxDZ8Fr71B
         j14c0e5CIJLKYmhKKVcJyjOb2yGZknksUS3yUV3zZN+I7IC8J/wRhdkhqSrwdM49BXp1
         QCWA==
X-Forwarded-Encrypted: i=1; AHgh+RqT2F5Xr0dYmeFvBorS+kDxvoOlVQ2gvSgrAWG/0+3t557uvYlM0dgWiwSVVOHCMW1Ew+NfbHnzEfznaQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzrn01Rh1b+IRFlFabRobZnWvyziel05LL8CFHlLB9fBF9npLZe
	9OvQez7brt0vWTxqG1r8RSF7wEG9aRcCs14LxSMNVwCNfhST7ccqkSj0HVSggWiDsIk=
X-Gm-Gg: AR+sD13ww+bl81JawbgXYRAN9Nv22cM/NcX4tneG1iRs2fFb8ypStHjafox+w2K23YP
	e5L2JEFL6S5UWuLkk79QmoRVqBvqCLA2jOxuAfR8XB8fCRhmzzlUOK43CUP9RZkXc7oMtCt6sbm
	EDAF9YFZGgdwjRVAbjU30+Bj5xPwOpT0yYim0yt5azgox7NgAJ1M72cYtRtbzDSTUaKNTsqiH3N
	n2f5o3UmCnpz6WvZbFyMxXZBq4OG+34JvO5I9RTyy3vcopFaHsdQ1/vigAUh/YuJMGbkYWDfslG
	VzV1jOQGLiJriDE2Bzj/jvQ+UQs9mgtq68b6cgKvHkx/NmTg1RpH5gG6UHo0vLjgp9rhXLl59uL
	wRX5kB8qgswcMlPAddXFsuCDbr73mLBCTlAQ+9ql2No5TX8hoxLTdn7+IUpYyisvxJS00jvYy0C
	K9nPc3g1c2NzBIg5RTsavmd3Z9SMKX5c3Xbja0NXBoTs0ipPbdmxfbZKmbaCAz/yPbmQxT+g==
X-Received: by 2002:a05:6402:2111:b0:699:6415:751e with SMTP id 4fb4d7f45d1cf-6a0a7d096f8mr3056890a12.4.1785666614157;
        Sun, 02 Aug 2026 03:30:14 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbd310b2sm2406396b3a.5.2026.08.02.03.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 03:30:12 -0700 (PDT)
Date: Sun, 2 Aug 2026 18:30:06 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Christoph Hellwig <hch@lst.de>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] ocfs2: switch dio read path from buffer_head
 to iomap
Message-ID: <am625rzVmGz0ATXy@p15>
References: <20260727061802.18485-1-heming.zhao@suse.com>
 <20260727061802.18485-3-heming.zhao@suse.com>
 <20260728041657.GB19573@lst.de>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728041657.GB19573@lst.de>

Sorry for the late reply, I am fighting with customer bug this week.

On Tue, Jul 28, 2026 at 06:16:57AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 27, 2026 at 02:17:58PM +0800, Heming Zhao wrote:
> > This patch migrates the DIO read path from the legacy buffer_head
> 
> Please never start commit messages with "This patch", that context
> is implied already.

OK.
> 
> > The rw cluster-lock level is not stashed in iocb->private: iomap DIO owns
> 
> Explaining what you don't do is always a bit odd, I'd start with what
> you do, and only really mention what not later if really needed.

Will change in next version.
> 
> > that field (it stores a bio there for polled I/O and unconditionally
> > clears it before calling ->end_io), so any side-channel packed into
> > iocb->private is corrupted and would trip the end_io lock-state check.
> > Instead the unlock level is encoded by which iomap_dio_ops is passed -
> > ocfs2_iomap_dio_ops_pr (PRMODE) or ocfs2_iomap_dio_ops_ex (EXMODE) - and
> > the *_iter() functions use the split __iomap_dio_rw() + iomap_dio_complete()
> > API so they can determine unambiguously, from the return value, whether the
> > completion handler already dropped the lock (real I/O, sync or -EIOCBQUEUED)
> > or whether the caller must drop it (no I/O issued, or buffered fallback).
> 
> .. and a lot of this just seems to be about the locking, but very little
> about the iomap changes.

Will change in next version.
> 
> > +	if (flags & IOMAP_WRITE) {
> > +		/* todo */
> 
> should this be a WARN_ON for now?

Will follow Joseph's review comment, replace with "return -NOTSUPP".

> 
> > +	if (direct_io && ocfs2_should_use_dio(iocb, to, inode)) {
> > +		struct iomap_dio *dio;
> > +
> > +		dio = __iomap_dio_rw(iocb, to, &ocfs2_iomap_ops,
> > +				&ocfs2_iomap_dio_ops_r_pr, 0, NULL, 0);
> > +		if (dio == NULL) {
> > +			/* No I/O issued; rw_lock still held. */
> > +			ret = 0;
> > +		} else if (IS_ERR(dio)) {
> > +			ret = PTR_ERR(dio);
> > +			if (ret == -EIOCBQUEUED)
> > +				rw_level = -1;
> > +		} else {
> > +			ret = iomap_dio_complete(dio);
> > +			if (ret != 0)
> > +				rw_level = -1;
> > +		}
> 
> What information is missing if you use plain iomap_dio_rw here?

ocfs2 should release the cluster lock in end_dio flow, where "rw_level = -1"
indicates that end_dio is responsible for releasing it.
Btw, I previously tried using iomap_dio_rw() here, but found that some xfstests
triggered crashes because of this cluster lock issue. The current code (idea) is
based on Joseph's patch, and the code work fine.

> 
> > +		/*
> > +		 * A 0 result means the mapping bounced us back to buffered I/O
> > +		 * (e.g. inline data); the rw_lock is still held. Clear
> > +		 * IOCB_DIRECT so generic_file_read_iter() takes the buffered
> > +		 * path rather than re-entering direct I/O.
> > +		 */
> > +		if (ret == 0) {
> > +			iocb->ki_flags &= ~IOCB_DIRECT;
> > +			ret = generic_file_read_iter(iocb, to);
> > +		}
> > +	} else {
> > +		iocb->ki_flags &= ~IOCB_DIRECT;
> > +		ret = generic_file_read_iter(iocb, to);
> > +	}
> 
> Can you share this code somehow?
> 

I can't follow what you mean. What code do you want to see?

Thanks,
Heming
