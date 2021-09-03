Return-Path: <SRS0=CWw2=NZ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80B1C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 05:00:48 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4FD156056C
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Sep 2021 05:00:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4FD156056C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 182MsRCc002824;
	Fri, 3 Sep 2021 05:00:47 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3atdw1cwqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Sep 2021 05:00:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1834xxC0034712;
	Fri, 3 Sep 2021 05:00:46 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3ate010a28-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 03 Sep 2021 05:00:45 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mM1De-0006Zr-Pk; Thu, 02 Sep 2021 21:54:26 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <gregkh@linuxfoundation.org>) id 1mM1Dc-0006ZT-05
	for ocfs2-devel@oss.oracle.com; Thu, 02 Sep 2021 21:54:24 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1834nskZ087920
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 04:54:23 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3atdyy0nxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 04:54:23 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	182N0BVx015716
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 04:54:23 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3au7wc3499-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 04:54:22 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC00360FDA;
	Fri,  3 Sep 2021 04:54:20 +0000 (UTC)
Date: Fri, 3 Sep 2021 06:54:18 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Message-ID: <YTGqekh95kH5U5F1@kroah.com>
References: <20210903012631.6099-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210903012631.6099-1-wen.gang.wang@oracle.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10095
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	spamscore=0
	impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
	mlxlogscore=328
	priorityscore=211 clxscore=324 adultscore=0 mlxscore=0
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2108310000 definitions=main-2109030029
X-Spam: Clean
Cc: stable@vger.kernel.org, ocfs2-devel@oss.oracle.com
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10095 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030030
X-Proofpoint-GUID: 4y_PxUmEPQ-BRh9kP3Dcz5qwq12dPuik
X-Proofpoint-ORIG-GUID: 4y_PxUmEPQ-BRh9kP3Dcz5qwq12dPuik

On Thu, Sep 02, 2021 at 06:26:31PM -0700, Wengang Wang wrote:
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
> -- 
> 2.21.0 (Apple Git-122.2)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
