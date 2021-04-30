Return-Path: <SRS0=KHNm=J3=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A23C433ED
	for <ocfs2-devel@archiver.kernel.org>; Fri, 30 Apr 2021 12:48:33 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 004FF61186
	for <ocfs2-devel@archiver.kernel.org>; Fri, 30 Apr 2021 12:48:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 004FF61186
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UCi3D5059613;
	Fri, 30 Apr 2021 12:48:31 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 385aeq7kqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Apr 2021 12:48:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UCiwMX116015;
	Fri, 30 Apr 2021 12:48:31 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3848f2fr2n-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 30 Apr 2021 12:48:31 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lcSZK-0006OY-7B; Fri, 30 Apr 2021 05:48:30 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1lcSYp-0006Nd-Rc
	for ocfs2-devel@oss.oracle.com; Fri, 30 Apr 2021 05:47:59 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13UCivBX115888
	for <ocfs2-devel@oss.oracle.com>; Fri, 30 Apr 2021 12:47:59 GMT
Received: from oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 3848f2fqky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 30 Apr 2021 12:47:59 +0000
Received: from userp2040.oracle.com (userp2040.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 13UCh21v024788
	for <ocfs2-devel@oss.oracle.com>; Fri, 30 Apr 2021 12:47:59 GMT
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by userp2040.oracle.com with ESMTP id 387y61na3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Fri, 30 Apr 2021 12:47:58 +0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 19ED2AF0C;
	Fri, 30 Apr 2021 12:47:56 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id D350A1E3029; Fri, 30 Apr 2021 14:47:56 +0200 (CEST)
Date: Fri, 30 Apr 2021 14:47:56 +0200
From: Jan Kara <jack@suse.cz>
To: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <20210430124756.GA5315@quack2.suse.cz>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<CAHc6FU62TpZTnAYd3DWFNWWPZP-6z+9JrS82t+YnU-EtFrnU0Q@mail.gmail.com>
	<3f06d108-1b58-6473-35fa-0d6978e219b8@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3f06d108-1b58-6473-35fa-0d6978e219b8@oracle.com>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	bulkscore=0 spamscore=0
	mlxlogscore=999 lowpriorityscore=0 malwarescore=0 phishscore=0
	mlxscore=0
	clxscore=158 adultscore=0 suspectscore=0 priorityscore=70
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
	definitions=main-2104300092
X-Spam: Clean
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        cluster-devel <cluster-devel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [Cluster-devel] [PATCH 1/3] fs/buffer.c: add new
 api to allow eof writeback
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300092
X-Proofpoint-ORIG-GUID: YQ8qGxkWla3kP191LmxByj0w2oBPSiw5
X-Proofpoint-GUID: YQ8qGxkWla3kP191LmxByj0w2oBPSiw5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1034 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104300092

On Thu 29-04-21 11:07:15, Junxiao Bi wrote:
> On 4/29/21 10:14 AM, Andreas Gruenbacher wrote:
> > On Tue, Apr 27, 2021 at 4:44 AM Junxiao Bi <junxiao.bi@oracle.com> wrote:
> > > When doing truncate/fallocate for some filesytem like ocfs2, it
> > > will zero some pages that are out of inode size and then later
> > > update the inode size, so it needs this api to writeback eof
> > > pages.
> > is this in reaction to Jan's "[PATCH 0/12 v4] fs: Hole punch vs page
> > cache filling races" patch set [*]? It doesn't look like the kind of
> > patch Christoph would be happy with.
> 
> Thank you for pointing the patch set. I think that is fixing a different
> issue.
> 
> The issue here is when extending file size with fallocate/truncate, if the
> original inode size
> 
> is in the middle of the last cluster block(1M), eof part will be zeroed with
> buffer write first,
> 
> and then new inode size is updated, so there is a window that dirty pages is
> out of inode size,
> 
> if writeback is kicked in, block_write_full_page will drop all those eof
> pages.

I agree that the buffers describing part of the cluster beyond i_size won't
be written. But page cache will remain zeroed out so that is fine. So you
only need to zero out the on disk contents. Since this is actually
physically contiguous range of blocks why don't you just use
sb_issue_zeroout() to zero out the tail of the cluster? It will be more
efficient than going through the page cache and you also won't have to
tweak block_write_full_page()...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
