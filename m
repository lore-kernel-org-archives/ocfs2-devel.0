Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E459B2BEFE8;
	Sun,  1 Mar 2026 01:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329486; cv=none; b=PiUWh2JuG+xaL275PIqmI/c9I/kpZUHgxIr6npWEKYnm3gIrGrdyTxYjdeWjhUrPyAhvgZX3aJPXOQKV1ToV8wvYJKGMAZ0QOZ4vW1zcfnOB+wvPkstGChxPZbSKokGyRPGJKBPKjbcexCE/P0YKO9ngEVxwdHkJNcXt+DeT/fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329486; c=relaxed/simple;
	bh=qaQvj7puNQeQmZlZO8R2FlyFM2AU11RAZfELCSUeEq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RkpcX/avuzdrw4NQzpg45KU0f7ixwOYzg/qzeKPk225WfS4Yox+CWcZxbhsBMgbDV5J1Ky0C9hdT6UcY0i+9QxO4DkugV+/tYHi2yQHEXhmvvjOdnUoqrXPFeCaqWuoVXGxO/Bz+aTFgfwJ6c0rNz9n+3S0arDX5OEwidnWd6cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6/mnQS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6/mnQS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13E2C19425;
	Sun,  1 Mar 2026 01:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329485;
	bh=qaQvj7puNQeQmZlZO8R2FlyFM2AU11RAZfELCSUeEq0=;
	h=From:To:Cc:Subject:Date:From;
	b=X6/mnQS2RmiXwOEgAyCOynpXKDgxynG+AKpHQcwno/sZiv2oZbcvi06ddCYNtq8Aj
	 IbFdNw2YPpK9Uk+lmeKnoir+1DIgn4YpDH7hVS3R333RAvl4KA3OZFO2wm6GbBI7bL
	 0Jsh+n8iSyvo/7+6X9Yoyxd2p3IrMeiM9jZ5Zq9R7h5fNMYHhkYLiLuZOcOu+yFqQP
	 gfVEN7iok9z2OxvZ/bN1uZvUU3DPzrYgn/CdE2Nq7pUecgOwwFJ+LZuywRT5oMEV97
	 BhT1FBEfLi6otGMs7P9lywTOU6v77AOV2giI2DauyDjCnPYlt+IztWcCPhDDnSH6gO
	 ZnFt0l1KzvxrA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	heming.zhao@suse.com
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Joseph Qi <jiangqi903@gmail.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev,
	linux-hardening@vger.kernel.org
Subject: FAILED: Patch "ocfs2: fix reflink preserve cleanup issue" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:44:43 -0500
Message-ID: <20260301014443.1707145-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 5138c936c2c82c9be8883921854bc6f7e1177d8c Mon Sep 17 00:00:00 2001
From: Heming Zhao <heming.zhao@suse.com>
Date: Wed, 10 Dec 2025 09:57:24 +0800
Subject: [PATCH] ocfs2: fix reflink preserve cleanup issue

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ocfs2/xattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 5fd85f5178689..e434a62dd69f9 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6395,6 +6395,10 @@ static int ocfs2_reflink_xattr_header(handle_t *handle,
 					(void *)last - (void *)xe);
 				memset(last, 0,
 				       sizeof(struct ocfs2_xattr_entry));
+				last = &new_xh->xh_entries[le16_to_cpu(new_xh->xh_count)] - 1;
+			} else {
+				memset(xe, 0, sizeof(struct ocfs2_xattr_entry));
+				last = NULL;
 			}
 
 			/*
-- 
2.51.0




