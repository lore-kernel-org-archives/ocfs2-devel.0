Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8473226ED41
	for <ocfs2-devel@lists.linux.dev>; Tue,  6 Jan 2026 11:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767699077; cv=none; b=Db1MKH7JICzznsjh99ZwxJc6Ed0smU/QxuKqN2w5h2cOJtM49D9TOpCzEBX7xj0c+ZEOck7LK1DB5KAdFcagZhnV8Y11oMTDi/FKmHvozHmEuUFpctmMmUzGjNrdrwQO5R0bvacFjpN6P/o7+Z69OXga7DfvBN7KL2WsnqJrdPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767699077; c=relaxed/simple;
	bh=fO6UupZFERJDlIqdOpw2trQhlGReg9afEXPDwnqDu6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=msGJ2CTSA8WSD14a62SxoOkOgUnd6AWwHbZJjjfIhY0RZSuh/gzteb8qpcsgZWD0oQ3R2KG00h5Ha30tcAsheaS0GUY6a641DOkAYv0bAZRD2y3KCRp/ZZRtyLOUkFn31C5d8yp+yiyMpkIGG+qWkZOKM6AzJqQKiiOgiFqHwbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aYn2uX0N; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aYn2uX0N"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a12ed4d205so8553395ad.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 06 Jan 2026 03:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767699076; x=1768303876; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/VMdGXBoUMv4tiAoGbxdhRDIq3r8oLq9e7PJQPOZXxY=;
        b=aYn2uX0NEAZjluy2hPQN65ccoH26wEwRRGBHOpKIZSCDEvwn3vn4jGH6oL+ZiBZKaC
         yhXMlsdy/KSG9FdlYABARUQ2Cnj6DopwRw2q0eOmFBK5cgivCh5MfzD3aEIqWgYHIjiM
         yA52wCuepJY76DzUovNKrEuTYQA8eQaSfGxO3O/t8jqx91e89w7achhpqvGruu5e3Ffp
         mHEyO6nttCCeTO2U+rrn6HpKU2n7PK1ayBFWmhlkJ+OxFqN1CocRm5rHFakAjv1nxIzF
         Af6kXOsNUGVdGBqlHXi5Iic8gqM6SocwiuYiACNBiFPgidLI/5y1G95d93yRwMbVdysF
         MTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767699076; x=1768303876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/VMdGXBoUMv4tiAoGbxdhRDIq3r8oLq9e7PJQPOZXxY=;
        b=abPwCX64JbfnLVMQfqbl0/njVJiRpF89XtOSMJSJXFd5sSgQewLhJkN5TDqTKH1iir
         wefVloC4kOTrKQ+Ib1sSNRA2f0zZrnnKdikch2eJa2ATgCxZepMgC7BzIuMu67IHCY0P
         QncdsaujcCQGxPeZFP8+zbSLo44K0cqg9ttuGALHDBZihZ2vtubh3zUyz4uCd3cMmYIn
         5QIxVjqeV0d22PvR4VhATJvUf6Bt/0MUsy++MHKuBzcR1f8An+UXhwnkZOYJXpIj6xwK
         HynbqFkmUkyMKa0r+uXQ03ZRuPPrcJz0WbHluYnxNh5m/BIHtzqUz9ItT7xyxkfdHKpl
         lWHw==
X-Forwarded-Encrypted: i=1; AJvYcCWpTlflVIqnZydwJmEh+rc8fE2YF02dKqFDf5XObYu7h56F5bWj2BiM7vmtVmAwqEXwVoQwY/J4/YFnsg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyzGKEZXQXebbKt81owZciPZGA5ySxVLbX+M7myDzHoThmuaqZK
	m32FC23UqsiPr+tCUuraiBIagz/BNqvTvna9LIFQufUhsDe75uKLKkis
X-Gm-Gg: AY/fxX6i0t85Zb1ZcLkSHLihrkAnZSNFcHaNuTdFvnmQEU8dy00cB/8wWPzag/6YWvO
	J1a8PC5XH/P/qmHd8kGSGbTJb1uB7pxYMztMlGgEGbRQs9UteoG+LjnuaF1Ll2CCNSaTrCXQROT
	NndqJ+bisCqIABjIF+CIcL1eoQCmAS60NcKtooMrWbj8kXITbDxjZVRkQ9m9WSXSCtt1f7+fJgH
	Nu8ibk90HmO25yuNZbpoiIu2lI82T5ScJsgvFUB9OWtGWRnHD6hRNRv+MmyPqpF11sNAboTfmmm
	Fn9ESvKtcuZZGAa51D7X95qYbvvYMRs6eh+BphMmwPs39oHr4Zz8XSgTzqO1eFYbUQvzUo5VBvd
	GdYHp2tffVVfBjx4cAg61QvuLmcYoPc5uQREPw5nNWR+iAN3u+hy9Z75vThvt9rdN6lWGM1l841
	BP6lnLtDcF/WZoPiRcu3uxm2mOQ4M=
X-Google-Smtp-Source: AGHT+IGkZ2hYbxyNtYQzCgXbNxMzUF9RoMX0pxZNWyZumEeNfVr1GE9y2to/afCSMZ5/UzIK3VNLMQ==
X-Received: by 2002:a17:902:c946:b0:29e:e925:1aa0 with SMTP id d9443c01a7336-2a3e2e1353dmr26524895ad.45.1767699075681;
        Tue, 06 Jan 2026 03:31:15 -0800 (PST)
Received: from localhost.localdomain ([111.125.210.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c4796asm20750675ad.34.2026.01.06.03.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 03:31:15 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: heming.zhao@suse.com,
	linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for ocfs2: Fix deadlock in ocfs2_del_inode_from_orphan
Date: Tue,  6 Jan 2026 17:00:53 +0530
Message-Id: <20260106113053.284336-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <66fdfef3.050a0220.9ec68.0031.GAE@google.com>
References: <66fdfef3.050a0220.9ec68.0031.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test upstream 765e56e41a5af2d456ddda6cbd617b9d3295ab4e

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/aops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 76c86f1c2b1c..586e3b74d782 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2295,8 +2295,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 		goto out;
 	}
 
-	down_write(&oi->ip_alloc_sem);
-
 	/* Delete orphan before acquire i_rwsem. */
 	if (dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
@@ -2309,6 +2307,8 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 			mlog_errno(ret);
 	}
 
+	down_write(&oi->ip_alloc_sem);
+
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);

base-commit: 765e56e41a5af2d456ddda6cbd617b9d3295ab4e
-- 
2.34.1

