Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A86153376
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Sep 2024 22:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725660779; cv=none; b=e9VgQpYeA9frab/3G0fDTmAL9HvF3Hb2IrD0ulzaTYGo+aJtt9UXEOK+tAiARNfic2+4bsS042MrlZp8ZSi0fnU3fcx4/xy3Czyb+MzWZdKWK7eopHxuwV70k9api+11UBVorthuRaLZHCEU5CPpDzmDroTpzP1S3Xy/ardiHko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725660779; c=relaxed/simple;
	bh=vC2jlXeWZrkHd67rtbyK0b0IevP8+AsDT09vOfr11qI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M+J5612a+huo1wbQHvTSPJ87KZFtQ84yxIrpJiULnKt6gNr9HC00LrbpxgvQMBtV+GMkK9jfe3TrVA/uHxL4/zI6+/5e8+OgRUcttHNrOBMqP8l5ClliGMJ+9ocC7nZ5Ft4QlYW0H6aQDjMGF6hy6xglE6JPS1B6/TR2nhhRCu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T7dyYgZg; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7dyYgZg"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7d4ed6158bcso1978509a12.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 06 Sep 2024 15:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725660778; x=1726265578; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NlEhQbcrtuiKn41rbnp2orLFJEhAmkBROEPy0RN6ODk=;
        b=T7dyYgZg77vvS9hnmKEvO8xAHqAvhBrra4sJUTh+pp1IQarxT6dHm5bArN4nqB5CIM
         liHvrZLnhM28IwOCpc4tvjzjGQAhdWbUpHZzibHHGJSX0Ld/+u1p1IevvPhVyonBiIGC
         ojquuhicj9XqDnaO6IaIWUhdp8PbsueuOGKkApItag3zCsZoyGZzO36Y6YYAS6ZKddH/
         90rPztK/ttbPwAZQgYfqnLGF5lOGUoNNiqnL51UCmVa0zMlH4m2UIDsOc+6Xl++4oVfc
         uAEuSc2uAnmFH+n/TJEkDSL4pejckObntxgQmO+5cxIzBYyJfI78jmFYlaw3ZBlbODbm
         pycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725660778; x=1726265578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NlEhQbcrtuiKn41rbnp2orLFJEhAmkBROEPy0RN6ODk=;
        b=HOMzGH5moz8o/Q/jdYyzdFDlnBa3ROMMGnCc7YVBPrZ3OLWaWYwJ0wVPMvBRiE/Z3q
         3VVY/13VQjteXLUBQolruUXf/SR1LjjKCnxK+OibVAmqPLW0Zbr05l7DXLiUxrRVMzE1
         OSm/1mZZYEXVtdVutkjw0gdlGfCIuhcYZNp7PyX7gdMrvFqyEL3SIeDYTBuIkYlWSWtq
         J1nuP8szU6XiOCdql0jHgeQsjfJ4n2JFTgKAFMxQWLkMjB7phPYhXcTvikxVvdWSvWWB
         /aEXLFto8lQyqEyCEME7Eb/0wqb0w2qF1q17QdW6NGF/A4LU+F/WsGzBErrQqYh17V+7
         RELQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxbuYmdnCMz/3cVE9hOcC7jue5oyq7BqGPxi5SWTWOtYMkgPxpianTReNFp7BD6s2+BXNHqUf5wrqgdA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxq1Rdbhy0kSkVA07sPg8zbaRlR8DTFgITutjhcgENTkXYkaCYW
	L0Qv5cV9JtoWaNX4WOUtQHj72kmpkV/CgEKE3eMC+qFdeYSMgcCg
X-Google-Smtp-Source: AGHT+IHzXyCRUhCCBbe80Dj6g97lXpPOvAy5LlL8HhBXDrgzfOw0Sxs5IjLy0ckCz+8zztvbUszXzg==
X-Received: by 2002:a05:6a20:d70a:b0:1c0:eba5:e192 with SMTP id adf61e73a8af0-1cf1d136daamr4439410637.27.1725660777476;
        Fri, 06 Sep 2024 15:12:57 -0700 (PDT)
Received: from dell-xps.. ([2401:4900:51d5:dcdb:d33e:287f:e196:82ab])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71782eb5352sm4309382b3a.154.2024.09.06.15.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:12:57 -0700 (PDT)
From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+adfd64e93c46b99c957e@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: bug fix when bh is null
Date: Sat,  7 Sep 2024 03:42:08 +0530
Message-Id: <20240906221208.136692-1-ghanshyam1898@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported-by: syzbot+adfd64e93c46b99c957e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=adfd64e93c46b99c957e
Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
---
 fs/ocfs2/buffer_head_io.c | 1 -
 fs/ocfs2/uptodate.c       | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index cdb9b9bdea1f..e62c7e1de4eb 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -235,7 +235,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
-				ocfs2_metadata_cache_io_unlock(ci);
 				status = -ENOMEM;
 				mlog_errno(status);
 				/* Don't forget to put previous bh! */
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 09854925fa5c..3242291402c3 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -471,7 +471,7 @@ void ocfs2_set_buffer_uptodate(struct ocfs2_caching_info *ci,
 
 	/* The block may very well exist in our cache already, so avoid
 	 * doing any more work in that case. */
-	if (ocfs2_buffer_cached(ci, bh))
+	if (bh == NULL || ocfs2_buffer_cached(ci, bh))
 		return;
 
 	trace_ocfs2_set_buffer_uptodate_begin(
-- 
2.34.1

