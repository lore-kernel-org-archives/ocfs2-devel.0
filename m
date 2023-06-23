Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60345EB64DD
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jun 2023 02:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KD9Ijz+Ucabdxp6nn4YEuNBWGy2LSUisnwNqArTBiXU=;
 b=K8PoTavE9wSdP8Ce37PZ/7et9Vmd2TfjXYHC1Ul1XyWqFAT9q5KOAit6J0Ic9AZ/GsYPTypLBtRu
   Ow+AM4x+gVgWtqWQZvrz7tR2TUsVUJZ6jyaUF2UL5M4+jHPwtPWaF+1aJwCQs5evkSJB5F9oOCk3
   ns6C+meI3SS68h3dQBg7PY37rlNZxL39QHaEungM8ePgYIQCcFv5Y+suQz0OnYyIv7dS98wDIhfQ
   QKDJk8aTnwMRNQD1LZg2LJtD1BLelkNc3SEQAnGaFfyqO1fgzpVTwdpx68B8r6ZiXFqb/c42azMG
   LuYmGJR328Gb2fGzUn8RbTHc3oRhjzAsl9e7SQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KD9Ijz+Ucabdxp6nn4YEuNBWGy2LSUisnwNqArTBiXU=;
 b=l7UnUg1aidEZFKnKnGF0CC8Fv5d8+8P+WA7JsFE5r62r/Yc0jbl+u7R+39UzaPff4vfzoFgK4rwd
   C32soYveFs5x4CtcZEWgssi/9qCC268lofgBXkwjDA0WF9iYNcDSMcQO88zyur2x6J19sQEVP7T5
   meeiv07erOhNhT+FbCmcUoyJL85UeZhjS7BTTRkKu7GnrlrUGZ6en2r7rVZ9Chu+KrQiEmk0Z86R
   NfNpZFesd4FpLifEQeT0wFR/XKx7RdHMKAA5EPg2IbBcW5uHpLkcf72Dt0RJvch95kBg2RZhe+fx
   lPTH7M7N7f8vOfKpBv6PeEDoJ6GaVeyKJZtNtg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWQ009P2LF6B590@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 24 Jun 2023 02:54:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1687520722;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6qW7QONKdXKQCe18ckz4PBDuqjad2A9AyVw+035R3zM=;
 b=UzHNYP6Za19pgiNVjw4MDxLM5mYdIaSrmyRvVqGq+LNFwti4eWaCifuJpTdc0+vHLeTK9A
 5drBTm5c3J21vk8M3r5/x6aqigN/hGz82PfgFZoGqJi7dqnse07wjOVe5j9yTTuHRNzw11
 WWpCCAN08kLZ+loNyrEGNfTeqzlMdqY=
To: netdev@vger.kernel.org
Date: Fri, 23 Jun 2023 12:44:23 +0100
Message-id: <20230623114425.2150536-14-dhowells@redhat.com>
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
Subject: [Ocfs2-devel] [PATCH net-next v4 13/15] ocfs2: Use
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
X-MC-Unique: woVC1FXnMaeEutQKCYvqpQ-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
X-Proofpoint-GUID: msSohsfKF1p5OMeP7iw87rFsD412H07G
X-Proofpoint-ORIG-GUID: msSohsfKF1p5OMeP7iw87rFsD412H07G
Reporting-Meta:
 AAFH+NSzF+gicqQYnmRQ8yFMnIDLS7g3bbcTisFwGu4isuuiYPOVZa4gi3kgittE
 bWBt1oG2mTpJW4LX4yg5v78eXXVb5p279NEFn7XJUG9dCFAtbdQuL/sUfKHug/Dl
 +kPMAtxoo/D8p54RDGH1S2CzPVAzdjkFx5zLiN/rnEtMD1D+ogLVQUqAz8P0Q8V2
 KFkr0zHJPEq4ssAVbYRGXIdMmmh8PVcrIpzLSn7IIl5urk5hwEquzwn15sTGCFVU
 FHcbMT+xgruB0EYQgq5h8oblS1tYgFgdYcxNY6B7szOMsJZNTU0T73P7q5Qkd2dl
 V3vJbDwEhZVDCoabu8JUYfqaCcCBD4DEMIjpM779luQaf/JyLbFYjucRHq0NVNcm
 KsiSLSJUmfeI5pDeEERBmc9GrFqGf1XFRsLzl8v2R3M0Lt8PzGJ3rqhtf6qVV9kF
 +NNaQ/9w7QiIx8oS/YFOeO9U84W16vrKbFk6oGKZiHVdj19LZuTrJYX2efySKbC9
 1/XgMve9J0QoBR7WiqmWROyJbL0LHRZmL67eep1NXFk=

Switch ocfs2 from using sendpage() to using sendmsg() + MSG_SPLICE_PAGES so
that sendpage can be phased out.

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
    ver #4)
     - Use folio_alloc() for o2net_hand, o2net_keep_req and o2net_keep_resp.
    
    ver #2)
     - Wrap lines at 80.

 fs/ocfs2/cluster/tcp.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 929a1133bc18..960080753d3b 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -930,19 +930,22 @@ static int o2net_send_tcp_msg(struct socket *sock, struct kvec *vec,
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


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
