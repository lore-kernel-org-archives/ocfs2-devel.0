Received: from mail-dl2-f42.google.com (mail-dl2-f42.google.com [74.125.229.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6A0313545
	for <ocfs2-devel@lists.linux.dev>; Wed, 30 Sep 2026 01:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790730454; cv=none; b=Stv+z8yIfspHi09HKxDYDCpLCAMAEtPf87CEu82G2OFPjxut5kN51BLA7oBYBHeZY+XPJ83P5MnuHTVmjq/1MGD5yOI4oMHhJOvAZGdmsRMD0aEfkW1PPU56SPE8njhHduIRANQfwh/W/iqIm3kvgRgB50Ox6vItSgEoDdc17bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790730454; c=relaxed/simple;
	bh=dsrb2nnlzQKp7GUWZetEFF/tjXJmHfUQW8Pen/ISFcw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C4sXTpsr9qBppIXl0Naf5y04ZhU/0nAW3pI9fNxAfGw+8SprINnj5EVnqsmnf8Fl9MCCrW93Lp7q6ONfJsWMn556bJgfNBhG/pWGLPqK7aM3jRZC0aONT+JDphUU3Y5IsNCotWMLluxJZv93W9s2XhYSCv8Hv0Qkz8XEChpzc3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=Xd1JW3cN; arc=none smtp.client-ip=74.125.229.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="Xd1JW3cN"
Received: by mail-dl2-f42.google.com with SMTP id a92af1059eb24-14380910258so1390182c88.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 29 Sep 2026 18:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790730452; x=1791335252; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zaXHRhsayLLA899a0yLIQYT705UjULcNm+T5JbX4Jjk=;
        b=Xd1JW3cNfxysZrPAZBD1U+/CVxCWqiQ6HL19JG2/ERjGu7RvjdY4ykeg7uJkpLJh8o
         Xx7WW/MTB2UDGKhpV9jcD99E93FNq2NHic2K2NlS8eL0qz8bhvc0cd0iaXZSk9WCi5wu
         2B2r5YBnlw4v852/H7fblvxDtG3giNhwuWBS0fdaDR03zelvQ91hYmePvss4JjFVgAhH
         AtrYU7E6yWmBCy4fYuu4wxiZOuuf7EzleEKgCuBXh0p/L/ZIRanUiVlZp8RvOmdAyEac
         2m/JHguzh69UkLMWCxQr9fA4hFLr8q0YCcWWElkEgkqDlBtf/PAUx6KHoi/842hU982w
         g+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790730452; x=1791335252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zaXHRhsayLLA899a0yLIQYT705UjULcNm+T5JbX4Jjk=;
        b=miO6yE7wrABaLzS8DlGyMN6NJszl4RmDO3kBTIobMTbwPSu6RE2+3kYOqEPIzmnfXq
         ztEcs6GASpOL+lOrwfP066RxYPfxcPYRQwN6uWXrU2VTX/nGSWnwu/r+8g8Qye+Hmh0v
         nQeuZmh4qTpnS9C2s8w6jtmyq0qtjVbzUtbRJgOM0S3Ph8+YnV9FIll1G3Z+YjaEwukj
         0hMM4n7gEOvHtyVoNL3mu0e68D2YM9vTMLZPnbqI5GL1qhwAcXWxZrzsvqWJiIY2Tv+Z
         OBKpkgg6g3mGzGUl8wcp/ltjUsnQGWBHYuCahxwU2PFqsIFpKOHi8bTTDyDY/LKE/YzT
         RUTw==
X-Forwarded-Encrypted: i=1; AKwUvBzqJ0q76keJrTv8ZsHyWF9Nm4LYOesFyn8ZMLjwqEpnO1JY0yjffjBMz2gcbHLHj19xkoiVQxgnZnLCJw==@lists.linux.dev
X-Gm-Message-State: AFuF++lEuXHDm6F0Es2wUlFAuXUhlOOJb+lkqJnaBmmJcVBsmx29hBay
	v2d72BzOqjw+oyyBdhgXzJTAGElNYYimzJlGpSUIzqYE+T48/GUWolkSjwNX/NMJli4=
X-Gm-Gg: AYBFou0XRcFV1rLNOzWMQieiLOx1tyK7unioWe64dVdD1Aj9rTknK14JZtXc8Vx6Sg2
	GS32HzcxAwZQ0XDCxwQA3ZwhxOOa7CHvDI+3BV4X3zTIu7v4w9r2xHXfwJhO6Ebftj3JurnT2oe
	HG5f0i0WAxxDbwV+yTUvmsZhIoOXM5MLHuTBNave+fBmSXyQz3ovfdc3XzGMoV8pEon6rgJaA7K
	xzJaPld+S3i9fz0T6nR6l9/S0AHJkjoBQsw/4kLKT2u9zS/ACy1n4L+3fpp2aHGeHiSCIzC/c0W
	2SZC9/Kn/eM0TyIdHPMzQ1zUQ0kvPiM6VpkTVqJXThMKtLqzoXwHHPA5b3fd9hwFDAdWp+Mav2l
	5uJrZv0KM1WI/E+Q08PIjRbGS5sKP/ukqo9Pk+PXDsy+GJUjN5im+l8Xb2S+3oRKU+/oA/c4M6l
	SQdd/GAM6235TfbItMlV+n/eHtL4F1Coh6R05iQ/G0lHocUpxCBwxeSwrZOYkfE2+BB5tQp7QUQ
	bIFK9sgp7YZ/AI+KqW1U9KNkDK1dSLv0VwdSLNcd7xNtJ7vyVNwPw+YKV4KVhhEhRpI380=
X-Received: by 2002:a05:701b:451b:10b0:146:606e:1f62 with SMTP id a92af1059eb24-14c9e29a175mr1040002c88.41.1790730452081;
        Tue, 29 Sep 2026 18:07:32 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:3481:cbb6:f339:9e4e])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14c60c55ed9sm2223598c88.2.2026.09.29.18.07.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Sep 2026 18:07:31 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.6.y] ocfs2: Avoid touching renamed directory if parent does not change
