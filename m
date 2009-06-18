From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 18 Jun 2009 10:21:27 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] orphan lock fixes for local mode.
In-Reply-To: <4A3A65EA.1060804@oracle.com>
References: <4A39F138.9050503@oracle.com>
	<20090618150645.GA7725@mail.oracle.com>
	<4A3A65EA.1060804@oracle.com>
Message-ID: <20090618172127.GA29363@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 18, 2009 at 09:06:02AM -0700, Sunil Mushran wrote:
> Joel Becker wrote:
> > On Thu, Jun 18, 2009 at 03:48:08PM +0800, Tao Ma wrote:
> >   
> >> Hi Joel/Srini,
> >> 	Here are 2 patches for orphan lock in local mode.
> >> patch 1:
> >> 	In local mode, we don't need lvb, so don't init it.
> >> patch 2:
> >> 	In local mode, orphan lock and unlock don't need to go to dlm part.
> >>     
> > 	I would think we don't even need the orphan scan in local mode.
> >
> > Joel
> 
> Tao, Good catch.
> 
> Yes, we don't need the orphan scan in local mount. The earlier patch
> that scans all the orphans slots mount should be sufficient.
> 
> Not calling ocfs2_orphan_scan_init() in ocfs2_initialize_super() should
> be sufficient. But we should add Tao's patch 2 too for completeness.

	Do we need the hard_readonly check like other lock types?

Joel

-- 

"Baby, even the losers
 Get luck sometimes.
 Even the losers
 Keep a little bit of pride."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
