Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7B7C63703
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3/b+dJGnfJmShbSQPl0SH3fTKmnvZ5SZeQoiY2+U7G0=;
 b=PM6rfGORbfzJDOA47q77+NOoy5Im52JrGmEnYMcdCvd2eCISXU8P+d58YWQQ+7HxIyMFqACNUX4O
   0Tymh8kvaWu6mEg8OunuE6E7MwD1wm6MmPUXeKFASigtC2DT3l8JrVEzpqM2l9dGjxOt4tgc6wK9
   +ct6o4rW9oNoEEL6zZ4zxlEYzi66SiDFYCxAZUuKwT5De/ki3ToZgQfcInZU91p3pcWI4y0hPNuc
   4vm47MCJ/kaTB3xJQAItl4j6j874JWgwv/YhZ6sPPoWCpGmaEw5dmSl0SFebIuSfIU8KjIQKiC/J
   LD5QcpNIQEIPnS7gtGoPyqf9mozIXeJ0F7T3Ug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3/b+dJGnfJmShbSQPl0SH3fTKmnvZ5SZeQoiY2+U7G0=;
 b=KmqC3UB9uxvfRAHgO9zme8WPkYsPgRf0IoX5bdIAL54EmldcdtzmMED7zcpwl8g+sIzV0YBUJeN7
   vFbpfxlM3fL2j8tgNjNpZUy2zUJwhE8PL1GkkDWiywKgVXrvgco80tL+v+ZQeZZN1NRgTpmpBDOZ
   pgyREtc5N9A79XsUPzcrHz3/BI2BUGhSR/0/Ylxq89bU1QZnVkTZeopQ9hlYbszDNWw40rjsJfvt
   yfgYQrpu1Ut6O3wiB5pzeDjgJPjqy6Hm2+CfR5k5JN94O7u/dje5zPuYsqHbnfhc5Z+WKwbNlLlY
   2RhkyWLQtZkDzQyh0VtbBKZGcal5GJyEVlxzhQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00LYHVZ06R40@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:48 +0000 (GMT)
Date: Mon, 21 Nov 2022 08:59:51 +0100
To: Jeff Layton <jlayton@kernel.org>
Message-id: <20221121075951.GB24878@lst.de>
References: <20221120210004.381842-1-jlayton@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20221120210004.381842-1-jlayton@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10537
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=221 spamscore=0 mlxscore=0 clxscore=121 adultscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=564 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210063
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 Martin Brandenburg <martin@omnibond.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 linux-xfs@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 linux-cifs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-afs@lists.infradead.org,
 cluster-devel@redhat.com, Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, devel@lists.orangefs.org,
 Shyam Prasad N <sprasad@microsoft.com>,
 Eric Van Hensbergen <ericvh@gmail.com>, Tom Talpey <tom@talpey.com>,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>, linux-nfs@vger.kernel.org,
 Paulo Alcantara <pc@cjr.nz>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
 Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Chuck Lever <chuck.lever@oracle.com>, Anna Schumaker <anna@kernel.org>,
 Bob Peterson <rpeterso@redhat.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] filelock: move file locking definitions to
 separate header file
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
X-Proofpoint-GUID: 314-JFeMQKivIJ8oVPBCKUrigddGMZbT
X-Proofpoint-ORIG-GUID: 314-JFeMQKivIJ8oVPBCKUrigddGMZbT
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAFANnfOXqxPYxx0Pu33ny15TGp9HEEU86HPSRa4hxPBOYpdDR3rfYvlC3QcQGZ2
 1TablEU/85VMs9xIL86fPFFLQnDiZW3yk+ZCU2gL3zdVZJiu+YKDr2ngJIFIr6DQ
 rugkHGd5M3l+jqAt5SLs7WhWBrK6gKK+mUIhHCvyBQfwPlt1QgQVYl1qHP9ugD8q
 uA0zmo5wXjn+VJA4ICrILEqZZCs2D1ClSVgKwT9tUn476S4+dVhHTX4KAXrE4+s3
 L1FrvCQI/owAdQEE79weGktnTpAhAO18YVnwOguiVeb9leq7RZKWYL/cR4u+S4Ua
 DtXu7sYzDCyBHO1+FxfUiGHiI4upPJIf8y1MpvUXk4OsJdBEumYirY2jId72ZG3A
 gGB4HCy6HB28Vcez5202XRobRoBoly2DLDXvlz4GLU3BtzmTeLM4MO5p+TCBBOf0
 WtNP7Wm5BKoNfVdt8J/xOF6DrySqkFm3K2mAKOdncpz8EhHpUyvr6E21Qm/52umK
 dO6Jz8DAyCR5b153L3GyZVktyUjuheVpijcKWR7RK9fH

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although it would be nice to drop all the pointless externs in the
new file while you're at it.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
