Return-Path: <SRS0=8K4+=KI=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE631C43461
	for <ocfs2-devel@archiver.kernel.org>; Thu, 13 May 2021 15:01:18 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8A01561439
	for <ocfs2-devel@archiver.kernel.org>; Thu, 13 May 2021 15:01:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A01561439
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DF05eL107962;
	Thu, 13 May 2021 15:01:17 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 38gpnehxt9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 May 2021 15:01:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DF09vj118334;
	Thu, 13 May 2021 15:01:16 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38gppg9fq0-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 13 May 2021 15:01:16 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lhCpu-0003en-Jh; Thu, 13 May 2021 08:01:14 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <rpeterso@redhat.com>) id 1lgRMY-0005yi-4R
	for ocfs2-devel@oss.oracle.com; Tue, 11 May 2021 05:19:46 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14BCFdrH183089
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 12:19:45 GMT
Received: from oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 38dfrx62j5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 12:19:45 +0000
Received: from userp2040.oracle.com (userp2040.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 14BCEVet023344
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 12:19:45 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by userp2040.oracle.com with ESMTP id 38evq0waku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 12:19:44 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-371-I-6271slPRKpjOsvKJ8G7A-1; Tue, 11 May 2021 08:19:40 -0400
X-MC-Unique: I-6271slPRKpjOsvKJ8G7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DE42106BB2D;
	Tue, 11 May 2021 12:19:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com
	(colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3364510190AA;
	Tue, 11 May 2021 12:19:39 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com
	(zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0DAD34BB40;
	Tue, 11 May 2021 12:19:39 +0000 (UTC)
Date: Tue, 11 May 2021 08:19:38 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
To: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <1750769001.24809997.1620735578939.JavaMail.zimbra@redhat.com>
In-Reply-To: <4d120e2e-5eb4-1bbb-cc63-8c3b7c62dac0@oracle.com>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<20210509162306.9de66b1656f04994f3cb5730@linux-foundation.org>
	<4d120e2e-5eb4-1bbb-cc63-8c3b7c62dac0@oracle.com>
MIME-Version: 1.0
X-Originating-IP: [10.3.112.114, 10.4.195.1]
Thread-Topic: fs/buffer.c: add new api to allow eof writeback
Thread-Index: aQPKcUwGH5yqUlPghB6gr17JLe3JLQ==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:13.110.208.0/21
	ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 ip4:148.139.1.2 ip4:148.139.2.2 ip4:148.139.3.2
	ip4:149.72.0.0/16 ip4:149.96.1.26 ip4:149.96.13.2 ip4:149.96.132.2
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-PDR: PASS
X-Source-IP: 216.205.24.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:13.110.208.0/21
	ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 ip4:148.139.1.2 ip4:148.139.2.2 ip4:148.139.3.2
	ip4:149.72.0.0/16 ip4:149.96.1.26 ip4:149.96.13.2 ip4:149.96.132.2
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_safe policy=tap score=0 classifier=
	adjust=0 reason=safe
	scancount=1 engine=8.12.0-2104190000 definitions=main-2105110096
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Mailman-Approved-At: Thu, 13 May 2021 08:01:13 -0700
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/3] fs/buffer.c: add new api to allow eof
 writeback
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130110
X-Proofpoint-GUID: XQSq4-B7q3NSWJvoTsmHfAm-1kJnmLMH
X-Proofpoint-ORIG-GUID: XQSq4-B7q3NSWJvoTsmHfAm-1kJnmLMH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105130110

----- Original Message -----
> On 5/9/21 4:23 PM, Andrew Morton wrote:
> 
> > On Mon, 26 Apr 2021 15:05:50 -0700 Junxiao Bi <junxiao.bi@oracle.com>
> > wrote:
> >
> >> When doing truncate/fallocate for some filesytem like ocfs2, it
> >> will zero some pages that are out of inode size and then later
> >> update the inode size, so it needs this api to writeback eof
> >> pages.
> > Seems reasonable.  But can we please update the
> > __block_write_full_page_eof() comment?  It now uses the wrong function
> > name and doesn't document the new `eof' argument.
> 
> Jan suggested using sb_issue_zeroout to zero eof pages in
> ocfs2_fallocate, that can
> 
> also fix the issue for ocfs2. For gfs2, i though it had the same issue,
> but i didn't get
> 
> a confirm from gfs2 maintainer, if gfs2 is ok, then maybe this new api
> is not necessary?
> 
> Thanks,
> 
> Junxiao.

Hi,

Sorry. I was on holiday/vacation for the past week and a half without
Internet access except for my phone. I'll try to find the time to read
the thread and look into it soon.

Bob Peterson


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
