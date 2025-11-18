Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5524E2D8791
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Nov 2025 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763492085; cv=none; b=KUv2BW73ZTQEGvQU1i0etjt5TH/HhLy5GVBzqptx6OOpKnUseFC7MTOfMqDxS/ZGJmxnP1FDGG37solPx/NL6WeRC+n5bQsMY5r4H3VkTsrQegxKl2eo/JgOWzuxRNSoB7SXmoH4Uqtkt02IOQMJ2ZTQs/7Co1qlceL3vtc8aDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763492085; c=relaxed/simple;
	bh=jXbHIaX7uet1qIIDMvxl7L5ZNqmUqivHU/rOIHAZZe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxysxtcKc9Kmzkx8NsIDGjYimUQY5FybCpSVp6Pt2drcTQL+vZOW3FPEC1m16wiyHavQH8HKwaihU3O9i7f70cmgLYEmehi7o9utpn9YhwnTwHIADGybPaJDfwCUG9bGjJNEfJz0IC5nUxETm0Ne2IjBsuKY97owlwTy11wN+1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wmwDAXYK; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wmwDAXYK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763492081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=awvTdrZRKqkX4B7gKJQBbruBviVbQ4oE31pIdPR+59I=;
	b=wmwDAXYKSpZy1XlzjB4rk81KPzBsqqRU3QhGgNiAudy0OAdODsKUs8PfPW9ShUMWsng/qk
	Ji37YHpWKKmWbqGBBkGX1d03BvidG4e7G4FSUyUnIrSHLQgLvLoDSnpTBQCLmMc7eBq2PD
	LU+mX6H9HIac87KLXorAbl3U+3cYQug=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ocfs2: Replace deprecated strcpy with strscpy
Date: Tue, 18 Nov 2025 19:53:45 +0100
Message-ID: <20251118185345.132411-3-thorsten.blum@linux.dev>
In-Reply-To: <20251118185345.132411-2-thorsten.blum@linux.dev>
References: <20251118185345.132411-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strcpy() has been deprecated [1] because it performs no bounds checking
on the destination buffer, which can lead to buffer overflows. Replace
it with the safer strscpy(), and copy directly into '->rf_signature'
instead of using the start of the struct as the destination buffer.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/ocfs2/refcounttree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 267b50e8e42e..c92e0ea85bca 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -34,6 +34,7 @@
 #include <linux/pagevec.h>
 #include <linux/swap.h>
 #include <linux/security.h>
+#include <linux/string.h>
 #include <linux/fsnotify.h>
 #include <linux/quotaops.h>
 #include <linux/namei.h>
@@ -621,7 +622,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 	/* Initialize ocfs2_refcount_block. */
 	rb = (struct ocfs2_refcount_block *)new_bh->b_data;
 	memset(rb, 0, inode->i_sb->s_blocksize);
-	strcpy((void *)rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
+	strscpy(rb->rf_signature, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
 	rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
 	rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
 	rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
@@ -1562,7 +1563,7 @@ static int ocfs2_new_leaf_refcount_block(handle_t *handle,
 	/* Initialize ocfs2_refcount_block. */
 	new_rb = (struct ocfs2_refcount_block *)new_bh->b_data;
 	memset(new_rb, 0, sb->s_blocksize);
-	strcpy((void *)new_rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
+	strscpy(new_rb->rf_signature, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
 	new_rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
 	new_rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
 	new_rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
-- 
2.51.1

