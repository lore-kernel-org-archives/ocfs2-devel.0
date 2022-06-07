Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272EEC43334
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 14:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wuDj1JIXQvMWZMvMjae4L4kIXNSmJoF1dP9BKj1/nYQ=;
 b=HFWDLIm/KWYZLXMsoJircMumzAldt+iwYJhp9Je/WB6vgsBvLYUZ76uE4laboNlPFKUCsk/d+INk
   9UkmKGkcrz2KzePjDK05pkAIUaDyHRW4S0UQI1M4RyKrL10HNE+5QzTSYpMCfvr2CDPg37sRi3PQ
   kBYjwdpT8dgZU81a3BS4d8xfzA/89KihBkVEL22S4g9+BWbSYX5puvB6ZY4yBB9qpYoNXGNkFqlq
   C1E/lLhQ+iYoPsa75NiDXa97lwCBp2UVfeqmfu28Lz0b5UqZIDfTeZbusVwyRPftDdR1dkFNrKT5
   dCJbg1/dvCXmtIyevnWJnZR+PHiI0tAnGhpeHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wuDj1JIXQvMWZMvMjae4L4kIXNSmJoF1dP9BKj1/nYQ=;
 b=n7dETjq4Mmk7aVoV6tAlTiZ6o+bM9k2cMF+AouBUOQzG79iSaPtFecgeoM6Ep7BdKy37qMwmswBU
   qk2k0LE50KECnD5sc1liSNisHIV6Ukq81H5moDqoXxLtZ+GRustmVHprMuc2nz5JlW81ZfarP1zd
   N0TbTdvbs3GemmXfrsnXXBVV0gWPTikP+MZzDoFEVYSiJKdri5hEDlWINLrgNNHBD4syKqgfCtKf
   fVKEJj6mcgh7tGfCQU9mrbesEvfTYFg3BFOB3OPGKMJUCqsMfw0VaLGlyx2kIgDV64Ma7Ir3ET+a
   8HkLBR4aXtk+U9N7q32R6kEnWJHeulUr75+pfA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD4000WZ2H3WS70@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 14:19:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=4nUpYTI4YzQUWe3MX/DeuqIdjPgTHj7mksBWnabO8pk=; b=IoritkaL90aqbR+RUHZKoSo8fb
 np1ux4ttns5tYj2sJk/FAj12Ak/CQ/wW4eIuwXN5ulK6rhUSeL7wfME8a6K9gYUgIYgqg08BNe9+I
 tus3kQ04SmPJZl9V4GH+E2xTibe280AETqIE3sbtSug/TUXDR0128c42jRa/+qeI8q7uri0dQOk1f
 wWHM11+pgzBreVL8bkL3da/JDGIf99g2HUm8tnTrzT4cPM9I17c3dxlon1CkQMKJOgWEf9FbWmKJ9
 h7TOtnv+jsL8ABFyKBR86bb03b2ZVDj0NIek4XcowncLGE0YjVino+xsZhqucJvOU+7lO9abDpL7s
 BM8iPWpg==;
Date: Tue, 7 Jun 2022 15:11:40 +0100
To: Brian Foster <bfoster@redhat.com>
Message-id: <Yp9cnCaZ1O4qHFEp@casper.infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-6-willy@infradead.org> <Yp9VpZDsUEAZHEuy@bfoster>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <Yp9VpZDsUEAZHEuy@bfoster>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0 clxscore=148
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxlogscore=828 suspectscore=0
 priorityscore=176 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070058 domainage_hfrom=8379
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 05/20] mm/migrate: Convert
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
X-Proofpoint-ORIG-GUID: oE8jFuOoaFidihpfkY2es2TouFLZcdJ3
X-Proofpoint-GUID: oE8jFuOoaFidihpfkY2es2TouFLZcdJ3
Reporting-Meta:
 AAEMoQroQueGomhiQHHGZ6KhIa6pGbK3ERdS85VG05rpAaz+Psp18+t+r04XY4QL
 BpoK9SUQaMM/tuUaFFr4EriSAZtfBPjyopRWqLx98p8tukOAdxE73Iv9/oW/t4mn
 DimbNERLXuyA/P7Or00WS2MWLB6WLfU3SPlObE4/8ajfW1kFpXt4VbYx4BOYyxHE
 FpVKf3CylZd0wrRlC8oaApisuTE6cH0ZlSkSOHsJJs8T19DLzQga8TWtw1lvyrsC
 fJOmwqLNTI4Q4KiWI/Rtc9ztfZiySzoda6NFW5aBLDziZQBgd3GPAVlTXR8VC5fv
 z8n2GPYgFLPEyec1YJiR2pOwmmT7P4loiuDz7i68lvhZGFPPRMeaGZ3X5JWI6xvW
 X2vnehIRG3a/WZ8nvLAp15/1Hc+n6+3ghCOKO/CWPpK9SDCRft2ic9W/c+w7KgLL
 iuet64r0yhTrRSqThVCSNPsBD+RecpAL5t5ViK5I5cEyW8Qu1Ito9a9tVHlhUK1Q
 WwSpn2eHSuNx3zZpCxJN2VuZ4afH9f30fTHJKRw3o/G2

On Tue, Jun 07, 2022 at 09:41:57AM -0400, Brian Foster wrote:
> On Mon, Jun 06, 2022 at 09:40:35PM +0100, Matthew Wilcox (Oracle) wrote:
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
> 
> Why not folio_has_private() (as seems to be used for later
> page_has_private() conversions) here?

We have a horrid confusion that I'm trying to clean up stealthily
without anyone noticing.  I would have gotten away with it too if it
weren't for you pesky kids.

#define PAGE_FLAGS_PRIVATE                              \
        (1UL << PG_private | 1UL << PG_private_2)

static inline int page_has_private(struct page *page)
{
        return !!(page->flags & PAGE_FLAGS_PRIVATE);
}

So what this function is saying is that there is one extra refcount
expected on the struct page if PG_private _or_ PG_private_2 is set.

How are filesystems expected to manage their page's refcount with this
rule?  Increment the refcount when setting PG_private unless
PG_private_2 is already set?  Decrement the refcount when clearing
PG_private_2 unless PG_private is set?

This is garbage.  IMO, PG_private_2 should have no bearing on the page's
refcount.  Only btrfs and the netfs's use private_2 and neither of them
do anything to the refcount when setting/clearing it.  So that's what
I'm implementing here.

> > +
> > +	return refs;;
> 
> Nit: extra ;

Oh, that's where it went ;-)  I had a compile error due to a missing
semicolon at some point, and thought it was just a typo ...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
