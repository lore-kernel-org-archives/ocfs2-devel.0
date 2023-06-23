Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70917EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jun 2023 02:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7LCNU4j1ZqnBVgneCYc9WN4BU5lHFKWTH6Ge3wF4bQ0=;
 b=ZwZ0jsoOdhuLLPztGEdUm+dU7gVRcKR78gShkeAIbBya+mgZJppW8Bt/jCeTGyUkcUuqHHitV9xd
   xn4zFUvgo0TDkRcH+nfNR3qUaJnYlM4rNF9fWtLWCsBt3WXblzrjNCD/ZPjma4pOGJMzsLpLvC5O
   aLloi2GR4CZ7O9zXUdEKfyKx1RLPKnmZr3uHKTFk2RqTuzQAPSqA1JmvdHy2fEXoG9UwODvRt+hw
   vAA/v4eMOhldFJ7XUR0ORyMXbbZEZD6/45eisIB1fhC39d/SyOzwxyZeqYqBX1MhOHrFfKUAPbA/
   SwwMhwgYnpa2lw+OHtZLcuHP3fWA4Lz1coGJuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7LCNU4j1ZqnBVgneCYc9WN4BU5lHFKWTH6Ge3wF4bQ0=;
 b=BBvrczWFKH0R+WxiF+NTMWJgWFCO+ilJljyU3Uug8hzZnqup3AUn0urkb5ZFZ2T8k5DyYFeptp+U
   HE4W9a11KsKW+5czuNUecC2wJmM80g35rraywEAthsF5d7rR/Xh5qmARPJTcLC/ogFKXUSjtPe2o
   CcYGghZS+7ogDYoMCf27DjgDKrpDSBXSwsbNsCogDWQ2JwK+B8tK/ZoPpVFv3HWrUn/Qy8/W8WIz
   JiaJP71QFVbS6UXc5DglFCu5HfgbA31g96n3eObigFPoQ6Hn6w6HlxQZ9pxcRx35gIxQ7aAg8gnO
   oURPRIehRRozJy19DBloJJLPeSCV/gWw04FFOQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWQ00KRTLF22VE0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 24 Jun 2023 02:54:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1687520718;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ZDy9qTqAXsZiyNyw/4xfrjcFbGXml691uHuF37I4PZg=;
 b=Ik6AFcb0x0VdlCQ/jSWOJJLyC/pKRyswrjtOKk2P13057yuU5lI9nQCjX5G29GURFbi0px
 9WvGY76FZ83jrV+ZgI7mNEve8/uoNruOJ/lZXo5xA0kDrhuUrA7Ct7nguNsr1LqZzr7z2r
 Q5P8iUpseumkdSLwxzV9MwUxk85f99o=
To: netdev@vger.kernel.org
Date: Fri, 23 Jun 2023 12:44:22 +0100
Message-id: <20230623114425.2150536-13-dhowells@redhat.com>
In-reply-to: <20230623114425.2150536-1-dhowells@redhat.com>
References: <20230623114425.2150536-1-dhowells@redhat.com>
MIME-version: 1.0
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10749
 signatures=596816
Cc: Jens Axboe <axboe@kernel.dk>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
 Alexander Duyck <alexander.duyck@gmail.com>,
 David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH net-next v4 12/15] ocfs2: Fix use of slab data
	with sendpage
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
From: David Howells via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: David Howells <dhowells@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: y_gjQWLAObqQcPZDkV39dQ-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: NniGSIfFS10VrlD9_FDpLZ2A7WEFUx1n
X-Proofpoint-ORIG-GUID: NniGSIfFS10VrlD9_FDpLZ2A7WEFUx1n
Reporting-Meta:
 AAFV6G8iHqJkK/qit5CUcDEeZ6zfXk5xIW7TgQURJMW754ggFAzeh5T1Y98sBIHn
 kLILulH43X4Nnx0VthVxm5dVOosi7DNRBRbpBQtd1R4dfhJd6ypPkOyorU8NT1wo
 w/mQI0DwNafvOxtU/B1ENU8wqJC01ml7MAkXyGli+Iu0iGTFCxiWg3adBt7nPFcl
 bDMT8pYQp+mKrNd5s2HA4QYGcv0VVGVq68+tflqvohu2uvoOupe8no6exSD4a0fp
 VzwJTvUdFg/FDfPyiLIfjDYirqlKUtQp3CUq4yGcA/iv7cDH6JvB/VcSuY6WxejU
 RVhnSb2BoQAF/iORtdbfO3ULulwOzlm6w7qTAtVyFblYJP5K9KUvi6iJWflQOn07
 QXZh0wRXOG6UoMh0E5aaSonVDDeqIPnKv5j3eqS3gKZqwfMg/0dW5cdNwDwEURjF
 uFNywGId35nVTgz7jE0C7xkFsS6eAj+v2DcYKznUj1R6kMaUMm1bfWjRW4WuJCVH
 PZ0huLJbZEuaRbjBb43QlsuVcigqTO43SPvQhMc6J/zE

ocfs2 uses kzalloc() to allocate buffers for for o2net_hand, o2net_keep_req
and o2net_keep_resp and then passes these to sendpage.  This isn't really
allowed as the lifetime of slab objects is not controlled by page ref -
though in this case it will probably work.  sendmsg() with MSG_SPLICE_PAGES
will, however, print a warning and give an error.

Fix it to use folio_alloc() instead to allocate a buffer for the handshake
message, keepalive request and reply messages.

Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Mark Fasheh <mark@fasheh.com>
cc: Joel Becker <jlbec@evilplan.org>
cc: Joseph Qi <joseph.qi@linux.alibaba.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: ocfs2-devel@oss.oracle.com
cc: netdev@vger.kernel.org
---
 fs/ocfs2/cluster/tcp.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index aecbd712a00c..929a1133bc18 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -2087,18 +2087,24 @@ void o2net_stop_listening(struct o2nm_node *node)
 
 int o2net_init(void)
 {
+	struct folio *folio;
+	void *p;
 	unsigned long i;
 
 	o2quo_init();
-
 	o2net_debugfs_init();
 
-	o2net_hand = kzalloc(sizeof(struct o2net_handshake), GFP_KERNEL);
-	o2net_keep_req = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
-	o2net_keep_resp = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
-	if (!o2net_hand || !o2net_keep_req || !o2net_keep_resp)
+	folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+	if (!folio)
 		goto out;
 
+	p = folio_address(folio);
+	o2net_hand = p;
+	p += sizeof(struct o2net_handshake);
+	o2net_keep_req = p;
+	p += sizeof(struct o2net_msg);
+	o2net_keep_resp = p;
+
 	o2net_hand->protocol_version = cpu_to_be64(O2NET_PROTOCOL_VERSION);
 	o2net_hand->connector_id = cpu_to_be64(1);
 
@@ -2124,9 +2130,6 @@ int o2net_init(void)
 	return 0;
 
 out:
-	kfree(o2net_hand);
-	kfree(o2net_keep_req);
-	kfree(o2net_keep_resp);
 	o2net_debugfs_exit();
 	o2quo_exit();
 	return -ENOMEM;
@@ -2135,8 +2138,6 @@ int o2net_init(void)
 void o2net_exit(void)
 {
 	o2quo_exit();
-	kfree(o2net_hand);
-	kfree(o2net_keep_req);
-	kfree(o2net_keep_resp);
 	o2net_debugfs_exit();
+	folio_put(virt_to_folio(o2net_hand));
 }


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
