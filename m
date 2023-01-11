Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50541C54EBC
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Jan 2023 02:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=C1eYXj+hdVpa4BJOohF8d6oNFov9Spg3UlUuHf242Jk=;
 b=y1YPq6uo5zdoTduUhqT6WetnZ4JUy6P26A79Y97g9j923RGgbtWJC7PBJKHG6ZeZE0g4Sv7x9vVU
   25YjwCamwDYzyTK+4VWC+fRviyJcr+G4QVzM1XbiEJzxNvGJWCA+oxkdKTb1qBNWMyJ10nCa/yGe
   6omMLdQ75o+DpkAo9SsYsqoSlNOzYYkBR9fbnHKsaJzzCekY8fy3T51Tnf92Wb+FOyMPjtJ0SXhB
   wvCC3q2/EAVZgSmBjQ2N0N5bbVpyrwpU4Db1XX+Aq5mc2TMr2FLDIF7/Rb7lQneXlswZNc4TN5zD
   TVo4YThi4gLv+XDgkPDhxMxdWnw64O23zJvqhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=C1eYXj+hdVpa4BJOohF8d6oNFov9Spg3UlUuHf242Jk=;
 b=NGf48/gzp/wc3OgFsWzf4en9xUPh0PovYK4XgvueFaCrb0Aqto1qkYbLV/fn4uiZCk+YXnEGyAEY
   RkOQ8d0uIHu8rjiMTsLgKpUb2dAoefRxl+wM44cYgvAQfbIPboY1XqNaN0ZvlXnK1HErbltH6DqV
   SKeb8rx5/DBSnImqsmblJ2uaqXTd0rJxHBKk0fUrXKluuSxYyb0K+zk3WvbWcb7QH7RcF6rS6Aqp
   nB+mdr2ZxgRCVSdPnMb88HcA/HhKtjtO0jha3BfGo8VmC+Jsh815ElHoZqnk8Momv87sUdxQ5EuG
   f9w8zTO8Ob0LqBJYVPoEEQrGk6uvAafQKKJsRg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROA0015NUJJ8RD0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 11 Jan 2023 02:21:19 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=nC2zRIJsPDH7lfPM013A6ZhKrdzcIixd+v8ICTA/zXw=; b=EJXDRWw922tsBHv8pVihMTfEzX
 cAnh+DIDfy5WK8WpuLeldrQsLeM+U+IDEhfDKkpqfRPo5ltzJrRQJN2h0983eKxZEn/ViZvQT1zw5
 dXZE6B7ajOJP+d079+ZOkU3XjRGF0CBIhvdLilgI3TMdfwzsYv8Hj+L9vHTLYg6953pTPbQgKeBnG
 jKblwmPGe5q2Ukar3+4BVgnbtwgOGcxJvaBJ2QDDdnukNQLNFYs45tV0O+meIHYIoke++yw3YLSEc
 ckkPIEkrGzWzDZEg2WPLfglK5OOx6Ai2BfcMgqkfqHHatTmLIju0/qQmXMpjNhfM21hXR1omDsOhr
 Xvu53ukg==;
Date: Wed, 11 Jan 2023 02:20:41 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <Y74c+WSEajAic3Kh@ZenIV>
References: <20230108165645.381077-1-hch@lst.de>
 <20230108165645.381077-4-hch@lst.de> <Y7sy5jzjT7tpPX6Z@casper.infradead.org>
 <20230110082225.GB11947@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230110082225.GB11947@lst.de>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10586
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=60
 mlxlogscore=544 impostorscore=0 malwarescore=0 clxscore=40 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301110015
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 3/7] minix: don't flush page immediately for
 DIRSYNC directories
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: RBPAXr4UEhamo3wl97PdwOBLFLp4aH2W
X-Proofpoint-ORIG-GUID: RBPAXr4UEhamo3wl97PdwOBLFLp4aH2W
Reporting-Meta:
 AAGTc/kBM69jhyjUDRekzGpjlbecezVI7qezbtFH1nAlU+qTo2Igv/4cT6bw8C3y
 IlKOe+STq98o0icfXiVFdDANAcqTBJ5tNYcKVfT2IXVXWlY9H1LC9e8QaZ27Fq5w
 nnmZR4nUVoPtAHK21KoctRTyFwFWBCLVX2y4h04wsCL8aKF9QWA9mR49tYmFxtsW
 kvGFFNso8LYHKd0eGluWdazz7vYZWv/DVc3ho94/tHDaKJQB/Cd2/mQOcp8nXSBZ
 ezUwgZvJHeMkAd+0exS0ENwghIcTR+XtC2smhby1tsfc6TMBMICTO5C16bxB5Xb1
 ZEwQUrt4EoCYSX5pHxedsN3pqHQPzCQABFh1TU90obvPVIbKdY029ubYpiBozszb
 kuBb3hQVk/CqwBLFaLeb502o1hXGw7rH92tiWKvSwV5luBACjcmEwns10hmQUVQk
 2LPjteYX4sCkTUQz/eNj6YI+GXHqh0oRfsJsVbaDtSKZXcFevl3i54XJM7eW+Jkh
 AUkRH67uNUFIVxNVryaj1k9W9/9ItZYzMZLndxHg1qEE

On Tue, Jan 10, 2023 at 09:22:25AM +0100, Christoph Hellwig wrote:
> On Sun, Jan 08, 2023 at 09:17:26PM +0000, Matthew Wilcox wrote:
> > > +	dir_commit_chunk(page, pos, sbi->s_dirsize);
> > >  	dir->i_mtime = dir->i_ctime = current_time(dir);
> > >  	mark_inode_dirty(dir);
> > > +	minix_handle_dirsync(dir);
> > 
> > Doesn't this need to be:
> > 
> > 	err = minix_handle_dirsync(dir);
> 
> Yes, fixed.
> 
> > 
> > > @@ -426,7 +436,7 @@ void minix_set_link(struct minix_dir_entry *de, struct page *page,
> > >  			((minix3_dirent *) de)->inode = inode->i_ino;
> > >  		else
> > >  			de->inode = inode->i_ino;
> > > -		err = dir_commit_chunk(page, pos, sbi->s_dirsize);
> > > +		dir_commit_chunk(page, pos, sbi->s_dirsize);
> > >  	} else {
> > >  		unlock_page(page);
> > >  	}
> > > -- 
> > 
> > Aren't you missing a call to minix_handle_dirsync() in this function?
> 
> Yes, fixed.

More seriously, all those ..._set_link() need to return an error and their
callers (..._rename()) need to deal with failures.  That goes for ext2
as well, and that part is worth splitting off into a prereq - it's a -stable
fodder.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
