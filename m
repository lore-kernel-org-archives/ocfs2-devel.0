Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 379EBC77B7A
	for <ocfs2-devel@archiver.kernel.org>; Sat, 20 May 2023 00:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JXhO1W/IcyL+NU8uWcY7ybCb0WdzfmjnLZ7xBeWbQ3U=;
 b=J6kDBX5EDkMsFYVTsC2ZguioH0xCtlGeDMdr/IRXMO8/05vGLK5H5GOi+8WFRy9ipWHpBOPMLb6T
   GBxavEj+BmoxaYe0YkwZrcJwipAxGE2YjtSrX2p5P/28bsZdvUL8cBcNjYS6kXB3t5Cpw5beuEG+
   NQEKzak0gN51x6KjJsgnSPQvgRn6Crm34hHdSXVKdzzFi3Bfq+g+hYBBBglOYqM28Cu1fm1htInS
   EHd09evAon7nFInAZVyca0l9I0VxLSouklEZPgRV0DA1/hKWiub1F+wqV3+p32WbC0dtF1XHdFYY
   WqAVhmDchnAZsr2PEYdrIVK3euFkM2RVBi2PJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JXhO1W/IcyL+NU8uWcY7ybCb0WdzfmjnLZ7xBeWbQ3U=;
 b=Jt8UEUQMn6v6jmSamwxAy/5pBaM0HWzKkobSeTYninlZzqdCl2Io1jTRUVIg1zozH/w9AgOhnDi1
   Ceh0Vhle7Pg8wqwYg8iIP2RWXl/VC+Zh3SRig8rm/hX21GzsWCL5NzTPtx1BCbvaklGhGJBieru8
   CzHqVl3Zw713zlZ4mcEKUsfCHP7uk6NPnVekXmwCH+0SuZkItzQKghDWxPMnoto79csNzAuChmFV
   0eK7QBleOcS+FGQAT3vBr12FCpgPkbEFdfZ5eVBehi6VthOOGpc5lGKe+uOxiRgQIkKZ7LRYpoi2
   IvnD3Daiwni0/mPKYNl/x2yj2KaeTT+6y8pveQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RUX00O2KK42AZ20@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 20 May 2023 00:02:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1684540933;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+ZeMoJ3W4+8Si0O+3M8rAaXW1eupuLZDs/fqA89KAPE=;
 b=Zol/mVEiDADTmjnfvCryYdUK9m3cV8zkVhiISKvYPoxCCt5aEAhVKGvqH4VBIxdRNIMagn
 LluxyngyAytUhCXX66J4QwrAv7OP6iIK+GHJaGEl5doiwUzg5OioA8PDZx6417OgTgtCYF
 jdokBsNAvQV2N4TGcn3Tbwp6ZVPpFjA=
To: Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
 Christoph Hellwig <hch@infradead.org>
Date: Sat, 20 May 2023 01:00:41 +0100
Message-id: <20230520000049.2226926-23-dhowells@redhat.com>
In-reply-to: <20230520000049.2226926-1-dhowells@redhat.com>
References: <20230520000049.2226926-1-dhowells@redhat.com>
MIME-version: 1.0
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10715
 signatures=596816
