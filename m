Return-Path: <SRS0=40Y/=PQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013D0C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Oct 2021 07:45:02 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5E22A610CF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Oct 2021 07:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5E22A610CF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19S7XIjc027398;
	Thu, 28 Oct 2021 07:45:00 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3byja28ytp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Oct 2021 07:45:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19S7Zx4j000713;
	Thu, 28 Oct 2021 07:44:59 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bx4gsbftc-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Oct 2021 07:44:59 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mg05q-0008FR-42; Thu, 28 Oct 2021 00:44:58 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mg05Q-0008EJ-CN
	for ocfs2-devel@oss.oracle.com; Thu, 28 Oct 2021 00:44:32 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19S7Zx4W000713
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 07:44:32 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3bx4gsbf49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 07:44:31 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19S00Yqh012124
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 07:44:31 GMT
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
	[47.88.44.36])
	by mx0b-00069f01.pphosted.com with ESMTP id 3by9q2a38x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Oct 2021 07:44:30 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R781e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
	TI=SMTPD_---0Utz8PDJ_1635407055; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Utz8PDJ_1635407055) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 28 Oct 2021 15:44:16 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
References: <20211025150008.29002-1-jack@suse.cz>
	<20211025151332.11301-1-jack@suse.cz>
	<f8c309cf-ace7-f8c7-33d2-9a5fa39cb21b@linux.alibaba.com>
Message-ID: <7b6b56f5-e040-1d85-d7a7-e43bf2dcc1fe@linux.alibaba.com>
Date: Thu, 28 Oct 2021 15:44:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f8c309cf-ace7-f8c7-33d2-9a5fa39cb21b@linux.alibaba.com>
Content-Language: en-US
X-Source-IP: 47.88.44.36
X-ServerName: out4436.biz.mail.alibaba.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	phishscore=0
	malwarescore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=909
	bulkscore=0
	clxscore=211 suspectscore=0 adultscore=0 priorityscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000
	definitions=main-2110280038 domainage_hfrom=8232
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280038
X-Proofpoint-GUID: 2fuoUqeY7g9ftC8dyuO1Fy_BNsVR8LZG
X-Proofpoint-ORIG-GUID: 2fuoUqeY7g9ftC8dyuO1Fy_BNsVR8LZG



On 10/28/21 3:09 PM, Joseph Qi wrote:
> Hi Jan,
> 
> On 10/25/21 11:13 PM, Jan Kara wrote:
>> ocfs2_truncate_file() did unmap invalidate page cache pages before
>> zeroing partial tail cluster and setting i_size. Thus some pages could
>> be left (and likely have left if the cluster zeroing happened) in the
>> page cache beyond i_size after truncate finished letting user possibly
>> see stale data once the file was extended again. Also the tail cluster
> 
> I don't quite understand the case. 
> truncate_inode_pages() will truncate pages from new_i_size to i_size,
> and the following ocfs2_orphan_for_truncate() will zero range and then
> update i_size for inode as well as dinode.
> So once truncate finished, how stale data exposing happens? Or do you
> mean a race case between the above two steps?
> 
Or do you mean ocfs2_zero_range_for_truncate() will grab and zero eof
pages? Though it depends on block_write_full_page() to write out, the
pages are zeroed now. Still a little confused...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
