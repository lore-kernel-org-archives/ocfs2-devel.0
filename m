Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77015285073
	for <ocfs2-devel@lists.linux.dev>; Thu, 20 Nov 2025 04:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763611915; cv=none; b=jiXcP7CFA3UEVQTc/KCJb4yMuKFLw1wbHk08p1J4GLwjs11UwiU2ulfqwVX3iiMbFyzJkdQYrntXbrgxmzzwYQ1VuoHPOGkQ6hsZG9T2efscUM5B+2j+MFl1F02CRf+73tytKaQEjrJuA4ogvuvvqLcI3h5Val06RKmh9heVJRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763611915; c=relaxed/simple;
	bh=97WnfnQbPA5vGe8X+wXaWHLMQWqNVeB0fUmYg/LcXnU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cJnYOEpXRqrqN0/nF75wd7hiiA5hhAuGYPrt9CID8JyHydX3oi8oJRjMIXQYzFvYL6TRHyBjmNmx/c8aAgHRHkLMe5QZ6nXOrmhR5L/Yu5Edwk6M8vw4z0Z5k9cE9cQznUaQapAuQ2YOhy3cFjtkdP+YnCFOe8F1tk3QievWB1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7Azvg//; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7Azvg//"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so577606b3a.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 20:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763611914; x=1764216714; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OAknHB5tZjEpml4alkW5iZcUUFNVM3J13VfbF4fSGGQ=;
        b=A7Azvg//6Il+abKXD0YfY1i2pFpx5p8KJsLeMfpoMvD2GTdneRg0qFUWfvcUMCnOm8
         KHuxzLaq9m6AsL8YnVfEYU2KwvybFFGqrMUwk9EJjeG11YBSsZru2wjQ5LY0vwB9iKJv
         z5Bi59et275keYyLHemyJhsMVm5BXoC1dE4QePlX74N0zoyoFQM3Ddo28elj9eA2nJGj
         8XhUj5qbELM4gLbORSFSiSOrE4fp+Pf8ZfoAC0YpjXyANMkZe1hTWKeUmq/WziW8Dqd8
         sxAxkIaXN3Bz2fX3ClhSy2ijBZp/rFRN4QsUi+6xEw/o87FAYFjpWPtjRlO0mgcWoUtB
         Y0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763611914; x=1764216714;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAknHB5tZjEpml4alkW5iZcUUFNVM3J13VfbF4fSGGQ=;
        b=Q9FGj42vhehL4vbV4k1NPUApItZQ955X/RyK+fV6JtFfmtfzROpSo/oo0KHKAVKgtr
         XiQiym4qGrGP9fJiqn2es/XrCJbKZH2TRekjUXKTsildN0QyMm4C6p89w0O9tKzT+R39
         ZO+qSpenLWB3BO4b1ro2si4XiiQ0lMidIkBKYGUWhMRu28Ebq94eo4oeWBOpgI8SeBZ3
         w3xAj7xRWgtuj5WT159sHcykzi7VIbtlx1S3qamf05D7IWA4rOcU5ZrDfBerKzRCu90S
         6TmlBVh98uC0iYpZA6SfG7xTZojuudBE1Vb4J/+oJOSMwccqFxbG00UXooTuQvS6afP/
         gKCA==
X-Gm-Message-State: AOJu0YwM+PYs4DgdfPyaBjh6I7+QZRIcImK5rsQPwdeOFCyunV3uvTeS
	atTGtIZCmqIffmJsT2kBtaBFhMJNMQcwPE04fxdppdzC/oCF/Fm3GhBZ
X-Gm-Gg: ASbGnct8QKoAziWJIdbFfzR8YrnHRmff4TH0jUlunuz/+xTKUFMQ8gE6pwx5KE1q0wz
	TboxmB7UGbMba6TdhowmThCelV02wXZLDteBrPgra834mr6/gUhxFVAK8I6JOsjaobwuhjFfnOT
	ypF1IdHFINeBPZTi1TOJJLBz0Ch+7TVNjxeGcTkmahh9hFZCXWhC9YxBrYSyhJ2Baj6FQ1InSry
	E/OF54vRlTk9fpXcSqmQSOsd3Km+N5LqvvcJHhFo1fkdHi0NrzvQryfWGWTUBElnJI7RjMLiQqx
	vXdASW2k3Y0VJUWXe4y7KhRx+zP9yEJ0BG1q6Gtk62pshXUON0+fIes8ujJMr4LCLW3iPDlxfxz
	JdsgmE+ylv19p6RvgL7fgqGxBtGkAe+ZCN7ADhuNoGhbIbD15FI61xLDL5gdpL82Q5NegOkdjW+
	ZXu+F25wzmyNpzjzHiZU4NfrJtLvP6txIH1kI=
