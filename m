Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 937E7C77B75
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 06:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UCPkJtNcc0WaC4aHFdBXD6lNk5KXcHg2UnX6ATgl9iY=;
 b=E9SKs7Xq0yBSVOoVbzlY78LUzZwrbO3CLF1xUpDjUHc8aGOrJDVzoMdccZwypLq0b+icUfPMDsu7
   lUfTEjRb9TIgewRuSFrqUs5CEO+HSolMwt+ZfXIcFXDeQ1L3rTql/3exr0vLUbNxqgaHHQlZBTCk
   Axty9EhJ3cMX2zfb8VyOoAcNd8j1rU3iFzc0BFbEQTKLrKdLIUiPLYMV5RVkZcdAdFS9ixQzpX/0
   dN11XkcPFyDrtsBU/KdRiLp6D8Ypdb3CaVnuRyTkg2JrLbndu+4rCLwM5k5pOjTRJDgJ+61MjiVP
   Oxo017Hc/bLThCZ+VRFJHskaw2xk3ap/ctU9hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UCPkJtNcc0WaC4aHFdBXD6lNk5KXcHg2UnX6ATgl9iY=;
 b=sy8kUMbjbqbm+xldYoY7mJej+4d+YnFFAA89BvXHMuapZXlSXQhMDl4d2mDVKDdEniW8b7gbW/aI
   GOcocyydWdamtijTJrJ2ecvck2WL88HqLnUHazYnjt5lXg0kCn5mxIGdsSDMaGcs07ISWE640fXv
   whftgOrcOZlsDRlM4SfULs4upo5bf0IxeCKI89O+zw1KKpDxsiBp+/SoVwSqBRoamE0EQDm3uS66
   xsSQW5Jkse88hzVtfqSs311nhL8G/4t3IJz1WrARrf3LYcQSJaopJo0Tz1vWc52f3f7gW8ApDhVy
   9UvcZyrOiBt+v8zMn6Yo8EwxjG9mfeTO2Swhpg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV100G1VSBZ0330@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 06:50:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1684738207;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WPmCmuYomWuJ+5LnnTa+OzAzhut1gbOGrEeSAMZunF8=;
 b=CWrDah1vZkK2RElMzQ8HGZ8pFlka9iIkndfmLfSXBmsblLA3QlbbwPJB68YMAkR/RwXGHt
 HVGCTi/mMfJUUsC2vrx4CQC61y/3ROHP3LP/inxj5GYWbEhIrGPB7/Xj8yQs+8PjDqqdR7
 QLR5Ej+A1RgW3lAWgCLPnxR+Z6zY9xQ=
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd,
 Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE,
 United Kingdom. Registered in England and Wales under Company Registration No.
 3798903
In-reply-to: <376ab23b-52d0-d7fd-2dd9-414cbb474e01@linux.alibaba.com>
References: <376ab23b-52d0-d7fd-2dd9-414cbb474e01@linux.alibaba.com>
 <20230520000049.2226926-1-dhowells@redhat.com>
 <20230520000049.2226926-23-dhowells@redhat.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
MIME-version: 1.0
Content-id: <2414054.1684738198.1@warthog.procyon.org.uk>
Date: Mon, 22 May 2023 07:49:58 +0100
Message-id: <2414055.1684738198@warthog.procyon.org.uk>
X-Source-IP: 170.10.133.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Hillf Danton <hdanton@sina.com>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
 linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-mm@kvack.org,
 linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 Jason Gunthorpe <jgg@nvidia.com>, linux-fsdevel@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v21 22/30] ocfs2: Provide a splice-read	stub
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
X-MC-Unique: o3bjNUnbPDuBiGmpC7NUHw-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
X-Proofpoint-ORIG-GUID: 2MNlCpvz_C3dYAFVP6k9dEapa6Zfs20i
X-Proofpoint-GUID: 2MNlCpvz_C3dYAFVP6k9dEapa6Zfs20i
Reporting-Meta:
 AAGUj3COowqebw2yTbfa9nE5GJ34TPxGOdYBqHxpocgNadvqJZNNh62yOQbD4mmj
 Aq36wDb0Rkdg0HHTAgX/RFKrYbnEeWJHgL2OJd+xNyyaDj03WXvZaIu5wNg8ZcKf
 UujDOaWBDr2cxOQHLy3HJ71pcAq/uRzPI3sMjtbkrn5E0TuH6j0GSHQlP3GQodLN
 i2InTCSg7RfsxiqQn0qQAtap/aiTSfYfs88/DJzPDs1WzoUFEWzgJ0i913Xe4HAP
 1e9QqwIlufTlWzwmQOjmHQFWRbJtxVLPI+9ubaegIhrH0SocKhbUvEzbCVRXc6Xi
 zIqbwC8MAup88XYfyFAMvvbJTLGFvP0012tdaaMPnjtX5+7JGeegCz/KgQm8gN9z
 NgbmQMPN8u87JibOQM9p280c3P29OTsa5GCQGHRySuj6iLpe+sRzES3427/6LW7k
 qShUDHJzR75Z5K8qj+2q8+guKNE8ugVrXokk8eY5i9paSrQYkLSPPgu55TyDBR41
 kdUyN4oRTtJ/45IDedhXW7CP8veFRcMZTOWj58pvJx9I

So something like the attached changes?  Any suggestions as to how to improve
the comments?

David
---
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index f7e00b5689d5..86add13b5f23 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2552,7 +2552,7 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	 *
 	 * Take and drop the meta data lock to update inode fields
 	 * like i_size. This allows the checks down below
-	 * generic_file_read_iter() a chance of actually working.
+	 * copy_splice_read() a chance of actually working.
 	 */
 	ret = ocfs2_inode_lock_atime(inode, filp->f_path.mnt, &lock_level,
 				     !nowait);
@@ -2593,7 +2593,7 @@ static ssize_t ocfs2_file_splice_read(struct file *in, loff_t *ppos,
 				     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 				     in->f_path.dentry->d_name.len,
 				     in->f_path.dentry->d_name.name,
-				     0);
+				     flags);
 
 	/*
 	 * We're fine letting folks race truncates and extending writes with
@@ -2601,10 +2601,10 @@ static ssize_t ocfs2_file_splice_read(struct file *in, loff_t *ppos,
 	 * rw_lock during read.
 	 *
 	 * Take and drop the meta data lock to update inode fields like i_size.
-	 * This allows the checks down below generic_file_splice_read() a
-	 * chance of actually working.
+	 * This allows the checks down below filemap_splice_read() a chance of
+	 * actually working.
 	 */
-	ret = ocfs2_inode_lock_atime(inode, in->f_path.mnt, &lock_level, true);
+	ret = ocfs2_inode_lock_atime(inode, in->f_path.mnt, &lock_level, 1);
 	if (ret < 0) {
 		if (ret != -EAGAIN)
 			mlog_errno(ret);


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
