Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58785C00140
	for <ocfs2-devel@archiver.kernel.org>; Thu, 18 Aug 2022 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JUT2Lw31WCgqLSYU0bBYV+hcpUuQg3SzrjamE5Y2/Ag=;
 b=DOZtBkmrSh2cMEUvK2qEgSWIKPJyIxB3yYOPeH7Lu3YGF35ofiRvWM5cfhXbDfDbtwxAVnbimgUT
   mljMrZqjbXZDwVkcmh4vrb26vdYUIuQJ7woSqABX3ncYCvmQ7PoGKCpABBgv2mKCc1NAIL1q5pMY
   q1ao7je3bcEwZKbdGGDCUBfCF3Pp9vtp1r8gWzYt4705wcZ1ioZN4jbKgd/WLupLrOcQ/4CdWOCk
   2BfPWsZ7UXUqNLjBscvxka9+UZi02aSXxws/cldc4eLetzhP3OEbK6BGsM3ZtHAnc2zqE3h1Ng5c
   9dV76gwCQAu9fU7lZZ7AtrVeEs2s7bZUe5dRCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JUT2Lw31WCgqLSYU0bBYV+hcpUuQg3SzrjamE5Y2/Ag=;
 b=EnlaHYp2VQnCHGDkzPRKQk93X+jNn+gBQMpLaG3esTkevlgLpDhj9A3bk072lZcTny5xW20JbXNG
   zAZL1W4Nu6Xj2MALdAtI/LR+MYkNqhwnVvRR/Wsxk3bC9oKkIZKtAcyLIOP3i9EX+OMX7HDfrs5I
   FEPBXDu8SeHPqgO2+80CuZZKH4XnHxPn4s8sEhaGzdBN2WBP1gp7YNhZF2rg+a5G4IiaJ+1CToNQ
   Xw8cmMp6bDI9w9hg649eta9ql8v791zZvmC2V3911mrHEZ4M5xuVfPEiQgwG7otrk5z5u9s5wL0d
   i+hpF2UAkwG4v4pT4smpRxXLjPssSTDo7BsAAQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220805 64bit (built Aug  5
 2022))
 with ESMTPS id <0RGT002YZG1U0R70@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 18 Aug 2022 14:53:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=2AZvmHGmUWYRtU8m5E0Y2FaQ3RYx/t9Os+yxzS89zbE=; b=YYpNzkhXYjdFiNTAIrlJmpzhKN
 JcxrksfNkLVtWmxo0N7RP87fpxhFhmBWzqCGl5mTAE0vsM52rWb9WSKoULQ85A4os9R+TiOCNV87X
 dx+pCYenv4Vr2ecM2PrItSsmKhzZTCBx1ei8ZLfQ4lQjMQzlSexiV5osR/7dx/CRM3a66aB7tL2Q2
 7PUISYNqrkUoiTEC43ypjVhhkrOd6soKsf9VM44E7CEUS91i+m84oBOtJ8+BwbjidVFChlJy5Q/PE
 F1eID9xWyilIo7RkkhOXGwkHG+VLYTjd7hFqTaWn4B5/yzC/IvCatAl1QJ6r9Z0Xt5mstMYq4oypG
 B0GPw+xA==;
Date: Thu, 18 Aug 2022 15:35:18 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <Yv5OJuwJq17bQDXo@casper.infradead.org>
References: <YvvBs+7YUcrzwV1a@ZenIV>
 <CAHk-=wgkNwDikLfEkqLxCWR=pLi1rbPZ5eyE8FbfmXP2=r3qcw@mail.gmail.com>
 <Yvvr447B+mqbZAoe@casper.infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <Yvvr447B+mqbZAoe@casper.infradead.org>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10443
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 priorityscore=171 mlxscore=0 impostorscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=312 phishscore=0 suspectscore=0
 clxscore=193 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180052
Cc: jfs-discussion@lists.sourceforge.net, Hans de Goede <hdegoede@redhat.com>,
 devel@lists.orangefs.org, apparmor@lists.ubuntu.com,
 linux-unionfs@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu,
 linux-security-module@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
 Sungjong Seo <sj1557.seo@samsung.com>, Namjae Jeon <linkinjeon@kernel.org>,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] Switching to iterate_shared
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
X-Proofpoint-GUID: ETf3D16wBIXgA7LSvNnDlBidrvTZcob5
X-Proofpoint-ORIG-GUID: ETf3D16wBIXgA7LSvNnDlBidrvTZcob5
Reporting-Meta:
 AAFLKpe9XnraUxpwi80iF277rG9KjXdJ4LbJ1XNhOwvE30oNKk+cNyKTwzHKKxdA
 71rL2nrbWD+VUeU6s8ibvRIIsR8KwHB1BmqBTgZRfWQewOa+5bwiX8U2X0HDWn2c
 vPh3Y+q/iHtUoqYhVsUuJAVTpUDF1/YomrVZl3fLwIyJQGytIH3dBHz1d5xfXT9B
 CP6RzaE41ViaL8Q6r7nt3kQ/3dvDq/g8bZnmkZuWPbFEMF4LTrRhQgkw5S7e6Hq/
 kPJaAMRQN5sQWrRsgH5HLcIYcaIVzd39REOX7yhQEQ156E1pZdkw6R9Hr0T8BM0a
 qQgVdE7+We+vSfbFgqVKBuleASlfweVDjtIPfUiq6sa+vBYSFtXJxND9PdNRtT3k
 0eejN3iFYkT94UqF203/i6izyEvACerGJ6rNLl1xN+eJ1TWeaApVIwpXWr3G1byP
 IjKpfB633G/4nXgcv190XfETxUX0T4BhfvE4z8h/GKBnhqbDHDcDKPHPSTc34Akd
 FaioVQ4v7eTdCXBu4aYEpyOV75FlJKHNmaq6L8qIKlEB

On Tue, Aug 16, 2022 at 08:11:31PM +0100, Matthew Wilcox wrote:
> fs/adfs/dir_f.c:        .iterate        = adfs_f_iterate,
> fs/adfs/dir_fplus.c:    .iterate        = adfs_fplus_iterate,
> 
> ADFS is read-only, so must be safe?

I just checked ADFS.  This isn't a f_ops ->iterate, this is a special
adfs_dir_ops.  ADFS already uses f_ops->iterate_shared.


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
