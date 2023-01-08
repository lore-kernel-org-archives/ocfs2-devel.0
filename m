Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEDD4C54EBD
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 21:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jhsGGTCytoLBX+tc1MAF3vI99VmnRVRcY82jRdEg3Vg=;
 b=G0GoUg99QnNDpw40L4gqkESVcTWJLQsOrIoTMwQUJ+XsfGAHWQKFesVOlJ7CbpzB8Q6yAyfkYtDn
   OtwT05WjnCb1f6Pr98c2BED8y1Npq1RrQxNX0VfpsNQ076q0pOSeFNQErvwkVDwEXk1nUE1mbftH
   aadxlo5UKH/ISwsdOAFbbLvMM+XlentIetEXJppd23XPwDm7jHkkHHpxPP1J4xDVwWZib/m1e+MY
   hTM8M0z2MAAbzaLdQtEZB0MlrJFMkA2Hhkd9CRwwPDj0BcK0tnGa3C9kTut7lkGq4f9aamavYgnz
   m8BJ8I1MmwKDfPMGuzz7g+/2vnZWjH1AJyPC/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jhsGGTCytoLBX+tc1MAF3vI99VmnRVRcY82jRdEg3Vg=;
 b=qdLHX04unh7AARbEExJLKsY+M4xRsbdNFyYws4LtSun9L6Nygr1jZGPya2ASDKzGXQQbt0FrxOqV
   93VvlvBbFA2CCCrfWKO+e/yRGUiPdAWTpIeBZRgWoG0aZdTh1EeqDSNrX8+qCMtMdzYNyKLrjHoE
   da2Dvm0BRkG+j5lHJWEsvhKcHhyE0U0B4Lmk+9Bxr454hVUdpUv3eQiDC4J1sfuzdinKxQWuKLZP
   Iz/Ww+knqm8Ic4Vr3VQaiwlcdHP8F5seKHkGsw0iv8WSjopMlAR6ns0Izncxzh45XRL6wf7cb5R/
   PcpYUlDaRv+Mjek/SjK7kKRVIg+MECqXHDU9cw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600DR6RT4YR50@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 21:31:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=++R3apswKn917ceG4txQXiZ1LJjLtj+nBEmEVXkWhS8=; b=dm/cLFNaKZAOrFlytHsOvTk2Jr
 ez8yteUWEcM+9Gvjd7lmrZYc8XtHwp9CxOiARQuiTXyFgAsjzy3BvOKdi6Oqkw4uYoM5bx9Zhquvd
 CfqTrxz9e1zrOlo3uKseyW7BDZTUKqM93uHTKqr+TKAQdIWYJ1GpWrZKrdQzGnvUt1TA+wb8u28/V
 qfs/1IGoaHoVjwdS40H5YXZN03jNyFQ5Ct+IpTy9QHadGXXKZIlrIjyAJVKd/VvXA+Njjonyf3h/h
 mavaFrnmkentZmOxii9RnnHf+WPa18T290G6Rs7XdgCFtfqKtR3EsibJzFKgmY2YydLv7S0chGUn7
 WdsGGqeA==;
Date: Sun, 8 Jan 2023 21:31:30 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <Y7s2Mo+XR4YJUfoH@casper.infradead.org>
References: <20230108165645.381077-1-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230108165645.381077-1-hch@lst.de>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 phishscore=0 mlxlogscore=278
 impostorscore=0 adultscore=0 clxscore=-34 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080160
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] remove write_one_page / folio_write_one
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
From: Matthew Wilcox via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Matthew Wilcox <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: fU058KPi8VEmX14S8C6BqsgGwRHc8u8J
X-Proofpoint-ORIG-GUID: fU058KPi8VEmX14S8C6BqsgGwRHc8u8J
Reporting-Meta:
 AAGD0zVJWQCFaPwkVB0nIb1fy5mwwhvUT6iaM+KIiT9fnzLJVyc4H2zEgL58eqUC
 5Fh0d/bovbVF4FJdx/Qke7wusu6f1aA+UEz+K8AdyNIyPJYDiqC3G6j43mGkYryu
 G8SQPNwe2FbY1VuOxFNwFZIsc6nhFY94YRQeCLrG0hFziRn7gmg1cW7YaVwBj+rf
 EeDt8AA64zaGeWD7VHGVuBlP/aK3wF2iKCdswKQtG268bZ3g4nHmvtOGI8437d4U
 cpR6Hj6/qYQxNoHBaPeXYBY1//KkJ2Y3oxgbuDDmXzDGw4egVn4vBfGzQqL7Zi8U
 nSgC7MR3n3+/tUY3mfZSkOdlbHy7Bb8mRJOFCInR5ev2M/VcL9O/GrsthjhrOWEU
 vZSNNsEQ3U4L7kjuJiLZ0O0rWGCAIZ/8EOASmBxa4laGdFTd9ulvJMdhdVM6ZeUw
 Kp//ZleecHwK895MDZufxggCF7x8d+W0zi9wshe2NOj1ZnsbwWcOv03WbG6DA/KJ
 h2Zp3d9BTPu4M6/hU04pKyC6JbhYyYIMzQbZ9zm4Sw==

On Sun, Jan 08, 2023 at 05:56:38PM +0100, Christoph Hellwig wrote:
> this series removes the write_one_page API, and it's folioized
> implementation as folio_write_one.  These helpers internally call
> ->writepage which we are gradually removing from the kernel.
> 
> For most callers there are better APIs to use, and this cleans them up.
> The big questionmark is jfs, where the metapage abstraction uses the
> pagecache in a bit of an odd way, and which would probably benefit from
> not using the page cache at all like the XFS buffer cache, but given
> that jfs has been in minimum maintaince mode for a long time that might
> not be worth it.  So for now it just moves the implementation of
> write_one_page into jfs instead.

Thanks.  This totally wrecks a patchset I was working on, but it's
definitely the right thing to do, and I'll rebase on top of it once
it's in.  Looking forward to v2 with my niggles fixed ;-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
