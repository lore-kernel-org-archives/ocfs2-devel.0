Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60111C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Jun 2022 12:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lsvTSdCvx4A9CIZ+0VYJoywqfayGfkB2eVMZmGomw0I=;
 b=dMBlGIsYGuEQOqfzlLkL6cMr1TJSwMr0OavA6urQlEF6LWktysEm0wfX5+nZoUfhlXZpBiexjdWy
   R7t4XqfLk0wKWElGkX33Hqh0Pw2fOoyqFcVkA+eKVBL5eU3bQfvWsS621cH+wMYavTb03aftsbUD
   FeD7BV3oZNndnymztlLC6lSM/Zq4qZryUL5lHcOvKouiP+bew9bWiomSYx1qz1mThLTIh2AxNDWV
   XcQaF4di7kzvp2rPlmaPC3n5vkZcMc5bNzpOiDCm3SFPL64gKGzknjASHVZEkz0OJbFmTmgvYPgt
   Ga9hLQQ21zXznZyeZjbq8W+ZoMwy1irtykyXNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lsvTSdCvx4A9CIZ+0VYJoywqfayGfkB2eVMZmGomw0I=;
 b=teyUcvfj/XRg3yeiwtcVoCO/K2E9BANdUtG45PBxPGVtFcivNzdYTW/5cbPietajV95dWJcnFnts
   UoxAZSXztLmHCmSJQREFqbpQ+g9tOluU7Pm64or0BQdJGICs6lVYBMzyZipSTLPEIDQ8in1db5Py
   opgge5Lh6zDY72csdyclmEY5hrOE14+M28iyOjEfeDtHJZZc0a1PZn46VjhpG7pyt+YZCO0JBJKM
   qVribcbQhnlqD/YiHrbxP6noWzxdP/3mqE5r834MXki/25HzAf8FtbYPVMg93C9GVEqGKr/Fbq5v
   /3wO+SlW9uy6lZ+h4nooJ1s8HmKYq0aRSs4Hzw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD7007C1NWPLH80@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Jun 2022 12:55:37 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654779024;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jSyVt04wqMoyKuQwGc4zbS9w9C6qNO7mTJG8w/5DiLs=;
 b=Rl3YETfEkiQD6P2TsO5Q+i5VUelvKEU17hm+QH6XVlbmrAJ7L3t+EKioFBQ5V87wSzaX2K
 P9vJkXK6o5F0e3B84HtDADUGHQ9+35O3pCsp1XpTsGXgoMQ02jOISrg18N3vhiAfq/tIlh
 UX1g0Zx+CYCEYOq3jeqHpE2JcOdz03I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654779324;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jSyVt04wqMoyKuQwGc4zbS9w9C6qNO7mTJG8w/5DiLs=;
 b=iIRG3JQ8oAPESvyziWMa5OrxaaNvbTKqU3LyuyRxRYwvJOs7d6FsPjTWlKZpKw+Xp297iL
 KtQQuISqIzrbQOePdf+kYmcB81/XkYe3Jrdh39U3bQB6Kv9g7vw95ki+xvX13bPkoD3G/Y
 hYNIlY/t8udc2fT5CyK3f7gqjNYBSp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:organization:in-reply-to
 :content-transfer-encoding; bh=jSyVt04wqMoyKuQwGc4zbS9w9C6qNO7mTJG8w/5DiLs=;
 b=MDDJhhtUBICQzU8aH44MaYkgmwgpTFbev7m9iBBsLND7H0TEaKanD0B9j2I1D8JKMb
 htEdQVwwvULRP+z6zDIZB8ZkGrmXlVGoACVT3n54gjd1/u5rUdi4gLxnJCoNpAJuFu0B
 un0lEhffcJ74Gbproj6wFgFcjg13sLA8qiGnVQj1V9zb9gwluDbITWlTlHsf0ZbRj7L4
 Mfo0D1YcB3Y1Wxs0qHYhjeN9of2U9zdLCCTjfSMiSoLxrREyp9/mJ/hDiq4lh5O6wWYx
 BeoOScY3GuoFHvbQoGiGxGS+bQiLo+ottGBMuq0SWUnYlXih/UJEHRDVLAuhWmAiQ5vU xepQ==
X-Gm-Message-State: AOAM530s5kJSbwukEM5o6R3qDaoOpC9b20RsidC1sLWzxC7S82JSg/jz
 J0jsDjjOO8HQTn9VzvQMGqx9TajsZ2uyLhDSZYClJvzgsoiH4E0XSPuBoUjTMQtOLOC3dPfgiuI
 dY+y7vbHf7QL1mOiuhe4w1A==
