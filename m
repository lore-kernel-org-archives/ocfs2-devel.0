Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D6EC7EE23
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 02:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uQQh0sJR07bTFfXRdd8Klq9RZbz/I+xyo+LpEKs0Ng4=;
 b=sfo6mm8NA0Dnd2nLcScxv7QSYNIrJoOB7rMrbWPMU0Smh/UYO4VyNf85c3wzqBk7qfr8aP3aLduz
   dpQg9tLbmC60aOlvhdcehrtPjrKT0M8HppULYSuG24zsTxABWt162ujcZXTdF5xAVNgSUNY/SOOH
   Oh9y2/BQkp5PyiFXkq5sM2oNPKtHXctTb+jOUPa8QgQ4I/Y6hRw89MUDhQ4BONr2hPrGMwhFCmeg
   hEk77tlmYdZPK3/6+JwDDdvVfd8VZawX1eldJmXfp7InegjgKR7CJjNde4/M79IlgV4kI1gKoknY
   lgFoqQJdiQptdboDyx10uKmOvyWGrUKrx2+f2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uQQh0sJR07bTFfXRdd8Klq9RZbz/I+xyo+LpEKs0Ng4=;
 b=SAckOQxBYXRXsfHD3HM62NXOVaYzokeDKNWDrg4JkOJ8iuf6aPPllhSRqSg8jjO4YSFgFVy2EPR1
   nZ9yoaoaLMZviHn7jocGVmbqUzIDeD76D48kmBoGS9vo9Pw06mckfIuoq9QYOp0eL9nMOAnIyD/U
   uz26KJR3wB+ZjzfMJPqQ/r/vCq0fOgpBcUrb9stD330NiO2f86AE6cW3P1RcqJltFfpa+c99Wg7m
   Kj1GjAmIfFzbmrxqElPeN81alhhCGXxuP5/A3DL1nOt5pD/gjcQuYsJO68f8gThyKQaeQO9kflc2
   3tujKG9eShkmNSRTdn+RVBUOx9qiq/HF4P7YyA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV100D5AH75DV80@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 02:49:53 +0000 (GMT)
Message-id: <376ab23b-52d0-d7fd-2dd9-414cbb474e01@linux.alibaba.com>
Date: Mon, 22 May 2023 10:49:30 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
To: David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
References: <20230520000049.2226926-1-dhowells@redhat.com>
 <20230520000049.2226926-23-dhowells@redhat.com>
Content-language: en-US
In-reply-to: <20230520000049.2226926-23-dhowells@redhat.com>
X-Source-IP: 115.124.30.112
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 impostorscore=0 mlxscore=0 priorityscore=30 clxscore=35
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220021 domainage_hfrom=8803
Cc: Hillf Danton <hdanton@sina.com>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org,
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=21; SR=0;
 TI=SMTPD_---0Vj6edsh_1684723770;
X-ServerName: out30-112.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: xcuyEsQjfQqozT-5CWho40gA5QZjzehi
X-Proofpoint-GUID: xcuyEsQjfQqozT-5CWho40gA5QZjzehi
Reporting-Meta:
 AAG5b1eZJJvgZONJB5jurHjzzOrjFPKlS6hKND38jgtLMqD1LUYQVF1ceLKQRP04
 zRpm7DyFTyyif+zR/dcKIuZZuH4IG5Jcbv5Nwl4BRtDyhDIq13DRRya5+jbnRds5
 t6VkXeF6RfKhTFnxBugybkRNlKbW2F2q8aYQuANCGHDKf41im49J5bSiXzJhPWgv
 N/qGuKoWPRoxNoLKjd5pTLvzk22chDu4vjX/5XrZSY9No/P40YOLpHspcXGEibSN
 Tn3I3tavWKjbhxpGuZywi3GnUAxt4gbMBkEHhEW68rb9Cq9VLai+u9UK2/eEOHzU
 IY4N1O6+2Z6pfxW01Qcd4OHTmrV2NBb3eLc+NT29tXHSCHYhTipmQnomKthbNf8X
 h4D1zPCqMNRxCniOTVqmghp0iprCsCft6LFJGco8+kW+AsahSj2NvCRhlLSL4nw+
 AN1sH2ZJ2QXFlSMUCNvw7aTabZyUu8s0rdiiL1gHReL4V0+FP4sM5F7Ep/GkcctC
 GWdPnTGG6wbguEeDiC6ZisrMQoT4864XPMt69vytzx0s



