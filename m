Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3EB3C7EE2D
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 13:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Xo1zUCzs4CqZiRYn368awJTl/1S9IWTgxoucezWS+no=;
 b=F1flwRY9bRTYiYGdc6tiBahE6wcxqM16L1QggySsMw+/xB6Sg0mdwRwWoEN7tYHtepDaDC1BDx9L
   fWFHvncYgPRGMTa3yH/s+wHYcNdMnbguJ1NWFFg6KqKOMQoLldHGRf1dwrTy+ImZjTRUpxxEkvi2
   sxaTCdAHVUI1l2Q1RWRm/2/pW0nj6SH9eUPUAGPLr8iDkrnGbkm9M+m/Vky3QBEeTxA5lKSQlK9l
   xcHGNRMCkLLu+m9Z+iuKzdTHi9IZYTJ/7l1EXmyr2C+jh20NzuPmdcot4oQ3i5H0foQA+4lHSaqY
   QElfUTPjAbCH3EZ1/OQxdzeUTaLK8ANq7+e3Lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Xo1zUCzs4CqZiRYn368awJTl/1S9IWTgxoucezWS+no=;
 b=hs14KiwaDRRxesjPpftnAIXPP7z9MPcKzpc3QFe4h1heA35fhsvKMNjtUCZvaZgb61yB/Mj45/cs
   Pm+Mx9jOJQdyYpdRDsRfsq37yEvUnMbmrq3NhaFXqSvCSAtRQslK041/sV22LH+7nGmcz4dBabJM
   BhvLyq/BDTnJY85ww8j4ERl9YIXj7g/21U8kkuPHtSYNlUpPEZNgZtemYVacvC+l3BM2Bfgp1MTB
   /1kQNtPMMo+piH6U5DE5u5tfDvTw2WYpeJplIXxEVJY29oBd+YT0eFubPPof74Oc1YzddCd2Qi9P
   A7BJm5vxXbLmwFWpWnb3JSIlEAG0VAL/RNlzVg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV2001IHBV04X90@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 13:52:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1684763517;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WTfdYshb2SEJ7i+Rhr+GK9rq0gZ3nIJZ8Q96oyv400s=;
 b=QMHnWkdwmwUVxtTZB25jYyJZKx1awXcN7jAmxLn71JU7e3UOpr4eF7v9uC7ngYXxzOTJJd
 qr6o9hChgXuegRMsu6N2DN5DE3KBq/wVGjjUUClrh38h+G3mnaxeIP3HIKe1Pt6nOzTcxa
 6aEk0Bs5RwfWUfFCEEuoTfQg4vuk97c=
To: Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
 Christoph Hellwig <hch@infradead.org>
Date: Mon, 22 May 2023 14:50:09 +0100
Message-id: <20230522135018.2742245-23-dhowells@redhat.com>
In-reply-to: <20230522135018.2742245-1-dhowells@redhat.com>
References: <20230522135018.2742245-1-dhowells@redhat.com>
MIME-version: 1.0
X-Source-IP: 170.10.133.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10718
 signatures=596816
Cc: linux-block@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
 Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
 linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
 linux-mm@kvack.org, Jason Gunthorpe <jgg@nvidia.com>,
 linux-fsdevel@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v22 22/31] ocfs2: Provide a splice-read wrapper
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
X-MC-Unique: VqXNS97OMu6rkAXf15s6Mg-1
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
X-Proofpoint-GUID: K7_aQkBDi7SCFGsaNwZl9a95yVudGfNh
X-Proofpoint-ORIG-GUID: K7_aQkBDi7SCFGsaNwZl9a95yVudGfNh
Reporting-Meta:
 AAFgYGu87AHz3u15KOOp/DPy7dFbegP5rHfvXADYoIrbQkcgm+vYDObgVVqmM8ql
 D0nkEzwGgssAbbJ2eUR587SAZbAeFuyBEIthKvDbvRz8mIDWGnTakN6MH9flzSH+
 Nc9k08Mnvyf9GEhYLFzDwGsPDgBR7KXIYcRGD1IvrQB+76zA7Fb4PQD89BbLff4V
 sWBiUP+8E87VszQlL7I592ipExckNxoJX7bOdW8c9iXQtf+Esaz/3kScZTBnSc9Z
 XJUSEb/fL9mu5Fqlpx8Cb0oQ6OmB2Y9/CWo8uXe2H2DYqNMa1p+hKX4SNYXUkSQl
 nCYy+Yjvdd7m8EjZT5WcYvQwyD6THGERM60alFcMQ2a+O0NjCiXX4+NiHXxu1+lj
 SpDtm/FH0z/xHFSrW+oIZZThCm/ubO173gzAlnmalmET1ZRNpavozj/rZ4g5ngtu
 EjT9zGoPGbjwbfCcje+h6WU6RTlqCIip5+kUELJoZcUU/PROmt4wPUAiTPMN9d0p
 1IR6N5CJCnRTHTin0JP1rAolAhe0jpu8WCrHc7Gfkzg=

Provide a splice_read wrapper for ocfs2.  This emits trace lines and does
an atime lock/update before calling filemap_splice_read().  Splicing from
direct I/O is handled by the caller.

A couple of new tracepoints are added for this purpose.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: Jens Axboe <axboe@kernel.dk>
cc: Mark Fasheh <mark@fasheh.com>
cc: Joel Becker <jlbec@evilplan.org>
cc: ocfs2-devel@oss.oracle.com
cc: linux-fsdevel@vger.kernel.org
cc: linux-block@vger.kernel.org
cc: linux-mm@kvack.org
---

Notes:
    ver #22:
     - Adjust a couple of comments mentioning generic_file_splice_read().
     - Pass 1 to ocfs2_inode_lock_atomic() rather than true.
     - Pass the splice flags into the tracepoint.

 fs/ocfs2/file.c        | 41 +++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/ocfs2_trace.h |  3 +++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index efb09de4343d..86add13b5f23 100644
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
+				     flags);
+
+	/*
+	 * We're fine letting folks race truncates and extending writes with
+	 * read across the cluster, just like they can locally.  Hence no
+	 * rw_lock during read.
+	 *
+	 * Take and drop the meta data lock to update inode fields like i_size.
+	 * This allows the checks down below filemap_splice_read() a chance of
+	 * actually working.
+	 */
+	ret = ocfs2_inode_lock_atime(inode, in->f_path.mnt, &lock_level, 1);
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
