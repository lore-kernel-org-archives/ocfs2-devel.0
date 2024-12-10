Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67821A7046
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Dec 2024 13:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733836117; cv=none; b=auBa1mpU7+CEC2uz46CL8/oIAUFGKSspIDdqs5r1tLZuyR2YBwhb74K7XKHJ4aL3f0hYOLs2cTNC300M5t/GXRd+Yvg4LsIMIQJ76r8+N2d0lV5ho6eX9V9zXe1rqxxSLinAHdAPGEDK3ElK7MZOqWbs7cPTtPhyupjpmzObbF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733836117; c=relaxed/simple;
	bh=Vgw3pRE6k8IRL1iE+VuQQRFu84FdmP9ajGorNOWkAcU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hM3DHWy4yo7NDzdu7Zl2yLE1vtW06vFDZlVJW1oErxQlPUAqlN0mqp3NBG+avFIbKnbU+gqoGveX0cvl4rFJFybFfe4nfrRqj0bLNsxXuefbIMI/tgD8w+JCYYEBIRpUN0gxNJD17DJInPaayXUC8q9pJpaTmR/Oz8QqtBPyAOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFvOwRGM; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFvOwRGM"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2166651f752so15546075ad.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Dec 2024 05:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733836115; x=1734440915; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zqhJ6nHHR9Y30E9gGwdpdayiTmOUSH+PiMjlvTCElLA=;
        b=BFvOwRGMFe//ETlflcy6eZlzXFWnHHVedHYSgfEFP1DE91ErR3QoTkSVtbQY6mKIph
         XT+oasrpwBsMSvHujmXVetK0G/t2ufci0cnxH5VQe6FwRk+RgZbtfEki9bHBSVRLFBXp
         5w4PLc7FrzNKZMKa/ZC1pOAmjPc402vsS+rDl+TGz+hIZYGPS/V0Im1ySIsR+iMljgwG
         AJsgdhFffNr7nyvQzHrpWtXvr5B3UD1PORgq46e3EEbHt1rZaQMuO/vpadgTUTOsWpxF
         NOwXVRtmnhRj0rrGz2Ef+WtIA11gzCNF6AUYNsYjfdyhMSYIQzu2/jNtjguedX9HS9xY
         /kRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733836115; x=1734440915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zqhJ6nHHR9Y30E9gGwdpdayiTmOUSH+PiMjlvTCElLA=;
        b=P5t0vOo6D7F51eIr0YugLQlGg9Unj78p03gY1Hclg0EIppEXGUrn+/BWbOcgjKoBxT
         J7eu3rlNNzQmIEnKCpbejagDh8O2h2pNQK9kmbrIP07rNBqCLFjZa1r3aKnubsHAkkIl
         fxoVwv9hJ8tlmKwc/FuIGhQNuVXkyb6bI8Z6YxePkLULwv6JsKGrXmYLkQC3ll6xDHX/
         XkX1VS9HyqlM1MXQl0WvkLN1VuL2vqQZBSBX+b34C+SKBMFW4Kwci8+KygQxMDpJAshX
         PeUw0SIvO59XEhM8LYekIgTxmOpIi9wkKQGrqNXoJ57AvMuyXgIR1TXZ2TNYvsrfRmuK
         73Hw==
X-Gm-Message-State: AOJu0Yw6gzCBPgXjczi7EOYtuASX6SXd2PM0igw6FveGsPDS3XT8FjuG
	ysaD6mAAqRcXsj1dOriEOFlGf9mlC8l6iICN2KeZwJIGO1/8i83yTDdAgEhUU5I=
X-Gm-Gg: ASbGncs3YIzudwGJqJ+QbgRUu4SElxW++uOd6nBT2WRwWquDRVBgdZtwAvqN7lE5HHw
	wqmjkk7M+ArTyXteUygNTNW8ONwxrhN5titfoJ2B/Q73OimMDC4ASUfNhQqJnvDh5t6XSLSXY4c
	0hyHZ8htUQV8h9V8rEa2GpM3qUPkxNfoF2sIqxSIX3WeTACN+nKeEo+xPYrsCM2HvORYefqN7pB
	FRscleBMap3M0OAE/f5pVQxMdQ6dvtL1ieeBfqW87gnkQ4cob50DltMz4ivUc53hswJDgOGdLYA
	JASU06z5qd0=
