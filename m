Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15F91442FA
	for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 11:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711883885; cv=none; b=ZsYm1pmvFsqSKey8nnCTp+Swj9o5RpnHkGnNDqmtz38iE/KnG09PtO0jEt3XrmwBi/U3jE2Yu7sRgzY4sA4HwUc7Ypu0E/5Xa83pt1Hw1uk1/VC+XH4kjgSVvyrjrHnzK7aoOa+nFDn4dgBUVG+StQpDqnITzk139Kd6Xxu48/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711883885; c=relaxed/simple;
	bh=FxktzRU1caA4LjmYTGPH2hqMRJMlTT+syczzwrcB9eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNg4cYvd/esw618siNoAqjpN72qVMNTn5AYJM1gXsccQimrKzyr3OVjhJOG7nXicIy1p4hlTyMKZlg1yrIKSPHNtjBSaBu2ptur5jPF2z+ANdoQUC4lwUGYEvJPGm/CULY2KtTQp1x2lA3EqwNtpZQbVC50clk0SNXiBbQvAp1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QlN/aaRZ; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QlN/aaRZ"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d47a92cfefso38479871fa.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 04:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711883880; x=1712488680; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9gkBC2PMN8Ri6afh83YiKco1UV0ZLdlvcdf+dGBQvJY=;
        b=QlN/aaRZJe8MB+q7OljmIyrzVdzERDFoD9WuJjWM+BOv9L6CzaUoBX/Ey19aq75G+p
         ecsFOH1K92I7t0mQqhzWAgtN0kVub9Y8+/jTwrxsRaVp4eg8TrNrAv7bc4pQijopfI6L
         IAXJdiC37yhmC9RYzvXNCK5y0LJtvgh4IxnmIx7+XY+C9HROlM3mJk6GdyaIcJE8/uig
         0K9KVVs0Jbp8pdq+vAOBiViUM6iL0/r1moZ+YrY0Wc3R9Yz0LsJErK+BwJRh9VU/YwuW
         LYwgOu2YN0qd7rxzf6td0y7Z2UuKf7966d69WbNxJW3Q/uaQ4+eZ9TN9kr7SELGmxScd
         +VtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711883880; x=1712488680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9gkBC2PMN8Ri6afh83YiKco1UV0ZLdlvcdf+dGBQvJY=;
        b=fr4rhhzVeyPCqeYsoxlZZDgjD2pjZJonrte0nwxlreaAQWip88xME6Ukd2dlrhXhjx
         PSHSBVZozftsdh36MxfsDItpuWsB+MJemUgDC6ncmWS6a1grEphDbZJcbA9YCcBEr+Qi
         8dh1pd9htLnaKNPxxT2JD98nk5x9dJ/OxJcfrE/likMrvK7X2hNp1IzkNCQYeSM0xM7D
         Iu1Mwvkt2lNEYtrPVj6wMqCZFgvp0fPh2hiJuZPJn3ikoPQnU4WjyIgVv4D0oqJpuki6
         2vVs4ka1C1e4k7sIY5iQ5CwMN6uiabKf2zhmUZW7rf38EPyWW2I+QdR7mMETGiNaSwzT
         otyw==
X-Gm-Message-State: AOJu0Yz6AZgUBGJsd3uLTyEwUPOiXCUB0G+vT/24tRY0/zrcKJD4q9Ec
	NMebe7Zf7C9JWO+HHyAF8Wz5YqNWh5Xgn4efqX/EwyhxxRidI19PkaW4IaSu9A8uKc2OwXv48GU
	R
X-Google-Smtp-Source: AGHT+IGS7WOKAspiMQUVUIvHAsdN/n9LgXq8lWeDYMc5g7KzzbCz5k8JlWNUW2rqR8QmzHDeXu3lDg==
X-Received: by 2002:a2e:a444:0:b0:2d4:7003:fc6c with SMTP id v4-20020a2ea444000000b002d47003fc6cmr3410127ljn.10.1711883880441;
        Sun, 31 Mar 2024 04:18:00 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id bf7-20020a170902b90700b001dd82855d47sm6675406plb.265.2024.03.31.04.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 04:17:59 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH 1/4] ocfs2: return real error code in ocfs2_dio_wr_get_block
Date: Sun, 31 Mar 2024 19:17:41 +0800
Message-ID: <20240331111744.7224-2-l@damenly.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240331111744.7224-1-l@damenly.org>
References: <20240331111744.7224-1-l@damenly.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Su Yue <glass.su@suse.com>

ocfs2_dio_wr_get_block always returns -EIO in case of errors.
However, some programs expect right exit codes while doing dio.
For example, tools like fio treat -ENOSPC as expected code while
doing stress jobs. And quota tools expect -QUOTA when disk quota
exceededs.

-EIO is too strong return code in the dio path. I have checked
return codes from collees of ocfs2_dio_wr_get_block to make sure
the change does not hurt us.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/aops.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b82185075de7..f0467d3b3c88 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2283,8 +2283,6 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	if (ret < 0)
-		ret = -EIO;
 	return ret;
 }
 
-- 
2.44.0

