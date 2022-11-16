Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED543C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 16 Nov 2022 15:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gAfCf5RxD8mN0qufA9IWzwDqx4fg/9ue0XHn6ST4g0Q=;
 b=QHFpklGwcVH9MK0xHsALDfgrwYC/miajme83BUV3ttKqj4S+Z9A+IH2vkIpBM+b1eGNTWrx4ymLb
   1VPDebQZ96JUBx7TB8end8+zGCiEKMJUptAycfVyHkbstShb8B/6mF1wtZZGBZ3h0eUwEev/TyXZ
   bz+5ROQsTVZPV9MCE07EP8lobfh1/8duZtPxuEHukGwtVxW55W8UhDIZoZcGls3hq4CG5RAzgpjB
   ZXnfE5Gs3AwD6pu2D7//568Gxf+VmfjuC1WnRAKgsl6WKVmRpZ+eYuGrzbichdweguErtfj1D/z7
   GF+po/wfS7Wb6TH20epBAlkQuTnI7cg74XM+Yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=gAfCf5RxD8mN0qufA9IWzwDqx4fg/9ue0XHn6ST4g0Q=;
 b=QDA6ZVWGk882urRBAhavlGpY3DxBObdi1Pw5fd2psrFcgs73QQd1p+BbO0d7hhnV/w0YaETWm+zj
   6sXKd8xmp8yevaZj2uSYOD5eSnaxbgdRIQsrnwUJcSMDDSnrv+sFNPy8lfU3BdRxMV/fPC/Th+S9
   a3YwOirfuhClyasr0L0FOYUN6qG4q6/Qsc5/r9QUmuPN41Mg/LApmvwCY5AV7znzR9m1PnLlmbCL
   iFxVGNF3qdzS7ZvVm7HIkVDHOg+zaFgOHwKpEsGNMNoGboJaDjH0kJ4910jGZwVp5dNHLjJFUZVx
   3NPb7aoZBYPRghmJxuM31GEJ0HgFD5UsChjqvg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLG00MX961TLYE0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 16 Nov 2022 15:37:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1668613006;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sLkFAGmODAxxEkX02jVvJl4offD9YV13b3F5VPNgrjo=;
 b=kpjpxKkatXq3EwXIEV+LmXYPlqGug+rL5rx5o/rJsc933/eJpQbsD/p+rNma92cYKNiNi1
 YdbC8GzWo43ZCdPFeaihAJ6HjcQHTDA9QISSKxypcBCuyZTXIUE2VVhStpcpCr29l9V9gK
 NTPHHOb0fLFUwA3NGMDRPUOi0JO3U8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1668613006;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sLkFAGmODAxxEkX02jVvJl4offD9YV13b3F5VPNgrjo=;
 b=y2zMGOWs/dn5QvLOUYvocvGltUMPBoQY2jZjWa1CBM1nVurW1yi34qHOJja8krFBYkjmXb
 4nRfZRBmBobFkTDA==
Date: Wed, 16 Nov 2022 16:36:44 +0100
To: Christoph Hellwig <hch@lst.de>
Message-id: <20221116153644.7rqgb6a4nyei3ltz@quack3>
References: <20221116135016.GA9713@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20221116135016.GA9713@lst.de>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10533
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=469 malwarescore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 priorityscore=100 clxscore=145
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160108
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, Mingming Cao <cmm@us.ibm.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
 linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] generic_writepages & jbd2 and ext4
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: YS--1qPa9DIPG0_XUHgMMJOMX-F3yRFG
X-Proofpoint-ORIG-GUID: YS--1qPa9DIPG0_XUHgMMJOMX-F3yRFG
Reporting-Meta:
 AAHKrrjoOn2Kpc9Lv4qnWJi1xibQMOj6QaPtXtBc8d1bCLKa2Qv+9SifODllbjLx
 +dlou3rwCGBdByBKbZ+vF3af6FstMwNhK+zYOko6kV9jValkoUopGgO0swFowAuy
 fN5k27/77ktxhgbn1ZKwwgr5QYqHpWGUlwt0ZRGe2bm8k+HAPdaZwJMBHeAKp1+f
 ATys+oDm+j/cwXJSw+x53JiQDqTvrPemOyE4L/yOt/LmUOevf28NjDyUMWu5rhLe
 givDcPpTBS63mwbnI+bVrk8s0z6McH2wSyfB2BffW3K6slVockzIp93tzN2jLEFy
 4z4LTRoHXJMZ3XCJwTl6PqrCL3Dyd08i7bhkz8Sobi683wLZcr0H9Km/mOFQamtW
 dPXeVwEpR3EA4d9a7nwuIRoZszXFP6AJUMrvfHYBXgRQt/fDz7C77KxC51pxYUN/
 kj7B7B8iXraF1WHEvjkP1fbxu97rNAee8HVOkRWMQWAhDh7pyxVsR8apRf0eyUd9
 Y8IdJuhHM1iwcOt3vsTlof+V0NdlAKkc5UFV9MSFHqQ=

On Wed 16-11-22 14:50:16, Christoph Hellwig wrote:
> Hi all,
> 
> I've recently started looking into killing off the ->writepage method,
> and as an initial subproject kill of external uses of generic_writepages.
> One of the two remaining callers s in jbd2 and I'm a bit confused about
> it.
> 
> jbd2_journal_submit_inode_data_buffers has two comments that explicitly
> ask for ->writepages as that doesn't allocate data:
> 
> /*
>  * write the filemap data using writepage() address_space_operations.
>  * We don't do block allocation here even for delalloc. We don't
>  * use writepages() because with delayed allocation we may be doing
>  * block allocation in writepages().
>  */
> 
> 	/*
>          * submit the inode data buffers. We use writepage
> 	 * instead of writepages. Because writepages can do
> 	 * block allocation with delalloc. We need to write
> 	 * only allocated blocks here.
> 	 */
> 
> and these look really stange to me.  ->writepage and ->writepages per
> their document VM/VFS semantics don't different on what they allocate,
> so this seems to reverse engineer ext4 internal behavior in some
> way.  Either way looping over ->writepage just for that is rather
> inefficient.  If jbd2 really wants a way to skip delalloc conversion
> can we come up with a flag in struct writeback_control for that?
> 
> Is there anyone familiar enough with this code who would be willing
> to give it a try?

Yes, I've written that code quite a few years ago :) And I agree JBD2 is
abusing internal knowledge about ext4 here. So yes, writeback_control flag
so that we can propagate the information to ->writepages method should do
the trick. I'll have a look into that.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
