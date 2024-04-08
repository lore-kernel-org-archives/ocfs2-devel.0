Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FEB2C69C
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Apr 2024 08:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712564463; cv=none; b=pa0A8DvQa28LfimC+wWj4WRt1NXpMTi0AdStZffnosNGW2kDqUgQW2zpesII5dGD9/QALDJrSnO6jUpPc0oUOT1+6YbiLlzAo4Ex4AQfOcgcp09SpfA+RRItmw3ePmRls28k0m+2EG/IsSzvAMMTEe/w6g0zXO1h0G1bgjQ2YPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712564463; c=relaxed/simple;
	bh=9pdjTt/gh0IhCKPLnY5Sq7vErp/pf4in6ThDa1bno0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWEcpod46z4Nj/CGWUS0xICw7OBYaO0FdsRb5/vnlABmFxZqUPq2j72//bjJxAqTkkC3nbq2EcAFL5KybmI1Xt7qnhmLi31WBaudFdSk84pLzWRDIhA63ke9hzF9Vw3gWDRfplARFI/bWSyahAK7CLpg141glEkmkn20ybAi28Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LLz2ffsr; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LLz2ffsr"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d6c9678cbdso53847781fa.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 08 Apr 2024 01:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712564458; x=1713169258; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bUkZlQs220fLoYzRdwgTqLyT2iPPHzAzB+hnAyoHG0Q=;
        b=LLz2ffsrCHbRpDwjQe/4yisY/2N0EluEFD3S5DyIkuynwbnvtu5SPfxjQA3YgseX0i
         bsYJFA38ZkPTcdEISt27IXwnGGu7nJtgME5Up7Cd/dgaevYBxg3DABzDXpIMStT0WjcJ
         i5jvPUnTj4B489WPwfq/bHZFdUWNfkhefb6QQzTmgU2O/cn7txEkz4tGcm7BhdIGhe+h
         9en5/NuIp3HqYvxswTZo4EutGMZkr+sVp/E7KdQwth5eVloQD2+5SyNC13eLZthvix4i
         Iuz6+18aILigkExxOv+33YwI18bODjjaroYV+45q+SHmpWIKl3xuTH0Un+Ng4kauhVFh
         D3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712564458; x=1713169258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bUkZlQs220fLoYzRdwgTqLyT2iPPHzAzB+hnAyoHG0Q=;
        b=cYDKy1v8L4jRIECTTQ/LFhzX9+fEfyOblcPWdkD2nMVoMeApoTv+oSfFSS0kEAxFZi
         7mXbVPf+yG+UMGFhM5H8U/YZekkgbhU8yVlfZnAOkUYtnkygbTJ4W8DO1UQrCZWv65u7
         lE3GTcMI4EPkzsiElhcoN1Dxlu8H5zyl8cqLENHLDPfuMRHuHU+b5AcGkIvetfeAt3Wx
         JzvuFBr31exfuZ/oMnjMTOx+RppL04fjF/29VsAFk6IGphkP2YLYA1lTBtB4kh36+FBL
         xg0xYCaiQoNZ/7n9u6smpaxRkIepnwRRqe1l3UC72quOJK/PvMWIkokQ/KPYVlIZx3Rx
         Wjaw==
X-Gm-Message-State: AOJu0YxQPrl1Pt3GvNSl4DIfWFZqP8s4Veg+0uZyu5+Bn2aG8hDKi/3G
	/b4fw2l/SJ3YgaopurcA2RLNpuV4R6cj0UJAH7yxWDtBYCQVzueR5aPbulGezki+anXzP54RuFZ
	D
X-Google-Smtp-Source: AGHT+IE07kMDKS4YSoKAIJ9In4NQkJSEgsfbItrlBx05S2XyreseWGEWSg8Y6cBtDOINo07IujO0oA==
X-Received: by 2002:a2e:8e86:0:b0:2d8:6104:f95a with SMTP id z6-20020a2e8e86000000b002d86104f95amr5088732ljk.23.1712564458133;
        Mon, 08 Apr 2024 01:20:58 -0700 (PDT)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id ft4-20020a17090b0f8400b002a54c4dd0f2sm213894pjb.43.2024.04.08.01.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 01:20:57 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3 1/4] ocfs2: return real error code in ocfs2_dio_wr_get_block
Date: Mon,  8 Apr 2024 16:20:38 +0800
Message-ID: <20240408082041.20925-2-glass.su@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408082041.20925-1-glass.su@suse.com>
References: <20240408082041.20925-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_dio_wr_get_block always returns -EIO in case of errors.
However, some programs expect right exit codes while doing dio.
For example, tools like fio treat -ENOSPC as expected code while
doing stress jobs. And quota tools expect -EDQUOT when disk quota
exceeds.

-EIO is too strong return code in the dio path.
The caller of ocfs2_dio_wr_get_block is __blockdev_direct_IO which is
widely used and it handles error codes well. I have checked functions
called by ocfs2_dio_wr_get_block and their return codes look good and
clear. So I think it's safe to let ocfs2_dio_wr_get_block return real
error code.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
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

