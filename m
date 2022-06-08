Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB19C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=e4ZtZVL2KA4+YKDU3gwSukBH4pWaHmGX4gs6TiuAA8c=;
 b=SK0PN2gl03WEpcSIUfzccjcPU0XtxCyjjrDAtS0jGik7VCwUlNoJRc8kuOLt+I5sma2tu5YMIR5x
   CwFIdDhUgO0e1gUPvXhuRIy5QjGsivhWyAdua/TLCMAi3g1qJIjn4g6gOEwJxT4zZNUcJlsnGqh4
   7p1cTbWNX9MoVlD8vaSl7zWERxXiJNggtRep0jEdSWIYwyS4V3IeRhAnyQF+T3kpzN2lmwKsm3aG
   8lIm9a20MBuklciLfJR2/BbEn9hqbpor5T4yNsUsI78GltCJ1OMSaEQjqEvbAw97/QD6oU9RDexF
   pn6hfIR5LyGQoOJCQw7qmG/6dxX1wDSLUDEKCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=e4ZtZVL2KA4+YKDU3gwSukBH4pWaHmGX4gs6TiuAA8c=;
 b=ri6248m3aLDHoiRBDq7c9hApCDFdEZ8M7kQAEfIEpuMAy6KGrLFN2Pvub95W7MnTf8nNvmljGghF
   4nyhC/5k2iInqp/5Bb9WxZToiICrRpVv6qXUPIjy8nM6q4tcZYIVjf9VhNeXGCWTz2obS8L5rGYF
   ZKqCuL5ucafkE0jGGyZlg8tBTOti/9olOH+FI7OEZiGdof2yjKvONCHjF1GTC6sVmUTAB/fxtgbl
   Ans4ycqn4iJfTaOA0rUO/Uqo8UYA/66RZV4L3RYlAAw4/7Z1TEZ9sgZPwQrEFzZDd8R/MGwXTswm
   JcB+CVJLKeX3PAXk5SU8LPars8E+1essLpS5kg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD600BUC02N6T10@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:23:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1654701776; bh=SgYW51aN3OeqjU6+EIk8CHclo6M6cc2uvUEPUetN9AY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=p7z+0eY7ntbEVxA2gI3ZDLWM0mQwSUHKo0XnCgV0chmlHkz2P/vCANEjmqGsAdwGb
 EoSpjHFAP8n9bDzPCEYaP1TdvsHfTZs7ZO2YCb1PhaDgWMEewk0XhfG2S7DJV8N6Zq
 6BFFHYmv/C0EtAhNH8ykQ23VCX1LuObfUCtnf/2zRNky8BKsi3YeFoHUI0AgtoZtnU
 /s5ocIdJDBgJaNkjIJoR2ZyE63FMuzKBldotmlU9Pd6NrsbPX3n/4O3QNinmpI+xhS
 eF/3KfLyFpQXF2Gi5KoPPct1DqMaQ4m32g9c7heF/cNtqM6cQYwdFJN5c8DpxFzwH1
 PF1h9+AG7Xw/A==
Date: Wed, 8 Jun 2022 08:22:56 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqC+0J9/P1siKkBk@magnolia>
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-12-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220608150249.3033815-12-willy@infradead.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2 11/19] mm/migrate: Add
	filemap_migrate_folio()
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
From: "Darrick J. Wong via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Darrick J. Wong" <djwong@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: beSsk4C_eXnxSUqX-bHmHg4VCy13fvib
X-Proofpoint-ORIG-GUID: beSsk4C_eXnxSUqX-bHmHg4VCy13fvib
Reporting-Meta:
 AAHJO9aEsJOTJwAsJu37n/pbcHb37DX0hLGjbNmU78lmr8/QNzH19izNQ2HZfEz0
 rKzfV6cnkaBWzlDfdb7VlL0VlmaS56suk5QiIYmriGlrMjnKnt4T3Z1uCQxQILIJ
 JehRcL0bPhb4bkqSeos/7OZKdaS4xV07EQGtOizmcGBYdJ76odyeIAp3a2yeLWnI
 A6ODR8jJpCz25CL+exPLDzTEZxpCO6hdqIHEn7h4wgMNwy6I00zwWiRfbS7bpyaS
 Ih3m73g58Xd/UmlFUCuXDlhwqL1i46XJY0D/dmTY/+nSRap72hyuq52XORzOdx00
 d0bbi5MolsbOrR97ksPWexz3TYSPK+It6KaLagS95LAYhkWO0ikguusOVZaGAgzF
 vfsTYGXkZWj0dIpg2wj0YCKgUU6vRwDNAqWMOV4MVXPrTchV0sw4BfGRyOsbVwwB
 7/qVqVMTzOabkGHdIkJgKPFMAx8xGR3VslzbHO9H+wJ2wS6iHvs4G5JjUMoRptc6
 u9w0fAqLzK9OcV5/jakzUxFMq7rOIUzu/PwnhLquhHDX

