Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1587E36196E
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792341113; cv=none; b=VHNNvYSPS2659eGR2ROKB19SIRLCloMYLay2UNngz/90bTWXxUMjfkeF7f4rNyigKDSud/X6s3mgfowQ8a+v3OYEo/jHW2s1pX5mEXrIao7joseiSi2sFvMUUkisw9VgIQ+MB2dYIOBOQ7pT9h2ixaIUXEvFFmfVC2f+R+Cqi10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792341113; c=relaxed/simple;
	bh=sCP6gp7v4kua0OIiD2f4Nb3Lrarw7N2ZRp8nfSOx8xc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ht3CGiH5b/7jzFylypECDHHO0b78bnR1fbbrE6cpx4ZdED/MdawvJMpovrHN0throoVr7hxSuvahLKWi8w6VuWTyqecKxfR43poArdZI+vOKwB46aTg6ABcN37ZRD1NlDDR8wJCqDE/yNUmbITJqtX09gsXbk1IsTUqI6I1Ykg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Npl3XhvY; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Npl3XhvY"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-354ba08cfd1so2324286eec.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792341111; x=1792945911; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rC079flF1ea2UIC6V0VoUeWhWKPu+OYvPPnysw6iStQ=;
        b=Npl3XhvYAFJ+YBU+VQyPaIkwQpZtz7gg3+CZhYhTJa70RIAr/rLnJNeMuWTtgTqviv
         riPPmng4/qsFviUcBOr+XWad/6/6wyZHxPg6JLkSRZXiE5kr475jhiYaBjWohQdUkUBs
         RB05OuNUl8izDGrylhjeM7JWLpC5qmq0Qu4wD0fA/7q3Dkt/fcoC+QxXrg1MWZJ8wWDs
         sZey3DU0phVH2JN9ZAEwg/Hr2O3jgc+GpXWHK7yLA+NbEihJIF1F6jO9egAjbiyowmCN
         uwJkneQraAuchHu3CwaFo8e3iDMmM1HCAk4DUCcpt9DtsaY1lYqC26HoXmhFWNmK+Nzx
         3EDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792341111; x=1792945911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rC079flF1ea2UIC6V0VoUeWhWKPu+OYvPPnysw6iStQ=;
        b=PAtV8VOrEv6sJ0OzlmMWv0jUpYIwl58Kl8mZL0o1BsaHgAMF6t0L4ifiW/lyy4pwMY
         FuBG5MveuJ7/yZQUbt5E52BRSm7JUawcqegL4SvvMGV4iUsq7OJjNlga9cdYoNXyeX4N
         eK8gAal43n7eOhQgR0z1BgC9cKpY1v+6VH6yhji8FRHB8qdsuzjy1DQnbF00bWtR6+l6
         U6zfhTgCpjK+yik/9pb2yslHJLnXozPPnxGaC/1FJsCZV/TSwxLrKKWi0hz2HJV6cE/h
         AfnslyzBUa8SMsXshSEDsG9z+rYQJWuXAw/noZX9w7a/0JBSWORdsF239JCtCrQjHyZp
         OrPA==
X-Forwarded-Encrypted: i=1; AKwUvByESJPjiq9xnYD+hzjzO/VDwtIewEsVYiKc9mRi/NOdd4+Uh4MN2+hFE+Lemj3ozg3Qzr1p6R1FciR5wQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYId4PCGZ4OknuplXaU8TieF7AxMPQfg2u16kpUxm9YcgRbIOpOI
	WA5OCAQ8N8CmVDLuFC81w4LvUAikKWLBwWXK7xgHX6EdKFANkoV2PO6P
X-Gm-Gg: AYBFou1wv2Zqdc99+fnsWQTyeAGD0Ei9YrN/Wldc2cgcUeDT+PHdbPNxpru7+FkKw/T
	amKep0m8SQlVs5IszKUBOmxSJxntaUshGSQD6Q3jKjHDN7tC8cN6QclSZk+4SMngI8UqSbyO6RO
	/1r/cIXa7E/ANnUtL3mBGbBjlWgUsW/A+JjzhHvGKhoGA3fIBtTwKpXg9N8t9xhaMmpLlp4kYFE
	rmJWAy1qKzswqD7a7zQUjPm5XMCkNWcyCVzOaH1jTv47uxMj3n5oDVHYbTENI+BtgDZHuP8bZDx
	rAinmgHacXbiNnCyJxkpvTeWwOvKonvi7YJzn7/WCZeCElDaQ9r2W6U8jzZP1/xRSc0nTWSU+Jo
	QRgkES/z6rgSiPd85tihC3Y5OjJA5cEkHKzRIbl8uenstQXJvsbjvkhTBTnpY9HkXxpGEw69Al5
	cNmMoO+yeUnlfeJpt/Pqh+OFBfICA2beKxUkFqMWorJwsGffhij/dAT/Q3X32LaIctbQ8fUiFxC
	gh/8KJxrOShmmu8pE8UlE7UEjSZATD6FawN528V9Iej8l6p0xYUA/zFPayQ/KUAotCaJLaWthQQ
	+lR5hg==
