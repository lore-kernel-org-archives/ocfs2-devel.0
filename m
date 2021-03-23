Return-Path: <SRS0=wAx7=IV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B3DC433C1
	for <ocfs2-devel@archiver.kernel.org>; Tue, 23 Mar 2021 16:10:24 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 427A2619AE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 23 Mar 2021 16:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 427A2619AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NG4EWk018787;
	Tue, 23 Mar 2021 16:10:23 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 37d6jbfsea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Mar 2021 16:10:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NG0CSm001584;
	Tue, 23 Mar 2021 16:10:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 37dtts50q8-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 23 Mar 2021 16:10:22 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lOjbp-0005cv-5O; Tue, 23 Mar 2021 09:10:21 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <riteshh@linux.ibm.com>) id 1lOjbl-0005cW-UW
	for ocfs2-devel@oss.oracle.com; Tue, 23 Mar 2021 09:10:17 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12NG0QtM036285
	for <ocfs2-devel@oss.oracle.com>; Tue, 23 Mar 2021 16:10:17 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 37dtxyernh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 23 Mar 2021 16:10:17 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12NG3XM3047590
	for <ocfs2-devel@oss.oracle.com>; Tue, 23 Mar 2021 16:10:16 GMT
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) by userp2040.oracle.com with ESMTP id 37d7nurnh7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 23 Mar 2021 16:10:16 +0000
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	12NG4L4N002219; Tue, 23 Mar 2021 12:10:02 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com
	[149.81.74.108])
	by mx0b-001b2d01.pphosted.com with ESMTP id 37fkh28e09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 23 Mar 2021 12:10:02 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id
	12NG3oV4016988; Tue, 23 Mar 2021 16:09:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
	(b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma05fra.de.ibm.com with ESMTP id 37d9a6hts4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 23 Mar 2021 16:09:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com
	[9.149.105.62])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 12NG8jwv34799932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Tue, 23 Mar 2021 16:08:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CA67AE057;
	Tue, 23 Mar 2021 16:09:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CC58AE051;
	Tue, 23 Mar 2021 16:09:00 +0000 (GMT)
Received: from [9.199.34.65] (unknown [9.199.34.65])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 23 Mar 2021 16:09:00 +0000 (GMT)
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org
References: <20210319015237.993880-1-ruansy.fnst@fujitsu.com>
	<20210319015237.993880-5-ruansy.fnst@fujitsu.com>
From: Ritesh Harjani <riteshh@linux.ibm.com>
Message-ID: <985f720c-0cf0-5ada-4df4-3405d5969b8d@linux.ibm.com>
Date: Tue, 23 Mar 2021 21:38:59 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210319015237.993880-5-ruansy.fnst@fujitsu.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369, 18.0.761
	definitions=2021-03-23_07:2021-03-22,
	2021-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	phishscore=0 suspectscore=0
	priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 spamscore=0
	lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
	clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103230118
X-PDR: PASS
X-Source-IP: 148.163.158.5
X-ServerName: mx0b-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 suspectscore=0
	phishscore=0 adultscore=0 impostorscore=0 clxscore=221 mlxscore=0
	mlxlogscore=999 bulkscore=0 spamscore=0 priorityscore=194
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103230118
X-Spam: Clean
Cc: jack@suse.cz, darrick.wong@oracle.com, david@fromorbit.com,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v3 04/10] fsdax: Introduce
	dax_iomap_cow_copy()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230118
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230118



On 3/19/21 7:22 AM, Shiyang Ruan wrote:
> In the case where the iomap is a write operation and iomap is not equal
> to srcmap after iomap_begin, we consider it is a CoW operation.
> 
> The destance extent which iomap indicated is new allocated extent.
> So, it is needed to copy the data from srcmap to new allocated extent.
> In theory, it is better to copy the head and tail ranges which is
> outside of the non-aligned area instead of copying the whole aligned
> range. But in dax page fault, it will always be an aligned range.  So,
> we have to copy the whole range in this case.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/dax.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 66 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index a70e6aa285bb..181aad97136a 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1037,6 +1037,51 @@ static int dax_iomap_direct_access(struct iomap *iomap, loff_t pos, size_t size,
>   	return rc;
>   }
>   
> +/*
> + * Copy the head and tail part of the pages not included in the write but
> + * required for CoW, because pos/pos+length are not page aligned.  But in dax
> + * page fault case, the range is page aligned, we need to copy the whole range
> + * of data.  Use copy_edge to distinguish these cases.
> + */


Is this version better? Feel free to update/change.

dax_iomap_cow_copy(): This can be called from two places.
Either during DAX write fault, to copy the length size data to daddr.
Or, while doing normal DAX write operation, dax_iomap_actor() might call 
this to do the copy of either start or end unaligned address. In this 
case the rest of the copy of aligned ranges is taken care by 
dax_iomap_actor() itself.
Also, note DAX fault will always result in aligned pos and pos + length.

* @pos:		address to do copy from.
* @length:	size of copy operation.
* @align_size:	aligned w.r.t align_size (either PMD_SIZE or PAGE_SIZE)
* @srcmap:	iomap srcmap
* @daddr: 	destination address to copy to.

> +static int dax_iomap_cow_copy(loff_t pos, loff_t length, size_t align_size,
> +		struct iomap *srcmap, void *daddr, bool copy_edge)

do we need bool copy_edge here?
We can detect non-align case directly if head_off != pos or pd_end != 
end no?


> +{
> +	loff_t head_off = pos & (align_size - 1);
> +	size_t size = ALIGN(head_off + length, align_size);
> +	loff_t end = pos + length;
> +	loff_t pg_end = round_up(end, align_size);
> +	void *saddr = 0;
> +	int ret = 0;
> +
> +	ret = dax_iomap_direct_access(srcmap, pos, size, &saddr, NULL);
> +	if (ret)
> +		return ret;
> +
> +	if (!copy_edge)
> +		return copy_mc_to_kernel(daddr, saddr, length);
> +
> +	/* Copy the head part of the range.  Note: we pass offset as length. */
> +	if (head_off) {
> +		if (saddr)
> +			ret = copy_mc_to_kernel(daddr, saddr, head_off);
> +		else
> +			memset(daddr, 0, head_off);
> +	}
> +	/* Copy the tail part of the range */
> +	if (end < pg_end) {
> +		loff_t tail_off = head_off + length;
> +		loff_t tail_len = pg_end - end;
> +
> +		if (saddr)
> +			ret = copy_mc_to_kernel(daddr + tail_off,
> +					saddr + tail_off, tail_len);
> +		else
> +			memset(daddr + tail_off, 0, tail_len);
> +	}

Can you pls help me understand in which case where saddr is 0 and we
will fall back to memset API ?
I was thinking shouldn't such restrictions be coded inside 
copy_mc_to_kernel() function in general?


-ritesh

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
