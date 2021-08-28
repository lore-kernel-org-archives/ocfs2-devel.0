Return-Path: <SRS0=LbgC=OD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176F0C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:32:03 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D08FA60555
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D08FA60555
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DESqtJ014885;
	Mon, 13 Sep 2021 14:32:02 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b1k1sau8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 14:32:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DEVNOI105353;
	Mon, 13 Sep 2021 14:31:58 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3b167qhbcc-1;
	Mon, 13 Sep 2021 14:31:58 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPmwy-0004cf-GF; Mon, 13 Sep 2021 07:28:48 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <tony.luck@intel.com>) id 1mJnx5-0006S2-SR
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 19:20:11 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17S2I1st170196
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 02:20:11 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3aqa8tn45g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 02:20:10 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RKpIvl015209
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 02:20:09 GMT
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq7esjb8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 02:20:09 +0000
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="218094817"
X-IronPort-AV: E=Sophos;i="5.84,358,1620716400"; d="scan'208";a="218094817"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
	by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Aug 2021 19:20:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,358,1620716400"; d="scan'208";a="528533365"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
	by FMSMGA003.fm.intel.com with ESMTP; 27 Aug 2021 19:20:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
	fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2242.10; Fri, 27 Aug 2021 19:20:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
	fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2242.10; Fri, 27 Aug 2021 19:20:06 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
	fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id
	15.01.2242.010; Fri, 27 Aug 2021 19:20:06 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, Al Viro <viro@zeniv.linux.org.uk>
Thread-Topic: [PATCH v7 05/19] iov_iter: Introduce fault_in_iov_iter_writeable
Thread-Index: AQHXm5pzAH4qSaa/BkWiD/swcmZu0auILsxw
Date: Sat, 28 Aug 2021 02:20:05 +0000
Message-ID: <ace2140100e6409a876984fafbb9cbde@intel.com>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-6-agruenba@redhat.com>
	<YSkz025ncjhyRmlB@zeniv-ca.linux.org.uk>
	<CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSlftta38M4FsWUq@zeniv-ca.linux.org.uk>
	<20210827232246.GA1668365@agluck-desk2.amr.corp.intel.com>
In-Reply-To: <20210827232246.GA1668365@agluck-desk2.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
MIME-Version: 1.0
X-Source-IP: 134.134.136.65
X-ServerName: mga03.intel.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.intel.com include:_spf.google.com
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	bulkscore=0 clxscore=313
	mlxlogscore=356 impostorscore=0 lowpriorityscore=0 phishscore=0
	spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 priorityscore=259
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108280012 domainage_hfrom=12940
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	bulkscore=0 spamscore=0
	adultscore=0 malwarescore=0 mlxlogscore=379 phishscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108280012
X-Mailman-Approved-At: Mon, 13 Sep 2021 07:28:45 -0700
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH v7 05/19] iov_iter: Introduce
	fault_in_iov_iter_writeable
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130096
X-Proofpoint-ORIG-GUID: yHmhqop_vBTcOkcy0wM08fOPXfTTnOCe
X-Proofpoint-GUID: yHmhqop_vBTcOkcy0wM08fOPXfTTnOCe

> But if your kernel code loops and tries again without a return to user,
> then your get another #MC.

I've been trying to push this patch:

https://lore.kernel.org/linux-edac/20210818002942.1607544-1-tony.luck@intel.com/

which turns the infinite loops of machine checks into a panic.

-Tony

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
