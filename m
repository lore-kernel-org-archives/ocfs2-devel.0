Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D052EA754
	for <ocfs2-devel@lists.linux.dev>; Tue, 15 Sep 2026 04:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789445806; cv=none; b=IJA6Kqz5osk7j5QbL7v5bDxiJradVr8H8U4N9/M8/pZVLcylhZX77VpQyTP0U8zpqQLRIclDE1HTZJDbbzkCxDHqCoQjVviipmakIWh1lxiFw4GMGU1HxjXNe/8B9qmQ4WHOudQaq3T5IURFKMBcikwEF4tP5wF/7jMz2fJ/bjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789445806; c=relaxed/simple;
	bh=9RTDbsI4o/lbxcJqfP8H/3b+5HYfUqH+12sNfrYPGPI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HuPxTs1MLC+mW5vNzaRGqIxRrBZro9WhzeamDvqACLV3riSpQgXKwBByAC6dcXgkLWRc8c5oGE0oK/zytoYLNFZPTASeXp2hKs1HkzsnxDIPG0CQwHwWvuVVqPpjgVvHkGXMuQadZ36qgMA7YJa5UD2Wt/vq40VmYFKFjLCoFpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FPYd9Gyf; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FPYd9Gyf"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d37b5so17487555e9.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 14 Sep 2026 21:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789445803; x=1790050603; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H7m8J76LGIna+5jEbgNrQJloAyOcCRg92irjbXqHI5k=;
        b=FPYd9GyfPSQf7z7CqKFKkqliTWalCUGm0/v9ZVDJKMc0Q+1II3g9IxgpAJKkQXqF8h
         3/PDyihMZ13aPJIr0cYoCIAvmgaqpOKqQTuYXaNQF7IkLNlrQ+DmPv8H0NGx6fljJni4
         rATNM8eq8187Ze3KdpJCCkGqn+5Znf+ENRdE+PjrgPXv/ZLcgDsmyv5c2H28s1INwHHv
         D1g8AABcj7xU8hjo0GLwxnpDVaCnyLZ8v3ZVQ8OgHmg80Ux8vlvX6JWaoYFqdVS7iuHM
         +8ZXXsGbLlMw+ovE5dvhKCkba8ym4DHKcF3rf44mSnJ8fWsF6nmNy7dJq1ZXwD5pDY0k
         yAOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789445803; x=1790050603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H7m8J76LGIna+5jEbgNrQJloAyOcCRg92irjbXqHI5k=;
        b=TmefCogcgNprP2l8hSMtlice7Wi3VFt9FGFu9TGGqheK6oW1r+YuvqVC3dqvalVvUT
         V7ubTKg+6dhn7qxtOBn4vsh7nxC+Cqj8l3gQ1U2glGUxNp/HA7Z0ieElInaXVv12dAFH
         VvWVnDykKr6q5L8GeFLha8RrN4Ya4kasou1CHXe51FoTEytyACM/LzxMKmeuAqjNkRMj
         RqlfZNtmLdNIjpOnsP0W12wsDgjtOFGMT8WybSewmwZIiwKekcfQCExyORyCIODmQjBg
         8RnHxHe7TZhhYq/xstj0NRs4OduIaT7fMubH+ZFdZ7RT8g1+BIPOOYvWukE650hEE6my
         wOUA==
X-Gm-Message-State: AFuF++maOsFNau9GmZwn+2FMEpC2V6m5JBQ8vCgUQXXxqdRrRhv+XCj3
	NyNppGgF3Lg6yfSZTGn7jeI1tUViwpZgKa+cjnOhlmltzqdixDyj1inGQMd4J1F8noiP3ipCAK3
	yEdld5062zA==
