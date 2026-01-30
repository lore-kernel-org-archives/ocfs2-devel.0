Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AC9335564
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 03:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769742813; cv=pass; b=cyy+BE6XfbTusT3cR+vIx9LCl0OYiaDYqhhRWBlFAhtuDxyfz6ufwLXhfxqu/6bmwZqbvDqIR/l92WNG3qlx7f4RuugceyLVRNLOqZoWRkFUuBUYnOjBFesXc1Q7pfpcKgJdkrtZK5bNE1v+ByvkjMybx5LNMeSGra2V991QDhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769742813; c=relaxed/simple;
	bh=M9shs0LLYp7UYlQ6MBy6Z9L4GID6f0Mcb70Nm7zMlAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKJev7lWbfGbYJ/ZKLiphMXKOV6/yJrQOQTNrgNEL+Ag4Sro2A+lhCkbNYsxmnqvT9o1itej3hDCv0xQnls9WQYMU5H8TYU1HxcwE+dN+vSLMJ48KenaXFIY3KBFXocFQQiRmfM7cYVEqGgzmJFdA/8lZ20tOdkGE7DgHxOQd+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=NDEIBTbG; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="NDEIBTbG"
ARC-Seal: i=1; a=rsa-sha256; t=1769742782; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=TTR00kvrTq/AbSQOBwYlF11rFfBxIeaNOVzGAjy2sGd3qKOsNZqLkoYuElBezujRrz1nYq27YS3PuyoBtvKbGDjfa7WmeAM3EaswgzI30iPNW8vI9XiErD5p4lfM5HS/kXZdJrbdA+vrA7vJqHCEC+hzdixiKfW+J8hV7SsnVGU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1769742782; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=met3wfkUbDNSSlILXa+wt375qqVlaJlyQ4RN4JogjWg=; 
	b=djvtlyJxxt27t4BAj3HNw9sc820R8LKXDRiij4OUtHX4wk57kScA3WraCx6ZkC/DRT7gA/Q64zTgXMl4zCopDDvY8yzsbH3bPGInJhjxNPqwGq/RmMz05fPj/hpn0E0jGEbg+o8ATZJQR/KpmlsxJ3chy5oQaXrmuabH+sqMcJo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769742782;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=met3wfkUbDNSSlILXa+wt375qqVlaJlyQ4RN4JogjWg=;
	b=NDEIBTbGxWkrColg2jDciJkbYm7iXT2wzrSwoBP1YvizSr82Mcw7a2MisQZ+waUM
	wpJpNv7zTjVUVn8YvPJpi2rjn9za/fCG3RmUyNA/tg26Lgsu/V8IJJ1wr3S7wQeUrd2
	N1gkdO1UphFshqrVoq+fiaI9Ie+KfEGGX19efiAs=
Received: by mx.zohomail.com with SMTPS id 1769742777273880.9267174469965;
	Thu, 29 Jan 2026 19:12:57 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Li Chen <me@linux.beauty>
Subject: [PATCH 3/3] ocfs2: use READ_ONCE for lockless jinode reads
Date: Fri, 30 Jan 2026 11:12:32 +0800
Message-ID: <20260130031232.60780-4-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260130031232.60780-1-me@linux.beauty>
References: <20260130031232.60780-1-me@linux.beauty>
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

Use READ_ONCE() for these reads to correct the concurrency assumptions.

Suggested-by: Jan Kara <jack@suse.com>
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/ocfs2/journal.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 85239807dec7..7032284cdbd6 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -902,8 +902,11 @@ int ocfs2_journal_alloc(struct ocfs2_super *osb)
 
 static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
 {
-	return filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
-			jinode->i_dirty_start, jinode->i_dirty_end);
+	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
+	loff_t dirty_start = READ_ONCE(jinode->i_dirty_start);
+	loff_t dirty_end = READ_ONCE(jinode->i_dirty_end);
+
+	return filemap_fdatawrite_range(mapping, dirty_start, dirty_end);
 }
 
 int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
-- 
2.52.0
