Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248D7230274
	for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 08:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760171577; cv=none; b=SOLPEVp1mhUkTg7zdWw0WALAh/xH61tKFWDNbmXj/5wNf/lMaqtlTXqf7juxl9Z50wR7fRRhdqYHmjJ6EfSPqr1N48eTq25ubThVqgd4go8xYThi+Oclbeuz7P7G6bpCdIQMTG76SssBOgded3oCkh2ZAMdEu4esY63aUizMIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760171577; c=relaxed/simple;
	bh=4tmxTvNOTpOf95JJ3x7mQPqFH75GrdZlng+aNIh+4xk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DjmHA9IwK5X+byaRuW4JgZPAMIp17/57sjEFXTe3gG+JEkBYQHB+gUTBbUjw+1ciAhBQtqMBIN2JrXdCdE6pSFHVARHkCQBvNDjpmpRbReTp257Ke91w/05PZkGe1OEMSVGZC5n8+pIs8Pa7dY+fiQBqqnxp1JWJaf1LxNjgesA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PLR/SAOY; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PLR/SAOY"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7811fa91774so2438843b3a.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 01:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760171571; x=1760776371; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ta0EmFWq+bNf3nosDwmz689S/1I/sZSzXyh2AonVWo=;
        b=PLR/SAOYGqycnhLAjrELeRmvM1m/NlmZX362mcVM0H4O0rBzabbdnW80d2ks5TB6WU
         4jMtzs3B3lOn/dbRArtY8NHMzca6vCscaqK12UAkNJgtA+34MQUG4AZn2/bjRA3QS0aF
         tx71kFx6st3dxPbdtT4+0hlyFq9ZatutlUdKFDI5lmN223rsAOeJirt8ROkwS/6y4+jG
         kS8hAcy2o4PXiaZiXFa4karwHZ8GKLyfDBKHhImC7Vemy4ajLcU36rBSDg3+ZeRYsy/W
         gMQAceJd6pmKEyEFBsWp//1zuCywpAieXjI6ZYICool6fotfWYszjZP2NTNzyvCkmT3z
         leUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760171571; x=1760776371;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Ta0EmFWq+bNf3nosDwmz689S/1I/sZSzXyh2AonVWo=;
        b=kZNsf5NjopFIOwMCfREIEDFP7v7aFL+9liNDkcaIPSfm99A1bVS80BQ5HCPgPX0Qww
         m3C7bZLdqrtDP5PEYeXM/xAX0l3CZccOBrbxGo7E4pYOx00+TKdeTbPhxHsrnWrQ0HXe
         p4WmZaM6gSZAeBu/+lSFOjPpTha6wgTabTbwL8cKTqIx8chTH6qZOJNyXA+C3GqrVpxQ
         vxdP+S1mIDyqh1Qpsx0AAWOcxXfqL5N0DLBXTHY2pHdOuMac1tWoRLKYPqOzZH7CLApJ
         WeOEGgOxSa1oYoORTuacRy9Ql+jmpnW5SgLn3J30Ziex8glnMrWihKGfvTm0n5xKUEeB
         SVyQ==
X-Gm-Message-State: AOJu0YwXimyRdISUX50Wfync+sgw3KHteYJ/JQIF3EMb/QXRP9xMkijY
	76F14nj3gEr2v6e9pLZGfVkgkpRo9NDSn0z7ut0uTI3CXvzgzFa5qfNiIByjREH45h8=
X-Gm-Gg: ASbGncsWgaxYtkFLO/ZB0IVBY7ah6vU8IyxL0kygydSrC5YvjqppQC/dDZYa9b/3DKW
	s3cnvu5lkw2lI2C+GOEKTWY4b6cDBu8aMoQtcnUsNvQdk1+grDRLztgF/HKzU76DxbTVDSDR9oB
	2KOUyyM9NAztnFGgId2WmlzbX71YYvf0UhdaG6c5iflsuzS5TfddksDbacWZuBCwEJ3j4dyJ3LQ
	Qvi0T9oBnEn7o3yX+OpspCRQ+dPfLMGoaeK1mtL/DFnJYdnpMzlby1YPo3KK8/aYlOedDSxyPsv
	hnT9cHJsoSfoorgZrOy6Ya4atXF0XgcxXcGSLIQQv/3l3vplO8GIQ89u9LW7igqxwVC4l6NDdTk
	kSW/TFtZwJjALJcutUz3Fs/LX0vkoqDkd0uOt7ndwuVtSGECe/elvkph2Y65YT8WW/o6YHHZjS1
	wq93cfhrHrbpdYs75BaOpHng==
X-Google-Smtp-Source: AGHT+IEr8jO/C2ScZ44WpNt6yOISZY5vZvGKUrMj1uETIsBCaWMtX1NNVkmfJdO2zBDw0rhDy4h/bg==
X-Received: by 2002:a05:6a21:6da2:b0:32a:91c6:e085 with SMTP id adf61e73a8af0-32da818334emr18113949637.11.1760171571316;
        Sat, 11 Oct 2025 01:32:51 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:2be5:a957:8629:d978])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b67acd88c77sm1292518a12.34.2025.10.11.01.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Oct 2025 01:32:50 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: heming.zhao@suse.com,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: fix stale extent map cache during COW operations
Date: Sat, 11 Oct 2025 14:02:44 +0530
Message-ID: <20251011083244.822985-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Heming,

Thank you for the detailed analysis and feedback.

After further investigation, I discovered that the ioctl call in the reproducer 
(0x40406f06) is NOT FITRIM as the syzbot comment suggested. Decoding the ioctl 
number shows:
  - Type: 'o' (0x6f)
  - Number: 6
  - This is OCFS2_IOC_MOVE_EXT (defined in fs/ocfs2/ocfs2_ioctl.h:222)

So the actual call path in the reproducer is:
1. copy_file_range() - creates reflinked extent with flags=0x2
2. ioctl(OCFS2_IOC_MOVE_EXT) - calls ocfs2_move_extents() -> 
   __ocfs2_move_extents_range()
3. write() - triggers BUG_ON

Inside __ocfs2_move_extents_range(), the while loop:
  - Calls ocfs2_get_clusters() which caches the extent with flags=0x2
  - Then calls ocfs2_move_extent() -> __ocfs2_move_extent()
  - __ocfs2_move_extent() at line 50 clears the refcount flag on disk:
      replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
  - But the extent cache is not invalidated

This is exactly what my v2 patch fixes by adding ocfs2_extent_map_trunc() 
after the move operation completes.

Thanks for your time!

Best regards,
Deepanshu
