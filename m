Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792486278;
	b=thW+YtAvN28RrXWmy6MbGuZIOSBC3LTrN7vQOpLAnMesbZN7sxWG7KpNa4tJCDYfJQnd
	 OaqziBqzssq0A8H9HTsF6i+IelUE5sFBo0fkgumFUgKBx+7rROelR07YXAHcrjlGeYyh9
	 7AqLokqFUOqLuV4mesmrIw8B9GXkkZWlP5usyevw4ihzi4ikYYGSu8sqg5VGzUm/ySmyb
	 +VxPzBzG6Cm3LL1uj2L8xgA9reMwSFZ7425WPigFLX06av8LVR4RMhTUYq0Z/HwunQlcU
	 RgcZc9frK4/Yop7DZGvfm5uCo5MRbRVuxBbdofKexRKt+TPPp51zLf5vua59VE+0gNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792486278;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5SW2IO2rseXzuOFXMzCYvlLaiKwdefVPHk6QIet+9Es=;
	b=te/5517ETG0c5X5XCS71tY3HUst/IlrXNZFBLrr7bzwh6XASBoDq2oPPsLkTPn4UGa2M
	 XI7tXbI8b+wNj8FmhGra/mwZANOWWh5yxXFxAkkCEXFQ/reKeos2n2QEG66LjXCcRnonm
	 9fZJk29FDyE4O9CTVZmcbzfZ19ZvBKaOr4PFC/3un1Lt4e7U99wFXzMBXtzKjQwVXwcdx
	 QB8uRlJ6oHn5ooBxYHQjd1IkFqfE4qGTxs2VPvwZUGs57DCbQwPFiQFF3QMIsmZqaoaN7
	 7OrW/IDBuU0XU5tnrilU9MeZQZOpoLppqvwh0EDwePm70xG0IsTriCXkuEXw+zBJ5vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="VWBG/m6C";
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1749606A31E
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 08:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1749606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VWBG/m6C
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-366421dc8ebso557265eec.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 01:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792486277; x=1793091077; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5SW2IO2rseXzuOFXMzCYvlLaiKwdefVPHk6QIet+9Es=;
        b=VWBG/m6CMf/22J3blSvDrUx8LHhaAxn6NdPVRU+i3ipLAjV0+iQZlyktJCbRnUzsO5
         A3TBIFH110ifFLUpNqT/une29EeCQQBFwRFk95a8Sj+VRSm7dYWwH4UD+eS2rG+rzX3o
         SOCHKQQXP295LnFkf3X0xLAbYHim84BDm/3tPwHg033D4oAsonCl333u03VnZOTNjm2c
         xBRMHAfLq2s4PGXl+PJl7cSPF+V72GFqxjWlC04Zp7Bhu77AF5ZYUz/MboZpH/NwDTQc
         Yuto7kRgCObVp7YyGmJ6CZyGZQ9gV9pbcrQBI/U0wgN0RBrGv9bG1i3nNnQrSr84zYZj
         Se1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792486277; x=1793091077;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5SW2IO2rseXzuOFXMzCYvlLaiKwdefVPHk6QIet+9Es=;
        b=SN3JMzOikauH3OSHKtNgBL6Hqu6HepLOKC5NHr4MJlgJzag7qcEl0Msq5tZOUa1LOE
         GKYwNywjJJfH7CjD9m1ROUryjjoMR5j3geYyzssepcqfNeE0WDMdqRznXM5mfQk6+xd9
         1wGyo/TNiep14EatcBjPbw2O3XQhtArcvip52vFlIP7VWLvvAOQHnSP7F5NxOkLToTKc
         2bgSv/dZLSYaf+P2LT4ClSSYXKdKS7G1W40RTueFl+uVikgjChM0ntkSW+mi3F6laln7
         CQeESGQyCp/TB5O6RYaKTKhQ7WrqiMwmN+tr8TxLG2FVLD7vzXbtTQgnii1QHkDZu641
         0VLQ==
X-Forwarded-Encrypted: i=1; AKwUvBzEGIItBtaxwGhVrAm8SZcK67BtGxGig9eHo1PTrqnzsIsEf9l4SorU+xiSLPA/lSNgWeg7dafOHz5KKw==@lists.linux.dev
X-Gm-Message-State: AFq9FYJTXPl6fXe8iPKoogGGTr7gugy1MnV0ahVnuE+4dVgJ6q8hzQCS
	LkDuFf6s75lJRnqcMbJ7DuhXmyvB5dhpnYswPcavVhcchxLb2Oq8CpB7LK0wDw==
