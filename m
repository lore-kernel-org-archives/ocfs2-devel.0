From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 24 Jun 2008 10:04:21 -0700
Subject: [Ocfs2-devel] [PATCH 0/2]v2 configfs: symlink() fixes
In-Reply-To: <20080624132004.GF7621@hawkmoon.kerlabs.com>
References: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com>
	<20080623222043.GG592@mail.oracle.com>
	<20080624132004.GF7621@hawkmoon.kerlabs.com>
Message-ID: <20080624170421.GC4184@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Jun 24, 2008 at 03:20:04PM +0200, Louis Rilling wrote:
> On Mon, Jun 23, 2008 at 03:20:44PM -0700, Joel Becker wrote:
> > 	Silly question: you've tested this, right?
> 
> Yup. I tested this on Linux 2.6.26-rc5 with a modified example_configfs.c
> (attached), and on a backport for 2.6.20 with my own subsystem (based on
> Kerrighed http://www.kerrighed.org/wiki/index.php/SchedConfig ).

	Excellent!

> Do you have some regression tests?

	No.  I've been meaning to create a complex configfs_example with
lots of different scenarios so I could write some.  Feel free to do so!
	Thank you for sending this along.

Joel

-- 

"There is a country in Europe where multiple-choice tests are
 illegal."
        - Sigfried Hulzer

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
