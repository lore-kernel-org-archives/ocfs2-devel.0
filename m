Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E231F0E57
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 11:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734003077; cv=none; b=ZEj46VqbJCe+T1PQMdOlM9haBT2O9S4DGAwA3wKbachm7z3dSMfTJ1jbe2AwUSU5RSMUVEOGrJDpLsXJMS0zTpAr1gtkOfBHxh/QpxChy92Ai1hTKjXIk1NDRi7EN01EL5+Ibc0aApuEbTycszATOplPar2uTOcNZEskcrwAl+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734003077; c=relaxed/simple;
	bh=MmgDZLSQtID9mT3Je11M6/sbF7asAJmRXqbPI1UO6rI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PWkOXwhta6O+fT0mv7+9BTGEse8JLMD/jU62s2Hszos8w/c1IeASjhjDQwNxBGeeU77Nhv/dXVUAwrlf68aMJGHfyDd8TXya303fvz48DHtwmGSNjUVkPR/WiGUBG+7iaQmw4K6wcdAAUSV2BHMqv/+o7fkSnxYl9+9YYYUbf6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VEV+J291; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VEV+J291"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-436203f1203so481385e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 03:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1734003074; x=1734607874; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Tzuw/zLX0WQJcc9n8LmQ2bz/aCPLkYLRBmSSAzg1cgo=;
        b=VEV+J291BxwGq7bdOsJyRHsVCCnAtNf/of/Mk2TN1DSiArzlrfd08Hk4qXvsb2nwN4
         k1agsd3IO/fEUFpbdwOx5RQGzV6bO143zr6Z3yJNe4phowLEPuU0HGbLStLrW1T2Cm1Y
         2YzhaYZEqPTdR7EMRK48I9IMwfdo3NYHhwDyUMLqN36fTLb8G5MO7dn4hzgu7HW7Df3S
         DsNkezS5Yh2oSCWOwwIezihhCMndNxb9VhnpjraDxXFjRosGjaiMs+Zg8Vs8iXJGU41E
         6KnKgls0SAkBi40Hf/wZU3yxL+Ik/3a3qu44UIwoEoAactt51Pco01ZU8Ndr9LJ1i0oL
         SP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734003074; x=1734607874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tzuw/zLX0WQJcc9n8LmQ2bz/aCPLkYLRBmSSAzg1cgo=;
        b=B4Hu/VUsoIz0aufDkWapTh1qbwplNTZQVEMbkjQ1xPrFYnr/XDSczj5toe5oZdEuRp
         yIthLGU0mll0b54nZPmgdJxq1xnWxJ9OZDV+PVyGCZHepBieSZUpgVvBHzzkngf+lPDC
         YmOXFQj/iRUI9zAVh0TscaZqUyJtk3C0MLk9RWNeBFqaIs9iWWBfOOm70ov26LvAgpki
         OuJsbMs7mq0ui56RUaDuQiTNPjrrqgcNZXDYHED6vHxkI1tnMdF5R1POGcj9K7F6JF5A
         ggpZpoZgyueEEKRahdRD9ZF6fAWIh8BZ2E/X7u/QYOIJu2hXgc52JggNGauRocFtVjXs
         L6RQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGGy26ZwsyoqZohYkC4W08JrHjO7wSBb0Wp/Hvwp+kWhw38hje77bKvPApjAe63nD/dpC91iEDxccVjw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyaLXyLHz25zT/e+ikBP/c9shMCWjtQ61wlmD/rpHFHlSC2NT4B
	yC/F5i6jNj1SO7X4uDAAU7LNzJSogvnAjROBqv+eAnV8qgdCJvVO7tluTbEigjI=
X-Gm-Gg: ASbGncsQCJig8M6atQ2SfeFrsvvwJTE7zli0I7oxG1QxhwiuOBhSxOwjYja54VrVQ1f
	CqYth/bFw5bIOZLk7xk2grdZa//+rrAfzQNDOu0Vjejlc0qt7PMyJABqd0/rlV/Tx/+UAyz3gF0
	KQdgPU7xLOOaeyfF9KmcLyoJkAQINR/NQvCc1ulofDcKYJ5vKkMDj47ZLujFWn4BwZk/HTPPoJM
	QdPEcFanYfkKAt/+y+wUdESN+AtXYypzBBmqNJCPnbmWlC/WUwr3wXfKbt71FYIDT5wKU0=
X-Google-Smtp-Source: AGHT+IGoamWVqwFBCte9IxOpQQ7DCMDYWPusRfzNwN0cUBdx1fxw1ns2IcyqhToSEVrLz61EtuVfdw==
X-Received: by 2002:a05:6000:1864:b0:385:ee59:44f3 with SMTP id ffacd0b85a97d-3864ce4afaemr2263141f8f.3.1734003073551;
        Thu, 12 Dec 2024 03:31:13 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725f9ff3909sm6285107b3a.77.2024.12.12.03.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 03:31:12 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	gregkh@linuxfoundation.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH] ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"
Date: Thu, 12 Dec 2024 19:31:05 +0800
Message-ID: <20241212113107.9792-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
unmounting an ocfs2 volume").

In commit dfe6c5692fb5, the commit log "This bug has existed since the
initial OCFS2 code." is wrong. The correct introduction commit is
30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").

The influence of commit dfe6c5692fb5 is that it provides a correct
fix for the latest kernel. however, it shouldn't be pushed to stable
branches. Let's use this commit to revert all branches that include
dfe6c5692fb5 and use a new fix method to fix commit 30dd3478c3cd.

Fixes: dfe6c5692fb5 ("ocfs2: fix the la space leak when unmounting an ocfs2 volume")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/localalloc.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 8ac42ea81a17..5df34561c551 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1002,25 +1002,6 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 		start = bit_off + 1;
 	}
 
-	/* clear the contiguous bits until the end boundary */
-	if (count) {
-		blkno = la_start_blk +
-			ocfs2_clusters_to_blocks(osb->sb,
-					start - count);
-
-		trace_ocfs2_sync_local_to_main_free(
-				count, start - count,
-				(unsigned long long)la_start_blk,
-				(unsigned long long)blkno);
-
-		status = ocfs2_release_clusters(handle,
-				main_bm_inode,
-				main_bm_bh, blkno,
-				count);
-		if (status < 0)
-			mlog_errno(status);
-	}
-
 bail:
 	if (status)
 		mlog_errno(status);
-- 
2.43.0

