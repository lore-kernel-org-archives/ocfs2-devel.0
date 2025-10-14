Received: from forward201d.mail.yandex.net (forward201d.mail.yandex.net [178.154.239.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B181E47CC
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 07:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760425917; cv=none; b=XCBeRoqEjNqilPxoreuZ+EhrNH2vkPncc01j2DElw4pmr7+H/XbxgY1MlrqVm2C5y1l9j4qkcQPfuUwMiqK1+DYNqXKG/X3KGIaNWsoiPYocN9Q2WQ+J3vyIawnbqfx5yBrllhqpS+6/XhC8CKsEQ3Ydi7uqRT48apv8iU7hqDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760425917; c=relaxed/simple;
	bh=W5zrwHqd1Okq/951rJ+c9pjRtf75PL05C3TWoKFAOCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ne1huskMUudTk6ifs1Vee+Y2YZO7vrF3vlIl2mCnhdB3H6kz+FF6wcNicqqQmW8trVJJv0cXLXYtd+7l1Ft5e5W+eDHl1E7qMlvD2PXvvlzGeKISp7Ac31xAe3bshQ4r3/z7IYgOqHrYQVEafA6UY1XGYTuaJ4jKL8hB+W6Wz/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=A1BJuQle; arc=none smtp.client-ip=178.154.239.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="A1BJuQle"
Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d100])
	by forward201d.mail.yandex.net (Yandex) with ESMTPS id 9AE1082735
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 10:03:41 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:81cc:0:640:2c74:0])
	by forward100d.mail.yandex.net (Yandex) with ESMTPS id B8207C0062;
	Tue, 14 Oct 2025 10:03:32 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id U3Jm2BULsSw0-WJRqf3em;
	Tue, 14 Oct 2025 10:03:32 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760425412; bh=F3SFskHb20DEag7E5nolVMWRjpSOFa8MTTlB3ZhmaXI=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=A1BJuQlefGsM8W9E6YlPnefd4IEkov2a9jkO+QZunOz641SoimQbbxeZ9z8ep/sST
	 jgxw/JKJvo92pqm3P21urbk5xwa19+CwUPuQnlahhAVfVMSMwg51NH0PtzLYjzgZL1
	 GDqcN7IG5Xg5VqzsD0e0iDLXYRViA36/RkY8Zrxs=
Authentication-Results: mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v2] ocfs2: fix __counted_by_le() usage in ocfs2_expand_inline_dx_root()
Date: Tue, 14 Oct 2025 10:03:24 +0300
Message-ID: <20251014070324.130313-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <9efedaaf-3600-4d1e-9fb7-77f55f1524e5@suse.com>
References: <9efedaaf-3600-4d1e-9fb7-77f55f1524e5@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After annotating 'l_recs[]' VLA member of 'struct ocfs2_extent_list'
with '__counted_by_le(l_count)', 'l_count' should be initialized
before touching 'l_recs[]' with 'memset()' to avoid false positives
from buffer overflow guards when CONFIG_UBSAN_BOUNDS is enabled.

Fixes: aa545adbe491 ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v2: adjust 'memset()' call to clear 'l_recs[]' of 'dr_list' only
    and initialize the rest of the members explicitly (Heming Zhao)

note: since the commit in subject is not merged to upstream yet, Fixes: reference is taken from
https://web.git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-unstable&id=aa545adbe491
---
 fs/ocfs2/dir.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8c9c4825f984..48b092bc83d4 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -4104,10 +4104,15 @@ static int ocfs2_expand_inline_dx_root(struct inode *dir,
 	}
 
 	dx_root->dr_flags &= ~OCFS2_DX_FLAG_INLINE;
-	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
-	       offsetof(struct ocfs2_dx_root_block, dr_list));
+
+	dx_root->dr_list.l_tree_depth = 0;
 	dx_root->dr_list.l_count =
 		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
+	dx_root->dr_list.l_next_free_rec = 0;
+	memset(&dx_root->dr_list.l_recs, 0,
+	       osb->sb->s_blocksize -
+	       (offsetof(struct ocfs2_dx_root_block, dr_list) +
+		offsetof(struct ocfs2_extent_list, l_recs)));
 
 	/* This should never fail considering we start with an empty
 	 * dx_root. */
-- 
2.51.0

