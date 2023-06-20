Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A47E3EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=usPeP2RPMUoU8UCnhaRAbf57oSuCprXW/d8KbPTyRRA=;
 b=ldhocyyB+AokbMhZT7DmlZ1WLhr/t9JCuW6Ol0r4uPDWeJDo5MP3i2+aqJ8eiHRELrPU0JgOD+UL
   3ddbU5fQf4cJMacLxrKaKWG1gr90HTeXkobnAhs96KdtrlgE3c/02Efhu9Awq8diLzRcXWk3IUIs
   fYrpdjWfe0+gf5u4frkyYn/0HNHeEZBLtVmYHEXubmOY47e0VefkIkBlZFF0ZQEqehCcqXhXhxrY
   XIdVVAPYB5dWusdLUIcnXz3RBg8uSYNxrww1yQF8/BAnQ8bz9juN4eLpN7IWqW/1HSV+0XwTSdNO
   g0Zpg4ocg2ZlJQ3jn7YF5mBerJWC4GvFjrmTcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=usPeP2RPMUoU8UCnhaRAbf57oSuCprXW/d8KbPTyRRA=;
 b=O2FNVzQX2qdctbnO96M9mbHZZiTYtxQ3m+OQGBsNr8SxZWEekS8w0o158HGZ+v+pukrruAYn60M8
   UQIcLQHkbjX8MAaPvhB3gFntEGJobywHUXAPeolfjgBGnSx4mfcg1VOekeQVPgDwdTXcSzKI8/IK
   TCNAMA+pmQLKLad/COLCJBXv2ZIm7lVNmJqTNRWv/YJck2qL4nPLVqhM2ikoYL34urgrF6eoEzTB
   47mxmwvJytMWK50eQb11DMDXph6KnPuzUoDnxStyKYkusipZNN/l6tenQltx6j+SzVJycrB6BQyK
   X8wYnWX+aKZd3iDVQx+yRn4rlV10iwK/Ms5joQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK003B747ZUH60@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:57:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1687273041;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=LPVmbLfi9bgga9t/1pR/YmjTCDUThBHs3vchY9icGtA=;
 b=TQAiQiVrDTADOAtnpROiC6W7TxL9Pjao/451jtBsSv4dEHG9mUYMaIwD3Akba/hHLD+4a9
 Wgx7fy+uPBI4ndTM0nB+tBkz+fdlF7SQCv/krnJoh9esQBL+bJPfrKcdw00GlxB+r5j8zq
 1TJT7BiJV0uNZgZ6ko5m+YcFvgFW5MA=
To: netdev@vger.kernel.org
Date: Tue, 20 Jun 2023 15:53:32 +0100
Message-id: <20230620145338.1300897-14-dhowells@redhat.com>
In-reply-to: <20230620145338.1300897-1-dhowells@redhat.com>
References: <20230620145338.1300897-1-dhowells@redhat.com>
MIME-version: 1.0
X-Source-IP: 170.10.133.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10747
 signatures=596816
Cc: Jens Axboe <axboe@kernel.dk>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
 Alexander Duyck <alexander.duyck@gmail.com>,
 David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH net-next v3 13/18] ocfs2: Use
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
X-MC-Unique: azJhDjRHOim524o5jKEhlw-1
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
X-Proofpoint-GUID: Y3CiicOaroBZ4RGhHYMEiJ9ycf4_kVme
X-Proofpoint-ORIG-GUID: Y3CiicOaroBZ4RGhHYMEiJ9ycf4_kVme
Reporting-Meta:
 AAEoght2UwhadxlETK3kS1Yr7ths3QF2HaiK3BQRFRfrh68jIYpqPSG6XuSLO0Gv
 uDmxgIJuPEdcPKr0WTqTlRcIz0ivlgVhpc847RliSj4+3IENuRF+hN4iGC+YKs7Q
 WBr6ZA8NEVYcGm0YFtHcXMA19dpFjwsRH3fOuRu7COnnkXJ9oguEwOVIB7QhLuAZ
 DgT3xb30SMRwN6nN/iZcAcbiOoiyNKNEfT/1h4UZwYn+jENBZOL7H/VaY6hnQ8DL
 G9KNSbLdXWE1GiSD5YEY/SmoGSajZEQ73MO9pdyQmK5Mcgwqse9wrKhLWqsAKqkC
 BAOSkZxSCyw7WYNFKbrs0k6WRvIP0sSEWHvdRFYgcKZtDXNKXprDhihuzahcrhJA
 5f1qndlTnAD9nAqOKiUfGu6vBYKcktKjhhsY1LyhVutlfnaZyrYSa0oQqCBnzf7t
 aJtt+x1oAwRXo3Cp0WN/BNkIlZSWdEDqnqRCJY7QYekGIe6GBM0kbJc+CoQ4kJft
 HNyKDEyoBf4mIrqBGaEthTkKQywtnDyXa6DRbS9wbxtD