X-Received: by 2002:a1c:4c0d:0:b0:39c:5233:1873 with SMTP id
 z13-20020a1c4c0d000000b0039c52331873mr3299351wmf.28.1654779022065; Thu,
 09 Jun 2022 05:50:22 -0700 (PDT)
X-Received: by 2002:a1c:4c0d:0:b0:39c:5233:1873 with SMTP id
 z13-20020a1c4c0d000000b0039c52331873mr3299322wmf.28.1654779021707; Thu,
 09 Jun 2022 05:50:21 -0700 (PDT)
Message-id: <b2a81248-03fc-afb3-1041-d8206e95e08a@redhat.com>
Date: Thu, 9 Jun 2022 14:50:20 +0200
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-4-willy@infradead.org>
Organization: Red Hat
In-reply-to: <20220608150249.3033815-4-willy@infradead.org>
Authentication-results: relay.mimecast.com; auth=pass smtp.auth=CUSA124A263
 smtp.mailfrom=david@redhat.com
Content-language: en-US
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2 03/19] fs: Add aops->migrate_folio
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
From: David Hildenbrand via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: David Hildenbrand <david@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: blKD2SJvNmebIPV-UKsAcg-1
X-Google-Smtp-Source:
 ABdhPJyJlGErsfVOd4GnScqiilTH958FLxgjsObuI+18makmIYSKefVpu0HdsVXKQhmSAU7kjNobOQ==
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
 ip4:103.23.66.26 ip4:103.23.67.26 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
 ip4:103.23.66.26 ip4:103.23.67.26 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: 8iY0mMYkvwINVAUxvSFsIkOUSQjRMUoP
X-Proofpoint-ORIG-GUID: 8iY0mMYkvwINVAUxvSFsIkOUSQjRMUoP
Reporting-Meta:
 AAFeS6bZQ22TMjiMsntozogy90tkIzman78dYx+mSgbeby0T6Lb5zgpwakbbeRy3
 u90+z+A9/tBc8B/G7ErvaWh9aq7IzNNQNeaAuUdHE8veyG1x4M6oiPUVrr0iuK7I
 QHbNWBaLnDEhjHRMT239hY0sZDnb6r67adKTpCzpCmb3hAHsFiu+8MgL/wfOyi/f
 y0MzOCk09KYZyIHaf3L2Hfe+6uQLvE76ckJ8SMZ6+ZgOidwjBB3ouxt8ALN5XSBn
 K4mD/7T2bB05TdUVRXBFtwLZBeMXxhf+zxvqOxufBaWVYuhby3/g15VcSEwjEzPU
 EdPD0GtGQS3ntuNdwK4IHtd+mGY3mCRGd9KF/Yw0kxBJAHlaeGMdR9Fa1wAi/5I2
 YBw7cdeUJI/4du5ZdKkMrDzg6RuxIfdKH0RnbD15RqCjtG9ZXjsA21YWxnh+sQZO
 xim1diyugK6rik9mK7gfkq5ZvgbeGip2yXhMP3CbZDKSoMhai2LQytf7nqRk86EX
 vy6qZv0UND0Stj2fYjhyZEkPyJKPiU6+2NeRA5iLhTj4

On 08.06.22 17:02, Matthew Wilcox (Oracle) wrote:
> Provide a folio-based replacement for aops->migratepage.  Update the
> documentation to document migrate_folio instead of migratepage.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/locking.rst |  5 ++--
>  Documentation/filesystems/vfs.rst     | 13 ++++++-----
>  Documentation/vm/page_migration.rst   | 33 ++++++++++++++-------------
>  include/linux/fs.h                    |  4 +++-
>  mm/compaction.c                       |  4 +++-
>  mm/migrate.c                          | 11 +++++----
>  6 files changed, 40 insertions(+), 30 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index c0fe711f14d3..3d28b23676bd 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -253,7 +253,8 @@ prototypes::
>  	void (*free_folio)(struct folio *);
>  	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>  	bool (*isolate_page) (struct page *, isolate_mode_t);
> -	int (*migratepage)(struct address_space *, struct page *, struct page *);
> +	int (*migrate_folio)(struct address_space *, struct folio *dst,
> +			struct folio *src, enum migrate_mode);
>  	void (*putback_page) (struct page *);

isolate_page/putback_page are leftovers from the previous patch, no?

