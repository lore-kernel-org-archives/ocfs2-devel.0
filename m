From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 7 Nov 2008 13:36:02 -0800
Subject: [Ocfs2-devel] [PATCH 0/13] ocfs2: xattr bucket API
In-Reply-To: <20081107212114.GN15154@wotan.suse.de>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
	<20081107212114.GN15154@wotan.suse.de>
Message-ID: <20081107213602.GA28338@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 07, 2008 at 01:21:14PM -0800, Mark Fasheh wrote:
> One thing though - your patches are built on top of our 'fixes' branch,
> which is great for merging down the line. Right now, merge_window will just
> live alone, until Linus pulls our fixes. Once that happens, I'll rebase
> merge_window one more time and start pulling it into linux-next / ALL
> branches.

	I would think that merge_window should live atop our latest at
all times, including 'fixes'.

Joel

-- 

Life's Little Instruction Book #15

	"Own a great stereo system."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
