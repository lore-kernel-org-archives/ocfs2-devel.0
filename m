Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2BEDC7EE20
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KcCwoBWrdjaCfki0osG+Jc0kU1XQWX9OS1ooD3VoErc=;
 b=006putGqnDVd7Z2Q/t1eT4pERQPKhIltXfbRhv+kazSfZ2SaV+B9B7GcbsWtrY1cQks5L9XoLGcP
   Pynt06do19E1IViXRla6YFEBfDA6FNcCkkVrndAZwNbolhRP1AYwygyC/h+ybCLIGPjfRvvwFDok
   zFqCnHBUSV4WU8kTSmtXx0tK5DGgxA8ewe8VVGe94C2yD/gxDSeLi0ezJXfHCz7AWog+IxH0XEQq
   wUDF/DVFXekyoNTb0kpKXedwCLq3KyzEjHs8r47AmL1uWamJm7Hbq+8qn64YW1M/2ii5XJEQnOXA
   D4JE5WIWO1DYf3kBk6uTjn4DA/w8LsKcy77HGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KcCwoBWrdjaCfki0osG+Jc0kU1XQWX9OS1ooD3VoErc=;
 b=JMaJ880YH5MzrNA1QtuGCW1F0vhc/nBJ6nZuk1L3Jb8IVPqdsdrXmTxQciSfziqGrqUICPYaKn7C
   0jrQuK9+oJ+ZtlgD86s6KLmZMMWohhy5Vr3mVAToVL2Y8wsn9ASWmH+rSGAKyAVq/NiVxhvg1w/h
   oRT1WH11CVUp7WrNLfJjaAQnaSEr4QSmaHhoKS/LsGPuH+M+dov8Wu24LluxHVdhpJmp0eIoo+x7
   8/9sGw2+ELGGr+/7h9q1yVd8TVFq1/n9eW0oWa3JScf+dSiPatTrv/BtWJS00nG5FUltlXVI2Ekt
   zbkpkApmq20F8HlCSgJD/yniuPHrFKq/zdjdHw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00G9AM19NU70@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:09 +0000 (GMT)
Message-id: <e8054874-88d8-e539-8fd4-6123821aa3a8@linux.alibaba.com>
Date: Fri, 10 Mar 2023 14:01:09 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
To: Yangtao Li <frank.li@vivo.com>, xiang@kernel.org, chao@kernel.org,
 huyue2@coolpad.com, jefflexu@linux.alibaba.com, tytso@mit.edu,
 adilger.kernel@dilger.ca, rpeterso@redhat.com, agruenba@redhat.com,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org
References: <20230310054829.4241-1-frank.li@vivo.com>
 <20230310054829.4241-2-frank.li@vivo.com>
In-reply-to: <20230310054829.4241-2-frank.li@vivo.com>
X-Source-IP: 115.124.30.111
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10631
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 suspectscore=0 priorityscore=130 impostorscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxlogscore=999 clxscore=101
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100047 domainage_hfrom=8730
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 2/5] erofs: convert to use i_blockmask()
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
From: Gao Xiang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Gao Xiang <hsiangkao@linux.alibaba.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R691e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=20; SR=0;
 TI=SMTPD_---0VdW7I1M_1678428069;
X-ServerName: out30-111.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: xHkxdqwQTovaNxmUAjGZlkqxSTiagUmL
X-Proofpoint-GUID: xHkxdqwQTovaNxmUAjGZlkqxSTiagUmL
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAE2dT0ZX1zd407aqWI1lnvwSVZ3VjMs4qcH1w7Sf5JzNw+OuR/9i2AJ21WsZSyL
 8IgWxJylV15tUSNgIcSomsncHMB/7ClktXGm7sJY50eBGNYt2Xx4q/k69GpoA/aC
 mXSSMj+tAA1wm/D5U7NN6+njxaSf2NJ9KJBBCUIZhlWG9i5mYMyBJqOdhWEvtTTu
 pLIrVYIt3uzEmNVOvVF6ddp0OjsXvHJjFmasVuO8MWyoZn0eBW+Rt0dACT1/aLwm
 SpuZzdSYWJXMJ4CcJZEyb32j1lddygZ+C6ArRKC7ucTRZjcuF3lEKphPoZfv5HfI
 eWN/B4EIs/YNNyhGrZ+pyJiHaCd4qBty0HNoDK8R6L8wNbJkZI9ZwpaPJcjqRUZo
 jYQIgtPF8Ba7OiqAqWnrAJJ148CgPdEDg8pbVMXMlPbFOOUIZO5OQVb8NfRGIMDu
 KMMA4PZSHc9/NJeLKrz8On6tbStwUuYPJvI+Rp4xF8f35vqOy3b7spHJvPh+uk4R
 ro4G4V7yPiRXaQuw/x/NJ5I4k2D3aCFFFnVhUzfw7846ZA==

The message from this sender included one or more files
which could not be scanned for virus detection; do not
open these files unless you are certain of the sender's intent.

----------------------------------------------------------------------
Hi Yangtao,

On 2023/3/10 13:48, Yangtao Li wrote:
> Use i_blockmask() to simplify code.
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>

Please help drop this one since we'd like to use it until i_blockmask()
lands to upstream.

Thanks,
Gao Xiang

> ---
>   fs/erofs/data.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index e16545849ea7..d394102ef9de 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -376,7 +376,7 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   		if (bdev)
>   			blksize_mask = bdev_logical_block_size(bdev) - 1;
>   		else
> -			blksize_mask = (1 << inode->i_blkbits) - 1;
> +			blksize_mask = i_blockmask(inode);
>   
>   		if ((iocb->ki_pos | iov_iter_count(to) |
>   		     iov_iter_alignment(to)) & blksize_mask)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
