Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502195;
	b=swMTydLygdDmgAe4MkH/vHqSyvMf8Bo1BV1seGo3RGvae8GRaWyz9gBAWBeFmqhKdds3
	 0Ttw70Nf9i36wa8Qyurx156Sg/WAEWxlCgDpnB0X+4PoUT6ZDqsfTMSyX3YzK591x2HXu
	 bgMwsx8qWwQrf70GgezK0qIFYxXhvfR+t9EYCfOw1PKi69Q+hCQjTRio0JobE2zsOCRtn
	 MH2IRIj/DP7NqRJtZVWbXru3Vj+pAZ1rYxvAVjFA2qBObdXT5feISUY9GPFozz0iDdCU6
	 8TQudIZOxnNOjCrsjXIuOVBvpFLtE1ZBNHNnu/scSfT07SupxJ1DKlrcoorYM58dvIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502195;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=F3m/+L4fUaNtacc/BKjjfkqz9A0nN/jif39xvTqMZ1Q=;
	b=H3JAkGp72mvi9k+9eQ68hOjwXZ358QgLV/qn7XVgRF2vcZTs6ICtbysvViTfULmqQgoz
	 R/MTXdSldRbVnF0eb37LxShED47bJk+DKWV30xDjKa+TR/YZo2UB7wdIKEFSErIE2R0FZ
	 iKO7I6EgMVJmSAdDjkoMxB+rh6rUTgoSQMdvgSNJJ8jsOFv+uL8KJwF3wS40FAWsS0v7p
	 o7B5BPw2PnGgJVqHkDeu+Aj5klzpsGC1SZi7p5CbpVbTpjy3wSQKVjr+IeiDUc8+PQ9KC
	 w2lu03l6vmS/3ibnE1zvoJfmOZP5uloxvKzr48VgZFfmOI3ShN/52pbKp7mQ44JVU8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ENWYYo1l;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A644606A31F
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 13:16:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A644606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ENWYYo1l
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e8ad5b31c7so18097285ad.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 06:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792502193; x=1793106993; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F3m/+L4fUaNtacc/BKjjfkqz9A0nN/jif39xvTqMZ1Q=;
        b=ENWYYo1lWLAvx/jyPcZzmnU8Ye8q1wufFw7RGE285axhLnkL8SVgGHO2f299QX8hx2
         eEq7LZoPxY3yq/ktpcblMwTAuZ2JupoJGNoQZX25w1OrLrLGl2fDb70YZVvXKSlFepOB
         dOJjmze34lViRMFVuJg8o+pj3cGB+yVGN6GyQLbQ4fqsiC40/vEUQxljVoACpxLsJcf0
         Ri9c7UCmQ4jqk/shIOXL0J99eE1AaExJTpQS9j/rLHXXaZQ1rQFk+EkafnDuQOCffdf+
         XsazrxDXxMfHnaNOaKirAncLp9+e402+XngGriUBqinI/4K6IfOOji+kjzBGaKAvNFQj
         Hv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792502193; x=1793106993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F3m/+L4fUaNtacc/BKjjfkqz9A0nN/jif39xvTqMZ1Q=;
        b=G9GB62Nf6FpMxlCBPRACqb4IAHh95p0pi/bPw6FgaLi6VYfLpYNT14Ix2KbpDwyyqE
         M+DDK7aiKl0Uy363FS3h4zuWaYOmnF4oJ8spzMEOef+QtfYg2GwE87V4Q4vqBjkejut8
         uFM8rQhcEDIxkJKKQPtgmnobEHsAX2Q69ybipZ0UVbLP4EX7vIOvPBEI1HH4gvTwPpRi
         8pZ3FekW8f7IUwXmPDq7t8dT+QrOLrcu+vzxoxuWSRB3/X/HwE+W7XjUSsQl/fffdJW9
         opiJS0qm7tAkiQ/Kmp1cVmrRKsVOp4ZRh+i3mXgKZDew7Npt/kFqgD+4eRnUGqrZdnIK
         8B8g==
