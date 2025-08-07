Received: from mail-m15595.qiye.163.com (mail-m15595.qiye.163.com [101.71.155.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADF81D5ABF
	for <ocfs2-devel@lists.linux.dev>; Thu,  7 Aug 2025 19:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754594851; cv=none; b=czmkLFHwK5CB61TtgcKdJR6FkGsfMxk6+/2yddHMoEKphLqVcU3cgfckXx6YZ5Ej2fg+51W5YHme+5N5A5KRNwaRSKFj/ev/3I8y702uAQ10tj7VaRoY/3jfKXVkzTeHGupVb3N2nf9YpAwSMi6j7ssLrj4JIuV0bWTnPvYF1NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754594851; c=relaxed/simple;
	bh=2FcZkk+xEDG3rUE0WWzuxXebsp/ITy84v19kDDs0yHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sc3NcEEuT8WP770JLnwyWnI7wEKBMfk04roXe/A8U4XNuvpbX+3DaDuazJBSSgP18vrv6TPFJ+Irfornss6cgf3kKbALH7tt13WfRIb1BOOC/MaEE/KGc5m3i9Qe3guZ59qJpcd99evsYDCYBsx42tBnEIUICPwEDgvPX1agJl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=winhong.com; spf=pass smtp.mailfrom=winhong.com; arc=none smtp.client-ip=101.71.155.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=winhong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=winhong.com
Received: from localhost.localdomain (unknown [183.6.116.60])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ea7f7fec;
	Thu, 7 Aug 2025 23:58:13 +0800 (GMT+08:00)
From: yili <yili@winhong.com>
To: yili@winhong.com,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: Fix super block reserved field offset comment
Date: Thu,  7 Aug 2025 23:57:49 +0800
Message-ID: <20250807155749.164481-1-yili@winhong.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9885411aff03ackunm8c16af54187a570
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTExIVh4ZHh5JHRhCS0oaSVYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKQ0hVTVVKSk1VTUtZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0tVSktLVU
	tZBg++

The offset annotation for s_reserved2 in struct ocfs2_super_block
was incorrect. After the preceding fields:
- s_xattr_inline_size (2 bytes at 0xB8)
- s_reserved0 (2 bytes at 0xBA)
- s_dx_seed[3] (12 bytes at 0xBC)

The actual offset of s_reserved2 is at 0xC8,
when calculating from the start of the structure.

Correct the offset comment from C0 to C8 to reflect the proper
location in the super block structure.

Signed-off-by: yili <yili@winhong.com>
---
 fs/ocfs2/ocfs2_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index e8e94599e907..ae0e44e5f2ad 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -614,7 +614,7 @@ struct ocfs2_super_block {
 	__le16 s_reserved0;
 	__le32 s_dx_seed[3];		/* seed[0-2] for dx dir hash.
 					 * s_uuid_hash serves as seed[3]. */
-/*C0*/  __le64 s_reserved2[15];		/* Fill out superblock */
+/*C8*/  __le64 s_reserved2[15];		/* Fill out superblock */
 /*140*/
 
 	/*
-- 
2.43.0

