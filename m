Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B524C486BBF
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 07:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792395010; cv=none; b=OXBebaADvfmnYpRHDxiKk2MguAcZKdXSlXRm3RSbV30tlPLpeZw+0Em593WMgy/Kovp1sYoqIgdxRNnBYK4nv2mumsAh+y0lS+ny+2E+F/8zInYvW2wZ4Dk8G0LGn2N2Loq7fK/unNr51wYiPHp3OAlkCmiN1xoQedE99FhkHNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792395010; c=relaxed/simple;
	bh=KSLxsLECDBlglJ5ok09mHe2q8VxULP0ESynDUsj7NjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx8t+4gKkN251RhQ41tswIfm5Tt3tBCDwFNhriDK8nBqLTX6M09IUYFkLakJvgfTB5F6Ogm0jawpahGoBXkjPLvUr1NZs/HZ79a7+54iz0xL88Cnoj5cPSAli4rrHvrc3WYBZSSjylE/QS9Z8ITegrOodd6qZ0fm6NdLGffQ7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3mhVv6M; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3mhVv6M"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-16079d54c17so4274940c88.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 00:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792395008; x=1792999808; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W7q+tRZEp7x1zsFqvPs4W277M15/fE06QNYP4aD/T7c=;
        b=b3mhVv6M/9Byw/i5KV7Ec1+qV4Np6zw4sW03CGj4g7p83UGCDM34uAMgGkp0pUxYZU
         H8Bk89k2T1vN+8p9mOsnffNoo/fvi+8lF4SXGcfOFV/cUnx1zIqZv7Db8mtBe1Kj3gc3
         RLx3RkCZJ/gjzkVlsOxDEPes6av8yExJkZ/HjGUsk2PUOFVlRjwdxKq/X6JlLSZjqtS+
         Zzxd3pq1TnlsxrUnv9o9ugPAIeqb7M21LtOJJV/BBIu0DKU4H8C69HUHMzsXBrUDugq2
         UChFqJw3RCpKFxVC7kbAmrjNl5uUrGcbFh8193qZaSwzph3Hecipnm7nBN0uPPMvd2/N
         66zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792395008; x=1792999808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W7q+tRZEp7x1zsFqvPs4W277M15/fE06QNYP4aD/T7c=;
        b=GMQIJIMZZY322c/I9vOc3kvjBJIazqh49XesfSHaA1OHp3xXEKaHREoQAlzmtJnL1v
         o+70sZsr1BBQHPBtet3OkUdAPzMLiBIi/Dg6WgDT2vhRvz2NqEXX0bIFbhJ6Ma9KiDxh
         5sdON88Z3xijyZFdkwQy04nXgfgH5yLS0A9OY7xDeMYSf5hkPgDD29ZQWz9et7UAgcRZ
         46M7kGDsA6kX+Q8uJ/D362szzQUfYmbqHg4ymdDLISbdiC0nSqKU5o832UfC+kJeKDGZ
         Wjae+3GDfF74nxOZMK9PKo7dlFUiBlHsOHYqZztM9RmoT07cErvbYTt6GJePY/WGNeuA
         4q1g==
X-Forwarded-Encrypted: i=1; AKwUvBwKygKtHVAHYy7DzyIY0sReLcUYS2ZuidqQfwFf4jdI/XxHPbQPxrSJInllnVq/z2M1Vh0oWUIKRkRu8w==@lists.linux.dev
X-Gm-Message-State: AFq9FYIJAbc9BWWhV8gWybLDRKXgyN2sKWFh93OdE6s2BGCKwwuSm7bl
	Zu/8T62b/9zURwkdGi5pqKpgVmEXJLOz6AIPX5C7xz50FBiWmx+GSDEq
