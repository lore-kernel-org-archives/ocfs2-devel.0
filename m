Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C83C2DEA83
	for <ocfs2-devel@lists.linux.dev>; Sat, 20 Dec 2025 08:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766220310; cv=none; b=S6nPyW9L+NW15K2VCNUla3E6b64DfS3fyOd5wyjm+WjPMx4XMRTJr5HsUXBU+gPyidm3NfUzPJCuwA/1WywfzQL0W44zqkfGuWJxNW0qRFdF24cH9HhPyXsZtWCOp7ddv3Gd1QO8a0cEBAofhjL+jcFEPLlFdDsJtsIrZyybouc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766220310; c=relaxed/simple;
	bh=J0Yw3Qm88S6dU5y9y7zh3BQNbj9xD1mfKKQdCpdKmi4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dDl2fME/pw72Z8w6+2WfwNXwEPoLKj4VS5Fr8iXeVgKrjDZAFfV9mZiP19Sx7tGjrUHW5eXOeYshdKBno0lhmcI23diTIyRfAjgA2DUsNoppVSugplpMUu5qj/WYrsQoRz72pZbEvzb0NtQqale/BS4v5I7W3/5u7/KiR/LVsKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jxdn2fue; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jxdn2fue"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso2864535b3a.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 20 Dec 2025 00:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766220309; x=1766825109; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHcc/gUYD8O9iFczjfCBRvxFz2eukzvKpiF4TuWiqbc=;
        b=jxdn2fuewQwgi8yTpoAoKyUggeRomVikpxECKbF7eLDVFDTcoHXTnMv9PSj94suxIr
         e2Swfhye7j4yyRgqJCM5dZhPTeBc5dU6kM0u/RmF7QpomRuOMlcQrvyOXNRL0KPf/aLH
         8YlNUFYAdUA92InEkK57N3fi97JQJfrxy6mJwDuLPUdrz7xsqPSMB65A85jUnhLYFuy7
         3K8nXBtjketgjytpwHw34OEAdcUymJYLTgATQ1QVpGT5C6vFAujwzkTyr/NqBpWf5ZzM
         QT1TJ12t3au6iYwpeaLh3LLyLbNbmEWCVJMgwIe66Qbsxf3qtCuYiupfVpqSqxIP0JXb
         JbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766220309; x=1766825109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PHcc/gUYD8O9iFczjfCBRvxFz2eukzvKpiF4TuWiqbc=;
        b=pc+7Fo5ZD/O/IOyBgiIgVoSwWoPUc4Kaog9Ey0+N7t7o849fwRXOWPneXTqnegRjWs
         NjE2FY7VlDhBbHjmjHQ3xylbifThQodKfyrvHQ3zrcyHU0XEQj8Kmj9Dgi2KkEFBTqY0
         TT+pUeGbDKmNpmCqalGekhkXbKdx+8bPhcqgLgxDLW2i65h6+GSRSRrejkZcxa3Vz1WL
         H/41R4hDgz8+n7aiGo8oRgaO6zR57IYXPkg1pXtad98J3H847LfRpQZ8UXQNZtf5S241
         YEvPcFPkiZLefEdCpcwN241LpDKMbJiCDVzvD4F3sTrrOkMXCfQLPjB6Ijt6ko0T6+h6
         yQ7g==
X-Forwarded-Encrypted: i=1; AJvYcCUbFZRuV5ygZjVEinTUpfRMa+BaeuCn03mDxpotU6z001xQQ/D96wlz9nZIuXSNPCAj25nCy7R+DVdDKA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwAAfaVROyqDcUB9rqIWS6KS9AFdIT0D4FcoHhAnKgNklGF6V7j
	60xn47V+DOO2shDSZxj2Sqrm/KGHW5rVPm+/B9tJzYwANHzymkwcbvhh
X-Gm-Gg: AY/fxX6RJ1uKN3OLf/7AuBo7WVmNNgL8R8tBWQUTFHh2tyGti175LnGcouYpoXatdg+
	vz5Jo3v7RFtT9yifo75cHWjRZUuc7iEuA2x6q09DbylH9pEiXcKQEGP8/X96I9nJE2GW1u2COAf
	XuFo7JL3MHWcztpuKimiHT1VnFOweYZxd5+EdAwHABOD+OK/YG4/t1ZW4gCbfHxh1NKRyt1sqKJ
	+GfsdjMMJzlXPHyAdvQWHKt8i0Hi/G2mC9B9nTtTodq8phkM/eWEXF1bxWSPeK6cJV6e/nfH0gR
	G0RLOGA+iQheUTohYi3sKGixCKWs7JN6UpfodwzHnnvGGDWG8xXsFOD4a+iYZWhIMwWbLrUQL4G
	qmTsUJWwRtaz7DT2K/JBLE1TH7c7UTI3QcTckSasne5wdaX4ucqvDglAbIT29sgFtf75hIYNKSl
	sIbjtmDxIQnAxRuo2fzs2bO/FSMj7Y
X-Google-Smtp-Source: AGHT+IF0+TiBaxAg9YnMnfln/1+S7rZY108uH43EV8K5mEl1+/rtxxQ+xY7hqB1M1a5TI4tqF0uFzA==
X-Received: by 2002:a05:6a00:e17:b0:7b9:ef46:ec70 with SMTP id d2e1a72fcca58-7ff65d7cdadmr4898289b3a.23.1766220308570;
        Sat, 20 Dec 2025 00:45:08 -0800 (PST)
Received: from localhost.localdomain ([111.125.231.172])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7aa328aesm4574551b3a.5.2025.12.20.00.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Dec 2025 00:45:08 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: heming.zhao@suse.com,
	linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for ocfs2: Add check for total number of chains in chain list
Date: Sat, 20 Dec 2025 14:14:57 +0530
Message-Id: <20251220084457.107038-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <67117fd9.050a0220.10f4f4.0004.GAE@google.com>
References: <67117fd9.050a0220.10f4f4.0004.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 36c254515dc6592c44db77b84908358979dd6b50

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/suballoc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f7b483f0de2a..7ea63e9cc4f8 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -671,6 +671,21 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	cl = &fe->id2.i_chain;
+	unsigned int block_size = osb->sb->s_blocksize;
+	unsigned int max_cl_count =
+	(block_size - offsetof(struct ocfs2_chain_list, cl_recs)) /
+	sizeof(struct ocfs2_chain_rec);
+
+	if (!le16_to_cpu(cl->cl_count) ||
+	    le16_to_cpu(cl->cl_count) > max_cl_count) {
+		ocfs2_error(osb->sb,
+			    "Invalid chain list: cl_count %u "
+			    "exceeds max %u",
+			    le16_to_cpu(cl->cl_count), max_cl_count);
+		status = -EIO;
+		goto bail;
+	}
+
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
 						   max_block, flags, &ac);

base-commit: 36c254515dc6592c44db77b84908358979dd6b50
-- 
2.34.1

