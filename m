From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 17:14:41 2007
Subject: [Ocfs2-devel] [PATCH 14/15] ocfs2: Read support for
	directories with inline data
In-Reply-To: <20070921000454.GH21356@ca-server1.us.oracle.com>
References: <200709192012.l8JKCHo9029366@rgmgw2.us.oracle.com>
	<20070920234740.GF3490@tasint.org>
	<20070921000454.GH21356@ca-server1.us.oracle.com>
Message-ID: <20070921001404.GH3490@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 20, 2007 at 05:04:54PM -0700, Mark Fasheh wrote:
> On Thu, Sep 20, 2007 at 04:47:40PM -0700, Joel Becker wrote:
> > 	Isn't this function basically the center of foreach_blk_el()?
> 
> It's deceptive. Some parts are similar, but many checks are different or
> don't exist in one version over another. The looping is slightly different
> too. The extent based code handles readahead, while that doesn't make sense
> for inline-data, etc, etc.

	Ok, that's what I was curious about.
 
> I managed to consolidate most of the other dir functions though, which I
> was happy about.

	I noticed that :-)

Joel

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
