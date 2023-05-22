Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C8CC77B73
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 06:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OKjUKxLOlej6JDbwC0ajU6Q4BxuRv63BP0Ud4GEdZ/w=;
 b=UV3C8iTwNptxnrGvj6jjwrb8bAslmOrLPos+0QlBsV1pI6qLqBjRWpftubs9uN7ZjyXoLmNZ/chI
   GvucOEr6WspzrsftDEB3K8ij4BDVs++6zWsve0pW9v5k8v+BKt9kp1AvW3zT8FW5DRVEclZUfD9l
   SX40/2BflGnfpG3a1y58d7OEhh4B3PIN7qjBnL5kC5s9CM8i1LxPp9EzGeE7X7K9dGTu3jEytFlJ
   moY3BsOPbqt1r/k73j9aL81gIRvDgAaY+7xueRDjZL+HfLRFAoxLwb93Ooxvl3c+Y1VUeY6S4CVZ
   CRisCzj5mGjIfEBJbtgHS22xVueDPM++dwUsFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OKjUKxLOlej6JDbwC0ajU6Q4BxuRv63BP0Ud4GEdZ/w=;
 b=dH82Ua4v2H2XmtMJDK3cXmKpePOpf3F+ZMmcL6QH8EnJIcSPI48h09CHHyUE4yfp+CIsa/eRjHrn
   dLZGzXjf1oryx8DGDlLeLGbOZM1CkwrRAWGruA/BYBumra8zPKMR5cYR4ZdnUiWQSO6ivBtbWlxg
   3rmK23e7oUGYVrWaSvib7ky+Lzhz5QGk8QUdUppLIlkbN1XtYZo+j4GtxRsUJlqdXXWEw++oxU3Y
   y3La3dYL56tcdfocp2p3eIGxIGGBHn4Tlg/qFEJDZspTJdYIkrfhFYDHlcz3Mttqb1qtG2MxCpdB
   1q1sODwyBj+UVKQpKG8cr2xW6XeGIyyw08FAuw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV1008PYSK3SZ10@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 06:55:15 +0000 (GMT)
Message-id: <9059d4e5-3813-b84c-b0d6-ecfd9a1c5570@linux.alibaba.com>
Date: Mon, 22 May 2023 14:54:53 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: David Howells <dhowells@redhat.com>
References: <376ab23b-52d0-d7fd-2dd9-414cbb474e01@linux.alibaba.com>
 <20230520000049.2226926-1-dhowells@redhat.com>
 <20230520000049.2226926-23-dhowells@redhat.com>
 <2414055.1684738198@warthog.procyon.org.uk>
In-reply-to: <2414055.1684738198@warthog.procyon.org.uk>
X-Source-IP: 115.124.30.97
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=814 spamscore=0 impostorscore=0 priorityscore=194 clxscore=35
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220058 domainage_hfrom=8803
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Hillf Danton <hdanton@sina.com>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>,
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=21; SR=0;
 TI=SMTPD_---0Vj99.vZ_1684738493;
X-ServerName: out30-97.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: RIWZn-3jFcgeF8xA_Sev-pSVjI6ZefMw
X-Proofpoint-ORIG-GUID: RIWZn-3jFcgeF8xA_Sev-pSVjI6ZefMw
Reporting-Meta:
 AAFxkQ6PxSJCSMklvpfWod/njOsTI0tP0WG4LKqFQfgZqMlDzKA+mcMB/Ggr0OEb
 YlHlwtEHYXoe2R0+UPqpFAPIz/uz4UzZGWIkGCMBKmZqOKDfzOD4IAAdtbNubqe3
 o3WndU+2L5eRCcEUl4vVGv+MS/McJ7dcijCCtp1VDaEmwWkbRCuAfkV3fqJnfMz0
 q1JuBuX5kpFnQGFijlxlBWRN1ZgrDDj9wdv9x7YDZx94tq8iAThpZNOSSjX4iwwO
 VOK+a1gFiiNu+NQdINsPx90M0PDuQBl+DFSvyFusOfjCLsTlV1DzlQeiuFcTO+FI
 i1ZLbromp0dEgyb4TbGZlzWJkcocBn1MQoQ8PlMd2doKajEWwYEnkUstmmq/V94r
 K87vYgF1hoip+V8+jQMiaQ4ThC/UeljDjnseAf8kJsmKXA+4xr6CQ4A5awCID9Wp
 QlehIbl21u/hEAaC0nk3IHygUkXhK4iw78WS3qO9bV6J2HnbLolFPqmf/ZX/RZk6
 f2pFtB6h2hWgCgVzVGVT4mcVxPbrvMm3V1r/i6LcjPAU



On 5/22/23 2:49 PM, David Howells wrote:
> So something like the attached changes?  Any suggestions as to how to improve
> the comments?
> 

Looks fine to me now. Thanks.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> David
> ---
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index f7e00b5689d5..86add13b5f23 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2552,7 +2552,7 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>  	 *
>  	 * Take and drop the meta data lock to update inode fields
>  	 * like i_size. This allows the checks down below
> -	 * generic_file_read_iter() a chance of actually working.
> +	 * copy_splice_read() a chance of actually working.
>  	 */
>  	ret = ocfs2_inode_lock_atime(inode, filp->f_path.mnt, &lock_level,
>  				     !nowait);
> @@ -2593,7 +2593,7 @@ static ssize_t ocfs2_file_splice_read(struct file *in, loff_t *ppos,
>  				     (unsigned long long)OCFS2_I(inode)->ip_blkno,
>  				     in->f_path.dentry->d_name.len,
>  				     in->f_path.dentry->d_name.name,
> -				     0);
> +				     flags);
>  
>  	/*
>  	 * We're fine letting folks race truncates and extending writes with
> @@ -2601,10 +2601,10 @@ static ssize_t ocfs2_file_splice_read(struct file *in, loff_t *ppos,
>  	 * rw_lock during read.
>  	 *
>  	 * Take and drop the meta data lock to update inode fields like i_size.
> -	 * This allows the checks down below generic_file_splice_read() a
> -	 * chance of actually working.
> +	 * This allows the checks down below filemap_splice_read() a chance of
> +	 * actually working.
>  	 */
> -	ret = ocfs2_inode_lock_atime(inode, in->f_path.mnt, &lock_level, true);
> +	ret = ocfs2_inode_lock_atime(inode, in->f_path.mnt, &lock_level, 1);
>  	if (ret < 0) {
>  		if (ret != -EAGAIN)
>  			mlog_errno(ret);

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
