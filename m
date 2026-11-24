Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795496111;
	b=JssFe1/wnOBsQjlLeXacJ+30JIRR0EjUYvKF3IgXxK9S79udPtSc2CWxpDspbqwmIiKY
	 Lym4KLc0SATlgFNOt+6PNVTsyIUVvV/KkevWtrp9gGHZ8jxsElRobQ4W/AwlFDPBOj3+d
	 3xXXFSnKSkX2PkXUo2MDygqr2TI1xtTwMS5dFHoXR02Ozao060l2XgNY2cTkiVkBSstuU
	 uYdcS2uz94vimp2kfvJ97w1fI0uMyouZWK1aMTkGVZR+4lqWRi/98wnVGe12FZF+NK7ES
	 NU3G3tyi1cILsSNiggHKHkNWpKEQEB2sQJC/N8SDoVYMuj1NGcrwcFrJajcPzVQIkzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795496111;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7aUybPiPpUnNn7ks+/w9bKIAWuxaQfEdz1JAzzHLFhQ=;
	b=nM0L5Xmw6Z/4UCyW950oMcZgaknQVY/nNQ2q9Jvjh8MIYdDelWiv+9aKjD1P5fmbBjqu
	 Rb82Za9dwmeLkH0jn2RGtZp6ai/pOjRmVWjcKG++qZbp+dszWfh7Mcx3TzyFRJNF/ydaU
	 AgLFEOxaTAu0pMxzhbLQzzc53V+un3oyv/oF4Z6fyGnI8C++PjPyrvJKHeuzjhscFm8d2
	 V1oBvg216QBHfw2PFvOrHq7EiJPbW2VLd0eLZHyvKk/8Gk+n98vpIIB/0QXf6kha0695X
	 jro3n2vp4BMfcpXi8fToSGyzLY8zmAIeDDfs2gfRtojQvmA/dXGHAZ28LicxxSwX+sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FMn3ozXv;
	arc=none smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112CF606A321
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 04:55:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 112CF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FMn3ozXv
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6ba1e6068c3so429644a12.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 20:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795496109; x=1796100909; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7aUybPiPpUnNn7ks+/w9bKIAWuxaQfEdz1JAzzHLFhQ=;
        b=FMn3ozXv7wEIyar98wuzwxPuPpJjKMLpz35g/OzpOCpa2Yc+mBH7nPY80Vm9fk3Uw7
         NDOwajY0UC0Mv0fOXyHABcUE+xTJFYhAjX1JNxCawCsH0uifIk0KJ39PyHbxAp3vQNm6
         KjpXXfo9+I51hXSycZQqZIuslpszvbPJcosP7Xnk86+iEgfpw0mP1gymp3CeCStrvFou
         rNjvyjVB4wbJ9lijOS8Y1W29e+NnR2ey8Nwjq6reeWLnjukHfbgoXJlsEGwaBJnuI4L2
         kCFH1gp9dPhEBcDOkqai3iUyPG8VAkRV/t5mFPgwXXO039mk43eMwazlpuj8fyciJBgt
         zDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795496109; x=1796100909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7aUybPiPpUnNn7ks+/w9bKIAWuxaQfEdz1JAzzHLFhQ=;
        b=gDYaCdF3Z9dNcH0CY7FU45JGojvwJFc/8kEMUSoxDldoRIj3Qqd+wqGPrDvsNAacP1
         BOGBn9iydRKeOu9M1P1F+IwAC2Z3aKT8yzjxXyY7+9dJaxkIJOpBBACCKgpBj2f8tfWK
         be5EJ5Zk9ZMaLQZg776oSLKsZr/lK22fI6AEXbRlgXe4mC9Qb0gAs7TgtH/CoLRLG38j
         HYgwyK/zuH7MJYw5PJCopvEaY0guvhXWs7KMSCWMK7+FhVvEu29xdLIvxWGkJO7p+jXt
         FmHRz9tuZrr4kU170ASMf1HUa5mwEbY2WkWLBhZohdnrc1pBBZAdYRgFQvhLfZc2/l/w
         86wQ==
