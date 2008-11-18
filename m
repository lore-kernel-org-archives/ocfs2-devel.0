From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 18 Nov 2008 15:15:17 -0800
Subject: [Ocfs2-devel] New OCF edition of o2cb
In-Reply-To: <02292B9D-C88D-4262-AADF-3820512DC60E@suse.de>
References: <02292B9D-C88D-4262-AADF-3820512DC60E@suse.de>
Message-ID: <20081118231517.GD10451@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 18, 2008 at 11:30:18AM +0100, Andrew Beekhof wrote:
> Here is an OCF-compliant edition of o2cb for use by cluster managers to 
> control userspace-based OCFS2 installations.
> It defaults to using the pcmk stack, but can also be configured to use  
> cman.

	I'm guessing this is basically the same as o2cb.init, but using
configuration and constants used by OCF?  Coolness.
	Why does it need to 'default' to any stack?  o2cb.init gets the
answer out of /etc/sysconfig/o2cb, and I would assume OCF would have a
similar sort of thing.

> I believe the correct location for it is vendor/common

	Yes.

> Oh, and if the license is an issue, it can be changed.

	GPLv2 is exactly what we use.  You can remove the paragraph
about "If you didn't receive a copy of the GPL"; the FSF has moved, and
they recommend removing that paragraph.  Regarding Copyright, much of the
code comes from o2cb.init, which is Copyright Oracle 2005,2008.  Please
add that copyright.

Joel

-- 

"The question of whether computers can think is just like the question
 of whether submarines can swim."
	- Edsger W. Dijkstra

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
