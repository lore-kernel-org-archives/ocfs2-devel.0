Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BBE6EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jun 2023 02:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XDZBSDyaA5pNR+c5xW+GGwShNBm8PqZnPMlCfNPaSGg=;
 b=isOG4/rAti46Mu5ymzvZTPSEEyjKPCc4IyIPRJ0fvX27g2KoSvd4p8pn0ZCBoMfscSFOg0//gBIs
   eVHnS2RJsGQ/s4/LMsPWxLhwzckw1wgg3iMEmJBM4y4haRCpuZWUWw9p2PNySS0PUZXh/pa5l/LR
   XeWEfzqS7DjK20iee8S8D5cgMj7slKwDXisj18mlaYwLhzkT30F9GSCTMiD8vSl/96DS//9CzXJZ
   hXM2rvHeyNLBwR3qoYubj0pBqsY2EnhF8+dZ3rDykFWeiYDspzsBU5bWQhXGAMGUu0qJW0/ub0fS
   Q7J7kaoshCsGEgqCVbq3uqnw5TgTWvvRWfz4VA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XDZBSDyaA5pNR+c5xW+GGwShNBm8PqZnPMlCfNPaSGg=;
 b=IIpr6uqrdISpFhcYkusG9ac9oHDKHXo44+ILU43cqDRn2M7mk30ZnoSpntSBcbPgHxLZ2mPHY3x3
   l3/477GocQgwMbHHCHk+9YI+NPT0vou4RUOeD0x9RhgVrG8146DjTwtHTbAao+vxS1ZPVwhpLVgt
   kvyga0pwT7ti05B7mIfhVhe7Zq6tXiOwT+9T6f4Px4JJ+BY7vbSAgvPgp7T0ir2+qAobWqL19AKs
   q5Wl9itAkrLfqyWqd/Z0TIPs5DyrwjyJwl7Tek57c7w6bZp5spkBY4rrAQoxMp92P5ongwaO/xGa
   u1n6NVgB0JAUyzA7kCngZXeGK5Mg355zmUwALg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWQ00PBBLE56VA0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 24 Jun 2023 02:54:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1687560958;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DznK2AUeRuZJq7eWmkzDsLOFPhbrN3vu6EuXAdMNepE=;
 b=I17uaVHxXDtllpyiVTtomGBUje2R31diHr4ASrXBHE1lWemlpfvHQPmHZu9/M+v1JGLqIE
 1BWwoDFaQEbRLY++z1KaSfdE6cqHMjOCk8QC/56j5i7QKrzhqD9ULGVns9KoyvZQPCH/T2
 H9TDQiYtygX9zNFfJAbMtITVCQGT/wk=
To: netdev@vger.kernel.org
Date: Fri, 23 Jun 2023 23:55:10 +0100
Message-id: <20230623225513.2732256-14-dhowells@redhat.com>
In-reply-to: <20230623225513.2732256-1-dhowells@redhat.com>
References: <20230623225513.2732256-1-dhowells@redhat.com>
MIME-version: 1.0
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10750
 signatures=596816
Cc: Jens Axboe <axboe@kernel.dk>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Kurt Hackel <kurt.hackel@oracle.com>, David Ahern <dsahern@kernel.org>,
 linux-kernel@vger.kernel.org, Alexander Duyck <alexander.duyck@gmail.com>,
 David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH net-next v5 13/16] ocfs2: Fix use of slab data
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
X-MC-Unique: scLXM6p0PSyn60UPmGbLlg-1
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
X-Proofpoint-ORIG-GUID: g2PiXrbgUOuJm93GH_msFnXuR-zdpk3E
X-Proofpoint-GUID: g2PiXrbgUOuJm93GH_msFnXuR-zdpk3E
Reporting-Meta:
 AAECKOCf44dwwvi5NidQGRQsmWgUdyEA0ayd9rXbwOhMQlklARYb3srYUIKUfHyE
 ddBAi47jQreF4jrm6Tut77dcZAPDBM4d3q04+c5xiblm8V/uH/lNQy+dw9TJf/Pc
 yQgIuFPj1W1BLZx2Qhlca8+pVGwJNbr/54EHT1pQjB2asHHen3lqr9MtWaH4GZcf
 2G1krK7T71oMoCvSABcBo2TzpBnvPrqmKfaSQmIYqThvjcn6K8hHQ2Fx1wqYXw0H
 tnR3BZTluNsE/MjgGDq/zB89i2mAgTSNmT50jnSnvjTMsAwWHnZ/PAry7oSTUWqb
 z98TT6SNfcu4jre/lTvOc9NeMjTt8rOfHMaNJbV6m7rrjzKgVE1JkfFGPeisluLT
 zxOfmpJTBLmKdV27GZcAs0xx/7LelBmN4UVGGl6nhklSDIXu5dFTG5KH53lwNed9
 bYRdM6EyWIzRbjPGDkfq85M21YnEG9rIQIjUQR4OMrvIU1tDMtgQQjYWZ3pn+g5X
 TY1ogta/AKJSANQP9oNDliQw2tQcSibbRNVIePc6614=

ocfs2 uses kzalloc() to allocate buffers for o2net_hand, o2net_keep_req and
o2net_keep_resp and then passes these to sendpage.  This isn't really
allowed as the lifetime of slab objects is not controlled by page ref -
though in this case it will probably work.  sendmsg() with MSG_SPLICE_PAGES
will, however, print a warning and give an error.

Fix it to use folio_alloc() instead to allocate a buffer for the handshake
message, keepalive request and reply messages.

Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Mark Fasheh <mark@fasheh.com>
cc: Kurt Hackel <kurt.hackel@oracle.com>
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
