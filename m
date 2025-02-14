Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE4B189B9D
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Feb 2025 08:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739522960; cv=none; b=NggRpGE8oA+sd5zSCohkYhoQedyX8NIQ8LPqSfVqvQ5SEkgfg8iLCR2sF7iQXZPMK5Q0TKCqafq3drP6neZOqthQtbzuQ81JBU70YFnNWtRbQ9VX8zCpEFtt4huIUZKiErd95248BuMGhjF/rFMzXS9hS0jzUFk2Jw8CxY7FhBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739522960; c=relaxed/simple;
	bh=gfPYUhwKYv1yN+ZIi7Gwz/R6bJJpxCjLJcrBc2tzsb8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EwsH5aQRfG7EXwGvzMy/AP8dJ+3oSEXEvEtIhR4ksGn1eawdwRmd4Xwp6VzZAcEGcm/XRMsXbxz3aPD+23u/8QGKBoVFc980MjvWn/Zl4X4rz/jHrKIhKt3R4VXNS0EddY6iOiNVT609pdTXW0N5EbM8dVxVEfFKyychOU58qO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [178.76.204.78])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 85BD4233B5;
	Fri, 14 Feb 2025 11:49:13 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: joseph.qi@linux.alibaba.com
Cc: jlbec@evilplan.org,
	kovalev@altlinux.org,
	kurt.hackel@oracle.com,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
Subject: [PATCH v3] ocfs2: validate l_tree_depth to avoid out-of-bounds access
Date: Fri, 14 Feb 2025 11:49:08 +0300
Message-Id: <20250214084908.736528-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
In-Reply-To: <bb8e95f6-ee91-47b9-82a0-86d576f67e39@linux.alibaba.com>
References: <bb8e95f6-ee91-47b9-82a0-86d576f67e39@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The l_tree_depth field is 16-bit (__le16), but the actual
maximum depth is limited to OCFS2_MAX_PATH_DEPTH.

Add a check to prevent out-of-bounds access if l_tree_depth
has an invalid value, which may occur when reading from a
corrupted mounted disk [1].

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Reported-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=66c146268dc88f4341fd [1]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
v3: Change the condition "> OCFS2_MAX_PATH_DEPTH" to ">= OCFS2_MAX_PATH_DEPTH"
v2: Restricted depth to OCFS2_MAX_PATH_DEPTH and moved the check
    to __ocfs2_find_path().
---
 fs/ocfs2/alloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4414743b638e8..cec8fc5cb8e87 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1803,6 +1803,14 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 
 	el = root_el;
 	while (el->l_tree_depth) {
+		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
+			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
+				    "Owner %llu has invalid tree depth %u in extent list\n",
+				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
+				    le16_to_cpu(el->l_tree_depth));
+			ret = -EROFS;
+			goto out;
+		}
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
 				    "Owner %llu has empty extent list at depth %u\n",
-- 
2.42.2

