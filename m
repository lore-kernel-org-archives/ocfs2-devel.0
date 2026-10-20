Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792531444;
	b=d8za5y3FSuBXYaZvayKTx0whklts266Mo7bFKugshKsopmOzTR/BOA9b8P+FnR68izI4
	 VIJkX9hg4bIWsXoWl0JG5mfMcyRZn1zieUIXA0yuq27rWoEhPFxoOYKuZLFy5UqaFkaid
	 8e1OU50N+f/fpW/hMTxhK0sykNNJHBq8HnFlfuDlo3eiH46mTfvRhItAFsr04g+BmeToH
	 u/Tb5BsD3F/TBjwLLtZSiwiTb0c95oVbWLZRUWOARN9fB9Rg/ey1OFGcrfhKAu/3H4U5R
	 maRLzE+YtU7pUh8C0A3qN8oz2Min3lRY6NlWDcOLaxp2fK1dSR6Lodk1z0oCkq79whw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792531444;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sEPH3pV5NQDGveQ4gCC4SZc339s/ZpKzGxrmka5jI0c=;
	b=VQTrXsHPFtnIW4i9M9878XL6MLowdWCi/4/vA6rnHbxEu8OQFgiNXyq6mFmMs8bnQLF2
	 VmEVsIyaR5mnM3pUy0Vpv+0ckIi4AhMoEFy0CqJrk2cEDzO+JIMZtaCOvxmxmnw1lfN5s
	 FOU8pSFbLBFrx1viL7O0DhNukBdVfiHGpIxxNHWbW/Mmu/E4rbGGri9N2lYhjNdUCu76M
	 9ZGYYPq2ykRepKGQr2RegtzyNOcmmqCpCh8Fh0savIuWQwAoRqiMG++2Dh5FlYjpdlQMC
	 BTbL6HyfSS1apq1pr2yYps3iYm/rfgoXTlLR05/jbCPyCUsCvHuACFhwIb7gzhCuO4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=L9Xx5GCE;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DE8606A32D
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 21:24:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56DE8606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=L9Xx5GCE
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-33fb4680717so28811eec.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 14:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792531443; x=1793136243; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sEPH3pV5NQDGveQ4gCC4SZc339s/ZpKzGxrmka5jI0c=;
        b=L9Xx5GCEd94gnyEGmc5WRk89jfk5w5/FrThG1bmx3JnOT6ZZQJ6lTd8epOOMjOTbTL
         VVXyM46fMMQ5Zfdvc0W2nbHPhrEZhBGmlnN+soN/gPdIXqT0OhKFqP+Ynfkp/w0ToI+5
         qg8QZUjGrpGLZuHaTamVPW5x6hs+4IN1rYqege2MkkUJavn634HKudAdQgyjL7ch4OPO
         BFaifjwH5W/zbyBlF7yUnh3OUcY+YMeGhpcIPSzBYgjlUZUHulh6nw1O0Y/EAsusgm+W
         hhPqoonbTXMbmJNPsr0f2bfJAu8fCX8KO/eNqAdUdNWmjacTiFJNP5ghGgqTtRI5Xr/g
         3WZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792531443; x=1793136243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sEPH3pV5NQDGveQ4gCC4SZc339s/ZpKzGxrmka5jI0c=;
        b=pH/lapX9tEGN+eJXyFzvt7CI6ideEwzNhZG/0GCUIQjoFQJ2MSg97rKHjWk7vloo8C
         QKYfy0yvvio2Rk5RLoWF88nDhvjLH7a2CgvkZ2uds1eXJejgzUxCzjPjQ+cWaeLpIsnq
         Mcj7EmhMLO+XqN23MFH4u00XE7QaNPHKYXDMsviB2HyRE+F+Y1bS/HtPxq+5T/IRDqQb
         YdWeCN7RDHc1L9S3GPZFjRp9XAME5k8Yg1ln6OYlOCDwpzdXt4VJybay0vMPpzNdj1tf
         7o+2cW4aCsFdZ4Q45JJutup6aG6O6cmfNfhgr5Ndpl9dv/Y5do2ZbNhss1/o5hDyWhRT
         2irw==
X-Forwarded-Encrypted: i=1; AKwUvBzvbWuvdZ8p4sllVUEZeGtLpr4Zxg1zrIp/n2QckMhXSDvUm5SkdzM7HDWSGBXTLfmdSJTIOKJXf8suCA==@lists.linux.dev
X-Gm-Message-State: AFq9FYIH8YWkbfogQAqPf60LPl1y1Ehb1Wrvu0RKaa/eY5uGaytCNgA6
	ICGPgBM94xx+iY8lVnuUx9mEVAt45VHVRnkn8gqieoinFe3Igk+abfP9
X-Gm-Gg: AYBFou1fTX/au5DdWzd+32U+BX6vR4/oz0QY7JKxpDQ4fLwRaVsdyileG9n6QiWtQXT
	PAXiZn7jVEDQORa050r64TFswGsn8mrBxSUV/s0eymlsQmkaky0TTyyMqaI4ORYi0jUciQWoSPd
	isCbmuIizvBcJhRxNLvGhu4r79wD/a+zK2UaUS3uh81X6rYIXPiC9LogSSOPqMEQ+H4e5rE7l7J
	5DjGjJaSnrTJzEo4ZXKkZez0U815JrUDy1qjEzJwlkKAf4+wd9bRxfrTHKOFYPjA4UKxPyMxKzu
	E/V/pbfgEuZaeHnu2xKVvCu2HADhuvUXa01ShhWyNl7ByhSXbc+e+2xlkLhyHQOQqrNltL3Xp16
	jps5+KoIoSDhThy1zi4hecJNsiGfgSQkYvbKZs6kcLvGU2eMdfqDmsonYVfdkkxMnB2GpdULlCn
	OyPNTzv5r71GCyzITCfY7ZhXD5iOsfVEa94HU6W8cZSQMBkeCdAKKXG7R8Pj5cqxNLfb0oa+KHE
	2/HPkuaPF2SHRJ2j3I78jk43uz77kg=
