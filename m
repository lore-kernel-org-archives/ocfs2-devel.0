Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742BF1442F4
	for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 11:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711883883; cv=none; b=h25R+NxIPFE1TgL/3Et0BoX8ZS2gkCqG/xXplBPCxFGZrJ+eZNVBoBnDDvARUqBK08j25bPdF590DSkTRcgEMG4kjzZg6odPnvAwTqYLelxLOKp+uf0BpRLM+15p7qwdZ8qPkSAEJdFywbpionwhPSA6tIX+zAiK3b28/lmgUl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711883883; c=relaxed/simple;
	bh=JgpL/G/F6CrmkG5EEHynUBqPN64JRwHFEJc2OPmSABE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=byTulBlcw2ATIvnn26FHTCyQp4RPhrMqYpMWVNwTDZyrY7AM4gyg3ynmRdCRYsmEJfykFf9LjjYgOY59kWFizWJJmhER8dqkcRlNXpCGdOy/eCi1wO0ZjtejJRvkioBZ0upyXhqizC9rdXTWA/HgLLuZnqfOGe59gQNP/tgbWFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a30vCrmH; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a30vCrmH"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d094bc2244so35711331fa.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 04:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711883878; x=1712488678; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aL2CvEX520MT8IlZu5sCitahhnvRs+a2x0Rfm6++i2g=;
        b=a30vCrmH3kiQ/Kdk0mQQZqI0Qcre8+s1ShwGrPwF3LrkEaYCyIIMHLBecTagpwi7+y
         zEbguYFKBqeOqQaX9F+3AjzAShkF/Utr7glYptRbPne9DO1mqMAp4ZlmtjNF45+aRPtt
         QSCfqMZ3tG4efGzQN9jafSiG9uVHdLkMO16wuHNxy3GdJHDMRdog0jeVTrgdkdiam+Rn
         ewKK7QYiv1J6DoSpwKstQ60hVBHKKL/y6PIVIbgmmqIP9Flr7XvTjFTnySIJkZ1LFOHI
         5wK+EPNFbwHyU3cPy9sBbglUKLPk/r788MQX8u0ltu027JlGz3PLC54Tkljf+YP4pMz1
         TAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711883878; x=1712488678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aL2CvEX520MT8IlZu5sCitahhnvRs+a2x0Rfm6++i2g=;
        b=HAMhRhEMcadVkO/ZP2NwWcUPTeBUj1R2pCQM3MomOL7uVns4I8MkuK63ehXpDMcRCf
         Vx0zaRE6qQteaSb9bAO7taovnUucquCqrZQkT3j71129AozxjQWdHynY3au0iMMQr54f
         VWfMkonOAHXB2EVkNP+Mc+mxlcvUVZ4G9Pwchyhs6PqK7ZMnn1o9axEuR9VwhvSNeQyH
         gFIJK6JWtBd2wi5mH20E2PlaLmT9TS/OVBcvkGjVHA/LklFEmy7weko3CdgEOGB3R9BN
         dN0+RTesO/ZJaea0qa6BTh2ZV2U4dF4C/Gb0FP3BKfoobyLguMMA4nu1TKmLdWHqtkqC
         DQkw==
X-Gm-Message-State: AOJu0YzBzhH5h1bGzo9CFwjPXFCjTW5LjxY/rob1I5qY2wPD3izDCt5J
	PJuS8JvkmNYmHnmdD6mn2V76BMmKl/iTq4gppp96bCt1W32MFmCJC3q09rvIzhnUfqRbr21Q9N3
	T
X-Google-Smtp-Source: AGHT+IF7HbHv+/MkrtdVfQGqzPOmpUTcJQSCuuLY0YHRpOWft2Q1X/4qZnpVgquGrNVl1fENFlSyHA==
X-Received: by 2002:a2e:920c:0:b0:2d6:87e2:e11e with SMTP id k12-20020a2e920c000000b002d687e2e11emr3782113ljg.8.1711883877936;
        Sun, 31 Mar 2024 04:17:57 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id bf7-20020a170902b90700b001dd82855d47sm6675406plb.265.2024.03.31.04.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 04:17:57 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH 0/4] ocfs2 bugs fixes exposed by fstests
Date: Sun, 31 Mar 2024 19:17:40 +0800
Message-ID: <20240331111744.7224-1-l@damenly.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Su Yue <glass.su@suse.com>

The patchset is to fix some wrong behavior of ocfs2 exposed
by fstests.

Patch 1,2 are about aio+dio vs hole punching. generic/300

Patch 3 fixes inode link count mismatch after power failure.
tests/generic/040,041,104,107,336

patch fixes wrong atime with mount option realtime. tests/generic/192

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

