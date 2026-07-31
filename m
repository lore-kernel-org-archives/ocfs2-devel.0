Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453433563E1;
	Fri, 31 Jul 2026 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785522098; cv=none; b=VjlHazj3qZiynYz2NRDHVlaHQOpPQ3pIseafTS4j4T70RUnDkZESeZoXWVRzNjBjpLn5L6+YaUiZkrg1/BF0RYskEEOSeDH5cpvu0j58OV31PeMezuzOnq0GvGhvOE2xy3afApVerNh3kG3Sr4UtC2R1U5dd4YkhwZx1DABbJ1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785522098; c=relaxed/simple;
	bh=VjlmuI/488lSMKDuBDkMfxNZcZx4999VmkXjXle5YWA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=H678mklNuTHpFZfRgrBZW5X1C7y+RbgzjaCfSzdiohH8UB2Y+nezUfs1Mq9G5PlAyt4BpMifpAnoLTQDNzUODQcBsY8KnRx21DQMrcyszxZvhiGrclfO2JmYq1+MBRciOGjAJdLqE8fBHN+RPq4zbaMxsMjPfu6Z3tn1HhBwHS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h46tJikx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h46tJikx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B956B1F00AC4;
	Fri, 31 Jul 2026 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785522097;
	bh=EVCLcMEugF0XzTjrfIZrBVZJSGrWomySnH3ay2+rCos=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=h46tJikx/4Y+kQjoIzGy7lCr0Ro5+EVGfGkIK+3c/WozP4PxTevO2MNOz/GquV7CJ
	 T4eHfsGAz3Y/YxmxauHeNJpMH7nOLLdouboC5O4hShYIfG6d+6QQ4Q9IfqDyScajYl
	 lEL4hABnlk9doWZf7PldUsbGJTAB0AHkYIbKxeNo=
Date: Fri, 31 Jul 2026 11:21:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Heming
 Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in reflink
Message-Id: <20260731112136.803da03ad3dd3ed119e88262@linux-foundation.org>
In-Reply-To: <20260731113425.4130293-1-joseph.qi@linux.alibaba.com>
References: <20260731113425.4130293-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 19:34:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> Lockdep reports a possible deadlock involving ip_alloc_sem,
> j_trans_barrier, and ip_xattr_sem:
> 

Cool.

Sashiko said a couple of things:
	https://sashiko.dev/#/patchset/20260731113425.4130293-1-joseph.qi@linux.alibaba.com

> Fix by swapping the lock order in both functions to acquire
> ip_alloc_sem before ip_xattr_sem, consistent with the rest of the
> codebase.
> 
> Fixes: 09bf27a00020 ("ocfs2: Implement ocfs2_reflink.")
> Fixes: 8b2c0dba5159 ("ocfs2: Call refcount tree remove process properly.")

Should we backport this into -stable kernels?


