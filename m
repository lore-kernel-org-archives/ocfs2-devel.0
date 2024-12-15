Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2AD8C1F
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Dec 2024 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734235233; cv=none; b=KJ++QwmGwo/MxDnThBYE5IV7BrJLftJb1ZBBFhR+jwOpvqAq3cJl+GbsveF3JKQwpcKrr1XJJc06xCXkmVJO0Fl5U2kHO6mE5EGaLA1hTViCMcARxrZIGiYkhkJVpiMjNoxvpgd1F9C6L/n7phkkBMHLIxGYh6K8TXyDWhndRzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734235233; c=relaxed/simple;
	bh=AhHs8wDXptTDXqO88AynHTjfp9xWvm0BZ1ABm1nrtek=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JTvfA8cnEJlc8jeK0CUajQcl2MRLfYI+/SYpymuGVaABcWKRPD04dgH7akzg4Ao/MkpvN3I46XrXDI2+xV+rptxSPqAL7iBaL2anZTEKalWnwNuT1mmxTq9upCJvWv6zLqPMJf7/z0je3319U4ojEVPpHwkWf5hvSYqRw9HJPmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WQbZX51Q; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQbZX51Q"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-467a17055e6so30089041cf.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 20:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734235230; x=1734840030; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/9GqpNH/QUF1rjt8cgarwiZ2r7vZlmB7WaQfeZrmbY8=;
        b=WQbZX51QfWzpEYRYszgqjH89p+/0drc5OYsaMqdaBv5rEL2jQV1isPQZ3MbXt/snr1
         8sl3cLMMdPFDWZQz8VNRNWOZO/ZVWU11V3DMp4T9TpljEj99xrHzBmOmQ60WtMBfpBY/
         z66RLmMu9QsWBaUEk+dxXeCS9FXf4ynIR0kE1cmCeAAz7Ixclol50drTGhLh65CkkKCk
         3rcD1MrnvYaw+RZ/F3DWpDFEYajhUMjpOvPYf/s4qL7HUtN7ENTO1Ef9ZIhAEWO6AET/
         GqUdBv3pDZI2OtivnZ7mb0RD9JRzsc1JNuj5VA4tDs/guLoKMpGSJqPjkeieLayCDzxp
         K0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734235230; x=1734840030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/9GqpNH/QUF1rjt8cgarwiZ2r7vZlmB7WaQfeZrmbY8=;
        b=jiu5GW/TYjQCzaGi71RqQCHwrSmT6poHjQRyrLjIbGzMsqH1MNMlsLNlzyw95nz/pB
         FZW7MOfwChDIJfy/+0c9sOGwVp4R2EF9ShAHZWfVQCW1ub0TmkcVxvsxqvoSr9KwMF1t
         hTU3HJVjLv2xcvHnpa6eIiS3agrJ0vU4mbvQj4Tuq9NRiHyQ9ZkqMxI9OPEp8Zkm+5wu
         xq6fs/94yH/XlwB1erVRh3May/Nuz1dLSMMUEHLErNQnMn62ZGs0PvTBaA8q5HXXqxXa
         BwkuUXkODyLvV9HLoRayCT0xAo4oMDJYDT9HMe+rh+S4NhwFuA1RpaWSbk+Dh/jA4SXn
         Yd6w==
X-Gm-Message-State: AOJu0YzSdBm7ke3Y38YHPeeZEOWy0YN3KD/bqv1G5l3fcBOBRo+RIMnF
	qLOGPUHvsiHtCA8ppNQBnWuszWa6muaLCtXIQ837VpI+pWY0ixpW
X-Gm-Gg: ASbGncsXHG1EIZEI0yAxKR5s707yB5NTQY8xuNxlCT+v+ubZs5YHf93jvbAcRaKuJ0j
	M4SFAisTMFwb8Sx3rYzqd3XkANm2UKpRfSk/oE6AIPwiYWtVF+g3jrL5HVCIYlH/rLWwuNXwtPb
	gmik1YKWxza9OKVF1A6ZIYPEzOQKbB6tNH2Whrtfk1u/k/wpjVLPsDTheM8/oY3WtTsk8BCcUqx
	uJzV5Sa28K+IWSBIFVhxeXGCBwUQ6fG0mDTklXAgcQ3uXwSxsBn6CDa+Tm529wMppdq1qLuwsW3
	dgVsKlvX1up++hir3NAkgb2yCmxWc/uNgI0=
X-Google-Smtp-Source: AGHT+IHxa9F8PDQJ3jj9NFmjBJdz4vd3H5LBFlmQ12JfK1aWCMiYBrBOyDF7CcAl9/TzRYCuB71UrA==
X-Received: by 2002:a05:6214:508f:b0:6d4:243f:6c9c with SMTP id 6a1803df08f44-6dc8469848dmr143052216d6.9.1734235229718;
        Sat, 14 Dec 2024 20:00:29 -0800 (PST)
Received: from localhost.localdomain (d24-150-189-55.home.cgocable.net. [24.150.189.55])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6dccd22fed2sm13365546d6.10.2024.12.14.20.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2024 20:00:29 -0800 (PST)
From: Dennis Lam <dennis.lamerice@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com,
	Dennis Lam <dennis.lamerice@gmail.com>
Subject: [PATCH] ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
Date: Sat, 14 Dec 2024 22:58:29 -0500
Message-ID: <20241215035828.106936-2-dennis.lamerice@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mounting ocfs2 and then remounting it as read-only, a
slab-use-after-free occurs after the user uses a syscall to
quota_getnextquota. Specifically, sb_dqinfo(sb, type)->dqi_priv is the
dangling pointer.

During the remounting process, the pointer dqi_priv is freed but is
never set as null leaving it to to be accessed. Additionally, the
read-only option for remounting sets the DQUOT_SUSPENDED flag instead of
setting the DQUOT_USAGE_ENABLED flags. Moreover, later in the process of
getting the next quota, the function ocfs2_get_next_id is called and
only checks the quota usage flags and not the quota suspended flags.

To fix this, I set dqi_priv to null when it is freed after remounting
with read-only and put a check for DQUOT_SUSPENDED in ocfs2_get_next_id.

Signed-off-by: Dennis Lam <dennis.lamerice@gmail.com>
Reported-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6731d26f.050a0220.1fb99c.014b.GAE@google.com/T/
---
 fs/ocfs2/quota_global.c | 3 ++-
 fs/ocfs2/quota_local.c  | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 2b0daced98eb..c6d38340d6d4 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -893,7 +893,8 @@ static int ocfs2_get_next_id(struct super_block *sb, struct kqid *qid)
 	int status = 0;
 
 	trace_ocfs2_get_next_id(from_kqid(&init_user_ns, *qid), type);
-	if (!sb_has_quota_loaded(sb, type)) {
+	if (!sb_has_quota_loaded(sb, type) ||
+			sb_dqopt(sb)->flags & DQUOT_SUSPENDED) {
 		status = -ESRCH;
 		goto out;
 	}
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 73d3367c533b..2956d888c131 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -867,6 +867,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	brelse(oinfo->dqi_libh);
 	brelse(oinfo->dqi_lqi_bh);
 	kfree(oinfo);
+	info->dqi_priv = NULL;
 	return status;
 }
 
-- 
2.47.0

