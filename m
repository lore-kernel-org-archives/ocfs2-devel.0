Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792863431;
	b=FXRnuykgsCnix6hT/sO9Yf/1GcxgQ2yHX4cqG25rUid4fLh5QnqYLHlmj9P9L1V242rN
	 Sj6tGpGpGqx9owfYzy7Na2QFR/r82y481wdp73DuVeCbMnEV6pXgzxrXSlnG7HzQwF9iz
	 Jr3hosliZgdiO/ZanvlR+rZyugKGsnBCcFuHmAiSHrofzn3sJhAIAiRjt34vSTu3IXwkk
	 7QLfTS2hdqTxo+j70TLCE9IsHRrmsl2A2nLicNdhmAzxHByECxpTzITtFOSKyhfXhx+7T
	 VM3jE/slQbwOzNggBeeHY4+rGCK8mTE5nohgxHNvZbJOToYbzGVhdd6JffX/NeE1tTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792863431;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SRWXm8At6b5HdVZInJapA+0lJxYRvCuweq82q6D9PzQ=;
	b=MDgFxkqKvoJckCWhuuldJuZwMGz904p3D58FX40gNiljENBxDXEMIJ+1sXgEWHQEQkHl
	 jzsvPkrvQ5LbUNb10zmCSQ4VaCobvLeuGZr0qYURNkBDvsz5WnI9rytFHKOswYg5rviwt
	 0HZlcxVxkizxh63+4ahrwJjGLFL8ibXk6VN+YBIRUX38EzsudrRPG5KHRkIqnqOAyRjW3
	 092cf57ow0Le2KjNQoXhiQ60/4c4uK30adEAFE9aMXGR0WPIEnn4kXbopHZqb+x/RqA9O
	 bvlUksB+HPfR4E0FsdAl7nzWRJqsxZfEPSkoMstj9VJTSnoQTDy7O+IQphjia17DEMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jVop9g0h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AF2606A31A;
	Sat, 24 Oct 2026 17:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jVop9g0h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAA41F01825;
	Sat, 24 Oct 2026 17:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792863430;
	bh=SRWXm8At6b5HdVZInJapA+0lJxYRvCuweq82q6D9PzQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jVop9g0h4ZI7XcVh03CA+LePOEecISeccoFDLHnCBokcbrRAlQ1j1Ebp9CUTmZq5G
	 c8tSVFOMudA82qQKw7/3No9R/oNpIHGl2LQAV4u+y5ZNuAxRk564cfO9QD4hkUoRWj
	 JEf2DcM4QUINYCZCK3UKPz6Mt/FNRjQTwKJq+4sc=
Date: Sat, 24 Oct 2026 10:37:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel
 Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] ocfs2: fix stale xattr entry pointers and empty
 header reads
Message-Id: <20261024103709.7ada16bbca6403787892cb5c@linux-foundation.org>
In-Reply-To: <20261024151012.1059683-1-joseph.qi@linux.alibaba.com>
References: <20261024151012.1059683-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 24 Oct 2026 23:10:06 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> Five defects in the ocfs2 extended attribute code, plus one robustness
> measure that belongs with them, all on the paths that move entries
> between a block, a bucket and an index tree.  They fall into two groups.
> 

Thanks.

The series is a little awkward - [1/6] is "no functional change" hence
it's upstream-in-7.5-rc1 material.

The other 5 are cc:stable fixes, so they're upstream-in-7.4-rcX material.

That means splitting the series and it means upstreaming an untested
code combination - 2-5 haven't been tested without the presence of
[1/6].

I think I'll just cheat a bit.  I'll keep all 6 together and I'll put
them in mm-nonmm-unstable for now.  After Linus releases 7.4-rc1 I'll
move all 6 into mm-nonmm-hotfixes-unstable for upstreaming during the
7.4-rcX cycle.

I'll add 

Fixes: e39baff18b85 ("ocfs2: use the stored hash when checking xattr bucket collision")

to [1/6] just to make things look better and to reduce the risk
associated with -stable running that untested code combination.
