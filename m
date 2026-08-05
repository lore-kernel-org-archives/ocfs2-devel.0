Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833EA3DFC6A
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785913725; cv=none; b=TXHtf5ytqekc+tFzJok6HxV+nl/Le9j8hPhwuD+UCH4898MdAZE3McYKAlL/aIaBaGhCoSWLhuCSbzrOuUe32mtCo+65JBIP6Rj0aB2QeNN0k0BvnCrNwdSDMUb+40maz2LZd0W15EU0NXh6dUSfhMhCWSizunbz67EBkkOJ4NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785913725; c=relaxed/simple;
	bh=7HiAf+EpVjkitp9J9mLgx1LeCBjQIRcocIrQjiEIkm0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=raKmtLO0YQrfyiYNUAVtUWKyUPV3n/NlefsCJnvZxBpRmxdjVEORJSUtWx2VgMcnBaSzZID35z2TGcekenoy1wWw93H4suaX/zs4VLpfVNGU8m1Zu15IZhNyi5DxpohERWNrwfObv8kj9vh4Xm2q88BDqZqgyJAi1lyHOhQQ30w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nw3MomnI; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nw3MomnI"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-381b831d535so780769a91.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 00:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785913723; x=1786518523; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g/DUUT6RMx4jLkGvR4e26W85aURX7BHuSfTbyD0AJW0=;
        b=nw3MomnImn20fgDssbcJSgq/VTnQeklqwkyutXf0v/9KaOkINDmifIJW0DMCz7IrnW
         2+Kgg5Bfg5PLo/msRi4JFVi75TJP8YdsB0LTM7xooSwQx5JHAaLMrTWslX6+z/vXRaRj
         1I3GC09FdfOhqMNGZRmIXEUHx0prkUtOo9vdFbbjUVGKi28ZZtovU3rkd/5+OdetmE/5
         Y0C4pHPOWb6PIxKBPVwSL7/G8wpvnBdcstg5GvO6VFoN5fwT9q7V+kbpEoU9O5yN6Vo8
         Qa5XfOJwUEAa39+Ovr3ghFLwNnvCth6ldaUBr6UZAxNBGwe6m0R/cIyy4DvVJDZx0N5g
         zqsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785913723; x=1786518523;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g/DUUT6RMx4jLkGvR4e26W85aURX7BHuSfTbyD0AJW0=;
        b=AuMnV2E+8kQ/m7QPZFdrSaU2JL57JgbUy79T54oLYltrWJ49hdehsl6f5Nc8H0Y3JE
         yTUIHtRUJCKhUkxixUph+2uSR9j3tfNlLzaq0yoP8XYzYnxoPO45QyZkaENLxYQDFdfY
         xxnv27jPvkLXGsA7SqvX0E0ngMOObz0mys/Z2txfHJDR9SwMeRIGy6Ey7e34XP/Rvr/Q
         aLkBWXn5lPJgvK/LYJCAD5GmmzqjS+leoGC5nHAyQqLa2qA8BwVzsj1HU7VSPoaqVlAY
         FklFZ5SRdo+cMEaSB+4DQSHkoDck2pWn10pX6KuE94hf5TPLB/iuj7zA0VztBG+eUw+1
         /9mw==
X-Gm-Message-State: AOJu0YyQqgbuXT+jv6SqV6Twx4mrBJS7/YQxdd7equ00KA54tLTp+VIF
	MVIb1wgn/6vwNtS62bRJf8JMCFBUN+s391tAYY1h83tGFtLA1j9tq6bDeQxfvFQh
X-Gm-Gg: AR+sD13EobPKzr0d4Ao4lA5wwLeWvHyk7aLnqjlDtj0MgAAE6nEjAb/a9ccOzngHo0x
	nPbNhx7tc83wK3tpdjxX/fBp1df9bpvR6tCZfVdIU2+qKOuRo7dgE1D8Gw3ByWstA+oL9kYs/Ta
	W8jwZgxgddYZ/P/1IpodXJIWWubRK8uKg4l2sLMJXegvKqKdr7NW1ltO2yOSQI0dhpCnVD1QxPI
	UNd2JetkWnVPWc2jjszeRENNtEshmTEGVV2Ho+Ocj3aipTrUeb4nBItlRpZddTW9klCCd1Be4/s
	F0zlhS1wlQZyuUv87azIt9cysGFM9BDkHm+Clz8IhBii1HOuAPkWuDAoc1GGHLe/JQWZlKthhXF
	hQSjV0jCi8YecTE6FKYLTfJDmSQGPIlhL24yxT9vZMGSd/mh1TN0SwXl3j4eyQE/Y5XWCcjBevg
	3YgvqjIgpe8eUp7+gTCx7ZyQaq3YmMcpwOMWN1Ytp6HsByoTSxReaV1dMYrmSFXRxTFobQXdDbp
	rtmPbSL+7s7woZcyNYFXfzCFvrSsuU+xYCEZJMWOj5CjIuyIzrcYSFw0zDK/9sEvn9cv3qDM818
	V3NARFsIN/FwnMBZqk7eoLSYVkyag0dW9r8TDGrXVbAhJFo+OyJwOvAVgb5BNkPJ
X-Received: by 2002:a17:90b:584c:b0:38e:2f21:3bb5 with SMTP id 98e67ed59e1d1-3903c63373emr5263359a91.21.1785913722666;
        Wed, 05 Aug 2026 00:08:42 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3903927dddbsm2136523a91.9.2026.08.05.00.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 00:08:42 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	glass.su@suse.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Matthias Goergens <matthias.goergens@gmail.com>
Subject: [PATCH] ocfs2: fix cached cluster count after suballocator reclaim
Date: Wed,  5 Aug 2026 15:08:37 +0800
Message-ID: <20260805070837.3390148-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When reclaiming a suballocator block group, first reduce the on-disk
cluster count by cl_cpg.  The current code then subtracts that new count
from the old cached count.

For an allocator with N groups, that leaves the cache at

    N * cl_cpg - (N - 1) * cl_cpg = cl_cpg

regardless of N.  This happens to be correct when reclaiming from two
groups, but undercounts the clusters from three groups onwards.  The
incorrect cache value is also used immediately to update i_blocks.

Assign the updated on-disk count to the cache, matching the allocation and
inode refresh paths.

In a QEMU test using a clean 256 MiB OCFS2 image and a 10,000-file
create/delete workload, the first buggy reclaim left the on-disk and cached
counts at 2048 and 512 clusters respectively; later reclaims underflowed
the cache.  With this change, the cache matched the on-disk count across
all four reclaims: 2048, 1536, 1024, and 512 clusters.

Fixes: 4a54331616b3 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 fs/ocfs2/suballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index a4a2b87a45fe3..20c3aec6b9873 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2759,7 +2759,7 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
 	fe->i_clusters = cpu_to_le32(tmp_used - le16_to_cpu(cl->cl_cpg));
 
 	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
-	OCFS2_I(alloc_inode)->ip_clusters -= le32_to_cpu(fe->i_clusters);
+	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
 	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
 					     le32_to_cpu(fe->i_clusters)));
 	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
-- 
2.55.0