X-Google-Smtp-Source: AGHT+IGvhPSCRmaZ/2TQ5ydynFDibMaG6/MjGDL6VZJedVuhKIAl+7JtX0S+vkSF4uTM4lg+IgKlKg==
X-Received: by 2002:a17:903:184:b0:216:3e87:c9fc with SMTP id d9443c01a7336-2163e87cbfamr151457515ad.5.1733836114444;
        Tue, 10 Dec 2024 05:08:34 -0800 (PST)
Received: from localhost ([206.237.119.150])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21615b1e6d6sm73132955ad.104.2024.12.10.05.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 05:08:34 -0800 (PST)
From: sunjunchao <sunjunchao2870@gmail.com>
X-Google-Original-From: sunjunchao <sunjunchao@zspace.cn>
To: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	sunjunchao <sunjunchao@zspace.cn>,
	syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: Add a sanity check for corrupted file system.
Date: Tue, 10 Dec 2024 21:08:27 +0800
Message-Id: <20241210130827.121584-1-sunjunchao@zspace.cn>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Recently syzbot reported a use-after-free issue[1].

The root cause of the problem is that the journal
inode recorded in this file system image is corrupted.
The value of "di->id2.i_list.l_next_free_rec" is 8193,
which is greater than the value of "di->id2.i_list.l_count" (19).

To solve this problem, an additional check should be added
during the validity check. If the check fails, an error will
be returned and the file system will be set to read-only.
Also correct the l_next_free_rec value if online check is triggered,
same as what fsck.ocfs2 does.

[1]: https://lore.kernel.org/all/67577778.050a0220.a30f1.01bc.GAE@google.com/T/

Reported-and-tested-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2313dda4dc4885c93578
Signed-off-by: sunjunchao <sunjunchao@zspace.cn>
---
 fs/ocfs2/inode.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 2cc5c99fe941..d3df54467d73 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1358,6 +1358,21 @@ void ocfs2_refresh_inode(struct inode *inode,
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
 }
 
+static int has_extents(struct ocfs2_dinode *di)
+{
+	/* inodes flagged with other stuff in id2 */
+	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
+			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+		return 0;
+	/* i_flags doesn't indicate when id2 is a fast symlink */
+	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+		return 0;
+	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	return 1;
+}
+
 int ocfs2_validate_inode_block(struct super_block *sb,
 			       struct buffer_head *bh)
 {
@@ -1386,6 +1401,15 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 
 	rc = -EINVAL;
 
+	if (has_extents(di) && le16_to_cpu(di->id2.i_list.l_next_free_rec) >
+	    le16_to_cpu(di->id2.i_list.l_count)) {
+		rc = ocfs2_error(sb, "corrupted dinode #%llu: next_free_rec is %u, count is %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->id2.i_list.l_next_free_rec),
+				 le16_to_cpu(di->id2.i_list.l_count));
+		goto bail;
+	}
+
 	if (!OCFS2_IS_VALID_DINODE(di)) {
 		rc = ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
 				 (unsigned long long)bh->b_blocknr, 7,
@@ -1483,6 +1507,16 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		rc = -OCFS2_FILECHECK_ERR_GENERATION;
 	}
 
+	if (has_extents(di) && le16_to_cpu(di->id2.i_list.l_next_free_rec) >
+	    le16_to_cpu(di->id2.i_list.l_count)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: l_next_free_rec is %u, l_count is %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_next_free_rec),
+		     le16_to_cpu(di->id2.i_list.l_count));
+		rc = -OCFS2_FILECHECK_ERR_FAILED;
+	}
+
 bail:
 	return rc;
 }
@@ -1547,6 +1581,16 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     le32_to_cpu(di->i_fs_generation));
 	}
 
+	if (has_extents(di) && le16_to_cpu(di->id2.i_list.l_next_free_rec) >
+	    le16_to_cpu(di->id2.i_list.l_count)) {
+		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
+		changed = 1;
+		mlog(ML_ERROR,
+		     "Filecheck: reset dinode #%llu: l_next_free_rec to %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
+	}
+
 	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
 		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
 		mark_buffer_dirty(bh);
-- 
2.39.5

