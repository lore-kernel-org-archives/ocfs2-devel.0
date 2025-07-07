Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969022580FE
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Jul 2025 03:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751859071; cv=none; b=rRiLr2Yx2yQNd80j+WtTJvEsVEtPsDj/2mf6YIuqDkDpFuTlF5jEE/Tml83ryolwXHt6YWj69HcLPDhtqNwoiBXm0SnJkl02DAjaxKDqs21X2i30Hy9vHZoWuq3gdzqKb6nM49tSDzKdpt+zVMaXFjANdsWPq09VRS2zW9pxJKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751859071; c=relaxed/simple;
	bh=5bGLlcz2LNZcz7V3A8E5z8rSY2F/sUreYHn4QIcKulI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Be7EfUCX2Vflz4IB+6w8ThNJWJJD4+or9fmCShzsnOuSRwbANjLcQXQm9qfPPyunPp2dERvUg4S8x8hDcPU1DvwrYuQVLedMuDL0u4XkFQyDgNDKz6F3iObWlCM91Cq97YKL4xFzsy8X+9iysPawBLO2tL7pHdFOJzSjwQxSSc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OZRPiSxv; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OZRPiSxv"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7fd581c2bf4so2104215a12.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 06 Jul 2025 20:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751859069; x=1752463869; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6D4FNc+ZPSxMXR0yzDGObqB7ha5/gNIAEBywyOv4ZVY=;
        b=OZRPiSxv3LnWBRbJBPxh+KUyo/ZjyLy2vzQbYx7G3D470eRZyoNY9/agfHpOWKkbRY
         w1XkJFmleRMnAgk0QVbGZ/73+uVitfr0FZQkzlma9/9zfG1DcfvCBoPPKKBhNSXTSSzL
         LxuwAGIhfS0tbKt3zKMjLkOk4I7+1YZnMvoHoQLAlcK/EyP8VbKCDPM/e7b+3/C+t1Ep
         TT4DKIhrQ85k7UEv1Prr8qVRZ6NuNQ3dQEK5rtgnKkY9yQ17I/57wXjoUZGPDIFuxCoM
         pCuYWuW1+S0cK66fWFwpFyq9p4GKnrkYlSyEwLz5cgJS9ck/kW9giDTHe7txbTNJpKsb
         CPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751859069; x=1752463869;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6D4FNc+ZPSxMXR0yzDGObqB7ha5/gNIAEBywyOv4ZVY=;
        b=b64YtWnXkw4Gg91ONYiwVW4eUJQeOX58TX7+l1xSYYt1OfVf8Q7XTtraF5enxeztlw
         LbME1nJjh7ngKYHMquBa+eq/eVLWyeVvRlzqmUwWcuzKtalrGymHBgVZW4AGm748hzfZ
         rdZQAlCkkpiny1QwJ5GrzTqU65yv/yxTjiZMtEyNBxtC0iWculVe5Oe2MU0a7zp7cVUU
         ER9c8RD6gpsMrV94FD76p+BwQumuLaCe9JRQvECIlIPWHbsf67ns1ahQU+dqJzx2WPAj
         epz7gEAnM50B8uTnMRATGOSHdI7K0M3tAZyd2Zk0SMdjiVbeAOB2pk24Vsm4ce78Tp1d
         locQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCGUviPTPxgzVn53XcdyVajH29Dzz8elvQv+eIUOri6h119W5NbgIWO7FTnsUY1MiMkNEcQ7976duVgg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyEeQ2U5eHGgs/A36/GVyXDd/zKQizICu+7PYf5hxRGw496hApw
	Zio9QG5JDMynqkz+jPUzYtHC/I9hN9SXV39hFXEPQnf5xYpcJ7YUoEj+
X-Gm-Gg: ASbGncuqubyg5RHoGGP1sgOZyvfKelX4dnE1KhG9FFZAhe6GuSMeKfVgK+p0uuQg7MW
	slrJOIbeRyGGSOA19e6ny9odT5hGAT/b9HuOeQ7L5OTsoC+k/PJiSHL+J42NhZHOHGid6lI7jj2
	mwCK4/T6mI/Y/rVRc7NxIREk+ekDBWVaFfHH5vbjAuYfN0DW4CkmrRN7gIPbTXBBq3RUYSI7PtU
	4cR85alzEHr4cGg20Thfgp0wlD+e5hTyoN5lnoSi2VJutjepOmYRIbQUQJXeIl6PSoMKN8j7MKQ
	P42ugwO6d5jLR1i46YIVTjpu6H3ehWrvifgWAln2Yj6BnbY2KXC1GE8UWw0TrNYzuBlCqdFz7GT
	txnOQ6nTXlGb9aO49gdoiNd9/X2P6ntYL6jtusvNQE+KVkN2xiA==
X-Google-Smtp-Source: AGHT+IEVYxAqKEVcCfg4J8NqSrjAG5zg58gwvdEAbHHYEWOVkuup7CGKWYMfT6CQpOy35AnTNXLlXA==
X-Received: by 2002:a17:902:ce89:b0:234:d7b2:2ab9 with SMTP id d9443c01a7336-23c87472898mr163559135ad.12.1751859068755;
        Sun, 06 Jul 2025 20:31:08 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55.hsd1.ca.comcast.net ([2601:646:a000:5fc0:5e93:4ea0:4954:ef6c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8fcf6715sm48359415ad.51.2025.07.06.20.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jul 2025 20:31:08 -0700 (PDT)
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Ivan Pravdin <ipravdin.official@gmail.com>,
	syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: avoid potential ABBA deadlock by reordering tl_inode lock
Date: Sun,  6 Jul 2025 23:29:51 -0400
Message-ID: <20250707032951.361331-1-ipravdin.official@gmail.com>
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

 fs/ocfs2/move_extents.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 369c7d27befd..aaf8eb2693a4 100644
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
@@ -637,13 +639,11 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 		goto out_unlock_gb_mutex;
 	}
 
-	inode_lock(tl_inode);
-
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto out_unlock_tl_inode;
+		goto out_unlock_gb_inode;
 	}
 
 	new_phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *new_phys_cpos);
@@ -704,12 +704,13 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	ocfs2_commit_trans(osb, handle);
 	brelse(gd_bh);
 
-out_unlock_tl_inode:
-	inode_unlock(tl_inode);
-
+out_unlock_gb_inode:
 	ocfs2_inode_unlock(gb_inode, 1);
+
 out_unlock_gb_mutex:
 	inode_unlock(gb_inode);
+
+	inode_unlock(tl_inode);
 	brelse(gb_bh);
 	iput(gb_inode);
 
-- 
2.45.2

