Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C082F7082A
	for <ocfs2-devel@lists.linux.dev>; Wed, 12 Nov 2025 18:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762970564; cv=none; b=H7FjkHRiOrZlyCDXNu67sGFzFc+CF3YKuiAo4BPRmyAP31gld9MZ9ReVToRpgK6iFCJ36VlO1xHCgKDxqNR0fOq7eFoWeL+aEtYgsJHs6+c6JlYG+8XXBvoAsLZq0jipNlKB+suxjRxCG7yI0D/knzPeoqDl/Ed+4hX4uoWdj2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762970564; c=relaxed/simple;
	bh=v9+MaYiGqWc7ENv1KY+yApCBMOuKKk+qIy3qvEUnvq0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=lQ/D5Fu2iUoW11XBn3E9W42Zdu1VpHK4zgJ3oXw9g8I6GYi0wPWG9AXvxUIcwEowv5tYYGNL1rPEG6cYqDZgwHlEDhKwSGU2saNFSWmtJ90zJO2XdVuMzEgU/W3lQH2VKMABaEY+UrJi+VIXg9Bwxgr4fZTKHpsXM1gnWQW0JG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WqBLZeA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WqBLZeA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B9FC4CEF8;
	Wed, 12 Nov 2025 18:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762970564;
	bh=v9+MaYiGqWc7ENv1KY+yApCBMOuKKk+qIy3qvEUnvq0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WqBLZeA3qv1TafLgIFwkXYeiY3n3z7WWdk+3g9LK11VCyaOaZ0Zd+uHBAEOucZFQS
	 z1tx1cwIfTNtLvfn8GvyZI7YqeemY5BM5Zp2rVS9DI1DGz++F8256R5egb0RMsOoB2
	 wz3j0/ymsRZOJ6NU77s6DuVY/h11b+vQO8RZ5RPk=
Date: Wed, 12 Nov 2025 10:02:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Dmitry Antipov
 <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] ocfs2: relax BUG() to ocfs2_error() in
 __ocfs2_move_extent()
Message-Id: <20251112100243.65616ed4faa94d8270aea61c@linux-foundation.org>
In-Reply-To: <aRRFtEa26UfufDLd@black.igk.intel.com>
References: <6be1e189-b974-4666-add0-5b0fe7330fb3@linux.alibaba.com>
	<20251009102349.181126-1-dmantipov@yandex.ru>
	<20251009102349.181126-2-dmantipov@yandex.ru>
	<aecb2ef1-ea56-42d9-8bee-a2760de66de1@linux.alibaba.com>
	<aRRFtEa26UfufDLd@black.igk.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Nov 2025 09:30:44 +0100 Andy Shevchenko <andriy.shevchenko@intel.com> wrote:

> On Thu, Oct 09, 2025 at 07:12:15PM +0800, Joseph Qi wrote:
> > On 2025/10/9 18:23, Dmitry Antipov wrote:
> 
> > > Reported-by: syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=727d161855d11d81e411
> > > Fixes: 8f603e567aa7 ("Ocfs2/move_extents: move a range of extent.")
> > > Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> 
> Andrew, something wrong went into the repository. If you look at
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-stable&id=63b0c2c8cd29f0b516bbe6bb6580ed1b0246996c
> 
> looks like a one off case, as others seem okay in the repo. I can't see any
> suspicious pattern in the tags,

doh, thanks, fixed.

> but it may be a very subtle bugs in the scripts
> you are using.

I do quite a bit of stuff manually - there's so little consistency in
what I receive that scripting more than I do would be a nightmare. 
Plus there's benefit in actually looking at things.


