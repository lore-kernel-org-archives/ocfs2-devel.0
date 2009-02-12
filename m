From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Feb 2009 16:38:19 -0800
Subject: [Ocfs2-devel] Possible lock inversion in directory locking
In-Reply-To: <20090211235237.GE17410@wotan.suse.de>
References: <20090211175834.GD13817@duck.suse.cz>
	<20090211235237.GE17410@wotan.suse.de>
Message-ID: <20090212003819.GA1706@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 11, 2009 at 03:52:37PM -0800, Mark Fasheh wrote:
> It's not intentional, no. In fact, we didn't really use ip_alloc_sem for
> directories much until recently when Joel standardized it. As far as fixing
> this, I'd say it's best to re-order the locks properly.

	Agreed.

Joel

-- 

"The first requisite of a good citizen in this republic of ours
 is that he shall be able and willing to pull his weight."
	- Theodore Roosevelt

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
