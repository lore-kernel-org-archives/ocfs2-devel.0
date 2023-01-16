Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC66EC677F1
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Jan 2023 21:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=w2fkaOV+8eDO2IyOPbKuIuDwg80x2gAvsOiXOj90vQQ=;
 b=DRgahJNa/F5J6SFMkwIreqxIy9hL2lX6YNEW/kH7+nKGp8Mkps5yY2pfx8t5gyR1XG0ctW1tSzM+
   HXT4K0U9MGfmRXAjqE8dHv+ee3uNWmRZAzS560lndFn225YC6wkYBCZh1+bZO23ay5kSeQYXADeZ
   nyXt0RflnmpcgoE/VxUYQTZf82mcsuwjLXPA2qLguiBLEYwvGhlujLS6LhYrmBtHvgPeerGemGwV
   g1iBrVNSJMlvAkwPqgf/alw6rhgM22kV1PPO2a4cvCejeRiv44xvZEDd+DusYrumiYIxZFspqNuo
   gI7E+sXQtKL+e95THk7d9DSKzbZM/v9ynpEEqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=w2fkaOV+8eDO2IyOPbKuIuDwg80x2gAvsOiXOj90vQQ=;
 b=l2AiqqkGMFrmG/XjUkS1Coxhq/4czvtQG9sUyAqwGQTDv7Pae0BozqIecpeEMGOR2TQMIrSNk2OQ
   vD03gBcZh1mVZNEC4znoe2ecOLH8ZhikIm7sF5miMw+QBhWj08XHbIvb/h5FG5qmoMqUUBaiWyIw
   OD2SpBHRLRosMvhlSYmU8JiYTA4gcgpsP2JLSfjrTsc2IJkFUZnD0Sy95u/nrkwic8dMY1rQL7Ry
   FlccC/fOXvbI5ffKgtqiSRPkBhRTscKSL/UsvPipAtkXlcc1UbpnLeajTbyZUTHWme8hSaP8K41C
   p/+b9XCJ0vO9lM7+9ucPKwIyOU9okSdeEwClYA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROL00HBTJTH0DB0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 16 Jan 2023 21:03:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=9WKEEi76vJhptedaWLNEvoVdr9s00xvLpcvV43SjTmo=; b=RVjIeR49+Lx0IiedP7HLQJuHAs
 UlIO7vPsAghva/+dz3sHsxnNLSpmJ9FtdWYqGPHNDHvwL5sz1tZwe+DVTohFlNE8mEuhKeHHQWkxI
 2w5uAVcva3f0X3mPpR2q+1Xzx+dsrSOMh+LmKEu+CiPMFngptd4GlHsy6FCJcf9rdyZu7SccKzk+n
 eWbr7zFIWzq135JPOjsB5H+H03BZErP1bfQityjS1ACT/IwTCaC7fiUQMBs6nMbkshyaax3x+C9h4
 MUCNC10HDFlrNUwpcDezD27bXwhXFtF8Kfd4JwTEJtIDz9EnmPXEDF+VP1Oe+IuLBHqGnH8EV+s40
 RwCrE1Pg==;
Date: Mon, 16 Jan 2023 21:02:45 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <Y8W7dULuW5oFGm/J@ZenIV>
References: <20230116085523.2343176-1-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230116085523.2343176-1-hch@lst.de>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10592
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=772
 priorityscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 clxscore=92 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160154
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] remove most callers of write_one_page
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
X-Proofpoint-GUID: iBTBJKEopzXZuhbyuC0CVfw2wVQQGvpJ
X-Proofpoint-ORIG-GUID: iBTBJKEopzXZuhbyuC0CVfw2wVQQGvpJ
Reporting-Meta:
 AAGmAyNOxsjp26ifksKJVbk9UBBVLG8oMXcM5AgVm3GhfGCAr8HBSh/001i5dYEn
 fAbxQa+dncaxHLkLWDszDB98DUQh493IZmFQ3yd/6mkczg+c1rQVvThXeBITLpRa
 YoiCu9laePyn9ehtiCFFZ89PuwSHLJ4tQS4GJJRZCqW9qYSa/PHZfDju3BJZyspa
 WTmS+KKSjFUkzy3rhjw4+Vbk9eVqNZdJlYBzvJdW7grvmiMBgMuAAen5xIhEP/oU
 o49urLj/QuSslthNVczyDVjva4qhPjnNSscNa10dlXlyrGrd6DR+2s03DPfDPUXs
 NXdopNCQ24K1edhRQNbdILJyxajq8NB79xWiW4xhAgSCyEbXPGE2vVteyYviGWUD
 eTCVyK3qaNj0jfHDGxlVVoIKkHZeYi+Kvxbq4NUXSfPeTF1R3WDnmOHh6PJ8oAb+
 omvFp6EiWMw57jr5f7bM3hqw2zXvFG2/A8vpXGsslw/WEI/qjUt/6+9jNHAaB5ur
 enfYKi58wzgApm9TU2+E1F3WmjuVcCOle7IA64+G4Avn

On Mon, Jan 16, 2023 at 09:55:17AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series removes most users of the write_one_page API.  These helpers
> internally call ->writepage which we are gradually removing from the
> kernel.
> 
> Changes since v1:
>  - drop the btrfs changes (queue up in the btrfs tree)
>  - drop the finaly move to jfs (can't be done without the btrfs patches)
>  - fix the existing minix code to properly propagate errors
> 
> Diffstat:
>  minix/dir.c          |   67 ++++++++++++++++++++++++++++++---------------------
>  minix/minix.h        |    3 +-
>  minix/namei.c        |    8 +++---
>  ocfs2/refcounttree.c |    9 +++---
>  sysv/dir.c           |   30 ++++++++++++++--------
>  ufs/dir.c            |   29 ++++++++++++++--------
>  6 files changed, 90 insertions(+), 56 deletions(-)

OK...  Mind if I grab minix/sysv/ufs into a branch in vfs.git?
There's a pile of kmap_local() stuff that that would interfere with
that and I'd rather have it in one place...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
