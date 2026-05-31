Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3938E8248B
	for <ocfs2-devel@lists.linux.dev>; Sun, 31 May 2026 04:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780202843; cv=none; b=oSOZbT9K9dDQItkf7D9BEAZONux/ZQONpU5t83vdaVNLckbSsLJP90nF8/gL1tTNLCA5rMi1Q0UYnCPpqqJnbbUc7b6aXCPy/eWjOuBZmQCko1aVcsNLmm1HarwourNzGGd9gO1LeHPDfH8s+gz410I0Wg3YTWkdyPUd8W+SkAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780202843; c=relaxed/simple;
	bh=2EQCwayL4OcjdOy/yauSvaJi3iM0Tk9Lrc5NZcMYGdk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=R31Kz5bzh61xGsUbMFcLSkHV01Pi9wwg76RNaBW7NRVTE9Vl4N+JBtJ6mwz/XwEw+TJfbdISiajKeJpVb6oAbtEoGCsjwViEa6gVYOsT1KD6A2X4PM75ZqnR9NmHy3i9DYxTPmtP3syzDlExqEW6YKJFYKi4YJHCNYKFWthpeNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sBLtbQvX; arc=none smtp.client-ip=209.85.215.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sBLtbQvX"
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-c8585c51f1fso348529a12.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 30 May 2026 21:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780202841; x=1780807641; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b6jQXpbofLGcqd7G5BY64NI7M9NX/olog+mYFxU0wY0=;
        b=sBLtbQvXg29DR80REB7/Lzs3BwIOx0rAsq6JRvG0qhzs6bHvuFQytWHskP1U2sDCgA
         Ibmnh2LWzD6mKw7O5VIX1Tl/I78f5fLGEsi5gvwUhtOYXYIdc1JgjM7mZ58NLVZsV5GK
         R2m5dBeIXaggL4dHPI1TbW4TmXds6f87lEavULrOUyRpkM8NQQ3OeJHB99RTj9312jiU
         Kf8Gtg+uCUju9E22+7rfRGVV+X+bV5TK5LlpSfsMY64ZfvWI01zMNXP88EnE6BwohzB4
         fyVF+w83R/pANu9KS28Vq+KcL2VvZICQGyD5yqYdH/NUBkzkfnAYLJW2DkDPASGMxeuZ
         244A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780202841; x=1780807641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6jQXpbofLGcqd7G5BY64NI7M9NX/olog+mYFxU0wY0=;
        b=F2L9D7fUNCb9bT0hCX/mt0uEP4Zc0QuIpXU/Kc2R1A3LsZNXf1KUHmwzrzX4tHqw9R
         cX+/l4CUYPlXY+FsoJmkL3diTL0Y426qLnA7rw6ecnnC9Wva+7qWTA0OhFSr8nx0ihaE
         Y4KMN+ZgX3UuwBdQjt9B95ekuaflXZFgo4fFzE/TzVX5CzsqLqv5mK896uCd0+LgHmAL
         EysLBdJN7fjy0YYLN3JaarViYLzxIYobE8ZX/NZXMsQopVzp8GCqdCsQNXM9jMO2wtBL
         YpZI6NHqPRKYNQTTuB5QoWqTLWD51OzC5ZasSyvSMvQGPapdyda+iqsQykGrLS2efAvr
         OCOQ==
X-Gm-Message-State: AOJu0YwiqQTGIeMKHcc/HqjFFe3+iLKiXlg6IO0uyV29e7/lQXoYtjMN
	KccAqxRWZvMHEUaY5/qpNJikKkBCQzXM00eX+E08w3A00b8gKx5DHMlf
X-Gm-Gg: Acq92OHFKP4VgO9TVdQZQh++Ejcx5hhGUeaqAgqPyX8WUJ4sxwkWypnLuSn7+Dxo8wg
	ArlWA94PKW+ruYLDN2QOA46gzAxHchZGohhSheLZG0cPw+/YCAnkjGyepmWFfbXyhmfiOrmg6es
	MTc1x+KP/UX+kHjhA0UwLHhd3WrtLVygytl6w9zoSVCExAYCn2VoyLpJ9cB9dij94VobqcvXxxK
	/kKss5LNj73qqC5NmNJ/jqUjB7B8qfCX2vMefIGK2X+SvIXLim7OzI9oRviIxgkx1mrC6D0Vsbm
	KSvaQY/CWIBabkIs/cctcXw8dy9ll84i4mDEwy+CfCyNqWlk1nU/fuzsUwQXXjhzFtOMvZAp2+9
	8IVzwgaymwrLI/N6BJ72B2vRHm7TfU5MnpONTzjFA/NXeBcuBoNGv1B8OvatsGXKHy1AjrvReDy
	5h2D9YSmpbpuacuEjE9a8sslMs5bjkd6pzzd1RsLx5dQ==
X-Received: by 2002:a05:6a21:7303:b0:38e:92f6:9ab1 with SMTP id adf61e73a8af0-3b426af5d56mr5188005637.22.1780202841209;
        Sat, 30 May 2026 21:47:21 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85771d367esm5957707a12.11.2026.05.30.21.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 21:47:20 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] ocfs2/dlm: require a ref for locking_state debugfs open
Date: Sun, 31 May 2026 12:47:14 +0800
Message-Id: <20260531044714.1640172-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

