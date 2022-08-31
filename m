Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD2FECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 11:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=p7yL+MK0xvCU8PuzYQQQSMGfUF6W5srBe5FxfgSX8DU=;
 b=N3QL/u+lYuz6AlN54fstB6K7t88nu5fBq3JRuX84EF1B7L43Ieg/lvbte7yE3Z1KpSGQT4RgcQ8S
   dfS3iwEV8XQ1sDuPPg3S/vVGn70+xoa8lcLSS/Dly8yBZpZfl5LmkUDw0rQD4DI505jvZwfqJrAo
   e5s7qVEqGp+DEbI2zrh3UE/ywqQ/ROS13q1PqgOpQs0UX8tQwmImrEvCV/Ws2cUIVat4XpeFNiFg
   7dDjJFLAP3MeV4yCfyFQjh8wqG5mPnzCJTN8RrBuz2/pJnGthhp6QqswQj8IADnkLw4BWNWfGcao
   IOnPTsT4w6ktW6UBqPTG2GB/1kWOYEMMB6DSSA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=p7yL+MK0xvCU8PuzYQQQSMGfUF6W5srBe5FxfgSX8DU=;
 b=hJAOgDOiOjTaGWKP2P73DeCEbDeJ5njYyQrZqC6cnB4KC+uP2c/gVGrCvOBSmOUeshpHCNv/UyVx
   cN8jRus3Xhe84BZqSNlzP3t03UPmHlymLe8nPwjBaRi79snPfG23vrY/s746NL17KU3RvpS56JPf
   +tIo1KNUXuY5MLd0ZUbXZleVHBuSlTfATQTkSbUOE4wnxQu/Aec8L7jeY//ZlfEoTUAIH8BOZM/v
   b2HZ3B+EnBMEoGvld2ANQGuUB6SlVW0nNJipkqSrz9qRUSGw0tvyKmt1HAXWr8dqFoUPnjxvRhvR
   fR/CxCt78FI/GdaJXrXim5ubulTf6tijHSHaYw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH00N1C9CZWT20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 11:31:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661945495;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=XrNkIM9koqnVx0iIIXA2kZMeNNiavp0FWSmtqMYA0AU=;
 b=j090jyCm7ljBjfs584BrGreYmQ2T034+Z8td5gv5FfrZdYMc/nlY8I/aSz4C3omfWXI7/r
 ZEOzi6UQXDB/dteLKZnnp6hc6sOMCOwq5e58CzzpQlUY6ftrhpOKAPFxsdKIx1CgNfMFzA
 Hj4TA31NoNrPyxjPQrg5GzRWQRMIkIk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661945495;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=XrNkIM9koqnVx0iIIXA2kZMeNNiavp0FWSmtqMYA0AU=;
 b=tPMWSP1a01IN2kwdj3whXjAztjKIlV4ffC1mOQYyySOtBL6HO9DkoW/WjMWwVHqCAYhxCh
 O+LRuPOxKQsV1wBg==
Date: Wed, 31 Aug 2022 13:31:34 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831113134.fdmklqore4uglz7g@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-9-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-9-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 mlxlogscore=495 phishscore=0 adultscore=0 spamscore=0 priorityscore=223
 malwarescore=0 clxscore=176 suspectscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310057
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 08/14] ocfs2: replace ll_rw_block()
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
X-Proofpoint-GUID: lf_ABxAa4bHkbdJKuGQHw_2247p0PQT_
X-Proofpoint-ORIG-GUID: lf_ABxAa4bHkbdJKuGQHw_2247p0PQT_
Reporting-Meta:
 AAFqqKONz/Is4PQgJKCLjCiEn6FzpXeEFuF3+UN5yC6YDx7McRuveDU29b8UFSoI
 fz945351SEpX6e6tC8sz3rUM4hQ5/nHyeUmuexjI+7BZRi9Rnu/A5kO2uSMI8TTx
 Bp3SK4WoTnOGLtldrFUJt3QfEIgFpRe0sVKrQ1ZDsrmmqXURCGQJp9hzNi70jySg
 3ABpb6fF10Twz6TmB23buoEm1fqgYiisihEQU1dUFQWUbIfEvayXBQOfV2cucWAa
 BzNNtHLe7PbeHnDIjEsUQf4pnf14/nMEk+zYf7ZdX2/Q1yZLH6EVWCzbVbChZiEy
 tOAHf5WZE2uYBkDc7shVLVLVGuv6DSeMooh/kqQigVRtD9IPVUxXx0Bo+azoCfbK
 rkVJF+8sU2YdJtBs83PAYRLIoEe5T4m01EZlrruwB0O9ViwbzC/tBhUzVGyfaMqv
 dsrPFHFw4vIBGfud2onisj6+KY/aSsbenu09EEbN1Ui6/9yGVQJPlR7q8S/0o8Ow
 6PV+mtU+0RWkClQyjYtUYVQjqUquwJZOxlWYYJw4qcxn

On Wed 31-08-22 15:21:05, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block() in ocfs2.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ocfs2/aops.c  | 2 +-
>  fs/ocfs2/super.c | 5 +----
>  2 files changed, 2 insertions(+), 5 deletions(-)
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
> index e2cc9eec287c..4050f35bbd0c 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1763,10 +1763,7 @@ static int ocfs2_get_sector(struct super_block *sb,
>  	lock_buffer(*bh);
>  	if (!buffer_dirty(*bh))
>  		clear_buffer_uptodate(*bh);
> -	unlock_buffer(*bh);
> -	ll_rw_block(REQ_OP_READ, 1, bh);
> -	wait_on_buffer(*bh);
> -	if (!buffer_uptodate(*bh)) {
> +	if (bh_read_locked(*bh, 0)) {
>  		mlog_errno(-EIO);
>  		brelse(*bh);
>  		*bh = NULL;

I would just use bh_read() here and drop bh_read_locked() altogether...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
