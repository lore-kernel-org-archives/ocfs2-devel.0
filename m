Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A84FEEDB
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Jun 2024 02:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640942; cv=none; b=hQt98gBdivPGwrZGKNh3i4MjIJec9ASTBO/Ai9f8gyQ+QSLJhgm7kycQTKemKAPC4dscmzdSc/ZD8bgCe4mFlRWjkh8WA4b4N0f3h9QGYznruPQTWr0knxEC0QWMJZJkUifU/WOkPEKyBZl6KsHym3L86IAZev3sx/rka92pV1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640942; c=relaxed/simple;
	bh=2AMkdPZKWvsmYsD3O+AX8oQXTToIpdh1ZGXeChHjSqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pr7/h/XCoRzkRp9w7kIfnFna2urI+o4cYKmfH8vbdEGO63evTu2eYQECESPSsSjUkYM9wU/E1psZl9ztNRnKtiF1HNoHyQc2aESUK0NJEgy51GEp8BPrPT4ECYWa3OVaVEoA3ejwgSQAnadcu0uzEX7qY0jjBE88werzPX23Rks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 820b9f9423ac11ef9305a59a3cc225df-20240606
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:de1b0203-e0e8-4176-94ec-70658eecebe5,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.1.38,REQID:de1b0203-e0e8-4176-94ec-70658eecebe5,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:82c5f88,CLOUDID:ef59916cf3e3bdb1ea0193934f573148,BulkI
	D:240606102255V77OWLIM,BulkQuantity:1,Recheck:0,SF:72|19|44|66|24|102,TC:n
	il,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FSD
X-UUID: 820b9f9423ac11ef9305a59a3cc225df-20240606
Received: from node4.com.cn [(39.156.73.12)] by mailgw.kylinos.cn
	(envelope-from <xialonglong@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1940339978; Thu, 06 Jun 2024 10:28:49 +0800
Received: from node4.com.cn (localhost [127.0.0.1])
	by node4.com.cn (NSMail) with SMTP id 470D516002081;
	Thu,  6 Jun 2024 10:28:49 +0800 (CST)
X-ns-mid: postfix-66611EE1-139648339
Received: from kylin-pc.. (unknown [172.25.130.133])
	by node4.com.cn (NSMail) with ESMTPA id 560E416002081;
	Thu,  6 Jun 2024 02:28:46 +0000 (UTC)
From: Longlong Xia <xialonglong@kylinos.cn>
To: mark@fasheh.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH] ocfs2: convert to pr_fmt
Date: Thu,  6 Jun 2024 10:28:23 +0800
Message-ID: <20240606022823.1296737-1-xialonglong@kylinos.cn>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Use the pr_fmt() macro to prefix all the output with "o2net: ".
while at it, convert printk(<LEVEL>) to pr_<level>().

Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 fs/ocfs2/cluster/tcp.c | 109 ++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 60 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 2b8fa3e782fb..fc483c7c4fb4 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -37,6 +37,8 @@
  * and only accepts the connection if the higher numbered node is heartb=
eating.
  */
=20
+#define pr_fmt(fmt) "o2net: " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched/mm.h>
 #include <linux/jiffies.h>
