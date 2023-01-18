Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A9D5C32793
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 21:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PH7/1yLLuSs3/a2KZSTl8Shzt8z36e2BLXrLDCIVhrs=;
 b=Sy0lTz2VWM4m6MayN2GUTaA+uJGDRQLWZkMAr8l/AfNM+LvRlnUh6inqQ2hIZi/S710+VFW6F1FA
   2WCUNOPahDMHS4y6jn/+SywnZ1UBxs6M0XCDiyRPqq+r8zGDVWrlaRQOUoPekSdP6WhX9S7cbwNM
   3Qu2H0bzgNvF7n2I7QGZChwuELQ8WlpuLLfzz6iUtrJEGwGI9GVSDToJcL81ClwsJ/tEcWXbXpa6
   q7DCi3Ti6/hH85elB3SXonfdlpeEubqyx5jgLACR19hAaZOcktUHnpx5/isRBL7KaAy05A1aG5Zr
   pOY51YvmZhGjvxNdw8bKrgaf55t5xTTPGoXXXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PH7/1yLLuSs3/a2KZSTl8Shzt8z36e2BLXrLDCIVhrs=;
 b=PcjeOOCXEy37P9cHbQeMukl5ES3vbcV0H6Aju08Xkw27Ye3U47/7jsslhMU97Kq3y0jB62oEDcBL
   dDh6KIxA0xmN5h/8yhdZFMr3koXJtYv7jalNS4xrWZK9bPzd5M1qDmMNoYIeAzcGl0BeiWkA6dlN
   T7vO3w9QmNZE51AC9M7TAZOB6QQqxnwoJc6W3vfzPh8rX2Jav2z9oUxftT0rGepx/deV135TVz0g
   ZT1IFAdWAqvNJH3fWnMwHdc70tKLyRV3Yx1JxxesMremOotVgeI7YAtlVcOhL77xtl8FH3/riE2j
   EiJsxzkurZBIOupprVjoFdoNMeN1TTjigTvzrg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROP000OPAKFKA80@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 21:33:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=2WuvGVVjPfhcIZhsbkz2EarT7sqqS33Y8zjJm+VJ7vM=; b=fe7L45tMENKiRxn7zi4tRhwwlq
 Ka5ppExwaE6DFwx/CqB0+37N0aLfxrGY/yR9SU+3bXUd3gORpegWv9nUm+2xC7bL4vmAzx5/INwtP
 Muh6AjDBr6uaZRUQp5hjyDiAfWKZJcRlsP90J26QDLBymCU0J5DZdzOH28NjQUaoo0Hp253JJ1gJB
 9j3DtqzVyJoKWUQzVFGORlGKXga7hvqMNhnbJxggVrWAK1fcbnDifJY4WSVkls5Oqns7E+mEXLKJb
 kF6HRfCmp8w+gJBHWrYBaHDyf92WPI//I8sS7CAUUG6DlDpar9pHmO6O4wsyehqHizyo0hV2CQBk7
 bElPFxdA==;
Date: Wed, 18 Jan 2023 21:33:32 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <Y8hlrJJZ2uJbZSCv@ZenIV>
References: <20230118173027.294869-1-hch@lst.de> <Y8hjWSfC8TVCx5Fe@ZenIV>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <Y8hjWSfC8TVCx5Fe@ZenIV>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=990
 priorityscore=30 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 clxscore=124 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180180
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] remove most callers of write_one_page v3
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
X-Proofpoint-GUID: T9FNBlGFRoOslfT2YeSS3Olr3tIcvSRh
X-Proofpoint-ORIG-GUID: T9FNBlGFRoOslfT2YeSS3Olr3tIcvSRh
Reporting-Meta:
 AAE+dGnifyFQevO6hhcIWzZGak3w4ND8gWVRB/J4JbhQ8Odr0c8/u5sfVKLqY0Lc
 8FzkAp0JANTLOKo0Px20ASKru75SXHZs/nNxQqrtW6q4Gd3fvnxey4qoK+ge9nQp
 JV1FbGgV1BGKTbqEsgViig+wORyDJlIR1l6aRIGcwDT24VG6wG6zNLaUfGMKn0hw
 7e7gX1NVetFO8hBqA80OxzW7iw2W97mJvPgSpHwnwyJhzilVuCii1q88JqjeDy6q
 tI6BGwaG8e3e5rjGTCDZdJHUfV/gjhF/Xzbz4sFm+ViXWvCWGLKxZcs6MAeZmzIg
 5JVxz14w64QPvoruK70OAjHh0216FQ5dbpREjf/J3/u4ifC1KIDCpO+ChkdoK7JJ
 FbRqaScm2qOWH+6ll7kyEqAFTioU2WOdO26eseXGYtIw56KuvfO8gcq+XgAEH2KL
 kFalfm1S+mG4T9DcnzCZ2qa8vG8kfkLi8PfVY6UYH6ItUE3BsJA79VWZos6sOR93
 duwLNU6L+ag0/KslnYmd2qkH3ZxzX/RTPAG2kig2Dydc

On Wed, Jan 18, 2023 at 09:23:37PM +0000, Al Viro wrote:
> On Wed, Jan 18, 2023 at 06:30:20PM +0100, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series removes most users of the write_one_page API.  These helpers
> > internally call ->writepage which we are gradually removing from the
> > kernel.
> > 
> > Changes since v2:
> >  - more minix error handling fixes
> > 
> > Changes since v1:
> >  - drop the btrfs changes (queue up in the btrfs tree)
> >  - drop the finaly move to jfs (can't be done without the btrfs patches)
> >  - fix the existing minix code to properly propagate errors
> 
> Grabbed.  I'll split that into per-fs branches (and synchronize wrt
> fixes), fold the kmap_local stuff into that and push out.

BTW, do you have the check for minix_delete_entry() failure when called
from minix_rename() anywhere in your tree?  I don't see that in this
series; I'm adding the trivial fix, hopefully that won't end up
creating conflicts...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
