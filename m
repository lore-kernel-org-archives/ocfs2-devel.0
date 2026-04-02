Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C557B386C1C
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 10:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775124425; cv=none; b=uZr1LB/Ho4+tH6/Zw5Oz5t7XDwjuo/KSik6yCxJqiTFfeVkkRgTKT9cJKGJHkluw71y89Lo2UpQD32G+Yw4Rbe+466fsDQGA/XGqzM4diKtUA/Qki6Q5+dnEi6y8OFor6ZMfSy7LpZVnrOrvNRN0siTvR4fOkBeVtFJ87kIhIYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775124425; c=relaxed/simple;
	bh=bf7qvDxR75mWEgf7KBD6caONv2dNfIm/tLJHbNZ4Iko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qqWYULMN9iuHfTR8fQJxLGxivKRTUonS9ArKtFrmO68bD2Yacm2dJ3gewammdCF5i4ra+rRirdrc4dmHCRny0oM7yqGuqbD69RC5PoXW7mkxEue9P7eCW6RyNgzIrBJDaJ7gaBWeIK+bzOEpXBAL4AwWvKG/SHqOSYS9HSRe8L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SLDCGVzJ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SLDCGVzJ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4836d9d54f6so867315e9.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 03:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775124422; x=1775729222; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A2aCT5udmSV679NKs5QYcrhiKC1n83X6NNcjMYG+n+k=;
        b=SLDCGVzJSHtEkDNLrHX9XEb+7IhapL+n4CWB0rZa53OGzTnB99oXlHq6c9HWd46uB/
         1pPykTDGSJIsxGSBrobGRcBw3Sd/hcLPrJaM/I13LgPkkWfA7MWkULPghQz3ACE5nN6W
         2agmnsM4RAK0EAb9wLVwBmINYbaKTHt9ve44uiO/GnNz+0RX6CNdir2bnYCxn07g5Zvm
         rA9G1e4yquQvHneZXhutpx/tcXuCK5OO9ga0S3mNqkdY2H30Qe4R+rphpwnBlTs72wvD
         +waDMfUIbU/LwGVu1nxqXWHDdkX9Xh6mEZ7+EIoaziVpV+Bg3g4yTkFRu2Qy6tIwCe8Y
         /vTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775124422; x=1775729222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2aCT5udmSV679NKs5QYcrhiKC1n83X6NNcjMYG+n+k=;
        b=L8Q3WkijnX3PMRNOJbdx4FYWng4zFFltUNWm/kYAEm+iOBS8hXI3OfdWsfsjbJ3EwP
         V9t1ROGMOx1xLdpTfHY68UPrJBwHxdpIl3VFQ/tIgpX5aq8UJE2mqCIFy7kAmFVN2sO5
         9j+7XYb8vOdhz7HhBRAhlLg8f4DtrmYYw7eEbQbAoyVPeC9dIOK4Izv5PXt+h7ARkGk+
         j+5vF81ZwP5mAyYygVeOsZXZVre4V9GP9QKnfCNEx/8+tcKGG04LMzt4/o+SA8zq0bez
         DylmppSiSxpmbtJ7kEr76y5WdmBQ7U/NYFMSe8QrWwrIK4sCTgeaY6WtYplLkWP4enMK
         0d3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVum+OrIGjdHDO1gJpYXXIIG9QSj9pgeZSnYnxHma1mcljiQ31uTrkqWpn6AAaxrEx33hCTds2RATJsXw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzhAt/fX0wwnLcLD642q6Ih+Tj29wVEcKXDuH5vKIvL32L04969
	ZbgoDLX/WBxdKzSx4eLGnfnaWqzxnflwaB373DFy8LJG6Pxir5+5den6mZwTk3SORfc=
X-Gm-Gg: ATEYQzyI/6blsqB7Dzd8889ynPPCLXsopgVMdHt8nCSuo2OozCyJOjiH9fmpSP9gjgK
	gufPwx1PnIbuH5EV3EKb2jWZ50xOvc+aLbSfI1dE/QHaWdCczKVoU2xFaki6m65yrFOeSCIoCmr
	PGDusDTr8X3ilmx8HolBfdzkJg3XXEvXDl7GD6DyleLQo1GCPJzNE6ZsQQMVw46GQJF+pTsu/aY
	5CJXwa5hTpjvcWSOOz9qK/5Vc5nZITfj9A9ySK7Qy9qejsAQo3AsPrNLXMwUYegTCxUkTBqz9fj
	lWLHqjPdshlKqh1+DKXFDc6DtPC6WyhkCM0W1Qer1/uOA0d864ixpuFIw/+mt0uqxh3NWTDkvdk
	PpmlLAHbajcPip4sgFzLyglFiJBIxgE36MUqZCL+I8pTNjTFg9QVDwJ2vyJXx+yF6G9rxJZ8sTv
	0/iPiR66TuAy84HU4NC0NnDkepuAP8V1vbNy0muzZV3KSTEoQ=
X-Received: by 2002:a05:600c:450e:b0:487:22de:25 with SMTP id 5b1f17b1804b1-488835af512mr64691045e9.7.1775124422105;
        Thu, 02 Apr 2026 03:07:02 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c65a3f08sm2307300a12.31.2026.04.02.03.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 03:07:01 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com,
	jack@suse.cz
Subject: [PATCH v7 0/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu,  2 Apr 2026 18:06:54 +0800
Message-ID: <20260402100656.24874-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For easier merging, this patch is based on Joseph's patch [1].

v6->v7:
fix logic error regarding "handle == NULL".

v5->v6:
add a check for handle before updating i_size.

v4->v5:
change update inode size and remove orphan logic.
add above change in commit log.

v3->v4:
Remove [patch 2/2] as the revert operation is incorrect.

v2->v3:
Following the discussion, use 'batch' and 'handle' to control
restarting the jbd2 transaction.

v1->v2:
following the review comments, restore the i_size update code in
ocfs2_dio_end_io_write().

the runtime of the test script [2].
real    1m48.148s
user    0m0.344s
sys     0m22.684s

[1]:
https://lore.kernel.org/ocfs2-devel/46yilbaq5z5x6gdfdpoa6lprf6sf3gbxriuku2odje4kx4bovf@jd735cphfutz/T/#t 
[2]:
https://lore.kernel.org/ocfs2-devel/75f89a17-213b-42a0-a30e-d52fb2d077a6@linux.alibaba.com/T/#mbe2b5f52ee249178e1ad4c76d964de2dc818eb32

Heming Zhao (1):
  ocfs2: split transactions in dio completion to avoid credit exhaustion

 fs/ocfs2/aops.c | 71 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 28 deletions(-)

-- 
2.43.0

