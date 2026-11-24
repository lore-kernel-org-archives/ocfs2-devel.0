Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795533995;
	b=iVsNwtv97Uu4dbJw2IidekuMgsmo0f6x/mg3JHRAWyvVha8X954ZS2Z6ZvNjhF/cBNje
	 mrkafcym3Kg5jmqqBSZpI83Ij3p04YLd98EUmTYLK9cJsTo1HEWNigYZKahnVkn82hAED
	 7Y7AMGnPNjcSyr1qN3eHWvacR4jWRUnKI8j9kT/kK5GXwuPIA2It+IJN+Tb7Axm0dyk8/
	 Pul/xj5Z5TlAY7sjOKU6WH/hy+1RN9WrXFA/TFdegy4l0WnvE3jtowhg4VkNtIWWUY6uC
	 5KN58Rnoyh3pshUgxRWGul4OjSB3TheH1/ROnaqF6Ocn+yt4ya3gFZ/Mm+1yKsdfcmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795533995;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CP+oHDXP5r+VSZDonqBvg/vdjmvF/5ULzNobg5RIMMA=;
	b=hE52mK1yNJLDtepKHIOx6xJaFPiaGqNCzQMri3UTMXngv+zNEPyMonI07DWyfwEvOouF
	 rUYF8rXeaAPefa+uV+zGGexj/xnHlD9T0k668RHkBcx09avqDHL10THpwHTY12W6pZdjg
	 gfbksE+tNdYAY6EsDFTc649ix97BrlvU8rvdhPyM07nplrCXK0GCYZV0bc2Yzm0o6BbSl
	 qZ1b1Z3lTQS4LTawS1b5XqGpYmHdN94JrmoWnc8SeMcrfFhoibDJxPBEtH0tygADvgWFS
	 9xtVAKN6wxQEfX/Xi0oCDY9fEGlCvcWWHeTTjfWtu7bLax65sGJR99FG6AHp51vmxYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=PcJaeuTW;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743E2606A31E
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 15:26:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 743E2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=PcJaeuTW
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c3fae9338f0so60570466b.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 07:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795533993; x=1796138793; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CP+oHDXP5r+VSZDonqBvg/vdjmvF/5ULzNobg5RIMMA=;
        b=PcJaeuTWEC9Jw8PBWn2erA8BVNDHmB2KynyFwICB83u6LWhc3IVDBNTh17dQZqWlAe
         WaU+5jDG/Ivq8hpTMmHZTj2wz/fSsEwPvWg3th2kfl+LFxgXBLuTKOTqkj8n/BxSjdDy
         FkDJ2/LuIK/+AtKKBsrsBHrSzgwwy/S5t7te65ZjWua76/7Cv6/2+CoHWrXWZfzdeGPk
         lK7fDqNxRpL4HM0BZNDAfCyJ93bA5qKQ1CzBoiRrz9jUbU3JsqWanMFOohYGpE75VaaW
         izBCTCj6ZE/E9MKUDqF6thE8UR1Sk9J8RBcokiZkGzFoX7uZj7h+Eh2ZO4OOwTWTISkN
         W85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795533993; x=1796138793;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CP+oHDXP5r+VSZDonqBvg/vdjmvF/5ULzNobg5RIMMA=;
        b=XXv9B/JyLDIPchzeVh5r9ZwY3BJocuY4sBhFCL+PwQsYob9pzpJ4wPLrHJ/jOZ33Kz
         KonanfCaK/+1EI0csdo8wGHdMVmngXrxBwKodNOfcA3pm15NYahA9L+h/EGB2YaUdFQL
         m8ujJXCYOc+uTinsdbTwb06siANn0JzELf2xjUfBcAXjuTX/1JGxXufo4NbXhUVj1Xg+
         PFmq2+oBVuqRqeo3sGu5x/XoCDjW+ixfPUqU5fvKLvUnmqdq1lBT2F4M3Tl1JPPPB0EW
         zETRZ9Pm9IUV+HZsLkg+qT9q1eSmTI1+ibgaOdDRplGGstWKfaD5+6S4ML3FHgIv4aoV
         FNXw==
