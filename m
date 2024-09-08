Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97597171E49
	for <ocfs2-devel@lists.linux.dev>; Sun,  8 Sep 2024 14:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725804445; cv=none; b=nd1vTsCaA9c94OD9zbxAqvxPdTXS/2YPgt9LD6X8NLyu8q99nQUn5X4sVO1MZoI01AxzSPmBlJjiO5h5pLJvGFjV0qbFKmjRNMdMtQFGSmqnj87NtMpe29w97E52SFrzFqrjHlMUMBA/L9hUdine1iPrAOrUUoepe4OVVFZcsNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725804445; c=relaxed/simple;
	bh=VdJeHcRa81uNgktXVnAIXziYQCFEfA5cn+PUdZ+gLkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=icC8XBW2fB10DIo4KeojxzU2WZbBZDLS/ggXzGVI7C/yzZANvIow/nowPF9Bdoj7pH9apHihcTkMdd9dATKqBbA9BSzhs94Z/vlLt49bcpsWf6X5l1zTRafi2a+b30Aqhkyw3v0Vjlzl+BDMGdAixYSEpeW96uLbZbptwo88apg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Yi5+DGoQ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yi5+DGoQ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42cacd90ee4so2207445e9.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 08 Sep 2024 07:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725804442; x=1726409242; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR6N4fCC++oBDLKVVVJ7HiCM6XtmAM6PYHQUGBS1rhs=;
        b=Yi5+DGoQMH8anKyYEFBvzQxS8xqdxI+nvYiRgQ6eKoVmw5HW4bhH7YBa+Nfurgrftn
         5j5UMOqa8SQt2DoZoM2ASAzBceYVk38IO8dBIN9IjIWuG6hFynJfCyF1HvhK/lik4iFF
         1rzojmcjOKm1jfQBsLEMIiDPJ8P0iV5MxoBuGrb2gbG6koDnZ4+BEerWJs7HnbqfdOZa
         JIK9O5h7+dfK8fBQczXRJ/NqHQz0iVC/H39CGTzP17vrxgizfECBPGdrI7k0E7MQm5Lx
         dkXOQBuTycWXatY9DNPSJ3mjHjmeUpXW+a2nndpBScWcKmfk8WC5nCgL9po7o1x8jHPw
         912g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725804442; x=1726409242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vR6N4fCC++oBDLKVVVJ7HiCM6XtmAM6PYHQUGBS1rhs=;
        b=nmpsXJm6Oo3IyV/OjJRqUDY3RU6G2RnZvhNtiKdU3J6CXDTIesku3eBoDJPs4lDRz8
         ReQUyPCbLVcuhRd/1X9TLtlO3sT45aEoZxwjgK+yavosEX7qe58poXdJJ8P6amjc9qRo
         26/CCqJ1MIeWpB6HxQBRV9Mp2IuFiNEMP6ds9GbqZEcd+dlLT27R73Eu6xezuptG21AF
         a9knflkZz+imTXjdbOChZuZsPHLM90qTBTuqeWXKIJimjEFhz5ZfwyrT5K60hoJzaMRo
         /8T+w0Q2t/20+ZKLPm/lBo4WeOjm0xevSyR8u1ao7VopRFXchux4jtgGab22nlMwqQhz
         XPZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIJP2a8cAn2Nm+sLO0cYWjezPKg2v5YDC181uFGAWbUbwaUiD/AX5UcPd8k6bogNvdv0KP8hwZfA6sXg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwhJQ4lxaGafBK1NFxxqKNe+/jCZGNKKc05R7XFsoN7aUo7NwtW
	48rtj12tpCEd0MPKfwuZ9yl8tWJK8XJ3685esTxzGHFzDGLaOqYvf0qgilyqrGw=
X-Google-Smtp-Source: AGHT+IEjD0/PC0WO2GOqUMpTA2/eZmSm46TAshTjVAAAEN0En/GnWtBMyhgW+2LIQa8czyBy0jD9zw==
X-Received: by 2002:a05:600c:4707:b0:426:6f48:415e with SMTP id 5b1f17b1804b1-42c9f97b9ddmr28933705e9.1.1725804441252;
        Sun, 08 Sep 2024 07:07:21 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dadc074599sm4863371a91.31.2024.09.08.07.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2024 07:07:20 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	glass.su@suse.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] ocfs2: adjust spinlock_t ip_lock protection scope
Date: Sun,  8 Sep 2024 22:07:05 +0800
Message-Id: <20240908140705.19169-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240908140705.19169-1-heming.zhao@suse.com>
References: <20240908140705.19169-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some of the spinlock_t ip_lock protection scopes are incorrect and
should follow the usage in 'struct ocfs2_inode_info'.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/dlmglue.c  | 3 ++-
 fs/ocfs2/inode.c    | 5 +++--
 fs/ocfs2/resize.c   | 4 ++--
 fs/ocfs2/suballoc.c | 2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index da78a04d6f0b..4a5900c8dc8f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2232,6 +2232,8 @@ static int ocfs2_refresh_inode_from_lvb(struct inode *inode)
 	else
 		inode->i_blocks = ocfs2_inode_sector_count(inode);
 
+	spin_unlock(&oi->ip_lock);
+
 	i_uid_write(inode, be32_to_cpu(lvb->lvb_iuid));
 	i_gid_write(inode, be32_to_cpu(lvb->lvb_igid));
 	inode->i_mode    = be16_to_cpu(lvb->lvb_imode);
@@ -2242,7 +2244,6 @@ static int ocfs2_refresh_inode_from_lvb(struct inode *inode)
 	inode_set_mtime_to_ts(inode, ts);
 	ocfs2_unpack_timespec(&ts, be64_to_cpu(lvb->lvb_ictime_packed));
 	inode_set_ctime_to_ts(inode, ts);
-	spin_unlock(&oi->ip_lock);
 	return 0;
 }
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 2cc5c99fe941..4af9a6dfddd2 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1348,14 +1348,15 @@ void ocfs2_refresh_inode(struct inode *inode,
 		inode->i_blocks = 0;
 	else
 		inode->i_blocks = ocfs2_inode_sector_count(inode);
+
+	spin_unlock(&OCFS2_I(inode)->ip_lock);
+
 	inode_set_atime(inode, le64_to_cpu(fe->i_atime),
 			le32_to_cpu(fe->i_atime_nsec));
 	inode_set_mtime(inode, le64_to_cpu(fe->i_mtime),
 			le32_to_cpu(fe->i_mtime_nsec));
 	inode_set_ctime(inode, le64_to_cpu(fe->i_ctime),
 			le32_to_cpu(fe->i_ctime_nsec));
-
-	spin_unlock(&OCFS2_I(inode)->ip_lock);
 }
 
 int ocfs2_validate_inode_block(struct super_block *sb,
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index c4a4016d3866..b29f71357d63 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -153,8 +153,8 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 
 	spin_lock(&OCFS2_I(bm_inode)->ip_lock);
 	OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
-	le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
 	spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
+	le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
 	i_size_write(bm_inode, le64_to_cpu(fe->i_size));
 
 	ocfs2_journal_dirty(handle, bm_bh);
@@ -564,8 +564,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 
 	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
 	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
-	le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
 	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
+	le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
 	i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));
 
 	ocfs2_update_super_and_backups(main_bm_inode, input->clusters);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 9e847f59c9ef..3f91615d8702 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -798,9 +798,9 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 
 	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
 	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
+	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
 	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
 					     le32_to_cpu(fe->i_clusters)));
-	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
 	i_size_write(alloc_inode, le64_to_cpu(fe->i_size));
 	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
 	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
-- 
2.35.3

