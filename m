Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11737475
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Aug 2023 13:14:51 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-686b879f605so4622315b3a.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 02 Aug 2023 06:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690982091; x=1691586891;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVnuD160K1/bLpyFapN48ZIB6cDl10OXwltvfzUcoDg=;
        b=lKRGyHwfC5W65UY67qnwfkM/FOoiM+bRZpkrMf6xdG/hRDmik91CFrCNaVE4mwQrxT
         Hfayg31dAoD8KqRs3mmAxsSTnJDrtBGO973KD3IwENZ2ceV7W2GDZs7NKvUusfstRzPR
         ELx6rtNwrjyPRCa2Tbc6COKuNVOzMF8+0GRQm+hZnBkksuJH+fK5S75Dn15orq9xOrPM
         iCDUIQ4ZccsyBL4cPQjh7G+8IOlsYBYWWX/bmuFl9KrayxXemSXTbF+nWaC/8MgwTmPg
         gRphx+xOP6qTlyVzuHjIPKGFxhsouXlWeKEwT7fvsX0owVS9eg1mkCzqPpMmAyat3SFb
         tcVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690982091; x=1691586891;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVnuD160K1/bLpyFapN48ZIB6cDl10OXwltvfzUcoDg=;
        b=kjKlxVzcCWcFK5JekmFFH8Gl/JLwtB49LBiO8MG3KZNreKQkJBoWaaGlEVxJg53MkE
         Z7jInb9JGNLyUIOI0Lpnyvitz4jDtBeB5MmKhpIPibpO62BWMLC5yj29PtANSaSwUs89
         2hlssK8oXRlGoci2LGjOQsNxlldBSMS8dTJQRZa0PL9psVddjYE4sK7eFuEnJ+LZO4eJ
         sAX/KM8HidAscYJ641LJdSLTyBtgYh4t4IZ32A9KZrMMctiPT2u55AIeZuSXUaijfBhn
         a2D9PBxT/Rb0ePbfyeP4nxFtXndLYDoqH0EcucsqMRlPOwo3lSNqTjKDGIY/tlBiJjK0
         byCA==
X-Gm-Message-State: ABy/qLbdnKGh00BPwYpNTxL/HECxWXTAaiV4FTwkgOEh1plzK+OGQ6KM
	FBGelnLPN/eb5s85CLNKeD8=
X-Google-Smtp-Source: APBJJlH6x7+QO5XQsSIqXDhFEZl+mm/X+v84i20gEoNwsZWL5nh3dMGOkb73JgqvYP0lqna4DTa5jA==
X-Received: by 2002:a05:6a21:a109:b0:127:76ab:a707 with SMTP id aq9-20020a056a21a10900b0012776aba707mr12847347pzc.30.1690982090948;
        Wed, 02 Aug 2023 06:14:50 -0700 (PDT)
Received: from 377044c6c369.cse.ust.hk (191host097.mobilenet.cse.ust.hk. [143.89.191.97])
        by smtp.gmail.com with ESMTPSA id p5-20020a63ab05000000b0054fa8539681sm11612537pgf.34.2023.08.02.06.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 06:14:49 -0700 (PDT)
From: Chengfeng Ye <dg573847474@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <dg573847474@gmail.com>
Subject: [PATCH v2] ocfs2: cluster: fix potential deadlock on &o2net_debug_lock
Date: Wed,  2 Aug 2023 13:14:36 +0000
Message-Id: <20230802131436.17765-1-dg573847474@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>

&o2net_debug_lock is acquired by timer o2net_idle_timer() along the
following call chain. Thus the acquisition of the lock under process
context should disable bottom half, otherwise deadlock could happen
if the timer happens to preempt the execution while the lock is held
in process context on the same CPU.

<timer interrupt>
        -> o2net_idle_timer()
        -> queue_delayed_work()
        -> sc_put()
        -> sc_kref_release()
        -> o2net_debug_del_sc()
        -> spin_lock(&o2net_debug_lock);

Several lock acquisition of &o2net_debug_lock under process context
do not disable irq or bottom half. The patch fixes these potential
deadlocks scenerio by using spin_lock_bh() on &o2net_debug_lock.

This flaw was found by an experimental static analysis tool I am
developing for irq-related deadlock. x86_64 allmodconfig using gcc
shows no new warning.

Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>

Changes in v2
- Fix typo in commit title
---
 fs/ocfs2/cluster/netdebug.c | 40 ++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 35c05c18de59..bc27301eab6d 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -44,17 +44,17 @@ static LIST_HEAD(send_tracking);
 
 void o2net_debug_add_nst(struct o2net_send_tracking *nst)
 {
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	list_add(&nst->st_net_debug_item, &send_tracking);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 }
 
 void o2net_debug_del_nst(struct o2net_send_tracking *nst)
 {
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	if (!list_empty(&nst->st_net_debug_item))
 		list_del_init(&nst->st_net_debug_item);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 }
 
 static struct o2net_send_tracking
@@ -84,9 +84,9 @@ static void *nst_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	nst = next_nst(dummy_nst);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return nst;
 }
@@ -95,13 +95,13 @@ static void *nst_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	nst = next_nst(dummy_nst);
 	list_del_init(&dummy_nst->st_net_debug_item);
 	if (nst)
 		list_add(&dummy_nst->st_net_debug_item,
 			 &nst->st_net_debug_item);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return nst; /* unused, just needs to be null when done */
 }
@@ -112,7 +112,7 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 	ktime_t now;
 	s64 sock, send, status;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	nst = next_nst(dummy_nst);
 	if (!nst)
 		goto out;
@@ -145,7 +145,7 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 		   (long long)status);
 
 out:
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return 0;
 }
@@ -191,16 +191,16 @@ static const struct file_operations nst_seq_fops = {
 
 void o2net_debug_add_sc(struct o2net_sock_container *sc)
 {
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	list_add(&sc->sc_net_debug_item, &sock_containers);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 }
 
 void o2net_debug_del_sc(struct o2net_sock_container *sc)
 {
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	list_del_init(&sc->sc_net_debug_item);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 }
 
 struct o2net_sock_debug {
@@ -236,9 +236,9 @@ static void *sc_seq_start(struct seq_file *seq, loff_t *pos)
 	struct o2net_sock_debug *sd = seq->private;
 	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	sc = next_sc(dummy_sc);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return sc;
 }
@@ -248,12 +248,12 @@ static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct o2net_sock_debug *sd = seq->private;
 	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	sc = next_sc(dummy_sc);
 	list_del_init(&dummy_sc->sc_net_debug_item);
 	if (sc)
 		list_add(&dummy_sc->sc_net_debug_item, &sc->sc_net_debug_item);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return sc; /* unused, just needs to be null when done */
 }
@@ -349,7 +349,7 @@ static int sc_seq_show(struct seq_file *seq, void *v)
 	struct o2net_sock_debug *sd = seq->private;
 	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	sc = next_sc(dummy_sc);
 
 	if (sc) {
@@ -359,7 +359,7 @@ static int sc_seq_show(struct seq_file *seq, void *v)
 			sc_show_sock_stats(seq, sc);
 	}
 
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return 0;
 }
-- 
2.17.1

