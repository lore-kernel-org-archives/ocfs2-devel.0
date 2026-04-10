Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3873631E853
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 06:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802159; cv=none; b=SBXzLBUBh6mgFT3l5fweJKD/is1gNHrJ5+8FQIXD6stfKNZqI8r5gTwfOpCVb5tNMHMBEFWcpRvxAmLHK6GetKtK1gcJp6p1VwAdx2ef0lLod2sovKTsMFFcBha+X/7ixZX7ak7LdqnlFMOzUTDIe++51yjW5kXvQOSmUOZ5WKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802159; c=relaxed/simple;
	bh=ztkayzzo0bgWeNLdK9unurMrG7IYOcEVI9HQ4tBu8sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Avc1CRiDWifw5HXa+mdKqyx8oobGbLK8nZ1bGbedCJSml3+yY0llX5Z9j/Pu/dYfhUWkoXcRAbCEOqrLvfcd3uTAV47jMwHgXPA6OU8hVDmHjn6FjAPIGxzb0NJjQmd+m0Ql+p9W3izZ5saNWEW91//QrkNuCrmIRrQ6wva0nDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J/kH+Q7n; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J/kH+Q7n"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82a655cfab5so1635900b3a.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 23:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775802157; x=1776406957; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OFrYQXdupMVyTwUKDSAAmtUoDt1iQIIGZs4BQXeH8gY=;
        b=J/kH+Q7nFmNSdjIsORHch/GLST/Z7mNIwEE6PbvhHdEY6ffFdQSK1XVme5bLNp4azm
         giScpesl0cOa/y6+VbLGdYeE+YJiGvV7e18YKm0YgibPjLZB7mUbh1G6tjkQXxlEfzWc
         zybgbXrLBeiDyZOYCqXiCZWt+gC0EaLjmdHbA84Hj26m/UFYyZLE3cw4UiPTvmfAqxcI
         T2EAQhAtdLNNWYujKMZyEIXT6NqwSuFKyZonM8e/xpEOjNcykX11PqHa4nHSw1fwHbAK
         1Ewo5gkN5u57OGgFUceO9zFHqGJaDc1v56yJJu0rU32r6a4ec4tlPau3N1B9grOHBNC/
         AzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775802157; x=1776406957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFrYQXdupMVyTwUKDSAAmtUoDt1iQIIGZs4BQXeH8gY=;
        b=FyuQI+AH9Vu7e8vTIXrKcVS8/d+UlghOj8juk8aX/HkAvc4nKKFHC3CK4L+uoIVV7B
         0OCoOJZlMma7LhRiuUZrBJo/8Qbz9mqJPhTMJUJl9LE6SZmIgsi3BoNe5iUHXivN/Eds
         cDKCoSK1UiK4uPVqg2wkTlGUKtMjk1EiA+wR3LXhXZ46Eehcwc6021JlL8YYIoS58V1B
         XChpr9TW++W0vll8JjzNr0dIjtCCeHa/vVxmBY2CnRwqneMTfEs/ZNRX5DFNeOiLuLW9
         vX14I/3YQ50IUQn95IgKM37Let1UorjwAxl/X+FBVhZE6og68fEuU0iavLT2TmXbTlyE
         GyWg==
X-Gm-Message-State: AOJu0Ywu6r0rtau3KZR1jCv/y08v1bVoSOoVtPH3e0WlpyFOoQS7Gd5W
	i6FWVw5O0mRxiE/hvJ0w03zpndYKfJmUYF39kAH2gjLc5jNBVKbn1KNG
