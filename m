From: Christoph Hellwig <hch@lst.de>
Date: Wed, 20 May 2020 21:54:44 +0200
Subject: [Ocfs2-devel] [PATCH 08/33] net: add sock_enable_timestamps
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
Message-ID: <20200520195509.2215098-9-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jon Maloy <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ying Xue <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org

Add a helper to directly enable timestamps instead of setting the
SO_TIMESTAMP* sockopts from kernel space and going through a fake
uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/sock.h       |  1 +
 net/core/sock.c          | 47 +++++++++++++++++++++++++---------------
 net/rxrpc/local_object.c |  8 +------
 3 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index cdec7bc055d5b..99ef43508d2b5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2689,6 +2689,7 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 void sock_def_readable(struct sock *sk);
 
 int sock_bindtoindex(struct sock *sk, int ifindex);
+void sock_enable_timestamps(struct sock *sk);
 void sock_no_linger(struct sock *sk);
 void sock_set_priority(struct sock *sk, u32 priority);
 void sock_set_reuseaddr(struct sock *sk);
diff --git a/net/core/sock.c b/net/core/sock.c
index 23f80880fbb2c..e4a4dd2b3d8b3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -757,6 +757,28 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs)
 }
 EXPORT_SYMBOL(sock_set_sndtimeo);
 
+static void __sock_set_timestamps(struct sock *sk, bool val, bool new, bool ns)
+{
+	if (val)  {
+		sock_valbool_flag(sk, SOCK_TSTAMP_NEW, new);
+		sock_valbool_flag(sk, SOCK_RCVTSTAMPNS, ns);
+		sock_set_flag(sk, SOCK_RCVTSTAMP);
+		sock_enable_timestamp(sk, SOCK_TIMESTAMP);
+	} else {
+		sock_reset_flag(sk, SOCK_RCVTSTAMP);
+		sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
+		sock_reset_flag(sk, SOCK_TSTAMP_NEW);
+	}
+}
+
+void sock_enable_timestamps(struct sock *sk)
+{
+	lock_sock(sk);
+	__sock_set_timestamps(sk, true, false, true);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_enable_timestamps);
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
@@ -948,28 +970,17 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_TIMESTAMP_OLD:
+		__sock_set_timestamps(sk, valbool, false, false);
+		break;
 	case SO_TIMESTAMP_NEW:
+		__sock_set_timestamps(sk, valbool, true, false);
+		break;
 	case SO_TIMESTAMPNS_OLD:
+		__sock_set_timestamps(sk, valbool, false, true);
+		break;
 	case SO_TIMESTAMPNS_NEW:
-		if (valbool)  {
-			if (optname == SO_TIMESTAMP_NEW || optname == SO_TIMESTAMPNS_NEW)
-				sock_set_flag(sk, SOCK_TSTAMP_NEW);
-			else
-				sock_reset_flag(sk, SOCK_TSTAMP_NEW);
-
-			if (optname == SO_TIMESTAMP_OLD || optname == SO_TIMESTAMP_NEW)
-				sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
-			else
-				sock_set_flag(sk, SOCK_RCVTSTAMPNS);
-			sock_set_flag(sk, SOCK_RCVTSTAMP);
-			sock_enable_timestamp(sk, SOCK_TIMESTAMP);
-		} else {
-			sock_reset_flag(sk, SOCK_RCVTSTAMP);
-			sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
-			sock_reset_flag(sk, SOCK_TSTAMP_NEW);
-		}
+		__sock_set_timestamps(sk, valbool, true, true);
 		break;
-
 	case SO_TIMESTAMPING_NEW:
 		sock_set_flag(sk, SOCK_TSTAMP_NEW);
 		/* fall through */
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 01135e54d95d2..5ea2bd01fdd59 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -189,13 +189,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 		}
 
 		/* We want receive timestamps. */
-		opt = 1;
-		ret = kernel_setsockopt(local->socket, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
-					(char *)&opt, sizeof(opt));
-		if (ret < 0) {
-			_debug("setsockopt failed");
-			goto error;
-		}
+		sock_enable_timestamps(local->socket->sk);
 		break;
 
 	default:
-- 
2.26.2
