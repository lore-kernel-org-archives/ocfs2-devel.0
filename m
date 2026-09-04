Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BA63A6B65
	for <ocfs2-devel@lists.linux.dev>; Fri,  4 Sep 2026 23:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788566265; cv=none; b=SctMGHBH6sbb86tSgSbIvkr+7JLS7E03oDf3MTKacDtgMeHm4K3UmojB7uTsB60RJrq/3LsDvFT+7ezBAWkEDpVTCXqjjueAsfVcg83CboIvd3gQVTLDWXdjvLuky9xPZIVEG7FpmMljK5W58RK8wtYFyGiMqAKt5DkTTxmDX1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788566265; c=relaxed/simple;
	bh=xyuUL9Vw9xbTnoxc8//PAV2BBZSGl1MIqqpiQJbRaag=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nnHFqn302c5+W4a28cDzENnNmoixUUeyenRinCP7uYb6Lh3/4D3cNNP5kcrouoUax7fk3MPFKBm4gDn0Xm26zye9ywhGuJgyauniR4hVuMeUhGeoRuwKKz/XFrGoAPoLczy+ExKwVKb2jvN+GnhcpAEZC++ecj1tDWorlVCe3Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJJUJDk6; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJJUJDk6"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cc891373e0so17135905ad.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 04 Sep 2026 16:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788566263; x=1789171063; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jdg1epLFOWbc0vDaaDLE4AWGZkYqi8Y+lj6oxcRbQB8=;
        b=nJJUJDk6hyD+Jik53rQfHEAD3hqHgOPNZKOhgoMNpvB0Y/NzEHDL0Nv4WQrpkAAf5v
         wdUJpo7po3XFjIAL0V3FkwP8/bfNkHw+2ShIKGpByuGLpcJrBXngxjU6m0RZYVzNV4BO
         Vmh2MNo0olzKc8uPiWJUg26DGREDn+hLH0J6tzV6AkWqur2HsE2vN0XXLh+qLGMS+Gte
         UVtMAi8XgSSHG4jT0vmhGZ7AWQ9yFCtECtWZGIept7VlxGx45LpczpbzBac8L0UKa2V1
         IB61s8TOnPG/UO1Niw3WioFDd44bxRFgy61t7zdpKMFWsxNaLEul7VyiCEh8d1F4sEx+
         VI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788566263; x=1789171063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jdg1epLFOWbc0vDaaDLE4AWGZkYqi8Y+lj6oxcRbQB8=;
        b=cqROZk9oMd0UY6mpcionWIEH30DaVCHHLVoIy0L0qsIOAaTW92X8VLfufbQI6X+slK
         sk2tKrMHZG4+8HrnpvUV4AwfyuGKGz8WFLI56WmTi6VVR7R1c/dCcWOe26KD31jNaooU
         949sD/vN87YLjbV185ufZqbaAYf6cyxZf0aTZjids7DkHYh3lvAhe+MzXZsCBYTwWQpZ
         Y/79E0DrsrynRSFnpgDe9IxaB4nuAqQTRLGdWnvufy1oqtL3g8DHTMqNKLq46TQF9Xx4
         eBLeqHewXbiKdk+VeIq0Yfz2QA0Qid8IAJaYHoojNp9niO+FQZE2EnZHcsEOfQbmLDjm
         L3Zw==
X-Forwarded-Encrypted: i=1; AKwUvByM/XiGdIQinC3TIYFDf/c0sJOg+Sn9UBKdXCSMexE4extUvmu+33eL+hHD6oKlFqcbphkW3BHp+ieLcA==@lists.linux.dev
X-Gm-Message-State: AFuF++lKPWVe4EyNzyc/Xeo9Jdljq+gwhC7yKFSJpbW2doLm8pNnHjAc
	1uirp6lY82OJOvEmBvrG7+HYyE7zwf2OKkQsRzw0fbRTDwAZoR70fydQ
