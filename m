Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86F07C6FA99
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 11:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MgP8iZCjH+UoEWPhHxAqmRIi9hT8ibeg1D6JRAlt6H0=;
 b=1coA/9MHGtLx8Jts0zSQS1bCKcOw5zUNecw+0Sjy/MHFLknSNMmAtTR2phoVWed1xY8vtG4oRPKv
   51ZcbkKJeKpMugxvjSfBep5r3sJYNzV4YlyyqJwrvGvYYN/OtWN8fAjxYLzyKgkLr6EVrYymiuxx
   /1MlTgmlGjMaNLDAhLjyfbFDZNWf3jA7/SEWcR5s4R8kVFDka43ATlc2B6XiP882V7nWtf+gpr69
   gtlVOUVCesyDm5a7I4YYdLIBN6n8F1oDrIJ6rvr8HS4EQvDRcHsxQE3FIWlO8M5qN96WGyPztNaX
   ewLSA8yJtvFSMWQza/G4ZbMhU+iGUrQCktBe+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MgP8iZCjH+UoEWPhHxAqmRIi9hT8ibeg1D6JRAlt6H0=;
 b=NLhNlkbU1XKF9iVCEULyW5nKnQKTiFKfbwaLuzS4iaqKzjXTMCrlU2zE/Hx2hi0wg9RfO+JAqXKm
   Y/QsQezUMqQ2lqbR6rdtJ/U75i6MB6xejZL9M5ReNqBmpgKOR5DoTUCwISAGkMPMnaWRY53C4+MJ
   gLXUX05tlKMQ4VXHQMFN4s8CCQoycw9i+IHqRYPQ6/H4zOC9vgNcS8QQNAwubS5+uiTRTRwunhct
   SyE2qjiQzDsJ3ylasz1QbTyn5vXaku5YkGOuyk0aPn0Co2/BDUlake8ln0RAOAQBSp6z2jvievia
   Ci5JUolr0Lvse8AxcAnMtE0KZ+/D5FZTf2ESgA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA00BIAXUGCO40@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 11:13:28 +0000 (GMT)
Message-id: <faca55dc-fe0d-9014-ede2-f55124cb4227@linux.alibaba.com>
Date: Fri, 10 Mar 2023 19:13:09 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
To: Yangtao Li <frank.li@vivo.com>, xiang@kernel.org, chao@kernel.org,
 huyue2@coolpad.com, jefflexu@linux.alibaba.com, tytso@mit.edu,
 adilger.kernel@dilger.ca, rpeterso@redhat.com, agruenba@redhat.com,
 mark@fasheh.com, jlbec@evilplan.org, viro@zeniv.linux.org.uk,
 brauner@kernel.org
References: <20230310054829.4241-1-frank.li@vivo.com>
 <20230310054829.4241-4-frank.li@vivo.com>
Content-language: en-US
In-reply-to: <20230310054829.4241-4-frank.li@vivo.com>
X-Source-IP: 115.124.30.119
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=100 malwarescore=0
 mlxlogscore=981 adultscore=0 clxscore=42 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100088 domainage_hfrom=8730
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 4/5] ocfs2: convert to use i_blockmask()
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R431e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=19; SR=0;
 TI=SMTPD_---0VdX95E7_1678446789;
X-ServerName: out30-119.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: -h4X3sobVNVGPDcfnQ0oDPo8395sXzQL
X-Proofpoint-ORIG-GUID: -h4X3sobVNVGPDcfnQ0oDPo8395sXzQL
Reporting-Meta:
 AAGuYiqMd4eWjZpbaoDTwomrplhFFl/LrT9bzjqUxPlPGZhHslTGOi0TJC/4+1dX
 JtQy7/1c1v5jnTZwTpydHqa0CUkIMFvDs3hS1CKOrea9j43b9Xq6WCgEqOSea+OF
 uyxvgcdRIcK2/ouI93aeu/XtdBfWfJMgy80kOHFUXYdadYE66RAJnRFJGvOdoWGh
 DH8l+4XEVHMG4AFrSL5QV4IAnKHRximGZxKKzS3kihpuOxJ59778nB4egwinu8//
 6VMWNO3YRtFBP80BjY5ZfPdWYJzdoqBsb6ociBDtEo1DdsKKvZPjLhPJhgDz/aBO
 6ICxq/dUs0AaoGG5g9RQXqusYaLxOEfRAhf7njJOjbrW47Z+5wy9eD8hsYLgeq9n
 bgMQ8twKqIysu6Zldk95qvPWNiuGAnIh1VHqqQHNuggyfXRo+DusvPZgrBvmtIpr
 DElZe0/QcQee8/qd00U9cg2mttbb5W9xGHQ60sB+rvV0HFN0PZO+dkHuk5qpd9W7
 2rS1G8ukPTYDMZFI+QnFGWOI5rk3P+hKohcK8hvsGg+w



On 3/10/23 1:48 PM, Yangtao Li wrote:
> Use i_blockmask() to simplify code. BTW convert ocfs2_is_io_unaligned
> to return bool type and the fact that the value will be the same
> (i.e. that ->i_blkbits is never changed by ocfs2).
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---
>  fs/ocfs2/file.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index efb09de4343d..7fd06a4d27d4 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2159,14 +2159,9 @@ int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
>  	return ret;
>  }
>  
> -static int ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
> +static bool ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
>  {
> -	int blockmask = inode->i_sb->s_blocksize - 1;
> -	loff_t final_size = pos + count;
> -
> -	if ((pos & blockmask) || (final_size & blockmask))
> -		return 1;
> -	return 0;
> +	return ((pos | count) & i_blockmask(inode)) != 0;

Or !!((pos | count) & i_blockmask(inode))?

My concern is just like erofs, we'd better get vfs helper into mainline
first. Or can we fold the whole series into one patch? Since it's simple
enough I think.

Thanks,
Joseph

>  }
>  
>  static int ocfs2_inode_lock_for_extent_tree(struct inode *inode,

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
