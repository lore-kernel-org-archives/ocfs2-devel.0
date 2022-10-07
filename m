Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 345C9C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri,  7 Oct 2022 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rfPYfrTyq2E0RB0mpNybjnqvid9La0/rY1gY7BUupFI=;
 b=mrKrBe75PCpeTgRhTTzyH2OWtV3EM4ZWN5tC9oqkJowhzCE/TIc/Iy95J8YHfH6Fg2iP8f+NgAcg
   wBIyRxqnm2Jz0lz7bpFcwuzfT3AQxP0icZLQhZ+RQ5YpFNfkDJUS1lQ3TUraSsEF/ElYd6zqQHBk
   Rvnm5EiC4mPcEzTuGlx+a5OE3WdH+8xckAkoQMH0734HtFcQ2vdoGydYuqrWS/L3aWN54m8y8zny
   DiRYc1dxZoyp5rvtekfigRzrSHvLlmkjFvUwDImaawRSkMvaS6UZOTnVuIjstYIVsBy2/O5BTSwv
   62ZAhV+zhq/dbMpDl9DDmueTyejHJ3Pm3y0IUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rfPYfrTyq2E0RB0mpNybjnqvid9La0/rY1gY7BUupFI=;
 b=rjpGSRLH3jYPe4PaW+9RWGznMe5Zv1kemCParawy58TJHuwx+yWVxQtinzgRPHU9jpWHZAnfaTV0
   9Wc7B+z0rN36SAY5fuH++EjTNkzDuwp94ZS35/tL2CbRi5x/6tziEkBSys7K374W1ee/7QGSq2eo
   5v1zWMaX9tjC1ntNczk4gnE+9F4T1dwKZ1Y7mS1TbinWD/gcY2SZylC0Auhx2CNngYn0qBX3cnWs
   52vQC7qWtolDIlNtlo4UVu3Htz8sJSk9RxVSGhhlM0RKY0hBwF5xpk/cNLWDW1ICz7ZlC+JtH/h6
   PiIbfg4maqK9TJvv55GXeBZqlujCklnQiupJpg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJD007RSVLU23A0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 07 Oct 2022 12:49:06 +0000 (GMT)
To: ocfs2-devel@oss.oracle.com
Date: Fri,  7 Oct 2022 20:48:46 +0800
Message-id: <20221007124846.186453-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-reply-to: <20221007124846.186453-1-joseph.qi@linux.alibaba.com>
References: <20221007124846.186453-1-joseph.qi@linux.alibaba.com>
MIME-version: 1.0
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10492
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=834 clxscore=-63
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210070076 domainage_hfrom=8576
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/dlm: use bitmap API instead of
	hand-writing it
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VRU9Gyx_1665146929;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: RLJF27xgIbmkq6MDk5Epf5A25qClF0-0
X-Proofpoint-ORIG-GUID: RLJF27xgIbmkq6MDk5Epf5A25qClF0-0
Reporting-Meta:
 AAFa6ZkpaR9wi/DgGjfXimn9M9ojUDrir1qTPYISZNUA1v0EiSoxxowfgiyQvSCn
 VF14ztzAqx31YzB09PBvm/FzdqFPzjfEb/ml7MtORj0bV9AfaPqEzgNSVq4lJ/eI
 4qPteWQxzRLHNDThKB/6TUkpacN4kY8PZ3qzOA2mPPN2Jb6QCQHijA2vVk6v0xZ6
 FLiaZeArqCLwF6le9W3ip3LrKx+OECv+C37BJYKX7XAh71BissfjAM5LJ6HFvryt
 zrAJc+ZtXL/Xy7mTr3NC1ODwoHl6PYNAUhaU/PIQNQts6uPrz/hKgyx53/e9a+z6
 +Pm9hrL/kPRygxRfWZZZ941K2aLfWB5yC3idL+RbyKfTFHB9mG6Ayjzk0mTj2VaG
 he5IQHa+PJPGGJYPAyeRdbcR+TpKWB1iJicSDPN9BoCSI4fcRnhEIJ8at0GgjlRA
 si9LdKFEL2MRkG5VU2KdE5amSP0k0FEjxuQ3PbZt+pcR1sssazx44CLvFrxaRMt3
 yRExJ5coaMBRBTaESy0Pi93F6la0CsgMsavkfvjS46+Q