X-Gm-Gg: AYBFou18omt0ptoyfNRVkICgIOIVQs4thKpTn1AjVjf6BgzbMSf1qdbqp6eUqvMcJz7
	Z4TgpFHJqM/ybozPUKYtW7i9kFYaGK5nj5dN/bdy9V9uM9B98Sk3iaDPHOiZQDuLSNIaqbZewK6
	80YNlsvLzUtlb/1lGYXcAJl0FSG5SruHMylKFl/mUeqrO83aoVBgDyM9HEgFHpgGPKHwVeUe/+v
	54LN5JLG2jwgSbrhGdG6+RgJG3PGHibQsG09DgeAaUwttZ7ZPdkh7kdd3tvjX+KywDwXJUxLG2i
	T2YgMkkypQYh7/2y3ifR9GnJwLOiPL7y8INNNtJhzsC0OOOBiaypDfhJb6UxsPfRnWrct6lF2P5
	dFPRAcQZGriYVKl6VKECfoN7gsvSlzuSTAT5ox56z+CdJk3rVfWaaRh3IP7eNYoXcAva9AXR/kQ
	yMsBdb/CCk8+r/vJwRrh0FoWR2Lg6ExD+4N7tTyBBtKrYc1YYZjz2YeK1s3c+2/5PSPxIySdU75
	G1A0o1P
X-Received: by 2002:a05:600c:4e45:b0:49e:6050:9fbe with SMTP id 5b1f17b1804b1-49e7a68cefdmr142356055e9.15.1789445802616;
        Mon, 14 Sep 2026 21:16:42 -0700 (PDT)
Received: from localhost.localdomain ([2605:52c0:2:27d1:8ca3:89ff:fe18:2252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14390c0be29sm974616c88.9.2026.09.14.21.16.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 21:16:41 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] ocfs2: update xattr count before moving bucket entries
Date: Tue, 15 Sep 2026 12:16:33 +0800
Message-ID: <20260915041633.93575-1-glass.su@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The xh_entries array is annotated with __counted_by_le(xh_count), so
FORTIFY uses xh_count to determine its bounds. When inserting an entry
into a bucket, ocfs2_xa_bucket_add_entry() shifts existing entries before
incrementing xh_count. The destination therefore extends one entry past
the bounds described by the old count.

With CONFIG_CC_HAS_COUNTED_BY and CONFIG_FORTIFY_SOURCE enabled,
ocfs2-test: single_run-WIP.sh -t reflink triggers the following failure while
adding an extended attribute:

[  150.156484] memmove: detected buffer overflow: 352 byte write of buffer size 336
[  150.156487] WARNING: lib/string_helpers.c:1036 at __fortify_report+0x3d/0x50, CPU#15: reflink_test/2336
[  150.160496] RIP: 0010:__fortify_report+0x40/0x50
[  150.164031] Call Trace:
[  150.164141]  <TASK>
[  150.164232]  __fortify_panic+0x9/0xb
[  150.164383]  ocfs2_xa_bucket_add_entry.cold+0x17/0x28 [ocfs2]
[  150.164661]  ocfs2_xa_set+0x8fb/0xf40 [ocfs2]

Increment xh_count before memmove() so the destination bounds include
the new entry. Keep the local count unchanged to calculate the insertion
position and move length from the original number of entries. The caller
has already checked that there is enough space for the new entry.

Fixes: 2f26f58df041b ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/xattr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 35bcbb0ff607b..49d82ea5a1271 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2076,12 +2076,17 @@ static void ocfs2_xa_bucket_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
 		}
 	}
 
+	/*
+	 * Increment xh_count before memmove() so __counted_by_le(xh_count)
+	 * includes the new entry in the destination bounds.
+	 */
+	le16_add_cpu(&xh->xh_count, 1);
+
 	if (low != count)
 		memmove(&xh->xh_entries[low + 1],
 			&xh->xh_entries[low],
 			((count - low) * sizeof(struct ocfs2_xattr_entry)));
 
-	le16_add_cpu(&xh->xh_count, 1);
 	loc->xl_entry = &xh->xh_entries[low];
 	memset(loc->xl_entry, 0, sizeof(struct ocfs2_xattr_entry));
 }
-- 
2.55.0

