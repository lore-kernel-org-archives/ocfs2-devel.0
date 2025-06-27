Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59ED1F19A
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Jun 2025 02:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750991975; cv=none; b=fceX2doikm/qkaVxnk5ZUeg/AmruEhlsOoX3zBrkioYP1hhjdpK1sxIdtAZK70XICnmjO15gL6JuHmGQ0duWKdeHJNjEsPc8fkIyrd4yXwsfsRfanyIeUiOz13Q2oV6zy+4rqjcXWCgwj8rdyeov3wbvL+5CTDH8Qb74qxZicOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750991975; c=relaxed/simple;
	bh=vvXfD1IfkO52OboqRZXTZrSZOnFkJz+wyFRQ1bQn7AY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dAfoidvX5WFO+o9c7TW/TQSM6bbZnICy+vlKSt9oztpuv64vKfBycpHaSBt0vILOx8DrKHj4L9rZXB7e0p1W7M9rzA98pxxztj58x0TVz3ofRjvMLsXFsP0EeLoIeQLFJgOUK6lIWUGxe3XgX1wd/8xEpFxuUZHg4BdyHiyD6/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A0BxJrl8; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A0BxJrl8"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-235d6de331fso23826145ad.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Jun 2025 19:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750991973; x=1751596773; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+Xmpn0m1NNRLGqOUCu2eX/6jrBk9qwF49IxfMBhpEU=;
        b=A0BxJrl8xaVlLRkvEhuPFS+DWOpsQKb+l/HT3zqf1KoQJn4GLg0TzxtyR1wj0Hi6Kt
         P/N+Xm5O+B76tM2XIY0UOTJt3t3wDfKt08iEZe0vRGjo4TkfcWA1uo2I99yFl99lBtiJ
         S8mk7T36oEGLSjgZPuW7diDW1npc7/RETVpTp+r/TCDPREGrLOHv5OeD/1hivBSWwxPV
         ZvxK3O4g8qjvBRqRmjQtKcPTiKM04dGqhVKOzVh3Rj7dS5OET4WKVHWpXOekZEi2oEfZ
         Lls5TaqBwvrhWp9PMzU7Cf1yLh85K9IBlU7JRapcbma/jsBM2HtP2dyrh4dZuvpFWHvf
         7Mwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750991973; x=1751596773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q+Xmpn0m1NNRLGqOUCu2eX/6jrBk9qwF49IxfMBhpEU=;
        b=DYnRnh7CfGuuzIqFimuavO+cjbC36K5LkhIyFWEgr76HyL+jGg5wQ3yw8JKt4C2alK
         +Rslg6JlaiJTn5Y00KMVe9/5TJirHmWSdIIgoYv0IsHblfiNb8DnE8nEXwKnI77nMyNx
         /2ZP1GLJL8ckcZBrzMHLY+Vsr3OHUfbxUAIRjjTmHOXgkCGjSbeAxd+HL5K8b6lmBryZ
         qZEneNSX0Wqx4oboj1JmEQUGbhJtxgr6ELGAnoymLp+NEpNZdkh0xRyJaP591J1NOi6o
         Jgg99gIn92WxC6wIbQXBXBH4GE4GPDY1SnOF9IjMMTA9W9xDLKC6T15aLLx8gwAHfMyN
         F7Zg==
X-Forwarded-Encrypted: i=1; AJvYcCU/+B+Hjc/v3AbVaGtN2ZrHOmzJUV6bNHWQBVnLjvMlbXNnHrRUdeZ6N5EglV62oJa07SHorsvJtJqWUg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5KRzbJotKMxoJ1EU/HIS0Fquz1Vcu9VOrBF0YVs50e4OBTiD5
	ddVTarkLZrU8GvJQyy7W2ZhAM1ZaB3LoUtYc0hyF/Xny52FUx6EJ9G60
X-Gm-Gg: ASbGncsbX1uCITR/FKFlLWCvuQtomOYFtcGa/9YI1EPxdY1AN6WJ9WQrDi/9k8QscNH
	bX0aJbpe7X0E7TZRHf7wu/Y5t3nP+Gpxc6NMaP22j9gu1VrKwVDtLwkLt+VU+PXjLWsktX3fnmb
	d0h26MTz1hrUwfN1GuRsZvHDuAc+ZJKZXMyeS7Xq1OC3lNVQboZqW3Gt4lahdeGa7SE8JrYCAXP
	fUbtNDWyM03s/0tujE/u1kfEjYuFznosPtHTxzpUrNv0x/QvI4YoDGE1dDoAp3QQItdaMFDcAxz
	oIGKUK4jhSf+7X+S8teDgBqLuhJ7FYQIJMU97BFARrk39dS9J4nuKnhuS5c1qZkUyn39TfAGbPG
	5E0guOPON3iD6LbVQwMu0b3qC8Ruo/Tl6kOhIDQ==
X-Google-Smtp-Source: AGHT+IGT6mSXkMoZBI9eS+i+6n5dkAlAiLro6eu3jOH5Rab/6j/ltru+m7KO0gmlC0KataXVrNbGHA==
X-Received: by 2002:a17:903:2f4c:b0:234:eb6:a35d with SMTP id d9443c01a7336-23ac4606503mr22426855ad.27.1750991972966;
        Thu, 26 Jun 2025 19:39:32 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55.hsd1.ca.comcast.net ([2601:646:a000:5fc0:ac9:41cf:eabf:a84b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c5bc7sm4037755ad.221.2025.06.26.19.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 19:39:32 -0700 (PDT)
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Ivan Pravdin <ipravdin.official@gmail.com>,
	syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: Avoid NULL pointer dereference in dx_dir_lookup_rec()
Date: Thu, 26 Jun 2025 22:38:30 -0400
Message-ID: <20250627023830.150291-1-ipravdin.official@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
error message that unconditionally dereferences the 'rec' pointer.
However, if 'rec' is NULL, this leads to a NULL pointer dereference and
a kernel panic.

Add an explicit check for a NULL 'rec' and use an alternate error
message in that case to avoid unsafe access.

Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67483b75.050a0220.253251.007c.GAE@google.com/T/
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
---
 fs/ocfs2/dir.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 7799f4d16ce9..dccf0349e523 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -809,11 +809,17 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 	}
 
 	if (!found) {
-		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
-				  inode->i_ino,
-				  le32_to_cpu(rec->e_cpos),
-				  ocfs2_rec_clusters(el, rec));
+		if (rec) {
+			ret = ocfs2_error(inode->i_sb,
+					"Inode %lu has bad extent record (%u, %u, 0) in btree\n",
+					inode->i_ino,
+					le32_to_cpu(rec->e_cpos),
+					ocfs2_rec_clusters(el, rec));
+		} else {
+			ret = ocfs2_error(inode->i_sb,
+					"Inode %lu has no extent records in btree\n",
+					inode->i_ino);
+		}
 		goto out;
 	}
 
-- 
2.45.2

