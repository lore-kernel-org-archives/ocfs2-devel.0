Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A071D63FB
	for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 07:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760168556; cv=none; b=TdsYBlRmQZNEL61e10hNVMj5CeN82UnJw4JvaGdq1sDOHg5to68gQLhbq5f7ck3DYjIdun+2amHUwUWSOxidpF3AV6o5suSzwFT7GMC+RBKo0yAx07PALVxoGuDA3yBUJN/nITlR3KSF4e0b5eBv6rLUIDww+wBQ8QNwWxBlaug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760168556; c=relaxed/simple;
	bh=NpFtc9Ia/VUtbsEj0nTLyL2x93ej74vMvRzTFZH2utg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BXdKRpmqhYg0nkPPoBey2oCiE/CH8Oul6SYsv9JhCSC4kmG3vs+inJZyt+HsjIS0K9h7aE19RG9wHOVhO5vOiFkERr9119OyFUDNaTqUFkzGrOyujtsl6Trz3uQU8I57902YnJr3A9hNWoMNxSDaLeg3UKGo+cNp2fbk99ZtenY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NB10ezse; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NB10ezse"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-27ee41e0798so44638725ad.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 00:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760168554; x=1760773354; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cZO3ywerteuN+FePy9qJsgDAwYZUo+tnTmcRp4rGvok=;
        b=NB10ezse76zM3cODzgLgcm6bTNWbCL1Qhc+/gSJOSYQp3R4A4tzOc9dOnGdAvLBo0b
         C0XqkkfiOXeWwGJXaq18+f/5wQo7p2d0OuRSbx7MPdK9LrtkBH3FmJX6xikH6pN9ouGV
         LFPPPPx5otG4a576uRwmJoeSbr4NOK1vJkE89UoXqnRFCuAN1LRsNvJNXhkYzX2vMFKD
         T/jFWhQn04DphHNC+dGmWmMEIALiuZixfcFV+ah5G0dCWsROQkitXHSCJOrHmXTZMCNl
         xqjLbc7i4NgPf2znPb1YbjUbrXmbMDVTBMI11OaAneu3tZRDCJIoVWm9xii2wvjhw48M
         zzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760168554; x=1760773354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cZO3ywerteuN+FePy9qJsgDAwYZUo+tnTmcRp4rGvok=;
        b=ecOOtybr310cR1LHuhu824pTlnP1XC+GxA5o5lUr9Z7HgZ18hPbY+SiOTMb/qmTceS
         wzYC7a3dPaOTek9rHb4K4qK5SXtl48muhL/AiV1eQvSDPEzqXJZeAM2FnFG+HLXA6arK
         6tfxDuT1fEY4zwqm4oWvpU0SDbcbXkFvHv9nPx2tReZtoOPhtZncqxjF59xJhJ/NrXNg
         2dxw+apPxN3h425ZXvsCAzuN1N1p7zWYUHcKXhbOSDFF7a8m9Jet/UbXnWs7wV6KbTp/
         dZDRwPgzFEeXXRiDg5bJNNECziGmXlvPUWofFsZ3e6likwmqNAqtqBRtrsMqJ4w86aX4
         z/pw==
X-Gm-Message-State: AOJu0YyIwcwJicn6yZ6UHQqNkQxpPuY8fJCnbrfmIesphL077Sq1XBHu
	Fy03gDH1meVxS0pPlhtXlMTDzHaxA8JO82os3ifZEz8vtHzL+eVzMfHbSMyEGu3SJsI=
X-Gm-Gg: ASbGnct+o7YhQO9zGJjYt9X+EF6bDaw+bMyNCKguBuKgbwTceo9RVCjxe4xJKNHy2SA
	mXMc4+6aV4UoGFNPvFoRkYCXrjEmSLfRvx7pZlu2YhJ9XtYzRNm3Vkn4nJ7Dz03EggnIwmUcV3O
	ie2jWVoTciVBMr/7Hlz+R4FLCrFqK609qYP12cyAHMv4TtcMjcMB0T7hSqUiiCtDDtz/GcHm2iE
	cNaKORipZJa7NfuM+/imFcuiObON3hpFz1bMjX9TUl57LbruUX78jJUwNBqpdIKyBlH/LJcaj4o
	y5d5EahjmsPSwG/QFPNdn4yE7dN5g2T9v0upzvVoBZ/+1Zc5uWU4HiLkuiQqgkF5zg8FpLxRhXz
	siQm540lArgiR5mDk+17pmwhhFclTb6oKx6mdsmBPNLW/TiXjZAXcg0irSyhtUYSKm+D9nA182/
	cA7InB6UNhDCNkQ9mBheE3mP9rC4Yqbyo=
X-Google-Smtp-Source: AGHT+IHVzsN4OObaUacV8+iwbdoA5hLuvUY03lsbXr/AKHdhX4aXGovoDEJRDGRsbYt7U199Icby8Q==
X-Received: by 2002:a17:902:f607:b0:25c:7434:1c03 with SMTP id d9443c01a7336-290273568e4mr188544205ad.10.1760168553718;
        Sat, 11 Oct 2025 00:42:33 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:87ea:a5ed:8e4:bfcc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de6e2asm77493045ad.23.2025.10.11.00.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Oct 2025 00:42:32 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: heming.zhao@suse.com,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: fix stale extent map cache during COW operations
Date: Sat, 11 Oct 2025 13:12:26 +0530
Message-ID: <20251011074226.821546-1-kartikey406@gmail.com>
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

I appreciate your review. However, I'm trying to understand your explanation 
better. You mentioned that step 5 (write with zeros) cleans the file data 
and causes the refcount flag mismatch. 

Looking at the C reproducer, I see:
- Step 7: copy_file_range() creates reflinked extent (flags=0x2)
- Step 8: ioctl(fd, 0x40406f06, ...) which is FITRIM
- Step 9: write() triggers the BUG_ON

In my analysis, step 8 (FITRIM) calls ocfs2_move_extents() -> 
__ocfs2_move_extents_range() -> ocfs2_move_extent() -> __ocfs2_move_extent().

Inside __ocfs2_move_extent() at line 50, I found:
    replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;

This explicitly clears the OCFS2_EXT_REFCOUNTED flag when writing to disk, 
but the extent cache is not invalidated afterward.

Could you help me understand:
1. How does the write operation in step 5 clear the refcount flag on disk?
2. Are you suggesting there might be two separate bugs - one in the FITRIM 
   path (which v2 fixes) and another in a different path (which v1 would fix)?

My v2 patch has been merged into linux-next. If you believe v1 addresses a 
different bug scenario, I'm happy to submit it as an additional patch.

Thanks for your time and expertise!

Best regards,
Deepanshu
