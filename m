Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5637714F9CC
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 03:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735874924; cv=none; b=mSJlJQnLyDm0hxyqJr3BKDbuLi5NwloP3IR5/dRTJfpE9WQDGYFMhQtTe0s01qQFS7sPI+kFVx7TEkntUvrsWgdAdhgHTzjRsLf0IlD7B6i1+wG3EGV4xKVwHpnqgcHqrhiPNvkUY3tssQV6+cuUG+KBzxzfj49oB987fC/a5qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735874924; c=relaxed/simple;
	bh=pVjlt3JHf8b/drKpTqCxbWC3H47UktMzF71Cw1EvA2o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CvuIfUBr1AL6806s31LSgwxEeAoXsFRYe3PzRY/Ndi2ViS+RnbtQC3q9NxefG4KJL8jini5lrFCkfjnX3SmfAiXR+07VwK5RQg1P4bcGtOZ+Ivc5jv3192xI0V7tJ57kJ+quT6jItum6Gz7k3mBdnkpACcxwyObYe59dCvH479k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=loJc0VOk; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="loJc0VOk"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2166022c5caso144484635ad.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 19:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735874922; x=1736479722; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xqK23JGhdkMF9qPxExfbgEqP6XodTjKcge8WwFLrcJo=;
        b=loJc0VOkd4R65x+O9eLWil7SHqx2K+laFMFNKKNNQDTBJL42vrwWjS6wkFw3rvjOgQ
         6+bU9E9/RYSnajCQVy0LP5vvXIHAY8I+E6IoFvz1dOL7IvDs0DiG/DHJf2IvSfMBgjVl
         IIQp7ArlhkuZPnG5T3nxa6gqUiide+v7MNzQZOw1AiWZEnYC9rMqowHaZANTn66hCqJ5
         EVa2bwLli8aqnHTRPh/xPhX/KceZg0TzuWEnVJpipmRWm3QNztFGQVA5O2A7rQgQdBLI
         8E02/h9/9TxRMe2tJgSbBXZeSJ7zzLtnG8BPVpZyBZHV45U28vrHZGDAkgCo8qE89xVw
         r2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735874922; x=1736479722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xqK23JGhdkMF9qPxExfbgEqP6XodTjKcge8WwFLrcJo=;
        b=YEDKpJ/fSnkVvvrsMsVtsRuDrJ0qCo5RkJG4YKq1OP6twEsNHOCe/LF95RfIE8iqzr
         wN2X9Nxr3+9lKI886kDBgGTBJyiQ30OrnfpThQF2BLEgzb3I8UTmNWB1yy0KmH4qh4z2
         bImOq1/9rapHzXUtoPY3+BbpZR7oEUUZzaGD58ojOVUqrDxjstu/igtDPCMyU3eJoBlQ
         BVsSLrnyfY9OYuWl2cbKawlz+RasSCpEWEmBTy4BotcvloaNd0in+QNoscDlP/IbUBzl
         JQ8A7FHlF8Sh64KtIEsPEAuO+l6MEvOOfXf126xVgBjwD6YZK000cPd7yAHVEq0ILCXh
         upyA==
X-Gm-Message-State: AOJu0YxXdelr0OkIwtx8CafVD0/M6HExf4KqsZbTA3+vuDNd45utUuZI
	wYQMZruSu40sA5I1mjgKcCBN1fBEH28qrRh5Q2OojRK+UVIgTPZyRZ0Ox3fEHtGKtA==
X-Gm-Gg: ASbGncteBy5dWYF73LyG0wPeln4H1yuSu/yd8wQPmYDjnRcJ286wnq029QDC8c+6QnA
	wOzkMWDwtRtlnAIhUIwy/XJcYN2nW2XZPbqwbgOWB7rNJ7vbNyDZ+thvqvAW2TNJK9zzihy3ten
	fWwGvIRrMjnQnlr9DzCtjbW9R0MPF/a3eL0KiIs7NIzNDZhog5pboCLOVCBHprIsb7j8ikrxVoS
	gNOH1Rt6kzuFFEFX7UrVSyFBfFzI0Z5EO8wTU0V/ftHcFYpjWEXz0dckq7RQjTLuPUebgyMqXCf
	l2KCoygY297LIQ==
X-Google-Smtp-Source: AGHT+IGI3Bdv70enk0g9lQ+BTkVJdEnDekiR138NVq+mSYKQm/0+UDBULg35RxpFG9xg9CfJxJ+nGQ==
X-Received: by 2002:a05:6300:6681:b0:1e0:c6c0:1e1f with SMTP id adf61e73a8af0-1e5e07f8a98mr67526365637.36.1735874921601;
        Thu, 02 Jan 2025 19:28:41 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842e36caf84sm23040907a12.74.2025.01.02.19.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 19:28:41 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Subject: [PATCH v2 1/2] ocfs2: Check el->l_next_free_rec in ocfs2_get_clusters_nocache
Date: Fri,  3 Jan 2025 11:28:36 +0800
Message-Id: <20250103032837.815858-1-sunjunchao2870@gmail.com>
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

