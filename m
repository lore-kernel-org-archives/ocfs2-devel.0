Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED4F27FB2A;
	Fri, 31 Jul 2026 01:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785462065; cv=none; b=qGxiT7KEZ3HpWZuh3EQT4IP8Un2gk6HjzxsZApevyXWMcvsViuSvCrINYuVpIqaHvwSqb+Kshd/7WAJD7lgz45DEA8Qt4qk8SadSAuMFguVTRiComWt15M5cRM/nTmYU9CC0OZiGk3uxW/nd+9+oJ7HQWKEysFadob5otaYXzro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785462065; c=relaxed/simple;
	bh=IMd5qsU35qpWHuULe5n0x9gAcUoK3cNTZbyGvwjiN90=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fYRKFGARBtDi5obx8QZ3dfbGIJeadEcGI1/NRCs29n2FJguNXWsIueNAcMPBY1GZTJ0XTtfX/bhcZa3VryhO1f6bQHvqaNlmZMeaccnjYfgwRGhIeRL84O5TJdPUvlGowOpZszIsnOHjeYzWk3zBcTB9bDJcYUk0KwBrnDz8jpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LW/C94IH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LW/C94IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCD81F000E9;
	Fri, 31 Jul 2026 01:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785462064;
	bh=JeORyz8JMX8+xFz7FLluX9QkXnXtgFdoA36vLqlvDtg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LW/C94IH58fdc9WrLXG/FSwOVSJxvXyWDsdxR7XGHaS5MbrtMKAXCVzT2HIm9ioGM
	 LjWp7/4VrAyHWN3votseUzty4sjILO303VtWrXwfjgLVFQSSxCczR34tk1yvN1zVfy
	 thwznLa+pUbh6ouQjobKP1sbG6TzeUAKhf0UEDp0=
Date: Thu, 30 Jul 2026 18:41:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Roman Demidov <roman.demidov@red-soft.ru>, Mark Fasheh
 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
Subject: Re: [PATCH] ocfs2: Remove redundant NULL check for rec variable
Message-Id: <20260730184103.95a1e280e006e6bbc149ba30@linux-foundation.org>
In-Reply-To: <a62a1071-4134-4bd6-b4fe-5b4f278037a9@linux.alibaba.com>
References: <20260730131507.26636-1-roman.demidov@red-soft.ru>
	<a62a1071-4134-4bd6-b4fe-5b4f278037a9@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 08:44:58 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> 
> 
> On 7/30/26 9:15 PM, Roman Demidov wrote:
> > The rec variable will contain the address of the structure array element,
> > i.e., the address of the ocfs2_chain_rec structure.
> > This address cannot be NULL.
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Signed-off-by: Roman Demidov <roman.demidov@red-soft.ru>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks.  And thanks Roman.

But I'm afraid we aren't supposed to take patches from developers with
Russian affiliations.  Especially those which are on the OFAC list,
which appears to be the case with red-soft.ru.

https://share.google/aimode/UgHJ7ubsy9uflS1Qa
https://share.google/aimode/wpqMe0GiORkYi2meC
