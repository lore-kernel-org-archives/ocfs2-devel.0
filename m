Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7FDAC63709
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7Y2Ic2k3cSrvqq6VD+sL7fDpJJgWqjPlrCnju+G5TK8=;
 b=Z/X6BcelwSi/Brd/qXv36zW4JuVNOCZl/sgMCBJPueA2fvVsLsGzZLGwWU5hHpRnadJGFbwMgVOg
   Jn+T4eZ5DFDFWF05tS+PTkty0nfiKSsibx7sIaowRZFuxXI99xNMC/uluAQyej8BfW/5wt6poJh+
   b4cqxsT6AxBAKO3B9cp1WIDIYqqIu5SfRI3jEd8rVySQfeYMFk8R0hRvqp8xfcGGD9ycdLgBbch2
   NoxqZoMR4SKHGtheWBHgOZ79XWj/eg0wjWeauqkej9aXAvIGD8Zm4stZpZmoWOgHo4HyvOvjTWjc
   spILwk9pBL8NO6PoWx+9V6n56UGbFfYNN73a1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7Y2Ic2k3cSrvqq6VD+sL7fDpJJgWqjPlrCnju+G5TK8=;
 b=ISVgqDSVQEHXN6h6cnC3B/Y0ejRL583e6fqlMGsxBMSrr8ExA+PZ78dj8dWEX0nIY0+iaukz+/8j
   vljr3GZ70sgV/FXZGN3V0QFZzxYjkTkBNU0NBM4pTZqkhq/Oc2IyQz7FGwiNjewjf1RfaWLavv8B
   PoiDTNfnFIu+WzYNGCjqKHNwhd+ZrL4Mlt2r5H7CmP0OS8TkX11snsCUT61MeNlu37wzhl2amUBc
   egZ/TZ0QGN+tlNixOWgcjuRoFyoMlYU+5oCzD0Q2l8VEjDUw0YWigmIJvy9HthsUC4FosGPUXgtW
   qJLYgcM7jBixI28aL3MWI36rb+5zcnq7/ftFtw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY000BGVYZLR90@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=Nf/bUURZpgL7+v01nDvViY+Mr2gn9Uq0Zv4IVJAqBIY=; b=pOnuFxI6xpMtGusD1QKOmUNaiu
 2G5WRi+pfuY2r1ILekGYfv+DmeMOEpo/9ZdfvtpgAw1Y1jnj/LcGblh8MiyfMovp8mLvKNdfUP/qI
 8R/UAAI5nVvaOQ8pSKG/rbuZ0VicxWqV4T1YGGVkt/RUglsV4NUqDoSiw0gmoccxvMxcYQ+10mgyq
 9B34ZIPM7+a/xi7vJHzDVB3NuDEFPfxL2tnCXZYEm1Px1iwHfqivbQNmLDdAhN6o8QmYRAyDENCDX
 RC3YVkPwPWNjGb/sgJLU0O4zrABPqKl4Vd/vL10iTc0IngH+XcCfs+tFpuOER1DxHIoO9jhrM1FLP
 7+QDvHAQ==;
Date: Tue, 22 Nov 2022 03:51:31 +0000
To: Jeff Layton <jlayton@kernel.org>
Message-id: <Y3xHQwM3UiD/SK0K@casper.infradead.org>
References: <20221120210004.381842-1-jlayton@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20221120210004.381842-1-jlayton@kernel.org>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 suspectscore=0 mlxlogscore=576 clxscore=112 priorityscore=223 mlxscore=0
 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220026
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
From: Matthew Wilcox via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Matthew Wilcox <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: xsiIKqZcsJlBRa7Z-xTJiYFqWPiIpTzP
X-Proofpoint-ORIG-GUID: xsiIKqZcsJlBRa7Z-xTJiYFqWPiIpTzP
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAFd/htfq0cqkEyvbEoEUFBYcxIucxInEYeBS++3RtgStN4vB3wo6b//bVRB5Nrk
 jIRS+EtjMZxO+4RHUYZ+hZsjcu4LQAEgr5P8KOgVvQ4co4IrVsLZ9j+3ZfvOyJp2
 b4R0TJZSkZIV/FOtvU8Oq40SnaknmAowVyjv+HzWKHkut4/6Qgo0OSCYB8Tf5aNk
 RZ5+/Tq8Q8d8N7mCUAcN/VVjDeEYHbDDL+NmIfdahD7YjrkAE4iXcPYa9arZkeHI
 JKhRLw78rdt1Qap00YHh/eYj6oSc+XqhO9qK9Gf48CaIleeb0eeZ7ehbtacmYvpN
 gfXWfzwk7T/cu4kyM2yvBLlNIUqjrmzyzWrLfML2p+RZ1g1Sr66diFplgI41tAgx
 4zZ4m37Fn1JF2nM9qgz0KQJ/8uc3/bCMzOhNqhUD8D75usHaq9ui0McB3B14M/f6
 pSXfpZOzIjieA0fqGPToIEAANqopVDOXNoS8El/rWS97SXuqAJ1hThdq0E4u9flM
 RbYsowmiBzRRQ4JC11GsmPl4aIwhv6db9DA+yM8RzAY=

On Sun, Nov 20, 2022 at 03:59:57PM -0500, Jeff Layton wrote:
> Move the file locking definitions to a new header file, and add the
> appropriate #include directives to the source files that need them. By
> doing this we trim down fs.h a bit and limit the amount of rebuilding
> that has to be done when we make changes to the file locking APIs.

I'm in favour of this in general, but I think there's a few implicit
includes.  Can you create a test.c that only #include
<linnux/filelock.h> and see if there's anything missing?

> +	wait_queue_head_t fl_wait;
> +	struct file *fl_file;

These two seem undefined at this point.

> +	struct fasync_struct *	fl_fasync; /* for lease break notifications */

Likewise.


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
