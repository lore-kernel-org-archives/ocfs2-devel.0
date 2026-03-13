Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A35D1EC01B
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Mar 2026 21:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773438979; cv=none; b=HHKefGx7VhP4iFFjpQFBzoaDktHboe0xvmn+D8/8oGZIgIFBz6+UyME0vlq7YZEf8MWkEzo1PsBgLucmdyXm6tZ3o/olo58WmznvbcXUPVMPWMsTdw9hplkXuOKwVJ64Yf8dgcghB1V7d1jgbn32QP6SF/7odEZe6pHGGF0FxWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773438979; c=relaxed/simple;
	bh=sRheUGXJhgHPJNIYQ6WiQRbGOF3KWgoRj5XdBPU009E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=c4kW3oz8Y4IqXP528qPvMuE83y9ets3ucGqg8G8A7Ly40Xrbe4WRQpw+MHIwPXnITOEIQwMbR1FWGkb2UCRaT6xnRAwPoWm5MaGgx78JR/NL29pUqrMMuDxSHIh3Nrphzc7r0PV+NvReb58h8y51QJ9mWg4QaX0JWsHruE2lTxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BaS28vZf; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BaS28vZf"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cbc593a67aso274381085a.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Mar 2026 14:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773438977; x=1774043777; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+0kAWsqQbIMaSFTcp7ztR3JUQe50QlfN4LNuH+iuaWE=;
        b=BaS28vZfyl31iy8V0rhSi3QSN4Izp7bXxYOWb//BTT77EqR/8LmhNG0chrPqKyXHcx
         ne1670mqtxUd+oaAN92oah8d9F7eH43LBdJ1wKTG8x2WmdaucbjVSgdOLy739LwrTain
         yEqDus6cON2S2KwfEpQGqvvCvwoZ6iO4Ji52XQKyFgEt0qd1yfSfM8YzrPm9h6QwoyGE
         brPWbGI5q1gs/DG2Pf9CtpsyOjhGyWDQyZs88PWjBy7MDTK7TiKTvEAn5jw/n10XIwYs
         6K7FcUOsgOn3id6oFTJdtuJn7maGmLD5HTggWHxgAPVQIAA612eXCLpSVfU1+jWaCd/A
         jusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773438977; x=1774043777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+0kAWsqQbIMaSFTcp7ztR3JUQe50QlfN4LNuH+iuaWE=;
        b=AKmVsI8jJ+m1P1EgbSCcmFU53NV43TLB7gwoD5Oqa0cg+sqTebDlrrm0GruKsuRUWA
         Jh8vicqHyudiSBkMGADvPR+EFxz20RUozZSKzsDc3TsODRaSx32nDKxeaoOK5q3Rg4Y0
         wB3WZhx33CnAbZCRXjnlWABvNP7Q9Q3zPcX0t6wgSPnebaSyDV9xh/Ujll39hzxxJZxx
         e23HpS5oLKxEDXBkipe7Xe+sbJ8e4PpObGHvI2Dbo2Ssly05UHJBraWn3kDi532JCpgd
         2SYtfX8cqzSbeclFZ5T7i4O/wncg1/bOqzV2ToCQb+46eXIHBisLUT7hXQmtCg01Rvhn
         6zRQ==
X-Gm-Message-State: AOJu0YwXIaVsTQSF37TC2Q7kq3rhVJNk2fmbpQZwwZ/g/oGLWqRLFThu
	ImVElSsyHVHhOV7hN/yvS0U0Fsk7kHcNwZ3evuMWrEmxZF5VBOY9LViP
X-Gm-Gg: ATEYQzzpPZuBJHSPjm1fMBTxzeRfscFgvUdS3m9Z4awDcfRn1UlkwnjTrqNXS6/fmT7
	phQiBmeVeP2qCw2jvFZG6cYU6HSVVwEJijomYqLi+H57rTd9G1SGRtq+2lBxomjnKAsh+QhNgrH
	Gp/2lpJWTK3jHbdI9YHdnkoZuAJzFzM598DBqI5JiGl5fXengk8mVKyiieVbOsaiYvhCH0/Y993
	AvTr+i2wNiNcrm8HV3ap4pnIT3aRrFW5ooblTUQu3eWJ871xLOYU7C0+K3Ph2X1EYVSCp1e8FUs
	zO6WEOdOCOAfUZ8LrMqME6V+89goTcCOlctwn79iliVnw7CA60JjX3b12i7m3vtVcwvZkvQnrD8
	NVH2l5FlpxDiTgC5dm0zt7l1v2vpvz6JcNxMeIAkiMvjpQMPDRUdrhjlLb6+ReELKjnMJYMIe+S
	DFPlHvDW+0a+1XQFs2hPjelf8iMj853GCatQ==
X-Received: by 2002:a05:620a:28c7:b0:8cb:d9a2:1347 with SMTP id af79cd13be357-8cdb5b7cce1mr652053585a.57.1773438976651;
        Fri, 13 Mar 2026 14:56:16 -0700 (PDT)
Received: from 192-222-50-213.ll.local ([192.222.50.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda1fc474dsm731421885a.6.2026.03.13.14.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 14:56:16 -0700 (PDT)
From: Jenny Guanni Qu <qguanni@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com,
	Jenny Guanni Qu <qguanni@gmail.com>
Subject: [PATCH] ocfs2: dlm: validate cancel join message length and fields
Date: Fri, 13 Mar 2026 21:56:16 +0000
Message-Id: <20260313215616.2660551-1-qguanni@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

dlm_cancel_join_handler() casts msg->buf to struct dlm_cancel_join and
accesses its fields without verifying that the received message length
is at least sizeof(struct dlm_cancel_join). A short message from a
cluster peer can cause out-of-bounds reads.

Additionally, cancel->name_len is not validated before being passed to
__dlm_lookup_domain_full() which uses it as a memcmp length, and
cancel->domain is logged with %s which reads until a NUL terminator
that may not exist within the received payload.

Add a message length check, validate name_len against O2NM_MAX_NAME_LEN,
and use %.*s for bounded logging.

The OOB read pattern was confirmed with KASAN using a test module
that accesses fields past a short kmalloc'd buffer matching the
handler's cast pattern.

Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
---
 fs/ocfs2/dlm/dlmdomain.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 2018501b2249..43fead9c5e90 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1323,10 +1323,16 @@ static int dlm_cancel_join_handler(struct o2net_msg *msg, u32 len, void *data,
 	struct dlm_cancel_join *cancel;
 	struct dlm_ctxt *dlm = NULL;
 
+	if (len < sizeof(struct dlm_cancel_join))
+		return -EINVAL;
+
 	cancel = (struct dlm_cancel_join *) msg->buf;
 
-	mlog(0, "node %u cancels join on domain %s\n", cancel->node_idx,
-		  cancel->domain);
+	if (cancel->name_len >= O2NM_MAX_NAME_LEN)
+		return -EINVAL;
+
+	mlog(0, "node %u cancels join on domain %.*s\n", cancel->node_idx,
+		  cancel->name_len, cancel->domain);
 
 	spin_lock(&dlm_domain_lock);
 	dlm = __dlm_lookup_domain_full(cancel->domain, cancel->name_len);
-- 
2.34.1

