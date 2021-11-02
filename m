Return-Path: <SRS0=iO0D=PV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F53DC433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Nov 2021 02:37:22 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0223960E73
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Nov 2021 02:37:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0223960E73
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A21QrbI022168;
	Tue, 2 Nov 2021 02:37:21 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c26e8dcc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Nov 2021 02:37:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A22UFNK047547;
	Tue, 2 Nov 2021 02:37:19 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3c1khstbx3-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Nov 2021 02:37:19 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mhjfq-0007SH-O6; Mon, 01 Nov 2021 19:37:18 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mhjfO-0007RN-O4
	for ocfs2-devel@oss.oracle.com; Mon, 01 Nov 2021 19:36:50 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A22Vaa0055943
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Nov 2021 02:36:50 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3c0v3d212e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Nov 2021 02:36:50 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A21E8Ym024428
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Nov 2021 02:36:49 GMT
Received: from out30-43.freemail.mail.aliyun.com
	(out30-43.freemail.mail.aliyun.com [115.124.30.43])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c28n35bfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Nov 2021 02:36:49 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0UufdSBc_1635820602; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UufdSBc_1635820602) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 02 Nov 2021 10:36:43 +0800
To: Jan Kara <jack@suse.cz>
References: <20211025150008.29002-1-jack@suse.cz>
	<20211025151332.11301-1-jack@suse.cz>
	<f8c309cf-ace7-f8c7-33d2-9a5fa39cb21b@linux.alibaba.com>
	<20211101113100.GA18487@quack2.suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <beb87697-e851-9681-bcc4-0669eb210703@linux.alibaba.com>
Date: Tue, 2 Nov 2021 10:36:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211101113100.GA18487@quack2.suse.cz>
Content-Language: en-US
X-Source-IP: 115.124.30.43
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	lowpriorityscore=0
	adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0 spamscore=0
	clxscore=191 suspectscore=0 priorityscore=0 bulkscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000
	definitions=main-2111020010 domainage_hfrom=8237
X-Spam: Clean
Cc: stable@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix data corruption on truncate
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111020010
X-Proofpoint-GUID: 4teGHOcjnu_J58cP62Fsv4EidMU4fNav
X-Proofpoint-ORIG-GUID: 4teGHOcjnu_J58cP62Fsv4EidMU4fNav



On 11/1/21 7:31 PM, Jan Kara wrote:
> On Thu 28-10-21 15:09:08, Joseph Qi wrote:
>> Hi Jan,
>>
>> On 10/25/21 11:13 PM, Jan Kara wrote:
>>> ocfs2_truncate_file() did unmap invalidate page cache pages before
>>> zeroing partial tail cluster and setting i_size. Thus some pages could
>>> be left (and likely have left if the cluster zeroing happened) in the
>>> page cache beyond i_size after truncate finished letting user possibly
>>> see stale data once the file was extended again. Also the tail cluster
>>
>> I don't quite understand the case. 
>> truncate_inode_pages() will truncate pages from new_i_size to i_size,
>> and the following ocfs2_orphan_for_truncate() will zero range and then
>> update i_size for inode as well as dinode.
>> So once truncate finished, how stale data exposing happens? Or do you
>> mean a race case between the above two steps?
> 
> Sorry, I was not quite accurate in the above paragraph. There are several
> ways how stale pages in the pagecache can cause problems.
> 
> 1) Because i_size is reduced after truncating page cache, page fault can
> happen after truncating page cache and zeroing pages but before reducing i_size.
> This will in allow user to arbitrarily modify pages that are used for
> writing zeroes into the cluster tail and after file extension these data
> will become visible.
> 
> 2) The tail cluster zeroing in ocfs2_orphan_for_truncate() can actually try
> to write zeroed pages above i_size (e.g. if we have 4k blocksize, 64k
> clustersize, and do truncate(f, 4k) on a 4k file). This will cause exactly
> same problems as already described in commit 5314454ea3f "ocfs2: fix data
> corruption after conversion from inline format".
> 
> Hope it is clearer now.
> 
So the core reason is ocfs2_zero_range_for_truncate() grabs pages and
then zero, right?
I think an alternative way is using zeroout instead of zero pages, which
won't grab pages again.
Anyway, I'm also fine with your way since it is simple.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
