Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676B04D90B1
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 15:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449083; cv=none; b=EiXEGPUym6V0u4RXmCEd1sk6iAoqrphjAiNDFm+ntwMelEe9v0DgWzONm7C87F5xo0f+y59ohUHvTTGK6QBXXjRXhgiQaZ1c0VpoSg/AOyBh4Bh2apZvBfRY+s9VNNoZVibCVBVcebMZnZOHcQZYi1afWObo+J7z1+3FN2dWmjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449083; c=relaxed/simple;
	bh=hiRQlPpIGglFRXty3EYqUEUerglqeZb/X1JgjZonIb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pDgB/3ZRcuyxviuj0o3JmAdd5BCb7AxXl6KiQVNE1MIkntdTbm/5e4Xi/0NZw5cIr8Zqlc2krB3G+I5KDOJ2ws/QiKzJ7KAF8se/JMJ1p4Lz2rU2WwuHVPZ/68Hh+IRf3E1225s4U0/ptI+8M+4sbgB428G4xgyfMZrKb+J8t5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GdnKZSHS; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GdnKZSHS"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-499b10c86edso1058255e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 03 Sep 2026 08:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788449081; x=1789053881; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fKRvoFT0iXNtYocSHfeIp3eZzwJLnARoSnyrks3zVww=;
        b=GdnKZSHSfzIpeWaD+plhIC8AP8ffrj/piPRCXFocvzxy0PjyFUBBr+1N1c04KX3Mj+
         RoHnStugRPzQJqT4pb1LkOl4XalV+jykZkfOQ7TB7CvnkPkARwphuklkW4amdnimx1J6
         zC9Xroc/SWgWKAK4ueXp844rEIFilISZ0KawVQoylk2HdsvjXD1SPe8T3LI39e1llYmJ
         OnxKUAWwzH9y4jS36GzXkUdNT4gZ1vUycXU2iCh4zstwa9RnNBPMgM30lFTWYC87Um21
         gvOz1eZw1R3H4JkTZB2UMycdZQ74u5VJUWr4z/h5IA6zm4gRiZ9l2dZf38wuK3ilPH9Z
         0L5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788449081; x=1789053881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fKRvoFT0iXNtYocSHfeIp3eZzwJLnARoSnyrks3zVww=;
        b=OUe/04xdBUir/AiHd6pH/RhXHffl9HP4Ba6u0cMHilQF7kbqNx9AV8jNT4QHHxx2oz
         79Jv6fm1Hvkxy9oZ7yroIOm0Oh43H0nH5fj1L27QgCk4v68yC6ATN/w+voaaJzQFqf+A
         onpO1RMh6JbQKKvL7InAxhbgz9/aWGFgAjwsI6FWVOFZiW5+x+d5Js3WwWBVOqFf1jPM
         Idk+81TP+MwWTKpWnlLm+qfzTEgkr/clPTURa3TQxwEzncchUTEw8lq/5dk3jVQWdGgo
         10lSsZvRFD4GN45NELakuY+YznEX8sf6iwtqBki2bILU3xcaD2hggIYyV5tO4pPeeypq
         TMWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwCT3Qd/Ms5qw+xdSBiLChmrL1Q3qXXdT86d+EKSLaqPIkYocwKbzG13Y5GmSopGmy4x6JUt7BPC5/iTw==@lists.linux.dev
X-Gm-Message-State: AFuF++kK0C2nlzUfbasRBrS8F9jCXPdtrQ0E8lABy7bkRxIscr2hNToZ
	d3uC42b2wv/2kIv8YzLc7ekiRpTf3qRcGDlpypf38/NUt1qUDvHMLCwK
