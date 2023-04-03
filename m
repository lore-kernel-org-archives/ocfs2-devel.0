Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B5CBC76188
	for <ocfs2-devel@archiver.kernel.org>; Mon,  3 Apr 2023 14:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ePfZOSJlzRRbetCt6QY9L5NgHI2N83STLQlGSvJ+llI=;
 b=doLqiZCFX0XqYsftkQtNHmIjoxFMwGVT/k0Wl0K/5hPrW/AMIkOE4PLiKpTAGC8knYYnJ+wyIRAT
   3Kz3xW5+SgB9ybYnZROfriuJ7lvZFEcGAaVbtGHGWe9tZzKGiw7agjfer6Q4UStXDMNRFpKF00qX
   RorYAO1NBtnodJMz1X2I+0nwNt/74bVVaDFwClgFFn7HNpSC8j/bQBu6r1O2Y+TTijPGifQQ+ou+
   DbLBwmyY+EhB3jJH/Pa9DRrQqQFvB9QAiSp1EZwynNfQA+9ezTft8ptgLdesEUq1wRiKuOjvCdgk
   33LXHNM8DYc+sP6ipUrPy+UdrRv2ShveigoHIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ePfZOSJlzRRbetCt6QY9L5NgHI2N83STLQlGSvJ+llI=;
 b=e+m1yiYxaS8UI9VBhqIXMQ/As5XHXxcD0NrvfHArGiR4kBnRYDVvUyZmqJjx29XAI43BKisue0Cx
   m+T3+YTQriTVAPM/2hE5SV9PUdkM4B91VwK+tkvOBEy/aCAJsyP3ZVy1jnAH95uHedSLP8HKMp4c
   WBvNMFPWcmwZWEs4ItMx7Ro27Ycf4oVThlglFl8UJfdgarDXDqSN4BtuCV44KXCZ16vPpsxda/KK
   UZKgzOt+3oPbop5CJ6aYfe5JBJ5iwM7UbQj/fS0DXYXzqEgBZiOPwuXHIvakyQCvZT9WGhXgsCni
   8h53TkoFu2M8cs79f0pwANvQbWrGvBRbGODI3w==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSJ007AJMMBGVC0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 03 Apr 2023 14:22:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1680531761;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=R46s3dzmAWjax7iXZKikFYCLr1xSbo6uFhX0zzjg4pU=;
 b=XViU3+ETjmX+Zv1i3Q4VVTn7Ny+KHI+pcGRnoPPT3r61aXIzJBxPYzNkNl9++TJ9aBjV6M
 pj5xzmCEcljzJ3VrWr7zg8WDaJErfGUilAp+755lKhp6uAWpsjuSCcyiyy9snmSveJO8Pa
 dYp4hCNxKq+rm1Sy8iI/zHvhEXqBk/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1680531761;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=R46s3dzmAWjax7iXZKikFYCLr1xSbo6uFhX0zzjg4pU=;
 b=U1FjLpLfehFJEz9putWhis2w9XqHu0U3h3oaiL98jCSHliu31HtoSv01Qgpvds/nc1S0hp
 frS9z8ZPoJjwAoCw==
