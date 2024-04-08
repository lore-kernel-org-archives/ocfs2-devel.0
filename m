Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D704A2030B
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Apr 2024 08:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712564460; cv=none; b=jzlKV3gWXLM5iej43V7srIjAklpcIhurbOE6K3j/rTyNzzfzFGrL/8K8l2dhUKX0xQHWBLRPA5Uwx+0kTCux96JakmdUIubL0MyYlCqJsYPz5CjxR1thcFOpswC0H3UOza0Wqhka1ny+FMTSIcHXVgidczLlNIiZ1pIocEHSeSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712564460; c=relaxed/simple;
	bh=62ESMSOfVym/HaXxpjmj7w2fLrR3LSkGQe63j7uQHGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IG7BJcNQOB1EM5pz4Iwu9LSYxO6lLlPG4NqssRX4eiL+JQK6HGxATYI7GEqnPrWOI2EgU7CZ12/+EqPYjvcLZhSRb5CSJiLoC4w7o785tEY/pIxGtgODlkMGuoCuMdRbqar63TagRFt7rkQHSfSqW3BRnTNobgWRE9TK9oa/57A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cq3A1JzN; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cq3A1JzN"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d88a869ce6so12232251fa.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 08 Apr 2024 01:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712564455; x=1713169255; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AXOUKM3FtD3sjWeTGKJp3uBdL5W4SoMITUa85O6lkEE=;
        b=Cq3A1JzNzpQVYTkcYv2LXn5QxvTDKhp4EpC1pz3mnh1kFPX12IC90ufeUc0mINP7G2
         EMlxXhPEQYXRFYkKzixylKllPUNcsLdgdjmBGxz1vDCup3uOK7vQQ/3Dnv7LE0dDyWGJ
         u0cIcPFr2WTrxmiKFTivATZ20I0jtjSdKZUvBoKnxZN+owhwbzhZgeVHSFnZarxBGlna
         OlZ56BELk9ImG3fej2jM4y31ezYf/vcp+jH8G/mSra6aOifdKvJI055iGwaLync+y3qX
         c0ibg+1yswZ6HMlX6jTYKu2MmwnFpynsQ6GVRAM5JfNTwMnAxNuFX4mi/b25cPybmopD
         5C2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712564455; x=1713169255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AXOUKM3FtD3sjWeTGKJp3uBdL5W4SoMITUa85O6lkEE=;
        b=cGcmQPDyWsiagg8FyFKugStrFVOPIGZP4V8ZGYGOisHTtKaIkZ2ayhjws5qR75GLtR
         9Wp/y/oF+qTf9lfiuZrNTjCqh0p9fyNe0YS45TQqh8dubG9QpsWQfz1+oVFw0BUFU9fh
         AQIFIb+X4lSdRx07z701mCZwkkQonyUsk9VFZczV59yQ7tJaAnoCVOKv+eF+AMf6TXGS
         9kPB89AZSsgmMler3TKBhIXdlogFHga5l7CyJG4VKigycRIII1btmMgOOArz31yrRIfJ
         zDJbl1BGYSYhQKke3/JznUI+X6GkiCUU3y0O4PkfHUEppHjUu9X2uVGFKDH/b9kX1yZ5
         OAeQ==
X-Gm-Message-State: AOJu0YxV2dS+XdPruIyPhol/5r/bL2f6tbk2FwKylpXxvr4MZjgklCg1
	WkVC8W4UPz1D4yaBvaNdR86y2dygQsacIMXpTX3ZT/hq4qgwoGrkKYHGJcpJV82kPE6I2oqqHMn
	4
X-Google-Smtp-Source: AGHT+IGyt1BYyAY5omHJ7aSpqCOkXFo0QLSLIfRVztYO2g91Z9YqgcrWlOWNLggtUshHbe5W9ERmVg==
X-Received: by 2002:a05:651c:1420:b0:2d8:6956:d4c3 with SMTP id u32-20020a05651c142000b002d86956d4c3mr4369878lje.13.1712564455303;
        Mon, 08 Apr 2024 01:20:55 -0700 (PDT)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id ft4-20020a17090b0f8400b002a54c4dd0f2sm213894pjb.43.2024.04.08.01.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 01:20:54 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3 0/4] ocfs2 bugs fixes exposed by fstests
Date: Mon,  8 Apr 2024 16:20:37 +0800
Message-ID: <20240408082041.20925-1-glass.su@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patchset is to fix some wrong behavior of ocfs2 exposed
by fstests.

Patch 1 makes userspace happy when some error happens when
doing direct io. Before the patch, DIO always return -EIO
in case of error. After the patch, it returns real error code
such like -ENOSPC, EDQUOT...

Patch 2 fixes an error case when doing AIO+DIO and hole punching
at same file position in parallel. generic/300

Patch 3 fixes inode link count mismatch after power failure.
Without the patch, inode link would be wrong even fync was called
on the file. tests/generic/040,041,104,107,336

patch 4 fixes wrong atime with mount option realtime.
Without the patch, atime of new created file won't be updated in
right time. tests/generic/192

For stable kernels, I added fixes to patch 2,3,4.
The patch 1 is not recommended to be backported since
ocfs2_dio_wr_get_block calls too many functions. It's diffcult
to check every git history of ocfs2 for every LTS kernel. 

Changelog:
v3:
  - Add rvb to patch 1.
  - Add fixes to patch 2,3,4.
  - Descirbe more in cover letter.
v2:
  - Fix typos and amend commit message about the functions called
  by ocfs2_dio_wr_get_block in patch 1.
  - Add rvb to patch 2,3,4.
  
Su Yue (4):
  ocfs2: return real error code in ocfs2_dio_wr_get_block
  ocfs2: fix races between hole punching and AIO+DIO
  ocfs2: update inode fsync transaction id in ocfs2_unlink and
    ocfs2_link
  ocfs2: use coarse time for new created files

 fs/ocfs2/aops.c  | 2 --
 fs/ocfs2/file.c  | 2 ++
 fs/ocfs2/namei.c | 4 +++-
 3 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.44.0

