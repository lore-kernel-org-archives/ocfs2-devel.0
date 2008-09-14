From: Mark Fasheh <mfasheh@suse.com>
Date: Sun, 14 Sep 2008 01:40:03 -0700
Subject: [Ocfs2-devel] [PATCH] jbd2: Create proc entry with
	bdevname+i_ino.
In-Reply-To: <20080908233114.GD20100@mail.oracle.com>
References: <20080908233114.GD20100@mail.oracle.com>
Message-ID: <20080914084003.GP4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com, sunil.mushran@oracle.com

On Mon, Sep 08, 2008 at 04:31:14PM -0700, Joel Becker wrote:
> jbd2 currently creates statistics files for each loaded journal in
> /proc/fs/jbd2/<bdevname>.  ocfs2 loads multiple journals when recovering
> other nodes, and the multiple journals on a given bdev collide in the
> proc namespace.

Did this patch ever get reviewied? We'd really like it in so that Ocfs2 can
use JBD2...

Thanks,
	--Mark

--
Mark Fasheh
