Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598633BB57;
	Mon, 19 Jan 2026 23:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768866834; cv=none; b=Hjm+pAKr68je5wM01fHQw2pExwvM71E1j2cGIbvAlOg5Fm8uF1e7vht/kuTvidIiZKUwvRjF4Lgy0XRLQkW5kY/KSimxgJ4u5v489A9ZtfBFLH47zKQ2+hqeQz8BQlO3xE1Ar1iKtv7PgrIGNgfRbEsUlv/fFsEU8PuOjuO6sKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768866834; c=relaxed/simple;
	bh=4UqPqITs3WmBZEEZ4a6PlUWjgjQh/Dm21B520j9Wq4U=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=clNHTyF87xN8U5jrptH8NTnvShPMoxYyTs3M3fZmvGhjF5fDOSmcKpvgbr4bWAh+IjrnE4Ga+ba60zt8IZP27T94Zd9z8Pi/YGDWDDSjQ3wRgxPcxkz6/pi7zUq/We4v4paBCQl/8eZ4QKPxQ1TUTiA9UNkHIfhlCKJfOJgl1yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vkX2Juub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vkX2Juub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD644C19424;
	Mon, 19 Jan 2026 23:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768866834;
	bh=4UqPqITs3WmBZEEZ4a6PlUWjgjQh/Dm21B520j9Wq4U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vkX2Juub2Qk4N/xfcxouDhkji0D1uGoPtkZ3ouKcbaMXPZcHV2f5fr3WbhfGatMhr
	 dvnrNgYujZGa/aNPlIxzldBp7HkyIWZqQTbiwipcMrV/3iCkF9dBqebZicnmmPyX9v
	 iWi7cwcQG8HfYkGMy4iqrWxT4XtDe8FSAOiqMcL4=
Date: Mon, 19 Jan 2026 15:53:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/1] ocfs2: fix reflink preserve cleanup issue
Message-Id: <20260119155353.c52e9ad69538668001833f38@linux-foundation.org>
In-Reply-To: <2ddspqqrnjaf4dsw46cx5h7wxnlmaqpbhhiolrfrn2c63v5txg@deaax4xovu64>
References: <20251210015725.8409-1-heming.zhao@suse.com>
	<2ddspqqrnjaf4dsw46cx5h7wxnlmaqpbhhiolrfrn2c63v5txg@deaax4xovu64>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Dec 2025 22:42:12 +0800 Heming Zhao <heming.zhao@suse.com> wrote:

> ping...
> 

yes please ;)  Some review input would be reassuring, thanks.

btw, I forgot to ask: what are the worst-case userspace-visible runtime
effects of this bug?

IOW, is a -stable backport desirable?


From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: fix reflink preserve cleanup issue
Date: Wed, 10 Dec 2025 09:57:24 +0800

commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by error")
doesn't handle all cases and the cleanup job for preserved xattr entries
still has bug:
- the 'last' pointer should be shifted by one unit after cleanup
  an array entry.
- current code logic doesn't cleanup the first entry when xh_count is 1.

Note, commit c06c303832ec is also a bug fix for 0fe9b66c65f3.

Link: https://lkml.kernel.org/r/20251210015725.8409-2-heming.zhao@suse.com
Fixes: 0fe9b66c65f3 ("ocfs2: Add preserve to reflink.")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ocfs2/xattr.c~ocfs2-fix-reflink-preserve-cleanup-issue
+++ a/fs/ocfs2/xattr.c
@@ -6395,6 +6395,10 @@ static int ocfs2_reflink_xattr_header(ha
 					(void *)last - (void *)xe);
 				memset(last, 0,
 				       sizeof(struct ocfs2_xattr_entry));
+				last = &new_xh->xh_entries[le16_to_cpu(new_xh->xh_count)] - 1;
+			} else {
+				memset(xe, 0, sizeof(struct ocfs2_xattr_entry));
+				last = NULL;
 			}
 
 			/*
_

