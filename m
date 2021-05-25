Return-Path: <SRS0=bLRF=KU=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25CEC2B9F8
	for <ocfs2-devel@archiver.kernel.org>; Tue, 25 May 2021 09:30:48 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 603B061413
	for <ocfs2-devel@archiver.kernel.org>; Tue, 25 May 2021 09:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 603B061413
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14P9TJ6H194296;
	Tue, 25 May 2021 09:30:47 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 38rne412gm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 09:30:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14P9UPuK107360;
	Tue, 25 May 2021 09:30:46 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38qbqs2u0a-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 25 May 2021 09:30:46 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1llTOc-0005sw-GI; Tue, 25 May 2021 02:30:42 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1llTOY-0005sX-Mm
	for ocfs2-devel@oss.oracle.com; Tue, 25 May 2021 02:30:38 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14P9BLEa140524
	for <ocfs2-devel@oss.oracle.com>; Tue, 25 May 2021 09:30:38 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 38pq2u3djf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 25 May 2021 09:30:38 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14P9E7Gu031056
	for <ocfs2-devel@oss.oracle.com>; Tue, 25 May 2021 09:30:37 GMT
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by userp2040.oracle.com with ESMTP id 38rnjngfsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 25 May 2021 09:30:37 +0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 818A2AECE;
	Tue, 25 May 2021 09:30:34 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 330A91F2C98; Tue, 25 May 2021 11:30:34 +0200 (CEST)
Date: Tue, 25 May 2021 11:30:34 +0200
From: Jan Kara <jack@suse.cz>
To: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <20210525093034.GB4112@quack2.suse.cz>
References: <20210521233612.75185-1-junxiao.bi@oracle.com>
	<20210524085508.GD32705@quack2.suse.cz>
	<479301ea-042b-855d-fc52-0d7bbdc55bdc@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <479301ea-042b-855d-fc52-0d7bbdc55bdc@oracle.com>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	mlxscore=0 clxscore=251
	malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
	suspectscore=0 lowpriorityscore=0 priorityscore=126 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250062
X-Spam: Clean
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix data corruption by fallocate
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250063
X-Proofpoint-ORIG-GUID: rsvU-cOx1QY-ezIaWPHBN9E1i6iqb8Yq
X-Proofpoint-GUID: rsvU-cOx1QY-ezIaWPHBN9E1i6iqb8Yq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1034
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250063

On Mon 24-05-21 09:14:16, Junxiao Bi wrote:
> On 5/24/21 1:55 AM, Jan Kara wrote:
> 
> > On Fri 21-05-21 16:36:12, Junxiao Bi wrote:
> > > When fallocate punches holes out of inode size, if original isize is in
> > > the middle of last cluster, then the part from isize to the end of the
> > > cluster will be zeroed with buffer write, at that time isize is not
> > > yet updated to match the new size, if writeback is kicked in, it will
> > > invoke ocfs2_writepage()->block_write_full_page() where the pages out
> > > of inode size will be dropped. That will cause file corruption. Fix
> > > this by zero out eof blocks when extending the inode size.
> > > 
> > > Running the following command with qemu-image 4.2.1 can get a corrupted
> > > coverted image file easily.
> > > 
> > >      qemu-img convert -p -t none -T none -f qcow2 $qcow_image \
> > >               -O qcow2 -o compat=1.1 $qcow_image.conv
> > > 
> > > The usage of fallocate in qemu is like this, it first punches holes out of
> > > inode size, then extend the inode size.
> > > 
> > >      fallocate(11, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 2276196352, 65536) = 0
> > >      fallocate(11, 0, 2276196352, 65536) = 0
> > > 
> > > v1: https://www.spinics.net/lists/linux-fsdevel/msg193999.html
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> > > ---
> > > 
> > > Changes in v2:
> > > - suggested by Jan Kara, using sb_issue_zeroout to zero eof blocks in disk directly.
> > > 
> > >   fs/ocfs2/file.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
> > >   1 file changed, 47 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > > index f17c3d33fb18..17469fc7b20e 100644
> > > --- a/fs/ocfs2/file.c
> > > +++ b/fs/ocfs2/file.c
> > > @@ -1855,6 +1855,45 @@ int ocfs2_remove_inode_range(struct inode *inode,
> > >   	return ret;
> > >   }
> > > +/*
> > > + * zero out partial blocks of one cluster.
> > > + *
> > > + * start: file offset where zero starts, will be made upper block aligned.
> > > + * len: it will be trimmed to the end of current cluster if "start + len"
> > > + *      is bigger than it.
> > You write this here but ...
> > 
> > > + */
> > > +static int ocfs2_zeroout_partial_cluster(struct inode *inode,
> > > +					u64 start, u64 len)
> > > +{
> > > +	int ret;
> > > +	u64 start_block, end_block, nr_blocks;
> > > +	u64 p_block, offset;
> > > +	u32 cluster, p_cluster, nr_clusters;
> > > +	struct super_block *sb = inode->i_sb;
> > > +	u64 end = ocfs2_align_bytes_to_clusters(sb, start);
> > > +
> > > +	if (start + len < end)
> > > +		end = start + len;
> > ... here you check actually something else and I don't see where else would
> > the trimming happen.
> 
> Before the "if", end = ocfs2_align_bytes_to_clusters(sb, start), that is
> the end of the cluster where "start" located.

Ah sorry, I got confused. The code is correct.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
