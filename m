Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B35F2C1BA
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 08:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711527716; cv=none; b=dgM75htRuXvoUWvKvg5jVw6/pHF5/FAPj7mUqQrJOu8AjSHqzWRES6bfiJ7DWgOoR7C+yT7e5OdY59DulodlDjr8zM0rySC+Rk03CHStEFvnal3wPXgP3CTMbPs1tLRgRq9Foe4hUlmAQVRFszGftHDCnohIr1ZA7aB8BX3+dpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711527716; c=relaxed/simple;
	bh=ke1UHlMA82VxUJ950mBn6p59eK+My6TjDfvusWcCtTs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=heryN9MwhyhIO31viA/ZkOHq/LQfda4YQkUULEKMAHlRShRM0BdvuqAztnjkB8dZIsG81A8h7h91BBNR5Ri2iz5da47XjxJuVSq2P6VMuY4o2iVx9TsnIvGk7O8r1FhposIIIeqdAXgr/XZhfTrY2kVkbZbo2xYvomHxlxswPB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=boLtd5hb; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="boLtd5hb"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d4a901e284so120563101fa.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 01:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711527713; x=1712132513; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E8BbZaKh05we9RVSKGF9lxM0YjlSyuXhT+MoyDItOm8=;
        b=boLtd5hbNzeLrK+st33+irK86fh+r9ujzGwQdhQHASIpbnvZzCEIQth38n/7I5jGfP
         Lpd5Ar9aVGA0ntsYauEQLdPnGjbv7U/5IVr1FcJ6UZMV7u5oM4sVYo8VVx7rhCSuQTMg
         mRn47DfGTbycoPnw3/dJUNruR5YH6itOU/5VR8IsSBQhr2amzqSOh/JDt5nhQYJ/WbAC
         28+Fi0IiZJLy6PI8CdxUyW+2v8E9qkbsmRDBbWORuApyiQBsAtS+Cj7/xHbXYoVMrq/p
         OE6CXX1MZeb1/jdT4Xjato5UJgcyoINBPSuO3gNQ015U0wj5hA14JtRe3FqQY1BqnkS0
         3YTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711527713; x=1712132513;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E8BbZaKh05we9RVSKGF9lxM0YjlSyuXhT+MoyDItOm8=;
        b=Va+Kwdd6AE4EcZbRjs4UP/6bSth+0bn2TcsnAOUsAVBEvCyzbFt3LD7C3OGHG4Wz4I
         AJbJc/BsxNIK4XhEVduxouRCZaVL7kN5sLSqdSMKBfr3ssKdku8Wde40Yq0wsdmWfDnb
         c46VPNYbkyaqfZckhfJ6FD5gCvhmMzSs+MdlrYa6V8gOYGJpbu5mhtq3XHnyQCWOo46d
         G6j+ryPyXl9aCr/iwpuMok8xH01cQ/AP330md3YWmLcYZcnLkbpkwv/AGXSu9t+uNcRq
         pNeH4k0lit99/lIUVdBaiIQQaY5WM/mZpb17WX87zR7Q08xwZmVmmm56oJkrb+gTyy4c
         jqpw==
X-Forwarded-Encrypted: i=1; AJvYcCWYH0c59gfafpJWiAhfLojX4Q4vVldHCrH37v4fLgBjj7j1hxPk953Q4pqL1P9BmkVEpW0HA22Z0fzWJNgx+LUZiH+uZkh1VBjaxkg=
X-Gm-Message-State: AOJu0YxmJccwDWNuylFVI4LpA7ryfNqa86ZvGZRPKJzW8YhQG0tLahcE
	ed5mdablUUapUt1sM+2SPws1jQJD/L2g57C+FynfHn2Z3AeZJbM3A9QZxcC4fKE=
X-Google-Smtp-Source: AGHT+IEkEWLHxgojXt6hS4oKPvc1ekiNiOfnNxdnGwoG0/KiR4nDmoWhsLWuKyWxXydw+RFhjUK2+Q==
X-Received: by 2002:a2e:9b46:0:b0:2d4:5a23:6b3e with SMTP id o6-20020a2e9b46000000b002d45a236b3emr1635176ljj.27.1711527712491;
        Wed, 27 Mar 2024 01:21:52 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id x2-20020a056a00188200b006ea858ea901sm3423022pfh.210.2024.03.27.01.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 01:21:51 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v4 0/3] improve write IO performance when fragmentation is high
Date: Wed, 27 Mar 2024 16:21:43 +0800
Message-Id: <20240327082146.6258-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please ignore previous patches, and using these patches for reviewing.

In v4, I split 3 patch files for easy reviewing:
- (1/3, existing) improve write IO performance when fragmentation is high
- (2/3, new) adjust enabling place for la-window
- (3/3, new) speed up chain-list searching

Heming Zhao (3):
  ocfs2: improve write IO performance when fragmentation is high
  ocfs2: adjust enabling place for la window
  ocfs2: speed up chain-list searching

 fs/ocfs2/localalloc.c   |  17 ++++---
 fs/ocfs2/move_extents.c |   2 +-
 fs/ocfs2/ocfs2_fs.h     |   3 +-
 fs/ocfs2/resize.c       |   8 +++
 fs/ocfs2/suballoc.c     | 110 ++++++++++++++++++++++++++++++++++------
 fs/ocfs2/suballoc.h     |   6 ++-
 6 files changed, 119 insertions(+), 27 deletions(-)

-- 
2.35.3

