Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C87ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 15:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1U44Kp3IexgDWOPKBaBSxNSwsvdM7AiXwcHf3PJMo6E=;
 b=PEDjticZZhE1IttEfJGd+WHy7PpFWYSWhlZYHvlsJ3i6XpuoomBUmc5fXave1/W/zBStIKPuufFV
   XWudonYesmDwkT77HzmbBEVNy83E5z37VnN4kXJncUbhVsUFdMj9pzxyYMMiM3yc3dq2KLNgsNbN
   bAZRfObY1sPOkxFucuMUzM3gdMsAkxXlChMq3fR1lvKhZe0CfI/7zNNdVi9ty2Cdqm7z9KXzDSbw
   vHy2lf9Cx/bvPZPqqc6pSUBRZvMyCTcj392FfFNyx2jpb+wrcEfP9/GvY7K+4HnURXhnCot6bLbQ
   ByB8BRL7PYHrurHvuWGqtdhae3C3+hVxKUG4iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1U44Kp3IexgDWOPKBaBSxNSwsvdM7AiXwcHf3PJMo6E=;
 b=d1O2OPwKWuYLxycm+Nf3QRdWHfPZK0qj4bs3A/QSAx5rOkHcBaWUqva9kpyb482iWOYx59Pa/tg/
   umBQU9uvAuL5PPRtFv54QxXb2buW1/NlEOpvfVWN7ICWUWB6URKFdohx0JsOJYo/gnn54ZvJza7+
   XYSPxnax9MptD43jLWEkRrZThEE0zWETOZtWpeD+5Afj7FUHZ7zoi00Lh1FOoLhgj/22yjDUbSEH
   2uKWwYDmH7GMOr6Yc1Srww9/zE/sHxIXvmUVbIWBhQUBDnrlsfhczON1bvm9rqRJvd8vgrVSETEj
   vyCWW3TysUdjQF2vHBZGiltZLgGLZN2E4cO5/g==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00LAAG1H6SD0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 15:51:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1662047465;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=5I0mKqUw3QSCLqCj5YIpAi2jtZ5obLRbYrhgg3fEUoY=;
 b=U7Un8DCOE4vHaNWAjnV1RHJvIkAJvwVTD1iy5tLgzFzn0yi3st4XwSnjHZ/fW2kX5uI0R+
 8giwSrL7sQmTu8X13dL0oCRXv81or0G6HiV5h4tVqsSN1kkb7nNO8hOshvQBw2Jv9VtVKb
 asX++mLhndXWdZAcD15WQ2NnJi/AApA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1662047465;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=5I0mKqUw3QSCLqCj5YIpAi2jtZ5obLRbYrhgg3fEUoY=;
 b=Yk5d8GzmcdpIlqYUaOt3CYZpv7xi85ztTzS8BwutP7VVFVQTqz0Tihub+VeK5FtVBlJBXC
 wJZX9dP1SI+QWQDQ==
Date: Thu, 1 Sep 2022 17:51:05 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220901155105.q56thxo7hcudwgrx@quack3>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-9-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-9-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 spamscore=0 mlxscore=0 priorityscore=232 phishscore=0 lowpriorityscore=0
 clxscore=179 suspectscore=0 bulkscore=0 mlxlogscore=389 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010071
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
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
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: 5kE1akMt_7Kk7SXXcCta0QcXEksukFTf
X-Proofpoint-ORIG-GUID: 5kE1akMt_7Kk7SXXcCta0QcXEksukFTf
Reporting-Meta:
 AAERc2IujToesLS5JvZxZIOSWUciPW7ovexw7gbDWYGmqwGjTI0ihnM+qa8Nahmm
 079dnUMcBEkRuQGBvD8TsJ+9BAiw4bJUEnnxpuPFqaBkElen03jjnuAM8wCO9s1j
 dMhah1C2AVJJeLAZnpTHG5dnla4aO6Sk6OkKIRaWvLMK/kLvbH0uWJpsJZ4BRMl1
 p0FtLzied+dxmucPoFzij4wfhXZBdCfV0q59mJ1F32pWIfFpblD7TyvbOsN6j1av
 3ONZDLXtFr9I5Go/uwIRVixXK/UYgkypp1c9UIIDCp00Pvxr2Sa6vk3R2h6vSKTt
 a9551Dd2f41CHOfZauiM7f/Ppje5iCnZM1X7ASl4cXc4yoDWERirvBlXGpIe7cnR
 kTfNGcGPUjwimitiVl9Dr0h+GoZ72Mxawmc9vo0qNbtHZwe7Vo/OlmpFd+C1JMT3
 7xlS9yvZL7R/+4IaH5UgA4UD8bKrm96czv3aMJnPMwkUk9vfdUzHTuryh1OmprwH
 mqWzfCXbP0763ObVflH57pJwn5AqQ1JxO3Nm71vlsl4=

On Thu 01-09-22 21:34:59, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block() in ocfs2.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

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
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
