Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E25CC433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Jul 2022 03:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Sfv5LCJwZ1XtQ7NAhA2tHiyOqsaSUo9zlYeaOmIUs+8=;
 b=ApdXgHbCS25ozN/4ZogpIrenNE5xiTp5Ggbfm9iI4jk/mqfB0TZEWbTdeodiAUmyYFhKzu8Imy+P
   IZt3f+MseOH6jwAMoR7nOt6sZqL7xP3rsoCKyKi333/WYBOhT3TywMZFsVGQ6zDGo9ebcm3K4KXW
   BXfdq9tst7MT+SE95xiLe3Nlezw7iaQ/zQAu9eFYIg2pmasmlpXaaNNEBn96WESFoNJCEmLuReas
   7FwYeFlcUS98GDK0d0RZTmCHBfqTLiwTMvN+Pkb1pA2IraJyEiwpaabS3AJ7wKYwgC9VzihkzZCY
   nT5jCbO12V5QCHtl5Uk/9hKUQxrRMrXScl+Lsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Sfv5LCJwZ1XtQ7NAhA2tHiyOqsaSUo9zlYeaOmIUs+8=;
 b=bssBGldY8piyfaGBHfgfO/dhYA/hbtmlllq1TKgcG8hM4vxzJFb4QxZ9yf7J8UzYMO+ALZYZXcTM
   zqjknMUWYXxJ3eEPHDFwWkSwWS8iYDZBIb6jRGqEluLI0DkprDgxb4J0OyNxe+/mrsZefuXDTM2k
   cZgcaWYBcfJ1ufAugsga2PsV9NV//q1/UIABSSTDcUfT4lWCKGzRCUikxx22dQOkA+YEyV1+lNze
   89XKIvBQfy6+SVCCEWHjYcLaDWpyjnqM7Xhi+Hr4GvbG9f3x48iisJv3Az3PWwyeq9dCPaKjYpHe
   8Zku1ga8gYBgxCcBx/9G3f6P8+ZCMkJuMuQ59w==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0REO009QWN1NA1B0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 08 Jul 2022 03:29:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=oM2k/skZQvyu3mUYfkmntJvn7Ev2BYz4NH8zgIp7wHI=; b=rHG9dzm8IpPU7EfLVpII+KVjLX
 tK5RzYEsVvZxSEwtzFKftLvIoD7Gprdj8prhV6AczG/W1VhVFRA0+eJOe8FB1oYirYLF/RKjzuD1y
 UeDEi51PvWgAnfcZaU3Gwg3yJ7ho+xCZcFg47ydeQ/XmgoGz+hnH2UXSd2OVAnZpRaDhU4lA368tD
 oe+dO/0K+fc3cXMTKiXo8fOIKu03oBij5w1Ge8Sml/7vp/K9duiAF0tEeC/5h5rnSekPO7SDQxmi+
 t+Coa71RLCVtJVynZWQvpaKSs5ZIFuJtUldewmkkeABsbAtcvNHR4ZT5VhVmpe3X/ZzFhhyxT4Ch5
 5u2Qto6g==;
Date: Fri, 8 Jul 2022 04:29:14 +0100
To: Hugh Dickins <hughd@google.com>
Message-id: <Ysekikp60Hhs5lV0@casper.infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-8-willy@infradead.org>
 <6e7599d1-8a5f-bf16-383c-febd753bd051@google.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <6e7599d1-8a5f-bf16-383c-febd753bd051@google.com>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10401
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 clxscore=80 priorityscore=210 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207080011
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2 07/19] mm/migrate: Convert
 expected_page_refs() to folio_expected_refs()
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
X-Proofpoint-ORIG-GUID: oSdNNibOZfXt6fkqqBiAfKodBPTnicnq
X-Proofpoint-GUID: oSdNNibOZfXt6fkqqBiAfKodBPTnicnq
Reporting-Meta:
 AAEudTQyRJNjvbUYg51gauIdr+5meYIhns8g0meP1cmhv569wG0Na243tbhNl0E9
 bpBB9a22xbcrpwqxAvIdXDgfakmSSHz8Mczy+KHgd/V2trz0QpstQhMUJ9ZAjazL
 b4c0zpbGwH2oaHhgOEHtAMgH9IjjUtJFAR5W0RMbWZZCZCT7NNkD3kfgngWPVv/h
 ZuYrEGriB+Wl+SRQimM2/qVuFVbs8mNPz3qog4R7YBwmf3C2DjAvDkSgLAKrxdyH
 BklfO2FmloNN8GyQHoqxNMbCYwTYmNefMZpBkGmccrcYooG/aMpJ7lVudE7vuFVI
 YEuFPbS0QSQVU46sHOPcUuSpZuk683Rzu/Tny8EYIjdEnfLFY47+pIlFM3X6+ZdV
 FfHleSjtMni4TcXgRs9yA51Q7qelbsy6oFcX4WuUyOarHLvHnRZRdefs2Uw2BHn5
 MM1E9c7hhnKrtMFqAXfUiwLffmLnua65IbX0mpXp8R2Gu3Gxxqf6+dCHDOTnCU29
 1w4KdqATEWHa7J9eLTG3cWPgHpDyEP5LQ12QwnKHla05

