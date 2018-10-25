From: piaojun <piaojun@huawei.com>
Date: Thu, 25 Oct 2018 18:35:02 +0800
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2/cluster: support IPv6 socket
 connection between nodes
Message-ID: <5BD19C56.5040201@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Both IPv4 and IPv6 will be supported when connecting or accepting other
nodes in cluster according to configuration by uppper user.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/cluster/nodemanager.c |   4 +-
 fs/ocfs2/cluster/nodemanager.h |   2 +-
 fs/ocfs2/cluster/tcp.c         | 190 ++++++++++++++++++++++++++++++-----------
 3 files changed, 141 insertions(+), 55 deletions(-)

diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 292f5dd..6813517 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -115,7 +115,7 @@ static struct o2nm_node *o2nm_node_ip_tree_lookup(struct o2nm_cluster *cluster,
 	return ret;
 }

-struct o2nm_node *o2nm_get_node_by_ip(__be32 addr)
+struct o2nm_node *o2nm_get_node_by_ip(u8 addr[])
 {
 	struct o2nm_node *node = NULL;
 	struct o2nm_cluster *cluster = o2nm_single_cluster;
@@ -124,7 +124,7 @@ struct o2nm_node *o2nm_get_node_by_ip(__be32 addr)
 		goto out;

 	read_lock(&cluster->cl_nodes_lock);
-	node = o2nm_node_ip_tree_lookup(cluster, (u8 *)&addr, NULL, NULL);
+	node = o2nm_node_ip_tree_lookup(cluster, addr, NULL, NULL);
 	if (node)
 		config_item_get(&node->nd_item);
 	read_unlock(&cluster->cl_nodes_lock);
diff --git a/fs/ocfs2/cluster/nodemanager.h b/fs/ocfs2/cluster/nodemanager.h
index 1f3cfc5..e5f8701 100644
--- a/fs/ocfs2/cluster/nodemanager.h
+++ b/fs/ocfs2/cluster/nodemanager.h
@@ -85,7 +85,7 @@ struct o2nm_cluster {

 int o2nm_configured_node_map(unsigned long *map, unsigned bytes);
 struct o2nm_node *o2nm_get_node_by_num(u8 node_num);
-struct o2nm_node *o2nm_get_node_by_ip(__be32 addr);
+struct o2nm_node *o2nm_get_node_by_ip(u8 addr[]);
 void o2nm_node_get(struct o2nm_node *node);
 void o2nm_node_put(struct o2nm_node *node);

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 1296f78..82fa8da 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1583,10 +1583,13 @@ static void o2net_start_connect(struct work_struct *work)
 	struct o2net_sock_container *sc = NULL;
 	struct o2nm_node *node = NULL, *mynode = NULL;
 	struct socket *sock = NULL;
+	struct sockaddr *mysa = NULL, *remotesa = NULL;
 	struct sockaddr_in myaddr = {0, }, remoteaddr = {0, };
-	int ret = 0, stop;
+	struct sockaddr_in6 myaddr6 = {0, }, remoteaddr6 = {0, };
+	int ret = 0, stop, addr_len;
 	unsigned int timeout;
 	unsigned int noio_flag;
+	unsigned short sa_family;

 	/*
 	 * sock_create allocates the sock with GFP_KERNEL. We must set
@@ -1633,7 +1636,33 @@ static void o2net_start_connect(struct work_struct *work)
 		goto out;
 	}

-	ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
+	if (mynode->nd_ipnet_type == IPV4_TYPE) {
+		myaddr.sin_family = sa_family = AF_INET;
+		myaddr.sin_addr.s_addr = mynode->nd_ipv4_address;
+		myaddr.sin_port = htons(0); /* any port */
+		mysa = (struct sockaddr *)&myaddr;
+
+		remoteaddr.sin_family = AF_INET;
+		remoteaddr.sin_addr.s_addr = node->nd_ipv4_address;
+		remoteaddr.sin_port = node->nd_ipv4_port;
+		remotesa = (struct sockaddr *)&remoteaddr;
+		addr_len = sizeof(myaddr);
+	} else {
+		myaddr6.sin6_family = sa_family = AF_INET6;
+		memcpy(&myaddr6.sin6_addr, mynode->nd_ipv6_address,
+				sizeof(mynode->nd_ipv6_address));
+		myaddr6.sin6_port = htons(0); /* any port */
+		mysa = (struct sockaddr *)&myaddr6;
+
+		remoteaddr6.sin6_family = AF_INET6;
+		memcpy(&remoteaddr6.sin6_addr, node->nd_ipv6_address,
+				sizeof(node->nd_ipv6_address));
+		remoteaddr6.sin6_port = node->nd_ipv6_port;
+		remotesa = (struct sockaddr *)&remoteaddr6;
+		addr_len = sizeof(myaddr6);
+	}
+
+	ret = sock_create(sa_family, SOCK_STREAM, IPPROTO_TCP, &sock);
 	if (ret < 0) {
 		mlog(0, "can't create socket: %d\n", ret);
 		goto out;
@@ -1642,15 +1671,14 @@ static void o2net_start_connect(struct work_struct *work)

 	sock->sk->sk_allocation = GFP_ATOMIC;

-	myaddr.sin_family = AF_INET;
-	myaddr.sin_addr.s_addr = mynode->nd_ipv4_address;
-	myaddr.sin_port = htons(0); /* any port */
-
-	ret = sock->ops->bind(sock, (struct sockaddr *)&myaddr,
-			      sizeof(myaddr));
+	ret = sock->ops->bind(sock, mysa, addr_len);
 	if (ret) {
-		mlog(ML_ERROR, "bind failed with %d at address %pI4\n",
-		     ret, &mynode->nd_ipv4_address);
+		if (mynode->nd_ipnet_type == IPV4_TYPE)
+			mlog(ML_ERROR, "bind failed with %d at address %pI4\n",
+			     ret, &mynode->nd_ipv4_address);
+		else
+			mlog(ML_ERROR, "bind failed with %d at address %pI6\n",
+			     ret, mynode->nd_ipv6_address);
 		goto out;
 	}

@@ -1673,13 +1701,9 @@ static void o2net_start_connect(struct work_struct *work)
 	o2net_set_nn_state(nn, sc, 0, 0);
 	spin_unlock(&nn->nn_lock);

-	remoteaddr.sin_family = AF_INET;
-	remoteaddr.sin_addr.s_addr = node->nd_ipv4_address;
-	remoteaddr.sin_port = node->nd_ipv4_port;
-
 	ret = sc->sc_sock->ops->connect(sc->sc_sock,
-					(struct sockaddr *)&remoteaddr,
-					sizeof(remoteaddr),
+					remotesa,
+					addr_len,
 					O_NONBLOCK);
 	if (ret == -EINPROGRESS)
 		ret = 0;
@@ -1819,11 +1843,13 @@ int o2net_register_hb_callbacks(void)

 static int o2net_accept_one(struct socket *sock, int *more)
 {
-	int ret;
+	int ret, slen;
+	struct sockaddr *sa = NULL;
 	struct sockaddr_in sin;
+	struct sockaddr_in6 sin6;
 	struct socket *new_sock = NULL;
 	struct o2nm_node *node = NULL;
-	struct o2nm_node *local_node = NULL;
+	struct o2nm_node *local_node = o2nm_get_node_by_num(o2nm_this_node());
 	struct o2net_sock_container *sc = NULL;
 	struct o2net_node *nn;
 	unsigned int noio_flag;
@@ -1864,22 +1890,39 @@ static int o2net_accept_one(struct socket *sock, int *more)
 		goto out;
 	}

-	ret = new_sock->ops->getname(new_sock, (struct sockaddr *) &sin, 1);
+	if (local_node->nd_ipnet_type == IPV4_TYPE) {
+		sa = (struct sockaddr *)&sin;
+		slen = sizeof(sin);
+	} else {
+		sa = (struct sockaddr *)&sin6;
+		slen = sizeof(sin6);
+	}
+	ret = new_sock->ops->getname(new_sock, sa, 1);
 	if (ret < 0)
 		goto out;

-	node = o2nm_get_node_by_ip(sin.sin_addr.s_addr);
-	if (node == NULL) {
-		printk(KERN_NOTICE "o2net: Attempt to connect from unknown "
-		       "node@%pI4:%d\n", &sin.sin_addr.s_addr,
-		       ntohs(sin.sin_port));
-		ret = -EINVAL;
-		goto out;
+	if (local_node->nd_ipnet_type == IPV4_TYPE) {
+		node = o2nm_get_node_by_ip((u8 *)&sin.sin_addr.s_addr);
+		if (node == NULL) {
+			printk(KERN_NOTICE "o2net: Attempt to connect from unknown "
+			       "node at %pI4:%d\n", &sin.sin_addr.s_addr,
+			       ntohs(sin.sin_port));
+			ret = -EINVAL;
+			goto out;
+		}
+	} else {
+		node = o2nm_get_node_by_ip(sin6.sin6_addr.s6_addr);
+		if (node == NULL) {
+			printk(KERN_NOTICE "o2net: Attempt to connect from unknown "
+			       "node at %pI6:%d\n", sin6.sin6_addr.s6_addr,
+			       ntohs(sin6.sin6_port));
+			ret = -EINVAL;
+			goto out;
+		}
 	}

 	if (o2nm_this_node() >= node->nd_num) {
-		local_node = o2nm_get_node_by_num(o2nm_this_node());
-		if (local_node)
+		if (local_node->nd_ipnet_type == IPV4_TYPE)
 			printk(KERN_NOTICE "o2net: Unexpected connect attempt "
 					"seen at node '%s' (%u, %pI4:%d) from "
 					"node '%s' (%u, %pI4:%d)\n",
@@ -1889,6 +1932,16 @@ static int o2net_accept_one(struct socket *sock, int *more)
 					node->nd_name,
 					node->nd_num, &sin.sin_addr.s_addr,
 					ntohs(sin.sin_port));
+		else
+			printk(KERN_NOTICE "o2net: Unexpected connect attempt "
+					"seen at node '%s' (%u, %pI6:%d) from "
+					"node '%s' (%u, %pI6:%d)\n",
+					local_node->nd_name, local_node->nd_num,
+					local_node->nd_ipv6_address,
+					ntohs(local_node->nd_ipv6_port),
+					node->nd_name,
+					node->nd_num, sin6.sin6_addr.s6_addr,
+					ntohs(sin6.sin6_port));
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1896,10 +1949,16 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	/* this happens all the time when the other node sees our heartbeat
 	 * and tries to connect before we see their heartbeat */
 	if (!o2hb_check_node_heartbeating_from_callback(node->nd_num)) {
-		mlog(ML_CONN, "attempt to connect from node '%s' at "
-		     "%pI4:%d but it isn't heartbeating\n",
-		     node->nd_name, &sin.sin_addr.s_addr,
-		     ntohs(sin.sin_port));
+		if (local_node->nd_ipnet_type == IPV4_TYPE)
+			mlog(ML_CONN, "attempt to connect from node '%s' at "
+			     "%pI4:%d but it isn't heartbeating\n",
+			     node->nd_name, &sin.sin_addr.s_addr,
+			     ntohs(sin.sin_port));
+		else
+			mlog(ML_CONN, "attempt to connect from node '%s' at "
+			     "%pI6:%d but it isn't heartbeating\n",
+			     node->nd_name, sin6.sin6_addr.s6_addr,
+			     ntohs(sin6.sin6_port));
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1913,10 +1972,16 @@ static int o2net_accept_one(struct socket *sock, int *more)
 		ret = 0;
 	spin_unlock(&nn->nn_lock);
 	if (ret) {
-		printk(KERN_NOTICE "o2net: Attempt to connect from node '%s' "
-		       "at %pI4:%d but it already has an open connection\n",
-		       node->nd_name, &sin.sin_addr.s_addr,
-		       ntohs(sin.sin_port));
+		if (local_node->nd_ipnet_type == IPV4_TYPE)
+			printk(KERN_NOTICE "o2net: Attempt to connect from node '%s' "
+			       "at %pI4:%d but it already has an open connection\n",
+			       node->nd_name, &sin.sin_addr.s_addr,
+			       ntohs(sin.sin_port));
+		else
+			printk(KERN_NOTICE "o2net: Attempt to connect from node '%s' "
+			       "at %pI6:%d but it already has an open connection\n",
+			       node->nd_name, sin6.sin6_addr.s6_addr,
+			       ntohs(sin6.sin6_port));
 		goto out;
 	}

@@ -2022,17 +2087,30 @@ static void o2net_listen_data_ready(struct sock *sk)
 		ready(sk);
 }

-static int o2net_open_listening_sock(__be32 addr, __be16 port)
+static int o2net_open_listening_sock(struct o2nm_node *node)
 {
 	struct socket *sock = NULL;
-	int ret;
-	struct sockaddr_in sin = {
-		.sin_family = PF_INET,
-		.sin_addr = { .s_addr = addr },
-		.sin_port = port,
-	};
+	int ret, addr_len;
+	struct sockaddr *sa = NULL;
+	struct sockaddr_in sin;
+	struct sockaddr_in6 sin6;
+	unsigned short sa_family;
+
+	if (node->nd_ipnet_type == IPV4_TYPE) {
+		sin.sin_family = sa_family = PF_INET;
+		sin.sin_addr.s_addr = node->nd_ipv4_address;
+		sin.sin_port = node->nd_ipv4_port;
+		sa = (struct sockaddr *)&sin;
+		addr_len = sizeof(sin);
+	} else {
+		sin6.sin6_family = sa_family = PF_INET6;
+		memcpy(&sin6.sin6_addr, node->nd_ipv6_address, sizeof(sin6.sin6_addr));
+		sin6.sin6_port = node->nd_ipv6_port;
+		sa = (struct sockaddr *)&sin6;
+		addr_len = sizeof(sin6);
+	}

-	ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
+	ret = sock_create(sa_family, SOCK_STREAM, IPPROTO_TCP, &sock);
 	if (ret < 0) {
 		printk(KERN_ERR "o2net: Error %d while creating socket\n", ret);
 		goto out;
@@ -2049,17 +2127,26 @@ static int o2net_open_listening_sock(__be32 addr, __be16 port)
 	INIT_WORK(&o2net_listen_work, o2net_accept_many);

 	sock->sk->sk_reuse = SK_CAN_REUSE;
-	ret = sock->ops->bind(sock, (struct sockaddr *)&sin, sizeof(sin));
+	ret = sock->ops->bind(sock, sa, addr_len);
 	if (ret < 0) {
-		printk(KERN_ERR "o2net: Error %d while binding socket@"
-		       "%pI4:%u\n", ret, &addr, ntohs(port));
+		if (node->nd_ipnet_type == IPV4_TYPE)
+			printk(KERN_ERR "o2net: Error %d while binding socket at "
+			       "%pI4:%u\n", ret, &sin.sin_addr.s_addr, ntohs(sin.sin_port));
+		else
+			printk(KERN_ERR "o2net: Error %d while binding socket at "
+			       "%pI6:%u\n", ret, sin6.sin6_addr.s6_addr, ntohs(sin6.sin6_port));
 		goto out;
 	}

 	ret = sock->ops->listen(sock, 64);
-	if (ret < 0)
-		printk(KERN_ERR "o2net: Error %d while listening on %pI4:%u\n",
-		       ret, &addr, ntohs(port));
+	if (ret < 0) {
+		if (node->nd_ipnet_type == IPV4_TYPE)
+			printk(KERN_ERR "o2net: Error %d while listening on %pI4:%u\n",
+			       ret, &sin.sin_addr.s_addr, ntohs(sin.sin_port));
+		else
+			printk(KERN_ERR "o2net: Error %d while listening on %pI6:%u\n",
+			       ret, sin6.sin6_addr.s6_addr, ntohs(sin6.sin6_port));
+	}

 out:
 	if (ret) {
@@ -2091,8 +2178,7 @@ int o2net_start_listening(struct o2nm_node *node)
 		return -ENOMEM; /* ? */
 	}

-	ret = o2net_open_listening_sock(node->nd_ipv4_address,
-					node->nd_ipv4_port);
+	ret = o2net_open_listening_sock(node);
 	if (ret) {
 		destroy_workqueue(o2net_wq);
 		o2net_wq = NULL;
-- 
