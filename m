Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BB42E62A2;
	Sun,  1 Mar 2026 01:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329986; cv=none; b=lr9sj3vFAKF/1UDchAL9NReYCguES247Sp/mK/mcCaeAGeOE18sXTVIshLYFIpb/VchwFVJOeQUKwUmG/I0KbVeJfhxqBP09NzFfF6xmPu/shYEBGpTu0G3XqsisWjY+Ul9H1HyhEvf20vMlS9/A6tchwGpFtlSve/CYPvhnDlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329986; c=relaxed/simple;
	bh=+w8Rq6Gyk0LT4U9vWhHddWEA/x6NsNEHT3+t4BLvqO0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=utJPnxpXxa7Ii1cipZGgjuYXsnjeZoSwhQCFpoezj/wzmzUDVMEzPoGhwNBj1dfuq1XMoFUBEa6opSqsBwXqZqqwN46J1kZ+w6py2O+Pw8iil/eufDBPlfg6hFBB9/SwsoaBsCFVBa3wb1XbP4PnEtw4Cj9W59wKXp7HUFSO9Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnfyOl7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnfyOl7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552A6C19425;
	Sun,  1 Mar 2026 01:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329986;
	bh=+w8Rq6Gyk0LT4U9vWhHddWEA/x6NsNEHT3+t4BLvqO0=;
	h=From:To:Cc:Subject:Date:From;
	b=gnfyOl7ND8Gjp03nxAdBcs5q2XdC6aSx/42fCn0L0Agxn8eXST2uZHOiHyzf15dRi
	 8APs1jugEllnjHPmuN9zpqPPHQYzDQy57bLf6/nbzKnU/sRFCuVGuF/sQVhVREoLdc
	 9t1PPcrHS3T2iw54/GnsdfF9NBH5sm6ybpHDIBpBt8F8cIDCahzUAygZZsIgiy1Td/
	 Ety26jvNbH8Tg2VDdZpx0SjXjRMuohObBqvO3vxW9UNsSVdV5XOJ8Q6TCUJG5ebZC+
	 28d88e61wQXAURPlwld4SD9w6v72tl1LH6DXGMEOEY9Ggsod/vZzWsH+/gzJ2+e7na
	 2Dh2qcF7FOkMw==
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
Subject: FAILED: Patch "ocfs2: fix reflink preserve cleanup issue" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:53:03 -0500
Message-ID: <20260301015304.1719729-1-sashal@kernel.org>
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

The patch below does not apply to the 5.15-stable tree.
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




