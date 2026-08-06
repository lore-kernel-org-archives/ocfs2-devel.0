Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E5B483836
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 17:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035608; cv=none; b=hJGF6l7VsJAu0vx6iEzTpyszIRUEG9RgyHkVYLsFy+DgY1GmHlSmRhUtoKPnygJW7tLzJTAwSb/PhbBibAdKE8neRwClUT3uPRObhcM1pJ3y2hXIlnSvO2phCacFxjYfgNp842YoQnxtuWR3w2l62tjV08GxjNT06UmLgmICvaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035608; c=relaxed/simple;
	bh=nwDfftK6tDKKFwsyIY1zmP/nNMRDmqL5O9HNMSOfLoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=karXQ5OpzfWHXG5dNTDdPUw454QptN1CYvJjUuac6/PsSMkFATwiOAeiv+B/ILfy3Bff2znyUd0xmVvKtn7HUz3HTLCxzUqqDFQUtER0Fhd12moKtxUEUI7yw+7oH+hxkvxic0AGBIyw3+tVo8z5Tfl48aFEBfJnwkJHLOF0Jzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e+QTjiVG; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e+QTjiVG"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5bf94664327so1024907e0c.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 06 Aug 2026 10:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035606; x=1786640406; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VOSQ52yeWBlRERTYkX4++c0c05H07NL60x8ILsT5aXA=;
        b=e+QTjiVGJO7eDsSVvPR8IKdrCUJLkpbf6ZlffLmiwN+Ef1XZfOLeGj7yr+RH4HYX0X
         7BG3kz6F+32Clsc9a3LQiHlRMCWuDJuCEc8mwUHJhRvsQf8an5st8sh5SooT13eYxMN7
         xSQhdz2LdBnGZnA7ClD6mMTl6RY6jkgYn0szqAlWQJ6RH90nrWcwO/U9TEblqn9CxkbJ
         aiPIO0ihJNyUH1Qg8IZesqn5FR5eh/Thu9U4kIsk8u8rfX+e4hJinwB4F1H5Uz1ZrKVz
         rYrR3QlRLCla/tcpaalNcSZUMp4T95l2Z8MHJaiDrABai28rx0gPXYRUgyaqAGCFVVC/
         6KxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035606; x=1786640406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VOSQ52yeWBlRERTYkX4++c0c05H07NL60x8ILsT5aXA=;
        b=qeCBAh6Lo6yj9bpiGZDk2fofVjPKTp2wmehZk31Q9XbSJgZVXO53K62wawpzcjQzqr
         7E7h3BcpxNJ3gBcQgTHKBp8T0OHVdkJzcQ9WWYxw5mInbZfQi/9wF0tQ0THoM8yfWbeI
         o9b47W5WLZOBnk9au1ehF7zdwq4wnhW0567QZRP7ag0e3vVbF/DUCDxfer3OBdwxHOmX
         1acwYP1kEUSF86r5BXDg/i5+X7jgte+DNsjXRabqrYeZt1jO46C/hKivEZ+l9+vymT+v
         tabiPwqJjaBhT37rhqA6QcC6kYpxClfGUMAQwtoTC0qMFHY8yRAXCd071I0Qtvn0g8NF
         rZzg==
X-Forwarded-Encrypted: i=1; AHgh+RqLKaS8D0h8g+MVy6D/X8XPYJ5JWzJW6D5AG8mqIN+5cag3jao9z2v9PqgKgPIING0ifjnTjFW2aJ738Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxfZnZFX0tKoJaNVoKeJWSKjUAgNR0pAgAISDsi1qNNtV7Tv5Zv
	CFif0lw83yGqeH3He8hwnN/lQ/c7Pz/2w3TYoIzVav7spaJ0UFFf80i9
X-Gm-Gg: AR+sD11f2iy3RRpdRRpSHNOeHqVK5ts4HvocnQFqLnOhXuol31tg5XMyibLX7gPh0U7
	12iqwiiKOTtIM2ZM+WqEescwYabJ1w9RFJNPgcxAayIfMeyj0JGsXmJ2Ljbrg1ln197RfqwlYMw
	7Ue/EianfdJHrETCrrMDcK0sJ7HWQnXzCaNMs2NG8xhnlf442fC8yaouKVaKQVqMUxXzFCS5N8B
	/8NfXVVT01JpnxC3eAUPFeFymyyFGj/5T5XPlOJRng3oAYitDgzQPh6NQ0T8Gh049ABdsN/eAmb
	5hzJsY6SpwbbyOaZfF9UFKcdDQcVDqeNxB0io9I35OoD1aweB/vlC1egQsTJQmPOO7cJ8RiZbs/
	8j6qQpjjMypijrMDy6i96IZ5vqtOLJ8UB4TRUEZkIJdt7WOEzEEhB51D5plYrAOzDHQCH9/LQqc
	zGY8eJKDTSS3xeCnExOjh3OW82ZHXiVz78c5owGFkCVBSnVGj4iXaZd51IS9uQf62G3kwyYsdUh
	aufH0M=
X-Received: by 2002:a05:6122:8f88:b0:5bf:b3a0:388c with SMTP id 71dfb90a1353d-5c3d91849cemr2185136e0c.6.1786035605840;
        Thu, 06 Aug 2026 10:00:05 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.10.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:00:05 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 18/21] jbd2: say what jbd2_freeze_jh_data()'s assertion is actually checking
Date: Thu,  6 Aug 2026 12:58:41 -0400
Message-ID: <713ffb9c0cdfe55499b3cdd2c06a59a2c152c46c.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The assertion that the buffer about to be copied out is up to date is
correct and stays, but its message - "Possible IO failure" - describes what
a buffer that is not up to date used to mean rather than what is being
checked.

Once this series stops clearing BH_Uptodate on write error, that reading is
wrong twice over.  A failed write no longer makes a buffer not up to date,
and a buffer that does carry BH_Write_EIO is fine here: it still holds
valid data and the journal will write it again.  What the assertion is
really guarding is that there is something valid to copy at all.

Say that instead.

Suggested-by: Jan Kara <jack@suse.cz>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/jbd2/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 5cc7d097b2ac..85d84d909f78 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -920,7 +920,7 @@ static void jbd2_freeze_jh_data(struct journal_head *jh)
 	char *source;
 	struct buffer_head *bh = jh2bh(jh);
 
-	J_EXPECT_JH(jh, buffer_uptodate(bh), "Possible IO failure.\n");
+	J_EXPECT_JH(jh, buffer_uptodate(bh), "Buffer not uptodate!\n");
 	source = kmap_local_folio(bh->b_folio, bh_offset(bh));
 	/* Fire data frozen trigger just before we copy the data */
 	jbd2_buffer_frozen_trigger(jh, source, jh->b_triggers);
-- 
2.43.0

