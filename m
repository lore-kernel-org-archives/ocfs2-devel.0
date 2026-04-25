Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA25213B293;
	Sat, 25 Apr 2026 21:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777152397; cv=none; b=hvZmNSRxuengom5zfl/hUU/fnI+gg50tEJssAgDAjQSuI62Ol056AS4a9jb1UwUYTsz92OnJaEbg4qtgB302jQgsw4nmz4k+RsTrEPYpteyyVL81Zag2QvMRWkCjPVvmnezO9iV3eNZ5go9QVaDxmIZ4rU1fvWSnfx5gwZv6D4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777152397; c=relaxed/simple;
	bh=g6TOctfy72nLJbVnJoK1Fy24z5OnqCqBcXJN0hVliLQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=rtAikqmCa41XCpm72aP5MOUgd83HK4EwTbapr7CZKD+j6k1dgpBdjwW+JzX62JiiA5hwHNigOempoeBX3BrjOd15gZcy8fS8mg3iOimcJUjBeJ3t2GrAkyLenbH7LjxBqR/WjL3RLNh1z0eyOmllrpi4mpKjXb5TyAAmCgNcnKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YJkUOXwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YJkUOXwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F22FC2BCB0;
	Sat, 25 Apr 2026 21:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777152396;
	bh=g6TOctfy72nLJbVnJoK1Fy24z5OnqCqBcXJN0hVliLQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YJkUOXwkr1T49QZusf5KUc+kSfhXLH4C7Czxf6f8K4h3eQG7Vg+AH5YMm2/ayv/vK
	 uxGBMyzGTjE7gANzx5GJf4DbzKL1r+Hn1gPuriL4hD98Qjgjqdz1/qY3p3ia/ASGeY
	 IiBeug6lz/swhDukK14S6EQ98Qr9/yYoq2GP4KO4=
Date: Sat, 25 Apr 2026 14:26:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Diogo Jahchan Koike <djahchankoike@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph
 Qi <joseph.qi@linux.alibaba.com>,
 syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com, Tetsuo Handa
 <penguin-kernel@i-love.sakura.ne.jp>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix lock acquisition order in refcounttree
Message-Id: <20260425142635.2ad0300d02ddea1bed94d6e2@linux-foundation.org>
In-Reply-To: <20250714221552.4853-1-djahchankoike@gmail.com>
References: <20250714221552.4853-1-djahchankoike@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Jul 2025 19:15:32 -0300 Diogo Jahchan Koike <djahchankoike@gmail.com> wrote:

> Acquiring the locks in refcounttree should follow
> the ip_alloc --> ip_xattr ordering, as done by multiple
> code paths in ocfs2; otherwise, we risk an ABBA deadlock
> (i.e in the start transaction path).
> 
> Reported-by: syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b

But ocfs2_reflink() does

	down_write(&OCFS2_I(inode)->ip_xattr_sem);
	down_write(&OCFS2_I(inode)->ip_alloc_sem);


