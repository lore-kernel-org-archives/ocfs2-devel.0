Return-Path: <SRS0=iO0D=PV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF483C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Nov 2021 10:02:19 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 559B260E98
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Nov 2021 10:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 559B260E98
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A29bTrv021938;
	Tue, 2 Nov 2021 10:02:18 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c290gxcem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Nov 2021 10:02:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A2A2F5L028460;
	Tue, 2 Nov 2021 10:02:17 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3c1kht867v-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Nov 2021 10:02:16 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mhqWE-0003M5-20; Tue, 02 Nov 2021 02:55:50 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1mhqWB-0003L1-JL
	for ocfs2-devel@oss.oracle.com; Tue, 02 Nov 2021 02:55:47 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A29ofiM012043
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Nov 2021 09:55:47 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3c27k4ra8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Nov 2021 09:55:47 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A290HQG029620
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Nov 2021 09:55:45 GMT
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c2aaugea6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Nov 2021 09:55:45 +0000
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id D0E1921952;
	Tue,  2 Nov 2021 09:55:42 +0000 (UTC)
Received: from quack2.suse.cz (unknown [10.163.28.18])
	by relay2.suse.de (Postfix) with ESMTP id A8D72A3B84;
	Tue,  2 Nov 2021 09:55:42 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 628361E0A2B; Tue,  2 Nov 2021 10:55:42 +0100 (CET)
Date: Tue, 2 Nov 2021 10:55:42 +0100
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <20211102095542.GB12774@quack2.suse.cz>
References: <20211025150008.29002-1-jack@suse.cz>
	<20211025151332.11301-1-jack@suse.cz>
	<f8c309cf-ace7-f8c7-33d2-9a5fa39cb21b@linux.alibaba.com>
	<20211101113100.GA18487@quack2.suse.cz>
	<beb87697-e851-9681-bcc4-0669eb210703@linux.alibaba.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <beb87697-e851-9681-bcc4-0669eb210703@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Source-IP: 195.135.220.28
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
	ip4:149.44.0.0/16
	ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
	ip4:192.31.114.0/24
	ip4:195.135.221.0/24 ip4:195.135.220.0/24 ip4:69.7.179.0/24
	ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=228
	lowpriorityscore=0
	suspectscore=0 spamscore=0 priorityscore=85 malwarescore=0 adultscore=0
	impostorscore=0 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111020058
X-Spam: Clean
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
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
 definitions=main-2111020059
X-Proofpoint-GUID: lDuDRqfI0PDim5Ze3YcQF8cdjn1-JNG2
X-Proofpoint-ORIG-GUID: lDuDRqfI0PDim5Ze3YcQF8cdjn1-JNG2

On Tue 02-11-21 10:36:42, Joseph Qi wrote:
> On 11/1/21 7:31 PM, Jan Kara wrote:
> > On Thu 28-10-21 15:09:08, Joseph Qi wrote:
> >> Hi Jan,
> >>
> >> On 10/25/21 11:13 PM, Jan Kara wrote:
> >>> ocfs2_truncate_file() did unmap invalidate page cache pages before
> >>> zeroing partial tail cluster and setting i_size. Thus some pages could
> >>> be left (and likely have left if the cluster zeroing happened) in the
> >>> page cache beyond i_size after truncate finished letting user possibly
> >>> see stale data once the file was extended again. Also the tail cluster
> >>
> >> I don't quite understand the case. 
> >> truncate_inode_pages() will truncate pages from new_i_size to i_size,
> >> and the following ocfs2_orphan_for_truncate() will zero range and then
> >> update i_size for inode as well as dinode.
> >> So once truncate finished, how stale data exposing happens? Or do you
> >> mean a race case between the above two steps?
> > 
> > Sorry, I was not quite accurate in the above paragraph. There are several
> > ways how stale pages in the pagecache can cause problems.
> > 
> > 1) Because i_size is reduced after truncating page cache, page fault can
> > happen after truncating page cache and zeroing pages but before reducing i_size.
> > This will in allow user to arbitrarily modify pages that are used for
> > writing zeroes into the cluster tail and after file extension these data
> > will become visible.
> > 
> > 2) The tail cluster zeroing in ocfs2_orphan_for_truncate() can actually try
> > to write zeroed pages above i_size (e.g. if we have 4k blocksize, 64k
> > clustersize, and do truncate(f, 4k) on a 4k file). This will cause exactly
> > same problems as already described in commit 5314454ea3f "ocfs2: fix data
> > corruption after conversion from inline format".
> > 
> > Hope it is clearer now.
> > 
> So the core reason is ocfs2_zero_range_for_truncate() grabs pages and
> then zero, right?

Well, that is the part that makes things easy to reproduce.

> I think an alternative way is using zeroout instead of zero pages, which
> won't grab pages again.

That would certainly reduce the likelyhood of problems but it is always
problematic to first truncate page cache and only then update i_size.
For OCFS2 racing page faults can recreate pages in the page cache before
i_size is reduced and thus cause "interesting" problems.

> Anyway, I'm also fine with your way since it is simple.
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks!

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
