Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B47C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Jun 2022 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=w/rQ3XAZOCvkwDw7J32ed4CNRbrfV6rT5qBnC/sWFSs=;
 b=yIrpsjqHB5XVT6Gu8ADXOhxsZxHPb32PJVG7kzlWPx9BXad4yzjMkHVehwoaxM+ipTnbi56VntnC
   gSUAqoXB9DetD1SIjpDC+5IIwHkjjxy0edItQEHB1zJJ0R8/aABouqO+RcyhWJCQ99rq7tUYNa0O
   M8TjkDZHL5/qIcs9umyWGvEdgritYkh1AUnpRNxtGs2ZZKAUJdEdG6XdVpUI9aAam8BAvUrfPgPc
   mXkF027FLYu6YDLyqF/lktRkNI6DgUXrEa55TghXzs/OYu9dlVoGAUJGmXTgMBCU6QIzsFjKUdsg
   Ws+VV75+hKKh0ISILStska5QtuUMzBqrxyl2yA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=w/rQ3XAZOCvkwDw7J32ed4CNRbrfV6rT5qBnC/sWFSs=;
 b=RXONC0/7pZAn5Zz/OmJUK63g5Rv4qqcLwk0NnZgfsFxstwXD7uHgoLbdf2EDIDos+R4+jy4ijVpw
   7qWtucsRAChKzx/5Cr5jFLbiw7qn0F1cTatu0mx0i4oAn0bh6OHQUhb6xUbqBwVk/8hjXsV4OMjR
   n9rRo0nUHKByhMRopgHfLkeCZ8VnZlrTftlpF6rTbknJjJIt5B687BwxEvUvwkpBMzF36oeT2vdo
   xODHEWww8Q053SoyQSRcBi2UtFuhT4T5A6ZqYOCz4QnJVWPLtNmZQt1nD7OYGswQpzbO3Ld1Z4u+
   UZpPt48G4WcgybzORfrawcesh1AMEayB73XdXQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD700L3UXVNYPE0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Jun 2022 16:30:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1654792244;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Y2i6/2xfXmqrG3UQrxWuJBZA/au7sKNam077cWguoHI=;
 b=WAFGqmnIhYNvM2ssVKG3KczLLHpzVExLaqbMNaaD4TxG3LoWXkMqgKnr5sAnFUCBPyx6Bj
 RhP7Axe2UJS1vtWME26BQmMzF4seMk852MkeYIJ1XbXQW9TzZc/m/RdeIYLyaRgTqpIusE
 ixbzVs/BQECC0I+aIWNnX7/19GjySKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1654792244;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Y2i6/2xfXmqrG3UQrxWuJBZA/au7sKNam077cWguoHI=;
 b=OcorPq9pvgFSPMUepbubrqyCj9P6m8KkNJ5KgBjsd3ExzLQ6RMGB6JpwEUQqKFOx6b3ocZ
 x6fso1mpPJmN9sCA==
Date: Thu, 9 Jun 2022 18:26:14 +0200
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <20220609162614.GU20633@twin.jikos.cz>
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
 <20220608150249.3033815-11-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220608150249.3033815-11-willy@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10373
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 mlxscore=0 mlxlogscore=490
 priorityscore=181 bulkscore=0 adultscore=0 malwarescore=0 clxscore=177
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206090063
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2 10/19] mm/migrate: Convert migrate_page()
 to migrate_folio()
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
X-Proofpoint-GUID: zlXurjpBhvKtxhQPrrJ6a_fEQLhU5L-G
X-Proofpoint-ORIG-GUID: zlXurjpBhvKtxhQPrrJ6a_fEQLhU5L-G
Reporting-Meta:
 AAGXsLtjayM+od1pv3T8c+cZwyjetd2u964tUKGNQeDodCRrsWyNroYY+8njdaYs
 oJpRMCsrowge91gujMbk79SBr1E0iT53DH+aJ+Bu5KqCDbhwz56WV1O6igo40vWv
 jwqQHoJtjo53PSjJx+72KHRaz6iqJACDFvMg7VGmdXLH+36C+2tKHVnR7o3Ly/d8
 4x+XAXvwWO+025VMmmmzgRbveun/zMIbpx/VCWs44Kb7/1PWU5BAzt0BGRJOXUkv
 lcfPuJe7PD8YBFIo9+eAo8DxdZvuVVi1a0GKx7nXlWFFqq0C+lfrFoFKzHyBb8Si
 lzrYb5RrNhJZxC2L2vl3ZEQLxkSBJhs3DUYvhB8bHqgrSe9/8x3u9npohxFTi/rK
 rzwB7YrqmGCtqVCGkwqZjprK6Fap1VBHnKsbv+XetaEIW0fZkGmLwkqGcPJL4/59
 B0UF/mWTHw8bfRAU5zLxriIazQpKuYPRTFFlj7nojVLtJvncrL6gLHtNRUh/SbJL
 0S0UXHMboVs1FrCoPSI98Rx5FyBhdBq4xKF+O4mVD0De

On Wed, Jun 08, 2022 at 04:02:40PM +0100, Matthew Wilcox (Oracle) wrote:
> Convert all callers to pass a folio.  Most have the folio
> already available.  Switch all users from aops->migratepage to
> aops->migrate_folio.  Also turn the documentation into kerneldoc.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_userptr.c |  4 +--

For

>  fs/btrfs/disk-io.c                          |  2 +-

Acked-by: David Sterba <dsterba@suse.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
