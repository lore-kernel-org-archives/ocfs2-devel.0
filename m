Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AF3C432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 19:33:34 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CC9DC60ED3
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 19:33:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CC9DC60ED3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RHD4pe025386;
	Fri, 27 Aug 2021 19:33:33 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aq1kvgqfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 19:33:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RJVdmg109266;
	Fri, 27 Aug 2021 19:33:31 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3akb92p0ev-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 19:33:31 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJhbW-0003Nl-MM; Fri, 27 Aug 2021 12:33:30 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mJhbQ-0003NF-UL
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 12:33:25 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RJVdMV109282
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:33:24 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3akb92p07q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:33:23 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RIk5WO015147
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:33:22 GMT
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com
	[209.85.208.173])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq08umbr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:33:21 +0000
Received: by mail-lj1-f173.google.com with SMTP id q21so13263239ljj.6
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 12:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=noHCPSrtAkyzCrVsyQD6F8PSfdWl+QDD2xq/GV377n4=;
	b=dO24ihNKdKaNOX3mgNRLptmgbhwqDjMzsoFbYMeRZ0OvQNBolhrmFkp/jbMubIHS/0
	yDU8KdUCejLko9uTiCQkKud/ItZA5mGNbugVpCH/kvyo9BZnNLD0GOIBNF0RFXk6ikVn
	5cMp9/iUpaDxsoDVnIoSrNyy5/MUvSsjufPKx8AjjEN0aSIIDGIqH3BTubrcV9njZben
	q42CDqlDriquEjZAePilT75yqhWWdCr0Bvi/rRG9//6/tkjfpc68dkCoYaFul2uC6/M1
	4rEctNPXigOmXn7W3fYfJjE0xjhfPL+bsUtqnHdYuEJzDOnVJfh6sLEV899ky35d+tQh
	Tjgg==
X-Gm-Message-State: AOAM531gN7Jsg5qHdItHEhRldC+ymcIaE13ZTh+jsdJw/dagneGx3A5H
	0Yj6HfQ5nkFDc20srhNOGAKGsAcIvgPpLXng
X-Google-Smtp-Source: ABdhPJyVUkLXUaDdCWPUZw1rLn7Hg/OFaNTVwLcVfkPJqPNXjio6mSvn2CGGWOMRQCBFDNKkNc8x4A==
X-Received: by 2002:a2e:b050:: with SMTP id d16mr8980264ljl.282.1630092798812; 
	Fri, 27 Aug 2021 12:33:18 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com.
	[209.85.208.174])
	by smtp.gmail.com with ESMTPSA id s9sm773700ljp.34.2021.08.27.12.33.17
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 27 Aug 2021 12:33:17 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id p15so13286384ljn.3
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 12:33:17 -0700 (PDT)
X-Received: by 2002:a05:651c:908:: with SMTP id
	e8mr8956231ljq.507.1630092796791; 
	Fri, 27 Aug 2021 12:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-6-agruenba@redhat.com>
	<YSkz025ncjhyRmlB@zeniv-ca.linux.org.uk>
	<CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
In-Reply-To: <YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Aug 2021 12:33:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
Message-ID: <CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Source-IP: 209.85.208.173
X-ServerName: mail-lj1-f173.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	adultscore=0 clxscore=383
	malwarescore=0 bulkscore=0 impostorscore=0 mlxlogscore=893
	priorityscore=323 mlxscore=0 suspectscore=0 spamscore=0
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108270113 domainage_hfrom=5365
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270113
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270113
X-Proofpoint-GUID: xeKlLyhDIzNXBAvBtMX9lSBx3kqUAjDp
X-Proofpoint-ORIG-GUID: xeKlLyhDIzNXBAvBtMX9lSBx3kqUAjDp

On Fri, Aug 27, 2021 at 12:23 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Could you show the cases where "partial copy, so it's OK" behaviour would
> break anything?

Absolutely.

For example, i t would cause an infinite loop in
restore_fpregs_from_user() if the "buf" argument is a situation where
the first page is fine, but the next page is not.

Why? Because __restore_fpregs_from_user() would take a fault, but then
fault_in_pages_readable() (renamed) would succeed, so you'd just do
that "retry" forever and ever.

Probably there are a number of other places too. That was literally
the *first* place I looked at.

Seriously. The current semantics are "check the whole area".

THOSE MUST NOT CHANGE.

              Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
