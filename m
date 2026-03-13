Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8CE3822A0
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Mar 2026 21:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773438177; cv=none; b=iZUIjU6D6zIjqQob/L5x65NuI4yaSeI6m0smc81MVwBPEzeP6xFgtiKho/I1/VswRP1XVzRuskVIk+yW2D2PovcAPQlaLX6T85g571IJK+bqbIgvE9CdvD2WvMsYrbYFdtmFgfuEjyK1Eu8tbvq0siVCeMFKXDg1+1BxUAvgcvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773438177; c=relaxed/simple;
	bh=bHG4gZMAiN6VNR/qTLz4pbVjdYOaTPWJrossjls/ObU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=bVRx3d8s3edSEyfnF+FpqA4c2C+/svZjZciOjy/LQUSXiPBrVLYQ9lPVY6hJTh4CuKN2EE3FJbsmWrPoz+h2UQP4XvIQaLPQ0t+CF4r78LyRXgQt22wJJ1Ca4pazL2ieU6T5xyBuKzrGhDsvXu8/1yunjYHmvO4qobolBi9Buf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RAVSYUKl; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RAVSYUKl"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cb4136d865so344080985a.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Mar 2026 14:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773438175; x=1774042975; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+IsH/P92VNlZ7hzAjgOWNGzQev1SNkbaW27hkcWXgNw=;
        b=RAVSYUKlZMNk+LRb4QfS5KgWS2LA+mkMGbhghSBBEFdVlXoss/u+mAvlrf+mu/3HKm
         ZrTRr/oiRTpjIK99PUdWit4HkmGDBRxB34m3JPlIgAfulRj88/dh+MgdfDP6UqMp0Ume
         5b88kKsZlDysrifT5/1QW8kc8OMBBsYmeOZsooXeRDmwPOX5peJz4ddkG8uTu2sHG9+v
         921y2EOCfJJHi8Mcx4OTi4Z3zwJ/550RB9GwSOXDGmcqrDw1IcGXL0lZ7voNP77YP41Y
         IEpqdgcfEFqZ+N6q4qO6qMFwOBQtzWJD/jdG8GuwG1zG8YyCZMrt4eTA4uA7gJfNXP9H
         Xx7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773438175; x=1774042975;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+IsH/P92VNlZ7hzAjgOWNGzQev1SNkbaW27hkcWXgNw=;
        b=S+hH3hcew4597uPuzKGl4p3oN0RIpafmur/6qnFRJ1JXRoFZTF2qAAaz4uXIU8OOp4
         oWHBNkaKAVjO6kGX/poHLsP4G/80r3S9lXDEB9/mBXUV39QXUZEcLl4yOX59pwcPprqj
         x0c0d6ynsbhH/j4ysYJzC9h2iVQOw6K2U9bH1egbC6bqNFRrXxUQ2bIdQIPd+IdLgIUL
         eVsfzfeNQ6RgbRHy/hX74oNeBVCElasR2GJbVMeg0KArbN5FHRoZfhyefsZmZuM2d4+7
         Ud64J1BMu3GI5DuKeltugzD9GVyg7mFCs4AiAN9eyF7egTDIUkRj4amtKtAQBs/7FiGX
         /fRQ==
X-Gm-Message-State: AOJu0YyoIxHdyxIi4bO4JaVJjwuNAswpwKulUCuU8+meQOFcYD1KIqEf
	TR9Gl+Rgfn7eMRXwPP+Whu3R3UVlHbr87uIpH8O8S1xyyyPltOYLIswE
X-Gm-Gg: ATEYQzyKjIQtmaI7hgDs0GhgIaOpz9e4VYzqyFylk7azjpVepswK04m5WZSAA2Ud5h0
	fcoXues0aBhGOJucRhCZH7I/WI59bpaBGqrdGzeLO6se2ZP3W3Ofq9zYkww+vpI6ThmiAxURYFD
	5WkCRwI0m5dvnlPJmlBGUQSwbPXi3V+3lwSXD4kskEiFM5Yw7KCFacO9ykztfzFkZ1+e5tE3eY1
	OXgr9ZrDKM262OUVTGAEBrcm8XuzVXl7lki2mjp55vGHOLlyqksE0+lmP5E5JT5G9aphpRywmHX
	JBNpghdqzDKmHkS2leQtyabAStxaNCDPdI2kaa/Ka01NXV3SahxxIPfOatDN4FVmR8NtFfQycfU
	aW6iMo9WJwJqH5vIwjPsgfrYaySa+jSHHgpPYfpNODUbfLOtyfse316SzdJN75lekxi3k6Ro71f
	4OwyRocar/jI6kDgqB/vjR5KQz5VQeJlS1LQ==
X-Received: by 2002:a05:620a:4707:b0:8cd:b52c:598f with SMTP id af79cd13be357-8cdb5baae87mr696012285a.59.1773438175373;
        Fri, 13 Mar 2026 14:42:55 -0700 (PDT)
Received: from 192-222-50-213.ll.local ([192.222.50.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda215c2a9sm639620885a.46.2026.03.13.14.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 14:42:55 -0700 (PDT)
From: Jenny Guanni Qu <qguanni@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com,
	Jenny Guanni Qu <qguanni@gmail.com>
Subject: [PATCH] ocfs2: dlm: validate bit index in refmap helpers
Date: Fri, 13 Mar 2026 21:42:54 +0000
Message-Id: <20260313214254.2594762-1-qguanni@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

dlm_lockres_set_refmap_bit() and dlm_lockres_clear_refmap_bit() pass
the bit parameter directly to set_bit()/clear_bit() on res->refmap
without checking that it is within O2NM_MAX_NODES. Since refmap is
sized for exactly O2NM_MAX_NODES bits, an out-of-range value causes
an out-of-bounds write past the bitmap.

The bit value originates from request->node_idx in network message
handlers such as dlm_master_request_handler(), which do not validate
node_idx before calling set_refmap_bit. In contrast,
dlm_deref_lockres_handler() already checks node_idx >= O2NM_MAX_NODES.

Add bounds checks in both refmap helpers to prevent OOB writes from
any caller.

The OOB write pattern was confirmed with KASAN using a test module
that calls set_bit() with an out-of-range index on a kmalloc'd bitmap
matching the refmap layout.

Fixes: 8d400b81cc83 ("ocfs2/dlm: Clean up refmap helpers")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index d610da8e2f24..08746e118466 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -606,6 +606,11 @@ void dlm_lockres_set_refmap_bit(struct dlm_ctxt *dlm,
 	mlog(0, "res %.*s, set node %u, %ps()\n", res->lockname.len,
 	     res->lockname.name, bit, __builtin_return_address(0));
 
+	if (bit >= O2NM_MAX_NODES) {
+		mlog(ML_ERROR, "bit %d >= O2NM_MAX_NODES (%d)\n",
+		     bit, O2NM_MAX_NODES);
+		return;
+	}
 	set_bit(bit, res->refmap);
 }
 
@@ -617,6 +622,11 @@ void dlm_lockres_clear_refmap_bit(struct dlm_ctxt *dlm,
 	mlog(0, "res %.*s, clr node %u, %ps()\n", res->lockname.len,
 	     res->lockname.name, bit, __builtin_return_address(0));
 
+	if (bit >= O2NM_MAX_NODES) {
+		mlog(ML_ERROR, "bit %d >= O2NM_MAX_NODES (%d)\n",
+		     bit, O2NM_MAX_NODES);
+		return;
+	}
 	clear_bit(bit, res->refmap);
 }
 
-- 
2.34.1