X-Forwarded-Encrypted: i=1; AL+hErELZCF1vAhI0H2BUTRMGys5cnWBjCF8dm/Aw8P26+87ti/A9yrF5r0zg9Z09jcDXoqZbtXxyV+dymqcHQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z9n4Xl12/yAGAT3mVh/Dux4MTirfRkso54SpIqisd/rMKs2MM1g
	do1hWbGjNrcPebHhw7bgdFo7QA17/cUQkIUtszGOdnNeKYCdZ+7ZZFIwO2Bw6E6kAEb3rG+6fTO
	KTpv0HAU=
X-Gm-Gg: AZFdTZeXqQbyAE9574Cce3g4zJycLSEH9WlJJF1PcFI6515wlTUuSdsPe06yl/7sgGV
	S9i5e5coSGhJh3/Njmri3nO0Ugczv4i1mqLaTfdsfSzic4X51Fwzy1MRApYU3QQLwJDK9yROVgq
	foSy6NgG1RnSpkdRQJmufGKjwoBZeYvEcG99h4alzF4NvbuCnozmZhhnGBOvV6ZJWKtGWw+aqDJ
	C9g7qvwoAh+P7Eg6l93SEv5X+Wh316PcEcnQtDcU7isSNVY5+iENp0Zy6R/Axkgoa6E8qexqvWa
	EJWQAMfqvuA7UveLsENGcm5ogQZ2TDuXH6wi1WTJC1loVO293dWftQ3XHbkEzx51eMxlO2QOSy4
	5nmTJrn1TxQU9EpezFuVJrwawMbpr1akpK4ky5Mo8+aIl6zVgrnM4oBCNHVakQTvPr7ZOnRg+74
	Q5nEwVDvAqZll7oMFnnvjeEeYqSY5gRm+KpDOgWclwfN5D95/gqdioR4vZr1Mog/5boMtoUDHgc
	2NDyjKLgihgCcIvr+H77eMPxkju34Ixzz4EWebPULy90zgtWsL8CflmYzHuoHv44yQWe30KtMCw
	xbeXS/jJHoUtkVlkbaJDBO3qFR3Ij3ZSaN/Zv55rXXna8jbxir2NVAKsQ6RocB/x
X-Received: by 2002:a17:906:fcb7:b0:c50:d900:8536 with SMTP id a640c23a62f3a-c513a3a33dcmr1198571566b.1.1795533992782;
        Tue, 24 Nov 2026 07:26:32 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d0575d9sm7182425a12.25.2026.11.24.07.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 07:26:31 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v11 0/3] migrate ocfs2 DIO from buffer_head to iomap
Date: Tue, 24 Nov 2026 23:26:18 +0800
Message-ID: <20261124152623.7838-1-heming.zhao@suse.com>
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

V11 changelog:

patch 1/3: no change
patch 2/3: no change except add "reviewed-by" tag
patch 3/3:
- based on Joseph's review comments
  - modify ocfs2_lock_map_blocks() and ocfs2_dio_zero_eof()
- based on sashiko's review comments 
  - add TODO comments in ocfs2_should_use_dio()

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
v10 patch set:
https://lore.kernel.org/ocfs2-devel/20261124045501.10281-1-heming.zhao@suse.com/
v10 sashiko review:
https://sashiko.dev/#/patchset/20261124045501.10281-1-heming.zhao%40suse.com

-----------------------

Heming Zhao (3):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch DIO read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap

 fs/ocfs2/Kconfig      |    2 +-
 fs/ocfs2/aops.c       | 1705 ++++++++++++++++++++++++++++++++---------
 fs/ocfs2/aops.h       |   43 +-
 fs/ocfs2/extent_map.c |   34 +-
 fs/ocfs2/extent_map.h |    3 +
 fs/ocfs2/file.c       |  345 ++++++++-
 fs/ocfs2/inode.h      |    9 +
 fs/ocfs2/mmap.c       |    2 +-
 fs/ocfs2/ocfs2.h      |   25 +-
 fs/ocfs2/super.c      |    3 +
 10 files changed, 1741 insertions(+), 430 deletions(-)

-- 
2.55.0

