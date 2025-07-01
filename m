Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3FF13AD26
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Jul 2025 02:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751337461; cv=none; b=PemY8D4K0yZd9DazO2wGkFAfeiSZA8GeMPMINdQDiO3ii9Mz9jeymqrdpTzL8raBo2cQit+2Jy4cWGJ5RXw2z+YTcy5o++zC0vijWHhZ/dHEkDMCwunMWaTDbpLNxc/tq258E8Bpfsz2ftxJMp5duZ5hujICcLMHthzIeiO6oWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751337461; c=relaxed/simple;
	bh=zv8H/ueXxWC5DLY5dbZxw8M8pOFqP7G7c0K9+DxAf18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IH7BhRpYV8Bq5+ctqn52cup4Ba+sm86uRQg8PbxwntEyffY01a219orIKNeQfXTUCqIfzq85bXrmADBEeNHMvEfJ/XMF4xkL2reUZpoi0LqQwd+Ma0DXNhZgtdx4Wq6xLbvRZ+RSGV4582cyU1DR2T42BHMx2DUrNaO2G6a0djo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SK7jYmwb; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SK7jYmwb"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-236377f00easo32319745ad.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 19:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751337459; x=1751942259; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HUEbK//prruDZHN241dDRLIKIkZ6TnXwENFQ7i5Q1V0=;
        b=SK7jYmwbope6il8FccOlcHn01oZ4SaheWuwBFluMzSmv6HRBwn4iJH3bE6JKIvuDXu
         84BrHRu2ODnNNCv4wHFi0sByIu/Dwn+qgVrISLSflTmdszdnh0SjlM7L8ctLiz8TOKLc
         NXSS3hBYgAAfTMkaK9zlE/hQegZZ4VBTfTdnUJq95ETrEbKZ9Ie1woYcZEkYnJTMVbyB
         QGU0Nuk0fxIMszWc+fhrwIlQTqI2T7x34X+DTsxZUXZTgFSfnNNgEwoGWuUJLDM27OPa
         ZcVDHU94MVMyabMWNtvFQn5ScHjRci+lvWUMIfxlchpjTfq+A6Ufobxwx4EKZKQh6yJ3
         gxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751337459; x=1751942259;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HUEbK//prruDZHN241dDRLIKIkZ6TnXwENFQ7i5Q1V0=;
        b=E2czo15fUtEw2rXABazySkSDWQk2wlZ7kZrHEpug2pI/sF5qchjrrK48EcRXPIrvfc
         ShFxK7PxxYfSWsawKD3N32bQW47Knbm7PQOf1z3pAAeLaOF3QgmjrS+c1pEfFmj1mKz5
         gokjr+Y2T1vwcsHFPBREu+vHM7hYf3hky+LFm4qtN7Qvt9LOUY/rRfhQB1P3v2JbRR3p
         fHISAuPx4cFHVl5Boraimj5pw0O6CRXQVgsZyBGpr7xVn9mwqFjENcGiwd4wVJp8viH+
         IGfSUTJj+ahtDTq5Y+eWmG/C8CFOxKYe/TihSbFlQ/aOmQwhrt3BvQ1x4sxyCbMQFDll
         bp3A==
X-Forwarded-Encrypted: i=1; AJvYcCU8E/DM5HM+3aXKIIQ2awXI6O53YpIgerUyWWC9OcqsRXgRZO55upLY3xIW0n21i+7zQ/Q6PfIj9gehcQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwRnnp7zxothmXp6DjNV6rTxYpuxsgYXWDUTBq36sgDq+iXTWor
	R42Io/WhNppPXqFucg4AZkZK/s6Ax8S9rBe7LkUP8FTaLpnOZlLwaejj
X-Gm-Gg: ASbGncuuj54G9LEJ9xl2y0zdnopYWwj8DmmVLmaYrmZ11usy55Pli1w8eQODWNMnQfA
	v0MABl8dEj6PhzsiFx2+1oMSL3q8Fm6XCb3cHigIMN2Q0tFcyoGIvefONktrND4IrHzhWLngn3S
	LLQEr+jOJ23VuRSE1zJ411gAb8WLzpW0f/4UPxF65FbzlI0xq841zAYlB+sOZ/vG1NRHzFR/9G8
	g0HhZbt/spls5LiZ9MuzOSwkHlAA6gWwk7ymkl4A+4poec/bYjkQ1hM/0s/ZxGAbFsIrJWlfY2O
	pmGd+zPJtOPSiRTiU0VcBrI9BUoupKVCdXN7jtjDpvvQ642gQ1UhkaijvBD7m8snXc5QBXNdmed
	+z/vU6OgEIBaxvAzv4AGi125J9swowFRykmfltyocf6arnd6Q
X-Google-Smtp-Source: AGHT+IHyuRcYmYE04g95LBJExejQ8LrpV+fanzEQ2/mJIcpOF7EtQio0DMLDMxrMqUaUoP91ln/zVg==
X-Received: by 2002:a17:903:1988:b0:234:bef7:e227 with SMTP id d9443c01a7336-23ac3dec2ccmr188501485ad.18.1751337459451;
        Mon, 30 Jun 2025 19:37:39 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55.hsd1.ca.comcast.net ([2601:646:a000:5fc0:185e:4baa:85df:637])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31db000sm9017202a12.65.2025.06.30.19.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 19:37:39 -0700 (PDT)
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Ivan Pravdin <ipravdin.official@gmail.com>,
	syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: Avoid NULL pointer dereference in dx_dir_lookup_rec()
Date: Mon, 30 Jun 2025 22:37:17 -0400
Message-ID: <20250701023717.543972-1-ipravdin.official@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
error message that unconditionally dereferences the 'rec' pointer.
However, if 'rec' is NULL, this leads to a NULL pointer dereference and
a kernel panic.

Add an explicit check for a NULL 'rec' and use an alternate error
message in that case to avoid unsafe access.

Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67cd7e29.050a0220.e1a89.0007.GAE@google.com/
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
---
v1 -> v2: Changed 'Closes:' tag to point to the correct bug report.

 fs/ocfs2/dir.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 7799f4d16ce9..dccf0349e523 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -809,11 +809,17 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 	}
 
 	if (!found) {
-		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
-				  inode->i_ino,
-				  le32_to_cpu(rec->e_cpos),
-				  ocfs2_rec_clusters(el, rec));
+		if (rec) {
+			ret = ocfs2_error(inode->i_sb,
+					"Inode %lu has bad extent record (%u, %u, 0) in btree\n",
+					inode->i_ino,
+					le32_to_cpu(rec->e_cpos),
+					ocfs2_rec_clusters(el, rec));
+		} else {
+			ret = ocfs2_error(inode->i_sb,
+					"Inode %lu has no extent records in btree\n",
+					inode->i_ino);
+		}
 		goto out;
 	}
 
-- 
2.45.2