X-Received: by 2002:a05:693c:884f:b0:359:9e84:dc99 with SMTP id 5a478bee46e88-367474becaemr467629eec.0.1792531443223;
        Tue, 20 Oct 2026 14:24:03 -0700 (PDT)
Received: from localhost.localdomain ([139.167.143.182])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36741e71eaesm2003444eec.26.2026.10.20.14.23.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Oct 2026 14:24:02 -0700 (PDT)
From: Eklavya Singh <eklavyasingh2106@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Cen Zhang <zzzccc427@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v3] ocfs2/heartbeat: serialize concurrent writes to a region's dev attribute
Date: Wed, 21 Oct 2026 02:53:39 +0530
Message-ID: <20261020212339.46591-1-eklavyasingh2106@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261019072936.2279-1-eklavyasingh2106@gmail.com>
References: <20261019072936.2279-1-eklavyasingh2106@gmail.com>
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
takes the mutex in a small wrapper rather than with guard(). The mutex
is dropped while dev_store() waits for the heartbeat to become steady,
which takes seconds, so a read of dev doesn't stall behind a start.
hr_bdev_file is already set at that point, so other writers still get
-EINVAL, and the cleanup after the wait retakes the mutex.

With the patch the same test ran for 10 minutes with lockdep on and
nothing was reported. So did a second one, with a working loop device,
that interrupts starts during the wait while other threads read and
write the attributes.

Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Reported-by: syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d4e96acd0febccb5e87
Cc: stable@vger.kernel.org
Signed-off-by: Eklavya Singh <eklavyasingh2106@gmail.com>
---
Changes in v3:
- rebase onto linux-next
- drop hr_dev_mutex while waiting for the heartbeat to become steady,
  so a read of dev that races a start no longer blocks (Joseph)
- name the four attributes in the hr_dev_mutex comment and assert the
  mutex is held in __o2hb_region_dev_store() (Joseph)

Changes in v2:
- take the mutex in a wrapper around dev_store() instead of with
  guard(), since dev_store() uses goto for its cleanup

Deepanshu Kartikey [1] and Cen Zhang [2] have posted patches for the
same race, and they conflict with this one. This version also takes
the mutex in dev_show(), which otherwise can read hr_bdev_file while a
failed start is dropping it.

[1] https://lore.kernel.org/all/20261020085100.8819-1-kartikey406@gmail.com/
[2] https://lore.kernel.org/all/pm-ocfs2-objects-candidate-0077-v7-34980443ec254b2a1ffc@gmail.com/

v2: https://lore.kernel.org/all/20261019072936.2279-1-eklavyasingh2106@gmail.com/
v1: https://lore.kernel.org/all/20261018163121.128911-1-eklavyasingh2106@gmail.com/

 fs/ocfs2/cluster/heartbeat.c | 40 ++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index b45adc3..7a18e71 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -269,6 +269,8 @@ struct o2hb_region {
 	struct list_head	hr_handler_list;
 	/* Serializes timeout arming against failed-start and teardown. */
 	struct mutex		hr_arming_mutex;
+	/* Serializes the dev, block_bytes, start_block and blocks attributes. */
+	struct mutex		hr_dev_mutex;
 	bool			hr_stopping;
 
 	/* last hb status, 0 for success, other value for error. */
@@ -1681,6 +1683,7 @@ static ssize_t o2hb_region_block_bytes_store(struct config_item *item,
 	unsigned long block_bytes;
 	unsigned int block_bits;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1710,6 +1713,7 @@ static ssize_t o2hb_region_start_block_store(struct config_item *item,
 	char *p = (char *)page;
 	ssize_t ret;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1736,6 +1740,7 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 	char *p = (char *)page;
 	int ret;
 
+	guard(mutex)(&reg->hr_dev_mutex);
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1753,10 +1758,12 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 
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
@@ -1872,11 +1879,9 @@ out:
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
@@ -1884,6 +1889,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	ssize_t ret = -EINVAL;
 	int live_threshold;
 
+	lockdep_assert_held(&reg->hr_dev_mutex);
+
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
@@ -1987,9 +1994,15 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 
 	wake_up_process(hb_task);
 
+	/*
+	 * Don't hold hr_dev_mutex across the wait, which can take seconds.
+	 * hr_bdev_file is already set, so other writers still get -EINVAL.
+	 */
+	mutex_unlock(&reg->hr_dev_mutex);
 	ret = wait_event_interruptible(o2hb_steady_queue,
 				atomic_read(&reg->hr_steady_iterations) == 0 ||
 				reg->hr_node_deleted);
+	mutex_lock(&reg->hr_dev_mutex);
 	if (ret) {
 		atomic_set(&reg->hr_steady_iterations, 0);
 		reg->hr_aborted_start = 1;
@@ -2041,6 +2054,20 @@ out:
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
@@ -2143,6 +2170,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 
 	INIT_LIST_HEAD(&reg->hr_all_item);
 	mutex_init(&reg->hr_arming_mutex);
+	mutex_init(&reg->hr_dev_mutex);
 	reg->hr_stopping = true;
 	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
 	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
-- 
2.52.0

