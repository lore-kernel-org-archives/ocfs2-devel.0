Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9069846F;
	Sat, 20 Jun 2026 17:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781978404; cv=none; b=nogwYzxDgxRjxraR8302fRhdBMF5VK4TOXCnLFs73z3hZL8NclXb2FXTCWmgnyMfXJ3qLwBBdvor10UFQH8OrKiT33KkyYYELyaVoFaVMPpS7BWZ5JcqIHKJDlN5Oq/krfOA+iYwbYzWMjs6oPO6donNIm29JS5iXuD8pOuD5nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781978404; c=relaxed/simple;
	bh=8OFr0lBC9cL+i6zdKCimEOmHBJyveHC8BCYwZiX1TWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dPVTWKewUFRUhiagwlWAJ5Q+FIW79rkJIu5UySIZcHxse73B4i44aGqcIcRlhdW2Kh7LkFMSYJ06JMnFRL1EyBlF0wlurJ5auxYVFZ1GuccKeM3T85ybc/kekmJcvZKCn9kzYedT49M+R4xO9kMAnKgHunuJDXBZtwc0ZHWs7C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B9x5kxZB; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B9x5kxZB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qNZKejoPIEwHy8v0PT0MYkewJ/JyHmMBqfk9pQqvmxw=; b=B9x5kxZByPxoLEHnGC/Jz4Hgja
	ldsTuMqKQPeq4nRfN89RjCEPL9mIArAHQ62989hVs1xn3vHTITFGatd0a32a2icb7PQpeZub7oevO
	WfICT1bS7vvSVYLo70mMXKlc3rr/kiQ38Brs5FrelqP1k3F2dt1m2tPgWcI6VsmDmLRmDeYg/an1t
	Wl3p/TFwVXF+sDARtbEqtjNMoRh9FBz8Soi0Q0N91UZqGTyjgsFoE/KyrZDoIZo1vDh9wjsttmsua
	kK8qq6jZ4FD0/jCeF2LRuW2Q4JPwJ3tprjlQ4s7dzg8yLGe6ZMOzzoKPKEhhqisNdh/WiHu8Z1HIr
	MrtzYx2g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wazym-000000011cf-2gnR;
	Sat, 20 Jun 2026 17:59:41 +0000
Date: Sat, 20 Jun 2026 18:59:40 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	bigeasy@linutronix.de, clrkwllms@kernel.org, rostedt@goodmis.org,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	syzbot+ce129763ce7d7e914739@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: fix deadlock in dio write orphan cleanup path
Message-ID: <ajbVDMX0mSnLKe2X@casper.infradead.org>
References: <20260620080802.35165-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260620080802.35165-1-kartikey406@gmail.com>

On Sat, Jun 20, 2026 at 01:38:02PM +0530, Deepanshu Kartikey wrote:
> PREEMPT_RT's rtmutex PI chain walker detected a lock dependency
> cycle in a single thread:
> 
>   ocfs2_file_write_iter()
>     inode_lock(file_inode)             [Lock A]
>       ocfs2_dio_end_io_write()
>         ocfs2_inode_lock()             [Lock B]
>           ocfs2_del_inode_from_orphan()
>             inode_lock(orphan_dir)     [Lock D] <- cycle detected!

This seems like a false positive.  You can't call write_iter() on
a directory, and orphan_dir is always a directory.

I would suggest that the easiest way to make this warning go away is to
replace inode_lock(orphan_dir) with inode_lock_nested(orphan_dir,
I_MUTEX_NONDIR2).  It's a bit quirky because, well, orphan2 is a
directory.  We could add a seventh lock class to
inode_i_mutex_lock_class, but that feels a bit excessive.

