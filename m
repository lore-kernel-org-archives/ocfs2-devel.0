Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C214A409298
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 11:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785929968; cv=none; b=Vj8xUYR8h25AU+WrONcbbf/kZNZW0aRn/LjDojRBVmupdwQoql1Px6dutL9vaHKj2uaZ/KcAWY+EZ+fMoO5n+GGsck0U+FknTOu0crJc7TqM+u1bupY5YmdLpeT+41vC1U4g+MLkTsRygOHAELhCkm3ZqsELNSra1mx3RU/meCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785929968; c=relaxed/simple;
	bh=iAmUHHQzaz4f9Rg6y4wTz9QKPgpQfSPXphBN6MdnwQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvOAeSR7rxkL1AuPj3Qo47hKXSK2Uc9c64vT7qXF4JLJhNvb8vipUAwQybX2bkaFERlWD0Kp+euIYOEJZKHm9/RmN5iq000SM15RjkXvd7YIq2EYBZO1Ig95lMDpp07mn0AWXZQb1ckT88KT6oDoOJyoZWUj1yB+pHxnlSleIuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZOPCTYY7; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOPCTYY7"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c966b9ee9cbso539947a12.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 04:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785929966; x=1786534766; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cWKwxfj+Ulmx669+xXO9b93Zs1csGNYfgoV9iYgU+M8=;
        b=ZOPCTYY7LU8wGlrLvxQKxKwGraJld1B+4vLvGbN0zwB3p6+RV5/LR9AARci099s0cI
         o0FEqG5pnuVFprSHuwXRj4DWg+r1m8pkpYLgl6zIJxgM/iw8m1gMl6Gzwk/1M2awulJp
         ngWR/OqCHYbtk+p/rUMr7U2bka/cmckgI/HVkbMO6B6jdZrjfx9AzhAX1tkPAGv2KfzL
         /y+gehQvX5XrUNteJQwl8ZtQ7Es48sNvPOcCTgaLK+9Oi78SLGNQxDLrg36bgzNanXps
         QapPu5luAELLFjKCbPi+YbC+Zn1EB0RTsoHViQJmH18KZmKh9Udpw76I3rG6uV6RKWqL
         NLNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785929966; x=1786534766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cWKwxfj+Ulmx669+xXO9b93Zs1csGNYfgoV9iYgU+M8=;
        b=JD4FPpurl7sfKMDzj3kM7jqqSjZCqxDsqfYZuHXPaB+2ynUuV6sDu2WXjfT1N+wQDZ
         5a/wlHVnCZWcriF9ZQQ20+Gj54cioisdgDe/FX/S3ezTG2BRQAM4Uq+jK5PxNTmVdwHy
         oPEJvjjw5evVnCQLC4JAwESyzkI3lt0s8C0TVT1vfDtSJGAHVsn2ESpVflBav/Zx85XV
         m5Zb711DeGrX6UkrfLE9bwfuAA/L7hzjOLPR0aHWO71UevNECC5iMSTj59bvXC7YLoWw
         F90gIIQeDc9Jo+VwbbX0pCy3SkVrcdAwClSYmDmAvpwqahvE427/OSkC+JMKP6ymYTbB
         z6+Q==
X-Gm-Message-State: AOJu0YxKEcDZ36nGHTMobSj/kgOm15OQloxc7Rs8i4zv8AC/busn8E8V
	LnchRrf4gG4mJzCyUTRuEzo3DN97QuYUGHy75MFZQTHNWMFnpwJKHF1C6T/d7Pns
X-Gm-Gg: AR+sD12t/eOBGIzSw8FVP81dOhL2ZS/e9w5J6wlOwrUwVh3agQxAUa2VAFAQJ7pp02u
	qwjTY7AZ1uTbZAmFavzFd7iNSe35bc9agXV+98u2hkbarD83aFENUkZLAf5lKbEUsTO07GatmUS
	DcAlRzyIfxvlwgSLkhZO+ognFtVQ+mL3gRG2e2NjnucORan2/Fhk5yZ2WP7a8BhICQzx7qeBaap
	GGOUPvbnOCVRZJV/K4jdIYRywInlP0OSp48GOY/VefN2OZE3LYh7RbpJ9x4rBx54sBQGsHOfQ3a
	lkeOYm4/JflipifSQCZZxcMyaju7OnNhrchM1QBw7eQkta5lcIBljUZ/uObDfTetdA1YSRlroqj
	FrOEKXXWg8NeqYhy20tDt4nzRb3MsZR4+RLo9ZIeNdrIA0R9zLsfQ5z9fsvD92p8TfWwwjcKSMl
	Nt8w9poUfw07sNZDG6Cjr6sYDvef1QZKQsEYl8vN9ntkOtqdSr09+UMhR2qsFMpq/u8QK+VNbED
	Ok2HdkBNwSh5IOdngBdlBH3AS1RhjPDvAoJoRGEbLR+2zy04TWIPzwSDE5KQfdz22b2plqYR1Sv
	xONwnVu9JAGjpBxiXkSzuQTYofOFhNUZwqGX8zempGw+VkzcbWyt
X-Received: by 2002:a05:6a00:22cc:b0:848:2c6c:dfc0 with SMTP id d2e1a72fcca58-84f2e04ea1amr6194826b3a.24.1785929966087;
        Wed, 05 Aug 2026 04:39:26 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe708c0ebesm1368088a12.19.2026.08.05.04.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:39:25 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: heming.zhao@suse.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	glass.su@suse.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Matthias Goergens <matthias.goergens@gmail.com>
Subject: [PATCH v2] ocfs2: fix cached cluster count after suballocator reclaim
Date: Wed,  5 Aug 2026 19:39:20 +0800
Message-ID: <20260805113920.385959-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <anL1pYKZK8UqYwsI@p15>
References: <20260805070837.3390148-1-matthias.goergens@gmail.com> <anL1pYKZK8UqYwsI@p15>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When reclaiming a suballocator block group, first reduce the on-disk
cluster count by cl_cpg.  The current code then subtracts that new
count (fe->i_clusters) from the old cached count
(OCFS2_I(alloc_inode)->ip_clusters).

For an allocator with N block groups, that leaves the cache at

    N * cl_cpg - (N * cl_cpg - cl_cpg) = cl_cpg

i.e. ip_clusters -= (fe->i_clusters - cl_cpg) leaves ip_clusters equal
to cl_cpg regardless of N.  This happens to be correct when reclaiming
from two block groups, but undercounts the clusters from three block
groups onwards.  The incorrect cache value is also used immediately to
update i_blocks.

Assign the updated on-disk count to the cache, matching the allocation
and inode refresh paths.

In a QEMU test using a clean 256 MiB OCFS2 image and a 10,000-file
create/delete workload, the first buggy reclaim left the on-disk
(fe->i_clusters) and cached (ip_clusters) counts at 2048 and 512
clusters respectively; later reclaims underflowed the cache.  With this
change, the cache matched the on-disk count across all four reclaims:
2048, 1536, 1024, and 512 clusters.

Fixes: 4a54331616b3 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---

v2: commit-log wording revisions suggested by Heming Zhao; code unchanged.
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

