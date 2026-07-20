Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17FE429006
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 14:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557201; cv=none; b=j5Qf3/32Dw5nhDma0lF2/VIL83SnidYVEBkUaUu8j1WL9iCTjhqgR5ZuQ60g4tGcyGI5JAkNPWb1PIGFJlPDpjkwJQT0EJnw90kKQgBVVQm5a3FAINKfwcgmrT0LMkxsgRtWKgxZ1gyApLzZzR/jvLzeAR58/jeoIX4/2Xf3uic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557201; c=relaxed/simple;
	bh=oaAbz8G8f2X7RTP1P1HJ+1cflrmoJylc1nG/N2BbeVM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t+yXXqs/TYcX9+dR+ajKRbM0//MDl9rf0/W6vBYuIhpbnq4fogd3HW+F8T88I7eSTY7rgxgsdZhK92pyIT11isAn+zI7BNvjyMPH3vbuy+fDd4jxuMalZ23VUl9F0ujGoF0qcBfcY/g/ne3MU7ZqLH3BGBa9vxPX+LewqEhjz5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sLl8xhhy; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sLl8xhhy"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ceab75934dso105976155ad.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 07:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784557199; x=1785161999; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e7d4MGOSniHAE+Fyu0H72S0OaeGQ/IROc3PriVSjYUc=;
        b=sLl8xhhyAKdrcLlZXEsdQ/m0zq1RxpGocLUzCYAdFWjqxnXBEquCMVL5jPMQcsVjW6
         8bRXqw3n1VtUQpCaQMFDUDP0rbgTs4Y1Gzsqm+Nwd89Cj5gIs+YqAV6NzFccKqSZDV5Y
         Pa8vL/QTw0qU2W5q90tkBppWTEv8R8nTFKSuuXKVBpVWkFT2khG7uZjAZSHupOjy1/ml
         SkOvUawWvb6QwoxDEqCQRhUO90nJHSCWX1PBfuVEhKiNQX0E3nOP6RSh3lure9844XTE
         aLlrRxdtJTpRqehfU+bbOBaYj2J2f9coz/7EYVAEmd+zDS29HsgsydQh3ZfqG+xoDoyT
         OB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784557199; x=1785161999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e7d4MGOSniHAE+Fyu0H72S0OaeGQ/IROc3PriVSjYUc=;
        b=idCANZn8ZUfoq3IO9mqiAcXG7glJqOTTQcaLIe7cmEHLl0H/rPCGrVyY7VSZteLFJP
         6bqpwEXf20PHfKpUMG/41JGAk0Gz1ajdqQzshFOKJWvPHuzeZLdi4q++Z+uessbbFknU
         4PL6GRTgmV1xewhuw0Mc86qRXR69VoUXNTZBOulAuy8Gih+Zc7JKGAklLYX5FDDkLxM/
         EdTZ+g4ZFijAK8QJKq7eVS8//feunY1EE6q6xBqdVEImzP6T97mcpOQ+mA3RtGNoX7AM
         eSqXNmTV0wD6tTwGTqM2va+mfMMoTXqqIbRimdYLuKGQUKw/JC//rLugiCt/LWc2hq0T
         lV/A==
X-Forwarded-Encrypted: i=1; AHgh+RrrOKtdtoSiODddU/yCBUuQYIfEiECauuIt1HLopufNVTWi7awABdI7ypU0OnUaeOw+u3sjX8V5GJBNbw==@lists.linux.dev
X-Gm-Message-State: AOJu0YymthZix6164jtGvfyd2d2PRaBl9B7WXIAQPG5sdaX6yPIEOmbw
	sfUFw1+bF0pexfHMruMWKeTHj3cWPDxetC6uIFNdibFhBEqwbx8gVNSWWbklLW7ssqg8lQ==
X-Gm-Gg: AR+sD11ee6W03jVWMBLSrL58cRotsH603Lk5GHHdV2fWQiKbmxmBOZAWqi7S3rccuHO
	MxjwHxWY9s9xTL7jGhRUKnAtIEOOkqY8N3u3YT0ypZAfiE5AQNps/eX4RN+mHFdw/FzVjLtEuc7
	GUN5cOfbAQGl4vZEdifvWk1QXl6uOKgNUmysJj3qIIP3jz8T2sHTweQ/BIFCelCFT6mpdlvfv+p
	TbE21l23ltCAEzXmP/x0x7ubBF6LkW4ESICRW7Sksuz/2cp8JuKEYgskOEHGHvQzb0vW0ynmiHZ
	fDPOGp5xWu6bhk3tdVl5LVYYfhz6UkFwuOYl5I0wAytzbT77ilwHQuKSpFTVxhEE6WMMkE9lXAh
	oDj92q0RP3L3+9Vy5UqDF9oSW4h2PbAjoD8TOgMVpiYy2xHrK7ZCFJGkjIhVFNEmZN+iOo6ghdl
	s=
X-Received: by 2002:a17:902:f710:b0:2cf:7d44:e14f with SMTP id d9443c01a7336-2cf7d44f558mr4954095ad.26.1784557198961;
        Mon, 20 Jul 2026 07:19:58 -0700 (PDT)
Received: from lgs.. ([101.76.249.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3479463bsm56844765ad.80.2026.07.20.07.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 07:19:58 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Tristan Ye <tristan.ye@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH v3] ocfs2: free unused clusters on defrag move errors
Date: Mon, 20 Jul 2026 22:19:43 +0800
Message-ID: <20260720141944.485212-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_defrag_extent() claims new clusters before calling
__ocfs2_move_extent(). If the move fails before ocfs2_split_extent()
succeeds, the claimed clusters are not referenced by the inode and must
be released.

The current error path only logs the error and continues to
ocfs2_cow_sync_writeback(), which can overwrite the original error with
zero and leave the claimed clusters allocated.

Not every __ocfs2_move_extent() error can free the new clusters. Once
ocfs2_split_extent() succeeds, the extent tree references them even if
ocfs2_decrease_refcount() or ocfs2_truncate_log_append() subsequently
fails. Freeing the clusters in that case would leave the extent tree
pointing to clusters marked free.

context->new_phys_cpos is updated immediately after a successful extent
split. Compare it with the newly claimed physical cluster on error. If
they differ, the split for the current move did not complete and the
claimed clusters can be freed. If they match, leave the clusters
allocated because the extent tree already references them.

Return move errors through the transaction cleanup path so that the
original error is preserved instead of being overwritten by writeback.

Fixes: 202ee5facb2c ("Ocfs2/move_extents: defrag a range of extent.")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v3:
  - Fix the duplicate split_started declaration.
  - Reuse context->new_phys_cpos to determine whether the extent split
    succeeded, as suggested by Joseph Qi.
  - Avoid changing the __ocfs2_move_extent() prototype.

v2:
  - Do not free the new clusters after the extent-tree update has
    started, as pointed out by Joseph Qi.
  - Track whether the new clusters remain unused on error.
  - Preserve __ocfs2_move_extent() errors instead of allowing the
    subsequent writeback call to overwrite them.

 fs/ocfs2/move_extents.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index ad1678ee7cc4..7820df90a262 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -310,8 +310,12 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 
 	ret = __ocfs2_move_extent(handle, context, cpos, new_len, phys_cpos,
 				  new_phys_cpos, ext_flags);
-	if (ret)
+	if (ret) {
 		mlog_errno(ret);
+		if (context->new_phys_cpos != new_phys_cpos)
+			need_free = 1;
+		goto out_commit;
+	}
 
 	if (partial && (new_len != *len))
 		*len = new_len;
-- 
2.43.0

