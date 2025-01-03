Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269D328E8
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 13:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735909953; cv=none; b=qlbtevjxnA7b5PvH9QPTP4l/518F9ZJ5whK7kOXIXpnpdBVHDuXnQ+1VYez4kLmqJBIm6+gZZ87GzM4B0p2HpK5bp5VIsewZ/PLVd/0UOptj7aZ4P/6BOiCFPYdSwKedG2UaTsxpybjbnY3u8QWsf7DsSJ3pkIgDXsilbWM/Pfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735909953; c=relaxed/simple;
	bh=Y6aHpUaNKKdE6rqche/JFbjHqWlXcjjXCl0TW6wS1as=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=phbJpowo866HoCK1qGyhgExGpjqMdoiVPtWeCteMQVWrdYZ0USDyween5pzuiXyEKTCmyukI5Msgl6Pe1KEPXncX/dOj+6BVL7FJnJ2J6JO4JmOWS6UyDYZsclCufgB/YNcvCuWKdC1vLq+mcHTB6u1G0QHGcHTEWtBUHcDPucw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Aw2F8YT3; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aw2F8YT3"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-219f8263ae0so126007315ad.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 03 Jan 2025 05:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735909951; x=1736514751; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sMM3PdvqZ6pLL+cWu8YeRIsroFE3nD5UW9cl8O3WBCA=;
        b=Aw2F8YT3BTlreM8+5jDpq1YBuxkaRcaOkC5N1fPdUj0r/G9BGjDTnizdzLIZcGeU5A
         Yh/k3wrFiciAoFKbcve0U5kPB2yf4fw8GnluVTia6o/x/+tuxXj9dSZrWB8u0vqCTcFx
         DLj6CMiHfdcyiqM1i2ESdUARklv/TbGhY0SXKTVcZkmfERC7UY7FiwlhpesM7SH9Uiz0
         /jg1m/0gLaClLKXEfcw1FzDCfwDEjOjeKw1RAcIIvGg9+GTcq1JrtyX06DxtZw30jHDf
         srngDftsJMJT4HNEj55qJ+oeDiFoIJf8Qtek+vUpU9cE8G37MdTVZX3li8LvGQYFZltH
         lUsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735909951; x=1736514751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sMM3PdvqZ6pLL+cWu8YeRIsroFE3nD5UW9cl8O3WBCA=;
        b=OP6l6gqRkw7uZf8h42M88GvHwT67bwC/k4SP9nFYeV1+VxQJnWWguj1//lLhHB8C2D
         E1fVzGuKJrixGZj5SZTPb2TIN6LTTHvE9+cvV+kxMaIKgY8Wfgav5mqA4+AEdvvppwmh
         ZArfDVIta+P+ML9uniIjGVJNY/TK+tSQBg8z+0qKptJlLoUsF5hbJJkNuF3P/SM+O4Lc
         iJcLipJoAVDpsXyfvlBVdH3aIuLvbZI7lWjP1/Nfn8NYqOG6FpixLU8fKBJ8nhSoPT5W
         J7MHFlBMyseDM8VVrByy2KKtWMhtNwSqtrRaBlLzs8WKwdbpmRBGW+yGbxGDlx767iB2
         d0mg==
X-Gm-Message-State: AOJu0YxP8ZgMyqCaQHLw76dz8ClKi6hk2kutHnP60fBX1JlxOc9XyHUN
	6tzu3ow/JEk8ks0lGBlappoSmSHGAUaxWlcanAJekOEXWaWRXlEpbYPHGvihOcdr0w==
X-Gm-Gg: ASbGncuPadgjJ6+LmRsWUGotEvaJmMj289btB5SD0iIsjbguTzJNJkSK9HI8XkfBwlR
	OqDjDXQ7KdIuxZf5g2sYETZU2STVF965GYXqyi7dVu88LSvXLQiN12eeDvPOfgdIogWDUcTl8xh
	nw+SjnigvRkFMBAjFXMDhCkNWCLyVOiB0kQLEutKPDVQ6MTYJQY7ofNkyv/jxRO+0HEXsoQ7rd2
	Djsp6HyfM7RWR8ah0cfKj3tmwfOW4qBlaxZyEHYsQD7i5jZTfU4O8FD2xiJf3yFdw2jJO2q2kD1
	TQEOGqn+JeFmGA==
X-Google-Smtp-Source: AGHT+IG3O2BaM51LGvW8bZi9ruBBZKrl6z1toKrPM6k9H/UWHU2Cp1ns2KNFRj01JEdaY+uIhLHe4Q==
X-Received: by 2002:a05:6a21:6da2:b0:1db:de38:294b with SMTP id adf61e73a8af0-1e5e0819216mr84372069637.38.1735909950810;
        Fri, 03 Jan 2025 05:12:30 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b31eeff3sm20326647a12.33.2025.01.03.05.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 05:12:30 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Subject: [PATCH v4 1/2] ocfs2: Check el->l_next_free_rec in ocfs2_get_clusters_nocache
Date: Fri,  3 Jan 2025 21:12:25 +0800
Message-Id: <20250103131226.1262042-1-sunjunchao2870@gmail.com>
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
 fs/ocfs2/extent_map.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f7672472fa82..a326c08d9145 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -435,6 +435,17 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 		}
 	}
 
+	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+		ocfs2_error(inode->i_sb,
+			    "Inode %lu has bad extent next_free_rec %u count %u in block %llu\n",
+			    inode->i_ino,
+			    le16_to_cpu(el->l_next_free_rec),
+			    le16_to_cpu(el->l_count),
+			    (unsigned long long)eb_bh->b_blocknr);
+		ret = -EROFS;
+		goto out;
+	}
+
 	i = ocfs2_search_extent_list(el, v_cluster);
 	if (i == -1) {
 		/*
-- 
2.39.5

