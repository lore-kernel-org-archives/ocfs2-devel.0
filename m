Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C76823DD;
	Tue, 21 Jul 2026 01:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784596537; cv=none; b=DcYLs4bLTz2aCP+7wRWK4K3HqcdiLk4D33dEM1HW5oeH2owHO0usyqg0laBLAcANB0uK48FC7ZxtIiZM7WGcnjaNsf02sxpiROmO10KvRPI1LjgdVQM8r8PKjexAQ4M5QItp4BC8XNqwMf3zBlX7mM8zjRH6y5vEgDhN3DiUgRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784596537; c=relaxed/simple;
	bh=ojIgvYqqIQK8sjCGCjkSi8JEgRCJ7XKJj4kQEog3D1A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=h0PbdEMd/mUjI8pt6AA/EzgMA6LrvqHyRnRahjKmr0VUxAF9nsD1mivCcvIpYrFBsuLfqsDzskplohO4gJ3qgEYmyc+P2UwAU8+gWjjGoIY4Gi1GXcUrjhIA9692+kRVdk9L2Cc2wU6dVHMFbQ0SkNhdOILX6+sjORxPPFqGPvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T3M0QQDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T3M0QQDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722F21F000E9;
	Tue, 21 Jul 2026 01:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784596535;
	bh=4q34Aw5O5ssYpPRJex6Nlp+UAAteHjDMWMQk6MU/m7I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=T3M0QQDqN1YnwL84GA732Kupm5xRPhauTcWE79bKGG2wdA5A6mD0FGzOb8dmgExLR
	 zABKrvdIJBvNLBCZPPhqI4eNUeU4wiNhbkwrP1UvCoAx3FeBaK63OoKTAo1Nn/8uBt
	 9VX7YX2ngT74HpLDQ9Sn5RBFtBnPZrKTxNYsRQ84=
Date: Mon, 20 Jul 2026 18:15:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph
 Qi <joseph.qi@linux.alibaba.com>, Tristan Ye <tristan.ye@oracle.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ocfs2: free unused clusters on defrag move errors
Message-Id: <20260720181535.158f43328e1f6c3d2036352e@linux-foundation.org>
In-Reply-To: <20260720141944.485212-1-lgs201920130244@gmail.com>
References: <20260720141944.485212-1-lgs201920130244@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 Jul 2026 22:19:43 +0800 Guangshuo Li <lgs201920130244@gmail.com> wrote:

> ocfs2_defrag_extent() claims new clusters before calling
> __ocfs2_move_extent(). If the move fails before ocfs2_split_extent()
> succeeds, the claimed clusters are not referenced by the inode and must
> be released.
> 
> The current error path only logs the error and continues to
> ocfs2_cow_sync_writeback(), which can overwrite the original error with
> zero and leave the claimed clusters allocated.
> 
> Not every __ocfs2_move_extent() error can free the new clusters. Once
> ocfs2_split_extent() succeeds, the extent tree references them even if
> ocfs2_decrease_refcount() or ocfs2_truncate_log_append() subsequently
> fails. Freeing the clusters in that case would leave the extent tree
> pointing to clusters marked free.
> 
> context->new_phys_cpos is updated immediately after a successful extent
> split. Compare it with the newly claimed physical cluster on error. If
> they differ, the split for the current move did not complete and the
> claimed clusters can be freed. If they match, leave the clusters
> allocated because the extent tree already references them.
> 
> Return move errors through the transaction cleanup path so that the
> original error is preserved instead of being overwritten by writeback.

Thanks.  AI review has flagged a couple of possible issues with this
change.  Please check?

	https://sashiko.dev/#/patchset/20260720141944.485212-1-lgs201920130244@gmail.com