Cc: linux-block@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
 Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
 linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
 linux-mm@kvack.org, Jason Gunthorpe <jgg@nvidia.com>,
 linux-fsdevel@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v21 22/30] ocfs2: Provide a splice-read stub
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
X-MC-Unique: v3noG5lZOjuaP3G1f6efug-1
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
X-Proofpoint-ORIG-GUID: gMCNHyyLNtPygDH1XunTqn3fz0LDhcW7
X-Proofpoint-GUID: gMCNHyyLNtPygDH1XunTqn3fz0LDhcW7
Reporting-Meta:
 AAETPw+tDF0ZLzihQf1b+cSK1bjN/GUPxujHv2YxZH6NqSjbTe/D7cdAzGPxIHRI
 bBygmSzPC0tqP0YerV6ECN9Xo7URG5LMGyy36fjsH4egkIh41P7507bCHxxmqt43
 3vwLu5wrhRgSN4ulhDB2Eb1myihbw9v2xKZXcuWMouIumJOBNXaT3KqM8ZXW5bOa
 NY3K0tnt9MEz+vCo0oESpoSNEM0yr/BnwMAJhiwbjdw6ZCn6Vrf+JM8b14evLeFJ
 7bRrOVDfqQyhG1PmPcO6O7ONrFXldACYaaNqGVHvTBSrapBXgWcnoDoLhMPbv8zH
 0VIO/GBIbMshIY8Tc5B5gFlDipsL+kKnJhH5a70y22XkxvHCLhg9vo/tDnTenfxj
 dxH8Ty2XOzL+/5mrWzPjg+XaGZ0By5TL774Pzw5jBObLjpcD9w4ddE7+V2OiDhqS
 DukTcjkDV4wqFfwAvGD2sFIQAgx29BLU1yKRPA4QLP3A8xfcYsz73eIv1fawpj8r
 ZuQ1oVy7HlIPEvCO8G6wHY8Dbdlaw2h6c/XqmPq/JELt+Q==

Provide a splice_read stub for ocfs2.  This emits trace lines and does an
atime lock/update before calling filemap_splice_read().  Splicing from
direct I/O is handled by the caller.

A couple of new tracepoints are added for this purpose.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: Jens Axboe <axboe@kernel.dk>
cc: Mark Fasheh <mark@fasheh.com>
cc: Joel Becker <jlbec@evilplan.org>
cc: Joseph Qi <joseph.qi@linux.alibaba.com>
cc: ocfs2-devel@oss.oracle.com
cc: linux-fsdevel@vger.kernel.org
cc: linux-block@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/ocfs2/file.c        | 39 ++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/ocfs2_trace.h |  3 +++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index efb09de4343d..f7e00b5689d5 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2581,6 +2581,43 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	return ret;
 }
 
+static ssize_t ocfs2_file_splice_read(struct file *in, loff_t *ppos,
+				      struct pipe_inode_info *pipe,
+				      size_t len, unsigned int flags)
+{
+	struct inode *inode = file_inode(in);
+	ssize_t ret = 0;
+	int lock_level = 0;
+
+	trace_ocfs2_file_splice_read(inode, in, in->f_path.dentry,
+				     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				     in->f_path.dentry->d_name.len,
+				     in->f_path.dentry->d_name.name,
+				     0);
+
+	/*
+	 * We're fine letting folks race truncates and extending writes with
+	 * read across the cluster, just like they can locally.  Hence no
+	 * rw_lock during read.
+	 *
+	 * Take and drop the meta data lock to update inode fields like i_size.
+	 * This allows the checks down below generic_file_splice_read() a
+	 * chance of actually working.
+	 */
+	ret = ocfs2_inode_lock_atime(inode, in->f_path.mnt, &lock_level, true);
+	if (ret < 0) {
+		if (ret != -EAGAIN)
+			mlog_errno(ret);
+		goto bail;
+	}
+	ocfs2_inode_unlock(inode, lock_level);
+
+	ret = filemap_splice_read(in, ppos, pipe, len, flags);
+	trace_filemap_splice_read_ret(ret);
+bail:
+	return ret;
+}
+
 /* Refer generic_file_llseek_unlocked() */
 static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
 {
@@ -2744,7 +2781,7 @@ const struct file_operations ocfs2_fops = {
 #endif
 	.lock		= ocfs2_lock,
 	.flock		= ocfs2_flock,
-	.splice_read	= generic_file_splice_read,
+	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ocfs2_fallocate,
 	.remap_file_range = ocfs2_remap_file_range,
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index dc4bce1649c1..b8c3d1702076 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1319,6 +1319,8 @@ DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_write);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_read_iter);
 
+DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_read);
+
 DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_truncate_file);
 
 DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_truncate_file_error);
@@ -1470,6 +1472,7 @@ TRACE_EVENT(ocfs2_prepare_inode_for_write,
 );
 
 DEFINE_OCFS2_INT_EVENT(generic_file_read_iter_ret);
+DEFINE_OCFS2_INT_EVENT(filemap_splice_read_ret);
 
 /* End of trace events for fs/ocfs2/file.c. */
 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
