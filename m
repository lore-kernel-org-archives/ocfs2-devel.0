Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC09026D4CD
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Nov 2025 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763492085; cv=none; b=D4J8VE15zRBsF+yJebGvmA0XL8oyi/bWhUJKjOdF2Fh4IqxQaFb/M3CUR5+IDoAUU5Nc9qL0g13bVBOIqb2qE/zixYytjAc0b/bO67irtanVHgTXd2F+WYumwLmA42P3YygZswz9AkWRk8SgT+qR2CrqCSwoTe/xTZwj090+9YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763492085; c=relaxed/simple;
	bh=hQARI69KmrvfVX5DvSCUWNenEPR5ZTqvOyk+YVWtkY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n/TlgcktAWKfJIjMG3krwZ3vIQBredR4BiDVNiw859GjmxlZWJIcheu4x4ARKxTgt29Ux3J5I/S49KhcTUoIaJ0a0PT4dW9J4OkYgoPfLjOnWXf3C7Wcw+mVl3YvHfy+6QLZLa+gvjYI+piHGT7rGnDxrQTZ/sMv9QLtoUYjhVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mw3r561u; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mw3r561u"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763492080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2GSjmkqdY0DP3rJAj+a1h6ecNefsWgMbqlfXfq8hMHQ=;
	b=mw3r561uJAjIGj8V2EowoNmfSYZZnwHruW4J1lsdbOYTzmVFdStYMasssr1hAmzQySv+Lr
	Q2kwyUBOamxjQvV6CFSvn1yKe3MO18L28HNSHp0jmKdFLKDeVE8bhMyHajGCzkbVsIqJRh
	n7tJSNHqsn341s4Q0ulVrPpgX3b68t8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ocfs2: Replace deprecated strcpy in ocfs2_create_xattr_block
Date: Tue, 18 Nov 2025 19:53:44 +0100
Message-ID: <20251118185345.132411-2-thorsten.blum@linux.dev>
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
it with the safer strscpy(), and copy directly into '->xb_signature'
instead of using the start of the struct as the destination buffer.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/ocfs2/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d70a20d29e3e..73c028f452ac 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2908,7 +2908,7 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 	/* Initialize ocfs2_xattr_block */
 	xblk = (struct ocfs2_xattr_block *)new_bh->b_data;
 	memset(xblk, 0, inode->i_sb->s_blocksize);
-	strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
+	strscpy(xblk->xb_signature, OCFS2_XATTR_BLOCK_SIGNATURE);
 	xblk->xb_suballoc_slot = cpu_to_le16(ctxt->meta_ac->ac_alloc_slot);
 	xblk->xb_suballoc_loc = cpu_to_le64(suballoc_loc);
 	xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
-- 
2.51.1

