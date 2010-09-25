From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Sat, 25 Sep 2010 18:09:22 +0800
Subject: [Ocfs2-devel] [PATCH 13/20] ocfs2/cluster: Track number of
 global heartbeat regions
In-Reply-To: <20100925094446.GC13387@mail.oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
	<1284504656-2434-14-git-send-email-sunil.mushran@oracle.com>
	<20100925093638.GD3950@laptop.jp.oracle.com>
	<20100925094446.GC13387@mail.oracle.com>
Message-ID: <20100925100922.GE3950@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> > >  	/* live node map of this region */
> > >  	unsigned long		hr_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
> > > +	unsigned int		hr_region_num;
> > 
> > I don't remember clear the value for O2NM_MAX_REGIONS, 32? Will
> > u8 be better than "unsigned int"?
> 
> 	It's not an on-disk structure.  There's no need to enforce the
> size.

I got it. Thanks!

regards,
wengang.
