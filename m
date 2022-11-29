Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF2D9C433FE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 29 Nov 2022 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GT13DKrX/hBK8rqGeg9Lgz4Dm4mvf/5C9qsPuv2Miao=;
 b=DibIiYVeOMjEfGPd0q6j/oSIc4zeBq05sdbrXNXOEiXgQtXxcfT2UJFJVLlQLI7V5svBa2/qFiBO
   DuPrjwILAE43yRVcpUGO7vVHswCpah6F05U+TQiexbiD10dbGxoS+7CebZBFtUkKAtS/37Xg+I+w
   ofaapLdXHWL0fYzNySPPkxGlMhernxngpRskwER0CYqWEXiDPAZkxImucC9MHbTts6+EvTH6Vvj1
   kmeZgDFwCdn+iU+NGTOjb0LepSsrM7sSXS6kS7H0cCwSwzHQcHP3Q6wgapUOksFMD/MUamY1brma
   k4/t4YS/HU2lHorRqW+nxlvCsYVeoBmiOAIRcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GT13DKrX/hBK8rqGeg9Lgz4Dm4mvf/5C9qsPuv2Miao=;
 b=binbSJzZmTP3FuFazwDnUsalS+P+gn+lX8SEDYkuqxICJvq/t1tFyc8J2o8iFAfylij4PFfMd3U9
   TW4ShwtCCixJEqSnEK+EJyV4DHH0vgDHV4+0VvBPrCDM3PQyDXO4K861HsUEWSsBhkM2pZFn3EWu
   dTAxG5EvynmvBbc+yBAwrW9ZZo1tJxIAu0NPIL/YPXvTXpXjqaL21rBdilsqW9JxC1WTJhEDocf6
   orOLv3UO/2Qqm9ctqokIcTGJrTvrpAoX198SjkNj3DL9pZuCvTGdjd1IF0pyfT4Gx5O48X4952Sl
   y87XGvgU5XL2yC1mrWxvAnf0JAnf8ektpfqewA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM4008SO89YU050@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 29 Nov 2022 15:27:34 +0000 (GMT)
Date: Tue, 29 Nov 2022 15:02:42 +0100
To: Benjamin Coddington <bcodding@redhat.com>
Message-id: <20221129140242.GA15747@lst.de>
References: <cover.1669036433.git.bcodding@redhat.com>
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to:
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10546
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=212 bulkscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 clxscore=101 mlxlogscore=333 spamscore=0 adultscore=1
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290080
Cc: Latchesar Ionkov <lucho@ionkov.net>, samba-technical@lists.samba.org,
 Dominique Martinet <asmadeus@codewreck.org>,
 Valentina Manea <valentina.manea.m@gmail.com>, linux-nvme@lists.infradead.org,
 Philipp Reisner <philipp.reisner@linbit.com>,
 David Howells <dhowells@redhat.com>, Eric Dumazet <edumazet@google.com>,
 linux-nfs@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
 Shuah Khan <shuah@kernel.org>, Mike Christie <michael.christie@oracle.com>,
 drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 linux-afs@lists.infradead.org, cluster-devel@redhat.com,
 Christine Caulfield <ccaulfie@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Ilya Dryomov <idryomov@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 Anna Schumaker <anna@kernel.org>, Eric Van Hensbergen <ericvh@gmail.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
 linux-block@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
 Keith Busch <kbusch@kernel.org>, ceph-devel@vger.kernel.org,
 Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, Chris Leech <cleech@redhat.com>,
 open-iscsi@googlegroups.com, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
 Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Chuck Lever <chuck.lever@oracle.com>, Lee Duncan <lduncan@suse.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 "David S. Miller" <davem@davemloft.net>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 2/3] Treewide: Stop corrupting socket's
	task_frag
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: kQ3ffixk6_DmRdJVNS_hhD0i0nhe849_
X-Proofpoint-ORIG-GUID: kQ3ffixk6_DmRdJVNS_hhD0i0nhe849_
X-Mailman-Approved-At: Tue, 29 Nov 2022 15:27:32 +0000
Reporting-Meta:
 AAFXc74dt1IojaDpn9/KYHXEwYUkCIM3y56SUZlgsn7TeHgnbzv9kmEoEKKROGEY
 5fYY3Hn0LO2fl8xSmN39DMO0pKuj+EZ4L7cL5IzcSz3Vs//YuUeis8GV8D8ALpe0
 fEfGDPkyH1ZU/no7LHgIx6MsBOGaF8UFLqpTjeXP3L9g5FXJg29P1h9GGh3jCoLR
 EFvnQxtSEW0+wTi7t40zbPen9GKwIr3H48qsFZaimItD3q59ESHrsJkX7poqRLJT
 rAIonuWTg1tOQLKk+4yiopp6Ktgh83DZPkRxuVNmE18q2wlNhXhaQHN3+akVyoiP
 zhw+gNknKZygMQOIKmSERH4dSqi3S6p4lcVPG+0hJdylz5hW2x7rPxMbPVHlSvr6
 H3O7Xqcb2VpYTL3tfpwady92uKwujhQdWAXqX+n5qdNzVTcEsyZSRAPmitQ3L5xj
 8hbsnEtQtEnWJ47t+gJnKazgV0oN5M6ITup4oNHN+68rZRDLrA8RF8xEnp+Nc3gN
 2JdiaZ9DizP4upVuA9DHzbDamhNz45173Q4qSQWgLNc=

Hmm.  Having to set a flag to not accidentally corrupt per-task
state seems a bit fragile.  Wouldn't it make sense to find a way to opt
into the feature only for sockets created from the syscall layer?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
