Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794927666;
	b=lOeImLDCGdZ2ml9cdLqQ0HHw9OxXo9KqUrPBzsEFGqFw9Ve66UYKYx8YUW8mQnnc/PRs
	 duF6Q8u69SBpUxs3zLJs66ecNHefG787ka7w8zLLixZGD/eXg7xTJc8n36DUGeLNo8bV4
	 7arXTQQ7khe67VT52r6sqmZ/fJ3dM+qx3tCmEkqmgVQePUOoKRCUBpFwfvBiPg9NjNifD
	 4WnDb1AQ2kBIZWn3SGVbJ2NK41anhlKGzW8TPbMnmuSnFExIRD4gE8hyaur1TsMPQqTn+
	 1ZwOJRr2W7utM1dDvxm/jTSJiJWKDNugPqASzWC1RXgz6HtDH7eSSEu/J6PdE3WCKgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794927666;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xI3AfZOEgNPU8zapOEdxP2eG9d0gL1f+DDTmnD/NVrU=;
	b=Ih8eMRzKygzP6WADtTeHOm3jmivuXSFV1KAVpXsk5LtbbWUknT5ey2cLf9jE8KBT7E7z
	 OB6RIu7s1f5e4gZ/TCz39jMAK2BoZt9AunQCeuWfeJ3By9UuuvYPJ96CsUQYk/GVVC0lt
	 CrNHWco982YMdMU4zOcbNsuzlPyB6/bgmNFvKjqbCd0i3phVIdl01Vv1bUqbDy5Gr59V+
	 mzWK2d45BMTGircdMHuHGWeXentemtmRcWx10Ke9whkup5HhjXErzbz4OSD2Pdvv6ijEx
	 +g+6qII13gwrZqCmbyxfXUviJ8PLs1e8vDpD+hXVhRhpnmnJ6of7isWU7LXEjjzkTNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="ZcYly4z/";
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBA3606A32A
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 15:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EBA3606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ZcYly4z/
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c50537f731eso56085666b.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 07:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794927663; x=1795532463; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xI3AfZOEgNPU8zapOEdxP2eG9d0gL1f+DDTmnD/NVrU=;
        b=ZcYly4z/XgQ9ZHTqbJ2t71nUAl2GvJTqDrgOEUdludC2KlVpfCSMK0XM4ZN6qAtRmY
         zkLh8LJwDqYNJedULfdOvcXN4//41ncomqAXgKke1c4W/AARqY1qFgG5zGJdloxKpsgL
         6XXAZBzIxZHo0u9CsZbiRRedBpcsFmiXUbIRIQwZFXiDjd2uE2ZYlmTyE8pwuiui3r7i
         nmc7oXD1W8Za6oIBOHHpOQBLb3G3jyM6Owt5Mzr0zjA5cyrLnHgVMss42apGGxLPKIh0
         YeXCXIsVMr7oxp8H1r8XgvuW/R11L8WFfkcySZb7Ljz4SWHE21P52wv0uhed8HhS4Dqt
         YI8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794927663; x=1795532463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xI3AfZOEgNPU8zapOEdxP2eG9d0gL1f+DDTmnD/NVrU=;
        b=cRWIKGMWp8TCL4YGrNdqi0gEslRe6pvWFmE1l7TXmlPuOUSBMrwKxLsENqdmiSsRVY
         Ed0x4UIr+6zEkzBb+1aKa79sCSzXgbpaHSJNxQItOChuQ7j2kKDoDTd842ijLf4dF8bN
         Wh8Y31Fbhleb/S7UtlkmuXy9H1snxt5hjyCqpZ6BD9Jmc6xvJLDMeVRlPhkYYPqdObmZ
         1raWRNTilmGpqf4vlqsBHN8t/sM1/ey27WM6Mx07Zpqe1IJsIWaJ8WHGgTczIvCfNQJ0
         hcNY40Amn+eqYcBcYk6BQ5qAEAvjk2zp8vsBoqQci39HzzQq3srlahqg6AX1NzhxT9Cl
         b0QQ==
X-Forwarded-Encrypted: i=1; AL+hErG+Nr37YNOMn9rGFdl1Cr/17RGiDIY8DIbEmA49xCSAdfVWkAcWL5zzozOK23fhcKz43GhimKKe+a3mog==@lists.linux.dev
X-Gm-Message-State: APuU4Z8ApzhEcbmR7l3AZCZfeQACi49sI1696SpFkfKwRzHkvEcu3+rE
	vWgIU9iCXi6ToOqkRkxBUA8bkF9zsETUiYqmn3bV5JkW1kc7GNh0P9Mbt75uAKshMAY=