Date: Mon, 3 Apr 2023 16:22:40 +0200
To: Matthew Wilcox <willy@infradead.org>
Message-id: <20230403142240.ftkywr3vn3r73yva@quack3>
References: <ZBCJ11qT8AWGA9y8@casper.infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <ZBCJ11qT8AWGA9y8@casper.infradead.org>
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10669
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=2
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=2
 clxscore=180 priorityscore=70 phishscore=0 mlxlogscore=173 malwarescore=0
 impostorscore=0 spamscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030104
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 Evgeniy Dushistov <dushistov@mail.ru>, linux-ntfs-dev@lists.sourceforge.net,
 ntfs3@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-mm@kvack.org,
 devel@lists.orangefs.org, linux-fsdevel@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-afs@lists.infradead.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] RFC: Filesystem metadata in HIGHMEM
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
From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jan Kara <jack@suse.cz>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: 4TfCpcI6_ttxQ2m0VRwx3UYCX2jPQrYO
X-Proofpoint-ORIG-GUID: 4TfCpcI6_ttxQ2m0VRwx3UYCX2jPQrYO
Reporting-Meta:
 AAHDaTSFheuU0GW4piZb3enRlLQzkCYt/N8qFvwT5dJ6hQrEqMwaW0d5G9AxY1J6
 K0M9WZvscddEh9etF9xC9q14ki5bKzi2gB9S4ETsEHwy9M9c2pyj3OMf+VYPSGzo
 aJsXnq8VIW5yQYbHP6dOlN34XO8cXaFRyu0mc2HmoOc0kMTEGQLP18s6nOjkGb9G
 kw7Ws/XXQx22NPZwSweKkhJ5fB2hvmGEDiAbHnvnuWLXfNj0vbC6RjYLulGyPH2w
 M3IxaODJsiy/Rvxzkim3W8a8qexY/9TqbYjmQokZQM0xCRfLjD8q6HcZ1uYJnMSV
 sp01x5foam+neW2rShGGBRDrx2JIKfW6i35fHYo6aIjKtjkjCH1T7LqT5T8zzQ7M
 tJR9XPTRKRjc/qJ/vYlFO6T7eV4doxZULmN2s4hVEcN0qwzqfXo04/LyrhWGMuuF
 JL7xeReCN0VULYBU/7PvVo9ECsj6lsWKJew0s+8oo1xPHkAWP0E9HfF7AzdfY6SX
 3MEXaleTM0UKQnr+zuz8N+Fr4SjrG3CebciKs7P47uY9

On Tue 14-03-23 14:51:03, Matthew Wilcox wrote:
> TLDR: I think we should rip out support for fs metadata in highmem
> 
> We want to support filesystems on devices with LBA size > PAGE_SIZE.
> That's subtly different and slightly harder than fsblk size > PAGE_SIZE.
> We can use large folios to read the blocks into, but reading/writing
> the data in those folios is harder if it's in highmem.  The kmap family
> of functions can only map a single page at a time (and changing that
> is hard).  We could vmap, but that's slow and can't be used from atomic
> context.  Working a single page at a time can be tricky (eg consider an
> ext2 directory entry that spans a page boundary).
> 
> Many filesystems do not support having their metadata in highmem.
> ext4 doesn't.  xfs doesn't.  f2fs doesn't.  afs, ceph, ext2, hfs,
> minix, nfs, nilfs2, ntfs, ntfs3, ocfs2, orangefs, qnx6, reiserfs, sysv
> and ufs do.
> 
> Originally, ext2 directories in the page cache were done by Al Viro
> in 2001.  At that time, the important use-case was machines with tens of
> gigabytes of highmem and ~800MB of lowmem.  Since then, the x86 systems
> have gone to 64-bit and the only real uses for highmem are cheap systems
> with ~8GB of memory total and 2-4GB of lowmem.  These systems really
> don't need to keep directories in highmem; using highmem for file &
> anon memory is enough to keep the system in balance.
> 
> So let's just rip out the ability to keep directories (and other fs
> metadata) in highmem.  Many filesystems already don't support this,
> and it makes supporting LBA size > PAGE_SIZE hard.
> 
> I'll turn this into an LSFMM topic if we don't reach resolution on the
> mailing list, but I'm optimistic that everybody will just agree with
> me ;-)

FWIW I won't object for the local filesystems I know about ;). But you
mention some networking filesystems above like NFS, AFS, orangefs - how are
they related to the LBA size problem you mention and what exactly you want
to get rid of there? FWIW I can imagine some 32-bit system (possibly
diskless) that uses NFS and that would benefit in caching stuff in
highmem...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
