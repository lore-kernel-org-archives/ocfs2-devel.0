Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBF39ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 Aug 2022 11:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AmAlbayhulp3sAch2bhsfKklGYw0BSh1pUWGLRi/O10=;
 b=nX3lzJBdKRyGc/U5PICNIM5pujF0KSNXMKtHqftOjXak8FnpeOC5zHu+qDJ/D8mU4Oh2chIthEmX
   J1c+UXEneoXavqE6njC2i/0p9dUBATgyx3I1jPUzuLiwxSgZejdomye9EZ4EHEDASeFE/tMo9Ph9
   FqFM13LSOJ/qEuV52TcBJYdZF3WK3FQFlckesnJ7t+GdpiqJ4l2wZ9rVACWkr3pbgpvAG7deNLuf
   6cP3SazywtDvOZ8DyS7cgzMfc4SqNf+YqNB2sDMVQjMnSnIJKBU5M8WE6q52owbxBtb2CrjB0MFF
   U/rE28S402XWiPqCuEEb2LIJ99Q9dPYWPahvxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AmAlbayhulp3sAch2bhsfKklGYw0BSh1pUWGLRi/O10=;
 b=Bm+qlkQFbneKPA3SenrE5At3jh+3EP9Twm2PV5b9yfox3oyZDhdhv0XD1+rLaVibXce+4jw5zfBz
   /S4EvXnH9JzsDqQeqxXQoU1ciLF/852BJ/EEk3UHyjnbi65bDJwHs2fbYnubxoeFTBB1qSyzZRSG
   2FzGt+Bytd/jKUpIR9JNQ7DkIyovMjBF26tE/SyvXTIV9B/fzCzigM9q/3xmgpPKJcTiX+ByZFr0
   HOjCkFyF28yT5qEpNYhkUDuhkIKiFNo2/pohn9cgeDu2DEFqQpwsDMfR8mmm/39kN4EjkHwntoRF
   XmwUHRiV5cz8TyIqCl2XFNwisoR9bOzBYwrouw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHH00LJG86ILH50@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 Aug 2022 11:06:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1661943967;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Ux+/6k6yQ68d20CIHpJNNhVF8b7vMhQjE5cIGh8WXbA=;
 b=gWzBh39lJUgv8YalnH1E/zHqDoZvJuwDJttq0eb5EwKD3gexkpEUqig8vE7ADgEj0aTpVk
 zmNsNkqdttx1r6tv8m5fU+ur8lf5fuRAEAE26Ontuxm07GZBmWv8Pz8w1DIEfmEFLu9uRJ
 PxcE/nkR+bxUDvtlQOuzJb8tk5EMZJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1661943967;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Ux+/6k6yQ68d20CIHpJNNhVF8b7vMhQjE5cIGh8WXbA=;
 b=79CrkKwcDm35RwKykj4Z/UcaMkbv7xV6sge+XImxuYJK/wSO3Zb6g/ir0fibCVSJxWpAkg
 84P5fdryH8GO1XBw==
Date: Wed, 31 Aug 2022 13:06:06 +0200
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <20220831110606.7c25xioli2uxcacr@quack3>
References: <20220831072111.3569680-1-yi.zhang@huawei.com>
 <20220831072111.3569680-12-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220831072111.3569680-12-yi.zhang@huawei.com>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10455
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=583 clxscore=179
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=181 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310055
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 11/14] ufs: replace ll_rw_block()
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
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: gz97S2q1WPOdHSgLdYR8vsKDAYv_ooQP
X-Proofpoint-ORIG-GUID: gz97S2q1WPOdHSgLdYR8vsKDAYv_ooQP
Reporting-Meta:
 AAEwnZZ6EToHhD0qBlL2drdEDkfq98JnXWrxaAxbJaxAU1QdKOfqR30CbSCuC4/h
 R/V8JZJKplRkiMSbwbkrVJkQFAe4r0OLWC8TD71iNpjq+Y14+cSYEs22T9TXyxXJ
 IeBOQSlsPXpbPfzuuaZO/D1JIp7BZqzWccYaSTj4zJHhcPOPy/RCXyF3IFlU903K
 cW5ErAOUYEeNUaTXSgC5YZqiUjLhpHF2gaGhghB6QeIbxDtoecSIHwqLyWqNYhSc
 9F4Dy2GsVbosMCDgNuiwQw/d6am8CZmSGTySDKZnKojTMYkvXZDdYYOVAtjaQbyD
 cmw9wsN8rG+y/hWBxZyE9o+ri0LxC6S26avXIvCQFBrNcgMu84hAZTH0X+8jMxr8
 D8Gex9ArA4CoDjxCUgCrMY3HL3Q3CX22ePucAAn34aF9jINQUB3MPEsyY57HduWs
 IpINSCRpaB1e0LMiUJNekBGqPYsg08wz9qWC6IX3ro8jRqONvQqedPSmiU4HHfSC
 82M88k4s8ZvkTn6+/4NiSefHQ0MtAV76Tx6c4Cefqp9i

On Wed 31-08-22 15:21:08, Zhang Yi wrote:
> ll_rw_block() is not safe for the sync read path because it cannot
> guarantee that submitting read IO if the buffer has been locked. We
> could get false positive EIO after wait_on_buffer() if the buffer has
> been locked by others. So stop using ll_rw_block() in ufs.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ufs/balloc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
> index bd810d8239f2..bbc2159eece4 100644
> --- a/fs/ufs/balloc.c
> +++ b/fs/ufs/balloc.c
> @@ -296,9 +296,7 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
>  			if (!buffer_mapped(bh))
>  					map_bh(bh, inode->i_sb, oldb + pos);
>  			if (!buffer_uptodate(bh)) {
> -				ll_rw_block(REQ_OP_READ, 1, &bh);
> -				wait_on_buffer(bh);
> -				if (!buffer_uptodate(bh)) {
> +				if (bh_read(bh, 0)) {
>  					ufs_error(inode->i_sb, __func__,
>  						  "read of block failed\n");
>  					break;
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
