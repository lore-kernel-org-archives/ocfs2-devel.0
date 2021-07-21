Return-Path: <SRS0=C0ey=MN=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25F4C07E9B
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jul 2021 01:58:16 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 41FF5611C1
	for <ocfs2-devel@archiver.kernel.org>; Wed, 21 Jul 2021 01:58:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41FF5611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16L1qFxP020809;
	Wed, 21 Jul 2021 01:58:15 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39w9hfv2qt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jul 2021 01:58:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16L1oLqe112776;
	Wed, 21 Jul 2021 01:58:14 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 39v8ywb1ag-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 21 Jul 2021 01:58:14 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m61Rv-0004Qj-Hn; Tue, 20 Jul 2021 18:55:03 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1m61RQ-0004Pk-8R
	for ocfs2-devel@oss.oracle.com; Tue, 20 Jul 2021 18:54:32 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16L1oUtr031990
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Jul 2021 01:54:31 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 39umb1mhsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Jul 2021 01:54:31 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16L1qBR0008903
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Jul 2021 01:54:30 GMT
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by mx0b-00069f01.pphosted.com with ESMTP id 39x1b0vq0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 21 Jul 2021 01:54:30 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
	TI=SMTPD_---0UgT.GF4_1626832465; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UgT.GF4_1626832465) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 21 Jul 2021 09:54:25 +0800
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com,
        akpm <akpm@linux-foundation.org>
References: <20210713211306.50593-1-junxiao.bi@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <9ce2351f-bba3-41e4-c8c9-80fb65683943@linux.alibaba.com>
Date: Wed, 21 Jul 2021 09:54:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713211306.50593-1-junxiao.bi@oracle.com>
Content-Language: en-US
X-Source-IP: 115.124.30.131
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	adultscore=0 suspectscore=0
	priorityscore=190 impostorscore=0 mlxscore=0 mlxlogscore=999
	clxscore=206
	phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
	definitions=main-2107210008 domainage_hfrom=8133
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	malwarescore=0 spamscore=0
	mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107210008
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix zero out valid data
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107210008
X-Proofpoint-GUID: wDImH90vsgRDRl5jgsur8Mzd1NRWUDze
X-Proofpoint-ORIG-GUID: wDImH90vsgRDRl5jgsur8Mzd1NRWUDze



On 7/14/21 5:13 AM, Junxiao Bi wrote:
> If append-dio feature is enabled, direct-io write and fallocate could run
> in parallel to extend file size, fallocate used "orig_isize" to record
> i_size before taking "ip_alloc_sem", when ocfs2_zeroout_partial_cluster()
> zeroout EOF blocks, i_size maybe already extended by ocfs2_dio_end_io_write(),
> that will cause valid data zeroed out.
> 
> Fixes: 1733438b1d06 ("ocfs2: fix data corruption by fallocate")

Fixes: 6bba4471f0cc ("ocfs2: fix data corruption by fallocate")

With the above fixed,
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com> 

> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>> Cc: <stable@vger.kernel.org>
> ---
>  fs/ocfs2/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 775657943057..53bb46ce3cbb 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1935,7 +1935,6 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  		goto out_inode_unlock;
>  	}
>  
> -	orig_isize = i_size_read(inode);
>  	switch (sr->l_whence) {
>  	case 0: /*SEEK_SET*/
>  		break;
> @@ -1943,7 +1942,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  		sr->l_start += f_pos;
>  		break;
>  	case 2: /*SEEK_END*/
> -		sr->l_start += orig_isize;
> +		sr->l_start += i_size_read(inode);
>  		break;
>  	default:
>  		ret = -EINVAL;
> @@ -1998,6 +1997,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  		ret = -EINVAL;
>  	}
>  
> +	orig_isize = i_size_read(inode);
>  	/* zeroout eof blocks in the cluster. */
>  	if (!ret && change_size && orig_isize < size) {
>  		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
