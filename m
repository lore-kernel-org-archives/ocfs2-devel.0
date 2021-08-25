Return-Path: <SRS0=H3cK=NQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C9FC4338F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 25 Aug 2021 08:30:58 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C946F60ED3
	for <ocfs2-devel@archiver.kernel.org>; Wed, 25 Aug 2021 08:30:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C946F60ED3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P6awQE030398;
	Wed, 25 Aug 2021 08:30:57 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3amv67b2gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Aug 2021 08:30:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17P8FcJ8013566;
	Wed, 25 Aug 2021 08:30:55 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpkyyq6q-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 25 Aug 2021 08:30:55 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mIoG9-00038o-HO; Wed, 25 Aug 2021 01:27:45 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mIoG3-00038N-N6
	for ocfs2-devel@oss.oracle.com; Wed, 25 Aug 2021 01:27:39 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17P8FTfd137531
	for <ocfs2-devel@oss.oracle.com>; Wed, 25 Aug 2021 08:27:39 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3akb8wf7cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 25 Aug 2021 08:27:38 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17P7kUJT026783
	for <ocfs2-devel@oss.oracle.com>; Wed, 25 Aug 2021 08:27:37 GMT
Received: from out30-133.freemail.mail.aliyun.com
	(out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by mx0b-00069f01.pphosted.com with ESMTP id 3anhrqrecg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 25 Aug 2021 08:27:37 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R441e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
	TI=SMTPD_---0Ullo4cF_1629880048; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Ullo4cF_1629880048) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 25 Aug 2021 16:27:29 +0800
To: CGEL <cgel.zte@gmail.com>, Mark Fasheh <mark@fasheh.com>,
        akpm <akpm@linux-foundation.org>
References: <20210825063125.70192-1-deng.changcheng@zte.com.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <6c5bc597-8ab8-ab7e-6005-656660e9a17a@linux.alibaba.com>
Date: Wed, 25 Aug 2021 16:27:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210825063125.70192-1-deng.changcheng@zte.com.cn>
Content-Language: en-US
X-Source-IP: 115.124.30.133
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	clxscore=220
	priorityscore=60 lowpriorityscore=0 malwarescore=0 adultscore=0
	spamscore=0 impostorscore=0 mlxscore=0 phishscore=0 bulkscore=0
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108250050
	domainage_hfrom=8168
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108250050
Cc: Yury Norov <yury.norov@gmail.com>,
        Jing Yangyang <jing.yangyang@zte.com.cn>,
        Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH linux-next] fs/ocfs2/dlm/dlmmaster.c: fix
 bugon.cocci warnings
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108250050
X-Proofpoint-ORIG-GUID: MDdYHb8T30sI6rnVP4cwasl7dJdpctWa
X-Proofpoint-GUID: MDdYHb8T30sI6rnVP4cwasl7dJdpctWa



On 8/25/21 2:31 PM, CGEL wrote:
> From: Jing Yangyang <jing.yangyang@zte.com.cn>
> 
> Use BUG_ON instead of a if condition followed by BUG.
> 
> Generated by: scripts/coccinelle/misc/bugon.cocci
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jing Yangyang <jing.yangyang@zte.com.cn>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlm/dlmmaster.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 227da5b..afaf9a7 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2181,8 +2181,7 @@ static int dlm_pre_master_reco_lockres(struct dlm_ctxt *dlm,
>  		ret = dlm_do_master_requery(dlm, res, nodenum, &master);
>  		if (ret < 0) {
>  			mlog_errno(ret);
> -			if (!dlm_is_host_down(ret))
> -				BUG();
> +			BUG_ON(!dlm_is_host_down(ret));
>  			/* host is down, so answer for that node would be
>  			 * DLM_LOCK_RES_OWNER_UNKNOWN.  continue. */
>  			ret = 0;
> @@ -2238,8 +2237,7 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
>  		mlog(ML_ERROR, "%s: res %.*s, DEREF to node %u got %d\n",
>  		     dlm->name, namelen, lockname, res->owner, r);
>  		dlm_print_one_lock_resource(res);
> -		if (r == -ENOMEM)
> -			BUG();
> +		BUG_ON(r == -ENOMEM);
>  	} else
>  		ret = r;
>  
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