debug_lockres_open() copies inode->i_private into struct debug_lockres and
debug_lockres_release() later drops that pointer with dlm_put(). That only
works if open successfully pins the struct dlm_ctxt.

Today open calls dlm_grab(dlm) but ignores its return value. Once the last
domain unregister has removed the context from dlm_domains, dlm_grab()
returns NULL, yet open still stores the raw pointer and returns success.
The later release path is outside the debugfs removal barrier, so it can
call dlm_put() after dlm_free_ctxt_mem() has freed the context. KASAN
reports this as a slab-use-after-free in dlm_put() called from
debug_lockres_release().

Fail the open when dlm_grab() cannot acquire the reference and unwind the
seq_file private state before returning. That keeps locking_state from
handing out a file descriptor whose release path does not own the dlm_ctxt.

The buggy scenario involves two paths, with each column showing the order
within that path:

locking_state debugfs open:          last domain unregister:
1. debug_lockres_open() reads        1. dlm_unregister_domain() calls
   inode->i_private.                    dlm_complete_dlm_shutdown().
2. debug_lockres_open() calls        2. shutdown removes the dlm_ctxt from
   dlm_grab(dlm) and gets NULL.         dlm_domains.
3. open still stores the raw dlm     3. final teardown reaches
   pointer in dl->dl_ctxt and           dlm_free_ctxt_mem() and frees it.
   returns success.
4. debug_lockres_release() later
   calls dlm_put(dl->dl_ctxt).

Validation reproduced this kernel report:
KASAN slab-use-after-free in dlm_put+0x82/0x200
RIP: 0033:0x7f4d349bc9e0
The buggy address belongs to the object at ffff888103a3c000 which belongs
to the cache kmalloc-2k of size 2048
The buggy address is located 816 bytes inside of freed 2048-byte region
[ffff888103a3c000, ffff888103a3c800)
Write of size 4
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xd0/0x630 (?:?)
  dlm_put+0x82/0x200 (?:?)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x188/0x2f0 (?:?)
  kasan_report+0xe4/0x120 (?:?)
  kasan_check_range+0x105/0x1b0 (?:?)
  debug_lockres_release+0x53/0x80 (fs/ocfs2/dlm/dlmdebug.c:587)
  dlm_put+0x9/0x200 (?:?)
  debug_lockres_release+0x5c/0x80 (fs/ocfs2/dlm/dlmdebug.c:587)
  full_proxy_release+0x67/0x90 (?:?)
  __fput+0x1df/0x4b0 (?:?)
  do_raw_spin_lock+0x10f/0x1b0 (?:?)
  fput_close_sync+0xd2/0x170 (?:?)
  __x64_sys_close+0x55/0x90 (?:?)
  do_syscall_64+0x10c/0x640 (arch/x86/entry/syscall_64.c:87)
  irqentry_exit+0xac/0x6e0 (?:?)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
Freed by task stack:
  kasan_save_stack+0x33/0x60 (?:?)
  kasan_save_track+0x14/0x30 (?:?)
  kasan_save_free_info+0x3b/0x60 (?:?)
  __kasan_slab_free+0x5f/0x80 (?:?)
  kfree+0x30f/0x580 (?:?)
  dlm_put+0x1ce/0x200 (?:?)
  dlm_unregister_domain+0xf6/0xb30 (?:?)
  o2cb_cluster_disconnect+0x6b/0x90 (?:?)
  ocfs2_cluster_disconnect+0x41/0x70 (?:?)
  ocfs2_dlm_shutdown+0x1c4/0x220 (?:?)
  ocfs2_dismount_volume+0x38a/0x550 (?:?)
  generic_shutdown_super+0xc3/0x220 (?:?)
  kill_block_super+0x29/0x60 (?:?)
  deactivate_locked_super+0x66/0xe0 (?:?)
  cleanup_mnt+0x13d/0x210 (?:?)
  task_work_run+0xfa/0x170 (?:?)
  exit_to_user_mode_loop+0xd6/0x430 (?:?)
  do_syscall_64+0x3cb/0x640 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)

Fixes: 4e3d24ed1a12 ("ocfs2/dlm: Dumps the lockres' into a debugfs file")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
 fs/ocfs2/dlm/dlmdebug.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index fe4fdd09bae3..564567358620 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -560,6 +560,7 @@ static int debug_lockres_open(struct inode *inode, struct file *file)
 	struct dlm_ctxt *dlm = inode->i_private;
 	struct debug_lockres *dl;
 	void *buf;
+	int status = -ENOMEM;
 
 	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
@@ -572,16 +573,23 @@ static int debug_lockres_open(struct inode *inode, struct file *file)
 	dl->dl_len = PAGE_SIZE;
 	dl->dl_buf = buf;
 
-	dlm_grab(dlm);
-	dl->dl_ctxt = dlm;
+	/* ->release uses dl_ctxt after open, so it needs a real pin. */
+	dl->dl_ctxt = dlm_grab(dlm);
+	if (!dl->dl_ctxt) {
+		status = -ENOENT;
+		goto bailseq;
+	}
 
 	return 0;
 
+bailseq:
+	seq_release_private(inode, file);
 bailfree:
 	kfree(buf);
 bail:
-	mlog_errno(-ENOMEM);
-	return -ENOMEM;
+	if (status != -ENOENT)
+		mlog_errno(status);
+	return status;
 }
 
 static int debug_lockres_release(struct inode *inode, struct file *file)
-- 
2.43.0
