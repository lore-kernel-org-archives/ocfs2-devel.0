Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792501454;
	b=ou1aIpsMhpXlDriM8bL/evIQAAUQpi3c4FXO5bePf1vlAjVthJ19UUwCv2wR8h0hoK7C
	 XnR3gsI5ic214YYmzbz2A0gUumOTlN61t0lVVnkm+JpCHh+l7vKOQpRM1SPmBs9jZs0SQ
	 2l3QKZ6ZQlByj8UYFLwv7m8fXXNGtBrWGMvbK2ZGi1AluB4hDWH36I2bdkfBCR/tzzTqp
	 6KNYE2SlXhR+8jImmRiJbWXbNVaFmqYOGflDsfkdtBgN5WeBiTMAOJpS9sJzi0Gh/iGDh
	 DeJVyl2aVPAzu49RghRJsGWeIxnIBgtwkWrLXsUm7dWhlYASd8jaDjoHXDM6JaEhOuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792501454;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PYSPbfibjCMAgfbLhUn692RCNw6C4KcKQJGM8L0iQ9Y=;
	b=XNdY6B5BKoOC6DRpBaHo3nUdFED/ZImR0GDz/DIh0Wj0Gl759vEHK+qSALlP4sQccxu1
	 teQA5TaZ8bJ0Hq+9nkEXV325NIGQqOSf7wlLTlcBcwnUUQw8Onz52HUr5JkPHt8NnzgTG
	 xpUE7yESJag2oDOsw1cOBcO/LO+nlA1vP8up8nYzdEfFI0rMeDl6EhsTpTTRVnnRwx5gO
	 ghZn2+uCT8ihuat5SrEBkZPvM/R69GCdWLhu+WTaD5ZY9F+t+sCCfjX8gGUdRHM84Ea4k
	 heWKZbf9XMxH28f56MOsLrfs9pGnRH3Nk+quv7KZqMSdzHG33G2BxsRTV5H2CCJAifw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QNfWp0i2;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D7F606A31C
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 13:04:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82D7F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QNfWp0i2
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a06210b29fso843112b3a.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 06:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792501453; x=1793106253; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PYSPbfibjCMAgfbLhUn692RCNw6C4KcKQJGM8L0iQ9Y=;
        b=QNfWp0i2WCxk9S+Fg7c6TkpJZa6b77DqUjNM1mC3kwGPpaLkEdg8Rl11BpyVvoBUYX
         sQcbo1UwI4ZTYUTahKMbboreQPbGtnvl0xJeTgufRTahszNxVAMk5UFaUgDueWS5D25T
         hvEF70QOB+SUsoyCdvMxrMuG8FtiNMZ3LFrFxHNgrpEIqEZnze9JvEQKPyno+TAStgVl
         rdQ0xGA77mErCAtTT6bumtSuPIMUx1yPVix0rKbHiYh1NtTtlZepdg0g1kSN7I+q0tnZ
         TOl3KvPTYRBpEr6ehwnyueq7qts1CZ1TN4o5/d1WpP91zm0iDsZoCCM0vuySM8rkFMzR
         1u1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792501453; x=1793106253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PYSPbfibjCMAgfbLhUn692RCNw6C4KcKQJGM8L0iQ9Y=;
        b=z9+BO5j6z2M61wkGfSLLx+isK9TwBS5yXuwi1JhcIHvofziNXQY4f0VEmmJvB+eUjB
         uZ8QvHCd6XRFFoQqc6nSpdcXQzECIub3B5oxjOe9dH0Qwxv/8JqHqzhRZLG39egtftDb
         RkDaMNrzu6tSXOyAXQEG0mR4C11MCVLe7i134HJ2/xli1P02ymEsBgSBOhE9wCyrTtVv
         QmaoxNIuo6ngW43IkyNEE98JG7INRd31AZOZwFKds6dtz1xuNMQ9p+Pin99r6pcuu6SC
         6dMX2+1Ze0jcQjSnXP1odcDA5TrekpazvO9r7VSE2nD40Y2+xZSD9tnjjvt1GZPhQcSD
         DgXg==
X-Forwarded-Encrypted: i=1; AKwUvBznfRqEPTZKTazg9kCfybPfM8U5aShsDZ3l51PpP8T7mWcxUASQEdnGrjuANkoKELZfob3m0zaOm5sXsA==@lists.linux.dev
X-Gm-Message-State: AFq9FYLlsa3L2bk3GGDsFviGQSwdHCWwntiUbAT1iq5w2SqWCWv22pG+
	8gTBE3Z6DPsTniU+hA69xgfCYpwT/ONe5gXm9nBNPp1YtX2Ziu/id4gz
