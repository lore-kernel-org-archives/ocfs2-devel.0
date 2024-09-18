Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EE91C9EAD
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 17:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726680066; cv=none; b=p7diODJTEmwNngFbgziHM+1IpZC0hxz8U8R3R+7o1U29VSOgJm0T0DWGq5bVETo/BywpEXaGflzH0c5RjSfY8hFra7iJyxiTeLfknNlSvdhUyEwBeHGUTfWYPvt9VGPy8AseBZf7ekk9IYmqq1r23Kx9e37TWTWHejxqQIymVaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726680066; c=relaxed/simple;
	bh=wdJOrGs35uZAgenFPyRtZVhdFWiwxgcmCBPZMD7rp68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpS/5HpTD/5282WBn6VLZ81OHK8q0umHlO2ZZPSMzf5LTQfAOc8w3WCRxLkihfZnMMW9cq3NG+8eNDDWVkr4nDS0aFTV3ZRMDLTkA2jieUAYb2LkUzY6sP41iE7UJ8u3mhRwFzzKabypcSTYWQdg/74RIjIb/hHF6jx+rDS4ZgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cjc+Om3+; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cjc+Om3+"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7db0fb03df5so5234459a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 10:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726680064; x=1727284864; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qrVPgtc9pr0MYXVJUam6GnYq72ewYaQxAFUiuA/F6Y=;
        b=Cjc+Om3+z4avH15BIsFRgU2nDbCltWPYHKhMuI8PaXNVfkoDsuJIkF/CoUA51NVeOG
         wsES3djw/1u2U1ubp7oij+rJrvB7RVJhrbBKqjRm8st+Xd/u4vWB1CyFAVhMfDd5Q83a
         N0ds1YBRIHmbKqIu0r7CZpS2g+YIzAfDb9/ZeJx3yvAw3cw9fqM09geXo7i5VHDk108P
         4l0hdrKzMJBrvV8YLa8RffnON/fpWXvnACJRA/HRu5r5pHLk8kejuftyCz4ZhFO/aULk
         VGZ3JQ+s86RYgkQxO268TQ0ovbAP583JeKAXhPlNTX52ywR/zrZnjxW4fc3MlfC56SJY
         s17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726680064; x=1727284864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7qrVPgtc9pr0MYXVJUam6GnYq72ewYaQxAFUiuA/F6Y=;
        b=s7fM3icUDKFLu0VLDepfLNQA6kejrp0WX8jbOvlISo4nH6obvzXxftWZ2cJ2HEpAdZ
         xtQer2eIYaINZUP3+80GIT0tgiw8E6sGck6KXm/2WPil1S67Dam72a6EtA304vHLKFCK
         srOFnS0icFewii2ZXCRnpgnVhR9E1LB1IUXBImt62Gpxr6fyvqgfINuPNGd8QQH/kqdL
         hW4IxqqLYAmHbG53JqG8mAnwbGJ47+FhXduT7vJQkdFoD4b/E/NlqwMO6anGuxHTeYt8
         22dY5aiOoD0MvMtgZlll6HIV2xXGtACNUIP/287baOkC8wLMWILGWXYTCT/7ok6MXruq
         xuOg==
X-Gm-Message-State: AOJu0YxxuEhMvoMCwfMQebZDPdwmOG6XezQsNcwV9XcNHGq6XyEmB7Nd
	tpGaoiE6uHAOnzrVGR2kaJGzMc9Rp9FxDI0oqo8VqEVrd+27OGZCnVzBsTM3
X-Google-Smtp-Source: AGHT+IF04UxO5twV68LGB/UhP/cNf8F9nCgomakgymG/9B3GMBVg5E8jctBNna5xDFm6dp5UHVbAtw==
X-Received: by 2002:a05:6a21:4d8a:b0:1cf:2218:1be6 with SMTP id adf61e73a8af0-1cf764b02aemr34176792637.50.1726680063771;
        Wed, 18 Sep 2024 10:21:03 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-71944b7aeafsm7186476b3a.99.2024.09.18.10.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 10:21:03 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com
Subject: [PATCH 2/2] osfs2: Fix kernel BUG in ocfs2_write_cluster
Date: Wed, 18 Sep 2024 17:20:26 +0000
Message-ID: <20240918172026.2532-3-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240918172026.2532-1-pvmohammedanees2003@gmail.com>
References: <20240918172026.2532-1-pvmohammedanees2003@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot has found a kernel BUG in ocfs2_write_cluster_by_desc [1].

The issue arises because ocfs2_insert_extent receives start_blk
as 0, which incorrectly maps to a physical address of 0. This
occurs when block is 0 after the call to ocfs2_clusters_to_blocks
which is invoked inside the ocfs2_add_clusters_in_btree. The block
value is then passed to ocfs2_insert_extent, leading to the problem.

[1] https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6

Reported-and-tested-by: syzbot+18a87160c7d64ba2e2f6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=18a87160c7d64ba2e2f6
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
---
 fs/ocfs2/alloc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 395e23920..926ffeed8 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4843,6 +4843,13 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 	}
 
 	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
+	if (block == 0) {
+		mlog(ML_ERROR, "Conversion resulted in zero block number");
+		status = -EIO;
+		need_free = 1;
+		goto bail;
+	}
+
 	trace_ocfs2_add_clusters_in_btree(
 	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
 	     bit_off, num_bits);
-- 
2.46.0

