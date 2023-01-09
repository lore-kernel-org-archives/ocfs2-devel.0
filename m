Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE72C677F1
	for <ocfs2-devel@archiver.kernel.org>; Mon,  9 Jan 2023 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=W/rXOzorvdkna9gkupwb9tvuXFiqMxNnUiL/Vl6G5IU=;
 b=OxXTPApa4KvazHdx8I9K9Af5QdFbuIN7bof86AMMrBvmlJZJkG3D70RBtaBNz/DfpmQfycQE2ZgV
   l/VB0mERk/KYxmdRuoXQZaEQ0N4DzxeF6HCyIE7n4ekdG5+SXk1G2L2K8jwFL3a8b8ABaTnFyh1i
   WIIX3hAunov04CK7dysaWg7UKWhhiiMcQMpAmlaLN7blOtmgomGo1iupD/hiHyM7MHd013cSBmyW
   exN64CL3ykrI5q8p4XX8jZEC5dD4ub75cq65FMUT97XxiEEMC0Pet/gs+JemE6u/VLaNZgaMUurJ
   iEpt6Pghupt5XYTpFuUCn2nWKfCyZj7DSX0Few==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=W/rXOzorvdkna9gkupwb9tvuXFiqMxNnUiL/Vl6G5IU=;
 b=ibAP1M8yQhtT94jYCm1tx7DzjXmHB+7uauyiq+apf4i7qQ1Xj2L3BXu4mzeX1a9UhzMnfJcDf7Mi
   r8ihw6KmZs3MG6bFjOzgd5kS1Z8iOlSivsy7ex1lUqmCUlDEfYhYjvlAoHaSZ/hiy0ZF1o/wyFXU
   mur9FfG8qx3w/DN2H27vl59E6wtwgfXaYyrG02wECSNvKPaHQqDZj73AhsiFq8z1KAyMfLarezGg
   icJ1mFVHSP39CwJayQtrnJk2nUOB9YJQ3xsRAgZz55yClEa8pAE1PjC/1Y8ZeBpFwYlrlBFn3pAC
   J1URnNaey0ADAd00v31Mm6B4cf0xSt9EiU5QEA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO800G0YA2N4QE0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 09 Jan 2023 17:03:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1673283821;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uVmmyHC2Ssr+zx9dA/TPpe6nT2qb9V4pzC/Myf+9t60=;
 b=QkYv4aUKGJ76GDlIUsX9im95mOqzYiwom90V2EDMZ1guLuNLcFfh48IN3G0yoVYjp2vCwY
 FduqnCISStQRMWi0qInfa6E9c+LEBqvbeejMt01w/4TmPTcJL7hJEu147k2cHqKAG2JdYK
 ccPdLNsia7DeM1Mf9UHFiLD97ofvFoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1673283821;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uVmmyHC2Ssr+zx9dA/TPpe6nT2qb9V4pzC/Myf+9t60=;
 b=tdnpLblfvKPQhFhRVgTdsKRz4lLQCddch2je6NGSKR6Va5Fc3eHdnV6vlNB9C4r0omorSS
 Xomtp1YWRUEdx5Dg==
Date: Mon, 9 Jan 2023 18:03:40 +0100
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230109170340.quwwjkte6c467vfp@quack3>
References: <20230108165645.381077-1-hch@lst.de>
 <20230108165645.381077-7-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230108165645.381077-7-hch@lst.de>
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10585
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=158
 impostorscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 priorityscore=70 mlxlogscore=557
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090122
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 6/7] ocfs2: don't use write_one_page in
 ocfs2_duplicate_clusters_by_page
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
X-Proofpoint-GUID: iBnjmq9kv1ruISiFHKVDBkdYyW94bfrz
X-Proofpoint-ORIG-GUID: iBnjmq9kv1ruISiFHKVDBkdYyW94bfrz
Reporting-Meta:
 AAEo09IfWFIAEOT+QD7uiD7mNv0nMCtzQCM6U8yAPM4K3bwpy6W9kKHMdJed1TDJ
 BhyZUCg9WYx0dY5u8YOFlhmNUAPMjEEqT0u/dL9YgWeEf4rYm526UYj9IMGSmcnE
 xdJE9/Zm6JoZM6SvrBPRYjqaAlhmSm1MklzhvdwJAgCmohnlqyaus+/tCQeSX57n
 jFNRV0rbBdARCKTUVbuUnDdFqvShNHB6uvrPgEMm0gIprgPTRucpyecr/MP3LPc/
 nX0aoLLlsRAQH1zy8XDVh4Bmk/FjTZsrEb9ccAfLCFGJsIW/2UZvTRk0PYVhBKJQ
 jgFo10AJirMvsUcsNR6DlrpEikQXoCR3kX2ojDgeokvvrw0MlAD1uqn7hrSWZMrV
 86DkKp6vSG8IjOoCx8TlelZp8YAidzuNLSMfY+yuLlo2MVB4dYvD3wvekw7ZZwmI
 ejCdFZETwQz1dHcVngjz0DWo2VAS47mHSVesLzEzGO5hKkpT3F4vBCiR5ekmFod8
 Cjci1YRDTYywlE/tzZ7rVItPgFP+cxzZ9dbn2qB1RPU=

On Sun 08-01-23 17:56:44, Christoph Hellwig wrote:
> Use filemap_write_and_wait_range to write back the range of the dirty
> page instead of write_one_page in preparation of removing write_one_page
> and eventually ->writepage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/refcounttree.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 623db358b1efa8..4a73405962ec4f 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2952,10 +2952,11 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  		 */
>  		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
>  			if (PageDirty(page)) {
> -				/*
> -				 * write_on_page will unlock the page on return
> -				 */
> -				ret = write_one_page(page);
> +				unlock_page(page);
> +				put_page(page);
> +
> +				ret = filemap_write_and_wait_range(mapping,
> +						offset, map_end - 1);
>  				goto retry;
>  			}
>  		}
> -- 
> 2.35.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
