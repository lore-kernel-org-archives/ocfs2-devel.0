Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701391B4236
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Jul 2025 02:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751940413; cv=none; b=rMM3CzS7Edtwb3E039PbqqdMmhaNj58w7poT7F2GRIwg3D50nagkneYiGfpsqbQkHWrBI+2s/4B3otabdCnPKYH5cFRr40cDIn3g19vs+uyBBFJDZ11T3H3eBHVkBG/YKoJ/gnk/A/+CQpYg8Hb1fDTJ/mUMPMR5WdO+eTXrVxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751940413; c=relaxed/simple;
	bh=L5DxJjCF4AvHC97m/wvuitUzww2TvZmZwAfZxXkujFY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h15l3HAf53bb+o4Yt/YMDw6zYFq5GUk1Z41DoTCp3GVL6V9G6UyyN1uSJPpn4XO4xnLhMclMFjWQjJ6VYJisqSleBcjpNwjzbkLeiKDYqhXVYnDRxaXfa3ZiazHhoqg/cwUBGM8TlKlky6Ha1aVzpD5Kc08RY246Qoo+1T7ukdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lSrj094i; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lSrj094i"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-234bfe37cccso43906555ad.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 07 Jul 2025 19:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751940412; x=1752545212; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1ILMkgNty9sxK9LcMlRaTbTzCGYHTSnyr/AOuJ+jorA=;
        b=lSrj094i+zV8oPKOqVlv6mOBU0vMlXiWaLIwlDC2zZGQe8hLIeBBS+6mva4LmTZ9oF
         YGstqwAWY8jh4c92ErT7wttAfhv+iN1S0ca8TZIcjMjNv+O/mvusV/qqhQFRkmDUGMrm
         E4KsiLwcKSoBfCU00IJpf/0nokIECoPaXmOIzxYDQiqqrOQCaKp7LXrOGE2eOhxpAtZY
         jnKkBT3PIZgIXscLgPbRO/n5A6ya8fyGUc+9jUBarlLwVDZ7JV/7IUldJTqvUbJK3Lk4
         ZSIDic5vR5zg5AqtgTFX0gyitoM0+i9idrKAzqNL/ifoc6Ugr1hNk6yCeWhcqRekCoY8
         pF8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751940412; x=1752545212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ILMkgNty9sxK9LcMlRaTbTzCGYHTSnyr/AOuJ+jorA=;
        b=OmBigFWfLEc2WfwYlesZ2GmrUOjz6cXn3YZDlDH1+yDlwzP6dhNFDO1nG+I8+WWLS9
         M1HXauE0VALDt+e/oXdpKFtszyrAxFhNW0iN1Eb7nekytK2qDNFMLGbMvgyKbMsF5t1Z
         TARDKFEkYFEyibLqCQYjfs3XhonVGX+s44RcimjDydnpTWM8Usg476mIe+x34nnjZwI2
         GHUo+g+iFEGYnMH37fWO2fYyLu25VA4Bmccnw6yPCyJ+RIG6Ix8pyqf8u7V8WF35a9Cv
         1IzHVs7fxHccVkO9HXAE9DT7wXS6cn5ttdwRBgE7J8ZeUduRKlj8zYz25ejDYKodZGx6
         Cq8A==
X-Forwarded-Encrypted: i=1; AJvYcCWnFPlMJcCocfm8BMpnvDzqes9EJ+u0MErvED0EPQl3FW7zdTg/m6oKEBLx/McPGAqlPwFEwl8085JtoQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyHv1i5mnJCnvTdNeZNSd8s8Q85rpPBfS5+DoIOPo9/Yn9zy9n4
	9ULIA2+o0eQWJ0oCE2veMzWUbLZBDocw3fChTTeONA9ejFKe6mLAwY4+
X-Gm-Gg: ASbGnct2+i3zGtLD13uQ+DXJgVEhb7c8+ZG0xnx0fgu/UhxH2Rd0cWvy8HmOinE1A74
	uuYyDSKEwl1UVHG/KnwzV6PTmKABDkeol8tMHBmUwoMHL3cEEV6KnzW/1I+mcw9mFMdDJacjU/a
	F3hc03qtTEE4wRnBAtVMFsZHAA0A1UFqOmaZ52v63Fi17AEsv4sAOLk/tXKJbG7aajk3SNzfgL0
	awypS9dMM9jrpVZKIGlIfvomo+P5xoe/ve+GOpFqBoJrTUcBMrLgIuLWKRo+juHSyI+CC5gIki5
	RJlzgs1wVndXZ/thEfW+Ia45ZXGHOrJ8odbaS0k1URgZvLkKFp81M0m7T+HzbvANRTzr+a8NzWI
	q90VRu5yIPaPrHbdwMNLZ4YKlMAkZHtLjT58nprm+9sf/gL1AgA==
X-Google-Smtp-Source: AGHT+IFFeBIcfFyPDZPTCystE3GoMnqn3rykNXxu9sxmsJll+yUfFFESSK8pmNNRaJbOTpCSYfHQHA==
X-Received: by 2002:a17:903:17c6:b0:235:2799:61d with SMTP id d9443c01a7336-23dd0afa580mr22319425ad.33.1751940411628;
        Mon, 07 Jul 2025 19:06:51 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55.hsd1.ca.comcast.net ([2601:646:a000:5fc0:7176:525f:68ef:22b9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c845bdcf4sm102329245ad.246.2025.07.07.19.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 19:06:51 -0700 (PDT)
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Ivan Pravdin <ipravdin.official@gmail.com>,
	syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
Subject: [PATCH v4] ocfs2: avoid potential ABBA deadlock by reordering tl_inode lock
Date: Mon,  7 Jul 2025 22:06:40 -0400
Message-ID: <20250708020640.387741-1-ipravdin.official@gmail.com>
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
v3 -> v4: Rearranged gb_inode cleanup.

 fs/ocfs2/move_extents.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 369c7d27befd..cbe2f8ed8897 100644
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
@@ -703,15 +703,14 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
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
 	brelse(gb_bh);
 	iput(gb_inode);
+out_unlock_tl_inode:
+	inode_unlock(tl_inode);
 
 out:
 	if (context->meta_ac) {
-- 
2.45.2