X-Forwarded-Encrypted: i=1; AKwUvByeQ8zWg+ABCnhB14XyakpEexQfKZEMgrQJq1tznKhhW9fWS6Pwv8JWR54NU3lxH8SRjyQ9lwnxv178hQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYLy0ezKuXvY/1b/re0uXE2nmqBqeyyUcXvt4QfpB0Mg+zeZervA
	nWnPNHhWOW28q5Gbhs3uWvFEM78rELmgqEy95mgF38IdrBu1erfsnxr8
X-Gm-Gg: AYBFou1vMWNKnfpArrNKqtFcYoSPY0nFDyTMHb7Mz7Jb+JZJFW00/tHlArXBsC3+AiK
	ynmc2Z584njlunMpBx6cQIbak68tVln4xp805sO5p5dafizgLU4+rumNOlWNHuF2m7uO+jGNedm
	QCWHacb2jhVVYsmaxgYbpo4cicxAGGqBzrTCsle/nC5fv0+tVVrxFlH//0+tnccJRZ/wScNNdpo
	h/PU7idSP89dwSiuKo6i73B289yoBvEwzUm1tfIOb78O5WBFzQdZuUpazQuPXiemeDXayKBV9JQ
	wWBdYGe68Fkfr2wFmj4oYxbFIeuI0XJ83yg6rp3lz9bCE9oKVOCqgo8ubevf1P6P+5vG1Iu4c2I
	PjHQXkvruzt0YDPxolVYewlLHmKSuoEr1TaIV0BG1HoL4Tq1iBh+ZWM9kIy9TyFLfz3JfBDQPhF
	ICdmXtWesRNEe3TV1TxIX03+whCCp/fk/6VY82Im3imhVXEsfDDLlR7OS1n3Yf5XY5MQ==
X-Received: by 2002:a17:903:37cc:b0:2e8:4040:792b with SMTP id d9443c01a7336-2e9a6a0c86dmr94936015ad.22.1792502193310;
        Tue, 20 Oct 2026 06:16:33 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1501e24fsm11843535ad.42.2026.10.20.06.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 06:16:32 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH] ocfs2/cluster: serialize heartbeat block count with device setup
Date: Tue, 20 Oct 2026 21:16:26 +0800
Message-Id: <pm-ocfs2-objects-candidate-0077-v6-eb25e73523a3cb94fae0@gmail.com>
X-Mailer: git-send-email 2.34.1
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

A heartbeat region's hr_blocks must match the number of slots allocated
in hr_slots until its thread stops. o2hb_region_blocks_store() checks
hr_bdev_file before updating hr_blocks, but neither operation is
serialized with device publication in o2hb_region_dev_store().

Writes to blocks and dev through separate configfs opens can overlap.
The buffer mutex is per open, and both callbacks hold frag_sem for read.
With an initial count N, the following order is possible:

  blocks writer               device writer
  -------------               -------------
  check hr_bdev_file == NULL
                              publish hr_bdev_file
                              allocate N slots in o2hb_map_slot_data()
                              start o2hb_thread() and return
  store hr_blocks = M, M > N
  return

After both writes finish, normal region removal calls kthread_stop().
o2hb_thread() iterates over the enlarged count and passes &hr_slots[N]
to o2hb_shutdown_slot(), which reads ds_node_num beyond the allocation.

Recheck the device guard and update hr_blocks under o2hb_live_lock, and
publish the device file under the same lock. Open the device into a
local pointer to keep the sleeping open outside the spinlock. A blocks
write then either completes before publication and determines the slot
count, or sees the published file and returns -EINVAL. Clear the file
under the same lock after failed-start cleanup has stopped the thread
and unmapped the slots, so configuration can resume safely.

