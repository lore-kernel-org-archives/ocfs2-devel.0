Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9FC21D583
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Feb 2025 08:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739520057; cv=none; b=lmiBWBAUYgfnwYYJp2fb9RxeyxbJLx0D5R6vnd5OzXFwTOlOvdrh5XP4Eah75urCU4DMeXByTwUfWc8tSvBk4hjqKswxa6DwvpY3E5NFJBkuadSwqjdxAgVJNDKYR81+044nRQoE1ppE08zSJIjHwij0RTvWa4IH1BD0Q7vP+yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739520057; c=relaxed/simple;
	bh=7qyE1rUAjEWTLeVysUNMu5l5eIHUWPtaoHVSPNXQJQU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fjBilvsP29IsoYdJVPHAtymS6O5UT3jE8salPbqkTVExBdB8xqgTvYm5rsBjV+vxRXhT9S2n0XQuiH/2z6Xqcv/icA7jMJO2/Qx4EwaxrhKCsBLnnYnVJ21Uzmw/hR4nk6kXtJ5o09Xt6BZMYrJleo46L1Yf2c1mqbi2LH7Fd+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [178.76.204.78])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 241F62339B;
	Fri, 14 Feb 2025 11:00:50 +0300 (MSK)
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
Subject: [PATCH v2] ocfs2: validate l_tree_depth to avoid out-of-bounds access
Date: Fri, 14 Feb 2025 11:00:38 +0300
Message-Id: <20250214080038.735185-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
In-Reply-To: <2d12eb70-5fbe-415b-9970-78af2ab7945c@linux.alibaba.com>
References: <2d12eb70-5fbe-415b-9970-78af2ab7945c@linux.alibaba.com>
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
+		if (unlikely(le16_to_cpu(el->l_tree_depth) > OCFS2_MAX_PATH_DEPTH)) {
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

