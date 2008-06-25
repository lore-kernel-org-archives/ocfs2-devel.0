From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 25 Jun 2008 13:29:14 -0700
Subject: [Ocfs2-devel] configfs: Q: item leak in a failing
	configfs_attach_group()?
In-Reply-To: <20080625202058.GC14049@ca-server1.us.oracle.com>
References: <20080624141649.GH7621@hawkmoon.kerlabs.com>
	<20080624171051.GD4184@ca-server1.us.oracle.com>
	<20080624180456.GA32036@hawkmoon.kerlabs.com>
	<20080624213439.GB2785@mail.oracle.com>
	<20080625095527.GB32036@hawkmoon.kerlabs.com>
	<20080625202058.GC14049@ca-server1.us.oracle.com>
Message-ID: <20080625202914.GD14049@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 25, 2008 at 01:20:58PM -0700, Joel Becker wrote:
> 	Um, 'A' hasn't appeared yet.  I don't see how it looks up 'A'
> until we're done.

	Oh, I think you mean cached_lookup isn't blocked by i_mutex.

Joel

-- 

Life's Little Instruction Book #497

	"Go down swinging."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
