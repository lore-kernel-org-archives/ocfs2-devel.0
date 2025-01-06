Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D5F15D5C5
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 02:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736130881; cv=none; b=UvOW9y/LCMuNmJ3W6AXtswhmQ2qI+AV5GdJ1pD2uGe7++DaoUShJLzivsOxeG/oymXN6d5fUK3B1o/PFZaiN742CVniK07b9B2yDIqOYVNgmAtjWpCc9FMh4863981Yx4r6iq3MdUv9am7Hi2Oa2AYsE9F1qXvCfIFrCRXGuS78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736130881; c=relaxed/simple;
	bh=Ebjy4n27zt0jXESLCH0xyhVWddl8GoCb+4Hh2uF0LdY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=smoZIKj65U2tpalPLLWwtRHJ3PuUNEO2wkGXogMtOT7hChoOiE4oDEOfKNFtYvBUoFsOyKEQgdKm2zAkjKuU1IDtR6sZLGqN+wkPM/k/9wtvPz2lzQrp6IcH/86PdwZ+gwSyibEDxjErdH+bBMckCU/nvVHVDcj8zHrPodSjHhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FAKPyDhz; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FAKPyDhz"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2162c0f6a39so204892645ad.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 05 Jan 2025 18:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736130878; x=1736735678; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RpGXoimYJwjlsToFU6xkdSbfIZK/gtWQDt+L2HwocOg=;
        b=FAKPyDhzRH1c13MnAxdGn3FolzuKB64idllavwR+fXGGOWj6InjRDlq8GhFEsGuLUI
         myrkyR8cV1Wk5lH0f+o7S04HYImGD+nmZN4+f2G1Kg+VUuOVcrM2I6UXr6SLzotyRo7L
         TUoAU0hTqLph6TOIbpfIWIXhActMlTS2p0LPHBNfk9fVRxNtbxMkZ3S7zD7d8SrCWdJE
         R6TBX2Lf+H5khsASA0NpLq6v0G/PTN7uZvCTSsSK5W4N43urJT9KqX2jeR4ar7x8EhHE
         mY5lKcVhAri8Egg7DZ3qca2ECt5teAHZfAnL0fmTUmQK8QbvxGZfujvKW/+PkgSYHyKj
         3twg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736130878; x=1736735678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RpGXoimYJwjlsToFU6xkdSbfIZK/gtWQDt+L2HwocOg=;
        b=RHd1YDeHpeYjPbsToB8/EU6HIWwmjUwJKyEt5go/g5G94gN7DjjR0eZKKOHVIIido5
         2Iyd4llzt/X268RNA9QgSHsRQ94tfsgf+Ha7FZpHydLC+Q+eqclUix2ZbIuOhy+P2lD0
         Dp4vq7bFodrF4h7pxZBbSFxjDTY6Qs+5/ZSsn8y9HEmU/APg4xZpxxQgdwST6PfMqIBt
         Vn0WNLEIe1/tCc+TWQYrx7dZuFZWrr6mOI+GoXzm7/0rEiOxJnibfAA5sc96kfnkOiy8
         D1CeZ85Agun0Ck0KPATLkdE16MCIAa5e1yq+WTE7zrPJucxR0wgv3mCCcizmjBEDdNw4
         iCYg==
X-Gm-Message-State: AOJu0YzQQd+hDcCBRrwP9Y3EBrwLkmqEMEyi93PTS45TJ/M/hmslsQhj
	im7/HcqFlFunK5C2OdcBBHarD9Pt+NUw3/4Lo5uf+lsnnG2G8nTpPPmWjIHYv6o=
X-Gm-Gg: ASbGnctHXwvtJSY83JTFif9Y84IlD3F/9Ga7Fhy29iUyAvYuAdnvQaZQmQSuHuQHaMX
	C05ejnEofdRJ35OgFSIvpgck0ad5kCwZlNrv0utCFz/+kY60SGMD63se9h3h6ls3FbjvVFhwv7l
	Kp4LM1nYipL6su6MBlJha6sXHGfsoXCx9kFesfUucv6svH35wYmB0wzCv12HY1TfnAAJToTNBuT
	L0ePDDnZr3jQVKugUGGCIM0DyVUW3VRd3Yq2nlfBz0zHsNZ7c0X4d+H9SPPn6eobRhL1ogNOebW
	yjy+SnpNzl2Vdg==
X-Google-Smtp-Source: AGHT+IEVMD0AJMZAOi9VPd2r5LuGE3v3XWEVti+vULqS6qGMa7sgtSNlh24RtotqHvZ+BChQYgWMtw==
X-Received: by 2002:a05:6a21:78aa:b0:1e4:745c:4965 with SMTP id adf61e73a8af0-1e5e1e26dc3mr84227312637.8.1736130877683;
        Sun, 05 Jan 2025 18:34:37 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad84ee4csm30158978b3a.82.2025.01.05.18.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 18:34:37 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Subject: [PATCH v5 1/2] ocfs2: Check el->l_next_free_rec in ocfs2_get_clusters_nocache
Date: Mon,  6 Jan 2025 10:34:31 +0800
Message-Id: <20250106023432.1320904-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently syzbot reported a use-after-free issue[1].

The root cause of the problem is that the journal
inode recorded in this file system image is corrupted.
The value of "di->id2.i_list.l_next_free_rec" is 8193,
which is greater than the value of "di->id2.i_list.l_count" (19).

To solve this problem, an additional check should be added
within ocfs2_get_clusters_nocache(). If the check fails, an error will
be returned and the file system will be set to read-only.

[1]: https://lore.kernel.org/all/67577778.050a0220.a30f1.01bc.GAE@google.com/T/

Reported-and-tested-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2313dda4dc4885c93578
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/ocfs2/extent_map.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f7672472fa82..930150ed5db1 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -435,6 +435,16 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 		}
 	}
 
+	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+		ocfs2_error(inode->i_sb,
+			    "Inode %lu has an invalid extent (next_free_rec %u, count %u)\n",
+			    inode->i_ino,
+			    le16_to_cpu(el->l_next_free_rec),
+			    le16_to_cpu(el->l_count));
+		ret = -EROFS;
+		goto out;
+	}
+
 	i = ocfs2_search_extent_list(el, v_cluster);
 	if (i == -1) {
 		/*
-- 
2.39.5

