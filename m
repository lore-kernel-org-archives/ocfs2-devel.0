Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7704A18
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jan 2025 12:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735821950; cv=none; b=eHGdlxpz1Ec94igMuvHseHAIYuTpbaEPWJvl286xiDK2OVKIAxX7Fl2JbzEh0WeesFSVs5YWRvjUI9Owtrx3KsKMKMuH5NSpa6SmcG5hlvfthcjDrTXTXCtDZlVub5n3g67XnHn5mkg/wVcfNbZtmZRgZkvHTkmhu3/wYfdYiCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735821950; c=relaxed/simple;
	bh=pVjlt3JHf8b/drKpTqCxbWC3H47UktMzF71Cw1EvA2o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ADpOyAO/UbJ+JC9EgxSVzDaDhijAaOsj5l8VqMmnKt9UcSB0h8GPeTCL1XkkTdVeHrGBL9X7W5UW1HnP3+Rz4F6vqSCEbgCPeAl86bNP+m1EGMSH9uD9KIFJfHXa3PtnaG7iakZSL2oJ1wsBTR5Lto9enLkW4MN2sN8LQbcCbgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=leS9Gbxg; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="leS9Gbxg"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-216426b0865so150328955ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 04:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735821947; x=1736426747; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xqK23JGhdkMF9qPxExfbgEqP6XodTjKcge8WwFLrcJo=;
        b=leS9GbxglIcO3jx/guBGZ8Rfi1IQed/YEwf8jCyV/ZXJZqK7rXkaHbLkkTXqphs9lU
         a5bhTrYrglmFhfSu3Yqm8P8Ze7oqUELsGMmFrU8/FSBchw/ptAr5gE54LPbVXBXZ+Emv
         tUffC6PU42t7bZ0rTmdU+akvlwRqaq0sqZTsomIKHJ6XUrq6eQuhnAS97Vk5ta1kQpCm
         AGFaf+2t7QOXs0FWcVhRshy/VNv0kOa9XD6rIEQF/Q0Yw6TOe5wx7OQElk/K/7E7QM/1
         +Jrml5weiWRzMxnNaZd2xQFq5krdMXKkE5ZKdH9SNuMzsxGP12JSOAae4qksaZeEQQn8
         Yeqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735821947; x=1736426747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xqK23JGhdkMF9qPxExfbgEqP6XodTjKcge8WwFLrcJo=;
        b=ArOZlsh89peOeOG7et9homfwJZPCKscTFk39WjVEGrvZtvGB8KbwGhkuAxtdxIvYui
         MXFfAF/grnYz/IlmJxPmO29frFCcZwPSr1dFk0OSHMqG/b1NLHJEEKu0WbUeChW1xTuj
         EUAL/gPYngVblqHzKIaBpdtkAeBi5xF+lTMa2HFD+U4ovA8iW5LUackoyL6HY4dz43cO
         FcYO/2wefiJX2EGadjHwOvT/vEF86ASWD12BUPnLDMKA6D9RVedQU2iUsjwU1EW1IrEG
         UPHJYe40RTep3xRKYzUuDCcHX2sGYZXXUq5U9Huon5eA9pOqG1IyzsF7NOUo3JeJnX7v
         C90Q==
X-Gm-Message-State: AOJu0YzAXzYmNIdfe9oKABFxKHHNFjawRKydPRD9YhouQpNkNFF+z8Fo
	WiH8xwvQxaWHH7LdnDIz8uxkCOynxw4FIfu4/otaDEXI4iJsRk29OKT31C1gOvk=
X-Gm-Gg: ASbGncs2bzEKpRlqKxQDrfs1y+hWEXCBh0uqsgoF51u4QupbLSrgvxC/daPtWO/dmSn
	8jk8g0oFq2P27KRTiMA3hQdx0cQOmtPPdiILb8c/u0QFZtfBfy3svtNIpkIjtZHbd8iPVJMB54y
	rmXoC7rthIuoXYdflE47U4P7noOaa6vDFmwHHTTbxCraGkgDf4/DLqROFewDprVUDZgKmjO43cd
	gW2A/pb5bupWFwV/5LjmVihUc2YxTmpkIjoNUtJS+tT+X7g6isB5jN7oIs+mPT2dR+TsMi7uBkl
	JIepxBWqaYS2AQ==
X-Google-Smtp-Source: AGHT+IFOP7oeSeiY27oGCai4Yl7QRsjy72wcvtN/ZWNRpRZ63ELGCScYehN2IGeJpknxqSY2WlSekA==
X-Received: by 2002:a17:903:41c3:b0:216:2e6d:baac with SMTP id d9443c01a7336-219e6ebaf3emr624272415ad.29.1735821945356;
        Thu, 02 Jan 2025 04:45:45 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f4476c04a5sm26369060a91.0.2025.01.02.04.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 04:45:44 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Subject: [PATCH 1/2] ocfs2: Add a sanity check for corrupted file system.
Date: Thu,  2 Jan 2025 20:45:38 +0800
Message-Id: <20250102124539.711325-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

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
 fs/ocfs2/extent_map.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f7672472fa82..83d3343b3e3c 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -435,6 +435,15 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 		}
 	}
 
+	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+		ret = ocfs2_error(inode->i_sb, "Invalid dinode #%llu: next_free_rec is %u, count is %u\n",
+				  (unsigned long long)di_bh->b_blocknr,
+				  le16_to_cpu(di->id2.i_list.l_next_free_rec),
+				  le16_to_cpu(di->id2.i_list.l_count));
+
+		goto out;
+	}
+
 	i = ocfs2_search_extent_list(el, v_cluster);
 	if (i == -1) {
 		/*
-- 
2.39.5