On Thu, Jul 07, 2022 at 07:50:17PM -0700, Hugh Dickins wrote:
> On Wed, 8 Jun 2022, Matthew Wilcox (Oracle) wrote:
> 
> > Now that both callers have a folio, convert this function to
> > take a folio & rename it.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  mm/migrate.c | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 2975f0c4d7cf..2e2f41572066 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -336,13 +336,18 @@ void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
> >  }
> >  #endif
> >  
> > -static int expected_page_refs(struct address_space *mapping, struct page *page)
> > +static int folio_expected_refs(struct address_space *mapping,
> > +		struct folio *folio)
> >  {
> > -	int expected_count = 1;
> > +	int refs = 1;
> > +	if (!mapping)
> > +		return refs;
> >  
> > -	if (mapping)
> > -		expected_count += compound_nr(page) + page_has_private(page);
> > -	return expected_count;
> > +	refs += folio_nr_pages(folio);
> > +	if (folio_get_private(folio))
> > +		refs++;
> > +
> > +	return refs;
> >  }
> >  
> >  /*
> > @@ -359,7 +364,7 @@ int folio_migrate_mapping(struct address_space *mapping,
> >  	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
> >  	struct zone *oldzone, *newzone;
> >  	int dirty;
> > -	int expected_count = expected_page_refs(mapping, &folio->page) + extra_count;
> > +	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
> >  	long nr = folio_nr_pages(folio);
> >  
> >  	if (!mapping) {
> > @@ -669,7 +674,7 @@ static int __buffer_migrate_folio(struct address_space *mapping,
> >  		return migrate_page(mapping, &dst->page, &src->page, mode);
> >  
> >  	/* Check whether page does not have extra refs before we do more work */
> > -	expected_count = expected_page_refs(mapping, &src->page);
> > +	expected_count = folio_expected_refs(mapping, src);
> >  	if (folio_ref_count(src) != expected_count)
> >  		return -EAGAIN;
> >  
> > -- 
> > 2.35.1
> 
> This commit (742e89c9e352d38df1a5825fe40c4de73a5d5f7a in pagecache.git
> folio/for-next and recent linux-next) is dangerously wrong, at least
> for swapcache, and probably for some others.
> 
> I say "dangerously" because it tells page migration a swapcache page
> is safe for migration when it certainly is not.
> 
> The fun that typically ensues is kernel BUG at include/linux/mm.h:750!
> put_page_testzero() VM_BUG_ON_PAGE(page_ref_count(page) == 0, page),
> if CONFIG_DEBUG_VM=y (bisecting for that is what brought me to this).
> But I guess you might get silent data corruption too.
> 
> I assumed at first that you'd changed the rules, and were now expecting
> any subsystem that puts a non-zero value into folio->private to raise
> its refcount - whereas the old convention (originating with buffer heads)
> is that setting PG_private says an extra refcount has been taken, please
> call try_to_release_page() to lower it, and maybe that will use data in
> page->private to do so; but page->private free for the subsystem owning
> the page to use as it wishes, no refcount implication.  But that you
> had missed updating swapcache.
> 
> So I got working okay with the patch below; but before turning it into
> a proper patch, noticed that there were still plenty of other places
> applying the test for PG_private: so now think that maybe you set out
> with intention as above, realized it wouldn't work, but got distracted
> before cleaning up some places you'd already changed.  And patch below
> now goes in the wrong direction.
> 
> Or maybe you didn't intend any change, but the PG_private test just got
> missed in a few places.  I don't know, hope you remember, but current
> linux-next badly inconsistent.
> Over to you, thanks,

Ugh.  The problem I'm trying to solve is that we're short on page flags.
We _seemed_ to have correlation between "page->private != NULL" and
"PG_private is set", and so I thought I could make progress towards
removing PG_private.  But the rule you set out above wasn't written down
anywhere that I was able to find it.

I'm about to go to sleep, but I'll think on this some more tomorrow.

> Hugh
> 
> --- a/mm/migrate.c	2022-07-06 14:24:44.499941975 -0700
> +++ b/mm/migrate.c	2022-07-06 15:49:25.000000000 -0700
> @@ -351,6 +351,10 @@ unlock:
>  }
>  #endif
>  
> +static inline bool folio_counted_private(struct folio *folio)
> +{
> +	return !folio_test_swapcache(folio) && folio_get_private(folio);
> +}
>  static int folio_expected_refs(struct address_space *mapping,
>  		struct folio *folio)
>  {
> @@ -359,7 +363,7 @@ static int folio_expected_refs(struct ad
>  		return refs;
>  
>  	refs += folio_nr_pages(folio);
> -	if (folio_get_private(folio))
> +	if (folio_counted_private(folio))
>  		refs++;
>  
>  	return refs;
> --- a/mm/vmscan.c	2022-07-06 14:24:44.531942217 -0700
> +++ b/mm/vmscan.c	2022-07-06 15:49:37.000000000 -0700
> @@ -2494,6 +2494,10 @@ shrink_inactive_list(unsigned long nr_to
>   * The downside is that we have to touch folio->_refcount against each folio.
>   * But we had to alter folio->flags anyway.
>   */
> +static inline bool folio_counted_private(struct folio *folio)
> +{
> +	return !folio_test_swapcache(folio) && folio_get_private(folio);
> +}
>  static void shrink_active_list(unsigned long nr_to_scan,
>  			       struct lruvec *lruvec,
>  			       struct scan_control *sc,
> @@ -2538,8 +2542,9 @@ static void shrink_active_list(unsigned
>  		}
>  
>  		if (unlikely(buffer_heads_over_limit)) {
> -			if (folio_get_private(folio) && folio_trylock(folio)) {
> -				if (folio_get_private(folio))
> +			if (folio_counted_private(folio) &&
> +			    folio_trylock(folio)) {
> +				if (folio_counted_private(folio))
>  					filemap_release_folio(folio, 0);
>  				folio_unlock(folio);
>  			}

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
