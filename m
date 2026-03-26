Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D722138839E
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 06:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774508342; cv=none; b=HjamTChGkDbMCCNrEca2vB9lJ3NOU+HLn4eLe7CS5d2eGW1lmVSNbs+hm3ooG5mJVwTW9Zx63HsaWHtkWM0+A18eSnokpJMFZ4iXDoNL2NXrL2DICBG0pdPh6BrqFnCGkRAh3a7vhDwBGs5c0GF4EvcUkAds43PDXs5q4v+Gars=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774508342; c=relaxed/simple;
	bh=n09AYt0AGyKvZm8wXYnifFnjtUYBAs8s/SnYBlDc3fE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=inY1ITHO3okSQiM1MvQUUb23+IlQFgcfSP7c2tjWggpg2sD67+Td92YlhNeDFuFqH9DOfsPtFxVZryuMNOMB3bTDOfLWXyeDN+7rAkWn5BULC8ZgWgBoHkJZCm20VDwcJoueP9nx6gHsEdoyIsQx2CfW8gIc1kjn+8d9rUgDRmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JNTO5a+I; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JNTO5a+I"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4830b67aa6bso305625e9.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 25 Mar 2026 23:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774508339; x=1775113139; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zDyQMUfvTiYsREdUdoRQHUhudDWwpiuf4wK9j2dlYBQ=;
        b=JNTO5a+Iqry+SZPwII5Bdg+6pJosWrMEwZTdv4LyriaRf33FNrdOfTWFQBaF757K0g
         sdwqmqBHWlYKjt11c2dLQ6YiCeoY1tVCs1D5HwaEWaCL2BiXVsMIFu3pESB7ju4SXFpl
         mT0LFpi+DGSLo2qACyWnjyWT3eqOVantQc0wdxAhejRkqj/xQ3jHAW1wKVorFNy6nium
         5jpMq8+LZWjJVxqVDWZDjSC8Qb/Q50q2p8kntWX2OpeFu3D9qpLZI885w6pitkAGFTCs
         qTOutwbD9ZWB28209kqJzryKxD1+eZLdCbzzoKWZjXqGI384Q/jnGoGoyciTgZFoY+mn
         +EwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774508339; x=1775113139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zDyQMUfvTiYsREdUdoRQHUhudDWwpiuf4wK9j2dlYBQ=;
        b=V67xIOX50i9qc21YoANC/zDsvyF/y9ZwY2DoWfxJo6I35/QlFkNcleBK+dyUEmgW8R
         VgBM3l0p1vfNxlKCEJn4wQzkGaJZpIy8/NtZpZZC2rHVf5USzN/vF5BfXhyXc8ZiF7RK
         Msc2S3+wgMitk9LOLHH9L1hIXCvJk5qQ+bfWNx18+JLhwew5YQmd3jQRnBmkaeje/BlM
         qLAVmtfZrttojVdP/ErnL7kgW7CgljAloTYUNo6//FzZuVNvgpWbwjAgLKo1c7rN6SAO
         ibDW/eNh6hkRuncXMNvhkPe3XevulwSRres7I1WbZSEMom18+uVvlbVd054+cbYJNlJ7
         eOXg==
X-Forwarded-Encrypted: i=1; AJvYcCWgWWKxddXjU7wGfmn+7JmXxLZ7b3z5Zt+8pgJia6zOzAQcfbG4tNdHPMrMScSnHjvKd5rER1jG6DH/1Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwCHErWBcjUHDgybtjm+rqfzNMqFdBJv8q3skoduybHc+0bJeyy
	a9HNUZMG532DvIrBTlslY1IlxElOPtrYHJ98FZrem/fzIgBtuKmMf8nyJxdi7iAuyKM=
X-Gm-Gg: ATEYQzz6kT8D8VAJ37B6lVJWrh4evjGZkG9C3JoB9TU8C/HBN4uPlhVLix+ZXjEq1x2
	jPDeu7gz1comGDNatS5zEVkMBujYj3MIN/79dQ+4JQtJfystiT820XV9AiiUzfLv4G+/nBe50ki
	GC1GDJoVBvMk65rhhM5IL6acdx3I+3yXsaB0o4bxb3g+C+t2qGurAjzmRtwUvt29/8vbXrN0Oko
	hw/DbC9aL5pH+G55wm5sf95GXjz2gjp2JlQxRtj/X8wU2274Dn27i7JbwcS06yCxNSn5ldgDc+z
	WWLdGZlKSUYreeJ7jzpoUvObgzESLTDTkmpLvx8F7NWTt96WnN2dfH9CZH7XDSpBmGTGAmqUdLg
	uYgZ4mPeVhQ2AnVFzJpil6HFNnFy1FugWtLfnf6YQKHDh3dNFTK7fQ5Cai50AFTVxC719MZFYEZ
	yRli7RBRLjXL6ZVKk7KEr2ma7FmtQ8VqeYGojy
X-Received: by 2002:a05:600c:35c6:b0:485:358b:e7ee with SMTP id 5b1f17b1804b1-48715f0390dmr66546715e9.0.1774508339253;
        Wed, 25 Mar 2026 23:58:59 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc8c4bd3sm20279875ad.63.2026.03.25.23.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 23:58:58 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jack@suse.cz,
	glass.su@suse.com
Subject: [PATCH v3 0/2] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu, 26 Mar 2026 14:58:16 +0800
Message-ID: <20260326065821.15156-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For easier merging, this patch is based on Joseph's patch [1].

v2->v3:
Following the discussion, use 'batch' and 'handle' to control
restarting the jbd2 transaction.

v1->v2:
following the review comments, restore the i_size update code in
ocfs2_dio_end_io_write().

the runtime of the test script [2].
real    1m49.650s
user    0m0.337s
sys     0m22.780s

[1]:
https://lore.kernel.org/ocfs2-devel/46yilbaq5z5x6gdfdpoa6lprf6sf3gbxriuku2odje4kx4bovf@jd735cphfutz/T/#t 
[2]:
https://lore.kernel.org/ocfs2-devel/75f89a17-213b-42a0-a30e-d52fb2d077a6@linux.alibaba.com/T/#mbe2b5f52ee249178e1ad4c76d964de2dc818eb32

Heming Zhao (2):
  ocfs2: split transactions in dio completion to avoid credit exhaustion
  Revert "ocfs2: fix DIO failure due to insufficient transaction
    credits"

 fs/ocfs2/aops.c        | 75 ++++++++++++++++++++++++------------------
 fs/ocfs2/journal.c     | 17 ----------
 fs/ocfs2/journal.h     |  2 --
 fs/ocfs2/ocfs2_trace.h |  2 --
 4 files changed, 43 insertions(+), 53 deletions(-)

-- 
2.43.0

