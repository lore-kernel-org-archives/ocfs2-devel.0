Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E641DDC33
	for <ocfs2-devel@lists.linux.dev>; Sat, 30 May 2026 02:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780106463; cv=none; b=gb5x/iblpJTmHu/RrgbSh9HrbK68nCtUo0k1woa1zwYreyvtZO0PB+E8Q7yfd/0OmVB1XukJmnDBwNjv49k+MYKDcylDzF4ojReuZRSGAa80KYtFT8jzTKz+DwBNP3/rDhldx3Tk1KctblmuBbIN3HWlWFc1Mgf22X57WGiuFzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780106463; c=relaxed/simple;
	bh=llSq+RQxu9S6BxwXq70aOO3+68reTd+yegVBGihp6RQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=e1b8Ntwp9Pz0b8JdbrNN3eyHHY3o5eJiU2GiD+xCU7OTdQb3EagUva/CiaxPyXe7/vQzQN8Y6kFK4DPQN3NgV7oXc7ghqpKQKQ99CtvzQVum5ule0W1TD/H795Xtka9KpyoqldtLhJ/uAG4c8ETZE1nJvuMKbbg+H09qEAckaIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W3Qox5Sx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W3Qox5Sx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDED61F00893;
	Sat, 30 May 2026 02:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780106462;
	bh=6t+cwzXCVDd4LZvXsgNS2dl4sTRCKmNGku4BdDxGozk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=W3Qox5SxteLMIr6PCRLjSso+y1s3xhlcBhlAxFdSORhKKjh2N9ibCr5OY7+NX1ARs
	 mVOHERb2FQjdwE+5obwWiVxUVjGbYUFIo5aP75IEt5AYNIEX7vFnOnSUCkIQnu3OGk
	 EC02FebW5qalg3Af9kISRqlOqWgs7WHblBSck1X4=
Date: Fri, 29 May 2026 19:01:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Joel Becker
 <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>, Changwei Ge
 <ge.changwei@h3c.com>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: fix buffer head management in
 ocfs2_read_blocks()
Message-Id: <20260529190101.a72cec8337c1b5e908e3afa0@linux-foundation.org>
In-Reply-To: <20260529094128.494293-1-dmantipov@yandex.ru>
References: <20260529094128.494293-1-dmantipov@yandex.ru>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 29 May 2026 12:41:28 +0300 Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Cc: Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>, Changwei Ge <ge.changwei@h3c.com>, ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, Dmitry Antipov <dmantipov@yandex.ru>, syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com

fyi, ocfs2-devel is not among the mailing lists which are monitored
by Sashiko AI review.  To benefit from that review you may choose to cc
linux-kernel on patches.

> Subject: [PATCH] ocfs2: fix buffer head management in ocfs2_read_blocks()
> Date: Fri, 29 May 2026 12:41:28 +0300
> X-Mailer: git-send-email 2.54.0
> 
> In 'ocfs2_read_blocks()', caller should't assume that buffer head
> returned by 'sb_getblk()' is exclusively owned and so 'put_bh()'
> always drops b_count from 1 to 0. If it is not so, buffer head
> remains on hold and likely to be returned by the next call to
> 'sb_getblk()' unchanged - that is, with BH_Uptodate bit set even
> if it has failed validation previously, thus allowing to insert
> that buffer head into OCFS2 metadata cache and submit it to upper
> layers. To avoid such a scenario, BH_Uptodate should be cleared
> immediately after 'validate()' callback has detected some data
> inconsistency.

Added, thanks.
