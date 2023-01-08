Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9CC6C54EBD
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 21:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MV2ESx+4QBtHlg9bTIQ1GC+1ssfEzO3K6IyPYdAncxs=;
 b=w12xvj/3dLCplrM0rfJK9Sby+gmE358U92DTMFywyVRg1uCev8YK3g461yGSlp7IZbdDlGAy6o7f
   TNAo20/bcQYE4prxshcU3Wrpq0Psm14QkKMDXSJ8XP/l1Wh8DqiesvdAln1E5Lr6DXsgaAyPUB6d
   M4pUsjYeOgnx1+Y47RJ5aR0rr1RqlSgXkkS6dm8FAeCHSxZ4CGWpCdEkBQmv0Wy3TmLkE9Eess9p
   Ax1nQtM4bwfG/DS1sjvQpoPgTgBXYnL050Z8RN24VH66o33WBUOE95cYxMFWyc2aFXJkx4id5Mai
   kuXn9RAUCpBIrz+sgGGaQ+czRtXedcBtN6gDVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MV2ESx+4QBtHlg9bTIQ1GC+1ssfEzO3K6IyPYdAncxs=;
 b=Y9vyc8hZ36rduyjcLWzwDKOgUjWCHnkno+IeQ6XBCsBtLImj40RabH6leDjtyV01Mz6talWoCrxL
   /Ebr0+ElsV3I/ouUZz82q6ZLL30MbcrvKURSq0uso5xRGbWB+ij9cTuvAhRTLcEFdIsroOsGaoHg
   gZzlOqzA1tg0MeUh5eL+yoU5TEyehVN1CRhzomaO29fXsoQtfZ/RR/OXRKA7jGvxojwZzarHhhyi
   78Nv3aQne9LigSMTsr+Lu36e4Kbv9gyTXbSZdKgAnQ8fG23TW6U8lenfa4H0t19YWvG80refQkd3
   /cSeV54GyH4eWNBclTt4ZDDXEMdBW5wplalRFA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600AKQR5JPK20@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 21:17:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=+fTNevAqKk/KH5jQmB577WyYwIjJaGXSYo1Kkw8//U8=; b=byUKNGetm3skpB0osIZdzjmVcj
 gX2dVF3m2fMEnkOaV+kh6gvARpBZ7AFyfxgY+L1iGfpdfGfjVTHL9xxoF4NlkjqYeIaQLwOSl+Mtl
 4Sa3NFJyeX0+o+I3BQS8ART4Ltabft8TVIJwxwfwQ9nMYccsrJmcldxE+CTmKur3Bs+uvJ+oF9CgA
 aPIoqFVfFK2QUuQ7BDYMSYt74tm/fN5lm2i7/Za+hVv4N+RLcV8ktrebKs/bSETE8RZTA4ZxkhNE0
 u6tAe/HAvZcOUtIpTcGGV/A/eQ1GwLN3mPr8I1VwHlpv4keaJQ0vmIEQNNgsdYSo1bq9yynXC37jl
 Eu6oRbmw==;
Date: Sun, 8 Jan 2023 21:17:26 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <Y7sy5jzjT7tpPX6Z@casper.infradead.org>
References: <20230108165645.381077-1-hch@lst.de>
 <20230108165645.381077-4-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230108165645.381077-4-hch@lst.de>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=-8
 mlxscore=0 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 mlxlogscore=412
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301080159
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
From: Matthew Wilcox via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Matthew Wilcox <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 7ssJw6yNBqhMT3REYhp0lTgcO-Itzmgj
X-Proofpoint-GUID: 7ssJw6yNBqhMT3REYhp0lTgcO-Itzmgj
Reporting-Meta:
 AAEecYacI10oETM84jpM5CwXYyD0dLsr04qrhRmCqU2Vw5Wnfz3lljJPg283Om5X
 QAQusiwU54QAr4Pe7ryIiG1LwzeXGuiVBj37612fKE2zAKnzuXh5n9ZE0zCl6cFR
 o2msCATFTvTdg3/6Xv+eEcQgxcB8+/5CmDQy7QVyyebN/vw/S/2Xx4J+Ssggosdl
 uW3EMvFiKtVi8fTh+apIcKeXedejY2nnoHrYnzXGUsz6K9gIgs+kONfDdhrnRv3h
 0mEeKFJUdcDvZ6GmO6pV1wj8SWemaEiA5vqP6LtOoLC0bxklwhcxmYfZE5HJpmsD
 IPGjFsK6Oe66BjpUOz8Hbvqleh+JIsZ/Zq4cJucKnrt2VrqvweqysZdi6S/ecsTH
 vjXtem3wrmtjz6H0RdNJYsmeKfEgoUQV7XeMQA4uqDyj/TFQykbqStBk1Ou+SrXl
 Tb/ILzY1fDD82D25jZ8U2rUlSap1o1kYG3O7kov/bEzOM90YTJn8Hj1TU+xoWdaS
 0PX8c2pPlEhLv9rpUE5KQT0uLE3+NrAYyGfffdXOisc=

On Sun, Jan 08, 2023 at 05:56:41PM +0100, Christoph Hellwig wrote:
> @@ -274,9 +280,10 @@ int minix_add_link(struct dentry *dentry, struct inode *inode)
>  		memset (namx + namelen, 0, sbi->s_dirsize - namelen - 2);
>  		de->inode = inode->i_ino;
>  	}
> -	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
> +	dir_commit_chunk(page, pos, sbi->s_dirsize);
>  	dir->i_mtime = dir->i_ctime = current_time(dir);
>  	mark_inode_dirty(dir);
> +	minix_handle_dirsync(dir);

Doesn't this need to be:

	err = minix_handle_dirsync(dir);

> @@ -426,7 +436,7 @@ void minix_set_link(struct minix_dir_entry *de, struct page *page,
>  			((minix3_dirent *) de)->inode = inode->i_ino;
>  		else
>  			de->inode = inode->i_ino;
> -		err = dir_commit_chunk(page, pos, sbi->s_dirsize);
> +		dir_commit_chunk(page, pos, sbi->s_dirsize);
>  	} else {
>  		unlock_page(page);
>  	}
> -- 

Aren't you missing a call to minix_handle_dirsync() in this function?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
