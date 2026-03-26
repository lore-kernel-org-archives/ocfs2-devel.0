Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E60C27E1A1
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 14:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774535210; cv=none; b=lb/88wc0ul1ULkKxgfnmpzdZnQtU2K9Ooa1o6D6gGAm7UCL7UKGwii2UvAerkpJK2KkAoap4FQo63zZs2+mIS/hoKcVJlxp5YhrYrnKPspRMesnK6lr8rbs04HE0o3PyswWB3WSdFAPtfJbs/57P7l+MlFUt7U87A36vxZZA12c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774535210; c=relaxed/simple;
	bh=xyngNdNZbSTfX05zt4g9pJVcr4nymWyj5rMTSlWaIxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AVdb2jFvVjatQkirm4r2mdWkcTShC+GqMbmxcEEsfsQaMCkeJinojvhfmC9Kg8eT9QikRI/j6Tvm10g92TLCUJj4uetK8CkhSeUxEcbXR+sNJRipOmJbT2DyR/6e/c/sJILyuxDn+IAfRryBCT5wYXvgj6lRVULJFHdKkOkG8jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GmGXRYxe; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GmGXRYxe"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48533a598fcso1985025e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 07:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774535208; x=1775140008; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/amN3qXV6maTSfb7WE/Xn2lom+AxH4Aj6LtnID6Fngo=;
        b=GmGXRYxejJz/fOP3F5+CdyyV4y25jFKETxWTjMF3MzqNQ1NOWXfCOj7GsonzHHNmeO
         v7gYHMnius1xhrdpN7Ri3d66wRFFknZ6M6zrvGI9gpxxyJi8h7nccwSl1jlkJ/OqNe9x
         SaHVdS9x3JXGfGV0hNTlw3OvommcFaKbFtTzoj7TuaPxbJqvArt4KiHdK8/6U4kaVOj7
         8WMkt2Irl8XCoSIaJRN/BNdvCZT61eINcglGcA7qZ9e9yzLbF9HkK52bIF8JORr4IxwS
         1l1yTVVL5fVlDHHfowRi2vmi7qEX9de2V5DCAI/9qj/pvaUg711PM4mXFwvtY7J7RfmL
         PW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774535208; x=1775140008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/amN3qXV6maTSfb7WE/Xn2lom+AxH4Aj6LtnID6Fngo=;
        b=GaXFF/uC0voqK82SMCiqQysL13k/mUjejtufw0IfFk8tGwtdPB+yFxsQ1jp52Ll+PZ
         gWFWwldespSADtDQ5PyrH+Z7m6ZsgQi4FCV/IwaqsGGUyO0f6sBSpp/bDlHI+wDuffJ4
         eHumucAk5DbBixet4ciQ3vsRHVGFXoID966nW4o9Sdp0auRVp2+LvoDkb8hnspFqqrlv
         L4e+lLx1+6SjVJeKfY9391YpyJmD5/4tlhJGk7r4+DraVVC90chzdTvOYqUwpm5XkvtA
         FiJu0aHuEys8oQokokNCF0te74KUPGOaYgBHBM1s8da/9nptn2Fsy2W26Cn935cMPSDY
         1D8g==
X-Forwarded-Encrypted: i=1; AJvYcCULQEwU4P2jW9m+6Bz/UvdVK39QnuqnOK7WS6scfq3TdhJ66/+kC5X0S/v4+aTicbsFPWm+DNv4C1WxEg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzAgOPQLa9jshVwZ5NNOBwFYvHMn5n6tkQfMd7nt+2Ajs2ZO7A7
	sUb8uhZi7A+q3oN38jVqsptqx2djw9H3JlNIjCgXo8+8oTMsAKfUQaNwKzRBwCo4Fz0brgeqjHp
	Mxb/XSrk=
X-Gm-Gg: ATEYQzx7HhPbe02BNK2KKzisyDjyKsYtpAqTofwXhdc7te6kkMi+mF7poRAJ6Uh/wTx
	Tmb7Q9YhEUAF8k/JaXNNQGlILWMZSwiNy+3MBILf+caF19GbyBbDIf9Q8s4yRykZyo5lMP6KkGD
	Jkzlh1pgGR3vjU33FxZCOz6jlAV2FjsXRCTbOOS+76xUXDKkvLrmoZiaL6e0KygqjrnCjiJQaxb
	S2LoGmiX+1dJ7rHdCarJxf6PPix3QDQL4+f5kLxNwoomSWAtsWQTjOaET9YzJqxLByo4Osm6Ka8
	gCQdI+Ukz225XYzWGQPpVD4XfOOwoz5ui5Xei2Q+NZ4KZa7i2i1jurO2vUMMJQRTvfTSHOwnMoX
	Ybggw1bJyIt5srNbRRn6zBTWRFX2PZQBf8ccW1vvG4P41KOgR5fd5sgzPVkno/enoiK4SsHjcW4
	RMvx1c3GiX0E0aqabJNOnbskrY++wxtbhXChLJ
X-Received: by 2002:a05:600c:4e88:b0:477:aed0:f402 with SMTP id 5b1f17b1804b1-487160b3b7bmr76552145e9.8.1774535207605;
        Thu, 26 Mar 2026 07:26:47 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d23841fsm3538669b3a.26.2026.03.26.07.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 07:26:46 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	jack@suse.cz
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v4 0/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu, 26 Mar 2026 22:26:38 +0800
Message-ID: <20260326142640.20077-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For easier merging, this patch is based on Joseph's patch [1].

v3->v4:
Remove [patch 2/2] as the revert operation is incorrect.

v2->v3:
Following the discussion, use 'batch' and 'handle' to control
restarting the jbd2 transaction.

v1->v2:
following the review comments, restore the i_size update code in
ocfs2_dio_end_io_write().

the runtime of the test script [2].
real    1m49.100s
user    0m0.303s
sys     0m22.672s

[1]:
https://lore.kernel.org/ocfs2-devel/46yilbaq5z5x6gdfdpoa6lprf6sf3gbxriuku2odje4kx4bovf@jd735cphfutz/T/#t 
[2]:
https://lore.kernel.org/ocfs2-devel/75f89a17-213b-42a0-a30e-d52fb2d077a6@linux.alibaba.com/T/#mbe2b5f52ee249178e1ad4c76d964de2dc818eb32

Heming Zhao (1):
  ocfs2: split transactions in dio completion to avoid credit exhaustion

 fs/ocfs2/aops.c | 72 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 28 deletions(-)

-- 
2.43.0

