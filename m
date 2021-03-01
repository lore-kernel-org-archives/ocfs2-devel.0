Return-Path: <SRS0=HAPo=H7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ECDC433E0
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Mar 2021 21:49:05 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4B7A3600EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Mar 2021 21:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B7A3600EF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121LTYD2112497;
	Mon, 1 Mar 2021 21:49:04 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 36ydgr5gb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Mar 2021 21:49:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121LUtGU113368;
	Mon, 1 Mar 2021 21:49:04 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 37000w4pq0-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 01 Mar 2021 21:49:04 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lGqPX-0002Xs-37; Mon, 01 Mar 2021 13:49:03 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <y-goto@fujitsu.com>) id 1lGcxE-00079V-2M
	for ocfs2-devel@oss.oracle.com; Sun, 28 Feb 2021 23:26:56 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1217OsgI053907
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Mar 2021 07:26:55 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 36yyyx3bax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Mar 2021 07:26:55 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1217NAQ9022453
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Mar 2021 07:26:54 GMT
Received: from esa11.hc1455-7.c3s2.iphmx.com (esa11.hc1455-7.c3s2.iphmx.com
	[207.54.90.137]) by userp2040.oracle.com with ESMTP id 36ycpu63rs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Mar 2021 07:26:53 +0000
IronPort-SDR: xHkRAm5doL6iN4c/EDTJisVRrN1S0ZMFlbAW68t/yNX7IOt/Jpj9vCZRT7SuJR7A7o5KoHCIB1
	TnS9Sq6kwx8ZaCyQzqNF6WbZw1f1N1kfDibDVoR2hYdXjZEg89wDAfRicOOeO/Pu8zGO0BFziC
	Z+AF9vu4mnFLSPVuj4JBUXTrvCMiV6riSZkBq2JihevyN6YuXIncA6Q9QskRivZXwkzMI/5iVq
	0X4JIgX4oyeWT2E40LBufJsEqUrLkb4LkOOvw8FAQaCWkq2x+IZDaJw/z0P0x98PXAlvWsuECp
	uaw=
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="1499185"
X-IronPort-AV: E=Sophos;i="5.81,214,1610377200"; 
   d="scan'208";a="1499185"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
	by esa11.hc1455-7.c3s2.iphmx.com with ESMTP; 01 Mar 2021 16:26:47 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com
	[192.168.87.58])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id B364240D3BC
	for <ocfs2-devel@oss.oracle.com>; Mon,  1 Mar 2021 16:26:46 +0900 (JST)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id D0D62B4E24
	for <ocfs2-devel@oss.oracle.com>; Mon,  1 Mar 2021 16:26:45 +0900 (JST)
Received: from [10.133.113.145] (VPC-Y08P0560117.g01.fujitsu.local
	[10.133.113.145])
	by m3050.s.css.fujitsu.com (Postfix) with ESMTP id A473F2A7;
	Mon,  1 Mar 2021 16:26:45 +0900 (JST)
To: Dan Williams <dan.j.williams@intel.com>,
        "Darrick J. Wong" <djwong@kernel.org>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<20210226190454.GD7272@magnolia>
	<CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
From: Yasunori Goto <y-goto@fujitsu.com>
Message-ID: <556921a1-456c-c24d-6d47-e8b15c1d9972@fujitsu.com>
Date: Mon, 1 Mar 2021 16:26:45 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
	Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iJiYsM5FQdpMvCi24aCi7RqUnnxC6sM0umFqiN+Q59cg@mail.gmail.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-PDR: PASS
X-Source-IP: 207.54.90.137
X-ServerName: esa11.hc1455-7.c3s2.iphmx.com
X-Proofpoint-SPF-Result: neutral
X-Proofpoint-SPF-Record: v=spf1 ip4:211.128.242.0/26 ip4:202.219.69.128/26
	ip4:207.54.90.47
	ip4:207.54.90.48 ip4:207.54.90.49 ip4:68.232.139.117 ip4:68.232.139.130
	ip4:68.232.139.139 include:spf.protection.outlook.com
	include:mktomail.com
	mx:fujitsu.com include:spf.messagelabs.com ?all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9909
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	priorityscore=0
	lowpriorityscore=0 malwarescore=0 mlxscore=0 impostorscore=0
	phishscore=0
	bulkscore=0 clxscore=369 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103010059
X-Spam: Clean
X-Mailman-Approved-At: Mon, 01 Mar 2021 13:49:02 -0800
Cc: "jack@suse.cz" <jack@suse.cz>,
        "fnstml-iaas@cn.fujitsu.com" <fnstml-iaas@cn.fujitsu.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] Question about the "EXPERIMENTAL" tag for dax in
	XFS
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103010174
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1011 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010174

Hello, Dan-san,

On 2021/02/27 4:24, Dan Williams wrote:
> On Fri, Feb 26, 2021 at 11:05 AM Darrick J. Wong <djwong@kernel.org> wrote:
>>
>> On Fri, Feb 26, 2021 at 09:45:45AM +0000, ruansy.fnst@fujitsu.com wrote:
>>> Hi, guys
>>>
>>> Beside this patchset, I'd like to confirm something about the
>>> "EXPERIMENTAL" tag for dax in XFS.
>>>
>>> In XFS, the "EXPERIMENTAL" tag, which is reported in waring message
>>> when we mount a pmem device with dax option, has been existed for a
>>> while.  It's a bit annoying when using fsdax feature.  So, my initial
>>> intention was to remove this tag.  And I started to find out and solve
>>> the problems which prevent it from being removed.
>>>
>>> As is talked before, there are 3 main problems.  The first one is "dax
>>> semantics", which has been resolved.  The rest two are "RMAP for
>>> fsdax" and "support dax reflink for filesystem", which I have been
>>> working on.
>>
>> <nod>
>>
>>> So, what I want to confirm is: does it means that we can remove the
>>> "EXPERIMENTAL" tag when the rest two problem are solved?
>>
>> Yes.  I'd keep the experimental tag for a cycle or two to make sure that
>> nothing new pops up, but otherwise the two patchsets you've sent close
>> those two big remaining gaps.  Thank you for working on this!
>>
>>> Or maybe there are other important problems need to be fixed before
>>> removing it?  If there are, could you please show me that?
>>
>> That remains to be seen through QA/validation, but I think that's it.
>>
>> Granted, I still have to read through the two patchsets...
> 
> I've been meaning to circle back here as well.
> 
> My immediate concern is the issue Jason recently highlighted [1] with
> respect to invalidating all dax mappings when / if the device is
> ripped out from underneath the fs. I don't think that will collide
> with Ruan's implementation, but it does need new communication from
> driver to fs about removal events.
> 
> [1]: http://lore.kernel.org/r/CAPcyv4i+PZhYZiePf2PaH0dT5jDfkmkDX-3usQy1fAhf6LPyfw@mail.gmail.com
> 

I'm not sure why there is a race condition between unbinding operation 
and accessing mmaped file on filesystem dax yet.

May be silly question, but could you tell me why the "unbinding" 
operation of the namespace which is mounted by filesystem dax must be
allowed?
If "unbinding" is rejected when the filesystem is mounted with dax 
enabled, what is inconvenience?

I can imagine if a device like usb memory stick is removed surprisingly, 
kernel/filesystem need to reject writeback at the time, and discard page 
cache. Then, I can understand that unbinding operation is essential for 
such case.
But I don't know why PMEM device/namespace allows unbinding operation 
like surprising removal event.

Thanks,

-- 
Yasunori Goto

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
