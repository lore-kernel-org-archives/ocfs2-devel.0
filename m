Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4263DCCA473
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Jun 2022 23:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mumoAk1XUkLaTiba1PAz/0Vs1H0oqkDVufBaBsY3SX4=;
 b=UQLUDzQyubw69wwfwY6QsAZlTA2boiYfOwAON0G1cF4W3ABBTVC6MEVVfT6u9s/1vFBWUOX66/A4
   CA7ElpVE/L05rv49zo0+ZWm9yy5wkKWS0XcvNt1ydXh0+nDjNTJbCimWF2el2f2hZdSMxuEYuSVn
   pGSYmuc13Cjbs368VqDp6auz7mMLUho4pR6NPPUVRxnoE8GHiJpav6hwcSEVpjuQ9iuRbSxhhIrL
   gInX413rLQTGP9xdWCxXRhtxPbLkBgiwIJ6oc2h9d7B/WQL3Vmh/74V2swEZN7A1oYYm93aYP+aR
   u9ZUkEAnh/e3Fy2+KbzUbugI2+IJfLlhJNcERg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mumoAk1XUkLaTiba1PAz/0Vs1H0oqkDVufBaBsY3SX4=;
 b=GA+V3coDdByKHAYs8Zp7F51N3G7e5yaSQnA5bx96M5eWX8zFYlSnn2Sp3iwQ7H2O5Pu+CleU4ieH
   J/mEiglNmwiXOccWikitibdxeuqYojijPjKNUpYiqmYkGGoSsF8XjpRywNWc02QkfncraVbsi2IN
   p+/puXz0A4H4BjEEaze4Ho3NR5UM5TCxIB4doFM9yR0ddGeHYLb4cvsMNCZkDOeyFvX8MUxB32wQ
   NlKoBdJJarF7Sxxu88PhizZePbd5foO1umr+Z5d1h5+M/rWPIP7rxZ7qmv5ATcacVeiCB5BMrove
   T/LFyx1UecSFEXEN8pLCBuzjK3C3x6FIc/eIKg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD800I8CGCB5Z90@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Jun 2022 23:09:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1654816172;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=qJ6CI0mpfkDIaS/pnwJC/3BIuCFzValbcslJLDqCmdg=;
 b=I4/06b2ltiKrPbL7GgKqUfyrBDeCyX3UBUG59EJr4ULzJeSHMklpbChcFfJ1kbSeucBXix
 La6qOv94FBGz6zARxy9vvZ/rfr+o4fJAO1+4sOg84lO5ESeVeDRRH4GNx2iw82Lzfy4RBp
 n/81rXgBPEK2N99/Wl5n9BN9FjCnnSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1654816172;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=qJ6CI0mpfkDIaS/pnwJC/3BIuCFzValbcslJLDqCmdg=;
 b=L3W4XRXz86YAqVEeWGz5ZqCwllS9CYkUvRzkZLgLEjLQjJDb2qGw16RPUqD736ufsddkqi
 GP6X1OhCsdJk3BBQ==
Date: Fri, 10 Jun 2022 01:05:01 +0200
To: Matthew Wilcox <willy@infradead.org>
Message-id: <20220609230501.GY20633@twin.jikos.cz>
Mail-followup-to: dsterba@suse.cz, Matthew Wilcox <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 cluster-devel@redhat.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
 ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org,
 virtualization@lists.linux-foundation.org, Christoph Hellwig <hch@lst.de>
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-13-willy@infradead.org>
 <20220609163323.GV20633@twin.jikos.cz> <YqIwjEO1a0Sbxbym@casper.infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <YqIwjEO1a0Sbxbym@casper.infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10373
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 mlxlogscore=737 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=138 impostorscore=0 clxscore=180 adultscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206090085
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-ntfs-dev@lists.sourceforge.net,
 dsterba@suse.cz, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
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
X-Proofpoint-ORIG-GUID: 32iRXQTd9SsLkO_qEvawtv597IEsS5wI
X-Proofpoint-GUID: 32iRXQTd9SsLkO_qEvawtv597IEsS5wI
Reporting-Meta:
 AAGOUci8Nq+P9oGf/Mb+uJvZEem7sgqNe8k4PtYmPOhOgUJKBn4f0pUJ93u4cWX/
 1wSGSaCUJUdtwlVisXFc8fcV28pNfRoscqeog0G+gpStxLZE2QXtNI8960fewSOA
 bDOTel0tATJ0+KVs/CjGIpjicS6mvwAXq5Ia/w/H6zBw5UNf2qCz+iBbA63gOPcf
 L6YEmFZR7xVk9Gbgo1o+eMtxHDAN8oFCV7dAZKcZxRMwO5MfeJY7NfELbkyA0UOv
 VyZkPrwnkWAWuCY+4g4maJfFQkCSO0dY0IeTTXTLiix6GLXkCDw7WTj9I+eKkBEs
 4Khw4Z8rKZGn/nPPJ2pazy9ZivUaLCh0lYmAwx2yod+2yKA/BIm5+LU+TUx0Sek1
 QQlVaiSakn78jKDiJHioztIb4EJuNZI9UvkrjqZZscPW44J7wcERFDV4yTmP4SbV
 ZGVrlmKOVvmp+6flL2MXirTr3w5J79/H+0iDlu5Vx1B9XBZPJUG97VQh0ozCINJ6
 /aH71lSGZJoFIkv6EMvL3v2Z69P32GV8UCPMbMW6GGU=

On Thu, Jun 09, 2022 at 06:40:28PM +0100, Matthew Wilcox wrote:
> On Thu, Jun 09, 2022 at 06:33:23PM +0200, David Sterba wrote:
> > On Wed, Jun 08, 2022 at 04:02:42PM +0100, Matthew Wilcox (Oracle) wrote:
> > > Use filemap_migrate_folio() to do the bulk of the work, and then copy
> > > the ordered flag across if needed.
> > > 
> > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Acked-by: David Sterba <dsterba@suse.com>
> > 
> > > +static int btrfs_migrate_folio(struct address_space *mapping,
> > > +			     struct folio *dst, struct folio *src,
> > >  			     enum migrate_mode mode)
> > >  {
> > > -	int ret;
> > > +	int ret = filemap_migrate_folio(mapping, dst, src, mode);
> > >  
> > > -	ret = migrate_page_move_mapping(mapping, newpage, page, 0);
> > >  	if (ret != MIGRATEPAGE_SUCCESS)
> > >  		return ret;
> > >  
> > > -	if (page_has_private(page))
> > > -		attach_page_private(newpage, detach_page_private(page));
> > 
> > If I'm reading it correctly, the private pointer does not need to be set
> > like that anymore because it's done somewhere during the
> > filemap_migrate_folio() call.
> 
> That's correct.  Everything except moving the ordered flag across is
> done for you, and I'm kind of tempted to modify folio_migrate_flags()
> to copy the ordered flag across as well.  Then you could just use
> filemap_migrate_folio() directly.

Either way it works for me. If it would mean an unsafe change in folios
or complicate other code I'm fine with the migration callback that
does additional work for btrfs that could be changed later.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