X-Received: by 2002:a05:7022:fc03:b0:128:d4be:7428 with SMTP id a92af1059eb24-1851229662fmr6253633c88.19.1792341110987;
        Sun, 18 Oct 2026 09:31:50 -0700 (PDT)
Received: from codespaces-393231.mimvmn1ww3huhhjmzljqefhnig.rx.internal.cloudapp.net ([4.240.39.195])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-183190aa7bbsm21629178c88.5.2026.10.18.09.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 09:31:50 -0700 (PDT)
From: Eklavya Singh <eklavyasingh2106@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Eklavya Singh <eklavyasingh2106@gmail.com>,
	syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2/heartbeat: serialize concurrent writes to a region's dev attribute
Date: Sun, 18 Oct 2026 16:31:21 +0000
Message-ID: <20261018163121.128911-1-eklavyasingh2106@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

o2hb_region_dev_store() checks reg->hr_bdev_file to see if the region
is already started, but nothing stops two writers from doing that at
the same time. configfs only serializes writes through the same open
file, so two processes that each open the dev attribute can both get
past the check:

  A: hr_bdev_file is NULL, opens file A, sets hr_bdev_file = A
  B: hr_bdev_file is NULL, opens file B, sets hr_bdev_file = B
  A: start fails, fput(hr_bdev_file) drops B, sets it to NULL
  B: start fails, fput(NULL)

Both calls also use the same hr_slots, hr_slot_data and hr_tmp_block,
so the error paths can free the slot data twice.

syzbot hit the fput(NULL) with an unbound loop device, where every
start fails with -EIO. With four threads doing the same thing on a
KASAN kernel I get both crashes within a second:

  BUG: KASAN: double-free in o2hb_unmap_slot_data+0x14d/0x2f0
  BUG: kernel NULL pointer dereference, address: 0000000000000158

Add a mutex to the region and take it in dev_store(), in the
block_bytes, start_block and blocks stores, and in dev_show(), since
they all look at hr_bdev_file. dev_store() sleeps with it held while it
waits for the heartbeat thread. That is fine because neither the thread
nor the teardown paths take it.

With the patch the same test ran for 10 minutes with lockdep on and
nothing was reported.

Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Reported-by: syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d4e96acd0febccb5e87
Cc: stable@vger.kernel.org
Signed-off-by: Eklavya Singh <eklavyasingh2106@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 1c3def99b..2ea870098 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -269,6 +269,8 @@ struct o2hb_region {
 	struct list_head	hr_handler_list;
 	/* Serializes timeout arming against failed-start and teardown. */
 	struct mutex		hr_arming_mutex;
+	/* Serializes the region's configfs attributes against dev_store(). */
+	struct mutex		hr_dev_mutex;
 	bool			hr_stopping;
 
 	/* last hb status, 0 for success, other value for error. */
@@ -1676,6 +1678,7 @@ static ssize_t o2hb_region_block_bytes_store(struct config_item *item,
 	unsigned long block_bytes;
 	unsigned int block_bits;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1705,6 +1708,7 @@ static ssize_t o2hb_region_start_block_store(struct config_item *item,
 	char *p = (char *)page;
 	ssize_t ret;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1731,6 +1735,7 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 	char *p = (char *)page;
 	int ret;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1748,10 +1753,12 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 
 static ssize_t o2hb_region_dev_show(struct config_item *item, char *page)
 {
+	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned int ret = 0;
 
-	if (to_o2hb_region(item)->hr_bdev_file)
-		ret = sprintf(page, "%pg\n", reg_bdev(to_o2hb_region(item)));
+	guard(mutex)(&reg->hr_dev_mutex);
+	if (reg->hr_bdev_file)
+		ret = sprintf(page, "%pg\n", reg_bdev(reg));
 
 	return ret;
 }
@@ -1879,6 +1886,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	ssize_t ret = -EINVAL;
 	int live_threshold;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -2156,6 +2164,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	reg->hr_key = crc32_le(reg->hr_region_num + O2NM_MAX_REGIONS,
 		name, strlen(name));
 	mutex_init(&reg->hr_arming_mutex);
+	mutex_init(&reg->hr_dev_mutex);
 	reg->hr_stopping = true;
 	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
 	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
-- 
2.55.0