X-Forwarded-Encrypted: i=1; AL+hErEAmxxJYWXuAML4uHIRZT5yDg5slQaFlSWldcL3aCq2Mb9O1gvb6fgROGoRrh56CD6G7FLkUIZSFgz2tQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z/zCEHDsr94tr32z9FOTeC3cWYDKukUQFAFN8xzZlH+p5LQKU7W
	SelpRMzp8b3rfZkt0h+ccfC+CrSFE9ycMn1lDcp/Omr5KUiAcXd3fZ38+Qh2WM4rGEQ=
X-Gm-Gg: AZFdTZfsD7lhbecg68ZF7jPKQT80sYrwBNZLTTvXj4lfT6rL0iGxZqIzSXKlBxGrAC7
	x9TGIywqFZQB1KUTSPgxb5OppEiwbgYiCDns+YSsjOXRT4OxHD173Myk1w4EnFhMNffeRpQJpgF
	LKjtoDTr5kgipwBICJA8idjkuHRIvSV+ytFkuTPlzimPoZIdbu+AuIklB1LRQCQ8hIZvjxe9egs
	Sd+9HG69FStkPNbXxeI377BZbYMdtkTy65pJP78zMW1L8JAxhLJgLxTtosqop9nGmQFlko6cDy4
	+1WiGwmeWIRgbOXfIpR2AFRPidC4Vh8yFzYY73WsEaN2/4yrLKRvl+nPEnpv+6ifMJjd7KaPPeP
	1U8A3QlpM+55lJUBeTWWzqGBJHRGaAFxgovfMNbEzYpgPaQ9I7mEle61orWH4yK13KDfYrU9iZz
	92mDX+IL73eWQh0firKLdtXxN+gzS+6/mg5yeGt4+RbfkZfGrbbSGRsfnexrTkP0YtP5H8tdDHE
	iXcwSG7YnAgyEgkbhascLddIY61P1QRs0uyQJokRx9DvLSeHibv4qtcVRRLP6NLGbxDSEI3zQuh
	oKgH5n60IqaWLudz3v+TslF/930X7o0hxBmzEGKfR3M=
X-Received: by 2002:a17:906:ad93:b0:c41:8e21:4d62 with SMTP id a640c23a62f3a-c513a4391ffmr983299466b.1.1795496109341;
        Mon, 23 Nov 2026 20:55:09 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe23sm20989085a91.15.2026.11.23.20.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 20:55:08 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v10 0/3] migrate ocfs2 DIO from buffer_head to iomap
Date: Tue, 24 Nov 2026 12:54:56 +0800
Message-ID: <20261124045501.10281-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set migrates ocfs2 Direct I/O (DIO) from buffer_head mode
to iomap mode. It is based on commit aebb72744764 (v7.4-rc3), and
also incorporates Joseph's code and ideas from [1]:

V10 changelog:

patch 1/3: fix a typo (gridge => bridge)
patch 2/3: fix commit log two mistakes found by Joseph.
patch 3/3:
- based on Joseph's review comments
  - ocfs2_dio_wr_map_blocks(): move the condition check IOMAP_NOWAIT before checking fast path.
- based on sashiko's review comments 
  - remove comparing line in ocfs2_dio_clear_orphan_locked()
  - add re-accessing i_size code in ocfs2_file_write_iter()
  - add a comments for del_orphan inode pending issue in ocfs2_file_write_iter()
  - reject unaligned I/O even when DIO falls back to buffered I/O

--------------
# test report

This patch set has been tested on 7.4-rc3 kernel

## ltp

runltp -f dio -d /mnt/ocfs2/

results: passed

## xfstests

./check -g quick -T -b -s ocfs2 -e generic/081 \
-e generic/266 -e generic/272 -e generic/281 \
-e generic/338 -e generic/347 -e generic/361 \
-e generic/628 -e generic/629 -e generic/648 -e generic/650 

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 4K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/091 generic/094 generic/177
generic/211 generic/225 generic/263 generic/321 generic/322 generic/329
generic/331 generic/370 generic/376 generic/424 generic/448 generic/467
generic/477 generic/481 generic/498 generic/510 generic/512 generic/513
generic/534 generic/537 generic/552 generic/557 generic/563 generic/578
generic/588 generic/607 generic/620 generic/630 generic/755 generic/760
generic/771 generic/777 generic/779 generic/784
Failed 39 of 632 tests