X-Google-Smtp-Source: AGHT+IHvxEhcnjNuS7nEdN4Os+KSqtAwVjCqKQtuUbalhTNoMMg+jKTuqAecvtfgwz4aNhn6XCNghg==
X-Received: by 2002:a05:6a00:84b:b0:7c2:60c6:8ca0 with SMTP id d2e1a72fcca58-7c433e0226dmr1144412b3a.5.1763611913572;
        Wed, 19 Nov 2025 20:11:53 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:b699:1eac:7219:cf4a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3ed471060sm1009312b3a.15.2025.11.19.20.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 20:11:53 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Subject: [PATCH v4] ocfs2: validate inline xattr size and entry count in ocfs2_xattr_ibody_list
Date: Thu, 20 Nov 2025 09:41:45 +0530
Message-ID: <20251120041145.33176-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add comprehensive validation of inline xattr metadata in
ocfs2_xattr_ibody_list() to prevent out-of-bounds access and
use-after-free bugs when processing corrupted inline xattrs.

The patch adds two critical validations:

1. Validates i_xattr_inline_size before use:
   - Ensures it does not exceed block size
   - Ensures it is at least large enough for xattr header
   - Prevents pointer arithmetic with corrupted size values that could
     point outside the inode block

2. Validates xattr entry count (xh_count):
   - Calculates maximum entries that can fit in the inline space
   - Rejects counts that exceed this limit
   - Prevents out-of-bounds array access in subsequent code

Without these checks, a corrupted filesystem with invalid inline xattr
metadata can cause the code to access memory beyond the allocated space.
For example:
- A corrupted i_xattr_inline_size of 0 would cause header pointer
  calculation to point past the end of the block
- A corrupted xh_count of 22 with inline_size of 256 would cause
  array access 7 entries beyond the 15 that actually fit (the syzbot
  reproducer used xh_count of 20041), leading to use-after-free when
  accessing freed memory pages

The validation uses the correct inline_size (from di->i_xattr_inline_size)
rather than block size, ensuring accurate bounds checking for inline
xattrs specifically.

Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab0ad25088673470d2d9
Tested-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Link: https://lore.kernel.org/all/20251111073831.2027072-1-kartikey406@gmail.com/ [v1]
Link: https://lore.kernel.org/all/20251117063217.5690-1-kartikey406@gmail.com/ [v2]
Link: https://lore.kernel.org/all/20251117114224.12948-1-kartikey406@gmail.com/ [v3]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v4:
 - Corrected commit message example: max entries is 15, not 7
   (pointed out by Heming Zhao)

Changes in v3:
 - Moved validation from ocfs2_xattr_list_entries() to
   ocfs2_xattr_ibody_list() to use correct inline size calculation
   (suggested by Heming Zhao)
 - Added validation of i_xattr_inline_size before use
 - Added validation of xattr entry count against inline space
 - Changed return value to -EFSCORRUPTED for consistency
---
 fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d70a20d29e3e..98fd4f3f2d2d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -971,13 +971,39 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
 	struct ocfs2_xattr_header *header = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	int ret = 0;
+	u16 xattr_count;
+	size_t max_entries;
+	u16 inline_size;
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
 		return ret;
 
+	inline_size = le16_to_cpu(di->i_xattr_inline_size);
+
+	/* Validate inline size is reasonable */
+	if (inline_size > inode->i_sb->s_blocksize ||
+	    inline_size < sizeof(struct ocfs2_xattr_header)) {
+		ocfs2_error(inode->i_sb,
+			    "Invalid xattr inline size %u in inode %llu\n",
+			    inline_size,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EFSCORRUPTED;
+	}
+
 	header = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize -
-		 le16_to_cpu(di->i_xattr_inline_size));
+		 ((void *)di + inode->i_sb->s_blocksize - inline_size);
+
+	xattr_count = le16_to_cpu(header->xh_count);
+	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
+		       sizeof(struct ocfs2_xattr_entry);
+
+	if (xattr_count > max_entries) {
+		ocfs2_error(inode->i_sb,
+			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
+			    xattr_count, max_entries,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EFSCORRUPTED;
+	}
 
 	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
 
-- 
2.43.0

