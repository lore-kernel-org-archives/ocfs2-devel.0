Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE6938F91
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jan 2025 03:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735790027; cv=none; b=UTKrrB9CBp6R/9gm6WGlVadSw+Tm3T32DL6E08UePadZIuIBOx0A7uYhNeugAnEPWoVe+1dDHwsBmmMWeM/B8sH6bcV8CTG2qUFF/d3ElYVm8GsqtrpF4ayqZprUBsRaCy24gek0/3r9X1RStK8HUEip5Qu+QtmHt2raiNtgIJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735790027; c=relaxed/simple;
	bh=+gLoUi/xji7yyskMfGOL0U61JGMXgKaElbAmlN3MjXs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Tbuew29Qs+ESh8r2XOQL17kulPaabudkhh45YNaCMqo5oGCkREhhUpdYQXJAeOOJ4UjZGmwTOhkax1QH3gmiMTnoL88EVa5j8584Q0zuSnMNywGVkDNn0pLuX2BUEvzdaZofpo6TsodhWFrkL1mJBy6WWsIJiOddvRoBZws7GBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J4IWtJ7p; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4IWtJ7p"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-216401de828so139756875ad.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Jan 2025 19:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735790024; x=1736394824; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IaONGo+R6aXL6TBZE4poKKiIN/NuJaEYQsxBIydnnhg=;
        b=J4IWtJ7px2djg3wOscfah6XZWjH/8XBQsG4ENdOO6L1Gm6cSmV+9y7cQ84K74U2WkP
         m7biYTksoZAja28q/y+ojLQFiEIrBGwBeMDjLWUVQ7TgCscXtuhGd5/PnwgYPwkH08uk
         JFIBMtjcFXN17BS4M8UMy21GIb/6S4gCjRWB+xuFNO8ybJjHN6dCRzBKiFwMtI+G36GS
         9i7o0142LO90QDxcjF5XxRsH/T4E5op5qYPgHdw60kmEx5hLAYYWCVVfY1weKUV/X6w4
         UNRtY65prkhRdLCcVC20pc/UDXRk2HOe2cqGMiUQCBFsBJLRx5qKMedzXz/zW4U4eCIA
         Df0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735790024; x=1736394824;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IaONGo+R6aXL6TBZE4poKKiIN/NuJaEYQsxBIydnnhg=;
        b=ti+fl5X+1DCLJpC3Ws9nvOsXnx7Lkg9flsve7LgifBy/AvpbGk/jmTz80qaTVbA+eJ
         gtDPxkgbUXGsiAMezjRRQg1witWKcJZthJo6KMq0SsjV/9ui2wDV0yuhvtZ/nmaBOVZi
         Jad3+qfUXC5WnbfoF1xEKM8ODxiDVFHraC8mIcmCcag6L+hil0zpiYawb118VtdkIVah
         n8yY0Rfha3C8wPUJIavUY3eerlKtw9sfkjl+7txDDd/KdtpAMv58tDA89BXeuba86pIo
         OdokG3EDVsdFhPwisQdjwyjnZ7JQUOHkVFy/5MpbMMX1lDcU1MV7N3hzFFC9g3ZBPulc
         9A1w==
X-Gm-Message-State: AOJu0YwqGOyjWY982fqZd0MI1WDDj5/puVsuXj3LahnwHb67DYanIQSF
	pf8FlEF+U0u2qZQPoeEQnOKe9OpQSKBbhV7kS1+prVuHgyS8Sv0JEreDiM6aDUA=
X-Gm-Gg: ASbGncs3iLxRiYNx8P3tNOky3FjI6ktAsd07BWz3i+Q0qcCglUEc13PCb2k3OV2z0tS
	uK1/OXn71UrXy32OoUXLngkQxDMiO1SEuadQzpn4X+b7BiWAgmzZqsTBQjn6K1ET8nPOJLeYvXF
	IyIIpS39f/1Ro0l+/0HuF7mugumoRjlDyr3kBxwwMs+ZBopXV9arNL0cA6gnyX2v/mjWFaToo7T
	LkTdNT34SQi8tZANFE5eX32jPCFmFGOk2zBXkNRhxTC/0Fu8GFp4cRaP/rHcNpWIsMy/KxpEuLd
	xs0YoABfJSqyAw==
X-Google-Smtp-Source: AGHT+IHvsFZ7POkwrTnv04ReK2uu8bQhSI0MA5O6CkXONiYUno9XYhr/zuTzgoD/diow/Ip4LxGNaw==
X-Received: by 2002:a17:902:d481:b0:218:a4ea:a786 with SMTP id d9443c01a7336-219e6f28491mr631516115ad.53.1735790024138;
        Wed, 01 Jan 2025 19:53:44 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc962cadsm217657075ad.15.2025.01.01.19.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2025 19:53:43 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Subject: [PATCH 1/2] ocfs2: Add a sanity check for corrupted file system.
Date: Thu,  2 Jan 2025 11:53:20 +0800
Message-Id: <20250102035321.391540-1-sunjunchao2870@gmail.com>
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
 fs/ocfs2/extent_map.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f7672472fa82..7fdbecb9c031 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -414,6 +414,16 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 	el = &di->id2.i_list;
 	tree_height = le16_to_cpu(el->l_tree_depth);
 
+	if (le16_to_cpu(di->id2.i_list.l_next_free_rec) >
+	    le16_to_cpu(di->id2.i_list.l_count)) {
+		ret = ocfs2_error(inode->i_sb, "Invalid dinode #%llu: next_free_rec is %u, count is %u\n",
+				  (unsigned long long)di_bh->b_blocknr,
+				  le16_to_cpu(di->id2.i_list.l_next_free_rec),
+				  le16_to_cpu(di->id2.i_list.l_count));
+
+		return ret;
+	}
+
 	if (tree_height > 0) {
 		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, v_cluster,
 				      &eb_bh);
-- 
2.39.5

