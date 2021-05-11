Return-Path: <SRS0=6hlh=KG=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31173C433ED
	for <ocfs2-devel@archiver.kernel.org>; Tue, 11 May 2021 13:55:57 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 97A2861400
	for <ocfs2-devel@archiver.kernel.org>; Tue, 11 May 2021 13:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97A2861400
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BDro0l008805;
	Tue, 11 May 2021 13:55:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : references : mime-version : in-reply-to : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=v4r0K3+me2ZD6PlTTSurYkgt0ur2MGGp1IkI7Cx++r8=;
 b=RC1UN4UvyKjYnQ+1ntO5J2loggimP0/7UG5nRdGHXC2neeqtRXk82IRUDDkETxLYAJdl
 GXrWDcL6c0ou6qnul0lk37VAHmUdu1Nb8j2rf+osoqbtsRFUWSIbuyRn1hcKeMHcGUUf
 Sg4gNpikz8+FUtlv2IL+iJQZtGgq1YZcTcHdtRp8CEAtsUjkUUxXlLbc1t58+LO12S9b
 xc2uQdez0jSjkGxxqh7e08SllXcx+eUv1j93jIRWXP5ybFOv6/7GlRY98BykGq/436Qd
 nwnCxyxCdMZR3YRgM1lCzsJ5ynXP+z0pPzJzPCr/3npwW+dt3H/wrQyB2s6hwTy8xs1v Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 38dg5bewct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 May 2021 13:55:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BDo063160902;
	Tue, 11 May 2021 13:55:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38fh3ws7q5-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 11 May 2021 13:55:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lgSoW-0001tC-H7; Tue, 11 May 2021 06:52:44 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.carpenter@oracle.com>) id 1lgSoT-0001s5-Ef
	for ocfs2-devel@oss.oracle.com; Tue, 11 May 2021 06:52:41 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14BDo1Qs161114
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 13:52:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by userp3020.oracle.com with ESMTP id 38fh3ws4cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 13:52:41 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14BDqepd172306
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 13:52:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userp3020.oracle.com with ESMTP id 38fh3ws4c4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 May 2021 13:52:40 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14BDqbBH003928;
	Tue, 11 May 2021 13:52:38 GMT
Received: from kadam (/102.36.221.92) by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Tue, 11 May 2021 06:52:37 -0700
Date: Tue, 11 May 2021 16:52:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <20210511135229.GU1955@kadam>
References: <YJovRPdOiaU6I+JK@mwanda>
	<bd7ddc22-11c4-3e88-120a-d68f153f573d@linux.alibaba.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bd7ddc22-11c4-3e88-120a-d68f153f573d@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix snprintf() checking
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110107
X-Proofpoint-GUID: TfehUbDHjW_SxxK9UGQ_DsB5-K9jC8cS
X-Proofpoint-ORIG-GUID: TfehUbDHjW_SxxK9UGQ_DsB5-K9jC8cS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110107

On Tue, May 11, 2021 at 08:54:53PM +0800, Joseph Qi wrote:
> 
> 
> On 5/11/21 3:16 PM, Dan Carpenter wrote:
> > The snprintf() function returns the number of bytes which would have
> > been printed if the buffer was large enough.  In other words it can
> > return ">= remain" but this code assumes it returns "== remain".
> > 
> > The run time impact of this bug is not very severe.  The next iteration
> > through the loop would trigger a WARN() when we pass a negative limit
> > to snprintf().  We would then return success instead of -E2BIG.
> > 
> > The kernel implementation of snprintf() will never return negatives so
> > there is no need to check and I have deleted that dead code.
> > 
> > Fixes: a860f6eb4c6a ("ocfs2: sysfile interfaces for online file check")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Looks good. But the last 2 sections are introduced by:
> 74ae4e104dfc ocfs2: Create stack glue sysfs files.
> 
> With 'Fixes' tag updated,
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 

Thanks!  Will do.

regards,
dan carpenter


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
