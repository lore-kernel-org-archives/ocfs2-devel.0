Return-Path: <SRS0=DEil=N4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4ABC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Sep 2021 11:43:10 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EB4036056B
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Sep 2021 11:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EB4036056B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1868EBg0030749;
	Mon, 6 Sep 2021 11:43:09 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3avw152843-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Sep 2021 11:43:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 186BeBOJ065091;
	Mon, 6 Sep 2021 11:43:07 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3avqtc8g1v-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 06 Sep 2021 11:43:07 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mND1m-000584-Ng; Mon, 06 Sep 2021 04:43:06 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mND1i-00057e-Ns
	for ocfs2-devel@oss.oracle.com; Mon, 06 Sep 2021 04:43:02 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	186BeiF8188705
	for <ocfs2-devel@oss.oracle.com>; Mon, 6 Sep 2021 11:43:02 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3auwwv900j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 06 Sep 2021 11:43:02 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	1865pcKN032267
	for <ocfs2-devel@oss.oracle.com>; Mon, 6 Sep 2021 11:43:01 GMT
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
	[47.88.44.36])
	by mx0b-00069f01.pphosted.com with ESMTP id 3avy8h12su-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 06 Sep 2021 11:43:00 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
	TI=SMTPD_---0UnSoHfI_1630928563; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UnSoHfI_1630928563) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 06 Sep 2021 19:42:44 +0800
To: Wengang Wang <wen.gang.wang@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20210903012631.6099-1-wen.gang.wang@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <9e8cbfe1-527f-0e75-ba9b-8bcea674645d@linux.alibaba.com>
Date: Mon, 6 Sep 2021 19:42:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210903012631.6099-1-wen.gang.wang@oracle.com>
Content-Language: en-US
X-Source-IP: 47.88.44.36
X-ServerName: out4436.biz.mail.alibaba.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10098
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
	clxscore=211
	malwarescore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
	mlxlogscore=999 bulkscore=0 priorityscore=0 phishscore=0 mlxscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2108310000 definitions=main-2109060074
	domainage_hfrom=8180
X-Spam: Clean
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: drop acl cache for directories too
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10098 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060074
X-Proofpoint-GUID: 2rdCGikPuVsdXGkvn_FfLbijIM45RrNF
X-Proofpoint-ORIG-GUID: 2rdCGikPuVsdXGkvn_FfLbijIM45RrNF



On 9/3/21 9:26 AM, Wengang Wang wrote:
> ocfs2_data_convert_worker() is currently dropping any cached acl info
> for FILE before down-converting meta lock. It should also drop for DIRECTORY.
> Otherwise the second acl lookup returns the cached one (from VFS layer) which
> could be already stale.
> 
> The problem we are seeing is that the acl changes on one node doesn't get
> refreshed on other nodes in the following case:
> 
>   Node 1                    Node 2
> --------------            ----------------
> getfacl dir1
> 
> 			  getfacl dir1    <-- this is OK
> 
> setfacl -m u:user1:rwX dir1
> getfacl dir1   <-- see the change for user1
> 
> 			  getfacl dir1    <-- can't see change for user1
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

Looks sane to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlmglue.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 50a863fc1779..207ec61569ea 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3933,7 +3933,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
>  		oi = OCFS2_I(inode);
>  		oi->ip_dir_lock_gen++;
>  		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
> -		goto out;
> +		goto out_forget;
>  	}
>  
>  	if (!S_ISREG(inode->i_mode))
> @@ -3964,6 +3964,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
>  		filemap_fdatawait(mapping);
>  	}
>  
> +out_forget:
>  	forget_all_cached_acls(inode);
>  
>  out:
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
