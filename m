Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA694AA597
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 13:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441219; cv=none; b=tgnm6tKq04hbWDm+5PuocwseHrGY+/ZrZotlmgKKpDyzUx6imX9/LMLIjARdyT5rKnt4T6rKCf5MkuF8N8a5RYqotcz8XhnmxcsIEomk00LoJtVh3oDgCH88FR4hFuLgTEvVVB5drgqooUttvZ2K3ySiyC1MiO2wy/l0l/TZnGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441219; c=relaxed/simple;
	bh=ONZsj5jmua+TvKAYv3gjEVEb77OuCLqCK7sd7KWFBb8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LNl3NQGZgfqgKnzxmdYfjDsiT4O5cJwXKe5n/qePkq98WB+e53Rj36B/Zm8Q0kxkwqzP8B1YSQaj9ZGiWPXFYoaTXfBgG7EOCTVQsnMp3ELZZVviZOJOMgbjhpkk9rE7l6NDc1RU/+/aDXSd5TRB/KIiXTatSpHXwUP63ISZ2kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KR6hKhGV; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KR6hKhGV"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788441198; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=bUd52YBr6WnPR1aGhEESuPmA5WwvLiDROmDwXm5K/s4=;
	b=KR6hKhGVpYKgctlyR05oBTvlBsGWHGt9C3lxOHbml2bdW3o05ueELfsmaYf+rxtGYxmJfCKjxE+ykMMp/Yg7jPhLm8GgiqmTMXoNGoCv1Ff0Q0iRHZTHBoRc8AwI25T/1xv8emUwDfEAygXUf6BJ5dmoIETX2OtXaHpPllY6gg4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XAG2x2o_1788441195;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAG2x2o_1788441195 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 21:13:16 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ocfs2: reject inconsistent xattr bucket during defrag
Date: Thu,  3 Sep 2026 21:13:13 +0800
Message-Id: <20260903131313.2396208-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260903131313.2396208-1-joseph.qi@linux.alibaba.com>
References: <20260902124109.27775-1-joseph.qi@linux.alibaba.com>
 <20260903131313.2396208-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_defrag_xattr_bucket() has two mlog_bug_on_msg() checks that
assume the name/value pairs in a bucket are disjoint and that
xh_free_start is not below the compacted region.

ocfs2_validate_xattr_bucket() only checks each entry in isolation,
so a corrupt bucket holding overlapping entries, or one with an
inflated xh_free_start, passes validation and then hits BUG() in
defrag when a setxattr triggers it.

Defrag works on a linear copy of the bucket and does not touch the
real blocks before the copy back, so the checks can return an error
instead of calling BUG().

Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index c71fa7983b73..e6c49adaac8a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4804,16 +4804,22 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 			memmove(bucket_buf + end - len,
 				bucket_buf + offset, len);
 			xe->xe_name_offset = cpu_to_le16(end - len);
+		} else if (end < offset + len) {
+			ret = ocfs2_error(inode->i_sb,
+					  "Defrag check failed for bucket %llu\n",
+					  (unsigned long long)blkno);
+			goto out;
 		}
 
-		mlog_bug_on_msg(end < offset + len, "Defrag check failed for "
-				"bucket %llu\n", (unsigned long long)blkno);
-
 		end -= len;
 	}
 
-	mlog_bug_on_msg(xh_free_start > end, "Defrag check failed for "
-			"bucket %llu\n", (unsigned long long)blkno);
+	if (xh_free_start > end) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Defrag check failed for bucket %llu\n",
+				  (unsigned long long)blkno);
+		goto out;
+	}
 
 	if (xh_free_start == end)
 		goto out;
-- 
2.39.3

