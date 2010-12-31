From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 31 Dec 2010 05:14:46 -0800
Subject: [Ocfs2-devel] [PATCH 00/34] OCFS2: Add trace event and replace
 mlog(0).
In-Reply-To: <20101231131020.GA27129@lst.de>
References: <4D12F7E7.1090204@tao.ma>
 <20101231131020.GA27129@lst.de>
Message-ID: <20101231131446.GD21179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 31, 2010 at 02:10:20PM +0100, Christoph Hellwig wrote:
> I really don't like the way this is split into tons of patches, which
> makes reviewing what's going on pretty hard.  In addition to the
> preparatiory patch just one patch is more than enough, or if you really
> want two: one to remove the old mlog code and one to add the trace
> events.

	I have to say, I would have found a single massive patch really
painful to read.  The eye glazes over so many repetitive changes.  But
I've now read it, and we can certainly push it upstream as one commit if
you like.

Joel

-- 

Life's Little Instruction Book #497

	"Go down swinging."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
