Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDE01DE88E
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 14:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736172082; cv=none; b=Mmg7/7Qt5j8EfuHDpAN1zfrgfuxB/zX9vLKxi2nHRsEvZSOsZFDA/WPnEw3YyhAbDKD47sd7f89M3VBjt8NDtOR+Uov+ldxftLrlxzu9xQ6iGUR9RjQAZ11nY3ChCrWunmPIH4SqzAKLHQUHKa0qkw2U83ZfQMDxvkDnADKk4A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736172082; c=relaxed/simple;
	bh=weSaS73iLOjabmsNDp4NbPiKtfGOrG83nulZ6GiKVBI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RT4vc1cv6Z2KyPa2y8y41KSeLHbjI62UreKd/VM7+WC8ifxDXTyKniZ3FmY+FDA6j35AJdMnP9NaDiyBIMfobOZ8wHax0jfPQl64i/526VaOX50MydgalzLeb2nKNo4CZXoc1YjDALAu1Lf5xDveyRGH9pDDF3plmPvSiYPPLx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=In6VrYbZ; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="In6VrYbZ"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3862d161947so6848431f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jan 2025 06:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736172078; x=1736776878; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VtJFxE+ALM3Spv3q9VMkafBFERfb4RbEXw3ei70PFA4=;
        b=In6VrYbZJddIYt4SkqlU1oHZhcim575c5hdh/YiHkYELeh7gfBOG7IH6FCjjwH7JjN
         16uJxgfZGHFBrKYcENjOJPXHSGW0iJgFpkkOmSLofZlPbnJEOZE9a68oj+KG4pJh/SOG
         2hL7dq+3N+/FnDqkCA1F2qkrOCEpoDXmuag7bpqflO2DKFgGY4mcf7xpUAfSu13MR9O2
         GJTBQh8ECJtoV+7hL1VvB6XXGSQVgePRZHxSQDvxeXyRdd22U/amF85/vNOsp1S8YlO9
         O/FH8Q7DFqmTob+s8anH5sYdg3Z9JAe9dl6r4UgTxrKW6NQyqQdXNrmhuYMyFmARMWSF
         6wVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736172078; x=1736776878;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VtJFxE+ALM3Spv3q9VMkafBFERfb4RbEXw3ei70PFA4=;
        b=F4cji85QBv0q8O6U7LqyiK0H6InCAHM2VU+ooN3oasBIUOmcK3+elaZE6DHIWsd5AB
         JcaT9nJS9vLhr/u9P7Roq2dFuBB0equRb1UMkBcc5SyGsV/tfsWaWv6dKXX3YuMJ8duD
         /IXk50ZZvuW/IHHHzIQUn+XETjNrm5Dp0N+QeM+g2Jd8lQHZMYilbIC/ELnS/0aa6Hps
         ZirYod40gTJUD/USF9hocEroKl+HSUOgjAMPwD5mVKON5K4Ejju79a35RjHR+eQIZ1tq
         TRdxB+bWsCBzDCi34ZzUthggDYD34n/DH+3iface1BJ05+7laLqi3pjtQ1+bQaG0zsqz
         N+vw==
X-Gm-Message-State: AOJu0Yw5GydHPz1w9rDj+7voYTdMpJRJhn1CwW1C9w3rWkSClOE0qdr4
	ymar5pRWMhe3xO0j1/YZ5zeR0wcKme+9AmPP4j+M7WxqPZI5QnhDrWgIa4ZFZ6w=
X-Gm-Gg: ASbGncuRgB99Fb32+zzBPfeu2OH8PYC3m7sEX8BzU4IUpLlvmrqxMOa42fBkMvgkMNa
	gbptcim8wmCeyuffb0LzhJ/K7bpBMNsvy8U9jOQh/JgC24wWgyCL3psq4vTuAcxGz2R6CYWZYsG
	jbIiwetVg/CUewWFeRcx5mH3Z5KMgtUzp7iRUFq/aYIvDPbJZ1a99rjWjnJLps0m/7Q/f6jMoyq
	Ye3l0joKYhGJMrTV3voZ46odwZj9yb/rhEd83QxFvNxvk/L737nJes9
X-Google-Smtp-Source: AGHT+IE4N6dd4N2bbEQe/0ddWHEm2ObeRRkdj4+yqbu76BwyuRc/pRDJpAy81wZx391QZESD9p4klA==
X-Received: by 2002:a05:6000:4a01:b0:385:f6c7:90c6 with SMTP id ffacd0b85a97d-38a221eac31mr51624871f8f.20.1736172077937;
        Mon, 06 Jan 2025 06:01:17 -0800 (PST)
Received: from MacBookPro.lan ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b9ac478be3sm1505382185a.74.2025.01.06.06.01.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 06:01:16 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: fstests@vger.kernel.org
Cc: ocfs2-devel@lists.linux.dev,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] generic/620: add '-J block64' mkfs option for ocfs2
Date: Mon,  6 Jan 2025 22:01:04 +0800
Message-Id: <20250106140104.91880-1-glass.su@suse.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mkfs.ocfs2 is using 32bit journal as default.
For 16T size device support, '-J block64' should be used.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 tests/generic/620 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/generic/620 b/tests/generic/620
index 3f1ce45a55fd..60e5a2cacdda 100755
--- a/tests/generic/620
+++ b/tests/generic/620
@@ -41,6 +41,9 @@ sectors=$((2*1024*1024*1024*17))
 chunk_size=128
 
 _dmhugedisk_init $sectors $chunk_size
+
+[ "$FSTYP" = "ocfs2"  ] && MKFS_OPTIONS="$MKFS_OPTIONS -J block64"
+
 _mkfs_dev $DMHUGEDISK_DEV
 _mount $DMHUGEDISK_DEV $SCRATCH_MNT || _fail "mount failed for $DMHUGEDISK_DEV $SCRATCH_MNT"
 testfile=$SCRATCH_MNT/testfile-$seq
-- 
2.47.1

