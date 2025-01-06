Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6A11DE2DF
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 14:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736172089; cv=none; b=kiLY7gfgkJc18xkxS/v7P4tDcX8Hcxs5F6xn3VDM8vewHowDuUn3GR7I2f0PEtgIcG7ENEqZ7MKpVVFU2vftvBdNOl7p98828vBcIHKgOmdEst5dgpqKIPFC9Lj79wB+eS3PcZ878SrQONw5mEjaHQz9yCX+aO+dwer1d60rxCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736172089; c=relaxed/simple;
	bh=ZZburt9AJEajz5k7XXnIEvai3PBklSgMjuz9a5Mf0cI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D9liOVaUxhXh0LmqW6G0b8zv1S52Ma1XfdVEe/ZSflOiqVkf34mOpwBSRWgYJwnk9E/XFZEkbwLSGAcvc33GloQHcdJLA95ytaRfth+UF275xtU6SeVxgCyYKgT7WiAWoGjVs775hJLETvIaCGZiBlk7JVV5yy/BdXTlq4EJ0Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g90szsuS; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g90szsuS"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-385e3621518so6701012f8f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jan 2025 06:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736172085; x=1736776885; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LWSGs2y6f9x6GdFKyNtGUXQtCcC0x80vP1gQ2rVmqNU=;
        b=g90szsuSn1aywmDKzw6SlwdRy4YRD8uI333wKFc81jj+bjCOEGvrj42Ex1RCmEqzid
         M+zAQTUNoc6OrfgB7BaFwGCobHoP5O9aweeyyBrf5CglOLikpk5tEnNGdO4n2hyg17JF
         /VH+HLhDz7dUlkEKb20NEqwAxvvpfT/mzf+V3/o9vW5GzhTz03BlBK5zDE90VCln+6Kk
         6UwyafTDaPD3cVsOTA45glygSUgrgaoApfdeautUcLx+SLAzqm0JqEECQUJKyjPy2nFI
         bPTIVc3h2Y/wT0c9m4venA96GgQVHi1UuXp88Yt1ANKk3WmhJKIm4ARnK+IkOi19tWo8
         lmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736172085; x=1736776885;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LWSGs2y6f9x6GdFKyNtGUXQtCcC0x80vP1gQ2rVmqNU=;
        b=keFOBPS/rG8g00teeiV4W/WNT22atNgwPbePtZFSTv/N+s58UCat+RFa537m6LK5Nj
         djGqwzacdUeBmof5qhnwcrILlHkbkWVD6sKMkVBIdvJq2cShPZO52dACs0L1MwudYyHL
         +tq2DyINOapeNPeINUXjOluDSe2mX3Nkh3MJCIlKxvr8EE7rVfY4HW+Uo9zdqaljFen+
         L1qWhaI6cjaSDnm2X67dgltg8hMXclJqzFQ+dT/KPuuwfT/arG0K/iXX+e9vf9BSeyIf
         X2SIWd510DTX0tVDQHs9QcYV/z41u4EPh7omnh1wv+ww+jdSDmIvgLKnNrsTtbJZU3tm
         VlBg==
X-Gm-Message-State: AOJu0Yx8oNG/uipY/M0eFmD47yDJs9odA9zIe+xFXMPG906HbcS7sjTP
	tgo+H1V6A64MIfL3oUAzeOLuZXJNfaE0GiZYrg7Cvp6KKynaJ01goRfWl3ao8ndXIMJ4BoTZotg
	/FGw=
X-Gm-Gg: ASbGncu8vs/1TNXG7nxGFUR97jYAqRigdacqYuGakqjh3bj/j6yb+J5jXVk1pi0PCHY
	GKMDk1Kbh/NuHSYsToDpssk45KobrWkvqcp6OyJTMfiq1TYFtUUz2wv4aR9/EIBMAwtShOqeuw+
	OJ6uvokbsvOWhjC5Xlm6sae2k4K8shZQuupIUj8f8NqEIWDCL+S797ySu6zHkGKAQMPGg/HLLMC
	BuWmOMoSyjn/p0qC8F1+eLM9EJpGFsOE8zvs/o9u31NztGNT4BP+Bu9
X-Google-Smtp-Source: AGHT+IE9TRIUNkcxWhGiBmroxbENquL0ntE/RsJlK1w3HEJC8ySJH6EbR0D6336E1VwiHJq2HY4EZQ==
X-Received: by 2002:a05:6000:1a8a:b0:385:e429:e591 with SMTP id ffacd0b85a97d-38a221f1c81mr42553374f8f.23.1736172084387;
        Mon, 06 Jan 2025 06:01:24 -0800 (PST)
Received: from MacBookPro.lan ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b9ac2bc4b7sm1511188585a.12.2025.01.06.06.01.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 06:01:23 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: fstests@vger.kernel.org
Cc: ocfs2-devel@lists.linux.dev,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] common/rc: add ocfs2 supported timesptamp range
Date: Mon,  6 Jan 2025 22:01:18 +0800
Message-Id: <20250106140118.91905-1-glass.su@suse.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2 supports timestamp ranging from s64min to s64max.
Add it to _filesystem_timestamp_range then generic/402 runs.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 common/rc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/rc b/common/rc
index 7b5bc0b45047..3a38a7ad6196 100644
--- a/common/rc
+++ b/common/rc
@@ -2690,6 +2690,9 @@ _filesystem_timestamp_range()
 			echo "-1 -1"
 		fi
 		;;
+	ocfs2)
+		echo "$s64min $s64max"
+		;;
 	*)
 		echo "-1 -1"
 		;;
-- 
2.47.1