KASAN report as below:

    BUG: KASAN: slab-out-of-bounds in o2hb_thread+0xc62/0xe90
    Read of size 1 at addr ffff888107829ac0 by task o2hb-pmbd-regio/497

    CPU: 3 UID: 0 PID: 497 Comm: o2hb-pmbd-regio Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? o2hb_thread+0xc62/0xe90
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? o2hb_thread+0xc62/0xe90
     kasan_report+0xe0/0x110
     ? o2hb_thread+0xc62/0xe90
     o2hb_thread+0xc62/0xe90
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_o2hb_thread+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __lock_acquire+0x5a3/0x2140
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lockdep_hardirqs_on_prepare+0xeb/0x1a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_o2hb_thread+0x10/0x10
     ? kthread+0x351/0x460
     kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>

    Allocated by task 496:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_noprof+0x2de/0x780
     o2hb_region_dev_store+0x7c4/0x1c70
     configfs_write_iter+0x2f9/0x4f0
     vfs_write+0x639/0x1010
     ksys_write+0x111/0x200
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff888107829a80
     which belongs to the cache kmalloc-64 of size 64
    The buggy address is located 8 bytes to the right of
     allocated 56-byte region [ffff888107829a80, ffff888107829ab8)

(Page and memory-state dump omitted.)

Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: <stable@vger.kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM
---
 fs/ocfs2/cluster/heartbeat.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index b45adc39aacc..7448ee53aebe 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1746,7 +1746,13 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 	if (tmp > O2NM_MAX_NODES || tmp == 0)
 		return -ERANGE;
 
+	spin_lock(&o2hb_live_lock);
+	if (reg->hr_bdev_file) {
+		spin_unlock(&o2hb_live_lock);
+		return -EINVAL;
+	}
 	reg->hr_blocks = (unsigned int)tmp;
+	spin_unlock(&o2hb_live_lock);
 
 	return count;
 }
@@ -1878,6 +1884,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 {
 	struct o2hb_region *reg = to_o2hb_region(item);
 	struct task_struct *hb_task;
+	struct file *bdev_file;
 	long fd;
 	int sectsize;
 	char *p = (char *)page;
@@ -1911,13 +1918,22 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	if (!S_ISBLK(fd_file(f)->f_mapping->host->i_mode))
 		return -EINVAL;
 
-	reg->hr_bdev_file = bdev_file_open_by_dev(fd_file(f)->f_mapping->host->i_rdev,
-			BLK_OPEN_WRITE | BLK_OPEN_READ, NULL, NULL);
-	if (IS_ERR(reg->hr_bdev_file)) {
-		ret = PTR_ERR(reg->hr_bdev_file);
-		reg->hr_bdev_file = NULL;
-		return ret;
+	bdev_file =
+		bdev_file_open_by_dev(fd_file(f)->f_mapping->host->i_rdev,
+				      BLK_OPEN_WRITE | BLK_OPEN_READ,
+				      NULL, NULL);
+	if (IS_ERR(bdev_file))
+		return PTR_ERR(bdev_file);
+
+	/* Freeze hr_blocks before allocating the slot array. */
+	spin_lock(&o2hb_live_lock);
+	if (reg->hr_bdev_file) {
+		spin_unlock(&o2hb_live_lock);
+		fput(bdev_file);
+		return -EINVAL;
 	}
+	reg->hr_bdev_file = bdev_file;
+	spin_unlock(&o2hb_live_lock);
 
 	sectsize = bdev_logical_block_size(reg_bdev(reg));
 	if (sectsize != reg->hr_block_bytes) {
@@ -2036,7 +2052,9 @@ out:
 		o2hb_unmap_slot_data(reg);
 
 		fput(reg->hr_bdev_file);
+		spin_lock(&o2hb_live_lock);
 		reg->hr_bdev_file = NULL;
+		spin_unlock(&o2hb_live_lock);
 	}
 	return ret;
 }
