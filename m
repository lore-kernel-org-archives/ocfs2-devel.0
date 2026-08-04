Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4548427876A;
	Tue,  4 Aug 2026 23:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785887163; cv=none; b=QHc4t0HEfSvqhD7XJRIFtqUT3/JKDJcpVFu9CPv3qkLy/hnmsg4J3sI5k03DtBO3zY65WcsnNBSmTYOgnW2TW1LdUpePRJTpagMSGTVaOUpLG9pySWOyHcrgugFHHtX+nLwXfrafUGJdhzfyhsak8i4MmbFHTHhya3lIae0D9wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785887163; c=relaxed/simple;
	bh=GhdadLDSeT3S451tJMeeXYj/r5d03FbU3MzwrQGTy20=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=R9HV5G6/q1t58mhHoOY1zJsAOCpDx6E82Vuog1AGKNF9sSyz3ht0qfoisMBj9T/uDUswpacVyX+JeLqvfdGgexrMoFH5hiukHxF9Azp1XHQgljKpB8Od4KmmdQ7kz7Rb1HbvAP9RS8ALneXSQsj27A8sZOQHpzqCdxy3uzXLcLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sP4IDR92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sP4IDR92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1091F000E9;
	Tue,  4 Aug 2026 23:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785887162;
	bh=zbFNwSxHCbe7qsUFSvQh7UbeLmGxMU+19xHxb3EsmZo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sP4IDR923j/E2kQlUQy86c+5YtIMo4a4g3Eafh/p5aJOkjyfD90TZmby3vxQs11E2
	 equPzIDZvJlZZ4duKXjD5NlLXj8NgyBTgckQNFReM0jFJCCuWkUX6G1VW5d0R3hOHy
	 diXRyPzl9mFdhiV7xBFCHTh2eCB8vsxGnCvTItTE=
Date: Tue, 4 Aug 2026 16:46:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: syzbot <syzbot@kernel.org>, Krystian Kaniewski
 <krystianmkaniewski@gmail.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, syzkaller-bugs@googlegroups.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot@lists.linux.dev
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in
 ocfs2_init_acl()
Message-Id: <20260804164601.2a5f2a95f53f62b43a50e601@linux-foundation.org>
In-Reply-To: <f98ff905-74bf-4017-a673-fd28f30f11d3@linux.alibaba.com>
References: <4094de06-9b69-4174-b2ee-08126dffc693@mail.kernel.org>
	<f98ff905-74bf-4017-a673-fd28f30f11d3@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 4 Aug 2026 14:36:02 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> > Additionally, remove the `ip_xattr_sem` acquisition from
> > `ocfs2_xattr_set_handle()`. This function is only used while initializing a
> > new inode that has not yet been inserted into the inode hash or attached to
> > a dentry, meaning there is no risk of concurrent access and the lock is
> > unnecessary.
> > 
> > Fixes: 16c8d569f570 ("ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute")
> > Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> > Reported-by: syzbot+4007ab5229e732466d9f@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
> > Link: https://syzkaller.appspot.com/ai_job?id=cc75363d-c672-499e-8fc5-44bcdc1cee39
> > Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks.  AI review might have found a pre-existing bug:
	https://sashiko.dev/#/patchset/4094de06-9b69-4174-b2ee-08126dffc693@mail.kernel.org
