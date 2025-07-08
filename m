Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383EE801
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Jul 2025 00:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751934925; cv=none; b=L6Mb59yN3euCCft+knkgfy7aZHJuv9uyYEDJzvENcD0acO1OjgnDSu3K8uWWQzeCblpJP4FBNfGOh4R/XwTH2ENhKrO0vP8HPobpOAVVflWiIXVRlzQa/KEpkODohO4MRg4ke0qsox7xK5126+x5MZ6mjnBEZ+sjnV5DBwtuLwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751934925; c=relaxed/simple;
	bh=wQYFt5K7RXr92fANj8A5bbXj6ZGgg/VTbMPoUP1YZYY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jeGCewDKIl/DyO7pti6sT4gAiBDTLowD6vhnQUPzF3fZKH7jp3kUK9zBwLKPmDWZbdBQ6J10Ajrj7zUv1r7awAtJNDKSRJGvw9Lz5bjvI3jURTMydrW58I3S8KCKPNKchPh4kYqMZwaLg5/6/d1qJsuWRGG4GL+NS8xWk1+QO90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F2cojDq7; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F2cojDq7"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3137c20213cso3657458a91.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 07 Jul 2025 17:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751934923; x=1752539723; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wf3o4V2I80SyK6m01qE6WqU7O8JhAfMNmh4JIjwVcuk=;
        b=F2cojDq7FgsRUqQ9UVvkZK0uJAE8C74uimsZJKTC/IAn3t2atjgdvln8FvKX7ZbDbl
         AWAMmvDH1fwnUVfW5SWMtMNVF9K3Opf39HdvO8ru9G6LrrBfHq02nYPPQjNI4kK9bHyH
         YO8icoborv7+/8NSgbuqWu3jFSWSiRT7zvBSGHgEmjZGQSjoTF9G9Az3ugtubG6axAwx
         tT3tx0v2fJ/E0BWlnWgcGu4+gwr8rTZmZ/QduXr5oS3ILaiZdJG8x6/6YSRPkui31bDu
         kG/JdsKh2j5r4zVeBFyELjNxCKh4dhZ93o5OzdRg/1Dd90+5rMeCbpeq4QKRIV5eUTHe
         QRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751934923; x=1752539723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wf3o4V2I80SyK6m01qE6WqU7O8JhAfMNmh4JIjwVcuk=;
        b=Cy9d97i94mSUclAebXfzE29q7nFG5ufFsnJhOUl2nAn34FyYvzNoy8+6ywPzRxqn+8
         4g9lQB1o//RI3y+QKXOB7CJOOMNj9YqBCn3JJeEnLLDDwdGZ0c9YaC4m6ykVZxpJpy5l
         3W3PUjewUdkWzCi2kxUuDPAMmLq9+dyP8E2cjSyVAcGRjT8WHHUQLmxRDXMy/OwC+Y2e
         4KbjFKubW0GZPex1VkS9FEahkrZju3i/uCobWlO10b8lEsH4AvGX860R9O+1PtWSt9+V
         jtnHuqHKdA7Ih5kxsBvM+jpm0PXutpdsznsFdX4XT4eCtvXYBq/CzpWTVE9gT1RDgdud
         0kgw==
X-Forwarded-Encrypted: i=1; AJvYcCXwyLyJ174+41uTWiGGa8Ud1eHDOKYmIGAGy/86nun+IfckN0RLT5uDkZ/olXBYq6Ntuh0hG8lgx3jmcA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzy5Dg4cHeskIbgYbH/1w1WQAnkksKTimNhULjvMrBKJN2iZrq5
	bB9gre2aIlQ14ENLVQbPonTtl8ucMnKYkX/q9yNXxI587TddHi1IRC7u
