From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 14 Sep 2008 18:19:36 -0700
Subject: [Ocfs2-devel] [PATCH] jbd2: Create proc entry
	with	bdevname+i_ino.
In-Reply-To: <20080914163117.GA13074@mit.edu>
References: <20080908233114.GD20100@mail.oracle.com>
	<20080914084003.GP4563@wotan.suse.de>
	<20080914090306.GF30537@mit.edu> <20080914163117.GA13074@mit.edu>
Message-ID: <20080915011936.GB29193@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@MIT.EDU>
Cc: Mark Fasheh <mfasheh@suse.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Sun, Sep 14, 2008 at 12:31:17PM -0400, Theodore Tso wrote:
> This is what plan to push instead.  It should address ocfs2's
> requirement.  In addition, it reduces jbd2 and ext4's stack usage,
> removes 30 lines of code, and fixes a potential problem with pesky
> block devices which contain '/' character in their names.  Four for
> the price of one!

	I like it!  I don't have time to test it (KS/LPC), but hopefully
Sunil can.

Joel

-- 

Life's Little Instruction Book #222

	"Think twice before burdening a friend with a secret."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
