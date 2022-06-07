Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D06C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oKH7pSC0GBNO2ag8jrRwqPJLlWYahO3Pdbw5HIb/oYQ=;
 b=MURabqtxlLqGTtDOZScufomIqlj9zESqIlMMwom9L6WRvGcPvzvqaM9RLKYbSuHmxwE9qculPtkW
   kHNuSAkNLsp2UVcOX1SxT4irxzzMyTaEazA7nClTxF4Rb8gD7tO6ImnABtWd4ppku3yP1gguIc4o
   UHtxkFs5vNRPPFxTUiWkjJj8ZiyJNvOwBcFLQDfO0eI8Whex843ddXQ9xwkSFkLsVeZHNRpf5xaB
   wjSUywHCTCCrhojGGMloloYhFnWoF+r0Alsi6YnqUHFFU0v+x0TgS7hbb5MucvJd6yk014wlLuQT
   7agoaFPzSLvbyHtvbSA9TOrey+za+2N99T4CxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oKH7pSC0GBNO2ag8jrRwqPJLlWYahO3Pdbw5HIb/oYQ=;
 b=b2NGFOCB18GF60BJF5y1pSJoGHfcQoOYGxORZcwkQJQEltOJEUkHttzlxo6p+lbs+h1elcIcL9lC
   n5rgZWQTDDL6xZ6g5MByfRaOxEfJuGPVCxJ7L2PUyEmpCTmkdAxBCBji78nY2Sl5JBiUyct21017
   1DHtj9Ce74QB6azqdrJUWlznBI99V+Oqvh+4bSrH5jLJiYkhYhPlyUwbCdkJB3BN0x/Yipy5aI3E
   SUA+j/N9wml0Y4kk2G31Z0R0LV701cmO4l/+2gjL9F9mplHikwEB/MDhqNakp+SpNqSKUxmH11Fn
   KOoBq0OJ/6GrJ+kcn9+a4m4170VB91ZPS4zMZw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD400BRW2OZJ2A0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 14:24:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=TMQU2bbtV5kjI1Y7uBOgpmsi6MujvLdf4se1f0ultbQ=; b=T3tONSSZEZI3TnW91MAPGKwqdn
 ynmJAoI6mOfrbbq8Jqf2czJGvi9Q0ukvLmmikcGSI8ZqHSwvRkTwLUTylDBqG6RaX8/3fM9Nvve4c
 VqFvCNQX2J5+bZcWx69Xcxl0FnIF/+ozKW4FHlSZHfTn6FEQTfoWOYo1nVdtg5lJcedIUJr0ygYNv
 BxeGZpOaFU4iqywNAUPFsAq2KhxI0Hbg9OXTdHy26nItEezSSsuIGEVlhH9A3QRH3TI9Fv56fknf8
 0pc9AkwczXake1fj6Qt6cCxOadkgaG3Xkumb8mMGujy60/hhxbEX20y0v48fX/CV/o6oaLLnenmYd
 w0xneMdA==;
Date: Tue, 7 Jun 2022 15:24:15 +0100
To: David Hildenbrand <david@redhat.com>
Message-id: <Yp9fj/Si2qyb61Y3@casper.infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-16-willy@infradead.org>
 <e4d017a4-556d-bb5f-9830-a8843591bc8d@redhat.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <e4d017a4-556d-bb5f-9830-a8843591bc8d@redhat.com>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 suspectscore=0 priorityscore=208 phishscore=0 clxscore=177
 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=579
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070058 domainage_hfrom=8379
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 15/20] balloon: Convert to migrate_folio
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
X-Proofpoint-GUID: TMRzyyEp-XITnT66ZXu0v2VCcsmuEp_T
X-Proofpoint-ORIG-GUID: TMRzyyEp-XITnT66ZXu0v2VCcsmuEp_T
Reporting-Meta:
 AAFkcIS6h1XGbefDGn7CgjNGhuXeZ4ta+5hGLxszNOODxxLlrdrponGTNgl1xir2
 MYRYxft/u/z9n4kHRgsK7ZvNTyUy/6O4WiFTqTh7JBz1H/U8/cw3pl1janc0NgTk
 /JCcAKMuNvG7uQkn2M5hE5E8f2yjej/gcuOKh/Fpm36c/vub32K6aJfr0qS4H5cQ
 GFOkCg5LZ7EGXxqcNGqoojZLSNOLF3Mgs18EuRFOaREwnpW2voCmKzSFzSg9D9J/
 bxVu2qgls7ga+getldSCNpo5g81Xc/z7dzEyksDOD38dGoJka1d9ZbDs0J218Zk9
 sPFOBQHLCYu+XQGyS/2zpNiG/aT9JVmD4zzq/nB1BtK1AQuMOLAq0Iow/0TlNhQ0
 nSy+aRm8iWjPSjA+lqAGbrjMhKHy5AIqNkaLtk3Ce+MgmIccCdqzWlA7C1/D1Tms
 cvBMQFBemG0ajPw5oldu1OdPP30ExAIAMv/qbf9IaT1o/QphuG8/XlrezmlQayYu
 wBMoZdxUOjlyQv3NscbJM5Z1EJFjKGOqqnjvsi5va+lZ

On Tue, Jun 07, 2022 at 09:36:21AM +0200, David Hildenbrand wrote:
> On 06.06.22 22:40, Matthew Wilcox (Oracle) wrote:
> >  const struct address_space_operations balloon_aops = {
> > -	.migratepage = balloon_page_migrate,
> > +	.migrate_folio = balloon_migrate_folio,
> >  	.isolate_page = balloon_page_isolate,
> >  	.putback_page = balloon_page_putback,
> >  };
> 
> I assume you're working on conversion of the other callbacks as well,
> because otherwise, this ends up looking a bit inconsistent and confusing :)

My intention was to finish converting aops for the next merge window.

However, it seems to me that we goofed back in 2016 by merging
commit bda807d44454.  isolate_page() and putback_page() should
never have been part of address_space_operations.

I'm about to embark on creating a new migrate_operations struct
for drivers to use that contains only isolate/putback/migrate.
No filesystem uses isolate/putback, so those can just be deleted.
Both migrate_operations & address_space_operations will contain a
migrate callback.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
