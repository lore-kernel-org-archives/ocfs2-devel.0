Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2F5C4708A
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fqzmqE/+lHLSdJqOtU67w7M1pbQyyueVUOWQqmFOc6o=;
 b=XVdotvPxsQCttVvEuVkZQ3/Er+hytZpZmR31ulyGYANYRZ6nwBMk+IhoZH5ptOD2spGXPugMOWk/
   EcDZwzuZaf4YRlaaHLslQko6x03t4yhpZy9unlaXYKlzQbWQpMt2X95utRQOSB/PO5BzqCwXMiDE
   uBnFftT+layBkVH5cN4gvwUVmzEyaTKRnCjdk/hZLOig/SNQkxzQ3jraTNHum07j9OAdZ2s77T2m
   cJ26i7WoFB9TgC1K71npxjvES45Xn92cf1yxMGylFn8Ny8nXpk2zE4m/cPwdNZ482IbyXtTw6tXc
   VKhFSRcrzKWadFD38MuLIqxQOqp6JWIRrCnnIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fqzmqE/+lHLSdJqOtU67w7M1pbQyyueVUOWQqmFOc6o=;
 b=FAux3lNbfdEiwLoth4axM9BkjnkhruBX3uKZqUVloTU57KcifFinMyR1CqMVSWCcCCkzBRu+6tyx
   jwu5cHHYxbxfdM1WtoBKJqJtcrOzOWVakqUgzOkHuiIi4Ww5unk/x/TaVed2tgEPLfMSrAG4ZAJw
   N+l35d0mau/o8bpg3d+KdLrL1XOhQNemUYxlMXwFULOO46GZ0W8YakK8aFZ5oBgiyli5omcHVtGQ
   Bz9baW8jxO0bpGH9m8r6rng0ROklpQBQBaN/CDZyoEph0mUguFkzsRlpKE7oTc+wOJF+A/+V8prD
   pq5M+YLZxSB6v8xpaUwShXgZS6MmQQ9n5Nn+yg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00DURVYY5J00@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1669044675;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=43gjeh12mqeKKnzpxBrG6XHUmQQh+jBPDZXXmUO7BOQ=;
 b=GBhwVYuUzMSa7xAE/WLKSkgfCC286b/oxxLexePjvz/kkxlq2jNPNii1xQrE5xaqbIoazv
 76wpU5T2Qcy9qoVPdVVOjkm8KA2EZrlpvQapD9WY4b1OhthrFuw9ziC5KuHVGQir75lJNp
 +7RFd/CVaiaGEBq/m3cpgD5CQ8Xh2sU=
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd,
 Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE,
 United Kingdom. Registered in England and Wales under Company Registration No.
 3798903
In-reply-to: <20221120210004.381842-1-jlayton@kernel.org>
References: <20221120210004.381842-1-jlayton@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
MIME-version: 1.0
Content-id: <416909.1669044663.1@warthog.procyon.org.uk>
Date: Mon, 21 Nov 2022 15:31:03 +0000
Message-id: <416910.1669044663@warthog.procyon.org.uk>
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 Martin Brandenburg <martin@omnibond.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, dhowells@redhat.com,
 Marc Dionne <marc.dionne@auristor.com>, linux-xfs@vger.kernel.org,
 Mike Marshall <hubcap@omnibond.com>, linux-cifs@vger.kernel.org,
 Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
 linux-afs@lists.infradead.org, cluster-devel@redhat.com,
 Christine Caulfield <ccaulfie@redhat.com>,
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
Subject: Re: [Ocfs2-devel] [PATCH] filelock: move file locking definitions	to
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
From: David Howells via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: David Howells <dhowells@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: iFy62VxxOjCf3yA5uhfvsQ-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
X-Proofpoint-ORIG-GUID: XEvJAxaaWHRRmE3Z_MnAIovr0HRiFtsU
X-Proofpoint-GUID: XEvJAxaaWHRRmE3Z_MnAIovr0HRiFtsU
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAG9ofe1uZIzVLY/EytApz2OUm7+LKfPS4LFKD4SDn1V3O72SA9QzodZjPockSLj
 fgAIglvVGfYPw8v2GDQmX4/lMIqtgtu7dzhaT77zjr1/8f2pJE4W+Enlu5Y09pUT
 LmJeEgJCvf0Y0J3ZsYWkk5uY7vULOha/NSGlKFESCCeTU2InONvUaRE4CjwJDzV1
 DzWZEdP/u6nKYY6m8SXo610y/aLwhURCXSpQP9IsbeI9zDa8o1GuOBSKO0vsKbD9
 4p394KxcUb5UEtcdAw+6wafXd5rwIyE9TxHZg3r5aG6mURzZuc+GSbzqhwxmqEDz
 eiQ/hDHQ8oMQriDmLofGTUnCtuvpD9b4vwzVDBH0RXwlE2coZ/82O1jrxjyHHRmF
 0+Zpa7Iqv9QgPmwdPpTF0/DmxX391jnT7EfjFM26NzMJYYWKI3CRJD6tj/iHY59i
 fdHBDDigvd29JO2QUcSO/rGjA7+kFtkplxyFiRbxSxOWrrSK8t9KICDpSR+0oPdS
 g82XAzfPHj2m4k9cz6ljrTGNbUkTU8H61ZV6vwlS+Zxg

Jeff Layton <jlayton@kernel.org> wrote:

> The file locking definitions have lived in fs.h since the dawn of time,
> but they are only used by a small subset of the source files that
> include it.
> 
> Move the file locking definitions to a new header file, and add the
> appropriate #include directives to the source files that need them. By
> doing this we trim down fs.h a bit and limit the amount of rebuilding
> that has to be done when we make changes to the file locking APIs.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Reviewed-by: David Howells <dhowells@redhat.com>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
