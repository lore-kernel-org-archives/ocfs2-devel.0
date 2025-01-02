Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA916182BC
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jan 2025 03:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735790033; cv=none; b=BS12DwfR7NUrcbijCmfm9SqvgdhlDWG3AMwSLJ9ekPptbA0o8+zvMcX20sQ/Z7ypEOOCzKL6QqlJiJwiuOOFPUu6Hyg51DBXqvoyFKudxAT5/sQad3NIjqtaeCToFG91gfqgSD8ymX4EZyuodX9knNhJFhFnQirvSQAbiXgeUCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735790033; c=relaxed/simple;
	bh=HNFxpv1mLEyTrxt/e0pR+ELgUU5F+Y8/dxxOxE2sq9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nGz+vHOg3PQpp7QtVcC3cIi0ImFtx2BotXOt96Auz5GvtQqn7pHvTHmZJMalkoDc2Fm9oqf2kB1lQpB2vJAr8iKK44yJq40ZlxTEsR0iK6HcqA9L4HzYh07ULQTjNnXlUX7mlFhqECIBtFj5mcXBk9uQMPQuOsdsLH1pfb/hJ/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I4yOzVP6; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4yOzVP6"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2eec9b3a1bbso11743588a91.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Jan 2025 19:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735790030; x=1736394830; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1KBRkcb48K8Wm8eXNHwyO281AhSO6O4DAGPjtvLu80A=;
        b=I4yOzVP6ZGX8t8Hz/dDNE3iEDjSVW85jw+VVVGtd0khjtpkFccS++Wa4RXdYJhpEtn
         K5J0qS5g9HVQ+wxLVSQvW9eE6WJssr4VN/A870kdfLcLH22A4kEsrNndf19NBzu9jlR+
         jeP+C+SIxtSNrRHc/m+mgswyq8yi31s2gbxN2Cy27qJ9tyw4uZkpaIItn6cYgTWxf3JR
         syDmYtPyTFqvMSRXh9IWjGUdUXuziEDc16dv7z9nH4aS+w2q9WbUdqX73buOgUs7fWKT
         l2g66GwkJ4iuDVvpQwnZ8lsEbf1QJgCQ+D7AFN38Eepz80n8gfd97YqLVkZkpbcFI8oD
         piAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735790030; x=1736394830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1KBRkcb48K8Wm8eXNHwyO281AhSO6O4DAGPjtvLu80A=;
        b=fKath09hdev3P6zSsnmqFnpo1hrJM33z5TWl2xdy3z2fqb1M5XYTHFC8VyEXsAjdSf
         jJszJfKIQyXacAuCIHgQTJWkwk1zHl3FhjfnHisZhHixxure1XM8Xb6lNhWAaQi1HTA3
         5a8IPN0JdbOZkVdX3fG8ktjO63f7X/bdLHT73bT0KhpifCabHQCAOvxS1FzXkdlKa+Hr
         2rN0ABbNB0qCrgdDevdCYt/2fFbCtTQpRvXdJ7PH9+CEIFZgrH4oWbP9hdzTigOLgT+i
         5c2yP7bc6ya7Ye3hRvaTmZMbBDYbpBCgF70DOkppiChLXjQBHZeKVm34A3eiVmTuO1FU
         pooQ==
X-Gm-Message-State: AOJu0Yzb0eSLya2fs1uiuWzJK7kaon/vu4sDciELf2cS3eMYPh3L1DlP
	gx6uHj2k1vdhPiVkmmWhSTzhe4ExLwg/+VU2FNrbYLf0eXT8McsCNpTE/hlDIXY=
X-Gm-Gg: ASbGncummUE7qE9vF8D6RKTOJciKvbLt61HU52F14cwB6Ar4BKG7Uw/LOl5Nj289kX0
	j2jBNaK3oNRmy8K5/RO/Tf9/fOIIXpCm8otnYsBMaEIeEJBylBa6xsYJ/Qa2dPbu7moWCAtZyDy
	dtkKtEDAeJktH+2t/mdanngC6/sgajfMeHf2SH4dIHzCjeFxo2AjkBYJiA69V+FGGoLLHajOozl
	7LnLyxL6RmDqy0B2/oHGnvij1Fv2ue/7jsluuMGbIJqkguL880aYd+2cYNc4dus1NP2Ljfq4GsR
	WEcsk9xzVFDocw==
X-Google-Smtp-Source: AGHT+IF9a8XAYlALKMZ2rh7R3DFgOUBIZfcymguYAj16BLov/pvDSbECOafZekIp0r+nG0gVNiGJSA==
X-Received: by 2002:a17:90b:3cd0:b0:2ee:a76a:830 with SMTP id 98e67ed59e1d1-2f452eb3279mr68641091a91.24.1735790030099;
        Wed, 01 Jan 2025 19:53:50 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed52cf40sm29972392a91.1.2025.01.01.19.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2025 19:53:49 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 2/2] ocfs2: Correct l_next_free_rec in online check
Date: Thu,  2 Jan 2025 11:53:21 +0800
Message-Id: <20250102035321.391540-2-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250102035321.391540-1-sunjunchao2870@gmail.com>
References: <20250102035321.391540-1-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct the value of l_next_free_rec to l_count during the online
check, as done in the check_el() function in ocfs2_tools.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/ocfs2/inode.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 2cc5c99fe941..1fc9544dc1fa 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -200,6 +200,20 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	return inode;
 }
 
+static int has_extents(struct ocfs2_dinode *di)
+{
+	/* inodes flagged with other stuff in id2 */
+	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
+			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+		return 0;
+	/* i_flags doesn't indicate when id2 is a fast symlink */
+	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+		return 0;
+	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	return 1;
+}
 
 /*
  * here's how inodes get read from disk:
@@ -1528,6 +1542,16 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
 	}
 
+	if (has_extents(di) && le16_to_cpu(di->id2.i_list.l_next_free_rec) >
+	    le16_to_cpu(di->id2.i_list.l_count)) {
+		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
+		changed = 1;
+		mlog(ML_ERROR,
+		     "Filecheck: reset dinode #%llu: l_next_free_rec to %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
+	}
+
 	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
-- 
2.39.5

