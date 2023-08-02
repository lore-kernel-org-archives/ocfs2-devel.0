Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3600C63B1
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Aug 2023 12:38:36 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3a5ad6087a1so4080818b6e.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 02 Aug 2023 05:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690979915; x=1691584715;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHj0ogn13uTD9ShXB2epVwSA8wIkWRIMgchHlQuBxLk=;
        b=WJgrzvkLDCxVrGzix111FmRTltpPpjO64wXrQbc3d4n8G+ckVsq12T9rapATZp2PW+
         lSIWWFy5GpvB5GHZlX2d0S9+rwXCmZDrWAo4Ujx87DJ4xEWP9lEdJlnieQYQ3xtiVfPI
         bk3wM9DbfoXAER0cr9qZLNpFF+lxJwht27dY+jWfBPQK5rujlRkkf9+ZgargfUTPoAGo
         u654rmIL1LsvndT2AqxeattLmn0BrUWY7goKlUuYzMH+EgXpjS3kM0GvJAku+2xS6VP+
         iULEc+LfoRtGopXWukQld7lm/yNSxkcB7khdxDqFIMwHM3CvhrDxdd5mScx/P21/DFgt
         xZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690979915; x=1691584715;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHj0ogn13uTD9ShXB2epVwSA8wIkWRIMgchHlQuBxLk=;
        b=cEHE6pY4CwUAl2qx1PFHnclOdhVJtiak+hgDFj3vIhnAovnQqEyiaGPk7mxc9rnqMW
         L2c7fE2ZO1OHoGsPkAkcYOjCbKIOw7dj2TQhYIjhXKrJF6lAI6b1iFSmAS0qFF1HiZcq
         sNOBdCNLfBqqJ9lentDnUA0kZk7hHXAiPQdbKr1gkoLkhwuAH0/HvDHp3BqvZdIYU/np
         qE0z6x991Ab6UOVao99uuKlbQcORNraunjaohH9D5ESiEtSABDH+bi0aDJIj8syYsMNo
         04WxzmUyNBYW3H9jUdFJtXZHY5ozL16pUDYd8XSypA4VyOd4bA+M5+m6gKjgnXjnvseS
         sb+Q==
X-Gm-Message-State: ABy/qLZDpyqIkcbvslTmGJHp6LZqTv2LRHAj6A6foQTnosGLjXJwso8A
	eEnESsgxIYiVd19HCJbL//Y=
X-Google-Smtp-Source: APBJJlGx9qMcCJMFddU0V+VzxGFmFG3wURPqhamSEipbPZmZopsqwCEWMBb6mbzA5GhBbttT7CZy1w==
X-Received: by 2002:a05:6808:2382:b0:3a0:38c2:2654 with SMTP id bp2-20020a056808238200b003a038c22654mr16938376oib.58.1690979915061;
        Wed, 02 Aug 2023 05:38:35 -0700 (PDT)
Received: from 377044c6c369.cse.ust.hk (191host097.mobilenet.cse.ust.hk. [143.89.191.97])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a001e00b00265c742a262sm1118029pja.4.2023.08.02.05.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 05:38:33 -0700 (PDT)
From: Chengfeng Ye <dg573847474@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <dg573847474@gmail.com>
Subject: [PATCH v2] ocfs2: cluster: fix potential deadlock on &qs->qs_lock
Date: Wed,  2 Aug 2023 12:38:24 +0000
Message-Id: <20230802123824.15301-1-dg573847474@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>

&qs->qs_lock is acquired by timer o2net_idle_timer() along the following
call chain. Thus the acquisition of the lock under process context should
disable bottom half, otherwise deadlock could happen if the timer happens
to preempt the execution while the lock is held in process context on the
same CPU.

<timer interrupt>
        -> o2net_idle_timer()
        -> o2quo_conn_err()
        -> spin_lock(&qs->qs_lock)

Several lock acquisition of &qs->qs_lock under process contex do not
disable irq or bottom half. The patch fixes these potential deadlocks
scenerio by using spin_lock_bh() on &qs->qs_lock.

