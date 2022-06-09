Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B945C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Jun 2022 16:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7Z3QCBEGaAFZOWp+3zeQcQyxZzUNvrfvuh40M8JJ87A=;
 b=oE3X5xGSJ5O1invdoUcz9f/bubjE3u6gf97FX5JSn72DbVOiPISvaRJSIFkFyvcf4IlgoeYY4Jv0
   OEjOpd/+B41ECleYoqhmj6+MDc/DnxrnZS2N5oJ1T3/KDcrIcu3RoP/rR9FJIliWmqTBa1R6S5Bi
   ZghkjaYwZVrklan5g8Y4hU+kN6up8kRMEzCaI2SZu8vYUn45QgQpAiVePZjmBWO/aKF7ONG9sIlN
   qASw2DUYa7PtLpmlBiF54mZSoSnf1s8RsERCxm97EmpJvPxI+UT8td54YuAxbdy5/eKlO4irGNVw
   joiL8/RLsNzxyzLLadi193W0TxkbxSYGcpL50g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7Z3QCBEGaAFZOWp+3zeQcQyxZzUNvrfvuh40M8JJ87A=;
 b=t3CpyQpypyW6Yz8oSJyo6H/rrASebLnu7WKA7HfAGCf9Aig1Ds4NYbeU3CZPBCdvXTUcyNytZnKV
   yJYZLqZLPgrtJ4ECzFPBabiXUUSZj+Xq0oe/j8Wua4wWcPcWh+023/3AVlk/3AvZqv5Fjft3cHoJ
   SdKMr81nROvqyXT9YeW6ZjQg4jPQHHLhOzHY23EPcqWkKr+Ue4rZsewxgt5vsdg18jSYxY0FV4uH
   zcQ6Bt9UR0rJcgqGna3dnoKr/OZWNG9/I8/JNnvcki1+Ka883M04n8m7mXX9x+nytAV4wVsN3f+0
   oaEt8mNWCmxUZ1eF5O91CFkdXHRi2dxLJIn79g==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD7007JFY7J2060@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Jun 2022 16:38:07 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1654792674;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zfYT+PR9lXha9hYJlMd2oONaI1SUc3WGC1Bck/G8ec0=;
 b=b2KEX6ZCINZeKoHTynlrz3FMDUbnVbIkotULQQM8wta+qakmo0wc5ILD3yfYynBGt8D1yz
 HYV/+JhfacH7KcZ34tTxnGAMq0+073DU9INO4NM3aBmmmH1cmHo9hWrrTnPyGWxZmapSer
 hIaGVqCWyAZ99ysi+fFP8RhgxxrPFtk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1654792674;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zfYT+PR9lXha9hYJlMd2oONaI1SUc3WGC1Bck/G8ec0=;
 b=Irv56z+I7t/5vmpdqARm0xsfrzoUND1o/lJUqjcW0uNId73f8zXP/st70yGmLiPVj3W5Qe
 j8Fgd9g+H7+p0iCw==
Date: Thu, 9 Jun 2022 18:33:23 +0200
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <20220609163323.GV20633@twin.jikos.cz>
Mail-followup-to: dsterba@suse.cz,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 cluster-devel@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
 ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org,
 virtualization@lists.linux-foundation.org, Christoph Hellwig <hch@lst.de>
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-13-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220608150249.3033815-13-willy@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10373
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 bulkscore=0 clxscore=170 priorityscore=289 phishscore=0 suspectscore=0
 mlxlogscore=519 adultscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206090063
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
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
From: David Sterba via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: dsterba@suse.cz
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: h5InL9kN-jwcKjOm3_NI44lTzNXYoBKv
X-Proofpoint-GUID: h5InL9kN-jwcKjOm3_NI44lTzNXYoBKv
Reporting-Meta:
 AAFM2150Sh+Nj3ZbqJIuOENjYv/GHoa4+U9w9F5JCAD1sTvagLZzj1V2kuVlbNPG
 ek9PCwKU4ujSDzfj6MxpAqoQ0/53eD/lrfHX/9DdNp1bGE/a/HR+VRgAUszJkx1L
 UzC+u1QxnGVYbsTNW6w0pgTl5Yb560TEDGOHk9LSY5wcZtfzPUO1mal645ihxhZ2
 MKHhAPu47LQHhGHenETmdYrmyKVwq6g9P4/TY7JhOf/41izTgHnsnat28IiajBDn
 Er/wH3cGgJpVhmTjgtdJLU8oI6CCntTpqGlFpGRQBrwAcinX9ei7hoMJS9ojLdhI
 YwEbXDOVkMUekSq152WvzBcfoz3xgcl3r36W6HucNwR2TDkffk1rSKrvVLe2Ttp1
 E6AFWEL0UFEkiyfwKk1W/tOua/Agw7YXAn71nqQBihWG6dMh070jXaUb/g7RbopC
 /I7XIVREWJ9q+A+aTvTDN+qNQ7u+4Ae2ZLCX4dJZU/r82OKC6thcL/pZ8W4/oJlv
 k7KnmD95i0fYNdqlvHpivanAqV0C9eV5nqD0y2+NjwYJ

On Wed, Jun 08, 2022 at 04:02:42PM +0100, Matthew Wilcox (Oracle) wrote:
> Use filemap_migrate_folio() to do the bulk of the work, and then copy
> the ordered flag across if needed.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Acked-by: David Sterba <dsterba@suse.com>

> +static int btrfs_migrate_folio(struct address_space *mapping,
> +			     struct folio *dst, struct folio *src,
>  			     enum migrate_mode mode)
>  {
> -	int ret;
> +	int ret = filemap_migrate_folio(mapping, dst, src, mode);
>  
> -	ret = migrate_page_move_mapping(mapping, newpage, page, 0);
>  	if (ret != MIGRATEPAGE_SUCCESS)
>  		return ret;
>  
> -	if (page_has_private(page))
> -		attach_page_private(newpage, detach_page_private(page));

If I'm reading it correctly, the private pointer does not need to be set
like that anymore because it's done somewhere during the
filemap_migrate_folio() call.

> -
> -	if (PageOrdered(page)) {
> -		ClearPageOrdered(page);
> -		SetPageOrdered(newpage);
> +	if (folio_test_ordered(src)) {
> +		folio_clear_ordered(src);
> +		folio_set_ordered(dst);
>  	}

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
