Return-Path: <SRS0=6PEN=J6=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7E0C433B4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  3 May 2021 10:32:50 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62F5761029
	for <ocfs2-devel@archiver.kernel.org>; Mon,  3 May 2021 10:32:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62F5761029
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 143ATvPB020815;
	Mon, 3 May 2021 10:32:49 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 388xxmu6e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 May 2021 10:32:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 143AVEKk025116;
	Mon, 3 May 2021 10:32:48 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 389grqh928-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 03 May 2021 10:32:48 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1ldVpa-0002fF-2s; Mon, 03 May 2021 03:29:38 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1ldVp6-0002eF-SL
	for ocfs2-devel@oss.oracle.com; Mon, 03 May 2021 03:29:08 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	143AL8m7034867
	for <ocfs2-devel@oss.oracle.com>; Mon, 3 May 2021 10:29:08 GMT
Received: from oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 388v3ut7f7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 03 May 2021 10:29:08 +0000
Received: from userp2040.oracle.com (userp2040.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 143ANxww000547
	for <ocfs2-devel@oss.oracle.com>; Mon, 3 May 2021 10:29:08 GMT
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by userp2040.oracle.com with ESMTP id 38abjp3kma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Mon, 03 May 2021 10:29:07 +0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 38F4DAE89;
	Mon,  3 May 2021 10:29:05 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id F1CA01F2B6B; Mon,  3 May 2021 12:29:04 +0200 (CEST)
Date: Mon, 3 May 2021 12:29:04 +0200
From: Jan Kara <jack@suse.cz>
To: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <20210503102904.GC2994@quack2.suse.cz>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<CAHc6FU62TpZTnAYd3DWFNWWPZP-6z+9JrS82t+YnU-EtFrnU0Q@mail.gmail.com>
	<3f06d108-1b58-6473-35fa-0d6978e219b8@oracle.com>
	<20210430124756.GA5315@quack2.suse.cz>
	<a69fa4bc-ffe7-204b-6a1f-6a166c6971a4@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a69fa4bc-ffe7-204b-6a1f-6a166c6971a4@oracle.com>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9972
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	spamscore=0 malwarescore=0
	phishscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
	priorityscore=0 lowpriorityscore=0 adultscore=0 clxscore=197
	bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2105030069
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9972 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105030070
X-Proofpoint-GUID: Rr8sA4p3zE6qEBESLEtln8gw0VEZ8Qcp
X-Proofpoint-ORIG-GUID: Rr8sA4p3zE6qEBESLEtln8gw0VEZ8Qcp
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9972 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 clxscore=1034 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105030070

On Fri 30-04-21 14:18:15, Junxiao Bi wrote:
> On 4/30/21 5:47 AM, Jan Kara wrote:
> 
> > On Thu 29-04-21 11:07:15, Junxiao Bi wrote:
> > > On 4/29/21 10:14 AM, Andreas Gruenbacher wrote:
> > > > On Tue, Apr 27, 2021 at 4:44 AM Junxiao Bi <junxiao.bi@oracle.com> wrote:
> > > > > When doing truncate/fallocate for some filesytem like ocfs2, it
> > > > > will zero some pages that are out of inode size and then later
> > > > > update the inode size, so it needs this api to writeback eof
> > > > > pages.
> > > > is this in reaction to Jan's "[PATCH 0/12 v4] fs: Hole punch vs page
> > > > cache filling races" patch set [*]? It doesn't look like the kind of
> > > > patch Christoph would be happy with.
> > > Thank you for pointing the patch set. I think that is fixing a different
> > > issue.
> > > 
> > > The issue here is when extending file size with fallocate/truncate, if the
> > > original inode size
> > > 
> > > is in the middle of the last cluster block(1M), eof part will be zeroed with
> > > buffer write first,
> > > 
> > > and then new inode size is updated, so there is a window that dirty pages is
> > > out of inode size,
> > > 
> > > if writeback is kicked in, block_write_full_page will drop all those eof
> > > pages.
> > I agree that the buffers describing part of the cluster beyond i_size won't
> > be written. But page cache will remain zeroed out so that is fine. So you
> > only need to zero out the on disk contents. Since this is actually
> > physically contiguous range of blocks why don't you just use
> > sb_issue_zeroout() to zero out the tail of the cluster? It will be more
> > efficient than going through the page cache and you also won't have to
> > tweak block_write_full_page()...
> 
> Thanks for the review.
> 
> The physical blocks to be zeroed were continuous only when sparse mode is
> enabled, if sparse mode is disabled, unwritten extent was not supported for
> ocfs2, then all the blocks to the new size will be zeroed by the buffer
> write, since sb_issue_zeroout() will need waiting io done, there will be a
> lot of delay when extending file size. Use writeback to flush async seemed
> more efficient?

It depends. Higher end storage (e.g. NVME or NAS, maybe some better SATA
flash disks as well) do support WRITE_ZERO command so you don't actually
have to write all those zeros. The storage will just internally mark all
those blocks as having zeros. This is rather fast so I'd expect the overall
result to be faster that zeroing page cache and then writing all those
pages with zeroes on transaction commit. But I agree that for lower end
storage this may be slower because of synchronous writing of zeroes. That
being said your transaction commit has to write those zeroes anyway so the
cost is only mostly shifted but it could still make a difference for some
workloads. Not sure if that matters, that is your call I'd say.

Also note that you could submit those zeroing bios asynchronously but that
would be more coding and you need to make sure they are completed on
transaction commit so probably it isn't worth the complexity.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
