Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814F71482E2
	for <ocfs2-devel@lists.linux.dev>; Sun,  8 Sep 2024 14:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725804440; cv=none; b=WBnBhn6rLZlz5iE2nvzoC/cyJV9Cl4f4jdnr/P9+9l3n5HH9kgYUckvNewrtyES8qEzDwtviU5CdiydeANjlAoW7+TUHT2tq/ftnzWh0x19rG7abuHfEFFwlAeKgdGJX7kMXyQ3eEvRj5vxYv41ekIznYH35UplSjmmSQstXgjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725804440; c=relaxed/simple;
	bh=mo8CzNGunHuO64tHr+6qMjdt496cUslWuBLgvsDihKU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cRds3TR3KyW1maqRIgKq6pB4xL4Cmles3K9Y5vPx4qQypI4yGcUwF3EJqLQJLPbTjIgv2IJFuZTt10+Sj385tvs4PjDupOcUZORkKmzc5lvX/VDnZ7tV7JiHWqQCUeDGd2BlcRFY/yo+sy8GaEvJ2hVFejSI95X+dZAqF3jO0UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b8pP/XL3; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b8pP/XL3"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3719419c2aaso81087f8f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 08 Sep 2024 07:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725804435; x=1726409235; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=29SIEneF1cqyaBC9DVH0mHI4s+16R15C9iDveRntcgA=;
        b=b8pP/XL3rk2KyBKLbBNgjIkoDoSYUINQMDIs5P2VkYK9MKWfzk3I6VBNjVVp3SlZww
         jFJoU623MY9N0P20Z+OxxMvPFibPLxLnwo98YJf/XUFdvTpylZ/A1OF0YXKpQH2zgFg2
         DEGoIFIQuugvw2hEYFyxAKt6w2UD4uNqYKM0XC7AnixgvgnR/4uEVSK65nVWfKROw8fU
         UappGa19xLU1GB4nnsxgiynVvwH+exww65ANAQUgiDYRaHJqscdc7+7tllgXmT3yhYyK
         s/1RlTfczC5wWDEZ6fQ8ltCFMjkne2hKEp0FNZw8eWQ03Rh38q2m8fqmCP9QAV8ySsgh
         6rvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725804435; x=1726409235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=29SIEneF1cqyaBC9DVH0mHI4s+16R15C9iDveRntcgA=;
        b=aOmn0u1MOueRGZ0Ob9GpnT3qcsor3Kci5NzSHGLAOoF6BZNx2mMUnrEQmQgOGWg2iW
         RaIp2KIK69Fq8Afgxp23iW6l0n2SiSRzQoS56X8ORu6fOIMjFsj4NN6THHJrMU8cuZqw
         Db50HRcVnDIO19ej0jzA78FZzpMhdJc4ujBfwgKkyIjZ3zNYsJNiSFr9dmBnAaXZQDX/
         q8H8vI15PROCK6ZVP5WWG1+4spghjvyoyg+Hw2h/2XO+1a7nihyoRVyyocCjH0fLtInd
         wgyAAjCOj7bOnj9A08KfCtt12zMayN+joG22zRFHWXI++GMSZ6JYz7Oowc9FYTYKEOZw
         N55A==
X-Forwarded-Encrypted: i=1; AJvYcCXxSNYi+Vn5iUBwgAtCo5XF918ZxNSghWWwCRjiC19FuyjMTHLKgd2SU2LHbtIu9Xy57SEbO4U6fh4ZIw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzcxaLl6/pYyOgY+sV3sB1CalmxvcUrmOFn5Diqf03SgXHT9Q8o
	uMyGuwJZhtn1C0SiIWkL95xOIi8Olw/8Lkv1896qdH8CiGVQaCg7NUGmqdknLNi8t1WH6I/m4+Y
	l
X-Google-Smtp-Source: AGHT+IHaYq1WS8AUlU43piYyPmURN1dkvYLnQvW/P8MeitdwlUgCLBypYHXMSCrTEm7d4ah1GXS7Lw==
X-Received: by 2002:a05:6000:184c:b0:374:bde8:3b46 with SMTP id ffacd0b85a97d-378895c54a5mr2808090f8f.2.1725804433832;
        Sun, 08 Sep 2024 07:07:13 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dadc074599sm4863371a91.31.2024.09.08.07.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2024 07:07:13 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	glass.su@suse.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] ocfs2: give ocfs2 the ability to reclaim suballoc free bg
Date: Sun,  8 Sep 2024 22:07:02 +0800
Message-Id: <20240908140705.19169-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3:

For patch [1/3]:
- Factor out the reclaim code into a new function '_reclaim_to_main_bm'.
- The function ocfs2_read_hint_group_descriptor doesn't return -EIDRM
  when the group descriptor is invalid. The new code logic returns 0,
  and the input parameter '*released' is set to 1.

For patch [2/3]:
- Modify the code to follow the new logic of ocfs2_read_hint_group_descriptor
  as introduced in patch [1/3].

For patch [3/3]:
- No new changes.

v3 patch has passed the xfstests:
./check -g quick -T -b -s ocfs2 -e generic/032 -e generic/076 \
-e generic/081 -e generic/266 -e generic/272 -e generic/281 \
-e generic/331 -e generic/338 -e generic/347 -e generic/361 \
-e generic/479 -e generic/480 -e generic/628 -e generic/629 \
-e generic/648 -e generic/650

v2:

Create 2 new patches:
- ocfs2: detect released suballocator bg for fh_to_[dentry|parent]
- ocfs2: adjust spinlock_t ip_lock protection scope

In ocfs2_read_hint_group_descriptor()
- bypass the validation of GD when the BH is already managed by jbd2.

In _ocfs2_free_suballoc_bits()
- Move up the position of the vars 'idx' & 'rec'.
- Move up the position of the ocfs2_journal_dirty.
- Use le[16|32]_to_cpu() to access cl/fe/rec vars.
- Add error handling for calling ocfs2_extend_trans().
- adjust spin_lock ->ip_lock protection scope.
- Follow Glass's review comments, add 'comment' & 'else-break' for the
  'for-loop'.

v1:

Only create patch:
- ocfs2: give ocfs2 the ability to reclaim suballoc free bg


Heming Zhao (3):
  ocfs2: give ocfs2 the ability to reclaim suballoc free bg
  ocfs2: detect released suballocator bg for fh_to_[dentry|parent]
  ocfs2: adjust spinlock_t ip_lock protection scope

 fs/ocfs2/dlmglue.c  |   3 +-
 fs/ocfs2/inode.c    |   5 +-
 fs/ocfs2/resize.c   |   4 +-
 fs/ocfs2/suballoc.c | 332 +++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 318 insertions(+), 26 deletions(-)

-- 
2.35.3

