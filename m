Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF0D1E9905
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 04:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765515418; cv=none; b=hk+MM9w66GfJlefvFJxjB7UzZc8RRsKp2fq8gRtH1Stre49x6ciOjTxAFIAqWBhBPqd9spRKAmHjNRMWD2aPm4qwf9eockT+c9v7zc+2dYJivydmMxh8Fcan7uvxneCqe5hTyElVSlj9TiHOEJ6dy493dO/HU2opK1IBgxxWrHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765515418; c=relaxed/simple;
	bh=wDAwyUet+HBPvyZd2hV45MphUZ08MbtAOwGGRPWXIjs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=quCoevA84Q4KKXXCxEviFWM0/8CyRjxqBtouAG3wJhcTgjXwW2eG60kyCO/eb2He15N/WOMEzDNfzYB17JTxYI6VCUEfK/ju/Z78LmUbiKNW5dOrE5aDG30AdFhJKPFkakzVsU5eG5ruzrQsqYI4edGcZ+CACSPGf5PFk0jSqpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EBH9JLzo; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EBH9JLzo"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3436cbb723fso674206a91.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 20:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765515416; x=1766120216; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T/iZj20w2idoOaAIIJHJiS6sUHBCE9D0SQnvyRsKZlg=;
        b=EBH9JLzozd5kJPZv43tBEQJ8S3j6lhpcPHxpc5rm3jYw6cAWK92D5oJ7MxMKFpFQrL
         0i+uoBsdd5J9FYucn7H1OlEYcfj7T1e7eE1rckl/DfFuIwg3XP3hvYjqUFZeZRWtSrNF
         J+vMbV+cMSU0xGEfHB/hChfaEUQObatE45HV7DpOdZWdOUsAkuXMStAv6ExNFxp+txqK
         MvcHoTmOF1mlRdYj1H3GXyW1XuKlhISXn+qkijJlsj1aLLknWGHW9omlIj+NDGy5ip6H
         pYo6pRYHHuyqTaP+YJnB2hoPK43AD01AmbTET0jd2CEVaYwChCxlixsnYoUfn6eCOfvs
         DUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765515416; x=1766120216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/iZj20w2idoOaAIIJHJiS6sUHBCE9D0SQnvyRsKZlg=;
        b=fBn+O4ZyWvy18NDOUOcHLmbUrAST01LI7us6KJvts21/WF+ZZMPqnO3vn5HdB7aA+E
         SVLopx+AChIhYJcunssttr7sJR/g76fBTKi5oI6h7O/G1NnJXNVRja+tYgPFn58xu2Gp
         +zzjgWhLVyByLoLLB6pGYXK/wnocuF6N2ES8jpEbnPVkbUDbfZ+u+SV+uhRTGjjtOypW
         bZ4pIdY635WeUvNSLy8uQOTvANqqmoHv5VGL5uFB3CjOMOymD65UHQ3mG+6Yq9aiZOeN
         aQ8AX+ZVvvlzFUXHSLk+G2kLDhLZdb01DtdSmY49Ni5H8q3fX/kWB/XcMtboSZPQVMNP
         +VUA==
X-Gm-Message-State: AOJu0YyDoYfDB4GkGndlDv2MAmL+uryqMWqJfxT/DISFXu3rlMNpMMMY
	CsJAYH5V5p548wGWIN16ZnhgS4T5Cx+Xr9gRLxFFcjK73BJzuQ8Waoot
X-Gm-Gg: AY/fxX6SmCQyIZ6x907HtxzGeuliuB7HH7pcGtbf+TzqzrpvzX7f8puEPhRmQfI6g/I
	3bfBDNDe8AjFDJ4kTTxcqHspmR75h5mFi4W8wzYosXuCHGkom8Bd8uTNCHAdWk/OTbEkyZkZoPb
	wjrRUFxkG5JPq+UO5HuhQ24tRayG9mXMiCZPJU7jBI3Ycz5tt67zWvBmiTjSMmDKt9K2aa+t6Sx
	5ASblMu6e/xfs+rddrUp29ZUPAyxsZ/ubkA9Y/ruGFk3dWox+j2JlyVXZHfaK798ZsYlV+uuP4g
	awKnj1GX/6uRqNKuL63ay92zIEp+2MO8NobwwjdOfVbF5H9udoQXRr5703/kDTr42Vrwuoy0H+y
	nWf4YX47shEELeaiUMK+q6xJOaPYTlLRMoZLnwO/mZkR6KMrKRsdsXITrt6DOPdfp04BPq7AuFu
	zhs0RTMLFL0d8e67PUXlBf0l1IN2rl4n3Cw0R5bXVRwm8ucUkKoBOHFkEK7RELM4UuVYs=
X-Google-Smtp-Source: AGHT+IGCnLEF6u3xo0XUTk14kOPwTB9ln5c3WkA98d4h3qWXYq/GxLoYR5+TSsEZM0OntcBdzu5PMQ==
X-Received: by 2002:a17:90b:2fc7:b0:343:87b1:285 with SMTP id 98e67ed59e1d1-34abd76160bmr959581a91.18.1765515416351;
        Thu, 11 Dec 2025 20:56:56 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:aae7:653e:9526:17a4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe218793sm597534a91.8.2025.12.11.20.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 20:56:55 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: validate i_refcount_loc when refcount flag is set
Date: Fri, 12 Dec 2025 10:26:46 +0530
Message-ID: <20251212045646.9988-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add validation in ocfs2_validate_inode_block() to check that if an
inode has OCFS2_HAS_REFCOUNT_FL set, it must also have a valid
i_refcount_loc. A corrupted filesystem image can have this inconsistent
state, which later triggers a BUG_ON in ocfs2_remove_refcount_tree()
when the inode is being wiped during unlink.

Catch this corruption early during inode validation to fail gracefully
instead of crashing the kernel.

Reported-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6d832e79d3efe1c46743
Tested-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v2: Shortened error message to fix line length (Heming Zhao)
---
 fs/ocfs2/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 78f81950c9ee..06f1f9e21423 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1484,6 +1484,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((di->i_dyn_features & cpu_to_le16(OCFS2_HAS_REFCOUNT_FL)) &&
+	    !di->i_refcount_loc) {
+		rc = ocfs2_error(sb, "Inode #%llu has refcount flag but no i_refcount_loc\n",
+				(unsigned long long)bh->b_blocknr);
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
-- 
2.43.0