X-Gm-Gg: ASbGncvAqmkMtEH/zUCYdOM7QbkdcEpl0plsOWU6igqg+BkOJ/SyGPdZQonG3IuJRxu
	kKNcLKeiOrnROK34sh8zUdqlZYmJyWuwiEpLP8f3DXaDvg3HcyXuBEthdK/QhgvNnawPU5vUXOX
	KWeKxUejoC/Q/IvOAe+STiVlRjTSsp7C6g82ul4zt9BcrluJbfptCHdob6LPrKfWy4+qJ9RIi5e
	enjuXFQEYXXeebgg8hrmnxbQKvaLYa925YOiGS2pd7DXINCq/eqSv9Ed5uSyfctFi3PEoxZEGHm
	j0X4QLy6IxpHkvAELvOvBcPDMhoi+6PWKA8Ob8V+TYNwRMZZxnAdC0H3IgAJkU3U3P2iRmN3Hoq
	tjL7ulLL9mq1WN2gy/Gi2bN2eWx/EtEI/XFwDzqM=
X-Google-Smtp-Source: AGHT+IH7TGLslieM/fqIp/Wft6U3ZL8rXycUBYC1okgKhh5EJ8jEKkIQXVGhccdpvcMVjtgDYb8ShQ==
X-Received: by 2002:a17:90b:5488:b0:311:fde5:c4b6 with SMTP id 98e67ed59e1d1-31aac432a9amr19372939a91.6.1751934923319;
        Mon, 07 Jul 2025 17:35:23 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55.hsd1.ca.comcast.net ([2601:646:a000:5fc0:268b:48b1:88cf:6e90])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c21e8b48fsm518749a91.33.2025.07.07.17.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 17:35:22 -0700 (PDT)
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Ivan Pravdin <ipravdin.official@gmail.com>,
	syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
Subject: [PATCH v3] ocfs2: avoid potential ABBA deadlock by reordering tl_inode lock
Date: Mon,  7 Jul 2025 20:35:19 -0400
Message-ID: <20250708003519.379597-1-ipravdin.official@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ocfs2_move_extent(), tl_inode is currently locked after the global
bitmap inode. However, in ocfs2_flush_truncate_log(), the lock order
is reversed: tl_inode is locked first, followed by the global bitmap
inode.

This creates a classic ABBA deadlock scenario if two threads attempt
these operations concurrently and acquire the locks in different orders.

To prevent this, move the tl_inode locking earlier in
ocfs2_move_extent(), so that it always precedes the global bitmap
inode lock.

No functional changes beyond lock ordering.

Reported-by: syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67d5645c.050a0220.1dc86f.0004.GAE@google.com/
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
---
v1 -> v2: Fixed unlocking order in ocfs2_move_extent.
v2 -> v3: Added missing out_unlock_tl_inode and renamed out_unlock_gb_mutex to
		  out_unlock_gb_inode and out_unlock_gb_inode to out_unlock.

 fs/ocfs2/move_extents.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 369c7d27befd..9d1fa8ecd97e 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -617,6 +617,8 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	 */
 	credits += OCFS2_INODE_UPDATE_CREDITS + 1;
 
+	inode_lock(tl_inode);
+
 	/*
 	 * ocfs2_move_extent() didn't reserve any clusters in lock_allocators()
 	 * logic, while we still need to lock the global_bitmap.
@@ -626,7 +628,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	if (!gb_inode) {
 		mlog(ML_ERROR, "unable to get global_bitmap inode\n");
 		ret = -EIO;
-		goto out;
+		goto out_unlock_tl_inode;
 	}
 
 	inode_lock(gb_inode);
@@ -634,16 +636,14 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	ret = ocfs2_inode_lock(gb_inode, &gb_bh, 1);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_unlock_gb_mutex;
+		goto out_unlock_gb_inode;
 	}
 
-	inode_lock(tl_inode);
-
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto out_unlock_tl_inode;
+		goto out_unlock;
 	}
 
 	new_phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *new_phys_cpos);
@@ -703,13 +703,12 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 	brelse(gd_bh);
-
-out_unlock_tl_inode:
-	inode_unlock(tl_inode);
-
+out_unlock:
 	ocfs2_inode_unlock(gb_inode, 1);
-out_unlock_gb_mutex:
+out_unlock_gb_inode:
 	inode_unlock(gb_inode);
+out_unlock_tl_inode:
+	inode_unlock(tl_inode);
 	brelse(gb_bh);
 	iput(gb_inode);
 
-- 
2.45.2