X-Gm-Gg: AYBFou3DwLmqimIEBA+2lpgZNU/PlqwzrIQbpbooIR9g2+aLgQaUcYKBNW4WsPsqpuL
	YaU3ftAJU4hbLtNzDKyL/2NHwWGbN+HNHzJFrVcrwsZnWNKpFBTG5M+0OY9aWFnXOVAKf4FrTFO
	sbGURrYp2T9jCYOMFRfZXTfRcBitJkv2fQAda+W2Nr+JZIw7jfP7dUbW0WXBNR+gP8157OJNT/1
	E5nqjg+JOmwkYHVWT+XBanoEB3UdCptpEEw+ar46H0+5j1FxKmW5+YH31alrGT6fpYQblSfuuho
	7NL396nT8IHAPWBUehmHST/4ar3AseIPbnFqi6hHUO4yzhhqWcbwFDWnyKUHJ4XfRLIio25LQcq
	UF6jGiyv9Qlba4zETVlf6ZiZ3e0rkjPsxeMnyJYajXe5/pz+RLFfw9kLIT2OdAvdg65AfSe//m9
	AgE84Xil56SJ1r5sEqJyhoBgzpKbESybBVuT+L2gX9evsNzBK2KTM/tePobtzFy3VnfyPcGR+pG
	4g1/HEXbytAYOQqGbcdZRfUX8d/pTgF9al1hnh4Yf/IBGY8rk1r+lZmxGaYCOWj8lM7EV/pRzWr
	usBDtbgBFpGWWycXIdSNhmbWqbEdMJHuBmnzCJ+aZLxPjw==
X-Received: by 2002:a05:693c:62cc:b0:358:a1b6:3ad4 with SMTP id 5a478bee46e88-365fa491f31mr2292136eec.4.1792486276837;
        Tue, 20 Oct 2026 01:51:16 -0700 (PDT)
Received: from deepanshu-Legion-Pro-5-16AFR10.. ([2405:201:682f:383f:fdcb:6ff9:fb3c:351a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36081fa5a6esm40264160eec.16.2026.10.20.01.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 01:51:15 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	akpm@linux-foundation.org
Cc: zzzccc427@gmail.com,
	kees@kernel.org,
	ericterminal@gmail.com,
	christophe.jaillet@wanadoo.fr,
	kurt.hackel@oracle.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: fix use-after-free in o2hb_region_dev_store
Date: Tue, 20 Oct 2026 14:21:00 +0530
Message-ID: <20261020085100.8819-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Two tasks can concurrently write to the same region's "dev" configfs
attribute, each through its own open fd. configfs does not serialize
separate fds against each other here.

The only guard against a second writer is an unlocked check near the
top of o2hb_region_dev_store():

    if (reg->hr_bdev_file)
            return -EINVAL;

This check happens well before hr_bdev_file is actually assigned;
several validation steps and an fd lookup sit in between. If a second
task runs this same check before the first task has assigned
hr_bdev_file, it also reads NULL and also proceeds.

Both tasks then call o2hb_map_slot_data(), which allocates
reg->hr_slot_data, and later, on any failure, o2hb_unmap_slot_data(),
which frees it. Since hr_slot_data is also unprotected, one task can
free it through its failure path while the other task is still
populating the array, producing the use-after-free reported by syzbot.

Race flow:

  T1: dev_store()                      T2: dev_store()
  if (reg->hr_bdev_file)  // NULL      if (reg->hr_bdev_file)  // NULL
  ...                                  ...
  reg->hr_bdev_file = ...
  o2hb_map_slot_data()
    alloc reg->hr_slot_data
    populating slots...
                                       reg->hr_bdev_file = ...
                                       o2hb_map_slot_data()
                                       failure -> out:
                                         o2hb_unmap_slot_data()
                                           frees reg->hr_slot_data
  writes to freed slot data  <-- UAF

Fix this by adding a per-region mutex, taken at the top of
o2hb_region_dev_store() before any region state is modified and held
until the function returns.

Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Reported-by: syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3025e3e8fc0b928af8f5
Tested-by: syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6a9b3f7a.2e649fcc.1e1977.0001.GAE@google.com/T/ [v1]
Assisted-by: Claude
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v2:
 - Expanded the description with the race flow
 - Updated Fixes: tag
 - Use tab for indentation
 - Dropped locking in o2hb_region_release(); configfs already
   serializes store and rmdir
 - Take the lock before the hr_node_num assignment, using
   guard(mutex) so every early return releases it
---
 fs/ocfs2/cluster/heartbeat.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 1c3def99bb07..e20ef0459f54 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -273,6 +273,8 @@ struct o2hb_region {
 
 	/* last hb status, 0 for success, other value for error. */
 	int			hr_last_hb_status;
+	/* Serializes concurrent writers of the "dev" attribute */
+	struct mutex		hr_dev_write_mutex;
 };
 
 static inline struct block_device *reg_bdev(struct o2hb_region *reg)
@@ -1879,6 +1881,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	ssize_t ret = -EINVAL;
 	int live_threshold;
 
+	guard(mutex)(&reg->hr_dev_write_mutex);
+
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -2149,6 +2153,8 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
 
+	mutex_init(&reg->hr_dev_write_mutex);
+
 	/* this is the same way to generate msg key as dlm, for local heartbeat,
 	 * name is also the same, so make initial crc value different to avoid
 	 * message key conflict.
-- 
2.43.0

