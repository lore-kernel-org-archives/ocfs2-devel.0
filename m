Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2921ECAAA1
	for <ocfs2-devel@archiver.kernel.org>; Tue,  6 Sep 2022 01:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2kKVNWeHBpvT+YaacZjRVpym3AOxo6GFoOVW9IL+fW4=;
 b=nDg10773akXKzqYoTbhlyJGeljetijUGi9LC8N7akhIGAI0cFxUnekNSrj4OpK0H3I8x47Lgly8w
   7x4aF90DcfXjYL3ie5ve/DauQ4+FheFBJTal/MNkInKVDRwOQH719Ai09pFc2a2SpK7ed++nvHiR
   o+WMiC+8FvtiMZXrJUpIOlSfK2rgtAI6t9cWNmuSw4mIvW3Ls4oXcsAlWgczL28Vcs/DXW6DMN1a
   sIoIKOjG6lZEahv4Nqau+qa6daPE1tXdxJoPLWQoVayiRNL6uhtTLfD8nbLveGMKAXkfCP2mfkMG
   9RG4JkGhZLBnFgK2bDgY9RTPNtzdNr6XDAilmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2kKVNWeHBpvT+YaacZjRVpym3AOxo6GFoOVW9IL+fW4=;
 b=lBTLZqpAo8mTp/hIS/nGq3H6zw/FHzXUXF5lUnYZgMhrUPGyuB/bkXjnXtGRmVW90Ms9x1yeZKfw
   QOo9aJqJJ9uaY6zlI2xguTen7BvPQ3qoxpwMwlnH+vYN4kYnMraAy+BOzFqbt8RLzcSoncmcuP6s
   jtOVEirWAi4PU6rkAVUYsf9pgi8IvGjDk/xJVX21OguQiifKLfxXiwP7Ysq4Bc8/0+z9ytm4UYIn
   ksbzfjWKyDG4RoEq9dDR1ZSze2lXWxzLdRU7EQ6os615tUgeTUNvMXz7SgPXYxBJ70GexmHgK1uq
   lCT1vurYZOqYkdVXH27suI8Y6/KoytLrlNxlsw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHR00971KF84Y80@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 06 Sep 2022 01:06:44 +0000 (GMT)
Message-id: <65f66ce6-7695-2884-23a9-378b5c9ca04f@linux.alibaba.com>
Date: Tue, 6 Sep 2022 09:06:24 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Content-language: en-US
To: Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com,
 reiserfs-devel@vger.kernel.org, jack@suse.cz
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-9-yi.zhang@huawei.com>
In-reply-to: <20220901133505.2510834-9-yi.zhang@huawei.com>
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10461
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 clxscore=91 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 priorityscore=128 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2209060003
 domainage_hfrom=8545
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com, tytso@mit.edu,
 agruenba@redhat.com, chengzhihao1@huawei.com, hch@infradead.org,
 viro@zeniv.linux.org.uk, rpeterso@redhat.com, yukuai3@huawei.com,
 dushistov@mail.ru
Subject: Re: [Ocfs2-devel] [PATCH v2 08/14] ocfs2: replace ll_rw_block()
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=19; SR=0;
 TI=SMTPD_---0VOZFNX5_1662426383;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: RxKQhdB4nAylKRhsgx6DmLFeX2iV_q1G
X-Proofpoint-GUID: RxKQhdB4nAylKRhsgx6DmLFeX2iV_q1G
Reporting-Meta:
 AAGrBo0tc9c5m9tU4t1iUYzsXh4ZJCvAv8pJYjjWkNG7U3FA6akbnIpJV5LC76va
 CYHqpjy0H6jNy+BuRKoQkeYmRR/dXSeZAUyw7JfnEJDqt5cSdcNzSrhwSbFATRjn
 9+WI5sWdHGv7/d42xGlqo+p+hCmYpjFDVp6ntTwjHxk+50nSdpEEgtzR+OfbEptz
 Ydumpcx4hzL3iXa5V7j+c7og7rE4C5wAUzRe0gZlG4ngVC4zMobzrtVU690cutpt
 xbHfU69YKAvz5Jp/F48MfCmlWjG90Mc0M3AEC6eRn7OwwC7QZ8RXpSEMCOcaQHKZ
 KQd/YTzw6nqsWMzfL27GD6bgafxW47uNYkbQViqQsO9FLSAZH+aF0Ha7t3yr9w3X
 6X3GpS1iXUEsCtnpC6tyzBp2I+Zb4L2DQsXmXwg7EpB7/7ZRu/EdFTpdPnX7iOg2
 U224HOLiaEs/l/vA8Z4wGK7hmp12r4LtbxXkjKM0YH1o7w/XBLjq3wDG3vYSXeld
 hYm+HeqUj6a/6nQox/RIPnaks7OMC28gniX2+ZHZc1I=



On 9/1/22 9:34 PM, Zhang Yi via Ocfs2-devel wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block() in ocfs2.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c  | 2 +-
>  fs/ocfs2/super.c | 4 +---
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index af4157f61927..1d65f6ef00ca 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -636,7 +636,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
>  			   !buffer_new(bh) &&
>  			   ocfs2_should_read_blk(inode, page, block_start) &&
>  			   (block_start < from || block_end > to)) {
> -			ll_rw_block(REQ_OP_READ, 1, &bh);
> +			bh_read_nowait(bh, 0);
>  			*wait_bh++=bh;
>  		}
>  
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index e2cc9eec287c..26b4c2bfee49 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1764,9 +1764,7 @@ static int ocfs2_get_sector(struct super_block *sb,
>  	if (!buffer_dirty(*bh))
>  		clear_buffer_uptodate(*bh);
>  	unlock_buffer(*bh);
> -	ll_rw_block(REQ_OP_READ, 1, bh);
> -	wait_on_buffer(*bh);
> -	if (!buffer_uptodate(*bh)) {
> +	if (bh_read(*bh, 0) < 0) {
>  		mlog_errno(-EIO);
>  		brelse(*bh);
>  		*bh = NULL;

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