X-Gm-Gg: AeBDietX/vh+5AZPGPD9EuOloKqFKceLs7wKdHLBYydahdWtyx6ejUWPYyo9xlmKOoU
	Js4t3RVY4IAFG1QeBybOYN7JGWyCMqimtFJO2WFlsER1oWBq8eY9rWIAcT3xYQQS94TexfVLQeJ
	3VPoKlJ75NGeWUCXZAvpIDhdVVEEfMWr/Tl/VjFhiQGAzc9AkTDDlI7umve4Bed02vAfoGdLFNK
	LvAtGnKLgcOa3F7/Zi6WYO8wCoqQsnvNd8r97BF55rCZvBpVeDfjptktY89oHLMCt3aIkZ8A1gx
	3h79lr/4Xfu8PfLnGQa1C7HzvXdfEn0+a6w222k5oKPTxf/XBAvHQ/zv0fQl0VMRU1uj0/9Ano9
	UPFSG0KsejztclZ4Cs7G28sXOsO/+dTRW6f52NF6nNYUsCmVi8PZQRVljPLHnm87FYf0AMG+Ptb
	OXx8MOYS2DulOxbP8smpfi1Ol7Edt4rx0jO3x/YIS2pzFuejX2zdPbXABLMOkf/ul5lMTl4Q==
X-Received: by 2002:a05:6a00:35c8:b0:82c:e83d:a9b0 with SMTP id d2e1a72fcca58-82f0c21952fmr2302547b3a.21.1775802157381;
        Thu, 09 Apr 2026 23:22:37 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c3145acsm1802344b3a.6.2026.04.09.23.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 23:22:36 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: validate inline dir size in ocfs2_dir_foreach_blk_id
Date: Fri, 10 Apr 2026 14:22:27 +0800
Message-ID: <20260410062227.3881209-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A crafted inline-data directory can set i_size larger than id_count.
readdir then walks past data->id_data and KASAN reports:

BUG: KASAN: use-after-free in ocfs2_check_dir_entry.isra.0+0x31f/0x370 fs/ocfs2/dir.c:305
Read of size 2 at addr ffff8880088f0008 by task syz.0.1936/4656
Call Trace:
 ...
 ocfs2_check_dir_entry.isra.0+0x31f/0x370 fs/ocfs2/dir.c:305
 ocfs2_dir_foreach_blk_id+0x203/0xa70 fs/ocfs2/dir.c:1805
 ocfs2_dir_foreach_blk fs/ocfs2/dir.c:1933 [inline]
 ocfs2_readdir+0x4ba/0x520 fs/ocfs2/dir.c:1977
 wrap_directory_iterator+0x9c/0xe0 fs/readdir.c:65
 shared_ocfs2_readdir+0x29/0x40 fs/ocfs2/file.c:2822
 iterate_dir+0x276/0x9e0 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:410 [inline]
 __se_sys_getdents64 fs/readdir.c:396 [inline]
 __x64_sys_getdents64+0x143/0x2a0 fs/readdir.c:396
 ...

[CAUSE]
ocfs2_dir_foreach_blk_id() uses i_size_read(inode) as the loop bound
after reading the inode block. Inline directories are only valid while
i_size <= le16_to_cpu(data->id_count), but that invariant is never
checked on read. Once ctx->pos reaches id_count, data->id_data +
ctx->pos points past the inode block and can land in a freed neighbor
page.

[FIX]
Validate i_size_read(inode) against data->id_count immediately after
ocfs2_read_inode_block(). If the inline directory size exceeds its
on-disk capacity, return -EFSCORRUPTED before constructing any dirent
pointer. Keep the change local to ocfs2_dir_foreach_blk_id() so the
patch stays scoped to the readdir bug.

Fixes: 23193e513d1c ("ocfs2: Read support for directories with inline data")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/dir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8c9c4825f984..fa537505d1a9 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1761,6 +1761,7 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 				    struct dir_context *ctx)
 {
 	int ret, i;
+	int error = 0;
 	unsigned long offset = ctx->pos;
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di;
@@ -1777,6 +1778,12 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 	data = &di->id2.i_data;
 
+	if (unlikely(i_size_read(inode) > le16_to_cpu(data->id_count))) {
+		error = -EFSCORRUPTED;
+		mlog_errno(error);
+		goto out;
+	}
+
 	while (ctx->pos < i_size_read(inode)) {
 		/* If the dir block has changed since the last call to
 		 * readdir(2), then we might be pointing to an invalid
@@ -1819,7 +1826,7 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 	}
 out:
 	brelse(di_bh);
-	return 0;
+	return error;
 }
 
 /*
-- 
2.49.0
