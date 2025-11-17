Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16692280330
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 11:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763379754; cv=none; b=eeaZvysxLcK/yNOK7O9ILvsDm6gXuTejpZ5UvapyWOrdTnXE4/b0P73zDhBi/AOgNzuavwniIU3apRcj6qVr9N7vpa5GL6mR9nWd0tze0ZgLTneUz0p6GXT7Odrby2tnfTQJxzv+ydwKXqEQXInllPW2rt7ld6aK8ZAcH8AOFJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763379754; c=relaxed/simple;
	bh=UZCACtO/pqe+26J2EJiBR/zQesvYpmL0azfVHaXmv4E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HPSWkmYn9cTfPPxzVDGwdwGNPkwfdeUm3treI2lxE9F/zLoUQFIN8bnpLldmoCupGOYGMjggbewactwNKGGYext7d61R61XAB7Z2JNyy2L546MFP4LF9LXYnAEgxHUFr3buCeE0P59CXM/+4kewghZnH8Elujw5zTVnShHvttWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cPNQp+kN; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cPNQp+kN"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-29568d93e87so37438745ad.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 03:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763379752; x=1763984552; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XNpL5Ghz/qrVsjxUngeGJ80bJJXI7kHj0yflRXScBjc=;
        b=cPNQp+kN806UnJv5aV0iFLwn8bUO8N4Gzx1EzF8hx5U+2rNvsSaRk/QM+9tIfGR/PN
         9CKRZtrq13U2Cr27UD8Enfmf0fmUifhjXego9k4wdcmbIRvt5KqH4oZAytqUCY9CBhfu
         B7y9I74lTLeSd8kfGH3VNQDTXM6PEmXPSIggx+esFKy9B33KxZkKtQv/Z/HaHOxcvk9h
         LMaSrljaz91ZShn4jLd60ed+AGjqmgkvlkpM+mNzg3ix2gMqdyO75lDP6UuMNgFy++eI
         EHVUTxC6YdGGwvI/Yi0ZRkgBlbBlqGNGsG44WECWDGPTXttYK5+uJKsFcOYskc1T/aOc
         oeZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763379752; x=1763984552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNpL5Ghz/qrVsjxUngeGJ80bJJXI7kHj0yflRXScBjc=;
        b=S/WwxvsCKGOkwD+nhkLgs4Sv/OUqmrzR0lGAm4FMvGuFS/CuM2yOzmpfwkQkGDSy7Q
         iWLa1+xwsIbwf2g6pt/m+CDt3hnKbvJuhDIEGn/aTDFsUyUMhQvJl6MSRcMC649pBdRc
         ybkqwe/flFk1kVmYU4OKPEK+j0/ve3dNMpKFDs2hTYFVRhR32alxn6hR0rP/+8S0qAY4
         bPhtBhQ6lOl9XqvaeJ6tE4TMe1aI0YeyGvFCGcqACSrAEvfIb1wcMKPsEKOnp2s4AdQw
         UbEUB9trbi8aipAXcpagQ7GlRlpxTtWuhgYksgs5ijqUmKTmuMistG2NQ61NpfJKl79P
         Qvww==
X-Forwarded-Encrypted: i=1; AJvYcCXhVGpj8G7XSbn+QPuWzHgfriAT4LU46/iru4tqo0iqw8z/ormB9dmyRCXA/NLUdvRcAC7Nw2YG3k+VpQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0fdul51K+rwY9BLwA8+vcaUOLnwtDOuKQZt5hVwWTnW3tH1Rb
	j+eKFCGdThttdz8gRvng2gFl7VtnwoeFSdwr00H7Tb2bBWv0Y2o0QRw7
X-Gm-Gg: ASbGncsp14G66XGr0xt3FP9lxMfsy6hrUaFoUW3LaEaMXhOU5KGGKYZPwgouVkwBgaW
	qn1szeu2xhgdi0YCbHvujtNDFbuGH9lDPHzOitWImu2kg7nPApseM2A3TZivcHdPoxmRVS+LMld
	LicvXI2ibsPzxPcSvki1NttMgNWfB0XUODK4fMk18k9YqKZhtqPgKf9KpY3m0d/vXCUVOJGFkRs
	8GRWGfXFj3imt6CUroFzRo4udH/JeOu/7uSfmQYt+3QwW+cyPChKz+VUfLMOJJKS50krv3h4pbz
	MrlMzRnGGHm1xNd9Iqmp90OWwS3i92sngHQ5SL+JbXStGh82WPSP1WyI953Ao2t2IIUab5yO9qz
	3aXsDVbTpsSpzKFLJItpH00NZ66CByzCW92u3k5tPYRl9PpVmx1dMDM202YkqjIzRFLScdHtuBQ
	s2TDJWElZWX48Fv/6m+0G54ZESoQgxOEtZzw==
X-Google-Smtp-Source: AGHT+IGxrtKLd/UOJMvhgpyn5AUt8VVfblBbqs7p1VeDOePaMAcUpYI4zG5FYpSR1dDOZq0Z4oEcag==
X-Received: by 2002:a17:902:e543:b0:28d:18fb:bb93 with SMTP id d9443c01a7336-2986a6b8261mr140865095ad.7.1763379752238;
        Mon, 17 Nov 2025 03:42:32 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:b6cd:9c19:e37a:84a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2986a60b116sm105452895ad.79.2025.11.17.03.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 03:42:31 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com,
	Heming Zhao <heming.zhao@suse.com>
Subject: [PATCH v3] ocfs2: validate inline xattr size and entry count in ocfs2_xattr_ibody_list
Date: Mon, 17 Nov 2025 17:12:24 +0530
Message-ID: <20251117114224.12948-1-kartikey406@gmail.com>
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
- A corrupted xh_count of 20041 with inline_size of 256 would cause
  array access beyond the 7 entries that actually fit, leading to
  use-after-free when accessing freed memory pages

The validation uses the correct inline_size (from di->i_xattr_inline_size)
rather than block size, ensuring accurate bounds checking for inline
xattrs specifically.

Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab0ad25088673470d2d9
Tested-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Link: https://lore.kernel.org/all/20251111073831.2027072-1-kartikey406@gmail.com/ [v1]
Link: https://lore.kernel.org/all/20251117063217.5690-1-kartikey406@gmail.com/T/ [v2]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
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