X-Gm-Gg: AYBFou3VC2aXXtxt73+RR/v78HrDSK+Ht6BlyFR9qbWWxZhoyePO3/LMV0Ju5LO1LGA
	WOEg7gyYj9PB1iWztyaQ6wDwJ4AFgXfgJc5z2jDMHHrsMeOQqkTm5h53rFGGtR8Zp2TdhRRGsqM
	huwBCWD4IVlDciRWf4i6fSf+XJi72v1+lBHJRrxlEUtv6mslvfwxrufBx8ZWZ0GhlHEkfuEFe+1
	0cGTdaTl8N8a40PN/Pevigb/rVBJuhrKGy/zheqxfLXMY/t5zZThzd0Lgad5pDsMcgSAS4lfcWX
	DfbA2FlbQUVm/uifUQPNGolRb5lw+YDuoMbDClfXK/dY+KKtOk2uhFHrecTbiwI4NhglCbTRLSR
	p9c9MYL0kz2nGREUy/wuO03gw9Gfwelfia0lX7nBGxaI7kn0QxiSyqKEqT9afZQ0c+9kRFvcZ5W
	LACITT+NUE+lX4kXqtmjp7h+1Vrr8gy9He9fQKVgD+g+TTZo4x/Oic064iqncbO/3Zyx07nqG/O
	JjO90ko+Bcw8XgjpcpuwRKoO7gHFCfcQ6B4Wa07xvtL/QMcg5yNSqRbOHeaYnlew9a0yzfDych1
	gJ5wbw7pMO07SaEtT03eQZo4dJCJ5ry/qrsxcojB1nE=
X-Received: by 2002:a17:906:130b:b0:c32:8cbb:fac with SMTP id a640c23a62f3a-c509630ec16mr1209113366b.3.1794927663112;
        Tue, 17 Nov 2026 07:01:03 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50309b2b5sm35904028c88.1.2026.11.17.07.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 07:01:01 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v7 0/3] migrate ocfs2 DIO from buffer_head to iomap
Date: Tue, 17 Nov 2026 23:00:49 +0800
Message-ID: <20261117150053.18417-1-heming.zhao@suse.com>
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
to iomap mode. And the code base is commit aebb72744764 (v7.4-rc3),
and also merge Joseph's code and ideas from [1]:

V7 changelog:

Address sashiko's review comments. Main changes:

1. Adopt the latest iomap API and remove the iomap_ops structure.
2. Add a retry mechanism in ocfs2_dio_wr_map_blocks() to fix a data loss
   bug. Multiple concurrent writes are serialized by i_rwsem at submission
   time but completed asynchronously by ocfs2_dio_end_io(). When the
   unwritten extent conversion fails and finishes first, other threads'
   submissions would lose data but still return success.
3. Fix DIO alignment issues.
4. Fix several edge-case handling problems in the DIO write path.

[1]:
https://gitee.com/anolis/storage-cloud-kernel/commit/ea3fe75e2060118ba093e90b1cd34fa382914b29

[2]:
https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com

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

--------------
# test report

This patch set has been tested on 7.4-rc3 kernel with the following test cases.

The current code still needs some polishing. I hope sashiko can continue to
find issues in v7, so I've only done a few basic tests so far.


## ltp

runltp -f dio -d /mnt/ocfs2/

results: passed

## xfstests

./check -g quick -T -b -s ocfs2 -e generic/081 \
-e generic/266 -e generic/272 -e generic/281 \
-e generic/338 -e generic/347 -e generic/361 \
-e generic/628 -e generic/629 -e generic/648 -e generic/650 

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/075 generic/091 generic/094 generic/112
generic/177 generic/211 generic/225 generic/263 generic/319 generic/321 generic/322
generic/329 generic/331 generic/370 generic/376 generic/424 generic/448 generic/467
generic/477 generic/481 generic/498 generic/510 generic/512 generic/513 generic/534
generic/537 generic/552 generic/557 generic/563 generic/564 generic/578 generic/588
generic/607 generic/620 generic/630 generic/755 generic/759 generic/760 generic/771
generic/777 generic/779 generic/784 ocfs2/001
Failed 45 of 632 tests


-----------------------
Heming Zhao (3):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch DIO read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap

 fs/ocfs2/Kconfig |    2 +-
 fs/ocfs2/aops.c  | 1628 ++++++++++++++++++++++++++++++++++++----------
 fs/ocfs2/aops.h  |   42 +-
 fs/ocfs2/file.c  |  243 ++++++-
 fs/ocfs2/inode.h |    6 +
 fs/ocfs2/mmap.c  |    2 +-
 fs/ocfs2/ocfs2.h |   25 +-
 fs/ocfs2/super.c |    1 +
 8 files changed, 1532 insertions(+), 417 deletions(-)

-- 
2.55.0

