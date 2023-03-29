Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C3E7C6FD18
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Mar 2023 14:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lgZ50WkoyLw9O/wTW2pJhCi/caINUn8M0LAVb3zTvAE=;
 b=nOX2trHPkZcdmDQcM1ilCH6kLZ7GiswX0jt0nM14zMIgiRk2Z0caQO5X8yL4Fws0RdiOJnQTdyNB
   MaIUqCFCU33T7qEbuPbLZ4h3YmEJt8O9mAbcKAtq1P3/k7G3soIW1OFdBLSfESeuCqvp/oc/ODvD
   RGPnzq+PN7p8TzCrp48A/fC4zTNhVutMl0uVHGSWsymrss1YRL/K6PFZhib4j5QEFBET71Aevf0l
   TckMQgZTbTfuPKxpaTr4rJqsbek48kh6WhYheduiE9usPoxGNqEHHryYIu+xpaK4Me9Y1AyxnXGa
   +OB4950Z9msYisorJhyG7AsUaN5PV7xvfqsYVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lgZ50WkoyLw9O/wTW2pJhCi/caINUn8M0LAVb3zTvAE=;
 b=R+QBx9wxZ60JE6Ri7PQzAk361Z5u1KFN+PBaszGVmEtnm5+7BDVWqYnsshDAReoWuQohxJaERDID
   F1m5HSu/NkjgQInrcubGgfIlTb20KOpkPCi4cOSv8b9KL0dbhuRWwxqyFtuKCsApkUodUpirTFC5
   0b/5pXJUomufTZXzd4CGppvJiICt1rHIGuhtALkzntb4EvmcFwM4fjszB+TUN1PXuxX9UMHISQzL
   maqpL0BNanDERRboTOEqj7cGWDhsUaLdO0jPftY/vZWptmFtYATPSHoU8WAjzHMxMRKKjywYLRiQ
   p3OYQGX7guO71IV46yeUYItXaWOk+AECbypvsA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSA00643CZLJNE0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 29 Mar 2023 14:16:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1680099382;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UieBw+fd7YOFzWwOOxTgfiaOtpF+6tMbkd08W9f/ez8=;
 b=bymhAKGcXM30P46CJzLFZPViVRpr6/qeB+a0xE0/eYtjo+7hbQd6u0gLcsi2wC64xE8pjV
 SrGEMkgkHJ3tqPtqdQOMP/y7w+/CwMDd4r6RRlnBo9eSSc/RaIPa83CVyAJjDrgtw6tFM6
 f9fwZHYdgwtosEalA1ZegPGU8J3RmyY=
To: Matthew Wilcox <willy@infradead.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Date: Wed, 29 Mar 2023 15:13:51 +0100
Message-id: <20230329141354.516864-46-dhowells@redhat.com>
In-reply-to: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-version: 1.0
X-Source-IP: 170.10.133.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10664
 signatures=596816
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Christian Brauner <brauner@kernel.org>, netdev@vger.kernel.org,
 Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
 David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
 Chuck Lever III <chuck.lever@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [RFC PATCH v2 45/48] ocfs2: Use
	sendmsg(MSG_SPLICE_PAGES) rather than sendpage()
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
X-MC-Unique: OM0xdWQoMNypMjdol7M5aQ-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
X-Proofpoint-GUID: mVKXy5DwkEYwURVfE-gFvUsqmZ59r5E_
X-Proofpoint-ORIG-GUID: mVKXy5DwkEYwURVfE-gFvUsqmZ59r5E_
Reporting-Meta:
 AAGV5tOJ+G1QSi4+FSQlNWmwcYFVvee5rBg0CBNyWq8IDCc7rFrBeGLLfSSzN+8z
 r6AUmN7T8cM4a26JVoYincHHjhZteF/hjZCCtPrP+6qTDmaFgNsYRENYc7GRRZjS
 1m0Mn1ye7QJj0lK5Gs8E9A5wd4X6axq/Iw03RV/CdS7i3uscNh2Q6ADuLqIqFZoz
 EhEDMQVW+/khDnRLtyKEUBYPCUqOKbw0CH31gaitmn4EMOH3ZuDDjYrOfeVobSnF
 x/VpZGwxa96O2XeOkpLRrDfgvlU4P5quH+CWTtbxi6XCdx3ajpCYZQjNouo2s0JB
 IlEeBKiB55Tv50x7Pmac8vZeg8dMBKQyEEm6L6s1Gnc06iTI+MKEWfm5BCO4zf7h
 JL9z4PmDLChqkYPj3C7QXLJYVbx6mgtLEjfv766/+wn0Tqs4F0wPWUiuSG6NHwvA
 J/3yUqsmuDbKngPqUfK+lRr60lqFPtElfzg06EMJgsaw5D+Xa2h+w/y8sjaNmpvb
 fSfyVKTIARJBEK+CODlB9PuzlgnOVurGeIZ6Ex6NkF76sA==

