Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5866C2EB5A6;
	Sun,  1 Mar 2026 01:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328957; cv=none; b=ekqdOicm2qpLZYMTAqShOzpQXBRZm3RFrzpi7QWO2myqrJQ+a7iy8LJngBPJ29lPr4Dx7jIfwF9S2n+qNpwEw8ESOGF3lgsxaK0zX+uAqnyOWC1mSY7CL8u24NsmBpXPKmRiODT0icudt4Ev6xkVRghPkiwbHfxb96fLrA+5on4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328957; c=relaxed/simple;
	bh=FHqyZkrjy3NcVknmPYcrwFCsqm9qJ28GFnOBVinlato=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fMmpdCqb6AEnnzuV6CYBIEJBZnK4iRvEsBkmduKVboi6CkBAn2OIVAn/Rh9H/yCycZF8VUIW1jHBNf4VduTY3+Rn1ZLulXgu5o2lTxGHey3ViHgtk4HOcEB8N6TPoGw+CErOf0RF0MMXbyOu3NXqfQGPfLtIAG3SyQuYSVfrj5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAq7/EGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAq7/EGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2889FC19421;
	Sun,  1 Mar 2026 01:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328957;
	bh=FHqyZkrjy3NcVknmPYcrwFCsqm9qJ28GFnOBVinlato=;
	h=From:To:Cc:Subject:Date:From;
	b=ZAq7/EGXclWaVRoq8g9sNeHuAmW72ouyq6llxOLQpwVnt/vLNbVd80GxlVMzPhuVv
	 SQj5E9C8+qXPzGtHXsF9keyxBCyw13qcceX6Apgyzt/C+QuGB6TfcqQineS+hy1zJ+
	 FOt27A+lswwMSYuG1PvOhv0CLeLOtH5QopUpAoEcb9H63J5kaMADM8o9BBiszbcard
	 n7RRkTC2M47SqdIKRylNZ641kp+J0px8Br2k83DFlRqaWGSRAa2vvKpygMhoOiDyCo
	 22LxR6WrCXG7MAKbrYPSV9xhQv13YEBy+KfNohG1jYKYtrt1dO9Du+bZSj1njdT5dR
	 t+VrQnI7dHWrw==
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
Subject: FAILED: Patch "ocfs2: fix reflink preserve cleanup issue" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:35:54 -0500
Message-ID: <20260301013555.1695736-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
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




