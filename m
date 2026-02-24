Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85C436A025
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Feb 2026 09:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771925146; cv=pass; b=n+cKZ9AuCFXZuCZzw49mzO2eU0aufDo2nIrTp7O9Of5MRmGsTsFmGKrs0AYdIBZsCzBFfMoPO6TC3Bxu6UD8ke7NvvZZTWrvSHq/7g+kGvOGAuNOCVH+8xxMvi7mH9zO4MsFwxgCB+QD0XmFC1JGFL4Ux2OapuTtqOWE5AzQajU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771925146; c=relaxed/simple;
	bh=6HnR2vQVyFMxEanvtrB7UYHlNmO1A2TCYspJNnFuYxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mcpx1hrokaXW9sXvIOpD+AL1aZb38CIh6fi+0o1uJk07WhqWHzCOqGIkCtF4P22SAN0qyfY5Tz0gR/k0ksS99VjDSd+dCfCGRy3DyP39sHcoOLljrjnhNCyy36gMzNxXnxwChRe9nz9Qrmn/F9wkA8GaBgKbtvbmVspjCawTbpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=tJOqJMyi; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="tJOqJMyi"
ARC-Seal: i=1; a=rsa-sha256; t=1771925101; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gYKI749D5gnkusH9m4h5yE5lm+r0gaD9vups5gCzl+D/0udmui2IRtvOEOc/PeeOS2dddYCrxcQAL5cOjpC8U5Tp+XLW0A9ri/20CoPgHj5cROyoYVlnWUh+BK+wmhbtTn4ayin+OBVoZTHfo8Ufam8eAv7DWiKigyrCk26jFIY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1771925101; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=i4ISv/Mq3feuc2xrr0ho5gyou48ed2HrxZS5FR03aSY=; 
	b=Ubp4CqatKC9rnHaHsrLKbacG0G2Mw3/mpIMnBQgaCJLa795/x5Rspmwwg2l3uaofSnGpr2dgNE+IHJiM//p5nFjhPpPi+v4qbZjeclG5a445ENhPXqxi90IPpkI+Q4qbVyGnV12IcaRQDjB6IUUA543s5ARLUIdQcnCfyb+WROE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1771925101;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=i4ISv/Mq3feuc2xrr0ho5gyou48ed2HrxZS5FR03aSY=;
	b=tJOqJMyivEmJw9bor3La9WsQh/aRg3xYNTxDjvxMKhFW75uYx6wdI/qYG6ANr6Fv
	Tpsc5ioRiFvaKnaQbv0lxhAaqFNkAKq0VQt+HZX/aFCzO8JOP+opvlK5H6+nihAjewA
	c9dd3k1gG79p3KpeUrXY32YJqKzHfUTC6nNoQk4M=
Received: by mx.zohomail.com with SMTPS id 1771925100358315.28790750738244;
	Tue, 24 Feb 2026 01:25:00 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	Mark Fasheh <mark@fasheh.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH v3 3/4] ocfs2: use jbd2 jinode dirty range accessor
Date: Tue, 24 Feb 2026 17:24:32 +0800
Message-ID: <20260224092434.202122-4-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260224092434.202122-1-me@linux.beauty>
References: <20260224092434.202122-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

ocfs2 journal commit callback reads jbd2_inode dirty range fields without
holding journal->j_list_lock.
Use jbd2_jinode_get_dirty_range() to get the range in bytes.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Li Chen <me@linux.beauty>
---
Changes since v2:
- Use jbd2_jinode_get_dirty_range() instead of direct i_dirty_* reads.
- Drop per-caller page->byte conversion (now handled by the accessor).

 fs/ocfs2/journal.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 85239807dec78..68c2f567e6e1b 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -902,8 +902,13 @@ int ocfs2_journal_alloc(struct ocfs2_super *osb)
 
 static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
 {
-	return filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
-			jinode->i_dirty_start, jinode->i_dirty_end);
+	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
+	loff_t range_start, range_end;
+
+	if (!jbd2_jinode_get_dirty_range(jinode, &range_start, &range_end))
+		return 0;
+
+	return filemap_fdatawrite_range(mapping, range_start, range_end);
 }
 
 int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
-- 
2.52.0