>  	int (*launder_folio)(struct folio *);
>  	bool (*is_partially_uptodate)(struct folio *, size_t from, size_t count);
> @@ -281,7 +282,7 @@ release_folio:		yes
>  free_folio:		yes
>  direct_IO:
>  isolate_page:		yes
> -migratepage:		yes (both)
> +migrate_folio:		yes (both)
>  putback_page:		yes

Dito.

>  launder_folio:		yes
>  is_partially_uptodate:	yes
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index a08c652467d7..3ae1b039b03f 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -740,7 +740,8 @@ cache in your filesystem.  The following members are defined:
>  		/* isolate a page for migration */
>  		bool (*isolate_page) (struct page *, isolate_mode_t);
>  		/* migrate the contents of a page to the specified target */
> -		int (*migratepage) (struct page *, struct page *);
> +		int (*migrate_folio)(struct mapping *, struct folio *dst,
> +				struct folio *src, enum migrate_mode);
>  		/* put migration-failed page back to right list */
>  		void (*putback_page) (struct page *);

Dito.

>  		int (*launder_folio) (struct folio *);
> @@ -935,12 +936,12 @@ cache in your filesystem.  The following members are defined:
>  	is successfully isolated, VM marks the page as PG_isolated via
>  	__SetPageIsolated.
>  
> -``migrate_page``
> +``migrate_folio``
>  	This is used to compact the physical memory usage.  If the VM
> -	wants to relocate a page (maybe off a memory card that is
> -	signalling imminent failure) it will pass a new page and an old
> -	page to this function.  migrate_page should transfer any private
> -	data across and update any references that it has to the page.
> +	wants to relocate a folio (maybe from a memory device that is
> +	signalling imminent failure) it will pass a new folio and an old
> +	folio to this function.  migrate_folio should transfer any private
> +	data across and update any references that it has to the folio.
>  
>  ``putback_page``
>  	Called by the VM when isolated page's migration fails.

Dito.

> diff --git a/Documentation/vm/page_migration.rst b/Documentation/vm/page_migration.rst
> index 8c5cb8147e55..e0f73ddfabb1 100644
> --- a/Documentation/vm/page_migration.rst
> +++ b/Documentation/vm/page_migration.rst
> @@ -181,22 +181,23 @@ which are function pointers of struct address_space_operations.
>     Once page is successfully isolated, VM uses page.lru fields so driver
>     shouldn't expect to preserve values in those fields.
>  
> -2. ``int (*migratepage) (struct address_space *mapping,``
> -|	``struct page *newpage, struct page *oldpage, enum migrate_mode);``
> -
> -   After isolation, VM calls migratepage() of driver with the isolated page.
> -   The function of migratepage() is to move the contents of the old page to the
> -   new page
> -   and set up fields of struct page newpage. Keep in mind that you should
> -   indicate to the VM the oldpage is no longer movable via __ClearPageMovable()
> -   under page_lock if you migrated the oldpage successfully and returned
> -   MIGRATEPAGE_SUCCESS. If driver cannot migrate the page at the moment, driver
> -   can return -EAGAIN. On -EAGAIN, VM will retry page migration in a short time
> -   because VM interprets -EAGAIN as "temporary migration failure". On returning
> -   any error except -EAGAIN, VM will give up the page migration without
> -   retrying.
> -
> -   Driver shouldn't touch the page.lru field while in the migratepage() function.
> +2. ``int (*migrate_folio) (struct address_space *mapping,``
> +|	``struct folio *dst, struct folio *src, enum migrate_mode);``
> +
> +   After isolation, VM calls the driver's migrate_folio() with the
> +   isolated folio.  The purpose of migrate_folio() is to move the contents
> +   of the source folio to the destination folio and set up the fields
> +   of destination folio.  Keep in mind that you should indicate to the
> +   VM the source folio is no longer movable via __ClearPageMovable()
> +   under folio if you migrated the source successfully and returned
> +   MIGRATEPAGE_SUCCESS.  If driver cannot migrate the folio at the
> +   moment, driver can return -EAGAIN. On -EAGAIN, VM will retry folio
> +   migration in a short time because VM interprets -EAGAIN as "temporary
> +   migration failure".  On returning any error except -EAGAIN, VM will
> +   give up the folio migration without retrying.
> +
> +   Driver shouldn't touch the folio.lru field while in the migrate_folio()
> +   function.
>  
>  3. ``void (*putback_page)(struct page *);``

Hmm, here it's a bit more complicated now, because we essentially have
two paths: LRU+migrate_folio or !LRU+movable_ops
(isolate/migrate/putback page)



-- 
Thanks,

David / dhildenb


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
