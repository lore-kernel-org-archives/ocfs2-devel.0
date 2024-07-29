Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD581304AB
	for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 08:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722240311; cv=none; b=IuiPuNWR65SKAtdtD9imbmLNYGw5QVMNYs494ptd1xHteMxsdoWmo5rVynoaG6xIKgCikQcgymlk/yqp8WChhmxNm0jKFfl41VSQV7C0E5RKBRZr0d+NECPBwzWjLiSHMNPLBaQwcapDbyt3bUhSRSlP9z6lebLYFkLGRWQNAO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722240311; c=relaxed/simple;
	bh=oz7f33TRP/vq3M9hrTRzrn5iR07SZL9SxrKV0HsqtGo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qpfaGCoWtahjSOFHh8b2ShfRhLIIImwW/8lcVo7EVctyeylz7aBijsRZEkdcsdoDysyZa5fMeoGkE96d4S6AjGXOrR2TPSzBOzk9Ahc0978N3UIYaQyQCOYPMuBFT4MN0v5dJ+aI5j5M+wYm3r07Kh/olzHADB3sdBsepYLv5YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fzyxXV0H; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fzyxXV0H"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-36865a516f1so1639797f8f.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 01:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722240307; x=1722845107; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MLjRKEBEqcL0oGW8urXN3X5AFLsvEJ+ayR8GORKB8o=;
        b=fzyxXV0HnvKX3P1/44n7iN/No7/zRWLFLrdct9aJ8JcDhmdcVhZm6AHMb/8sSRpLAx
         SXU8E0nAl1Vji36eZT6v4aEHknAS/eYfAgXTvmjNxyFXxYw0BjDLyjKMaOtrKkU0Bs6Y
         E7p8N2HVObLL9HRNlMdCBqFEmqEwW76lLZQyJ3JBaevFeekA6452ubEHZVHDPznVJCby
         ytIxTo3WbyZ9qnUUvFsyRYGzvQ6eqiAA3f4VRlhybGWf8CbXNlxKIRPm1MwjAb0dkIEM
         lA/+O1t59JK4FhdRexcCH3MBHvy6eh1xCCqFM1uWUvoSCnP2xznJQBtwoYax3Y453P86
         rl6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722240307; x=1722845107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5MLjRKEBEqcL0oGW8urXN3X5AFLsvEJ+ayR8GORKB8o=;
        b=q+sDgaOfBy/Pzmn6+i5rOxCoe5DjhUkZ5h9uoG5S4MVTTlHepofUqPdZelEr4cTQfW
         atmmXIdM7aKA56uBIfPPCTwuq2Gw65H6PCx+TkPV+0UjR/foaZxUhTRAllhkqxEgDTCW
         uWljJbSDOcHJtpvWz4inwPzkpd3BHskgob1naBLfX3IWpoopCVwX7ru/gT3FDcqCqura
         OKbI134BDq+OKVo5zscK6Z+6Hctr5/IFRRe0hgjwE7mBmAp7J+vR9If0Zl0UgGNuYvm1
         b3BAgxTKc8qB3M3dn19NWpCT/aKJnl2bDiTBC7ISZiklhOgAUB5rj5f/zq+pS+EfCJ1V
         QtAw==
X-Forwarded-Encrypted: i=1; AJvYcCUDI6ix5V0H64HtfUwzS8Lxn7jgeMYNczoxAM0xoA72KhDIGt+MOqucvdd102ter5fsNnOfKkCn9GKWolit4ANL5UOgJk7AYfHNYTU=
X-Gm-Message-State: AOJu0Yx9qlsLgD7jlxAJ1ECGLt/tuvMb5B9uaMtyRyBf1FY7YeeQsZQF
	ufb7gTCOEmGi5ZZbis6MD3CxpKdlZCsMw6HlNRkzTkEcBKgKaivcrtNgxHhvZK8=
X-Google-Smtp-Source: AGHT+IFWt/a6BjBNjPB2GS2+A1TiUis+0fQp3O5bwEPX6zpmboqbrIEiZrhqYYUD9VgLr8E0wXeO6A==
X-Received: by 2002:a05:6000:18a1:b0:360:75b1:77fb with SMTP id ffacd0b85a97d-36b5cf25321mr6017879f8f.8.1722240307450;
        Mon, 29 Jul 2024 01:05:07 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7edd813sm76560305ad.170.2024.07.29.01.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 01:05:06 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	glass.su@suse.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v2 3/3] ocfs2: adjust spinlock_t ip_lock protection scope
Date: Mon, 29 Jul 2024 16:04:54 +0800
Message-Id: <20240729080454.12771-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240729080454.12771-1-heming.zhao@suse.com>
References: <20240729080454.12771-1-heming.zhao@suse.com>
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
---
 fs/ocfs2/dlmglue.c  | 3 ++-
 fs/ocfs2/inode.c    | 5 +++--
 fs/ocfs2/resize.c   | 4 ++--
 fs/ocfs2/suballoc.c | 2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index cb40cafbc062..28ab6578f957 100644
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
index dc421f55ed8f..e2569b0d6204 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -790,9 +790,9 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 
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

