Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BF21DE89A
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Apr 2025 06:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744610497; cv=none; b=be9Tt+Unblzw4zg0kzUaUN4wrFSggzmLmNK8bzxmaHFA0AOH0/mc4Tuc8N7f+W8ku7p3Oh9nsP75GCp/VlatMzkJlTnEXWtW7HJt1WfzGlIZDRDk0KYEfkuTQx6pzrKXr064WKJPxffJhUNFV4u8efkZAVoV9n8b75TXwOuyvDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744610497; c=relaxed/simple;
	bh=EcMfXzjc0f88vB3toS0ABfI5YgnwjH3e+vx22X93KFI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RmN705C4zaWqZVxiJlrIFezvi29ctKic1qgaz7kJyOIT67M5NXye7jXH7J6OyId8nTayp2EXBP9GtwXqO+ikExi8VRP+3UVUHkiY1NM86kmc1vAX/cJpyQWHbxCoAgj32sLu1XVsQWdoWOnRQCSLvrjxgOnDkAmTokKsBSQBUyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PACuCkYm; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PACuCkYm"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cee550af2so4322395e9.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 13 Apr 2025 23:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744610493; x=1745215293; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GaK/Duc2/P3Mm4Vaom0POcUuZzetxOATY1/LwQLjocc=;
        b=PACuCkYm5/RcaZWJtyD/t49WaWyPpERlDsm6AZWbBFu/gcK8OJfaVM9t5XITJ5haxq
         iFwwKbzDKBcu7NaASe9DalfMh88u5HCduMpXMIbnrHZdJnkTW0XXUcsvpWz6lKa9juty
         tEQ/nSAXdJl5xdGcft6lMpo1aoWzBuiomUr8Kjr+7ranlsnvLEKW9lb7IvMYBVwadBLs
         pl3/M9oGVEYEjazH5i0jfgAmVpXF5xZfkxSmKmQ8xGRBMXGSmRb5NNdKkfMymWFSHIG0
         ssUzDLFMJVUzYKt2cE1IWyJTmwtCCGahu644aLbKNQYE1Ykh2oGRqgyqCJ1dqRrd+azc
         xG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744610493; x=1745215293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GaK/Duc2/P3Mm4Vaom0POcUuZzetxOATY1/LwQLjocc=;
        b=b0VbNdAfhtBGpClU4Z5LDzw+Gq3+n4l1oj/0/SBgNhUcA72ulekWm6iLqxJFdyyrSC
         AY8KDuJQiIdIM/0iJl+HH4vSMCLWxw2Ha/hpPZrtE8xDCJfYDVCaxuiJROcVvC64FsKZ
         C4d79eLTEEvqmf7JQyvrhW6RO51ptV3sN6ZQRl3AwRpzzHqbuLCuIp9OqY+o+NIpvEK1
         vf56TjjqBFGX4w+rUs4WE0weU6DIwDAg1mHUtohJc0ch5FV7OJtM3widOkgUnFks9car
         3yT8kpscGSs3AIXzfLxcf6X1+voNSbcwahPabxZLJgSldSBphGTl0gXIXdJ4slTTmeKi
         4Ggw==
X-Forwarded-Encrypted: i=1; AJvYcCVYgxRFHrVFzbDA8A39aC6mUrz8G2Cz4ZtSvvdwAavEGDgL8vjIy3pbaA5aQghPjpDTAL5sFJ2IWGBsYQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywe0lof2wSkYLbVQhobKEJLd/r8VpOHrjNZ8ViH0bhPj64bqWaE
	oNq0Ou/kmtr+YPEbaU9WEuq1ifrRem1kTkybOkgI2oTqGbbvV0C8qLAEOaCKu60=
X-Gm-Gg: ASbGncuSMO1R+vSUt9chcY+YF9OIrBiWRmklrez03aBZMfG+q/vKFvtbAaNeUflP1oM
	0gT9pL2H+0c7rhf2XlJ8fV5gRdA9qojgNNYUWlh8cfRljif6H1fqZdUFNU3kyefyLfl0JsKCul5
	34WGI1YKMS0pRqPDjSEIKP2kBjVB0fgQmdevMnFtONux01VR7RxtZmjrb4f2+H/fBJil7bZkoxy
	JlJyPSau9FexYLljZKSG2xmlHmPKWKu/bm7lsBQckZ0cm/zltKF2vGXnBrlg+2qotIHLV3fHffU
	uHVzYyVKXcHEHrg/76w/SSL7OlQXh3XBg9ewOUQkFPP9fvzcqJjE8+4=
X-Google-Smtp-Source: AGHT+IHaEbtzDigymltzIRWG9TwpHrh86ssXQV3ZPHNTRqiUrqlLpO+plF92DL9K5QFZp6NOJ6mEYA==
X-Received: by 2002:a05:6000:1787:b0:39a:be16:9f1e with SMTP id ffacd0b85a97d-39eaaec4be4mr3176931f8f.12.1744610492739;
        Sun, 13 Apr 2025 23:01:32 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7b8c3c1sm92029555ad.60.2025.04.13.23.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Apr 2025 23:01:32 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	gautham.ananthakrishna@oracle.com
Subject: [PATCH v2 0/1] ocfs2: fix discontig allocating issue
Date: Mon, 14 Apr 2025 14:01:22 +0800
Message-ID: <20250414060125.19938-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running ocfs2-test, I found the same issue [1] regarding
discontiguous extent allocation. The previous patch [1]'s commit
is incorrect, and the fix code is insufficient, so I am sending
this patch.

PS, there is an ocfs2-test PR [2] pending for review.

[1]:
https://lore.kernel.org/ocfs2-devel/1f3049dc-5536-4a27-8768-b264be062f7c@linux.alibaba.com/T/#t

[2]:
https://github.com/markfasheh/ocfs2-test/pull/21

---
v1 -> v2.
- we will recall patch [1], so this patch merges some codes of patch [1].
- polish the 'if' condition in function ocfs2_search_chain().

---
Heming Zhao (1):
  ocfs2: fix the issue with discontiguous allocation in the
    global_bitmap

 fs/ocfs2/suballoc.c | 38 ++++++++++++++++++++++++++++++++------
 fs/ocfs2/suballoc.h |  1 +
 2 files changed, 33 insertions(+), 6 deletions(-)

-- 
2.43.0

