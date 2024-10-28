Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B82D1DB350
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730126692; cv=none; b=hceufLX5IJtafsVlLNr8VGt2tNYi67C+L0Iy9aFcFuAWJywJNMpaRB/dIrVvECXs2L0KNjsDuilwsWx5egLmgsH5ySOAfnALFu4ZVOzG5ihgnO6kfKPkfEX0lxEnBhxM/4ly37IqlhX6rvKfAlsyKEst1WnwLlJRr6twzA0f+2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730126692; c=relaxed/simple;
	bh=p7yMguCBKmD9r0RbDe7chkG0LWFM96Paqn++IF1pTag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nRid8W5TGsAlTRQMWIZIONSSsfjywCfuCjAbtYWzd9n3opqZlTKu9vzscL7hgDiheWreswv+gw2Ppzh10Ik1HN3sG95i6iQ1EqU29rRTYElS80iy10cq1BK4wcUSBy3FB5XwmXTwdW7RZZJvFkItOzfJMPp2VlJ21fuVgAs15pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BBWEfuK1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BBWEfuK1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730126689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WkUbSQrMk+dfn1VmSJ/MQOaPLbP4AoqiC7gCqTffvD0=;
	b=BBWEfuK1gnGlcWnCh4qOaHisEuXyQcg2WSX8EzoeFtZaibqVApxJR15kIAxvOgxF1UsWW9
	AfDHyBfhyCz2dWldrWITHlv+jY6oZ3KRC79wgYsqDIiob2G3jQ8KYYl0ouZT/LWFjiEHKZ
	Xn2qnTvXndeo+voRoQeGDATD0QWklhM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-C9-_KHZROwuhUmLF-z5nsw-1; Mon, 28 Oct 2024 10:44:48 -0400
X-MC-Unique: C9-_KHZROwuhUmLF-z5nsw-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3da2d46b9so41698025ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 07:44:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730126687; x=1730731487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkUbSQrMk+dfn1VmSJ/MQOaPLbP4AoqiC7gCqTffvD0=;
        b=FfDR6La3xixsYkmQoRiGFFaBcFKTZpZBRPcvOTmKYW24twVWpZRjUCSOdtVHhguMC8
         ERsaHcQFr/lFNCb1UGwPB2p5ZdUC1bR/owbO8tbnzirOv/0G72lIWjIF2oUxF6LXYgkx
         sTRxkVlaHRiPhB9fwT0Q+wmz+KklPLrcvhVh+6CB8VXqRtFK/xp+OpR6Yuf1x6EbKERr
         uM2fk3xjslB6JmZ9KmR/OzmVN0M+hkASE5TUjrYxsGFlQS3F+bUgV3kppo1KouJLdwEz
         qFxvh2tcob3zRVCm7AJuwCo9e/GrXVUdLTkW4PF6rq2tY6modstQQVmkPrfLhZiOPeDV
         5wqA==
X-Gm-Message-State: AOJu0YxxxRVjLcEEkVMIyFZRAR3m8Rbct47tRLRUQa9r2vE0xOCeWDfr
	pHuA52tcTD04LvYVVTwaJdA3eM67+Akv4OELwlqdcivoOIGph1dq7kRlPs+Pr68mlL28sbOPgOK
	bGpUNaw1esQnliwI0uk9H8vettWetGT2SfAjVBJk3SiXcJBmSp1Exe0XgDFYy4xGEu2WVIvGIXD
	PW3apznLbQ2+nFZyuIH7bVkmuAX5APCxLgAdldIYQLewNNyw==
X-Received: by 2002:a05:6e02:1568:b0:3a4:e637:7b4 with SMTP id e9e14a558f8ab-3a4ed264e4fmr80315045ab.5.1730126687519;
        Mon, 28 Oct 2024 07:44:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFF3DMl7xOxwGbg4xC9bOP6dzwpEZfUfbOMAtAWsx2huxbC6q63xUTpQXk0Lfsbplz1K7wJBg==
X-Received: by 2002:a05:6e02:1568:b0:3a4:e637:7b4 with SMTP id e9e14a558f8ab-3a4ed264e4fmr80314705ab.5.1730126687076;
        Mon, 28 Oct 2024 07:44:47 -0700 (PDT)
Received: from fedora-rawhide.sandeen.net ([65.128.110.20])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a4e6e56c62sm16760705ab.56.2024.10.28.07.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 07:44:46 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	brauner@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [RFC PATCH 1/2] dlmfs: convert to the new mount API
Date: Mon, 28 Oct 2024 09:41:14 -0500
Message-ID: <20241028144443.609151-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241028144443.609151-1-sandeen@redhat.com>
References: <20241028144443.609151-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Convert dlmfs to the new mount API.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ocfs2/dlmfs/dlmfs.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 7fc0e920eda7..2a7f36643895 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -20,6 +20,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/fs_context.h>
 #include <linux/pagemap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -506,9 +507,7 @@ static int dlmfs_unlink(struct inode *dir,
 	return status;
 }
 
-static int dlmfs_fill_super(struct super_block * sb,
-			    void * data,
-			    int silent)
+static int dlmfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_SIZE;
@@ -556,17 +555,27 @@ static const struct inode_operations dlmfs_file_inode_operations = {
 	.setattr	= dlmfs_file_setattr,
 };
 
-static struct dentry *dlmfs_mount(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data)
+static int dlmfs_get_tree(struct fs_context *fc)
 {
-	return mount_nodev(fs_type, flags, data, dlmfs_fill_super);
+	return get_tree_nodev(fc, dlmfs_fill_super);
+}
+
+static const struct fs_context_operations dlmfs_context_ops = {
+	.get_tree       = dlmfs_get_tree,
+};
+
+static int dlmfs_init_fs_context(struct fs_context *fc)
+{
+	fc->ops = &dlmfs_context_ops;
+
+	return 0;
 }
 
 static struct file_system_type dlmfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ocfs2_dlmfs",
-	.mount		= dlmfs_mount,
 	.kill_sb	= kill_litter_super,
+	.init_fs_context = dlmfs_init_fs_context,
 };
 MODULE_ALIAS_FS("ocfs2_dlmfs");
 
-- 
2.46.0