@@ -528,18 +530,16 @@ static void o2net_set_nn_state(struct o2net_node *n=
n,
=20
 	if (was_valid && !valid) {
 		if (old_sc)
-			printk(KERN_NOTICE "o2net: No longer connected to "
-				SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
+			pr_notice("No longer connected to " SC_NODEF_FMT "\n",
+				  SC_NODEF_ARGS(old_sc));
 		o2net_complete_nodes_nsw(nn);
 	}
=20
 	if (!was_valid && valid) {
 		o2quo_conn_up(o2net_num_from_nn(nn));
 		cancel_delayed_work(&nn->nn_connect_expired);
-		printk(KERN_NOTICE "o2net: %s " SC_NODEF_FMT "\n",
-		       o2nm_this_node() > sc->sc_node->nd_num ?
-		       "Connected to" : "Accepted connection from",
-		       SC_NODEF_ARGS(sc));
+		pr_notice("%s " SC_NODEF_FMT "\n", o2nm_this_node() > sc->sc_node->nd_=
num ?
+			  "Connected to" : "Accepted connection from", SC_NODEF_ARGS(sc));
 	}
=20
 	/* trigger the connecting worker func as long as we're not valid,
@@ -629,9 +629,8 @@ static void o2net_state_change(struct sock *sk)
 		o2net_sc_queue_work(sc, &sc->sc_connect_work);
 		break;
 	default:
-		printk(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
-			" shutdown, state %d\n",
-			SC_NODEF_ARGS(sc), sk->sk_state);
+		pr_notice("Connection to " SC_NODEF_FMT " shutdown, state %d\n",
+			  SC_NODEF_ARGS(sc), sk->sk_state);
 		o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
 		break;
 	}
@@ -1260,11 +1259,10 @@ static int o2net_check_handshake(struct o2net_soc=
k_container *sc)
 	struct o2net_node *nn =3D o2net_nn_from_num(sc->sc_node->nd_num);
=20
 	if (hand->protocol_version !=3D cpu_to_be64(O2NET_PROTOCOL_VERSION)) {
-		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " Advertised net "
-		       "protocol version %llu but %llu is required. "
-		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
-		       (unsigned long long)be64_to_cpu(hand->protocol_version),
-		       O2NET_PROTOCOL_VERSION);
+		pr_notice(SC_NODEF_FMT " Advertised net protocol version %llu but %llu=
 is required. Disconnecting.\n",
+			SC_NODEF_ARGS(sc),
+			(unsigned long long)be64_to_cpu(hand->protocol_version),
+			O2NET_PROTOCOL_VERSION);
=20
 		/* don't bother reconnecting if its the wrong version. */
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
@@ -1278,33 +1276,30 @@ static int o2net_check_handshake(struct o2net_soc=
k_container *sc)
 	 */
 	if (be32_to_cpu(hand->o2net_idle_timeout_ms) !=3D
 				o2net_idle_timeout()) {
-		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a network "
-		       "idle timeout of %u ms, but we use %u ms locally. "
-		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
-		       be32_to_cpu(hand->o2net_idle_timeout_ms),
-		       o2net_idle_timeout());
+		pr_notice(SC_NODEF_FMT " uses a network idle timeout of %u ms, but we =
use %u ms locally. Disconnecting.\n",
+			  SC_NODEF_ARGS(sc),
+			  be32_to_cpu(hand->o2net_idle_timeout_ms),
+			  o2net_idle_timeout());
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
 		return -1;
 	}
=20
 	if (be32_to_cpu(hand->o2net_keepalive_delay_ms) !=3D
 			o2net_keepalive_delay()) {
-		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a keepalive "
-		       "delay of %u ms, but we use %u ms locally. "
-		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
-		       be32_to_cpu(hand->o2net_keepalive_delay_ms),
-		       o2net_keepalive_delay());
+		pr_notice(SC_NODEF_FMT " uses a keepalive delay of %u ms, but we use %=
u ms locally. Disconnecting.\n",
+			  SC_NODEF_ARGS(sc),
+			  be32_to_cpu(hand->o2net_keepalive_delay_ms),
+			  o2net_keepalive_delay());
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
 		return -1;
 	}
=20
 	if (be32_to_cpu(hand->o2hb_heartbeat_timeout_ms) !=3D
 			O2HB_MAX_WRITE_TIMEOUT_MS) {
-		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a heartbeat "
-		       "timeout of %u ms, but we use %u ms locally. "
-		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
-		       be32_to_cpu(hand->o2hb_heartbeat_timeout_ms),
-		       O2HB_MAX_WRITE_TIMEOUT_MS);
+		pr_notice(SC_NODEF_FMT " uses a heartbeat timeout of %u ms, but we use=
 %u ms locally. Disconnecting.\n",
+			  SC_NODEF_ARGS(sc),
+			  be32_to_cpu(hand->o2hb_heartbeat_timeout_ms),
+			  O2HB_MAX_WRITE_TIMEOUT_MS);
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
 		return -1;
 	}
@@ -1497,9 +1492,8 @@ static void o2net_idle_timer(struct timer_list *t)
 	unsigned long msecs =3D o2net_idle_timeout();
 #endif
=20
-	printk(KERN_NOTICE "o2net: Connection to " SC_NODEF_FMT " has been "
-	       "idle for %lu.%lu secs.\n",
-	       SC_NODEF_ARGS(sc), msecs / 1000, msecs % 1000);
+	pr_notice("Connection to " SC_NODEF_FMT " has been idle for %lu.%lu sec=
s.\n",
+		  SC_NODEF_ARGS(sc), msecs / 1000, msecs % 1000);
=20
 	/* idle timerout happen, don't shutdown the connection, but
 	 * make fence decision. Maybe the connection can recover before
@@ -1645,8 +1639,8 @@ static void o2net_start_connect(struct work_struct =
*work)
=20
 out:
 	if (ret && sc) {
-		printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
-		       " failed with errno %d\n", SC_NODEF_ARGS(sc), ret);
+		pr_notice("Connect attempt to " SC_NODEF_FMT " failed with errno %d\n"=
,
+			  SC_NODEF_ARGS(sc), ret);
 		/* 0 err so that another will be queued and attempted
 		 * from set_nn_state */
 		o2net_ensure_shutdown(nn, sc, 0);