Fix ocfs2 to use the page fragment allocator rather than kzalloc in order
to allocate the buffers for the handshake message and keepalive request and
reply messages.

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

Notes:
    ver #2)
     - Wrap lines at 80.

 fs/ocfs2/cluster/tcp.c | 109 +++++++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 49 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index aecbd712a00c..969d347ed9fa 100644
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
@@ -1186,8 +1187,17 @@ static int o2net_process_message(struct o2net_sock_container *sc,
 					   be32_to_cpu(hdr->status));
 			goto out;
 		case O2NET_MSG_KEEP_REQ_MAGIC:
-			o2net_sendpage(sc, o2net_keep_resp,
-				       sizeof(*o2net_keep_resp));
+			keep_resp = alloc_skb_frag(sizeof(*keep_resp),
+						   GFP_KERNEL);
+			if (!keep_resp) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			memset(keep_resp, 0, sizeof(*keep_resp));
+			keep_resp->magic =
+				cpu_to_be16(O2NET_MSG_KEEP_RESP_MAGIC);
+			o2net_sendpage(sc, keep_resp, sizeof(*keep_resp));
+			folio_put(virt_to_folio(keep_resp));
 			goto out;
 		case O2NET_MSG_KEEP_RESP_MAGIC:
 			goto out;
@@ -1439,15 +1449,23 @@ static void o2net_rx_until_empty(struct work_struct *work)
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
+	hand = alloc_skb_frag(sizeof(*hand), GFP_KERNEL);
+	if (!hand)
+		return NULL;
+
+	memset(hand, 0, sizeof(*hand));
+	hand->protocol_version		= cpu_to_be64(O2NET_PROTOCOL_VERSION);
+	hand->connector_id		= cpu_to_be64(1);
+	hand->o2hb_heartbeat_timeout_ms	=
+		cpu_to_be32(O2HB_MAX_WRITE_TIMEOUT_MS);
+	hand->o2net_idle_timeout_ms	= cpu_to_be32(o2net_idle_timeout());
+	hand->o2net_keepalive_delay_ms	= cpu_to_be32(o2net_keepalive_delay());
+	hand->o2net_reconnect_delay_ms	= cpu_to_be32(o2net_reconnect_delay());
+	return hand;
 }
 
 /* ------------------------------------------------------------ */
@@ -1456,16 +1474,22 @@ static void o2net_initialize_handshake(void)
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
 
@@ -1475,8 +1499,15 @@ static void o2net_sc_send_keep_req(struct work_struct *work)
 	struct o2net_sock_container *sc =
 		container_of(work, struct o2net_sock_container,
 			     sc_keepalive_work.work);
+	struct o2net_msg *keep_req;
 
-	o2net_sendpage(sc, o2net_keep_req, sizeof(*o2net_keep_req));
+	keep_req = alloc_skb_frag(sizeof(*keep_req), GFP_KERNEL);
+	if (keep_req) {
+		memset(keep_req, 0, sizeof(*keep_req));
+		keep_req->magic = cpu_to_be16(O2NET_MSG_KEEP_REQ_MAGIC);
+		o2net_sendpage(sc, keep_req, sizeof(*keep_req));
+		folio_put(virt_to_folio(keep_req));
+	}
 	sc_put(sc);
 }
 
@@ -1780,6 +1811,7 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	struct socket *new_sock = NULL;
 	struct o2nm_node *node = NULL;
 	struct o2nm_node *local_node = NULL;
+	struct o2net_handshake *hand;
 	struct o2net_sock_container *sc = NULL;
 	struct o2net_node *nn;
 	unsigned int nofs_flag;
@@ -1882,8 +1914,11 @@ static int o2net_accept_one(struct socket *sock, int *more)
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
@@ -2090,21 +2125,8 @@ int o2net_init(void)
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
 
@@ -2122,21 +2144,10 @@ int o2net_init(void)
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
