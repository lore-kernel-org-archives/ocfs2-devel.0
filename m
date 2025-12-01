Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CDB309F04
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 12:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764591445; cv=none; b=Mi5uJXiXYl7JGpTqK20YijTeIvohhqdwkSN0WFM8IsgNAlBYbOAGOPXGWI0CshnSCKGOfx+AJ2t0e7OTs7IHkyhAyGrmTdZexrGcBDF9/mu4jyesj3PcLkir8lRTuZoOhhEXe0r00hcXLTh+bXiVpnypwlt4lK/aqBb80yYqLww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764591445; c=relaxed/simple;
	bh=u7aOx9eKX85WMhjYKGLulfWhDMdEpmU4UT4wA6MLSnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f8pd9sv/UKYc9/Bg0xn5zEbUmoS9dWfpcbD54zE8X0yW8umKXSd8asRx7WObd6tKDHXCDObfJaxD2oGXy1r9KpNp41bAwKmLpOwwK+/YzBdgIdS3EAZzBInvvQH8bqOmL7if/v8RyEEKFtdt3/phk3AI9HVUV8lmEQxuVBMo3vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WodDrx3o; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WodDrx3o"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3434700be69so5852360a91.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 04:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764591442; x=1765196242; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzQZn23yhZ520wZAxPYFCVxk+XIfXKrdt4/IxzzgKXs=;
        b=WodDrx3o+hoL0SWhK4hz732P6VWTjYf3Z7n4do2xJVkqMILRMVxRRGiaxLm81GcniO
         9pg7KQQV3JgDL4hhMwrRkHz+YCT2MiGREEuljYLYPS5KJf1RlDA5I3gW1TOelqQJv0ET
         AaYI+Tef+OhS2WmSj+GdtCs2WDtLDS2Aw4dpFZfFir0Hoh3+yaW2tjytfQIavhAJY77a
         0WZzjMWMmSYd1u6IC2GFcVc8l1Iaf9seQKRml9dQ+acIM3SvzZn+V2dSqIZqf7qGwRMx
         0YotIoqhlCXvSBoJQAYD97CK5v4eNfWnCjhZeHy19ATDKtiSIMNelS6kknPZzKxqsrDF
         ogeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764591442; x=1765196242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JzQZn23yhZ520wZAxPYFCVxk+XIfXKrdt4/IxzzgKXs=;
        b=eSq7ALiiItnVGG+S4WtJ1H1UwQoM6rRjc8c1QHJ/mtZi+WS7jAl5U29kU1M0bN/Xjm
         dJk0+vqQfsOql/LFxmJhUG1o6PUbeSLEcXcKo4RoLS0fJHkJoue//ZdXvS/iK6dyo1Vh
         LJTg+t53RfxDQhLPmBTw0D5TyaIdKNo0bvP4yiy05w0Did41ddltEpMR2p11Mr6xjEWL
         ZOxKOq1l7lIB1e9zTcwDf6cq0bq6Of8Sa50I14EVMCyzJvUh8U9LooGQVBYagAHR6Tlx
         AnlwpUOFOAeBgpYVrah4kr0tEIfsvjjXJ22yuOOT+rgjZxIgWeC8vyZleUexNG1KZ32S
         1Yjw==
X-Forwarded-Encrypted: i=1; AJvYcCXio/+bn/lgTXtYI7q3LjByz1JCVTTzoEcfZrNC0c/AKb2d+5uBBzLaX9EAOAztWaYcUsSMDzAxKxPKkw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxpqmpC3MJaTAFnYnKUaS7xnEZsWBOU2SiMGKyAB5GIKdjjzJqH
	2KR+zvsRDEmbih4r+5b6LjTr1p+zfI32iFAqpw7uhu1VCarVuee/Ma7Y
X-Gm-Gg: ASbGncvv9O1/JF0YPllsXY2cJMZvjFolwMZ2HEF70HjntKf8LI7adkjYyJX7u3NK6Tl
	JWUjzOdASlT+3+khOfnirUJfPHnlAMswXaRbzx5e4WbF7KEF3hEo/5K5ZbRrTvubOrZ3a/2rKtV
	rqHXL/7FFsobUYO0KyjQAN+Th5I7yT9rb7cgIXk/tO1fQj1WOv0IzZGiidNiJNSHfJiJFiijFBs
	exZ0gu5AE2tJe8kGZJuVDuoLlcg2DD0Fn1oETm/srsrHu6OgaMAsRjb3JUbCKYjgS4T7e7LMOlG
	QxFBZ3DPTxRkij7QDrXb+4J5DnQiU71nd43e30F59pBhdkgiJCHoaJSDdC/NJDRFy20NJzsbLoK
	Fa8SAW07355Q7yfKMKGXyS9HnMAbkc3BKC9/EaEbGjZegknS5bCMpvsVbNWMIbqFBTkqsNr1NaO
	XS4pF30llC/vng1pI5kzy2x3ZUDoA=
X-Google-Smtp-Source: AGHT+IFvuHqvEYnUoIOGYPRErw2714sO5VkGglyDWqrHE7Z6y6XVPEe4W6f7g2gVi3wG4QN1tX27SA==
X-Received: by 2002:a17:90b:1a84:b0:32b:65e6:ec48 with SMTP id 98e67ed59e1d1-3475ebd2f41mr24584187a91.8.1764591435157;
        Mon, 01 Dec 2025 04:17:15 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3475e9b46f4sm8095381a91.3.2025.12.01.04.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 04:17:14 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot testing for v3: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Mon,  1 Dec 2025 17:47:03 +0530
Message-Id: <20251201121703.128667-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <000000000000560ff106204134d2@google.com>
References: <000000000000560ff106204134d2@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 939f15e640f193616691d3bcde0089760e75b0d3

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/suballoc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..e93fc842bb20 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1992,6 +1992,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	}
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
+	if (!le16_to_cpu(cl->cl_next_free_rec) ||
+	    le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Chain allocator dinode %llu has invalid next "
+				     "free chain record %u, but only %u total\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno),
+				     le16_to_cpu(cl->cl_next_free_rec),
+				     le16_to_cpu(cl->cl_count));
+		goto bail;
+	}
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;

base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
-- 
2.34.1

