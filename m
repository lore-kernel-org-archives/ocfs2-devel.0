Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97F3C64EC4
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 04:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YY8g36h85vxCuYW9E4G8EeOVlFtkxSjpQeHyheGBprw=;
 b=Qjo4fOCwNPCXJ+R0nuLlHv8LYbe6zsoAnwz7VKT40wrhdLvTv9NID9JCRYUVV/h/WX6+cZfm2BnS
   42l1DReEoTMWcOtI2ES7nb/D+bqLOxTpZ5JePcn39wpuNc9EAi8ofZngQAlOwbH3TskZhdMkniA4
   UVJKxvKfXJW4+6Sce0lqhov1gCChMVHxzxcLo+5dqkChkCiopzB81zoD2Yu+FwDtVVdn0UnSoVTm
   bCQaqyv/1mtY1A42d+EDfm/DpOtONDPENP+ZSZJYSQJAnMXr0JSnJSBfcBswMQN8Zbb5v5K+QMTw
   z45CuVVotcUwIFGWPMikVqHisdfcn45UpPX1/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YY8g36h85vxCuYW9E4G8EeOVlFtkxSjpQeHyheGBprw=;
 b=W5WyyHqq3+L88rA7VwTuqMXgdmQM89lQdFbP/ftzOep+wddiwio0fW70qVZ664gTxjLqqkBN3zOO
   fDjlXWKgppTD7RicHW9MSANfSqTEldvkviysgS7C7vx7OBDvWUgLcP2dixWvbEbi/1pInde8dAX/
   BETN3saFOvh4cN57iNWnBrcWHZ6vho1zZUXXvEWatWPdCfcLyHSEpCbLzHgYASRTrfm9Cqpdvy1f
   ayPzbHeV4Ct/EzuKqv8Z7C0bAk2VcgemxSfBMmuYbz2002M5AKCiC8chhKk0yhus0u6SGUjc7jUa
   l+rb3sKIk8TAopV7fmiL1pbw1qZVnkbtEw7Qbw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA00LIYE1UNJ40@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 04:05:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=sXO3jdqVtcE9IkmkZO6INMTY092zGfYbJtv9fnxM+sA=; b=s4GPi5XiLpgFxOlwC+NflMG4/X
 5HbPrHSvN06Y/6GM49O0nUugEJWHbzRYk7+EIhVHCxwEJLArUtCzzLmbb/w8xsdE1ryBSkDa4o/UH
 /N3oi9I6KVELpO4jbxOBBgqadEWL8k8Wl3X6o65G0ZkCGO7az4JwtM2Xp0Ugz8+6prxwsSFqzhWjX
 uX2Z+9SprefB8puk0M9v8g355tcJYOHb6tD4sgQOoxH5zYgTMjICW2GSKbf5ZGmTfecoDhGe3HaF4
 TTuzOp2phpd65QIpwrHo9QfKuhFLoKM1nmI+Zh35Eab3siV3m/GriED+HcHPd+vQqeBt2OFkrlOnZ
 M5IC4GPQ==;
Date: Fri, 10 Mar 2023 04:05:08 +0000
To: Yangtao Li <frank.li@vivo.com>
Message-id: <20230310040508.GN3390869@ZenIV>
References: <20230310031547.GD3390869@ZenIV>
 <20230310035121.56591-1-frank.li@vivo.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230310035121.56591-1-frank.li@vivo.com>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=253 malwarescore=0
 mlxlogscore=999 adultscore=0 clxscore=157 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100031
Cc: brauner@kernel.org, tytso@mit.edu, agruenba@redhat.com, chao@kernel.org,
 linux-kernel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 huyue2@coolpad.com, adilger.kernel@dilger.ca, jefflexu@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, xiang@kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] erofs: convert to use i_blockmask()
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: q8SX0MijLprFRM1w0Mc6ZM7hrnKDVdQb
X-Proofpoint-ORIG-GUID: q8SX0MijLprFRM1w0Mc6ZM7hrnKDVdQb
Reporting-Meta:
 AAHW4I4xlX4s8LEP45XSiQTZ0/ZwtNx0ocMqnJTKLeSxTGcxZVGt8o3C1GpXkxt5
 KiAyGV82G4AHuVcLf/bunYMhpIoGOuyDfn0JetpXM/sqeT7oXzM2VBG84IUHfdKu
 /9aM6TpiBoJxSvTd0qcrDJAfVlVymwdOMxOeXjMrogODncgI6EB3I+MUItIJ6ti1
 RYbA9Rc2L3nQzyf6NAmgs+T9uCRtdWzGHu4sRp0geqEk2zl04KQMz8BK9peHpPdf
 cNbCjD9A0CsBbAWblJQ2z4QAHbksB/ODOPiUfQzyyg/sQGtD434WooXk4cDWNS9G
 ysQQkZ66CDh4eQWCl4wPvn1EDV9sYJpsRb+ShVXtph8ErW6vaoU3Kfw8Y4TJ/vYx
 dnak6fsyoiojbFDGJAy7BIqk5Em+L4fruNvD6TmJ+C2sspJQTeQh9a0B5OmVgy/O
 a2IZCNNg2MvujVLu+Y4UIANNmmZDg3Zqp8Rq83b/E3QxBe1pFSA3tzIniclIRaki
 0FLsthGD+gA7lxVm+cnFgj9Gifzk7lyrsYjYXGR/h5/i

On Fri, Mar 10, 2023 at 11:51:21AM +0800, Yangtao Li wrote:
> Hi AI,
> 
> > Umm...  What's the branchpoint for that series?
> > Not the mainline - there we have i_blocksize() open-coded...
> 
> Sorry, I'm based on the latest branch of the erofs repository.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git/log/?h=dev-test
> 
> I think I can resend based on mainline.
> 
> > Umm...  That actually asks for DIV_ROUND_UP(i_size_read_inode(), i_blocksize(inode))
> > - compiler should bloody well be able to figure out that division by (1 << n)
> > is shift down by n and it's easier to follow that way...
> 
> So it seems better to change to DIV_ROUND_UP(i_size_read_inode(), i_blocksize(inode))?
> 
> > And the fact that the value will be the same (i.e. that ->i_blkbits is never changed by ocfs2)
> > is worth mentioning in commit message...
> 
> How about the following msg?
> 
> Use i_blockmask() to simplify code. BTW convert ocfs2_is_io_unaligned
> to return bool type and the fact that the value will be the same
> (i.e. that ->i_blkbits is never changed by ocfs2).
> 
> 
> 
> A small question, whether this series of changes will be merged
> into each fs branch or all merged into vfs?

Depends.  The thing to avoid is conflicts between the trees and
convoluted commit graph.

In cases like that the usual approach is
	* put the helper into never-rebased branch - in vfs tree, in this
case; I've no real objections against the helper in question.
	* let other trees convert to the helper at leisure - merging
that never-rebased branch from vfs.git before they use the helper, of
course.  Or wait until the next cycle, for that matter...

I can pick the stuff in the areas that don't have active development,
but doing that for e.g. ext4 won't help anybody - it would only cause
headache for everyone involved down the road.  And I'd expect the gfs2
to be in the same situation...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
