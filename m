Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E1E1DDC36
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 14:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736172095; cv=none; b=Rhnln1bkkl8FZ7qVCxTsRlKAIEoVDfenmhZr/u2hBv5MWbuBFU+Mh+Lf/4aWfR7R/0mIUXVlh93j2YjVjjfgP3unTvAVyt36WXjfdJrYjRPyc07BTPBf1jTmA2HYRSRiDIv7M7puL2LME+DN3xqyLIaWuXIbvBiMUG36txzOBxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736172095; c=relaxed/simple;
	bh=ustdWhN8B7AxEmjNSenhEvMBMTZjhkclrTBp50RGrv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P8qRsRW4SoKht9wpF8CUHNjDcqq00OSIJVrHB+D9HKc6TAu2jpMUdR/n0Xcp5M3JjtmsOeQ57WiISMLy1AAvW2S8PB7f8CaZI1OkVJ2le15CscLBJmw+xls8OeAEmvn1eyIWh7rWhSbhjbBqng+LxcfRUx2HREvrwOrCkqX5K+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HXsVklPv; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HXsVklPv"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-385ddcfc97bso12203519f8f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jan 2025 06:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736172091; x=1736776891; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jhRAQfQjH1uGJhH2qOUgRmb0lkyZNgt9BBAljl/5XuI=;
        b=HXsVklPv5jd5T0Y7GLzICCujP3EsZFx2TW7rDbtIxA6VPlj+5qiRVWPNPLQhEJrp1L
         wabc3gVEvgwWhJ3mRnzZCrY6S3852fhqc+amcSNPWa9x/9tr6Wv2GHBeuZHUHgffIeG4
         P3tdVQ7VSoLpS8aPUCm8cwRCsrpP/gSoO0j8ZguYgA6h32fCHQmwe4mw2PF1VL8zca4L
         9JIjNCygl4FBPqKRqoEQQJHq9mXAYwjxk0F43rrbHH1HeRO/EGWUOLQDeRrujHFa1qlR
         /N7Hn+xzZ+78dV9vYAFKdUOBdOhjs9XxkF2SOJ/T7aINbX+JKmrLSN69v7ItR/5F158X
         SDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736172091; x=1736776891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jhRAQfQjH1uGJhH2qOUgRmb0lkyZNgt9BBAljl/5XuI=;
        b=GGi3L8nnfvxcCh/ZX4XVpZ66huTzYNEJQbm2vl6h7szxNSKwcX+QKPesdYn8QcUjD7
         6oTtQrCwXi2z2VovytXypva0e34wuVOMtmA9Jb7S47uKTgR6arY9Lge5xJiXP9Lof5jy
         X62ln8tlaI+2dPeCN8jTHXOWJSw62sYVhLKEufEddaH9/UbLC0RwHVSXmK00VmsFC1Bv
         mCQa30gNt7prDIWCV8EEAkEtqk+X+YH6UbXF1dzcHOfQvG7PTrZgU8zlOH1w3WrwA6zz
         ZoFKCZqLXfvdIg5BmGtptajj++sz6XCm4TAFwsrDE2ietgRDR3nLIEGAARLkIMmaRHGY
         Kstg==
X-Gm-Message-State: AOJu0YylMHPtK15jNfwbgyYk+tEuEuVqOPay/3FC9XIEl77aYPrJbjPR
	fRbRDx/zdZbyvJcxOQVHEpFxEiFsuRQuRTuycszweclZ5RgPFRw9d6W/fIX2kpCYd9HIq3UATIk
	Jp7Y=
X-Gm-Gg: ASbGncvjtftlyhWhwUdoyyMFp97kDICRq0i0WuOdOzPJl7vocpjcZbsWoHu2A4mNS7G
	Anmz2bGUbuIH/QBOCaSV5YPfMXX42wIV49Lbt4BEC6vp62JNVWtK3Nym5qW61ylWOJ70ymx0hS4
	LFaPM5K9uDPXiojzI3EGKgWqq+TBkD4y2lkwPs0/uv3zh94YSYCBsrjXCPEW7SxNPm0LnlTt9oj
	AVfkAMSZOBEcnfhmuwvvPZp/6PTtCUcAjQ14NAxi+ceD95Zyop3+E/3
X-Google-Smtp-Source: AGHT+IHPYL6GOfFsut0WtPgHEJwsoPCYaLQ0m68SILlMc08KM4u5gSm96RDuXyNjPH0BjrDHmWVhBg==
X-Received: by 2002:a05:6000:4603:b0:382:38e6:1eb3 with SMTP id ffacd0b85a97d-38a221ffbcamr41054462f8f.30.1736172090857;
        Mon, 06 Jan 2025 06:01:30 -0800 (PST)
Received: from MacBookPro.lan ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b9ac478d9esm1512704785a.77.2025.01.06.06.01.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 06:01:30 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: fstests@vger.kernel.org
Cc: ocfs2-devel@lists.linux.dev,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] common/quota: filter out option projquota in _qmount_option for ocfs2
Date: Mon,  6 Jan 2025 22:01:24 +0800
Message-Id: <20250106140124.91928-1-glass.su@suse.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2 doesn't support projquota but does support usrquota an grpquota.
For now, two tests generic/594 and generic/603 are for testing
usrquota,grpquota and projquota. The mount option 'projquota' causes
failure of ocfs2 mount.

To make things simple, just skip the tests for ocfs2.
However, we can't just put '_require_prjquota $SCRATCH_DEV' before
_qmount because f2fs and xfs need runtime after mount of SCRATCH_DEV.

For ocfs2, filter out option 'projquota' in _qmount_option() to make
_qmount successful. Then in _require_prjquota(), ocfs2 will fallthrough
as a no kernel projquota support fs type.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 common/quota | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/quota b/common/quota
index 8135b7c044bf..8688116c6547 100644
--- a/common/quota
+++ b/common/quota
@@ -325,6 +325,9 @@ _qmount_option()
 		OPTS=`echo $OPTS \
 		| sed	-e 's/\bpquota/quota/g'	\
 			-e 's/prjquota/quota/g'`
+	# ocfs2 doesn't support "-o projquota"
+	elif [[ "$FSTYP" == ocfs2 ]]; then
+		OPTS=`echo $OPTS | sed -e 's/prjquota//g'`
 	fi
 	# Ensure we have the given quota option - duplicates are fine
 	if [ -n "$OPTS" ]; then
-- 
2.47.1