X-Gm-Gg: AYBFou0hFNO7ITpMn47e57xNtCTSi5JJ6rsHaGx6TY7vMXiyYtWp3u1fzWj+Eu3o42w
	FbKCxHuzA6UlNgE/9+Od+7uuyY07ymUECg6uS4W7ZDPg/FPrCBE9u7oW5LzWkDYHAss4Y1wU2cF
	w5AzpmbvVIhk4QpWaDJJlS3QSNI30ls75dHkL2kKd57/Mi6RY6wb9iXhEq1WHzj1JWisn3gWen1
	YeU8aW6qDUZPNEDaWAPRJCHGpLf3/YfEtDB3DqXyB2n1ry/bdtaBj8b+3vJ49E/hX00PHYd/GpO
	pZqN30svGofyKHAbvfjLEjsCtjqMYdqlhIuhWWZ/9HbzxDK7VFFkVSn8BYJguAtsjoJdawTWM5G
	GIc2T8lwKCLq4WXULwyRwUzbbR6uzu4zpMQZYT6WkYChS80hGzLXxGcrGFU5HWV14c8Uf6geZcF
	W7SAuOo+82tHagCyfQHoYVmaerWtGQzmY9l/ei251HG4tNJTtUSrPVaX66KVg77dqNxDaThWrc9
	6vQpjNPMWJXY8AU0glLhrBGFg28bhMj5B0nGeVCbguCe63hyN/DDZzW6ivNXmTmj2SWcj0b+0eQ
	Dtubug==
X-Received: by 2002:a05:701a:ca05:b0:17e:6de6:6a1a with SMTP id a92af1059eb24-18511ad9debmr11070852c88.8.1792395007422;
        Mon, 19 Oct 2026 00:30:07 -0700 (PDT)
Received: from codespaces-393231.mimvmn1ww3huhhjmzljqefhnig.rx.internal.cloudapp.net ([4.240.39.204])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831b75be5esm35134155c88.16.2026.10.19.00.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 00:30:06 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2/heartbeat: serialize concurrent writes to a region's dev attribute
Date: Mon, 19 Oct 2026 07:29:35 +0000
Message-ID: <20261019072936.2279-1-eklavyasingh2106@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261018163121.128911-1-eklavyasingh2106@gmail.com>
References: <20261018163121.128911-1-eklavyasingh2106@gmail.com>
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

Add a mutex to the region and hold it in dev_store(), in the
block_bytes, start_block and blocks stores, and in dev_show(), since
they all look at hr_bdev_file. dev_store() cleans up with goto, so it
takes the mutex in a small wrapper rather than with guard(). It sleeps
with the mutex held while it waits for the heartbeat thread. That is
fine because neither the thread nor the teardown paths take it.

With the patch the same test ran for 10 minutes with lockdep on and
nothing was reported.

Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Reported-by: syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d4e96acd0febccb5e87
Cc: stable@vger.kernel.org
Signed-off-by: Eklavya Singh <eklavyasingh2106@gmail.com>
---
v2: take the mutex in a wrapper around dev_store() instead of with
guard(), since dev_store() uses goto for its cleanup. No other changes.

v1: https://lore.kernel.org/all/20261018163121.128911-1-eklavyasingh2106@gmail.com/

 fs/ocfs2/cluster/heartbeat.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 1c3def99bb0..003c398366e 100644
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
@@ -1867,11 +1874,9 @@ static int o2hb_populate_slot_data(struct o2hb_region *reg)
  * this is acting as commit; we set up all of hr_bdev_file and hr_task or
  * nothing
  */
-static ssize_t o2hb_region_dev_store(struct config_item *item,
-				     const char *page,
-				     size_t count)
+static ssize_t __o2hb_region_dev_store(struct o2hb_region *reg,
+				       const char *page, size_t count)
 {
-	struct o2hb_region *reg = to_o2hb_region(item);
 	struct task_struct *hb_task;
 	long fd;
 	int sectsize;
@@ -2032,6 +2037,20 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	return ret;
 }
 
+static ssize_t o2hb_region_dev_store(struct config_item *item,
+				     const char *page,
+				     size_t count)
+{
+	struct o2hb_region *reg = to_o2hb_region(item);
+	ssize_t ret;
+
+	mutex_lock(&reg->hr_dev_mutex);
+	ret = __o2hb_region_dev_store(reg, page, count);
+	mutex_unlock(&reg->hr_dev_mutex);
+
+	return ret;
+}
+
 static ssize_t o2hb_region_pid_show(struct config_item *item, char *page)
 {
 	struct o2hb_region *reg = to_o2hb_region(item);
@@ -2156,6 +2175,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	reg->hr_key = crc32_le(reg->hr_region_num + O2NM_MAX_REGIONS,
 		name, strlen(name));
 	mutex_init(&reg->hr_arming_mutex);
+	mutex_init(&reg->hr_dev_mutex);
 	reg->hr_stopping = true;
 	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
 	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
-- 
2.55.0