Use bitmap_zero/bitmap_copy/bitmap_qeual directly for bitmap operations.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dlm/dlmcommon.h   |  2 +-
 fs/ocfs2/dlm/dlmdomain.c   | 17 +++++++----------
 fs/ocfs2/dlm/dlmmaster.c   | 30 +++++++++++++++---------------
 fs/ocfs2/dlm/dlmrecovery.c |  2 +-
 4 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index fd2022712167..20f790a47484 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -1094,7 +1094,7 @@ static inline enum dlm_status dlm_err_to_dlm_status(int err)
 static inline void dlm_node_iter_init(unsigned long *map,
 				      struct dlm_node_iter *iter)
 {
-	memcpy(iter->node_map, map, sizeof(iter->node_map));
+	bitmap_copy(iter->node_map, map, O2NM_MAX_NODES);
 	iter->curnode = -1;
 }
 
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index f46941ff665d..5c04dde99981 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1576,8 +1576,8 @@ static int dlm_should_restart_join(struct dlm_ctxt *dlm,
 	spin_lock(&dlm->spinlock);
 	/* For now, we restart the process if the node maps have
 	 * changed at all */
-	ret = memcmp(ctxt->live_map, dlm->live_nodes_map,
-		     sizeof(dlm->live_nodes_map));
+	ret = !bitmap_equal(ctxt->live_map, dlm->live_nodes_map,
+			    O2NM_MAX_NODES);
 	spin_unlock(&dlm->spinlock);
 
 	if (ret)
@@ -1607,10 +1607,8 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
 	o2hb_fill_node_map(dlm->live_nodes_map, O2NM_MAX_NODES);
 
 	spin_lock(&dlm->spinlock);
-	memcpy(ctxt->live_map, dlm->live_nodes_map, sizeof(ctxt->live_map));
-
+	bitmap_copy(ctxt->live_map, dlm->live_nodes_map, O2NM_MAX_NODES);
 	__dlm_set_joining_node(dlm, dlm->node_num);
-
 	spin_unlock(&dlm->spinlock);
 
 	node = -1;
@@ -1643,8 +1641,7 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
 	 * yes_resp_map. Copy that into our domain map and send a join
 	 * assert message to clean up everyone elses state. */
 	spin_lock(&dlm->spinlock);
-	memcpy(dlm->domain_map, ctxt->yes_resp_map,
-	       sizeof(ctxt->yes_resp_map));
+	bitmap_copy(dlm->domain_map, ctxt->yes_resp_map, O2NM_MAX_NODES);
 	set_bit(dlm->node_num, dlm->domain_map);
 	spin_unlock(&dlm->spinlock);
 
@@ -2009,9 +2006,9 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	mlog(0, "dlm->recovery_map=%p, &(dlm->recovery_map[0])=%p\n",
 		  dlm->recovery_map, &(dlm->recovery_map[0]));
 
-	memset(dlm->recovery_map, 0, sizeof(dlm->recovery_map));
-	memset(dlm->live_nodes_map, 0, sizeof(dlm->live_nodes_map));
-	memset(dlm->domain_map, 0, sizeof(dlm->domain_map));
+	bitmap_zero(dlm->recovery_map, O2NM_MAX_NODES);
+	bitmap_zero(dlm->live_nodes_map, O2NM_MAX_NODES);
+	bitmap_zero(dlm->domain_map, O2NM_MAX_NODES);
 
 	dlm->dlm_thread_task = NULL;
 	dlm->dlm_reco_thread_task = NULL;
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 227da5b1b6ab..d610da8e2f24 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -258,12 +258,12 @@ static void dlm_init_mle(struct dlm_master_list_entry *mle,
 	mle->type = type;
 	INIT_HLIST_NODE(&mle->master_hash_node);
 	INIT_LIST_HEAD(&mle->hb_events);
-	memset(mle->maybe_map, 0, sizeof(mle->maybe_map));
+	bitmap_zero(mle->maybe_map, O2NM_MAX_NODES);
 	spin_lock_init(&mle->spinlock);
 	init_waitqueue_head(&mle->wq);
 	atomic_set(&mle->woken, 0);
 	kref_init(&mle->mle_refs);
-	memset(mle->response_map, 0, sizeof(mle->response_map));
+	bitmap_zero(mle->response_map, O2NM_MAX_NODES);
 	mle->master = O2NM_MAX_NODES;
 	mle->new_master = O2NM_MAX_NODES;
 	mle->inuse = 0;
@@ -290,8 +290,8 @@ static void dlm_init_mle(struct dlm_master_list_entry *mle,
 	atomic_inc(&dlm->mle_cur_count[mle->type]);
 
 	/* copy off the node_map and register hb callbacks on our copy */
-	memcpy(mle->node_map, dlm->domain_map, sizeof(mle->node_map));
-	memcpy(mle->vote_map, dlm->domain_map, sizeof(mle->vote_map));
+	bitmap_copy(mle->node_map, dlm->domain_map, O2NM_MAX_NODES);
+	bitmap_copy(mle->vote_map, dlm->domain_map, O2NM_MAX_NODES);
 	clear_bit(dlm->node_num, mle->vote_map);
 	clear_bit(dlm->node_num, mle->node_map);
 
@@ -572,7 +572,7 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 	spin_unlock(&dlm->track_lock);
 
 	memset(res->lvb, 0, DLM_LVB_LEN);
-	memset(res->refmap, 0, sizeof(res->refmap));
+	bitmap_zero(res->refmap, O2NM_MAX_NODES);
 }
 
 struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
@@ -1036,10 +1036,10 @@ static int dlm_wait_for_lock_mastery(struct dlm_ctxt *dlm,
 
 	spin_lock(&mle->spinlock);
 	m = mle->master;
-	map_changed = (memcmp(mle->vote_map, mle->node_map,
-			      sizeof(mle->vote_map)) != 0);
-	voting_done = (memcmp(mle->vote_map, mle->response_map,
-			     sizeof(mle->vote_map)) == 0);
+	map_changed = !bitmap_equal(mle->vote_map, mle->node_map,
+				    O2NM_MAX_NODES);
+	voting_done = bitmap_equal(mle->vote_map, mle->response_map,
+				   O2NM_MAX_NODES);
 
 	/* restart if we hit any errors */
 	if (map_changed) {
@@ -1277,11 +1277,11 @@ static int dlm_restart_lock_mastery(struct dlm_ctxt *dlm,
 
 			/* now blank out everything, as if we had never
 			 * contacted anyone */
-			memset(mle->maybe_map, 0, sizeof(mle->maybe_map));
-			memset(mle->response_map, 0, sizeof(mle->response_map));
+			bitmap_zero(mle->maybe_map, O2NM_MAX_NODES);
+			bitmap_zero(mle->response_map, O2NM_MAX_NODES);
 			/* reset the vote_map to the current node_map */
-			memcpy(mle->vote_map, mle->node_map,
-			       sizeof(mle->node_map));
+			bitmap_copy(mle->vote_map, mle->node_map,
+				    O2NM_MAX_NODES);
 			/* put myself into the maybe map */
 			if (mle->type != DLM_MLE_BLOCK)
 				set_bit(dlm->node_num, mle->maybe_map);
@@ -2094,7 +2094,7 @@ static void dlm_assert_master_worker(struct dlm_work_item *item, void *data)
 	flags = item->u.am.flags;
 
 	spin_lock(&dlm->spinlock);
-	memcpy(nodemap, dlm->domain_map, sizeof(nodemap));
+	bitmap_copy(nodemap, dlm->domain_map, O2NM_MAX_NODES);
 	spin_unlock(&dlm->spinlock);
 
 	clear_bit(dlm->node_num, nodemap);
@@ -3447,7 +3447,7 @@ int dlm_finish_migration(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 		ret = 0;
 	}
 
-	memset(iter.node_map, 0, sizeof(iter.node_map));
+	bitmap_zero(iter.node_map, O2NM_MAX_NODES);
 	set_bit(old_master, iter.node_map);
 	mlog(0, "doing assert master of %.*s back to %u\n",
 	     res->lockname.len, res->lockname.name, old_master);
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 52ad342fec3e..50da8af988c1 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -733,7 +733,7 @@ static int dlm_init_recovery_area(struct dlm_ctxt *dlm, u8 dead_node)
 	struct dlm_reco_node_data *ndata;
 
 	spin_lock(&dlm->spinlock);
-	memcpy(dlm->reco.node_map, dlm->domain_map, sizeof(dlm->domain_map));
+	bitmap_copy(dlm->reco.node_map, dlm->domain_map, O2NM_MAX_NODES);
 	/* nodes can only be removed (by dying) after dropping
 	 * this lock, and death will be trapped later, so this should do */
 	spin_unlock(&dlm->spinlock);
-- 
2.24.4


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
