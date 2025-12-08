Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432501E1E04
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Dec 2025 08:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765183457; cv=none; b=T3Dp6023WBi9jvrv6vhy4nf2ah27aIKajbUU305XoKyqC28pJpL0/gOsuaAzEr6+WEHZl/Nxd3RX0iXLK4EEOMwX6dPaXESgsd2vIVgYWrXd9Dd6z1swGkQFNgnYXLHo1QAmGQpXqIUoMf2AWISulqf7rmeozyY5WC8Vjr0UZvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765183457; c=relaxed/simple;
	bh=NzAhqvAKMMvaSxSiRD67OJPOtjVbm361rRnP87UWJw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jAmUDF9WCe2t8nomVdFTVha5MLwXwJFFWO6vxprAO/jhYtDDcvUgjfBr7bvAlLKqx19MDFW7S1fDtkAQQiikIyh3Y/YVJzDxt9I18tL2gbGDq7LNwA5S9H/9X4CWNBMsOWOIg/gXqS7UxTK2Nc/ZxYCLW2O1yho2TXRQDifOdV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OtMiMh89; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OtMiMh89"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7ba55660769so3502477b3a.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 08 Dec 2025 00:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765183455; x=1765788255; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lXG95/gAn++oSeny0xnWF8SGaCFuSuGGIyXACjCOH0M=;
        b=OtMiMh89SxXeuoyiiB20xpvdWkQmKaq225oM/FS8+sBUpvZMUnKeEeZ60skd+noLsh
         QC6/sFR3NouhzULEN6MIgGckteXqPUDuv/RZVeb+AognjoEo7Curk4drVeK4kjeg3jKd
         ut0ct1lUP9uTuReE+PFcxdJ/umfHhdeKjoqVy73xLRm7CVjZJoWfHy0QAzblHaMdWDBg
         kLouwQwIIdrTHu7V/20jOyog/Oryiuj8bu4zUXRE6eTxrxUW8NKvI+obypwxW7qgiGag
         Aqzg2yIz8C48Hh3vx/iq1PbeBrIlDlcDCUkOx8sy3gtjlstuNRN5W7ocIOoKyNJp9L8K
         euBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765183455; x=1765788255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXG95/gAn++oSeny0xnWF8SGaCFuSuGGIyXACjCOH0M=;
        b=EkI9o0tY5Oq3Jhfms8Gq38iy/DSwJSBpGti6eil5cEk0WTiMNUPefGN64IxQB4Bk4+
         5Fevo2u7xCe1B+VvfMvP22JhzciyCV+9tY5rUUuMrP2K5LdXC6tS2rykg/tsXZeNyujK
         3xr3fyvWHUdSPySZtqsRtUQVXrljFEOV4sDsC8rCed1+FhbYTbQkrFbELFyS43XQZ0Ej
         HiGq4EkOAyBQWvtJ/I/zEdQn/lO3fB2t1LkHbTUWZz9FlBUIwNJf4nHgCAuNvbuUdcLU
         0L+1yHqZRsELPlw9IEBbXLRwn3el1Bns11azluQ54zalXS3/S3/V+c2ZG7Gr0Nc80A06
         oi4A==
X-Gm-Message-State: AOJu0YwnGQPRu9B+knXcakJpxgJ0xcyNZTmQ6kA2EHjfVQlbGs6pfYNF
	Wcy0MLedAwyj76Zyz2RRjCQFmIStkvI0tnu9oo/CbsXnAwJqTtUwzJYG
X-Gm-Gg: ASbGncu/5YTTwg2o40ShKlaogD/f9IfAIExnetN3PmR+Jf49sQVUbWjRMc9DyzZr132
	YIvAKkiiBwSwmwtdJhsRjRPsu5/kexRAGlZzX6Xn6Y6u05Wk8Q16J0e1UDiI2bJf1H8xNQvNG+m
	U55ekQwmm6H5yW318Wtw+fNqmrItAk1p6vLArLJC31+b8DvCyEhvaIk6en7Zp4g4MC8efvShuhQ
	r2dsNFx5HKtsAxHYMxjGVPjaHJBYqVx4bDVlmuD5VyXBMSo0fYm2r8qoYTzRxTTJcw4PweRqGt2
	6zR1G5pU9UD8i0nfAAgnjsJDWxEw7NWzssZeedmeGJbbZTrGCrwIvkpePBuB1m3bcK84o+gt0D5
	P9Gpk/APfoOMChepIKZdr4RKrZVIwx1VZuY0Vi+eYBbH0ZLJVZ0wn5gAhyJtqseoChoxx1g7tCL
	2nmVvBHTsYTIAhW+Bd8EWJsPT+csumV7hE7DDr8yUOkeg0+SnuE1hHlYkv5KdeY7x3iaw=
X-Google-Smtp-Source: AGHT+IERhpNLT3c+vZMzi8wwzV5PmDbI7VHqdtuzs8YhhoxW0yZMt821wRPXRMHEkzTQKwF3W0h11Q==
X-Received: by 2002:a05:6a00:a13:b0:7e8:4471:8c5 with SMTP id d2e1a72fcca58-7e8c6dac0aamr5813539b3a.38.1765183455422;
        Mon, 08 Dec 2025 00:44:15 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:8847:f08b:572c:9775])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e7f42a43basm7660212b3a.2.2025.12.08.00.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 00:44:14 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: validate i_refcount_loc when refcount flag is set
Date: Mon,  8 Dec 2025 14:14:07 +0530
Message-ID: <20251208084407.3021466-1-kartikey406@gmail.com>
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
Tested-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6d832e79d3efe1c46743
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/ocfs2/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 78f81950c9ee..dd56407fc056 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1484,6 +1484,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((di->i_dyn_features & cpu_to_le16(OCFS2_HAS_REFCOUNT_FL)) &&
+	    !di->i_refcount_loc) {
+		rc = ocfs2_error(sb, "Invalid dinode #%llu: refcount flag set but i_refcount_loc is zero\n",
+		      (unsigned long long)bh->b_blocknr);
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
-- 
2.43.0