X-Gm-Gg: AYBFou1TSLbZIddJsHEKI48txJcAs/UFOdpdSgNmh2y9l4Tb6ltnna6TrpGf/o/kHlu
	gKXBWsxf6WRM7SCdwz+oqpHP5oLM4dhmsTgFn6uyYY+aft1cAIY8fUNhmlbPyFFyLlFwiMrGEkk
	qiYT5R5KaX/BSY/0z6zEUCFaD0oPO1I5mtKdXqkhxI6EA0r7ijf4dKU50mHD5bITf3TinpraNlU
	7gVQR4cxy3bGW9B7f6A9NUrK+cCCVHL+uCca7oQcwL14rIAFH7ZoectG1HJ+TkEhiHwtZ5ZH88c
	jyxiW2g/Zwx0QIYvv/7uPwDvBvPY7sUgIi6Y/8kGaVgfFzGGlUGTJnZ5T1r9N3OBi2pUStOK2vu
	mTJwLkamnjdKYEUGQfpu0ZCPOqVGueotB5P3WjmA2MqLF/p9Z1+19skTxY77GinsgOYtKiK2r0r
	AqZ5KL4rf/0J2GO5T1lecTFwatvSIpzA/5vm2xca/ZjpmSA3SVVf0ikSUM4x5ouNGmklgSze9L2
	kUk4V5yUnUsOSHytubQakSD
X-Received: by 2002:a17:90b:1c0a:b0:398:d132:ba76 with SMTP id 98e67ed59e1d1-39b2623abfemr13100856a91.21.1788566263169;
        Fri, 04 Sep 2026 16:57:43 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:383f:35e0:2c1e:70f6:a9ef])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08ca63b3sm12815116a91.11.2026.09.04.16.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 16:57:41 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz
Cc: zzzccc427@gmail.com,
	ericterminal@gmail.com,
	ocfs2-devel@lists.linux.dev,
	christophe.jaillet@wanadoo.fr,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: fix use-after-free in o2hb_region_dev_store
Date: Sat,  5 Sep 2026 05:27:10 +0530
Message-Id: <20260904235710.16317-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Concurrent writes to a region's "dev" attribute can race, letting two
tasks both allocate/free reg->hr_slot_data for the same region and
causing a use-after-free. Add a per-region mutex to serialize
o2hb_region_dev_store() against itself and against
o2hb_region_release().

Fixes: 1d3aa0b97c55 ("ocfs2: port block device access to file")
Reported-by: syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3025e3e8fc0b928af8f5
Tested-by: syzbot+3025e3e8fc0b928af8f5@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 1c3def99bb07..6f03de1b6d4a 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -273,6 +273,9 @@ struct o2hb_region {
 
 	/* last hb status, 0 for success, other value for error. */
 	int			hr_last_hb_status;
+	/* Serializes dev_store() against itself and region_release() */
+	struct mutex            hr_dev_write_mutex;
+
 };
 
 static inline struct block_device *reg_bdev(struct o2hb_region *reg)
@@ -1616,7 +1619,10 @@ static void o2hb_region_release(struct config_item *item)
 
 	o2hb_quiesce_timeout(reg);
 	o2net_unregister_and_flush_handler_list(&reg->hr_handler_list);
+
+	mutex_lock(&reg->hr_dev_write_mutex);
 	o2hb_unmap_slot_data(reg);
+	mutex_unlock(&reg->hr_dev_write_mutex);
 
 	if (reg->hr_bdev_file)
 		fput(reg->hr_bdev_file);
@@ -1879,9 +1885,6 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	ssize_t ret = -EINVAL;
 	int live_threshold;
 
-	if (reg->hr_bdev_file)
-		return -EINVAL;
-
 	/* We can't heartbeat without having had our node number
 	 * configured yet. */
 	reg->hr_node_num = o2nm_this_node();
@@ -1906,12 +1909,20 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	if (!S_ISBLK(fd_file(f)->f_mapping->host->i_mode))
 		return -EINVAL;
 
+	if (mutex_lock_interruptible(&reg->hr_dev_write_mutex))
+		return -ERESTARTSYS;
+
+	if (reg->hr_bdev_file) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	reg->hr_bdev_file = bdev_file_open_by_dev(fd_file(f)->f_mapping->host->i_rdev,
 			BLK_OPEN_WRITE | BLK_OPEN_READ, NULL, NULL);
 	if (IS_ERR(reg->hr_bdev_file)) {
 		ret = PTR_ERR(reg->hr_bdev_file);
 		reg->hr_bdev_file = NULL;
-		return ret;
+		goto out_unlock;
 	}
 
 	sectsize = bdev_logical_block_size(reg_bdev(reg));
@@ -2029,6 +2040,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		fput(reg->hr_bdev_file);
 		reg->hr_bdev_file = NULL;
 	}
+out_unlock:
+	mutex_unlock(&reg->hr_dev_write_mutex);
 	return ret;
 }
 
@@ -2149,6 +2162,8 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
 
+	mutex_init(&reg->hr_dev_write_mutex);
+
 	/* this is the same way to generate msg key as dlm, for local heartbeat,
 	 * name is also the same, so make initial crc value different to avoid
 	 * message key conflict.
-- 
2.34.1