On Wed, Jun 08, 2022 at 04:02:41PM +0100, Matthew Wilcox (Oracle) wrote:
> There is nothing iomap-specific about iomap_migratepage(), and it fits
> a pattern used by several other filesystems, so move it to mm/migrate.c,
> convert it to be filemap_migrate_folio() and convert the iomap filesystems
> to use it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/gfs2/aops.c          |  2 +-
>  fs/iomap/buffered-io.c  | 25 -------------------------
>  fs/xfs/xfs_aops.c       |  2 +-
>  fs/zonefs/super.c       |  2 +-
>  include/linux/iomap.h   |  6 ------
>  include/linux/pagemap.h |  6 ++++++
>  mm/migrate.c            | 20 ++++++++++++++++++++
>  7 files changed, 29 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index 106e90a36583..57ff883d432c 100644
> --- a/fs/gfs2/aops.c
> +++ b/fs/gfs2/aops.c
> @@ -774,7 +774,7 @@ static const struct address_space_operations gfs2_aops = {
>  	.invalidate_folio = iomap_invalidate_folio,
>  	.bmap = gfs2_bmap,
>  	.direct_IO = noop_direct_IO,
> -	.migratepage = iomap_migrate_page,
> +	.migrate_folio = filemap_migrate_folio,
>  	.is_partially_uptodate = iomap_is_partially_uptodate,
>  	.error_remove_page = generic_error_remove_page,
>  };
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 66278a14bfa7..5a91aa1db945 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -489,31 +489,6 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len)
>  }
>  EXPORT_SYMBOL_GPL(iomap_invalidate_folio);
>  
> -#ifdef CONFIG_MIGRATION
> -int
> -iomap_migrate_page(struct address_space *mapping, struct page *newpage,
> -		struct page *page, enum migrate_mode mode)
> -{
> -	struct folio *folio = page_folio(page);
> -	struct folio *newfolio = page_folio(newpage);
> -	int ret;
> -
> -	ret = folio_migrate_mapping(mapping, newfolio, folio, 0);
> -	if (ret != MIGRATEPAGE_SUCCESS)
> -		return ret;
> -
> -	if (folio_test_private(folio))
> -		folio_attach_private(newfolio, folio_detach_private(folio));
> -
> -	if (mode != MIGRATE_SYNC_NO_COPY)
> -		folio_migrate_copy(newfolio, folio);
> -	else
> -		folio_migrate_flags(newfolio, folio);
> -	return MIGRATEPAGE_SUCCESS;
> -}
> -EXPORT_SYMBOL_GPL(iomap_migrate_page);
> -#endif /* CONFIG_MIGRATION */
> -
>  static void
>  iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
>  {
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 8ec38b25187b..5d1a995b15f8 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -570,7 +570,7 @@ const struct address_space_operations xfs_address_space_operations = {
>  	.invalidate_folio	= iomap_invalidate_folio,
>  	.bmap			= xfs_vm_bmap,
>  	.direct_IO		= noop_direct_IO,
> -	.migratepage		= iomap_migrate_page,
> +	.migrate_folio		= filemap_migrate_folio,
>  	.is_partially_uptodate  = iomap_is_partially_uptodate,
>  	.error_remove_page	= generic_error_remove_page,
>  	.swap_activate		= xfs_iomap_swapfile_activate,
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index bcb21aea990a..d4c3f28f34ee 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -237,7 +237,7 @@ static const struct address_space_operations zonefs_file_aops = {
>  	.dirty_folio		= filemap_dirty_folio,
>  	.release_folio		= iomap_release_folio,
>  	.invalidate_folio	= iomap_invalidate_folio,
> -	.migratepage		= iomap_migrate_page,
> +	.migrate_folio		= filemap_migrate_folio,
>  	.is_partially_uptodate	= iomap_is_partially_uptodate,
>  	.error_remove_page	= generic_error_remove_page,
>  	.direct_IO		= noop_direct_IO,
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index e552097c67e0..758a1125e72f 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -231,12 +231,6 @@ void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
>  bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
>  bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
>  void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
> -#ifdef CONFIG_MIGRATION
> -int iomap_migrate_page(struct address_space *mapping, struct page *newpage,
> -		struct page *page, enum migrate_mode mode);
> -#else
> -#define iomap_migrate_page NULL
> -#endif
>  int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
>  		const struct iomap_ops *ops);
>  int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 1caccb9f99aa..2a67c0ad7348 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1078,6 +1078,12 @@ static inline int __must_check write_one_page(struct page *page)
>  int __set_page_dirty_nobuffers(struct page *page);
>  bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
>  
> +#ifdef CONFIG_MIGRATION
> +int filemap_migrate_folio(struct address_space *mapping, struct folio *dst,
> +		struct folio *src, enum migrate_mode mode);
> +#else
> +#define filemap_migrate_folio NULL
> +#endif
>  void page_endio(struct page *page, bool is_write, int err);
>  
>  void folio_end_private_2(struct folio *folio);
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 785e32d0cf1b..4d8115ca93bb 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -784,6 +784,26 @@ int buffer_migrate_folio_norefs(struct address_space *mapping,
>  }
>  #endif
>  
> +int filemap_migrate_folio(struct address_space *mapping,
> +		struct folio *dst, struct folio *src, enum migrate_mode mode)
> +{
> +	int ret;
> +
> +	ret = folio_migrate_mapping(mapping, dst, src, 0);
> +	if (ret != MIGRATEPAGE_SUCCESS)
> +		return ret;
> +
> +	if (folio_get_private(src))
> +		folio_attach_private(dst, folio_detach_private(src));
> +
> +	if (mode != MIGRATE_SYNC_NO_COPY)
> +		folio_migrate_copy(dst, src);
> +	else
> +		folio_migrate_flags(dst, src);
> +	return MIGRATEPAGE_SUCCESS;
> +}
> +EXPORT_SYMBOL_GPL(filemap_migrate_folio);
> +
>  /*
>   * Writeback a folio to clean the dirty state
>   */
> -- 
> 2.35.1
> 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
