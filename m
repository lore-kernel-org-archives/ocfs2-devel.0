Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8783C3B9D8D
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 03:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779766851; cv=none; b=qcG7ybM0HDOpWYD2nSouBEJdrhKmh7Qm+WW+sXPxZqyi82Vd7BPhJE1Jk/+IdONU0QrEAQDZhPo8CQoTm6KQHWNRPFHtEsLw1RuOu9sLeedK8MIaOFrSRgq/xgIJHAunf2+3RLW85sUQtxvJq6vw/IXoCVquvQLCUjnwLDOAF+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779766851; c=relaxed/simple;
	bh=CWrGbvittqfJlUGa+eDDo2qRYPSN8inE4Dn1qiVZrYw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bvCbgEEoFnSX+hTByWR3bYrZP3EZpInTZTprnrwMK/Cj+pb29A1OSr2lV+X/BZPokiLYiDBcVefvAiQ8wXii9U8wvmOU0uQWzMOOTWAxShNgkrjLxdwgt3QuW3k4WTD1X5AbAQyzthr+2D9rgctI7KwtK5rTpV/CbhwmGDeGiFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fT7RgaTK; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fT7RgaTK"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-8353fd1cb5fso4982186b3a.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 20:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779766849; x=1780371649; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LTY4hZ2RhoTsyOvBWt/C+iMgLjUOUlY3fwuKPijzWJQ=;
        b=fT7RgaTKX+f67ZLVltOb+TCAUN4BFaKSBkTFU4C0nq61wDHi6xjbzMX8+Pj+FETnyt
         SYavI5nPJAwgecRroDSLA3Yi8opIaDy1dI0SWN5bbmiMwAYzpC45faH/38aratl9QjEC
         SYvpLE4wmlPZiYkjdlBKLIRShAKrcFZnQXjURL+JLmC9Mzdjm2v8AWKc8/TTpI9jKMnd
         LlRPRnHAd3l9qqZhtAx8w0f3cfIyACEUAPBSQRzUx6ll+90msnuF45iYNAOiq/NcblKx
         WmnKEWvBw5ivTkS9YV3CoZjp0uuQPxLMW5d7JgNNbAnaScGRzoS7fWPUgS2lfWjUKFjq
         sPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779766849; x=1780371649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTY4hZ2RhoTsyOvBWt/C+iMgLjUOUlY3fwuKPijzWJQ=;
        b=owXMCPxYHbT8AcEumwnJr3KhPqEnX4t6ITDp/ONfP2SzL5tdfoBLUubJ8JKCl7yPcX
         +Sk9n38o/gxNhp5Mmg18GRr/iPLSP8Rnk0XexRtdLtMRmPbrDFvOUiru/+W558bxKNkh
         wk4ZHgDKSFyREYcPA+U/RykrVRIUx6YsvVIV+oVopZER1XapOTUUk0a2RR+UHH4lY8by
         dvUcxH57lJi/RN6U0a1Ifw7leMDcJyAReu2QYZQ6N/PWe2raLHbtfYGfj6I4DfSV7yVd
         MoZgHGnjOTxpb53n8cARsQg5gFSPk+5FlaJowEmoJkpqo3zXFPEalB8M8VhJGTKRMjED
         D3Dg==
X-Gm-Message-State: AOJu0YwDZJaoTQL8R5siK6cEI94LMMltqa9C1ds55hb+Xm3gI4H4U+90
	sZjtYwF1GQ9QZQZ/KjI6BYMHD1yv5MtPNQXSCE7D5k8rVGfQItIo5IEF
X-Gm-Gg: Acq92OEf5jrBvezFoj2SYjK5u2Ga2liNnKiMXc0NxjMMFvEMSdm54/Pa+MOXdxslYNy
	hFLwWQKev+JxXWw4TU89Hwl9SabqyimUt5wm4GPXmncIGG8iGTspH12EXlRWGZS53pE4FaewTH7
	wFxe/5arNrhazT7wMagS9u9FNaLUFPLaTjhjsYYuug0vhpWzD67WLfZzgiLoDQzodYoWgGVjoBd
	XF4uEFLHk93mIqW2MFrJA8aASXdgwA7wdB/wkNOJq+sETc63USEvPzjXv3PeMS7iiGBYgk8YZjf
	LwRhF5AgpV9bx5McAod+kO5c1IFa8ZgEGLv+KeDXTTuuIBNcSzpZff3rFfNiYVtyWC+W+vHbjwG
	c7A2fPYauy5N8qZOrnI4+RysLrsSTvEcOG2IWktgZ1/YebHp15m4pw0JGEzGG27XpcZb9eTKEKW
	iyXhEMyxjWoZtQ9TwmskbUiEnWfMlbjTE=
X-Received: by 2002:a05:6a00:3a1b:b0:835:537a:6f15 with SMTP id d2e1a72fcca58-8416112863dmr12857649b3a.15.1779766848665;
        Mon, 25 May 2026 20:40:48 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ff3e00sm12368478b3a.54.2026.05.25.20.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 20:40:48 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH v2 0/2] ocfs2: validate xattr metadata bounds
Date: Tue, 26 May 2026 11:40:38 +0800
Message-Id: <20260526034040.3602377-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This small series rejects corrupted OCFS2 xattr metadata before the
getxattr and listxattr paths walk filesystem-controlled inline, external
block, or indexed bucket storage.

Patch 1 validates the inline xattr header placement and entry count
before ocfs2_xattr_ibody_get() parses it. Patch 2 builds on that helper
and validates listxattr entry counts and name ranges against the storage
that backs each walk.

Both issues were reproduced with crafted OCFS2 images under KASAN.

v2:
- Resend as a proper two-patch series. The previous send was malformed
  by the transport and appeared as a single combined email.

Zhang Cen (2):
  ocfs2: validate inline xattr metadata in ocfs2_xattr_ibody_get
  ocfs2: validate listxattr entry bounds

 fs/ocfs2/xattr.c | 122 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 101 insertions(+), 21 deletions(-)

-- 
2.43.0