@@ -1669,12 +1663,10 @@ static void o2net_connect_expired(struct work_str=
uct *work)
=20
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
-		printk(KERN_NOTICE "o2net: No connection established with "
-		       "node %u after %u.%u seconds, check network and"
-		       " cluster configuration.\n",
-		     o2net_num_from_nn(nn),
-		     o2net_idle_timeout() / 1000,
-		     o2net_idle_timeout() % 1000);
+		pr_notice("No connection established with node %u after %u.%u seconds,=
 check network and cluster configuration.\n",
+			  o2net_num_from_nn(nn),
+			  o2net_idle_timeout() / 1000,
+			  o2net_idle_timeout() % 1000);
=20
 		o2net_set_nn_state(nn, NULL, 0, 0);
 	}
@@ -1821,9 +1813,9 @@ static int o2net_accept_one(struct socket *sock, in=
t *more)
=20
 	node =3D o2nm_get_node_by_ip(sin.sin_addr.s_addr);
 	if (node =3D=3D NULL) {
-		printk(KERN_NOTICE "o2net: Attempt to connect from unknown "
-		       "node at %pI4:%d\n", &sin.sin_addr.s_addr,
-		       ntohs(sin.sin_port));
+		pr_notice("Attempt to connect from unknown node at %pI4:%d\n",
+			  &sin.sin_addr.s_addr,
+			  ntohs(sin.sin_port));
 		ret =3D -EINVAL;
 		goto out;
 	}
@@ -1831,15 +1823,13 @@ static int o2net_accept_one(struct socket *sock, =
int *more)
 	if (o2nm_this_node() >=3D node->nd_num) {
 		local_node =3D o2nm_get_node_by_num(o2nm_this_node());
 		if (local_node)
-			printk(KERN_NOTICE "o2net: Unexpected connect attempt "
-					"seen at node '%s' (%u, %pI4:%d) from "
-					"node '%s' (%u, %pI4:%d)\n",
-					local_node->nd_name, local_node->nd_num,
-					&(local_node->nd_ipv4_address),
-					ntohs(local_node->nd_ipv4_port),
-					node->nd_name,
-					node->nd_num, &sin.sin_addr.s_addr,
-					ntohs(sin.sin_port));
+			pr_notice("Unexpected connect attempt seen at node '%s' (%u, %pI4:%d)=
 from node '%s' (%u, %pI4:%d)\n",
+				  local_node->nd_name, local_node->nd_num,
+				  &(local_node->nd_ipv4_address),
+				  ntohs(local_node->nd_ipv4_port),
+				  node->nd_name,
+				  node->nd_num, &sin.sin_addr.s_addr,
+				  ntohs(sin.sin_port));
 		ret =3D -EINVAL;
 		goto out;
 	}
@@ -1864,10 +1854,9 @@ static int o2net_accept_one(struct socket *sock, i=
nt *more)
 		ret =3D 0;
 	spin_unlock(&nn->nn_lock);
 	if (ret) {
-		printk(KERN_NOTICE "o2net: Attempt to connect from node '%s' "
-		       "at %pI4:%d but it already has an open connection\n",
-		       node->nd_name, &sin.sin_addr.s_addr,
-		       ntohs(sin.sin_port));
+		pr_notice("Attempt to connect from node '%s' at %pI4:%d but it already=
 has an open connection\n",
+			  node->nd_name, &sin.sin_addr.s_addr,
+			  ntohs(sin.sin_port));
 		goto out;
 	}
=20
@@ -1986,7 +1975,7 @@ static int o2net_open_listening_sock(__be32 addr, _=
_be16 port)
=20
 	ret =3D sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
 	if (ret < 0) {
-		printk(KERN_ERR "o2net: Error %d while creating socket\n", ret);
+		pr_err("Error %d while creating socket\n", ret);
 		goto out;
 	}
=20
@@ -2003,14 +1992,14 @@ static int o2net_open_listening_sock(__be32 addr,=
 __be16 port)
 	sock->sk->sk_reuse =3D SK_CAN_REUSE;
 	ret =3D sock->ops->bind(sock, (struct sockaddr *)&sin, sizeof(sin));
 	if (ret < 0) {
-		printk(KERN_ERR "o2net: Error %d while binding socket at "
-		       "%pI4:%u\n", ret, &addr, ntohs(port));=20
+		pr_err("Error %d while binding socket at %pI4:%u\n",
+		       ret, &addr, ntohs(port));
 		goto out;
 	}
=20
 	ret =3D sock->ops->listen(sock, 64);
 	if (ret < 0)
-		printk(KERN_ERR "o2net: Error %d while listening on %pI4:%u\n",
+		pr_err("Error %d while listening on %pI4:%u\n",
 		       ret, &addr, ntohs(port));
=20
 out:
--=20
2.45.1

