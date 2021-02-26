Return-Path: <SRS0=7w/S=H4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6DBC433DB
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 19:05:08 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 749A664ED5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 19:05:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 749A664ED5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QIwq6o107883;
	Fri, 26 Feb 2021 19:05:07 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 36vr62dcaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Feb 2021 19:05:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QJ4g4O102405;
	Fri, 26 Feb 2021 19:05:06 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucc303ta-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 26 Feb 2021 19:05:06 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFiQD-0007cA-GI; Fri, 26 Feb 2021 11:05:05 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <djwong@kernel.org>) id 1lFiQB-0007bm-Dq
	for ocfs2-devel@oss.oracle.com; Fri, 26 Feb 2021 11:05:03 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11QJ4gV8102345
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 19:05:03 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 36ucc303pg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 19:05:03 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11QJ51CO016209
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 19:05:02 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by userp2040.oracle.com with ESMTP id 36wskfyqx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 19:05:02 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B1D464F1B;
	Fri, 26 Feb 2021 19:04:55 +0000 (UTC)
Date: Fri, 26 Feb 2021 11:04:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Message-ID: <20210226190454.GD7272@magnolia>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <OSBPR01MB2920899F1D71E7B054A04E39F49D9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
X-PDR: PASS
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx a:sjc.edge.kernel.org a:ewr.edge.kernel.org
	a:ams.edge.kernel.org a:nrt.edge.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_safe policy=tap score=0 classifier=
	adjust=0 reason=safe
	scancount=1 engine=8.12.0-2009150000 definitions=main-2102260138
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: "y-goto@fujitsu.com" <y-goto@fujitsu.com>, "jack@suse.cz" <jack@suse.cz>,
        "fnstml-iaas@cn.fujitsu.com" <fnstml-iaas@cn.fujitsu.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260139
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1034 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260138

On Fri, Feb 26, 2021 at 09:45:45AM +0000, ruansy.fnst@fujitsu.com wrote:
> Hi, guys
> 
> Beside this patchset, I'd like to confirm something about the
> "EXPERIMENTAL" tag for dax in XFS.
> 
> In XFS, the "EXPERIMENTAL" tag, which is reported in waring message
> when we mount a pmem device with dax option, has been existed for a
> while.  It's a bit annoying when using fsdax feature.  So, my initial
> intention was to remove this tag.  And I started to find out and solve
> the problems which prevent it from being removed.
> 
> As is talked before, there are 3 main problems.  The first one is "dax
> semantics", which has been resolved.  The rest two are "RMAP for
> fsdax" and "support dax reflink for filesystem", which I have been
> working on.  

<nod>

> So, what I want to confirm is: does it means that we can remove the
> "EXPERIMENTAL" tag when the rest two problem are solved?

Yes.  I'd keep the experimental tag for a cycle or two to make sure that
nothing new pops up, but otherwise the two patchsets you've sent close
those two big remaining gaps.  Thank you for working on this!

> Or maybe there are other important problems need to be fixed before
> removing it?  If there are, could you please show me that?

That remains to be seen through QA/validation, but I think that's it.

Granted, I still have to read through the two patchsets...

--D

> 
> Thank you.
> 
> 
> --
> Ruan Shiyang.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
