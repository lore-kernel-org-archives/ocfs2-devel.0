Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0BB37A486;
	Sun, 26 Jul 2026 04:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785038540; cv=none; b=U8mgyxZXhr1j+2K7AEB7t2B8fkXjHojX/y42Zb9SQPKPib8bJQgpLU3JLS/OvfhNV/TpLu/1+EK04BZbkrtzoweATHXkGuZszZKX/dupkyMN2HfKv5AKW0y1MgpDGxUESgJJ55IwOD0yEyupWCqjrut6wlSrFJWYGHsqr4AjXIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785038540; c=relaxed/simple;
	bh=49zNO2fyq2kG+J/guIXVHb9qJU3dnp8ocpSeTGRjkAg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=qPNlF6qJE71OHpYAXCXjLY6rrpu+xLtdtasU/IaX8wWLJ9vIJKcUeIK/vYdxS9gOAMcuZcHRfES9yHiG8ZuF+FqwYi/zWr5FiotRbZUH3v9dyAr1LGddPn80GR2yL7bgL0SreMEzC90g5zfngjyodQ6U0AIuBP+T/hPLDjFecjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eEHwvD3d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eEHwvD3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672A51F000E9;
	Sun, 26 Jul 2026 04:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785038538;
	bh=Kj/CYyRO87Sbu//nTiEbDmEddMtw0wYz9NJ5vrpz4NA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eEHwvD3d3TwAG2pRzc4ZCTNL1foJavOVdS+YQYyQrSikZ7oXV84Ba+wx9FeCDEty2
	 ypZTJTBVm3fHUVSCgSLroIzAI6k4q6jMlNntvoB3u2F3Cl2YJ8To/RByXuLG2RfeEE
	 Ce/Pg9uJN8yroArAHgbxnWMwxSLznqhh8jfvfS1s=
Date: Sat, 25 Jul 2026 21:02:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph
 Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
Subject: Re: [PATCH 0/2] ocfs2: harden heartbeat teardown races
Message-Id: <20260725210217.8880c2417a832cad67b0d9d2@linux-foundation.org>
In-Reply-To: <20260624095310.763763-1-zzzccc427@gmail.com>
References: <20260624095310.763763-1-zzzccc427@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Jun 2026 17:53:08 +0800 Cen Zhang <zzzccc427@gmail.com> wrote:

> This series fixes two OCFS2 heartbeat/o2net teardown races found by
> KASAN.

Thanks.

Having two Fixes: on [2/2] is quite confusing.  Fixes: tells -stable
maintainers "add this patch to this kernel version".  So what are they
to make of this conflicting advice?

But both Fixes: targets are from 2016 so it doesn't matter.  I'm assuming
we don't need cc:stable on these, but that might be wrong?


I'd really like to see Sashiko review on this series, but
https://sashiko.dev/#/patchset/20260624095310.763763-1-zzzccc427@gmail.com
says "failed to apply".  

I don't know what its problem is.  It tries linux-next and
ocfs2-cluster-keep-heartbeat-local-node-stable.patch has been in
linux-next for over a week and both patches apply cleanly to linux-next
for me.

It's a shame, because these are two quite large and complex patches to
old and very tricky code which hasn't proven to be problem-free in
recent times!

Sigh.  I'll poke Roman, see if there's something that can be done
longer-term to improve the situation.  Meanwhile, Joseph, are you
really sure?