X-Gm-Gg: AYBFou3TCRr2cT94O73iLEuLeViuoC47kY0iBMNnf0Ird9t0ArPx4RePTYVsvKskV4E
	q8ki2udwWAyd6X/j/CvO4iSGzUA8VV0bM/WKAtRt+wG/ptKn1c9l+xOlFgcm29pG6xhWUsgzfu2
	17whfq+ym8KZVf0kJgN0CedHkYt9qR9904+U3xnLESGicOquwYemy5/3hI9xk4iVkbpt0XMBY0X
	/ivG613W0QIf5drHJkEfsc4PGLka9tM0kRbXqgEkzSUv4E0NpojYay0ZZTPgl/vvKAT5h4rbwFf
	+ZDcfXx8FUyuxlqgM73/LPft5ReDdRAlSuDTloymTLFMhdEYrQKrfWjKD2GXOEEqXInxlN+dZj8
	CaQZpdqo8f2ggyY2vaFKAr6xW6LLDY5nLF1TIk1lzoE1bVXAYhMYeN6x/2mvv+H5B+3k/RE8hQx
	4Ytr66qFCAYFGamAKRJO8k426cKpaTYKHieNIUVRaHHww20pI0Lj14Ab71u0kGjrSz2w==
X-Received: by 2002:a05:6a21:3949:b0:3de:46cc:b63c with SMTP id adf61e73a8af0-3e225f34c37mr8453562637.11.1792501452699;
        Tue, 20 Oct 2026 06:04:12 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd6549fb556sm5267685a12.22.2026.10.20.06.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 06:04:12 -0700 (PDT)
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
Subject: [PATCH] ocfs2/dlm: drain join handlers before releasing module text
Date: Tue, 20 Oct 2026 21:04:04 +0800
Message-Id: <pm-ocfs2-objects-candidate-0076-v5-dd198d8a9358ad81f70e@gmail.com>
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

The code for a registered DLM handler must remain resident until its
last invocation finishes. dlm_unregister_net_handlers() only removes
dlm_join_handlers from the o2net registry. o2net_handler_get() takes a
kref on the wrapper, but that reference does not pin ocfs2_dlm text.
o2net_process_message() calls nh_func after dropping o2net_handler_lock.

With CONFIG_OCFS2_FS_O2CB=m, ocfs2_dlm can be loaded independently of
ocfs2_stack_o2cb while nodemanager continues handling messages from a
configured, heartbeating peer. If no dependent module or module reference
prevents normal unload, the following ordering is possible:

  Receive worker                       Module unload
  --------------                       -------------
  o2net_handler_get()
    take wrapper kref
    drop handler lock
  <preempted>
                                       dlm_exit()
                                         unregister handlers
                                       release DLM module text
  call saved nh_func
    in released module text

Use o2net_unregister_and_flush_handler_list() in the shared DLM
unregister helper. It first prevents new lookups, then waits for the
ordered o2net workqueue to drain, including a concurrent destruction of
that queue. The acquired invocation therefore finishes before dlm_exit()
returns and the loader releases the callback code. The same helper also
covers partial registration and dlm_init() error unwind before module
memory is released.

Oops report as below:

    Oops: int3: 0000 [#1] SMP KASAN NOPTI
    CPU: 2 UID: 0 PID: 54 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)

Hardware identification omitted.

    Workqueue: o2net o2net_rx_until_empty [ocfs2_nodemanager]
    RIP: 0010:0xffffffffc0423871
    Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc

Register dump omitted.

    Call Trace:
     <TASK>
     ? o2net_rx_until_empty+0x19b1/0x3300 [ocfs2_nodemanager]
     ? __pfx_o2net_rx_until_empty+0x10/0x10 [ocfs2_nodemanager]
     ? lock_acquire+0x190/0x300
     ? process_one_work+0x935/0x1b40
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     ? kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ? ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ? ret_from_fork_asm+0x1a/0x30
     </TASK>
    Modules linked in: ocfs2_nodemanager [last unloaded: ocfs2_dlm]
    ---[ end trace 0000000000000000 ]---

Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: <stable@vger.kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM
---
 fs/ocfs2/dlm/dlmdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 97bb9400e24b..0f4d29cbce81 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -2215,7 +2215,7 @@ static LIST_HEAD(dlm_join_handlers);
 
 static void dlm_unregister_net_handlers(void)
 {
-	o2net_unregister_handler_list(&dlm_join_handlers);
+	o2net_unregister_and_flush_handler_list(&dlm_join_handlers);
 }
 
 static int dlm_register_net_handlers(void)
