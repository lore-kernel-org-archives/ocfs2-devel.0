Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E165EC43334
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Jun 2022 17:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FkuxP9HiA4V14mRrgXuFosWO1ydyNjPZVyN8lX5u4SM=;
 b=R698DCxuFTCqJqnEHeJ0LYJkI1aSVDT1CrKWYqoenyqz4MLZLyL1hJ7juf82cvZeJfZLpA9q67lC
   WXyKPxCt++xkNItELHWb8I9gtSSy87sftosZi4B+51c9DHwhzig6KrToiDFiHSNVOE7D+wvPGpeh
   WG3Dry2egROlnOYrOVwUYb43jQRkSxM1OQnQEHHQ7Ic6tEbS9lZo265aLh33sMqKZtecSqmRBhmr
   db7WuLRekHRSRG3g5w8tQcxmI2FixKNYoFych5cmKfJXVNnpQe7aKsZEumUwaeFDSBjKnnNxN+1X
   pqmsB4SV0Z+SbP009Ddnc9+9NSuh6k/AiivJ6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FkuxP9HiA4V14mRrgXuFosWO1ydyNjPZVyN8lX5u4SM=;
 b=IN4BNYEXGptm151JR1ynsImcupCWhLoEktI+iwv9eLjbRfFJMuXKzudjZ7Pgw5XGZlntJAkRJgDP
   siUJ9nCpRMwqVFuDBUSkWsXrfiOuvkJ4wRp8JtgsHd8tVayHKdDfmwfNdFzUV6WVLDt85QY7+AeM
   n8i1pcQlZrTtCBj4z0EDF05QjntYfQvYYu5mHkNtK/yEOHBo4tgSOsjGtG2fgH0tHvi6neCJGF1n
   1dEyniNItdTFG2L+r5TnfINQKY7+WONaWGznHEVbz48URwDA73D4adoF1PfcHvyc2yU86M6TEGx3
   s/S6WHmPSzElqRXaA+wT9ov1CP64VMmt6Nk1Xw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD800J4714GZW20@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Jun 2022 17:41:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=50LH8Dogtui4JOE7bz/ojMzo0HRhZGWl5FgghUdbsso=; b=H80hSPNqGiAd5chM6yyxpXe7GI
 v16rR9GPk1lsBvZCxGkkfPwwIt580VMmgSt7/ZwfufekJhmrwARChvfRps5Isb2jo31hImz/J8zhg
 3Gqid/DHTzlBHrEnpsHq7tbmdB6lizbSwvMg1psBh47cB986OJv32t09q9JTTsGSl5f5sM+mUmbDC
 kBxIqffET9U+LDZy+bNXjBWIq4ozQI6dP3A/jTcDrHF2DBz9xSzltFjBNcK5NRZczIeDZyfqJ8lJf
 qfewZREEYM3aHIjRrfEfYKtBKEBJRQ6UywKBfP0QJhwiV/qPmGd6+tb1EV1S0HSjXDX6WidFPIyNN
 +S04cl5w==;
Date: Thu, 9 Jun 2022 18:40:28 +0100
To: dsterba@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-aio@kvack.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
 linux-mtd@lists.infradead.org, virtualization@lists.linux-foundation.org,
 Christoph Hellwig <hch@lst.de>
Message-id: <YqIwjEO1a0Sbxbym@casper.infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-13-willy@infradead.org>
 <20220609163323.GV20633@twin.jikos.cz>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220609163323.GV20633@twin.jikos.cz>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10373
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=333 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=180 mlxlogscore=474 malwarescore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206090065 domainage_hfrom=8381
Subject: Re: [Ocfs2-devel] [PATCH v2 12/19] btrfs: Convert btrfs_migratepage to
 migrate_folio
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
X-Proofpoint-ORIG-GUID: 7jZl46yig3lEfg0Iszf36RDKowPIwN4o
X-Proofpoint-GUID: 7jZl46yig3lEfg0Iszf36RDKowPIwN4o
Reporting-Meta:
 AAGXsLtjayM+od1pv3T8c+cZwyjetd2u964tUKGNQeDodCRrsWyNroYY+8njdaYs
 oJpRMCsrowge91gujMa89NSBr1E0iT53DH/FCh3acVT4450nps8jm/5hhKd23jAB
 +TQTpmG9/9diipycblMmPh1mS4SfbK/seFC+kqra4Dji8h4mpCsOjuQjt3tzKyS3
 O+dCZvFU/5ncLb89VdkHVcs4lMI834xkmWtpKomyJZgr85ahuVdj+0SHw9Mgw858
 rh2aGOooUM2mICMY8iVND8JDJahnT8pBkOW2mFxszkba/OBeyVGhQgU2zEcniYwS
 hOkogvZdjh8FRXdqbHR4vrTio5MaO035oKn5+9vQaextxIrDCw+JpERfW6sj52g9
 4TDEHdPGVlkdRqd9pGgYr3ysSK/AJRpFb43/UmnKVt6H8qUy4groRl1ASAt3Ajjx
 xvtnoao7pu++fndhkEB4JEjbStb6asKKRdvefXj3uNsKAEU4NRgvwufuLYMqyCUV
 jtAlVfztRK226KTeyFHcKqFxLjVmFplfz9Wt4u8/nFk=

On Thu, Jun 09, 2022 at 06:33:23PM +0200, David Sterba wrote:
> On Wed, Jun 08, 2022 at 04:02:42PM +0100, Matthew Wilcox (Oracle) wrote:
> > Use filemap_migrate_folio() to do the bulk of the work, and then copy
> > the ordered flag across if needed.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: David Sterba <dsterba@suse.com>
> 
> > +static int btrfs_migrate_folio(struct address_space *mapping,
> > +			     struct folio *dst, struct folio *src,
> >  			     enum migrate_mode mode)
> >  {
> > -	int ret;
> > +	int ret = filemap_migrate_folio(mapping, dst, src, mode);
> >  
> > -	ret = migrate_page_move_mapping(mapping, newpage, page, 0);
> >  	if (ret != MIGRATEPAGE_SUCCESS)
> >  		return ret;
> >  
> > -	if (page_has_private(page))
> > -		attach_page_private(newpage, detach_page_private(page));
> 
> If I'm reading it correctly, the private pointer does not need to be set
> like that anymore because it's done somewhere during the
> filemap_migrate_folio() call.

That's correct.  Everything except moving the ordered flag across is
done for you, and I'm kind of tempted to modify folio_migrate_flags()
to copy the ordered flag across as well.  Then you could just use
filemap_migrate_folio() directly.

> > -
> > -	if (PageOrdered(page)) {
> > -		ClearPageOrdered(page);
> > -		SetPageOrdered(newpage);
> > +	if (folio_test_ordered(src)) {
> > +		folio_clear_ordered(src);
> > +		folio_set_ordered(dst);
> >  	}

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
