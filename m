Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10ACAC61DB3
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Jan 2023 02:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+FTeHpSf5Cf3H9lNPV3jAepmaeEHh7NZR7FuXIOprhI=;
 b=BgKSNq81AFO4xs4q5N70aePj+oeahZcXOAr0bZgr8dMHAoWGxu6c5z2iBNGbQVOHqwkp/Qn4IvAM
   TW3NN8joEtRoeMs7Ptrf3wCUzLnLjJ1osqiU4/WcHhATfw/cYbix9rNGga57cM/eY7KRSWLP+0Sc
   BU7/I988NNKwUD8QK5abWwk5UBEbBWYvMIXf3vKGFf9St7J7JkgKryKTdr1JOiZISTjWecM9GdbJ
   Lr4wBGQUdiFSvCi3S6NcmZUx0NJ/QhwLrtpjwH2eizXqmljT6GZoNAChm/g3bTBApqiLySkwOEs+
   qFfCzox/m0l4KB7+GDRkSNEnIMCN9yDgkKAMEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+FTeHpSf5Cf3H9lNPV3jAepmaeEHh7NZR7FuXIOprhI=;
 b=udAVAw1mSx5lbH4DD52jA2LAXEF+s/IdX24MJ1XiaPbosu5ZA86GgqPkfl8lq8MU+hX4/iiH0vbH
   /H7MWSMtl12ny4kNO+NYdBcu5IRgu694on8R9xCob01gwmW55vh/SY0IWwCdR7JU8Q0AelZjEC+H
   nwAW6U/oVVjo2KGFBC4nGbqhtgjlOqT4xFWYgps4HDNbIDxPbIZKhQy1lRA9Kq0FxDO5khc/Hm6l
   fx38Ws7FYSE33TwXDWqTUIUDKObXRyzZQgTyFnyiPctWH9kqhMwJdamdjecfUWzPSdrJWxlDG0//
   e8RcmeHuvJCXQH04RTPyT1a41A+F4fu6RULsBQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROA00LCBVAA6T40@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 11 Jan 2023 02:37:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=njrrmruQDIC0in34qwfwYVLn81yNCbta3wj2UCVqMgs=; b=nh0gZtN2mPu3w5awxIzCHyCM0m
 VL7XTrWSWP/T3pXS1JaWh6hTp9KvW6KHDhtX2kyiA8TwA81F6Pqp6MN5fkdOW8mYBgv4PdAWlhPV5
 HO78Fcczxdyq35HLxMLDtwOodiZ2yh6krPSU706FcQ7hzKU0gDz3zzYBXr4hSNnWGOVbwrT1cmA6r
 h5aEO9JLRpDpneToikJt11IFS/KVgwbXQlCgNlO11DGxO0Y2XrcTxJzCJg+0AhCT1uzgmJS00241D
 6QuZTgwjKcGVUzNQkX9fB3CfMoLRZ8ZIWrKz6eEqMFO7wlHlPvRp3Rsm1EAfnwwOVh84wSPT+W1vT
 xRc2VA1g==;
Date: Wed, 11 Jan 2023 02:12:30 +0000
To: Jeff Layton <jlayton@kernel.org>
Message-id: <Y74bDlSiEb2dRFSx@ZenIV>
References: <20230105211937.1572384-1-jlayton@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230105211937.1572384-1-jlayton@kernel.org>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10586
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxlogscore=999 clxscore=102 lowpriorityscore=0 malwarescore=0 phishscore=0
 mlxscore=0 priorityscore=156 spamscore=0 impostorscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301110014
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 Martin Brandenburg <martin@omnibond.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 linux-xfs@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 linux-cifs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Russell King <linux@armlinux.org.uk>,
 linux-afs@lists.infradead.org, cluster-devel@redhat.com,
 Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, devel@lists.orangefs.org,
 Shyam Prasad N <sprasad@microsoft.com>,
 Eric Van Hensbergen <ericvh@gmail.com>, linux-nfs@vger.kernel.org,
 Tom Talpey <tom@talpey.com>, linux-fsdevel@vger.kernel.org,
 ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 linux-arm-kernel@lists.infradead.org, Christian Brauner <brauner@kernel.org>,
 Paulo Alcantara <pc@cjr.nz>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
 Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Chuck Lever <chuck.lever@oracle.com>, ocfs2-devel@oss.oracle.com,
 Anna Schumaker <anna@kernel.org>, Bob Peterson <rpeterso@redhat.com>,
 Steve French <stfrench@microsoft.com>
Subject: Re: [Ocfs2-devel] [PATCH v2] filelock: move file locking definitions
 to separate header file
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: XApzEcwMt6P-E3procTsYePyDBYtRDuo
X-Proofpoint-GUID: XApzEcwMt6P-E3procTsYePyDBYtRDuo
X-Mailman-Approved-At: Wed, 11 Jan 2023 02:37:20 +0000
Reporting-Meta:
 AAFkFsCnDP+7uI/3BTjmHG6stlEkEjkn9DR78+kok5LLjKYszsXa1OO3iAXNUSV5
 A3vzw+fKEBmGOKbNMDu8Fmc0tDXaluqr2iKkp/gREvTdJZM3B6fgW+U4maoATpiP
 XIrwnsKwsgP8CwxmlVFBelJRoWy6c/hQDa5DEZC7RKooCbsYtGvFdIXForhSqy8G
 Ra1KOrlo+jBbRDN6b52/O7DTYqP7h5y9T0yN+rfs2PAslWlnOqidUv5QBtzvvmhN
 UcYEBEBiXQYOgMyS1o8fZ4TOnm6Qgwi4yXE06jKqOBB7rjOBmDlCkR8Bp/q5bhJG
 NYllPIRppdXQbYdLwwSOvUWhZqfcO8622aoPF8dRYKVEHTG366iagqVVdUii9yk+
 qx6jXZ+bSSV1rhTExP6XY6G3gZk/4dy+yA9ZWXngWBSM/CwzHPnb9M7Z6AK5YliG
 1+bkPH/HDOlSODLYkdm9heCRPbZjmSVaJzHcVly7OCQrVL+5PyKSNpRJJZflsYbI
 2tHyWgaHCOsrX1WSh1LWkwtTcxeUXZTMmoxU1a0Vgy4=

On Thu, Jan 05, 2023 at 04:19:29PM -0500, Jeff Layton wrote:
> The file locking definitions have lived in fs.h since the dawn of time,
> but they are only used by a small subset of the source files that
> include it.
> 
> Move the file locking definitions to a new header file, and add the
> appropriate #include directives to the source files that need them. By
> doing this we trim down fs.h a bit and limit the amount of rebuilding
> that has to be done when we make changes to the file locking APIs.
> 
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Acked-by: Chuck Lever <chuck.lever@oracle.com>
> Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Acked-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Same question re git tree preferences (and my Acked-by in any case)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