OCFS2_MKFS_LOCAL_OPT="-b 4K -C 4K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/070 generic/091 generic/094
generic/177 generic/211 generic/225 generic/263 generic/321 generic/322
generic/329 generic/331 generic/370 generic/376 generic/424 generic/448
generic/467 generic/477 generic/481 generic/498 generic/510 generic/512
generic/513 generic/534 generic/537 generic/552 generic/557 generic/563
generic/578 generic/588 generic/607 generic/620 generic/630 generic/755
generic/760 generic/771 generic/777 generic/779 generic/784
Failed 40 of 632 tests

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/075 generic/091 generic/094
generic/112 generic/177 generic/211 generic/225 generic/263 generic/321
generic/322 generic/329 generic/331 generic/370 generic/376 generic/424
generic/448 generic/467 generic/477 generic/481 generic/498 generic/510
generic/512 generic/513 generic/534 generic/537 generic/552 generic/557
generic/563 generic/564 generic/578 generic/588 generic/607 generic/620
generic/630 generic/755 generic/759 generic/760 generic/771 generic/777
generic/779 generic/784 ocfs2/001
Failed 44 of 632 tests

## fio

no test

------
[1]:
https://gitee.com/anolis/storage-cloud-kernel/commit/ea3fe75e2060118ba093e90b1cd34fa382914b29

[2]:
https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com

[3]:
v1 patch set:
https://lore.kernel.org/ocfs2-devel/20260724052559.15409-1-heming.zhao@suse.com/
v2 patch set:
https://lore.kernel.org/ocfs2-devel/20260727061802.18485-1-heming.zhao@suse.com/
v3 patch set:
https://lore.kernel.org/ocfs2-devel/20261018143319.22329-1-heming.zhao@suse.com/
v3 sashiko review:
https://sashiko.dev/#/patchset/20261018143319.22329-1-heming.zhao%40suse.com
v4 patch set:
https://lore.kernel.org/ocfs2-devel/20261103135605.22943-1-heming.zhao@suse.com/
v4 sashiko review:
https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com
v5 patch set:
https://lore.kernel.org/ocfs2-devel/20261105071930.16399-1-heming.zhao@suse.com/
v5 sashiko review:
https://sashiko.dev/#/patchset/20261105071930.16399-1-heming.zhao%40suse.com
v6 patch set:
https://lore.kernel.org/ocfs2-devel/20261115154013.9379-1-heming.zhao@suse.com/
v6 sashiko review:
https://sashiko.dev/#/patchset/20261115154013.9379-1-heming.zhao%40suse.com
v7 patch set:
https://lore.kernel.org/ocfs2-devel/20261118002050.9019-1-heming.zhao@suse.com/
v7 sashiko review:
- https://sashiko.dev/#/patchset/20261117150053.18417-1-heming.zhao%40suse.com
- https://sashiko.dev/#/patchset/20261118002050.9019-1-heming.zhao%40suse.com
v8 patch set:
https://lore.kernel.org/ocfs2-devel/20261119064029.11910-1-heming.zhao@suse.com/
v8 sashiko review:
https://sashiko.dev/#/patchset/20261119064029.11910-1-heming.zhao%40suse.com
v9 patch set:
https://lore.kernel.org/ocfs2-devel/20261120060014.12087-1-heming.zhao@suse.com/
v9 sashiko review:
https://sashiko.dev/#/patchset/20261120060014.12087-1-heming.zhao%40suse.com

-----------------------

Heming Zhao (3):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch DIO read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap

 fs/ocfs2/Kconfig      |    2 +-
 fs/ocfs2/aops.c       | 1689 ++++++++++++++++++++++++++++++++---------
 fs/ocfs2/aops.h       |   43 +-
 fs/ocfs2/extent_map.c |   34 +-
 fs/ocfs2/extent_map.h |    3 +
 fs/ocfs2/file.c       |  342 ++++++++-
 fs/ocfs2/inode.h      |    9 +
 fs/ocfs2/mmap.c       |    2 +-
 fs/ocfs2/ocfs2.h      |   25 +-
 fs/ocfs2/super.c      |    3 +
 10 files changed, 1722 insertions(+), 430 deletions(-)

-- 
2.55.0

