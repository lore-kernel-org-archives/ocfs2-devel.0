Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 992A5C54EBE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 Jan 2023 08:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GXzfKlFHard2WXUBrMauSiLcNliIhsSOmTJpzYV+smU=;
 b=HodkhBJJo8U+TChRG7IQ1Iw5uJ9wecfRqm4R5hTo+erhHmCrifc2c1n3jZ6rbbyDtDjnrnAa7XHe
   NAFYEuswLw1sEL5dJSpdjVPxerBHtZo2TgGNB9vPOvG/31qDSkplwxDObc/t+tYowXG92rKayiPX
   vCnV/6ttSbE17kfCDoGBTLkwWwoaG22qzrDXgncu4KjFdTIOJDTNtJBScz2J3LTBamc+obBDVqrz
   Uyk9magHCbfx1b9mZ68ca5SCBjrHTWIx4VcuVZGnh6m1G+BlmY2X4dhuvv9UM65R80bDi6pwVgcf
   yw1NKN6RoGna4RSoua+f6G7A44Y/nQhJrKZK2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GXzfKlFHard2WXUBrMauSiLcNliIhsSOmTJpzYV+smU=;
 b=cTQ6oDNsifsBAga199A4w9hQfili6OV3zJK79FXKNUz5mLqKzX1JZ5iN9IS4YRWrJvZoRoQj9op5
   iGUw6jqm3AGZ4labgPuROh2JZvRJem6yQo9RHueZcWz0SsE6pR3MoUWuCKvR9N836UpoMgQzJ1GI
   ARC5rTXXXMrRqLJFE11ZYtW+QF0HaDrW0eOknfXHu6fLRjyAV+QmWAmXhqvW538sb5WkNwdzbr/4
   Qug5KKm8XAYoxZMERjazo6IERU+l2+MyswEktWIR0AL/wJoFSugu+9pBQdYeGDOqcGaVRIQRP4A7
   MM/kICEhDuG1vcYY3Y98kswY6nn96F2KslyS/g==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO900IF8GM133C0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 Jan 2023 08:22:49 +0000 (GMT)
Date: Tue, 10 Jan 2023 09:22:25 +0100
To: Matthew Wilcox <willy@infradead.org>
Message-id: <20230110082225.GB11947@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
 <20230108165645.381077-4-hch@lst.de> <Y7sy5jzjT7tpPX6Z@casper.infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <Y7sy5jzjT7tpPX6Z@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10585
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 mlxlogscore=536 malwarescore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=200 clxscore=258 phishscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100051
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: VyYbwrFnmmqg1QXUiK7dPNNUt8JkMohG
X-Proofpoint-ORIG-GUID: VyYbwrFnmmqg1QXUiK7dPNNUt8JkMohG
Reporting-Meta:
 AAGZgG4uwlfi/VCHrL1B5thfqg7z4bYYjgaWVuO//0Wyyj6TLQv9MTRllt/eFTIf
 Cl/kyNbXr9WZipG26ebgEon3FcjJ99GBqQD+4Q7712NMwGXLK8gwxv810KagBrTQ
 WR0xyDqjx+ijT/e7DxSMk1NliaA6nkCCqC8QuBvQjYlr5lKF4v7O3jhb/5fEsI9Z
 sDpoSdPhQIeoRDHGU4ViJ4E1a3tg6gzKe4xVBig5BrA0EpPJLTTYxypFVLlerncZ
 KEpJSUeb5cqPV3+jwGu30kw9LayrIeuzGEvaesLIToL9MHl0uLlIooPB77SndL1h
 ynp6Ad3KZcS5f6nlNweyDIv1prn5sh0Ad1LlQ2dNDgQ6WuXF/0R/oC1em0GcNZmK
 0+JdylsPmWLVdK+Jvr3+C9OREUXWrnhUkI2wP+UcQHBplNtxeHhSHxnDBqriOZCh
 uXPcVi5IqSSIhvs4ddL8wgTcSUwW9SUDfKJf8c3bACpdrWdiron/PM4+xFtVTCkR
 uYkmnfVLo+nSyHYiwRRdQ/SgVnK1Vu3mUXm+/XO/v9rG

On Sun, Jan 08, 2023 at 09:17:26PM +0000, Matthew Wilcox wrote:
> > +	dir_commit_chunk(page, pos, sbi->s_dirsize);
> >  	dir->i_mtime = dir->i_ctime = current_time(dir);
> >  	mark_inode_dirty(dir);
> > +	minix_handle_dirsync(dir);
> 
> Doesn't this need to be:
> 
> 	err = minix_handle_dirsync(dir);

Yes, fixed.

> 
> > @@ -426,7 +436,7 @@ void minix_set_link(struct minix_dir_entry *de, struct page *page,
> >  			((minix3_dirent *) de)->inode = inode->i_ino;
> >  		else
> >  			de->inode = inode->i_ino;
> > -		err = dir_commit_chunk(page, pos, sbi->s_dirsize);
> > +		dir_commit_chunk(page, pos, sbi->s_dirsize);
> >  	} else {
> >  		unlock_page(page);
> >  	}
> > -- 
> 
> Aren't you missing a call to minix_handle_dirsync() in this function?

Yes, fixed.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