This flaw was found by an experimental static analysis tool I am
developing for irq-related deadlock. x86_64 allmodconfig using gcc shows
no new warning.

Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>

Changes in v2
- Consistently use spin_lock_bh() on all potential deadlock sites of
  &qs->qs_lock
---
 fs/ocfs2/cluster/quorum.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index 189c111bc371..15d0ed9c13e5 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -93,7 +93,7 @@ static void o2quo_make_decision(struct work_struct *work)
 	int lowest_hb, lowest_reachable = 0, fence = 0;
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	lowest_hb = find_first_bit(qs->qs_hb_bm, O2NM_MAX_NODES);
 	if (lowest_hb != O2NM_MAX_NODES)
@@ -146,14 +146,14 @@ static void o2quo_make_decision(struct work_struct *work)
 
 out:
 	if (fence) {
-		spin_unlock(&qs->qs_lock);
+		spin_unlock_bh(&qs->qs_lock);
 		o2quo_fence_self();
 	} else {
 		mlog(ML_NOTICE, "not fencing this node, heartbeating: %d, "
 			"connected: %d, lowest: %d (%sreachable)\n",
 			qs->qs_heartbeating, qs->qs_connected, lowest_hb,
 			lowest_reachable ? "" : "un");
-		spin_unlock(&qs->qs_lock);
+		spin_unlock_bh(&qs->qs_lock);
 
 	}
 
@@ -196,7 +196,7 @@ void o2quo_hb_up(u8 node)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	qs->qs_heartbeating++;
 	mlog_bug_on_msg(qs->qs_heartbeating == O2NM_MAX_NODES,
@@ -211,7 +211,7 @@ void o2quo_hb_up(u8 node)
 	else
 		o2quo_clear_hold(qs, node);
 
-	spin_unlock(&qs->qs_lock);
+	spin_unlock_bh(&qs->qs_lock);
 }
 
 /* hb going down releases any holds we might have had due to this node from
@@ -220,7 +220,7 @@ void o2quo_hb_down(u8 node)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	qs->qs_heartbeating--;
 	mlog_bug_on_msg(qs->qs_heartbeating < 0,
@@ -233,7 +233,7 @@ void o2quo_hb_down(u8 node)
 
 	o2quo_clear_hold(qs, node);
 
-	spin_unlock(&qs->qs_lock);
+	spin_unlock_bh(&qs->qs_lock);
 }
 
 /* this tells us that we've decided that the node is still heartbeating
@@ -245,14 +245,14 @@ void o2quo_hb_still_up(u8 node)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	mlog(0, "node %u\n", node);
 
 	qs->qs_pending = 1;
 	o2quo_clear_hold(qs, node);
 
-	spin_unlock(&qs->qs_lock);
+	spin_unlock_bh(&qs->qs_lock);
 }
 
 /* This is analogous to hb_up.  as a node's connection comes up we delay the
@@ -264,7 +264,7 @@ void o2quo_conn_up(u8 node)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	qs->qs_connected++;
 	mlog_bug_on_msg(qs->qs_connected == O2NM_MAX_NODES,
@@ -279,7 +279,7 @@ void o2quo_conn_up(u8 node)
 	else
 		o2quo_clear_hold(qs, node);
 
-	spin_unlock(&qs->qs_lock);
+	spin_unlock_bh(&qs->qs_lock);
 }
 
 /* we've decided that we won't ever be connecting to the node again.  if it's
@@ -290,7 +290,7 @@ void o2quo_conn_err(u8 node)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	if (test_bit(node, qs->qs_conn_bm)) {
 		qs->qs_connected--;
@@ -307,7 +307,7 @@ void o2quo_conn_err(u8 node)
 	mlog(0, "node %u, %d total\n", node, qs->qs_connected);
 
 
-	spin_unlock(&qs->qs_lock);
+	spin_unlock_bh(&qs->qs_lock);
 }
 
 void o2quo_init(void)
-- 
2.17.1

