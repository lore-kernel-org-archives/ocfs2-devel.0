Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91339459AF4;
	Wed, 22 Jul 2026 23:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763830; cv=none; b=gQbWfEUZaRBgfQRc/mqeY1DOt7y9lujw8jC3hyFKpEsXHVE6SDgfl42DGsG3fDhBqmyZFcrl3nwTvfN8HYd4UWzQ0nJV5ErZfWuR3s111yaUZka35BK+Ip6A91UrasrmpYMupzRzMCZa5OHlhEqCgi+25YM41YrgkAvfJNnXQJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763830; c=relaxed/simple;
	bh=qE6EHUIXctlnia2mtJbbU/EZiszBJiZyAch2XItyUwY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=itBthJ9xfeRYXdC1m178rVIIvwdhLQwXbOJ6EeV96L9OyOGJGm3dghS0U4bXV9qZZ4mCufNM0oQyVdKmo1echHVJDEGFnbsKjuq4D8WG4D+R/5DkZhpCijUt1a7E02CbT4FUTB/8S7oMOm+ghnPAJIk8bIaRPgL/Dj2fnWKJHHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KFZVM8qX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KFZVM8qX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29B71F000E9;
	Wed, 22 Jul 2026 23:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784763829;
	bh=M/Xc9laBwLPuA5dewaB9bdJEiv96xvetkci68DZ76zo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KFZVM8qXJTbIJKbPKIpJCM4FOLiaG0e3eT1Fb6vRKJODkQzWfc8XcRaj4f3RezH1A
	 KdioTLg+PcBEM4VZF3gMo+Hz6CtRlMKife1J9f2f5qAUwWB4O4Xa1yT0Ckiz0ijPP0
	 f3QgVjceiTexxILny2Bg3q6hvMhcgS7oghIkiVk4=
Date: Wed, 22 Jul 2026 16:43:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Heming
 Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] ocfs2: cluster: o2hb_region_pin() fixes
Message-Id: <20260722164348.994179ec6c81bdb85c416c56@linux-foundation.org>
In-Reply-To: <20260722124933.430554-1-joseph.qi@linux.alibaba.com>
References: <20260722124933.430554-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 Jul 2026 20:49:30 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> This series fixes three related issues in o2hb_region_pin(), all are
> from the original implementation in commit:
> 58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions"):

Thanks.  I assume we want cc:stable on all three?

(If there's no known way in which userspace can hit any of these issues
then cc:stable can be omitted, but I expect the stablebots will
backport the patches anyway, based on their Fixes:)