On 5/20/23 8:00 AM, David Howells wrote:
> Provide a splice_read stub for ocfs2.  This emits trace lines and does an
> atime lock/update before calling filemap_splice_read().  Splicing from
> direct I/O is handled by the caller.
> 
> A couple of new tracepoints are added for this purpose.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Christoph Hellwig <hch@lst.de>
> cc: Al Viro <viro@zeniv.linux.org.uk>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Mark Fasheh <mark@fasheh.com>
> cc: Joel Becker <jlbec@evilplan.org>
> cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> cc: ocfs2-devel@oss.oracle.com
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-block@vger.kernel.org
> cc: linux-mm@kvack.org
> ---
>  fs/ocfs2/file.c        | 39 ++++++++++++++++++++++++++++++++++++++-
>  fs/ocfs2/ocfs2_trace.h |  3 +++
>  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index efb09de4343d..f7e00b5689d5 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2581,6 +2581,43 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  	return ret;
>  }
>  
> +static ssize_t ocfs2_file_splice_read(struct file *in, loff_t *ppos,
> +				      struct pipe_inode_info *pipe,
> +				      size_t len, unsigned int flags)
> +{
> +	struct inode *inode = file_inode(in);
> +	ssize_t ret = 0;
> +	int lock_level = 0;
> +
> +	trace_ocfs2_file_splice_read(inode, in, in->f_path.dentry,
> +				     (unsigned long long)OCFS2_I(inode)->ip_blkno,
> +				     in->f_path.dentry->d_name.len,
> +				     in->f_path.dentry->d_name.name,
> +				     0);

Better also trace flags here.

> +
> +	/*
> +	 * We're fine letting folks race truncates and extending writes with
> +	 * read across the cluster, just like they can locally.  Hence no
> +	 * rw_lock during read.
> +	 *
> +	 * Take and drop the meta data lock to update inode fields like i_size.
> +	 * This allows the checks down below generic_file_splice_read() a

Now it calls filemap_splice_read().

> +	 * chance of actually working.
> +	 */
> +	ret = ocfs2_inode_lock_atime(inode, in->f_path.mnt, &lock_level, true);

Since prototype is 'int wait', so directly passing '1' seems more appropriate.

> +	if (ret < 0) {
> +		if (ret != -EAGAIN)
> +			mlog_errno(ret);
> +		goto bail;
> +	}
> +	ocfs2_inode_unlock(inode, lock_level);
> +

Don't see direct IO logic now. Am I missing something?

Thanks,
Joseph

> +	ret = filemap_splice_read(in, ppos, pipe, len, flags);
> +	trace_filemap_splice_read_ret(ret);
> +bail:
> +	return ret;
> +}
> +
>  /* Refer generic_file_llseek_unlocked() */
>  static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
>  {
> @@ -2744,7 +2781,7 @@ const struct file_operations ocfs2_fops = {
>  #endif
>  	.lock		= ocfs2_lock,
>  	.flock		= ocfs2_flock,
> -	.splice_read	= generic_file_splice_read,
> +	.splice_read	= ocfs2_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= ocfs2_fallocate,
>  	.remap_file_range = ocfs2_remap_file_range,
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index dc4bce1649c1..b8c3d1702076 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -1319,6 +1319,8 @@ DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_write);
>  
>  DEFINE_OCFS2_FILE_OPS(ocfs2_file_read_iter);
>  
> +DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_read);
> +
>  DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_truncate_file);
>  
>  DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_truncate_file_error);
> @@ -1470,6 +1472,7 @@ TRACE_EVENT(ocfs2_prepare_inode_for_write,
>  );
>  
>  DEFINE_OCFS2_INT_EVENT(generic_file_read_iter_ret);
> +DEFINE_OCFS2_INT_EVENT(filemap_splice_read_ret);
>  
>  /* End of trace events for fs/ocfs2/file.c. */
>  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
