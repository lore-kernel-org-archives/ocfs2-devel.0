Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF390481FB7
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 11:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779188667; cv=none; b=RXVVkfBHS8JWccV3sNydayVwejvRMptOmcpwqhvHeqizHkLilttXtNGDg/kcFS3E3V55/T1xgeAyAIYdgbnFjdxDjexrWOKdL6us3azVigOK9t1432HkXz/2CmBDDD94ZmrDC1x9UzUVZggW5K0Y4ND+V5gRTNx+M6LfVsiUYvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779188667; c=relaxed/simple;
	bh=q0QaQO++/PvA1DQe3ls4tZMPt5G9WPx1L4vtJDSJKXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMZ+bgyZJKcM3d7PySAV1IL56nXMXzkl+jAqDnHDlWeVOaVF669vjHIs3D2Enc+BWRL7MCDfqRx6hRYpkPeSfmzpM85nv2/2RtEThH7eHhlCb/5e7orq3TQWfLRxMO53Mhewad95J1z7lhADm/h2j6WWheHfgEowSpDtwx9+izY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rTPnnCSX; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rTPnnCSX"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7bdaa68cf81so27600837b3.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 04:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779188665; x=1779793465; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6SyXZe52KMUC2ic8Hq1mf3+02KbtP8Oos7zC9gOb7ro=;
        b=rTPnnCSXBBXALXR7NoZSlY5DNZLQUVEJ4BUY0h2v0i7lpHyasZHg2LXvF20wKOnWkN
         OxI6mbvC7YaWxoxM7Sg+4aZWsT3r/XbQEAybPlztNWHdKlOObSddNCNY49GkERtcW/7X
         EvhaZitLe4DR/XogNH2CtxrQKxswAZ4I8VCz/MhZdslOC8eYU/Z0kicOVO3DI1/iCjij
         ePZIFMx+l9MqoEZ4+yAq/R11Ii7XkILr2q769ZGPmMuUKFNTPOITsbMAOqgTy95t2MUJ
         1PXcfpmTOaCnp4UZIJK3IIpXWX4lj4QOjj8Ksd1clxAxsZRsiTStDKFUpEH2L7LM7Yxk
         QNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779188665; x=1779793465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6SyXZe52KMUC2ic8Hq1mf3+02KbtP8Oos7zC9gOb7ro=;
        b=ISgQAECcckD5bv3neE+jUns5+fViZuzdwtGAQepoE/UJDArYwF1jJHBd+/PFqkVCuf
         xRW4zmsj6rmRnvkx+zaFMAo7dfi8JRG8yZC0vdCpOKFNKiMdVmqDsZPxfgbzz4kM5GrQ
         1jkTWRW6ssADzrPETrc5e2Vq6T0lXuFLtKMcLRo1pP+so6Y7KrUP9EJVmFWqhcejesAj
         r+p1vq4meDxhJgVtDJh1pjgBxG5U2VE/VNrrIUTejnUD5Wf3sTNPTBC6GY0Qvf1AJcRG
         BlRyfh/RuHa5wKFNzH/m7GEL4GI7o7QZBTj5NY1MEFY9OiOd8cGlFKQou3KPvuovM6s+
         NL+Q==
X-Forwarded-Encrypted: i=1; AFNElJ+FJTQzTpBaWBuVz05W1xilaplFmAtoa4EaAfwxlsxbufPBl6UGd4phMUfC4tfDNpMnIzXwBn45LvgTdg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxO5KTDMDeEKJ2b18B/sJug+/RpwhG+gg0PGA5Qir0oUQY8hKI6
	9FuxBfSdW82FfVuJwESQKaxBXOiTxJzRFy0T/T+9OwnNIyAFcfRmbrq6f3J1G8gN
