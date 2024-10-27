Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BE22FE33
	for <ocfs2-devel@lists.linux.dev>; Sun, 27 Oct 2024 13:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730036148; cv=none; b=CwNTDPCSxq3F3VmiBW17nOmgN4jOn0bxHRdS5AbiRhNuqhFl9Ps8jB5vsIlLZs4hbMiO6XepqEYo+SQhxNdwvBWLUX5whoD7HX08Y6NHyIIJH5EbG9VrehU/Xxx712vbdIWAbhZQn4JUuMc6s0MKduGsHWDhfdw//CtUmnD9RKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730036148; c=relaxed/simple;
	bh=0O8eKPQladhE8cLxr/bSaYHnQGuNIfdauWs5HzIC8rs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HOMOPokxnTGXyeZqo/OaxLq/Wfdp9sbw4n0Hg5UidT2Mx+HJUpD128++LkQTd5gkIojCe+qIoTAIa0AVvEbD96csIg00rddsrbp89SXfcwLg7Z3Lq8zHEw6Xazb0mC2hSqwnQ4dz826KqmDmWdTpAZjnS23RG7HTptyJYA18oPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eyEZKxey; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eyEZKxey"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4315f24a6bbso34435255e9.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 27 Oct 2024 06:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730036145; x=1730640945; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mK7sVqYoX25AgNKVn0A6qLQfrJlccu+9fSrGoYMncso=;
        b=eyEZKxeyMInCOH5w0KWZFKJ+XRGFBrL3USR181GxQiPvAU5cvSqCiRH4fjiDVpM6F8
         Tk40ku0wnOM896e8yOj8IH9z/22GjAYntt0ncWP0MmCUTJrp+nBYc/THwj/of0EkWznE
         toWTfyPRb/KCMgMawvEu/6X3CMR/UhzcpzdBYVysvHxih8+GE8fpAQQ9ub0tP0aY4o8p
         0Lb/7MRWbNcBaUtGjLIRVlDdJDfX073cgVzp60A/MlaUFH2fMapIizT5oQUdY+Tp50b6
         MKGllKQGSs75etWCqHOiKRT4nBxzVbJnWzHGHCYXK1kpBZQiDTwJom1HA0myz2leUkII
         WOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730036145; x=1730640945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mK7sVqYoX25AgNKVn0A6qLQfrJlccu+9fSrGoYMncso=;
        b=V0Pz/eutb6NuK/f8FE7Gh8IptH+wUOmelY84Df/tYeYb4WUj9w1+Tlq73xgCkKMZcV
         lBG+peY//tpIy4hKDOX7NULv30gwn0GETUJHQkVK2ZB8XE0ZVsTuq7ebhS6SeAgOoBKu
         262iclHH9Ud1bM30DRkJd9oaCZ4XUgFxWTtyL6ZXToUTN1HKuOPnlei0O6jEYwNR5Lvy
         RnpAzmOtQQeijT13e6ueY7KtzMbNqa17wvzZZH0o6mQCCc+YC9xdoz5+lADGnw/tx6zV
         k4YpHF8Cqwyrw4xJUv8/IHP9tIMUT2f4ooVPCcPbUkYQQq0VjRC1oQ44RXfTQkr4uZ74
         rhXw==
X-Gm-Message-State: AOJu0Yz1bwUtBYegnsIFAFxq4eOk7pu4Pbnq574iKJ9MCprWSJFzZF5P
	dpwAn0SrJ35DucpfSKfC89IYXaTwpEp+UXxpmPmN/q0rBDuCIFD0
X-Google-Smtp-Source: AGHT+IFvoR5pALM3sVKeUHGr16ao40f833nEkt8YEwQlcfMaEnCIzjNv8RcjHl6d476xPvJAQ3quew==
X-Received: by 2002:a7b:c5cc:0:b0:428:1310:b6b5 with SMTP id 5b1f17b1804b1-431aa802774mr1484315e9.34.1730036145278;
        Sun, 27 Oct 2024 06:35:45 -0700 (PDT)
Received: from void.void ([141.226.10.223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b712d6sm6814218f8f.78.2024.10.27.06.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 06:35:44 -0700 (PDT)
From: Andrew Kreimer <algonell@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Andrew Kreimer <algonell@gmail.com>
Subject: [PATCH] ocfs2: cluster: fix a typo
Date: Sun, 27 Oct 2024 15:35:18 +0200
Message-ID: <20241027133540.22090-1-algonell@gmail.com>
X-Mailer: git-send-email 2.47.0.149.g3e3ac46130
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a typo: panicing -> panicking.

Via codespell.

Signed-off-by: Andrew Kreimer <algonell@gmail.com>
---
 fs/ocfs2/cluster/quorum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index 15d0ed9c13e5..8bf17231d7b7 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -60,7 +60,7 @@ static void o2quo_fence_self(void)
 	switch (o2nm_single_cluster->cl_fence_method) {
 	case O2NM_FENCE_PANIC:
 		panic("*** ocfs2 is very sorry to be fencing this system by "
-		      "panicing ***\n");
+		      "panicking ***\n");
 		break;
 	default:
 		WARN_ON(o2nm_single_cluster->cl_fence_method >=
-- 
2.47.0.149.g3e3ac46130

