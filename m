Return-Path: <SRS0=okW4=JT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CF4C433ED
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Apr 2021 10:45:00 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B3087613C3
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Apr 2021 10:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3087613C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MAhCFt135140;
	Thu, 22 Apr 2021 10:44:57 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 38022y4c3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Apr 2021 10:44:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MAa3uO135243;
	Thu, 22 Apr 2021 10:44:56 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3809evpxag-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 22 Apr 2021 10:44:56 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lZWpL-0000ja-Bd; Thu, 22 Apr 2021 03:44:55 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1lZWow-0000ik-9y
	for ocfs2-devel@oss.oracle.com; Thu, 22 Apr 2021 03:44:30 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13MAa3uq135179
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 10:44:30 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 3809evpx01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 10:44:30 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13MAh1x9006438
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 10:44:29 GMT
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by userp2030.oracle.com with ESMTP id 383068fthp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 10:44:29 +0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 0DC1EB0B6;
	Thu, 22 Apr 2021 10:44:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 9D86E1E37A2; Thu, 22 Apr 2021 12:44:25 +0200 (CEST)
Date: Thu, 22 Apr 2021 12:44:25 +0200
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <20210422104425.GC26221@quack2.suse.cz>
References: <20210421162953.GA13863@quack2.suse.cz>
	<c4d119be-e263-366c-c2c2-6c58ee852977@linux.alibaba.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c4d119be-e263-366c-c2c2-6c58ee852977@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-PDR: PASS
X-Source-IP: 195.135.220.15
X-ServerName: mx2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
	ip4:149.44.0.0/16
	ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
	ip4:192.31.114.0/24
	ip4:195.135.221.0/24 ip4:195.135.220.0/24 ip4:69.7.179.0/24
	ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
	impostorscore=0
	mlxscore=0 mlxlogscore=847 lowpriorityscore=0 suspectscore=0
	clxscore=184
	phishscore=0 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104220090
X-Spam: Clean
Cc: Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] Possible fs corruption when hole punch races with
	other ops
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220089
X-Proofpoint-ORIG-GUID: pd6wkkJd0QseuOcwX2OV94pM94aLVlv1
X-Proofpoint-GUID: pd6wkkJd0QseuOcwX2OV94pM94aLVlv1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1034 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220089

Hello!

On Thu 22-04-21 11:22:07, Joseph Qi wrote:
> Checked the code flow, it seems the race you worried truly exists.
> We have to take ip_alloc_sem before calling into ocfs2_get_block().

OK, that's what I assumed but this won't be easy. Because ocfs2_writepage()
is called with a page locked but ocfs2_remove_inode_range() gets called
under ip_alloc_sem and locks pages in ocfs2_truncate_cluster_pages() ->
truncate_inode_pages_range(). Which creates ABBA deadlock. So you'll
probably need to come up with a similar dance like in ocfs2_readpage().

But after fixing this, ip_alloc_sem should provide you with enough
protection so that ocfs2 isn't prone to races between hole punch and
readahead / fault my work will be mostly irrelevant for OCFS2.

Thanks for confirmation!

								Honza

> On 4/22/21 12:29 AM, Jan Kara wrote:
> > Hello,
> > 
> > I'm unifying protection various filesystems use to protect hole punch
> > operations from racing with other operations (like readahead, page fault,
> > writepage etc.). I was looking into OCFS2 and I think it is prone to a
> > following race which can possibly lead to filesystem corruption. But maybe
> > I miss something so that's why I'm writing here. The scenario I'm concerned
> > about is:
> > 
> > CPU1					CPU2
> > ocfs2_remove_inode_range()		ocfs2_writepage()
> >   ...					  block_write_full_page()
> >   ocfs2_remove_btree_range()		    ocfs2_extent_map_get_blocks()
> > 
> > Now ocfs2_extent_map_get_blocks() runs without protection of ip_alloc_sem
> > AFAICT and so both these operations can be modifying extent map at the same
> > time? What am I missing?
> > 
> > 								Honza
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