X-Gm-Gg: AYBFou2/MMAHLHCrm42mbbOpMg9su2RTKvIpwpSZj3qXAU/yhZ5K07egkFabUgjpP3u
	wyCeaHrsgbKg7dBmE6lmNKWDTIBXuHojVPj8j0CGK0mxEjuF/LLQXdCD5yYunjn2AUgc35W8I3h
	XEmpQNza+fimV7+sIBKWFu845Nmkfif0TgiO1NNWV71l9g9aZCnwfRX7CRNxcLBuZn4zjMgxvhK
	BqXBUyang9G5ND9ZxYMoV99OSBJbcJo1Fl0hZ7Gk6PkW1m5+OzOVM7sM4SSBDG6M7M5r45/GbQv
	DXlG5ZgLwm6qpSPXHP3pPMYZmYQyVdqdD0eYEqA0/zKMUFmp4utQxlGJfnTVeKVail6lVFBr375
	opQCRXdfGJntD4BcXKrgh5R6H+HZQ6BBEFuF7jVfA2udRIF2bpymOJU//SdXEOdZBJFXN8aPpVP
	Xao2QQNW36fYJvi9tJIcqeWAs1dzC1uj06/Gju4KaLVCbfnf98Pi5GzVdHN6HQwqUQleMTMF6os
	FK5rNhlmgEphR/8g7dcUV3AdfZOgaCstzF8UioUXokCzV5JeuVbS2t1zTrBRwXoSMzGlDGpLG9B
	r9swvYbHIGYG7g==
X-Received: by 2002:a05:600c:a03:b0:492:4a7a:e415 with SMTP id 5b1f17b1804b1-49ce583e8d8mr109612635e9.2.1788449080400;
        Thu, 03 Sep 2026 08:24:40 -0700 (PDT)
Received: from pop-os.. (98.102.222.87.dynamic.jazztel.es. [87.222.102.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5563c6csm107207695e9.4.2026.09.03.08.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:24:39 -0700 (PDT)
From: Miguel Garcia <miguelgarciaroman8@gmail.com>
To: stable@vger.kernel.org
Cc: pvmohammedanees2003@gmail.com,
	akpm@linux-foundation.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] ocfs2: fix deadlock in ocfs2_get_system_file_inode
Date: Thu,  3 Sep 2026 17:24:35 +0200
Message-ID: <20260903152435.1801594-1-miguelgarciaroman8@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mohammed Anees <pvmohammedanees2003@gmail.com>

commit 7bf1823e010e8db2fb649c790bd1b449a75f52d8 upstream.

syzbot has found a possible deadlock in ocfs2_get_system_file_inode [1].

The scenario is depicted here,

	CPU0					CPU1
lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&osb->system_file_mutex);
                               lock(&ocfs2_file_ip_alloc_sem_key);
lock(&osb->system_file_mutex);

The function calls which could lead to this are:

CPU0
ocfs2_mknod - lock(&ocfs2_file_ip_alloc_sem_key);
.
.
.
ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);

CPU1 -
ocfs2_fill_super - lock(&osb->system_file_mutex);
.
.
.
ocfs2_read_virt_blocks - lock(&ocfs2_file_ip_alloc_sem_key);

This issue can be resolved by making the down_read -> down_read_try
in the ocfs2_read_virt_blocks.

[1] https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd

Link: https://lkml.kernel.org/r/20240924093257.7181-1-pvmohammedanees2003@gmail.com
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: <syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd
Tested-by: syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Miguel Garcia <miguelgarciaroman8@gmail.com>
---
 fs/ocfs2/extent_map.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index bb3a56b7f9a7c..5e86c7e2c8212 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -981,7 +981,13 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 	}
 
 	while (done < nr) {
-		down_read(&OCFS2_I(inode)->ip_alloc_sem);
+		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
+			rc = -EAGAIN;
+			mlog(ML_ERROR,
+				 "Inode #%llu ip_alloc_sem is temporarily unavailable\n",
+				 (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			break;
+		}
 		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
 						 &p_block, &p_count, NULL);
 		up_read(&OCFS2_I(inode)->ip_alloc_sem);
-- 
2.43.0

