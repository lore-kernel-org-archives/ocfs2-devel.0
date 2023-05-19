Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61688C7EE2A
	for <ocfs2-devel@archiver.kernel.org>; Fri, 19 May 2023 07:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4VnJbSJrHwfB2a97XUKGU897lluoEBK7B8KPJl6IGN4=;
 b=ma/G/hBUNgWzHyl5+gpxZhXPaC9p3566q9oQe+6bI25tSsIxY/PlvK5jViqt0lBoeOnvnsbWMJdy
   nDYWQe3BnNw0+BDvQcGHiMNM5OtgzCapfQ7cQg1Sz3NLX6sDd8A8mefOs1WvuUUW2i8vRBrrJZ31
   /HPoQH6/uN0bZb2rg6f4nZG1ugxfj1s4t8B2Lh9NbuWUnrGV0UIiGUEaJUJjqbDzRjdZ7TutabU7
   c3bXLJA29fP0LnwmazcSPS5ZoarNzM9YAq6reoSG8xyCM6Rac6aZxUVmeOsyf1Mu32mxkLyT8vbn
   FAnSAU5+IfqQkrA/rtRRPc1yOXz2B0tzJd51hQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4VnJbSJrHwfB2a97XUKGU897lluoEBK7B8KPJl6IGN4=;
 b=daX1n1mfNTRLCd21ivZwzsr2kJbYUN6c4UqzXNAQzASU3wTywFjeyAwR1RFe2tMAgafut0tvvUEA
   SwXHpnGoFvFzvd1vsZ1JB0w+Eb4qadv2xHmyiq0PtReZZ4Ck1kS6Iw4etzFsIDfiSCZ3o/fcIHAX
   dPVcOiJ+VYqXINelNtC/i172XgvNXfjQoofQBipQZy7xH0/VbhLjjrOnePCMz9Uj5vkv/EF5rHLh
   uz0RjhEU3IWVdRsrXk8218Ng6wuCUwXyFaPjpQqlnqBcdf4nA6zbNM1gRoUe5ofsJFNKk7311Amr
   jE2ARr6o2JUZFEQ/UfwndLc3Ah6jrC5irrkdDQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RUW002CKAQVF000@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 19 May 2023 07:42:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1684482137;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gBG1rbAQ+/pvrFxoUU2GMJeglrqrT3cq++hcE5SQo7w=;
 b=auxAEAlwthRjC6xSIlM/ZpgRq1TpplkHsMleVoLeA5Lg2NvLq90AmP7LWovhBuNss6Mt7S
 Jv+nPgQDe9H0mBZdEro8Y+m8m11EmF4gyesoAE/IPX8Rg/M0MIUmoqD28s81HJPKPUbU3H
 wBj41jSAHZ7/wxBTMCK/xgBHkG9wjy0=
To: Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
 Christoph Hellwig <hch@infradead.org>
Date: Fri, 19 May 2023 08:40:34 +0100
Message-id: <20230519074047.1739879-20-dhowells@redhat.com>
In-reply-to: <20230519074047.1739879-1-dhowells@redhat.com>
References: <20230519074047.1739879-1-dhowells@redhat.com>
MIME-version: 1.0
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10714
 signatures=596816
Cc: linux-block@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
 Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
 linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
 linux-mm@kvack.org, Jason Gunthorpe <jgg@nvidia.com>,
 linux-fsdevel@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v20 19/32] ocfs2: Provide a splice-read stub
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
X-MC-Unique: _MfV9O_bPYGXDbkMXz1GRA-1
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
X-Proofpoint-GUID: GMc6dxZ_WYH7kwQ6BCbdKD4fJidG9Pui
X-Proofpoint-ORIG-GUID: GMc6dxZ_WYH7kwQ6BCbdKD4fJidG9Pui
Reporting-Meta:
 AAGutpx60ATFMUzML5N7XTojKm8RLyTyyFWfQrm2F9s+eycjqRukLdsyL2U8rJ56
 Ykv0sUhj4o15fOjwdm2BFTvfOyqZrVW2MJ89CO5QBkvjg8LXGDVjxf7/OLQXmaQc
 VPnCCxHZ4xhOOj1mzZ0ycvX4Q442pcnlbt9r1B1xjz2buM2sGXrxybhezuMoIx+A
 qhDNSbZtoQhOzq78+R8zjrUkXNiuAMKjk2nsSUOo7vdV8MnTCd78bI0H2KzZsZro
 Wbzdltr+j0kWswqItY7MPmKD5rCflBncwtPKHw6gzupj6oekLVIGL8IohBsm9TQS
 OqqDlF3V+voZiFpHOlVHcpKc61YsfC2gaEsD34bc6Ssnv1g2j+UMzambUdaCjoQ1
 1ScDjCq+StiL+srFyRkuVAvYQhlQP6VENaQ0bAs2ATxoXfED95FQOltlKnbK3zSz
 zjaSsJGWM6sobdAfEXSfFoUtdelMezGC24BFOIE4Zw6C1mZGiiaNMI99xEkGq6Zo
 dDcx5S8BME6bfXMqH9491d11GJhBMSW7MPa+FtP+lL0=

Provide a splice_read stub for ocfs2.  This emits trace lines and does an
atime lock/update before calling filemap_splice_read().  It doesn't do this
for around direct_splice_read() as that will call ->read_iter().

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
 fs/ocfs2/file.c        | 42 +++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/ocfs2_trace.h |  3 +++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index efb09de4343d..27c54a71ec57 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2581,6 +2581,46 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
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
+	if (in->f_flags & O_DIRECT)
+		return direct_splice_read(in, ppos, pipe, len, flags);
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
@@ -2744,7 +2784,7 @@ const struct file_operations ocfs2_fops = {
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