Date: Tue, 29 Sep 2026 21:07:26 -0400
Message-ID: <20260930010728.94306-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit 9d618d19b29c2943527e3a43da0a35aea91062fc ]

The VFS will not be locking moved directory if its parent does not
change. Change ocfs2 rename code to avoid touching renamed directory if
its parent does not change as without locking that can corrupt the
filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi Greg, Sasha, and fs ocfs2 maintainers,

I am working through the small CVE backports still missing from 6.6.y.
This one addresses CVE-2023-52590. It avoids updating a renamed directory
without the VFS lock when its parent is unchanged.

The fix is already present in 6.12.y, 6.18.y, and 7.2.y, but not in 6.6.y.
This fix also affects 6.1.y, which will need a separate backport; this
submission contains only the 6.6.y patch.
The code change is identical to upstream.

Could you please queue it for 6.6.y?

CVE: CVE-2023-52590
Upstream: 9d618d19b29c2943527e3a43da0a35aea91062fc

AI assistance: An LLM helped identify, adapt, and validate this backport; I
reviewed the resulting code and validation evidence.

Thanks,
Artem Dinaburg

 fs/ocfs2/namei.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 113102009431da..5776980402de95 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1347,7 +1347,7 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 		goto bail;
 	}
 
-	if (S_ISDIR(old_inode->i_mode)) {
+	if (S_ISDIR(old_inode->i_mode) && new_dir != old_dir) {
 		u64 old_inode_parent;
 
 		update_dot_dot = 1;
@@ -1364,8 +1364,7 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 			goto bail;
 		}
 
-		if (!new_inode && new_dir != old_dir &&
-		    new_dir->i_nlink >= ocfs2_link_max(osb)) {
+		if (!new_inode && new_dir->i_nlink >= ocfs2_link_max(osb)) {
 			status = -EMLINK;
 			goto bail;
 		}
@@ -1608,6 +1607,9 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 	if (update_dot_dot) {
 		status = ocfs2_update_entry(old_inode, handle,
 					    &old_inode_dot_dot_res, new_dir);
+	}
+
+	if (S_ISDIR(old_inode->i_mode)) {
 		drop_nlink(old_dir);
 		if (new_inode) {
 			drop_nlink(new_inode);
-- 
2.39.5

