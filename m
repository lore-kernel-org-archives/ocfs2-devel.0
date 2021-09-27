Return-Path: <SRS0=/tXN=OR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D0AC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 27 Sep 2021 07:50:27 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8792360F4F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 27 Sep 2021 07:50:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8792360F4F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R6xpn4017458;
	Mon, 27 Sep 2021 07:50:25 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bap3eany6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Sep 2021 07:50:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18R7oI9Q104508;
	Mon, 27 Sep 2021 07:50:23 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3badhqknta-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 27 Sep 2021 07:50:23 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mUlOn-0004jG-Be; Mon, 27 Sep 2021 00:50:05 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1mUlOl-0004ir-ID
	for ocfs2-devel@oss.oracle.com; Mon, 27 Sep 2021 00:50:03 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18R7fQrO102236
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:50:03 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3b9stc5597-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:50:03 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18R42A1d020169
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:50:02 GMT
Received: from out30-133.freemail.mail.aliyun.com
	(out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by mx0b-00069f01.pphosted.com with ESMTP id 3basdnrkn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 27 Sep 2021 07:50:01 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R751e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UpjynXy_1632728984; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UpjynXy_1632728984) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 27 Sep 2021 15:49:45 +0800
To: Gang He <GHe@suse.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "Markov, Andrey" <Markov.Andrey@Dell.com>,
        Junxiao Bi <junxiao.bi@oracle.com>
References: <AM6PR04MB6488C35E2103DFC0BF4AF896CFA79@AM6PR04MB6488.eurprd04.prod.outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <816ee511-5764-aeed-4554-83b91de8e06e@linux.alibaba.com>
Date: Mon, 27 Sep 2021 15:49:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <AM6PR04MB6488C35E2103DFC0BF4AF896CFA79@AM6PR04MB6488.eurprd04.prod.outlook.com>
Content-Language: en-US
X-Source-IP: 115.124.30.133
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10119
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	lowpriorityscore=0
	phishscore=0 spamscore=0 clxscore=241 adultscore=0 mlxlogscore=999
	priorityscore=78 bulkscore=0 impostorscore=0 mlxscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2109270053 domainage_hfrom=8201
X-Spam: Clean
Subject: Re: [Ocfs2-devel] The last part of the file is zeroed out when
 write N random bytes
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10119 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270053
X-Proofpoint-GUID: HC4v5h1VuVOUVCpJV39hy4-FmEPdxaw0
X-Proofpoint-ORIG-GUID: HC4v5h1VuVOUVCpJV39hy4-FmEPdxaw0


Last week, Andrey Markov reported a similar issue, but unfortunately not
on mail list.

And Junxiao has resolved a similar issue recently. So can you reproduce
the bug in latest kernel?

Thanks,
Joseph

On 9/27/21 3:16 PM, Gang He wrote:
> Hi List,
> 
> I'd like to report a data loss bug when write N random bytes, since I saw there were some related commits in the past weeks.
> I can reproduce this bug stably with the latest ocfs2 kernel module code as below,
> 1) Create a three node(e.g. ghe-tw-nd1, ghe-tw-nd2, ghe-tw-nd3) ocfs2 cluster, attach a shared disk(e.g. /dev/vdb).
> 2) Format the disk with the command "mkfs.ocfs2 -N 4 -b 4096 -C 1048576 /dev/vdb", and mount the disk to /mnt/shared on each node. The cluster size must be greater than 4K, this is the key to the problem.
> 3) Copy the file write/test scripts to /mnt/shared directory, then run test script on node1 to reproduce this bug. 
>     file write script ocfs2_fallocate_bug_plain_write.py: https://pastebin.com/QsXcD8rq
>     file test script ocfs2_loop.sh: https://pastebin.com/eTUe2hkW
> 4) Then, you can meet this bug, the file md5sum is different between from node1 and from node2.
>     In fact, the last part of the file is zeroed out from node2.
>     e.g.
>     file dump from node1: https://pastebin.com/HB92TVS0
>     file dump from node2: https://pastebin.com/jBG7HdSz
> 
> More information, 
> this bug does not exist on some old kernels( e.g. linux-4.12.14-120), but it will happen on some new kernels, I feel this bug is probably NOT caused by ocfs2 commits, since I used old ocfs2 kernel module code on the new kernels, the problem also happened.
> Anyway, if you have any comments, please reply this mail.
>  
> Thanks
> Gang
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
