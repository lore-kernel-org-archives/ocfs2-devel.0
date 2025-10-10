Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571208528E
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 02:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760061660; cv=none; b=SjVB09N4tHz89/rUP0F6Mn6/+SXvZYI7yJFF5MUtzf6HLlLbUfCIJAxunf269WnCNXh+eThbPuxnY3IZUKej+yUTJdpj+X2kbsl9jB72DJBJnq54B6io1S0rsKWKMvyC24BCwTlIpyoT2CYskL27tjtbuQWhliEm5Tdj+uMRmh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760061660; c=relaxed/simple;
	bh=ZJ0ZO8tVsX63PTkbuehFWFQ5H5Io+PO6mAdzl1iHsj0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hbOFyWpoIdbdG/ZkBMAZYB5BKrDV/zYO4wt51tIvpCHd0aaJnUB31vkO1smCUBwaOCkJ/KS7N8Bdxms4riGvj+kw73YUGv44YeQfqLIzgXgYMph/myp6P0Peu3764wTSshM0HROHILQQrJFscI6HVsiLVRtlfC/KSpz5uzmIO38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bGzW4Ioy; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGzW4Ioy"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-330b4739538so1464507a91.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Oct 2025 19:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760061658; x=1760666458; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJ0ZO8tVsX63PTkbuehFWFQ5H5Io+PO6mAdzl1iHsj0=;
        b=bGzW4IoyksDJ7YvqTdjRGNQ/opzFJnsDKP9uBl+PiSZHaa0gYNttiYa7zQDUChg63D
         ap6MlPVSFJ2fxKRugbnr3YeWqiDW9bBTSvqTZL45VnEQGB+roxcl4vYF4rlRJcwmNijh
         E0sH8vSVDDVng59uUKuJB0BTvjnl/bH9IpCcmGvStyJ/T4xFemTBLCwzuBazSpN+FLnH
         sfH45kEq9nQPpvG9uzedx5r97N0Ygq11jUFfX9TbuihEmCy8r2lChWv1EZvqHbYYyu3e
         RvW/xYmQXVydnB40CGUpTc/rPxsHhEDnN1wIRqDOWJejQxMXHVvcz8jltIvrSOwCb53X
         fuXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760061658; x=1760666458;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZJ0ZO8tVsX63PTkbuehFWFQ5H5Io+PO6mAdzl1iHsj0=;
        b=LVvatbi6SW6konW7cuvaDlrUCGmn5D42MTKfv8kEBNPKjXF3E2KCbyFqyTPhUTzm12
         OY5cII99zF8CZAONFGut0Hh5ZwXiCmzc62yK9lZSfonTChLCpQyzExWqqBqT/Rd7UFTb
         lUPF4QW7+/vY+gWesRifSjpLaOeWFdg2KCu1ldPg4KJdYWqzbhQ+yK+5DvEMpCo/yzRZ
         tcjgO5S0MSkJTwVQ83/nwyfVEIPc1MUMLz63TNNfgx5QtHx9BKnXSKsumg15yk4ObEpB
         KnK4y+YCo8X7CdCOzj0RERmFLRw1p4E8OL24WOyuDF4Px7GAL7IWobzJ1YWDB+ZpTIGZ
         I1XQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTzv73UcVbLaq+m6jtTfxmbeWpH67Mhb1dG1xyMKpXIIzU2oenLNRCm2LsPkKw6lKx2tLnRyRdJ9XW0g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzBLB/RXSyESHBaX0dHmCwbO7fgDXiuHiqUzVLrqpTYO6GdEHQI
	wvyMS+pTHUfsRz1n/niKi28qdvGaGPfBOnJiXsI2juW1Q+RKSGfFFqYpsGPVaFaPn94=
X-Gm-Gg: ASbGnctwNYEyVcPRBlWZHuqwZ4zHJ6ETg9P+2rqTWHdLCssz4Hdk688+L4WHuaH1/BQ
	NB2B+3d4y8EgEEIHaHQiSj8ZguMy7nPR8Jyw+BbG87M2pom2AXic6o0vhNLpFkHPZMYZWwVg4S5
	/wYo++fFCxnMhb8rt1rWc3KUUWZyMR7pv7hTRnzjcX3L5MYf2Pk6jPx/h9FsR8AF1tt71lSAp3l
	J2t0mR0+o76uvUm0WTrl9gVM2tjoJvbWGoCVgg2UuALB7RIJ/+zJ/HtsocrxgPUdHYZcME6TFTd
	GjR96RXBPN7xIFzzbFkLdKm9hUVZVxIpyL6vFLjDuNm6K4ceAU6u2w0gAec7QN4dU1P9f6ZWI1U
	SKtsEf8Ni0SzG5Z49PF/ce4TBkD+rnKg6ekEiH4OcSNyAEzid2EtslzmV8qN5Fs18baHWh3CDup
	QC3LX8voWxwHQIw10xeoYqjNPA+QU=
X-Google-Smtp-Source: AGHT+IF4/vxKx1CP0CXz1kH5ziINSy5FUdO2xGkIxifAZOS1HIvhxqzvJEmlrdJ2EGLNh9neLRf/JA==
X-Received: by 2002:a17:90b:17c8:b0:329:d8d2:3602 with SMTP id 98e67ed59e1d1-33b513b389fmr13709247a91.17.1760061658518;
        Thu, 09 Oct 2025 19:00:58 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:cfc5:62ab:555f:ccdc])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992db864c7sm1073619b3a.82.2025.10.09.19.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 19:00:57 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ocfs2: clear extent cache after moving/defragmenting extents
Date: Fri, 10 Oct 2025 07:30:49 +0530
Message-ID: <20251010020049.523924-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew,

Thank you for picking this up!

For the Fixes: tag:

Fixes: 53069d4e76954e2e63c1b3c501051c6fbcf7298c ("Ocfs2/move_extents: move/defrag extents within a certain range.")

This commit introduced __ocfs2_move_extents_range() with the while loop that
calls ocfs2_get_clusters() (which caches extent data) followed by
ocfs2_move_extent()/ocfs2_defrag_extent() (which modify disk), but without
invalidating the extent cache afterwards.

Thanks,
Deepanshu
