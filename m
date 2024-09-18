Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B4E1C68B4
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 17:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726680041; cv=none; b=DRjVdbW1oKa53gUPOB5dk0gGz5xTR1GLLAdE+vhNZquy9+/MrNAtBLCA39+RQIkAqoXJ/HfeqH5SlcyNzWVsftDAvG8zSUNSLGNpOrG7EtUK+I8F2PvEM6k0ha1x0eMjOsxeCr+Za+SY/xZ+bsoNT/IPLIdtJaYgWipaFMHnUFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726680041; c=relaxed/simple;
	bh=fp0kfU9JJXj3JXg6Kmhe3J26EnAG57gHBH6CHIYIU6c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iZi9a83/mARXTGRAxBWr9dtQRUXvi17olwSZe02svJZ1Jwhen0XuDkB31xBlAzVTkXLF/ihYX4QLhTF8CX1OnJTqXOcJlRuzZvCyS2ysxZBN7T9lXkViw1FnVod1gFcRuFczKQPlX++O47MsCas7FDsZ+8UajGfzsfEanLVULGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XkzzJs7e; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XkzzJs7e"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-718d91eef2eso797515b3a.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Sep 2024 10:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726680038; x=1727284838; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WCjQaYHdb+9akkF4GNDfGIZ6sEnEG+5xP5QyLjg07+g=;
        b=XkzzJs7e7Vd+i5ym0NE3orie0LRxE5mUBxWPf7aDHEQkoS++k2p10D1lJfat7ozXrm
         v0J01LtojrjXuMwaAOqDfN2ZQWUIW+EYWLCqOwOrIoyzpEj1Y6gdCDvbb8rK4uuzVS6c
         nzeriYWakwd65pnGmcVhUTu+x7HpshkuZum9HK7Tq9yYkz0h3Mikz8PUQst+xthXIAN1
         h9jijnCB3I63Oa7yyfpu1aZDZDBxypMU7qVKlS8+LCf8kMg8+LTYEnSNRKt+QtkvOTQ3
         qspwxf0psnllUgPE6ZLLswCTAudtVF5r8+VF/9JPWNf+UKXcO36fQWGx/+ESbOHRgh+C
         cdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726680038; x=1727284838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WCjQaYHdb+9akkF4GNDfGIZ6sEnEG+5xP5QyLjg07+g=;
        b=elRa9E8EijvYX2tYqIcGpLZVua5GULOhyG/h/6j5SFoT6KwahoFZcMfSY8QK/hOtwJ
         c2l0e+2jmqnK6YBwRyr2CTMl+V8FBPYinwBh0b54V84SmyUNxPsYId0ie1EPhOpOa+Px
         f17yzbVrgXuG2OgP4k21sreMOe7Q31IGjQzdzFNKVRT8z3ejJ6KsxkIb8PacBoH5v+wW
         gWOnJLaEQju9ohCEimyw/2TAx8PVeh3fi/jiCKs1QbLEP05aO9PyfPiworOhEW2rBSOC
         cEAOAPZbDym/DI1Urxu3xQbognFYGBRyQnT/ovZ64p6Fb0tXQgw5koTh2gzEv6aOIlz0
         d7Ig==
X-Gm-Message-State: AOJu0YwTj3gmVvpd70gf+H3jUpBDAjE/048juxQkZi+lgsrYb8uqNn1b
	ilOO1fGMJVMxqAjQ1pkTllSx//uclntBILtnVL1x+kVZvM6iyG3ECKZGEyEV
X-Google-Smtp-Source: AGHT+IFZVBIM7leYgR1FuSjCuamUv2TO9TcnN1QImS+vNJUsnHx5FI5MEArsnr4YCOk+f+LXTrVIbQ==
X-Received: by 2002:a05:6a00:6513:b0:717:92d8:ca5c with SMTP id d2e1a72fcca58-7198e24346emr477163b3a.3.1726680037871;
        Wed, 18 Sep 2024 10:20:37 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-71944b7aeafsm7186476b3a.99.2024.09.18.10.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 10:20:37 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mohammed Anees <pvmohammedanees2003@gmail.com>
Subject: [PATCH 0/2] ocfs2: Fix deadlock in extent_map and handle zero
Date: Wed, 18 Sep 2024 17:20:24 +0000
Message-ID: <20240918172026.2532-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series addresses two distinct issues within the OCFS2 file
system:
1. A potential deadlock occuring in ocfs2_read_virt_blocks due to
contention on the lock.
2. Handle block conversion with value 0 in ocfs2_add_clusters_in_btree

Mohammed Anees (2):
  ocfs2: Fix deadlock in ocfs2_read_virt_blocks
  osfs2: Fix kernel BUG in ocfs2_write_cluster

 fs/ocfs2/alloc.c      |  7 +++++++
 fs/ocfs2/extent_map.c | 16 +++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

-- 
2.46.0