Fix ocfs2 to use the page fragment allocator rather than kzalloc in order
to allocate the buffers for the handshake message and keepalive request and
reply messages.  Slab pages should not be given to sendpage, but fragments
can be.

Switch from using sendpage() to using sendmsg() + MSG_SPLICE_PAGES so that
sendpage can be phased out.

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
 fs/ocfs2/cluster/tcp.c | 107 ++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 49 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index aecbd712a00c..e568ad2f34bf 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -110,9 +110,6 @@ static struct work_struct o2net_listen_work;
 static struct o2hb_callback_func o2net_hb_up, o2net_hb_down;
 #define O2NET_HB_PRI 0x1
 
-static struct o2net_handshake *o2net_hand;
-static struct o2net_msg *o2net_keep_req, *o2net_keep_resp;
-
 static int o2net_sys_err_translations[O2NET_ERR_MAX] =
 		{[O2NET_ERR_NONE]	= 0,
 		 [O2NET_ERR_NO_HNDLR]	= -ENOPROTOOPT,
@@ -930,19 +927,22 @@ static int o2net_send_tcp_msg(struct socket *sock, struct kvec *vec,
 }
 
 static void o2net_sendpage(struct o2net_sock_container *sc,
-			   void *kmalloced_virt,
-			   size_t size)
+			   void *virt, size_t size)
 {
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
+	struct msghdr msg = {};
+	struct bio_vec bv;
 	ssize_t ret;
 
+	bvec_set_virt(&bv, virt, size);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bv, 1, size);
+
 	while (1) {
+		msg.msg_flags = MSG_DONTWAIT | MSG_SPLICE_PAGES;
 		mutex_lock(&sc->sc_send_lock);
-		ret = sc->sc_sock->ops->sendpage(sc->sc_sock,
-						 virt_to_page(kmalloced_virt),
-						 offset_in_page(kmalloced_virt),
-						 size, MSG_DONTWAIT);
+		ret = sock_sendmsg(sc->sc_sock, &msg);
 		mutex_unlock(&sc->sc_send_lock);
+
 		if (ret == size)
 			break;
 		if (ret == (ssize_t)-EAGAIN) {
@@ -1168,6 +1168,7 @@ static int o2net_process_message(struct o2net_sock_container *sc,
 				 struct o2net_msg *hdr)
 {
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
+	struct o2net_msg *keep_resp;
 	int ret = 0, handler_status;
 	enum  o2net_system_error syserr;
 	struct o2net_msg_handler *nmh = NULL;
@@ -1186,8 +1187,16 @@ static int o2net_process_message(struct o2net_sock_container *sc,
 					   be32_to_cpu(hdr->status));
 			goto out;
 		case O2NET_MSG_KEEP_REQ_MAGIC:
-			o2net_sendpage(sc, o2net_keep_resp,
-				       sizeof(*o2net_keep_resp));
+			keep_resp = page_frag_alloc(NULL, sizeof(*keep_resp),
+						    GFP_KERNEL);
+			if (!keep_resp) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			memset(keep_resp, 0, sizeof(*keep_resp));
+			keep_resp->magic = cpu_to_be16(O2NET_MSG_KEEP_RESP_MAGIC);
+			o2net_sendpage(sc, keep_resp, sizeof(*keep_resp));
+			folio_put(virt_to_folio(keep_resp));
 			goto out;
 		case O2NET_MSG_KEEP_RESP_MAGIC:
 			goto out;
@@ -1439,15 +1448,22 @@ static void o2net_rx_until_empty(struct work_struct *work)
 	sc_put(sc);
 }
 
-static void o2net_initialize_handshake(void)
+static struct o2net_handshake *o2net_initialize_handshake(void)
 {
-	o2net_hand->o2hb_heartbeat_timeout_ms = cpu_to_be32(
-		O2HB_MAX_WRITE_TIMEOUT_MS);
-	o2net_hand->o2net_idle_timeout_ms = cpu_to_be32(o2net_idle_timeout());
-	o2net_hand->o2net_keepalive_delay_ms = cpu_to_be32(
-		o2net_keepalive_delay());
-	o2net_hand->o2net_reconnect_delay_ms = cpu_to_be32(
-		o2net_reconnect_delay());
+	struct o2net_handshake *hand;
+
+	hand = page_frag_alloc(NULL, sizeof(*hand), GFP_KERNEL);
+	if (!hand)
+		return NULL;
+
+	memset(hand, 0, sizeof(*hand));
+	hand->protocol_version		= cpu_to_be64(O2NET_PROTOCOL_VERSION);
+	hand->connector_id		= cpu_to_be64(1);
+	hand->o2hb_heartbeat_timeout_ms	= cpu_to_be32(O2HB_MAX_WRITE_TIMEOUT_MS);
+	hand->o2net_idle_timeout_ms	= cpu_to_be32(o2net_idle_timeout());
+	hand->o2net_keepalive_delay_ms	= cpu_to_be32(o2net_keepalive_delay());
+	hand->o2net_reconnect_delay_ms	= cpu_to_be32(o2net_reconnect_delay());
+	return hand;
 }
 
 /* ------------------------------------------------------------ */
@@ -1456,16 +1472,22 @@ static void o2net_initialize_handshake(void)
  * rx path will see the response and mark the sc valid */
 static void o2net_sc_connect_completed(struct work_struct *work)
 {
+	struct o2net_handshake *hand;
 	struct o2net_sock_container *sc =
 		container_of(work, struct o2net_sock_container,
 			     sc_connect_work);
 
+	hand = o2net_initialize_handshake();
+	if (!hand)
+		goto out;
+
 	mlog(ML_MSG, "sc sending handshake with ver %llu id %llx\n",
               (unsigned long long)O2NET_PROTOCOL_VERSION,
-	      (unsigned long long)be64_to_cpu(o2net_hand->connector_id));
+	      (unsigned long long)be64_to_cpu(hand->connector_id));
 
-	o2net_initialize_handshake();
-	o2net_sendpage(sc, o2net_hand, sizeof(*o2net_hand));
+	o2net_sendpage(sc, hand, sizeof(*hand));
+	folio_put(virt_to_folio(hand));
+out:
 	sc_put(sc);
 }
 
@@ -1475,8 +1497,15 @@ static void o2net_sc_send_keep_req(struct work_struct *work)
 	struct o2net_sock_container *sc =
 		container_of(work, struct o2net_sock_container,
 			     sc_keepalive_work.work);
+	struct o2net_msg *keep_req;
 
-	o2net_sendpage(sc, o2net_keep_req, sizeof(*o2net_keep_req));
+	keep_req = page_frag_alloc(NULL, sizeof(*keep_req), GFP_KERNEL);
+	if (keep_req) {
+		memset(keep_req, 0, sizeof(*keep_req));
+		keep_req->magic = cpu_to_be16(O2NET_MSG_KEEP_REQ_MAGIC);
+		o2net_sendpage(sc, keep_req, sizeof(*keep_req));
+		folio_put(virt_to_folio(keep_req));
+	}
 	sc_put(sc);
 }
 
