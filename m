Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B24189902
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 18:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724092696; cv=none; b=SgmvOZ0eAjRxvnNzj/37zNeGSb5GXNxv8tEm+/unDvGh9GtKwNx9RcGKG533Ul70UMXjwMERZDZsjZf4O1Apy7vkBFaYuA+Qe5XLh2LiXZcxcnIY6Va3I54BzcA/porWNetCgl49PygSd7IGMNKPZHJz370GSv89dR9gO6h9SNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724092696; c=relaxed/simple;
	bh=pEykAF54ZombhDtvSOFvz07hgEbPC1yWSKUBIVMyTKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlxA0JPsVj/Vgwr2QjlyGoVC49jli/OKu9ly15i/y2ZpmHBkd9SDofgFMA1xuykRu/vyJ8Wb1whQvJJk8tCbPvaQHY8VwgbuNIbUQ833L5u1TxohmK/1oHlAUjj/5ZnP3p/MTW0B+ZncUqtlZemRfcAOKWwBDqd3zjksHY5FTCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ajAFtOHW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ajAFtOHW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724092693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UjcWZWetbGAUh5mkwGzeBCESacAnBs5/X7m1T3R+vyM=;
	b=ajAFtOHWCCClTo+Fcl6INQFvZsXinPD9RkazG4Fqlx895QtM4b0rMvdR11FTL8pQwrctYD
	AQF2r01u0qTiRj8/xaV0srIGYr5+pXwXJdFJUprxTeRLttEAfZiMuhz+5lc6pri7ZxK+g6
	aSk3uEJ1uH1d5ka5OWBDV8KKA5rEZr8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-z9KOyE-BOd-Z8xrAHTj7sw-1; Mon,
 19 Aug 2024 14:38:09 -0400
X-MC-Unique: z9KOyE-BOd-Z8xrAHTj7sw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 857881955D4A;
	Mon, 19 Aug 2024 18:38:06 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E4CCE1955F44;
	Mon, 19 Aug 2024 18:38:02 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	agruenba@redhat.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	netdev@vger.kernel.org,
	vvidic@valentin-vidic.from.hr,
	heming.zhao@suse.com,
	lucien.xin@gmail.com,
	aahringo@redhat.com
Subject: [PATCH dlm/next 03/12] dlm: add struct net to dlm_new_lockspace()
Date: Mon, 19 Aug 2024 14:37:33 -0400
Message-ID: <20240819183742.2263895-4-aahringo@redhat.com>
In-Reply-To: <20240819183742.2263895-1-aahringo@redhat.com>
References: <20240819183742.2263895-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

To prepare a namespace separation for each DLM lockspaces context we add
a struct net parameter that the user tells us in which net-namespace
the lockspace should be created. We are using net-namespace here because
a DLM lockspaces context acts like a per cluster node separation and the
created per node sockets need to be separated by their net-namespaces
anyway. It just fits that the DLM lockspaces are also separated by a per
"network entity".

This patch only prepares for such parameter for a functionality that
does not exist yet. It does not have any effect. If there will be
support for such handling the DLM user need to activate it anyway as the
applied parameter for now is the "&init_net" instance that is the
default namespace which we are currently using.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 drivers/md/md-cluster.c | 3 ++-
 fs/dlm/lockspace.c      | 5 +++--
 fs/gfs2/lock_dlm.c      | 6 +++---
 fs/ocfs2/stack_user.c   | 2 +-
 include/linux/dlm.h     | 9 +++++++--
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 1d0db62f0351..cc1c93370510 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -896,7 +896,8 @@ static int join(struct mddev *mddev, int nodes)
 
 	memset(str, 0, 64);
 	sprintf(str, "%pU", mddev->uuid);
-	ret = dlm_new_lockspace(str, mddev->bitmap_info.cluster_name,
+	ret = dlm_new_lockspace(&init_net, str,
+				mddev->bitmap_info.cluster_name,
 				DLM_LSFL_SOFTIRQ, LVB_SIZE, &md_ls_ops, mddev,
 				&ops_rv, &cinfo->lockspace);
 	if (ret)
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 00d37125bc44..2dd37a2e718d 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -663,8 +663,9 @@ static int __dlm_new_lockspace(const char *name, const char *cluster,
 	return error;
 }
 
-int dlm_new_lockspace(const char *name, const char *cluster, uint32_t flags,
-		      int lvblen, const struct dlm_lockspace_ops *ops,
+int dlm_new_lockspace(struct net *net, const char *name, const char *cluster,
+		      uint32_t flags, int lvblen,
+		      const struct dlm_lockspace_ops *ops,
 		      void *ops_arg, int *ops_result,
 		      dlm_lockspace_t **lockspace)
 {
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index fa5134df985f..6c5dce57a2ee 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -1328,9 +1328,9 @@ static int gdlm_mount(struct gfs2_sbd *sdp, const char *table)
 	 * create/join lockspace
 	 */
 
-	error = dlm_new_lockspace(fsname, cluster, flags, GDLM_LVB_SIZE,
-				  &gdlm_lockspace_ops, sdp, &ops_result,
-				  &ls->ls_dlm);
+	error = dlm_new_lockspace(&init_net, fsname, cluster, flags,
+				  GDLM_LVB_SIZE, &gdlm_lockspace_ops, sdp,
+				  &ops_result, &ls->ls_dlm);
 	if (error) {
 		fs_err(sdp, "dlm_new_lockspace error %d\n", error);
 		goto fail_free;
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 77edcd70f72c..23611eba58ef 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -984,7 +984,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 	conn->cc_private = lc;
 	lc->oc_type = NO_CONTROLD;
 
-	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
+	rc = dlm_new_lockspace(&init_net, conn->cc_name, conn->cc_cluster_name,
 			       DLM_LSFL_NEWEXCL, DLM_LVB_LEN,
 			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
 	if (rc) {
diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index bacda9898f2b..ecab5c197a7f 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -11,9 +11,9 @@
 #ifndef __DLM_DOT_H__
 #define __DLM_DOT_H__
 
+#include <net/net_namespace.h>
 #include <uapi/linux/dlm.h>
 
-
 struct dlm_slot {
 	int nodeid; /* 1 to MAX_INT */
 	int slot;   /* 1 to MAX_INT */
@@ -43,6 +43,11 @@ struct dlm_lockspace_ops {
  *
  * Create/join a lockspace.
  *
+ * net: the net namespace context pointer where the lockspace belongs to.
+ * DLM lockspaces can be separated according to net namespaces. As DLM
+ * requires networking communication this net namespace can be used to
+ * have a own DLM lockspace on each network entity e.g. a DLM node.
+ *
  * name: lockspace name, null terminated, up to DLM_LOCKSPACE_LEN (not
  *   including terminating null).
  *
@@ -82,7 +87,7 @@ struct dlm_lockspace_ops {
  * lockspace: handle for dlm functions
  */
 
-int dlm_new_lockspace(const char *name, const char *cluster,
+int dlm_new_lockspace(struct net *net, const char *name, const char *cluster,
 		      uint32_t flags, int lvblen,
 		      const struct dlm_lockspace_ops *ops, void *ops_arg,
 		      int *ops_result, dlm_lockspace_t **lockspace);
-- 
2.43.0

