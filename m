Return-Path: <SRS0=i0E0=OT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CECC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 20:01:13 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 86522615A2
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Sep 2021 20:01:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 86522615A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=valentin-vidic.from.hr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TJwXin007839;
	Wed, 29 Sep 2021 20:01:10 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bcheps379-16
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Sep 2021 20:01:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TIuV77044732;
	Wed, 29 Sep 2021 19:01:32 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bc3bkeeah-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 29 Sep 2021 19:01:31 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mVemb-0002ru-Gu; Wed, 29 Sep 2021 11:58:21 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <vvidic@valentin-vidic.from.hr>) id 1mVCws-0007gQ-Gx
	for ocfs2-devel@oss.oracle.com; Tue, 28 Sep 2021 06:15:06 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18SDEptQ031696
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 13:15:06 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3bc3ah97vw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 13:15:00 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	18S9Jem8030077
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 13:14:59 GMT
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [109.200.23.17])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bbj89pf9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 28 Sep 2021 13:14:58 +0000
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
	id 83C607082; Tue, 28 Sep 2021 15:14:50 +0200 (CEST)
Date: Tue, 28 Sep 2021 15:14:50 +0200
From: Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <20210928131450.GM28341@valentin-vidic.from.hr>
References: <20210927154459.15976-1-vvidic@valentin-vidic.from.hr>
	<00850aed-2027-a0ab-e801-c6498a5a49f8@linux.alibaba.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <00850aed-2027-a0ab-e801-c6498a5a49f8@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Source-IP: 109.200.23.17
X-ServerName: valentin-vidic.from.hr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
	malwarescore=0
	clxscore=248 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
	suspectscore=0 mlxlogscore=999 impostorscore=0 priorityscore=0
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2109280076
X-Spam: Clean
X-Mailman-Approved-At: Wed, 29 Sep 2021 11:58:19 -0700
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: mount fails with buffer overflow
	in strlen
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290110
X-Proofpoint-ORIG-GUID: 4nJZK4iJaUT2AkdOVJdvWI-9znA9tZW1
X-Proofpoint-GUID: 4nJZK4iJaUT2AkdOVJdvWI-9znA9tZW1

On Tue, Sep 28, 2021 at 08:05:22PM +0800, Joseph Qi wrote:
> strlcpy in ocfs2_initialize_super() is introduced 8 years ago, so I
> don't understand why you've mentioned that the issues starts from
> v5.11.

v5.11 introduced the overflow checks to string functions so that is
when the mount started to fail.

> osb->osb_cluster_stack and osb->osb_cluster_name is always larger by
> 1 than which in ocfs2_cluster_info, and the input size of strlcpy does
> the same, so I don't see how it overflows.

strlcpy internally calls strlen on the source argument, in this case
that is ci_stack array with size of 4. That array stores the value
"o2cb" so the strlen continues reading into the union until it reaches
a zero byte somewhere. The same would happen with ci_cluster if the
cluster name is long enough.

struct ocfs2_cluster_info {
/*00*/	__u8   ci_stack[OCFS2_STACK_LABEL_LEN];
	union {
		__le32 ci_reserved;
		struct {
			__u8 ci_stackflags;
			__u8 ci_reserved1;
			__u8 ci_reserved2;
			__u8 ci_reserved3;
		};
	};
/*08*/	__u8   ci_cluster[OCFS2_CLUSTER_NAME_LEN];
/*18*/
};

-- 
Valentin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
