Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E83F8EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jun 2023 02:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KD9Ijz+Ucabdxp6nn4YEuNBWGy2LSUisnwNqArTBiXU=;
 b=xgqXG70EtP9WvsqNaoV4KVzeBcrXN1n1aMPD0D6VmAnuV474kptdcvR5RBOfxahcABbAMpe7XWnD
   AH1rG72vyRxyVJdkedno5ZlDXH9TyWB9Ejxb3gPblgmHhNQO4StP/OELjQ5mdNPFXEDUMUaKlGBC
   +J4koOV+AQr12Bxb33gi3X/B8vp6yejtLGpUrObQd340GDSRkN2TTo3Phkk7r+OgHmY1OU6u7AIp
   DglGhQUo7UfRHeWueSdar7AMuFEr+4FpNs6V6wGk+4KQdT9Ne+Ad3MX1DAj40c2ABKkN8Hja5ZEi
   9McMXuIB7QmW0lvMd2pitpO428v+RIju0K9aGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KD9Ijz+Ucabdxp6nn4YEuNBWGy2LSUisnwNqArTBiXU=;
 b=Hm8U28B5L934SNnIDmCVsmIeC4RIgF/nhy9WiZkrmJbWO4SZ3DBMUx0ETeNe1tfPDI+YQaUyxAM7
   pSPIgaqelk77FK/+vED5GwSHGTI/TbUIbnOvTSp8rurhUjfFELuqjdquhnHGtf1rXMnctx4ontTh
   coTHaJGAoXNCAQjZOXzZJJF275TeOGB0OsVTfxiqHqWOCe6iWvA+rndwaq+lO5vSk4TnOl4OAP29
   2k6E3NDSyFM+FRgr9Vpwxf5pnCCbtzmiyMhQ45WsXRWKtJtC18mEOBJACepymgqSgLlq2/Y1itmF
   35k5PH6NEnoKPCG9R78W7llu3vhxin/7neyVGQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWQ00LJ7LEDZ420@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 24 Jun 2023 02:54:13 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1687560964;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6qW7QONKdXKQCe18ckz4PBDuqjad2A9AyVw+035R3zM=;
 b=Vv7dLA8hBk4btvpRclhRoEBG8PXnqHicj0Xf+7dXTneuHG7L71yUSHGziivVNDuyKKZLyx
 T4m8GhqVN4Oh3QEu/QD7Nh0vpY3shvjK/cfAbgGdjkw5RaF0YRP7S4Uzcn3O6I2JqCyJUd
 NtbL9WwI4nB4jAwNY+nu4NntWvM8d2E=
To: netdev@vger.kernel.org
Date: Fri, 23 Jun 2023 23:55:11 +0100
Message-id: <20230623225513.2732256-15-dhowells@redhat.com>
In-reply-to: <20230623225513.2732256-1-dhowells@redhat.com>
References: <20230623225513.2732256-1-dhowells@redhat.com>
MIME-version: 1.0
X-Source-IP: 170.10.133.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10750
 signatures=596816
Cc: Jens Axboe <axboe@kernel.dk>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
 Alexander Duyck <alexander.duyck@gmail.com>,
 David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH net-next v5 14/16] ocfs2: Use
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
X-MC-Unique: a9340YSgPS-PNmqg9L7xcg-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
X-Proofpoint-GUID: V_4EjNe4R4Hox3XfJahfjlW4Q2Wrg3Fm
X-Proofpoint-ORIG-GUID: V_4EjNe4R4Hox3XfJahfjlW4Q2Wrg3Fm
Reporting-Meta:
 AAECKOCf44dwwvi5NidQGRQsmWgUdyEA0ayd9rXbwOhMQlklARYb3srYUIKUfHyE
 ddBAi47jQreF4jrm6Tu377dcZAPDBM4d3q03IfjR4yacod4qmJVkQU9J0pKD1F2z
 8ydToHCAroA1QHrT3hcf/WJgngeHRCL5m5/ln96NanQHuKWfOSaVEv6yPHwKpa1+
 k/BtpFriXsH7d29Kf2R1LE7dwha7s/V27GPjmOyRVdrLuuf9hpVMdeKcK3A/SUZ7
 VluR3vUbxCQb+2GdUrAs4I9Bv1+EZL5VzZmaNtidVjadr43R/xLaUNbr/FNybc7M
 0xnxP0ekXOPrW65pQasi/OfO9uq26aqucmZjH2Kdjz+FtxAeBq37K1Yy4d5akNc2
 6AwoWW+RdWevpsb8drJ5x9PDwps2TmHSgslCtBbRCMNah5d2191EqEhdqzuRAp7H
 kpULgnU6UAXYvo1P9mhwWZ9RvM8FggCfyPyS5+w+WKozf4JCHGF/DBqXjNJNnbmM
 qJLJOKuHsE0bTLKy58ScuDgJw2bNDVfOZDlG3UHyrFpN

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