@@ -1780,6 +1809,7 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	struct socket *new_sock = NULL;
 	struct o2nm_node *node = NULL;
 	struct o2nm_node *local_node = NULL;
+	struct o2net_handshake *hand;
 	struct o2net_sock_container *sc = NULL;
 	struct o2net_node *nn;
 	unsigned int nofs_flag;
@@ -1882,8 +1912,11 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	o2net_register_callbacks(sc->sc_sock->sk, sc);
 	o2net_sc_queue_work(sc, &sc->sc_rx_work);
 
-	o2net_initialize_handshake();
-	o2net_sendpage(sc, o2net_hand, sizeof(*o2net_hand));
+	hand = o2net_initialize_handshake();
+	if (hand) {
+		o2net_sendpage(sc, hand, sizeof(*hand));
+		folio_put(virt_to_folio(hand));
+	}
 
 out:
 	if (new_sock)
@@ -2090,21 +2123,8 @@ int o2net_init(void)
 	unsigned long i;
 
 	o2quo_init();
-
 	o2net_debugfs_init();
 
-	o2net_hand = kzalloc(sizeof(struct o2net_handshake), GFP_KERNEL);
-	o2net_keep_req = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
-	o2net_keep_resp = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
-	if (!o2net_hand || !o2net_keep_req || !o2net_keep_resp)
-		goto out;
-
-	o2net_hand->protocol_version = cpu_to_be64(O2NET_PROTOCOL_VERSION);
-	o2net_hand->connector_id = cpu_to_be64(1);
-
-	o2net_keep_req->magic = cpu_to_be16(O2NET_MSG_KEEP_REQ_MAGIC);
-	o2net_keep_resp->magic = cpu_to_be16(O2NET_MSG_KEEP_RESP_MAGIC);
-
 	for (i = 0; i < ARRAY_SIZE(o2net_nodes); i++) {
 		struct o2net_node *nn = o2net_nn_from_num(i);
 
@@ -2122,21 +2142,10 @@ int o2net_init(void)
 	}
 
 	return 0;
-
-out:
-	kfree(o2net_hand);
-	kfree(o2net_keep_req);
-	kfree(o2net_keep_resp);
-	o2net_debugfs_exit();
-	o2quo_exit();
-	return -ENOMEM;
 }
 
 void o2net_exit(void)
 {
 	o2quo_exit();
-	kfree(o2net_hand);
-	kfree(o2net_keep_req);
-	kfree(o2net_keep_resp);
 	o2net_debugfs_exit();
 }


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