X-Gm-Gg: Acq92OFIq+Lx+SDQv+02mUcoJQ89cCIFeTtCP0q6VDc3MxMCzn3R5o6J8uPkE91B4E+
	ZasLRFb8JSx6rOWTVDCAgpAPkfQ2xTwTmQr+ZsiO9R2lpW78pm6R/WL0e0IKtHjLMTewUkb78Qm
	+BGjFtTlX9l+qQ/0Xl8232OY93deVx44HmSf409izdQdq+LBEkoMV9vKcbhE2irLe2nehf0usP2
	q1KKli3CwX+bR3Sqfscb1KePlc20YcBdXQ6e67EhiTS0wwygt2v8CxRoc+qc7ybOcRN3vyfDKef
	jYd/km6RiSjTIV5Z1SuFDJ1ERT8QNpvgEoE6wnqY8A1I79fW/ya71Bic1JrYJGcroRrHbARS4oZ
	TRlP4wZGT3fpWIHR8YqZGYjVW+Nd5UhSM2looDMRVKgidJfVQU4tOSqkAe7FsUEJjRtv9qRLTcI
	TGYR6GkDw754/6fIM9sUP6wBAqkqdQ4J2GTRHrhXyphRkeFGDQ7Tv3vLXHlRDmYaP6ju5vOVeQr
	4+BiUyuKAt+H9lJHMxT4wH5zam8cE4=
X-Received: by 2002:a05:690c:6c10:b0:7bf:107b:f859 with SMTP id 00721157ae682-7c959f7e881mr226344557b3.16.1779188664814;
        Tue, 19 May 2026 04:04:24 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9bc0ccf7sm35206827b3.25.2026.05.19.04.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 04:04:24 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ZhengYuan Huang <gality369@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] ocfs2: reject dinodes with non-canonical i_mode type
Date: Tue, 19 May 2026 07:04:02 -0400
Message-ID: <20260519110404.1803902-2-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260519110404.1803902-1-michael.bommarito@gmail.com>
References: <20260519110404.1803902-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

ocfs2_validate_inode_block() currently accepts any non-zero i_mode value.
ocfs2_populate_inode() then copies that mode verbatim into inode->i_mode
and dispatches on i_mode & S_IFMT to the file/dir/symlink/special_file
iops; an unrecognised type falls through to ocfs2_special_file_iops and
init_special_inode().

Reject dinodes whose type bits do not name one of the seven canonical
POSIX file types.  Use fs_umode_to_ftype(), the same generic file-type
conversion helper OCFS2 already uses for directory entries, so the
accepted inode type set matches the kernel file-type vocabulary instead
of open-coding a local switch.

Apply the same structural check to the online filecheck read path.
filecheck keeps its own error namespace, so it reports malformed i_mode
through the filecheck logger and OCFS2_FILECHECK_ERR_INVALIDINO instead
of calling ocfs2_error(), but it must not allow a malformed dinode to
proceed into ocfs2_populate_inode().

Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.bommarito%40gmail.com
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 fs/ocfs2/inode.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index a510a0eb1adcc..e149ccbdc03ce 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/iversion.h>
+#include <linux/fs_dirent.h>
 
 #include <asm/byteorder.h>
 
@@ -64,7 +65,12 @@ static int ocfs2_filecheck_read_inode_block_full(struct inode *inode,
 static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 						struct buffer_head *bh);
 static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
-					      struct buffer_head *bh);
+						      struct buffer_head *bh);
+
+static bool ocfs2_valid_inode_mode(umode_t mode)
+{
+	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
+}
 
 void ocfs2_set_inode_flags(struct inode *inode)
 {
@@ -1494,6 +1500,24 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	/*
+	 * Reject dinodes whose i_mode does not name one of the seven
+	 * canonical POSIX file types.  ocfs2_populate_inode() copies
+	 * i_mode verbatim into inode->i_mode and then dispatches via
+	 * switch (mode & S_IFMT) to file/dir/symlink/special_file iops;
+	 * an unrecognised type falls into ocfs2_special_file_iops with
+	 * init_special_inode(), which interprets i_rdev.  Constrain the
+	 * type here so the dispatch only ever sees a value mkfs.ocfs2 /
+	 * VFS can produce.
+	 */
+	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: mode 0%o has unknown file type\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_mode));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
@@ -1624,6 +1648,15 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		     (unsigned long long)bh->b_blocknr,
 		     le32_to_cpu(di->i_fs_generation));
 		rc = -OCFS2_FILECHECK_ERR_GENERATION;
+		goto bail;
+	}
+
+	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_mode));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
 bail:
@@ -1812,4 +1845,3 @@ const struct ocfs2_caching_operations ocfs2_inode_caching_ops = {
 	.co_io_lock		= ocfs2_inode_cache_io_lock,
 	.co_io_unlock		= ocfs2_inode_cache_io_unlock,
 };
-
-- 
2.53.0
